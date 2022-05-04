Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1D5196B1
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 07:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344654AbiEDFCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 01:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344676AbiEDFCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 01:02:48 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC91B2DD71
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 21:59:03 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2444wVIE094267;
        Wed, 4 May 2022 13:58:31 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Wed, 04 May 2022 13:58:31 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2444wU4G094260
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 4 May 2022 13:58:31 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
Date:   Wed, 4 May 2022 13:58:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/04 12:09, Eric Dumazet wrote:
>> Does maybe_get_net() help?
>>
>> Since rds_conn_net() returns a net namespace without holding a ref, it is theoretically
>> possible that the net namespace returned by rds_conn_net() is already kmem_cache_free()d
>> if refcount dropped to 0 by the moment sk_alloc() calls sock_net_set().
> 
> Nope. RDS has an exit() handler called from cleanup_net()
> 
> (struct pernet_operations)->exit() or exit_batch() :
> rds_tcp_exit_net() (rds_tcp_kill_sock())

Hmm, when put_net() called __put_net(), this "struct net" is chained to cleanup_list.
When cleanup_net() is called via net_cleanup_work, rds_tcp_exit_net() is called from
ops_exit_list(). Therefore, we can call maybe_get_net() until rds_tcp_exit_net() returns.
That's good.

> 
> This exit() handler _has_ to remove all known listeners, and
> definitely cancel work queues (synchronous operation)
> before the actual "struct net" free can happen later.

But in your report, rds_tcp_tune() is called from rds_tcp_conn_path_connect() from
rds_connect_worker() via "struct rds_connection"->cp_conn_w work. I can see that
rds_tcp_kill_sock() calls rds_tcp_listen_stop(lsock, &rtn->rds_tcp_accept_w), and
rds_tcp_listen_stop() calls flush_workqueue(rds_wq) and flush_work(&rtn->rds_tcp_accept_w).

But I can't see how rds_tcp_exit_net() synchronously cancels all works associated
with "struct rds_conn_path".

struct rds_conn_path {
        struct delayed_work     cp_send_w;
        struct delayed_work     cp_recv_w;
        struct delayed_work     cp_conn_w;
        struct work_struct      cp_down_w;
}

These works are queued to rds_wq, but flush_workqueue() waits for completion only
if already queued. What if timer for queue_delayed_work() has not expired, or was
about to call queue_delayed_work() ? Is flush_workqueue(rds_wq) sufficient?

Anyway, if rds_tcp_kill_sock() can somehow guarantee that all works are completed
or cancelled, the fix would look like something below?

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

