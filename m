Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FA5630E00
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKSKIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 05:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSKIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 05:08:47 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839E31DF25
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 02:08:41 -0800 (PST)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AJA8cgO062116;
        Sat, 19 Nov 2022 19:08:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Sat, 19 Nov 2022 19:08:38 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AJA8cmr062112
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 19 Nov 2022 19:08:38 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c4685015-ee4f-598c-0e2f-70e0737f4685@I-love.SAKURA.ne.jp>
Date:   Sat, 19 Nov 2022 19:08:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Content-Language: en-US
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
 <87zgconn3g.fsf@cloudflare.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <87zgconn3g.fsf@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/19 2:50, Jakub Sitnicki wrote:
> Thanks for the patch, Tetsuo.
> 
> As Eric has pointed out [1], there is another problem - in addition to
> sleeping in atomic context, I have also failed to use the write_lock
> variant which disabled BH locally.
> 
> The latter bug can lead to dead-locks, as reported by syzcaller [2, 3],
> because we grab sk_callback_lock in softirq context, which can then
> block waiting on us if:

Below is another approach I was thinking of, for reusing existing locks is prone
to locking bugs like [2] and [3].

I couldn't interpret "Write-protected by @sk_callback_lock." part because
it does not say what lock is needed for protecting sk_user_data for read access.

Is it possible to use a mutex dedicated for l2tp_tunnel_destruct() (and optionally
setup_udp_tunnel_sock_no_enable() in order not to create l2tp_tunnel_register_mutex =>
cpu_hotplug_lock chain) ?

By the way I haven't heard an response on

  Since userspace-supplied file descriptor has to be a datagram socket,
  can we somehow copy the source/destination addresses from
  userspace-supplied socket to kernel-created socket?

at https://lkml.kernel.org/r/c9695548-3f27-dda1-3124-ec21da106741@I-love.SAKURA.ne.jp
(that is, always create a new socket in order to be able to assign lockdep class
before that socket is used).

diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..49473013afa6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -323,7 +323,7 @@ struct sk_filter;
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
   *	@sk_socket: Identd and reporting IO signals
-  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
+  *	@sk_user_data: RPC layer private data.
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..2bfcf6968d89 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1150,10 +1150,8 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	}
 
 	/* Remove hooks into tunnel socket */
-	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
-	write_unlock_bh(&sk->sk_callback_lock);
 
 	/* Call the original destructor */
 	if (sk->sk_destruct)
@@ -1455,6 +1453,7 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg)
 {
+	static DEFINE_MUTEX(l2tp_tunnel_register_mutex);
 	struct l2tp_tunnel *tunnel_walk;
 	struct l2tp_net *pn;
 	struct socket *sock;
@@ -1474,7 +1473,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
+	mutex_lock(&l2tp_tunnel_register_mutex);
 
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
@@ -1519,19 +1518,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	trace_register_tunnel(tunnel);
 
+	mutex_unlock(&l2tp_tunnel_register_mutex);
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
+	mutex_unlock(&l2tp_tunnel_register_mutex);
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }

