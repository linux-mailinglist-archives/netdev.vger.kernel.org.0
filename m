Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF83603B0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhDOHtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:49:00 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:47960 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhDOHs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:48:59 -0400
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13F7mBlx023347;
        Thu, 15 Apr 2021 00:48:31 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net 2/4] ch_ktls: fix device connection close
Date:   Thu, 15 Apr 2021 13:17:46 +0530
Message-Id: <20210415074748.421098-3-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sge queue is full and chcr_ktls_xmit_wr_complete()
returns failure, skb is not freed if it is not the last tls record in
this skb, causes refcount never gets freed and tls_dev_del()
never gets called on this connection.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c  | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index e39fa0940367..a626560f8365 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1735,7 +1735,9 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 				 struct sge_eth_txq *q, u32 skb_offset,
 				 u32 tls_end_offset, bool last_wr)
 {
+	bool free_skb_if_tx_fails = false;
 	struct sk_buff *nskb = NULL;
+
 	/* check if it is a complete record */
 	if (tls_end_offset == record->len) {
 		nskb = skb;
@@ -1758,6 +1760,8 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 
 		if (last_wr)
 			dev_kfree_skb_any(skb);
+		else
+			free_skb_if_tx_fails = true;
 
 		last_wr = true;
 
@@ -1769,6 +1773,8 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 				       record->num_frags,
 				       (last_wr && tcp_push_no_fin),
 				       mss)) {
+		if (free_skb_if_tx_fails)
+			dev_kfree_skb_any(skb);
 		goto out;
 	}
 	tx_info->prev_seq = record->end_seq;
-- 
2.30.2

