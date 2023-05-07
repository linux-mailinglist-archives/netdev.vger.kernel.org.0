Return-Path: <netdev+bounces-748-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A50B6F97FA
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 11:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A8E31C21A5F
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 09:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DD023BC;
	Sun,  7 May 2023 09:18:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC72C7C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 09:18:43 +0000 (UTC)
X-Greylist: delayed 381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 07 May 2023 02:18:40 PDT
Received: from mail-m127104.qiye.163.com (mail-m127104.qiye.163.com [115.236.127.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA0A100E8;
	Sun,  7 May 2023 02:18:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:3277:3e50:d9d7:3dc:49c3:c0bf])
	by mail-m127104.qiye.163.com (Hmail) with ESMTPA id 36F23A4010E;
	Sun,  7 May 2023 17:12:14 +0800 (CST)
From: Ding Hui <dinghui@sangfor.com.cn>
To: chuck.lever@oracle.com,
	jlayton@kernel.org,
	trond.myklebust@hammerspace.com,
	anna@kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	bfields@redhat.com,
	linux-nfs@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dinghui@sangfor.com.cn
Subject: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Date: Sun,  7 May 2023 17:11:31 +0800
Message-Id: <20230507091131.23540-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSB5LVh1MHkNLSE0aSx9PT1UTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTExBSB5OS0EfQh9MQUgfGEFPQhhIQRhLGR1ZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a87f57ba7f5b282kuuu36f23a4010e
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQg6HAw*DD0KCTErOhU*OAwu
	LDJPCwxVSlVKTUNIT05LTEhOS0xCVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUxMQUgeTktBH0IfTEFIHxhBT0IYSEEYSxkdWVdZCAFZQU1LTEM3Bg++
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

After the listener svc_sock freed, and before invoking svc_tcp_accept()
for the established child sock, there is a window that the newsock
retaining a freed listener svc_sock in sk_user_data which cloning from
parent. In the race windows if data is received on the newsock, we will
observe use-after-free report in svc_tcp_listen_data_ready().

Reproduce by two tasks:

1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done

KASAN report:

  ==================================================================
  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
  Read of size 8 at addr ffff888139d96228 by task nc/102553
  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x33/0x50
   print_address_description.constprop.0+0x27/0x310
   print_report+0x3e/0x70
   kasan_report+0xae/0xe0
   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
   tcp_data_queue+0x9f4/0x20e0
   tcp_rcv_established+0x666/0x1f60
   tcp_v4_do_rcv+0x51c/0x850
   tcp_v4_rcv+0x23fc/0x2e80
   ip_protocol_deliver_rcu+0x62/0x300
   ip_local_deliver_finish+0x267/0x350
   ip_local_deliver+0x18b/0x2d0
   ip_rcv+0x2fb/0x370
   __netif_receive_skb_one_core+0x166/0x1b0
   process_backlog+0x24c/0x5e0
   __napi_poll+0xa2/0x500
   net_rx_action+0x854/0xc90
   __do_softirq+0x1bb/0x5de
   do_softirq+0xcb/0x100
   </IRQ>
   <TASK>
   ...
   </TASK>

  Allocated by task 102371:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   __kasan_kmalloc+0x7b/0x90
   svc_setup_socket+0x52/0x4f0 [sunrpc]
   svc_addsock+0x20d/0x400 [sunrpc]
   __write_ports_addfd+0x209/0x390 [nfsd]
   write_ports+0x239/0x2c0 [nfsd]
   nfsctl_transaction_write+0xac/0x110 [nfsd]
   vfs_write+0x1c3/0xae0
   ksys_write+0xed/0x1c0
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

  Freed by task 102551:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   kasan_save_free_info+0x2a/0x50
   __kasan_slab_free+0x106/0x190
   __kmem_cache_free+0x133/0x270
   svc_xprt_free+0x1e2/0x350 [sunrpc]
   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
   nfsd_put+0x125/0x240 [nfsd]
   nfsd_svc+0x2cb/0x3c0 [nfsd]
   write_threads+0x1ac/0x2a0 [nfsd]
   nfsctl_transaction_write+0xac/0x110 [nfsd]
   vfs_write+0x1c3/0xae0
   ksys_write+0xed/0x1c0
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

In this RFC patch, I try to fix the UAF by skipping dereferencing
svsk for all child socket in svc_tcp_listen_data_ready(), it is
easy to backport for stable.

However I'm not sure if there are other potential risks in the race
window, so I thought another fix which depends on SK_USER_DATA_NOCOPY
introduced in commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data
pointer on clone if tagged").

Saving svsk into sk_user_data with SK_USER_DATA_NOCOPY tag in
svc_setup_socket() like this:

  __rcu_assign_sk_user_data_with_flags(inet, svsk, SK_USER_DATA_NOCOPY);

Obtaining svsk in callbacks like this:

  struct svc_sock *svsk = rcu_dereference_sk_user_data(sk);

This will avoid copying sk_user_data for sunrpc svc_sock in
sk_clone_lock(), so the sk_user_data of child sock before accepted
will be NULL.

Appreciate any comment and suggestion, thanks.

Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead of open coding")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 net/sunrpc/svcsock.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index a51c9b989d58..9aca6e1e78e4 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock *sk)
 
 	trace_sk_data_ready(sk);
 
-	if (svsk) {
-		/* Refer to svc_setup_socket() for details. */
-		rmb();
-		svsk->sk_odata(sk);
-	}
-
 	/*
 	 * This callback may called twice when a new connection
 	 * is established as a child socket inherits everything
@@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock *sk)
 	 *    when one of child sockets become ESTABLISHED.
 	 * 2) data_ready method of the child socket may be called
 	 *    when it receives data before the socket is accepted.
-	 * In case of 2, we should ignore it silently.
+	 * In case of 2, we should ignore it silently and DO NOT
+	 * dereference svsk.
 	 */
-	if (sk->sk_state == TCP_LISTEN) {
-		if (svsk) {
-			set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
-			svc_xprt_enqueue(&svsk->sk_xprt);
-		}
+	if (sk->sk_state != TCP_LISTEN)
+		return;
+
+	if (svsk) {
+		/* Refer to svc_setup_socket() for details. */
+		rmb();
+		svsk->sk_odata(sk);
+		set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
+		svc_xprt_enqueue(&svsk->sk_xprt);
 	}
 }
 
-- 
2.17.1


