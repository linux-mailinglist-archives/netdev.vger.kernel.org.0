Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79702AB277
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgKIIe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:34:26 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:35034 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729762AbgKIIeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:34:25 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A98XwJa010868;
        Mon, 9 Nov 2020 00:34:15 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v5 05/12] ch_ktls: Correction in trimmed_len calculation
Date:   Mon,  9 Nov 2020 14:03:49 +0530
Message-Id: <20201109083356.11117-6-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109083356.11117-1-rohitm@chelsio.com>
References: <20201109083356.11117-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trimmed length calculation goes wrong if skb has only tag part
to send. It should be zero if there is no data bytes apart from
TAG.

Fixes: dc05f3df8fac ("chcr: Handle first or middle part of record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c         | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 950841988ffe..4286decce095 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1729,10 +1729,13 @@ static int chcr_short_record_handler(struct chcr_ktls_info *tx_info,
 
 	if (remaining_record > 0 &&
 	    remaining_record < TLS_CIPHER_AES_GCM_128_TAG_SIZE) {
-		int trimmed_len = data_len -
-			(TLS_CIPHER_AES_GCM_128_TAG_SIZE - remaining_record);
-		/* don't process the pkt if it is only a partial tag */
-		if (data_len < TLS_CIPHER_AES_GCM_128_TAG_SIZE)
+		int trimmed_len = 0;
+
+		if (tls_end_offset > TLS_CIPHER_AES_GCM_128_TAG_SIZE)
+			trimmed_len = data_len -
+				      (TLS_CIPHER_AES_GCM_128_TAG_SIZE -
+				       remaining_record);
+		if (!trimmed_len)
 			goto out;
 
 		WARN_ON(trimmed_len > data_len);
-- 
2.18.1

