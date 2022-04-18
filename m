Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F04505D03
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346614AbiDRQzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346651AbiDRQzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B5E34660;
        Mon, 18 Apr 2022 09:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3547B81049;
        Mon, 18 Apr 2022 16:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF07C385B8;
        Mon, 18 Apr 2022 16:51:55 +0000 (UTC)
Subject: [PATCH RFC 07/15] SUNRPC: Refactor rpc_call_null_helper()
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:51:54 -0400
Message-ID: <165030071492.5246.11926309853435664142.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to use RPC_TASK_TLSCRED instead of RPC_TASK_NULLCREDS in one
upcoming case.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/clnt.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 3d3be55205bb..3fb601d8a531 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2734,8 +2734,7 @@ struct rpc_task *rpc_call_null_helper(struct rpc_clnt *clnt,
 		.rpc_op_cred = cred,
 		.callback_ops = ops ?: &rpc_null_ops,
 		.callback_data = data,
-		.flags = flags | RPC_TASK_SOFT | RPC_TASK_SOFTCONN |
-			 RPC_TASK_NULLCREDS,
+		.flags = flags | RPC_TASK_SOFT | RPC_TASK_SOFTCONN,
 	};
 
 	return rpc_run_task(&task_setup_data);
@@ -2743,7 +2742,8 @@ struct rpc_task *rpc_call_null_helper(struct rpc_clnt *clnt,
 
 struct rpc_task *rpc_call_null(struct rpc_clnt *clnt, struct rpc_cred *cred, int flags)
 {
-	return rpc_call_null_helper(clnt, NULL, cred, flags, NULL, NULL);
+	return rpc_call_null_helper(clnt, NULL, cred, flags | RPC_TASK_NULLCREDS,
+				    NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(rpc_call_null);
 
@@ -2821,9 +2821,11 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 		goto success;
 	}
 
-	task = rpc_call_null_helper(clnt, xprt, NULL, RPC_TASK_ASYNC,
-			&rpc_cb_add_xprt_call_ops, data);
+	task = rpc_call_null_helper(clnt, xprt, NULL,
+				    RPC_TASK_ASYNC | RPC_TASK_NULLCREDS,
+				    &rpc_cb_add_xprt_call_ops, data);
 	data->xps->xps_nunique_destaddr_xprts++;
+
 	rpc_put_task(task);
 success:
 	return 1;
@@ -2864,7 +2866,8 @@ int rpc_clnt_setup_test_and_add_xprt(struct rpc_clnt *clnt,
 		goto out_err;
 
 	/* Test the connection */
-	task = rpc_call_null_helper(clnt, xprt, NULL, 0, NULL, NULL);
+	task = rpc_call_null_helper(clnt, xprt, NULL, RPC_TASK_NULLCREDS,
+				    NULL, NULL);
 	if (IS_ERR(task)) {
 		status = PTR_ERR(task);
 		goto out_err;


