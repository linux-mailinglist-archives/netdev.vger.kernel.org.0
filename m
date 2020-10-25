Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F49298368
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418605AbgJYTnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:43:53 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:34174 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1418597AbgJYTnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:43:53 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09PJhmTp029574;
        Sun, 25 Oct 2020 12:43:48 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net] chelsio/chtls: fix memory leaks in CPL handlers
Date:   Mon, 26 Oct 2020 01:12:29 +0530
Message-Id: <20201025194228.31271-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPL handler functions chtls_pass_open_rpl() and
chtls_close_listsrv_rpl() should return CPL_RET_BUF_DONE
so that caller function will do skb free to avoid leak.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 5c3242ec0e10..d128fc860c6f 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -772,14 +772,13 @@ static int chtls_pass_open_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	if (rpl->status != CPL_ERR_NONE) {
 		pr_info("Unexpected PASS_OPEN_RPL status %u for STID %u\n",
 			rpl->status, stid);
-		return CPL_RET_BUF_DONE;
+	} else {
+		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
+		sock_put(listen_ctx->lsk);
+		kfree(listen_ctx);
+		module_put(THIS_MODULE);
 	}
-	cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
-	sock_put(listen_ctx->lsk);
-	kfree(listen_ctx);
-	module_put(THIS_MODULE);
-
-	return 0;
+	return CPL_RET_BUF_DONE;
 }
 
 static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
@@ -796,15 +795,13 @@ static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	if (rpl->status != CPL_ERR_NONE) {
 		pr_info("Unexpected CLOSE_LISTSRV_RPL status %u for STID %u\n",
 			rpl->status, stid);
-		return CPL_RET_BUF_DONE;
+	} else {
+		cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
+		sock_put(listen_ctx->lsk);
+		kfree(listen_ctx);
+		module_put(THIS_MODULE);
 	}
-
-	cxgb4_free_stid(cdev->tids, stid, listen_ctx->lsk->sk_family);
-	sock_put(listen_ctx->lsk);
-	kfree(listen_ctx);
-	module_put(THIS_MODULE);
-
-	return 0;
+	return CPL_RET_BUF_DONE;
 }
 
 static void chtls_purge_wr_queue(struct sock *sk)
-- 
2.18.1

