Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B995505D26
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346757AbiDRQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346778AbiDRQzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:55:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C09F33A37;
        Mon, 18 Apr 2022 09:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1ED0612EC;
        Mon, 18 Apr 2022 16:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48BEC385A1;
        Mon, 18 Apr 2022 16:52:02 +0000 (UTC)
Subject: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:52:01 -0400
Message-ID: <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
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

Introduce a mechanism to cause xprt_transmit() to break out of its
sending loop at a specific rpc_rqst, rather than draining the whole
transmit queue.

This enables the client to send just an RPC TLS probe and then wait
for the response before proceeding with the rest of the queue.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/sched.h  |    2 ++
 include/trace/events/sunrpc.h |    1 +
 net/sunrpc/xprt.c             |    2 ++
 3 files changed, 5 insertions(+)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 599133fb3c63..f8c09638fa69 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -125,6 +125,7 @@ struct rpc_task_setup {
 #define RPC_TASK_TLSCRED		0x00000008	/* Use AUTH_TLS credential */
 #define RPC_TASK_NULLCREDS		0x00000010	/* Use AUTH_NULL credential */
 #define RPC_CALL_MAJORSEEN		0x00000020	/* major timeout seen */
+#define RPC_TASK_CORK			0x00000040	/* cork the xmit queue */
 #define RPC_TASK_DYNAMIC		0x00000080	/* task was kmalloc'ed */
 #define	RPC_TASK_NO_ROUND_ROBIN		0x00000100	/* send requests on "main" xprt */
 #define RPC_TASK_SOFT			0x00000200	/* Use soft timeouts */
@@ -137,6 +138,7 @@ struct rpc_task_setup {
 
 #define RPC_IS_ASYNC(t)		((t)->tk_flags & RPC_TASK_ASYNC)
 #define RPC_IS_SWAPPER(t)	((t)->tk_flags & RPC_TASK_SWAPPER)
+#define RPC_IS_CORK(t)		((t)->tk_flags & RPC_TASK_CORK)
 #define RPC_IS_SOFT(t)		((t)->tk_flags & (RPC_TASK_SOFT|RPC_TASK_TIMEOUT))
 #define RPC_IS_SOFTCONN(t)	((t)->tk_flags & RPC_TASK_SOFTCONN)
 #define RPC_WAS_SENT(t)		((t)->tk_flags & RPC_TASK_SENT)
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 811187c47ebb..e8d6adff1a50 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -312,6 +312,7 @@ TRACE_EVENT(rpc_request,
 		{ RPC_TASK_TLSCRED, "TLSCRED" },			\
 		{ RPC_TASK_NULLCREDS, "NULLCREDS" },			\
 		{ RPC_CALL_MAJORSEEN, "MAJORSEEN" },			\
+		{ RPC_TASK_CORK, "CORK" },				\
 		{ RPC_TASK_DYNAMIC, "DYNAMIC" },			\
 		{ RPC_TASK_NO_ROUND_ROBIN, "NO_ROUND_ROBIN" },		\
 		{ RPC_TASK_SOFT, "SOFT" },				\
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 86d62cffba0d..4b303b945b51 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1622,6 +1622,8 @@ xprt_transmit(struct rpc_task *task)
 		if (xprt_request_data_received(task) &&
 		    !test_bit(RPC_TASK_NEED_XMIT, &task->tk_runstate))
 			break;
+		if (RPC_IS_CORK(task))
+			break;
 		cond_resched_lock(&xprt->queue_lock);
 	}
 	spin_unlock(&xprt->queue_lock);


