Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13D5387176
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 07:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbhERFyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 01:54:32 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:58233 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241657AbhERFyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 01:54:31 -0400
Received: from heptagon.blr.asicdesigners.com (uefi-pc.asicdesigners.com [10.193.186.108] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 14I5qQxD024924;
        Mon, 17 May 2021 22:52:27 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Cc:     secdev@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] ch_ktls: Remove the checks for u_ctx pointer
Date:   Tue, 18 May 2021 11:21:32 +0530
Message-Id: <20210518055132.9397-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.28.0.rc1.6.gae46588
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The u_ctx pointer in case of ch_ktls will always be valid. As u_ctx is
ch_ktls ctx pointer and remains valid until driver is running.

So removing the u_ctx checks.

Fixes: 65e302a9bd57 ("cxgb4/ch_ktls: Clear resources when pf4 device is removed")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 59683f79959c..82f847cecf90 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -371,7 +371,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 		return;
 
 	u_ctx = tx_info->adap->uld[CXGB4_ULD_KTLS].handle;
-	if (u_ctx && u_ctx->detach)
+	if (u_ctx->detach)
 		return;
 	/* clear l2t entry */
 	if (tx_info->l2te)
@@ -443,7 +443,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (tx_ctx->chcr_info)
 		goto out;
 
-	if (u_ctx && u_ctx->detach)
+	if (u_ctx->detach)
 		goto out;
 
 	tx_info = kvzalloc(sizeof(*tx_info), GFP_KERNEL);
@@ -688,15 +688,13 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 		tls_ctx = tls_get_ctx(tx_info->sk);
 		tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
 		u_ctx = adap->uld[CXGB4_ULD_KTLS].handle;
-		if (u_ctx) {
-			ret = xa_insert_bh(&u_ctx->tid_list, tid, tx_ctx,
-					   GFP_NOWAIT);
-			if (ret < 0) {
-				pr_err("%s: Failed to allocate tid XA entry = %d\n",
-				       __func__, tx_info->tid);
-				tx_info->open_state = CH_KTLS_OPEN_FAILURE;
-				goto out;
-			}
+		ret = xa_insert_bh(&u_ctx->tid_list, tid, tx_ctx,
+				   GFP_NOWAIT);
+		if (ret < 0) {
+			pr_err("%s: Failed to allocate tid XA entry = %d\n",
+			       __func__, tx_info->tid);
+			tx_info->open_state = CH_KTLS_OPEN_FAILURE;
+			goto out;
 		}
 		tx_info->open_state = CH_KTLS_OPEN_SUCCESS;
 	} else {
-- 
2.28.0.rc1.6.gae46588

