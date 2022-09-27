Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C5C5EC370
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiI0NAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiI0NA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:00:29 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B001992F6B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:00:23 -0700 (PDT)
Received: from fsav111.sakura.ne.jp (fsav111.sakura.ne.jp [27.133.134.238])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28RD0LkG002932;
        Tue, 27 Sep 2022 22:00:21 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav111.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp);
 Tue, 27 Sep 2022 22:00:21 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav111.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28RD0L7B002924
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 27 Sep 2022 22:00:21 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c9695548-3f27-dda1-3124-ec21da106741@I-love.SAKURA.ne.jp>
Date:   Tue, 27 Sep 2022 22:00:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: WARNING: locking bug in inet_autobind
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
References: <00000000000033a0120588fac894@google.com>
 <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
 <YydimPlesKO+4QKG@boqun-archlinux>
 <f1567517-5614-2b2a-b42d-4c26433de3b2@I-love.SAKURA.ne.jp>
In-Reply-To: <f1567517-5614-2b2a-b42d-4c26433de3b2@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/09/19 14:02, Tetsuo Handa wrote:
> But unfortunately reordering
> 
>   tunnel->sock = sk;
>   ...
>   lockdep_set_class_and_name(&sk->sk_lock.slock,...);
> 
> by
> 
>   lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock");
>   smp_store_release(&tunnel->sock, sk);
> 
> does not help, for connect() on AF_INET6 socket is not finding this "sk" by
> accessing tunnel->sock.
> 

I considered something like below diff, but I came to think that this problem
cannot be solved unless l2tp_tunnel_register() stops using userspace-supplied
file descriptor and starts always calling l2tp_tunnel_sock_create(), for
userspace can continue using userspace-supplied file descriptor as if a normal
socket even after lockdep_set_class_and_name() told that this is a tunneling
socket.

Since userspace-supplied file descriptor has to be a datagram socket,
can we somehow copy the source/destination addresses from
userspace-supplied socket to kernel-created socket?


diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..07429bed7c4c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1382,8 +1382,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
 	return err;
 }
 
-static struct lock_class_key l2tp_socket_class;
-
 int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
@@ -1509,8 +1507,20 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
-	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-				   "l2tp_sock");
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		static struct lock_class_key l2tp_socket_class;
+
+		/* Changing class/name of an already visible sock might race
+		 * with first lock_sock() call on that sock. In order to make
+		 * sure that register_lock_class() has completed before
+		 * lockdep_set_class_and_name() changes class/name, explicitly
+		 * lock/release that sock.
+		 */
+		lock_sock(sk);
+		release_sock(sk);
+		lockdep_set_class_and_name(&sk->sk_lock.slock,
+					   &l2tp_socket_class, "l2tp_sock");
+	}
 	sk->sk_allocation = GFP_ATOMIC;
 
 	trace_register_tunnel(tunnel);

