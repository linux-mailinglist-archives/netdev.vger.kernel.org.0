Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2987C160390
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgBPKbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:31:46 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:46946 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPKbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:31:46 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01GAVAJA015332;
        Sun, 16 Feb 2020 02:31:11 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        borisp@mellanox.com
Cc:     aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net v3] net/tls: Fix to avoid gettig invalid tls record
Date:   Sun, 16 Feb 2020 16:01:08 +0530
Message-Id: <20200216103108.14034-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code doesn't check if tcp sequence number is starting from (/after)
1st record's start sequnce number. It only checks if seq number is before
1st record's end sequnce number. This problem will always be a possibility
in re-transmit case. If a record which belongs to a requested seq number is
already deleted, tls_get_record will start looking into list and as per the
check it will look if seq number is before the end seq of 1st record, which
will always be true and will return 1st record always, it should in fact
return NULL.
As part of the fix, start looking each record only if the sequence number
lies in the list else return NULL.
There is one more check added, driver look for the start marker record to
handle tcp packets which are before the tls offload start sequence number,
hence return 1st record if the record is tls start marker and seq number is
before the 1st record's starting sequence number.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cd91ad812291..00a26e66d361 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -592,7 +592,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 				       u32 seq, u64 *p_record_sn)
 {
 	u64 record_sn = context->hint_record_sn;
-	struct tls_record_info *info;
+	struct tls_record_info *info, *last;
 
 	info = context->retransmit_hint;
 	if (!info ||
@@ -604,6 +604,25 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 						struct tls_record_info, list);
 		if (!info)
 			return NULL;
+		/* send the start_marker record if seq number is before the
+		 * tls offload start marker sequence number. This record is
+		 * required to handle TCP packets which are before TLS offload
+		 * started.
+		 *  And if it's not start marker, look if this seq number
+		 * belongs to the list.
+		 */
+		if (likely(!tls_record_is_start_marker(info))) {
+			/* we have the first record, get the last record to see
+			 * if this seq number belongs to the list.
+			 */
+			last = list_last_entry(&context->records_list,
+					       struct tls_record_info, list);
+			WARN_ON(!last);
+
+			if (!between(seq, tls_record_start_seq(info),
+				     last->end_seq))
+				return NULL;
+		}
 		record_sn = context->unacked_record_sn;
 	}
 
-- 
2.25.0.191.gde93cc1

