Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600D551B4CF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiEEAt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiEEAt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 20:49:57 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0911BE84
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 17:46:19 -0700 (PDT)
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2450joNY018435;
        Thu, 5 May 2022 09:45:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Thu, 05 May 2022 09:45:50 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2450joIS018432
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 5 May 2022 09:45:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp>
Date:   Thu, 5 May 2022 09:45:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH] net: rds: use maybe_get_net() when acquiring refcount on TCP
 sockets
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
 <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
 <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
 <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
 <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp>
In-Reply-To: <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet is reporting addition on 0 problem at rds_tcp_tune(), for
delayed works queued in rds_wq might be invoked after a net namespace's
refcount already reached 0.

Since rds_tcp_exit_net() from cleanup_net() calls flush_workqueue(rds_wq),
it is guaranteed that we can instead use maybe_get_net() from delayed work
functions until rds_tcp_exit_net() returns.

Note that I'm not convinced that all works which might access a net
namespace are already queued in rds_wq by the moment rds_tcp_exit_net()
calls flush_workqueue(rds_wq). If some race is there, rds_tcp_exit_net()
will fail to wait for work functions, and kmem_cache_free() could be
called from net_free() before maybe_get_net() is called from
rds_tcp_tune().

Reported-by: Eric Dumazet <edumazet@google.com>
Fixes: 3a58f13a881ed351 ("net: rds: acquire refcount on TCP sockets")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/rds/tcp.c         | 11 ++++++++---
 net/rds/tcp.h         |  2 +-
 net/rds/tcp_connect.c |  5 ++++-
 net/rds/tcp_listen.c  |  5 ++++-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 2f638f8b7b1e..8e26bcf02044 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -487,11 +487,11 @@ struct rds_tcp_net {
 /* All module specific customizations to the RDS-TCP socket should be done in
  * rds_tcp_tune() and applied after socket creation.
  */
-void rds_tcp_tune(struct socket *sock)
+bool rds_tcp_tune(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
-	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
+	struct rds_tcp_net *rtn;
 
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
@@ -499,10 +499,14 @@ void rds_tcp_tune(struct socket *sock)
 	 * a process which created this net namespace terminated.
 	 */
 	if (!sk->sk_net_refcnt) {
+		if (!maybe_get_net(net)) {
+			release_sock(sk);
+			return false;
+		}
 		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
 		sock_inuse_add(net, 1);
 	}
+	rtn = net_generic(net, rds_tcp_netid);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
@@ -512,6 +516,7 @@ void rds_tcp_tune(struct socket *sock)
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);
+	return true;
 }
 
 static void rds_tcp_accept_worker(struct work_struct *work)
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index dc8d745d6857..f8b5930d7b34 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -49,7 +49,7 @@ struct rds_tcp_statistics {
 };
 
 /* tcp.c */
-void rds_tcp_tune(struct socket *sock);
+bool rds_tcp_tune(struct socket *sock);
 void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_reset_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_restore_callbacks(struct socket *sock,
diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index 5461d77fff4f..f0c477c5d1db 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -124,7 +124,10 @@ int rds_tcp_conn_path_connect(struct rds_conn_path *cp)
 	if (ret < 0)
 		goto out;
 
-	rds_tcp_tune(sock);
+	if (!rds_tcp_tune(sock)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if (isv6) {
 		sin6.sin6_family = AF_INET6;
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 09cadd556d1e..7edf2e69d3fe 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -133,7 +133,10 @@ int rds_tcp_accept_one(struct socket *sock)
 	__module_get(new_sock->ops->owner);
 
 	rds_tcp_keepalive(new_sock);
-	rds_tcp_tune(new_sock);
+	if (!rds_tcp_tune(new_sock)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	inet = inet_sk(new_sock->sk);
 
-- 
2.34.1


