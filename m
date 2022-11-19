Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B26630F28
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 15:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiKSO16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 09:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSO15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 09:27:57 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C956A84818
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 06:27:56 -0800 (PST)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AJERsNJ007758;
        Sat, 19 Nov 2022 23:27:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Sat, 19 Nov 2022 23:27:54 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AJERsTw007755
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 19 Nov 2022 23:27:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
Date:   Sat, 19 Nov 2022 23:27:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
In-Reply-To: <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/19 22:52, Tetsuo Handa wrote:
> On 2022/11/19 22:03, Jakub Sitnicki wrote:
>> When holding a reader-writer spin lock we cannot sleep. Calling
>> setup_udp_tunnel_sock() with write lock held violates this rule, because we
>> end up calling percpu_down_read(), which might sleep, as syzbot reports
>> [1]:
>>
>>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
>>  percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
>>  cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
>>  static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
>>  udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
>>  setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
>>  l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
>>  pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
>>
>> Trim the writer-side critical section for sk_callback_lock down to the
>> minimum, so that it covers only operations on sk_user_data.
> 
> This patch does not look correct.
> 
> Since l2tp_validate_socket() checks that sk->sk_user_data == NULL with
> sk->sk_callback_lock held, you need to call rcu_assign_sk_user_data(sk, tunnel)
> before releasing sk->sk_callback_lock.
> 

Is it safe to temporarily set a dummy pointer like below?
If it is not safe, what makes assignments done by setup_udp_tunnel_sock() safe?

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 754fdda8a5f5..198d38d8fceb 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1474,11 +1474,12 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
-	write_lock(&sk->sk_callback_lock);
-
+	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
 	if (ret < 0)
 		goto err_sock;
+	rcu_assign_sk_user_data(sk, (void *) 1);
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
@@ -1492,6 +1493,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
 			sock_put(sk);
 			ret = -EEXIST;
+			write_lock_bh(&sk->sk_callback_lock);
+			rcu_assign_sk_user_data(sk, NULL);
 			goto err_sock;
 		}
 	}
@@ -1522,16 +1525,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
-	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
+	write_unlock_bh(&sk->sk_callback_lock);
+
 	if (tunnel->fd < 0)
 		sock_release(sock);
 	else
 		sockfd_put(sock);
-
-	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }

