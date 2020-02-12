Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAF15A197
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgBLHQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:16:58 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:28776 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgBLHQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:16:57 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01C7GW00031571;
        Tue, 11 Feb 2020 23:16:54 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net] net/tls: Fix to avoid gettig invalid tls record
Date:   Wed, 12 Feb 2020 12:46:30 +0530
Message-Id: <20200212071630.26650-1-rohitm@chelsio.com>
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

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cd91ad812291..2898517298bf 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -602,7 +602,8 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 		 */
 		info = list_first_entry_or_null(&context->records_list,
 						struct tls_record_info, list);
-		if (!info)
+		/* return NULL if seq number even before the 1st entry. */
+		if (!info || before(seq, info->end_seq - info->len))
 			return NULL;
 		record_sn = context->unacked_record_sn;
 	}
-- 
2.25.0.191.gde93cc1

