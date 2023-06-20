Return-Path: <netdev+bounces-12095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F08736155
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:00:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 117AA1C20880
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DC71119;
	Tue, 20 Jun 2023 02:00:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5F010E3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D300C433C8;
	Tue, 20 Jun 2023 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687226409;
	bh=q991Df6lElczcQfXTZH5AJGFVHbnOIKkuwwRkFJopok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bkkf5QRDS1XkG0z/mmLqUfLjSW2LOWrMQdW2D7mXxEDcgkaWkYEnCI3MpgJ7bksDa
	 yF+0Pq9gplP94mSjFQ+lNBsb9a8cG4IvRW+F8LWiwIW3yi5odKhSIfk7Zo+pwM3VeB
	 ADgR6RL6hEhxDyaaNOhSz6q98aR00gFrRy+0uSR0GXAygMyYJavRuY6DJabpCQjyab
	 5dBRywIdOcFPnAtM+cm9P8GgKcANbCmVG3GeSYF5RdfwTJswJyGkZ/j7ZgSH2wT1pD
	 uYvkb91Gu8883KZZyE3ISjXeMGzhhi1E1mQugsdTIx9sJJwBGwrTX92JK+3lFwrwzY
	 pfimmOJ5BtQQA==
Message-ID: <483161ce-f36b-a0d8-0239-6c68ea34e92f@kernel.org>
Date: Mon, 19 Jun 2023 19:00:08 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: remove sk_is_ipmr() and sk_is_icmpv6()
 helpers
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
 syzbot <syzkaller@googlegroups.com>, Breno Leitao <leitao@debian.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>
References: <20230619124336.651528-1-edumazet@google.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230619124336.651528-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/23 5:43 AM, Eric Dumazet wrote:
> Blamed commit added these helpers for sake of detecting RAW
> sockets specific ioctl.
> 
> syzbot complained about it [1].
> 
> Issue here is that RAW sockets could pretend there was no need
> to call ipmr_sk_ioctl()
> 
> Regardless of inet_sk(sk)->inet_num, we must be prepared
> for ipmr_ioctl() being called later. This must happen
> from ipmr_sk_ioctl() context only.
> 
> We could add a safety check in ipmr_ioctl() at the risk of breaking
> applications.
> 
> Instead, remove sk_is_ipmr() and sk_is_icmpv6() because their
> name would be misleading, once we change their implementation.
> 
> [1]
> BUG: KASAN: stack-out-of-bounds in ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
> Read of size 4 at addr ffffc90003aefae4 by task syz-executor105/5004
> 
> CPU: 0 PID: 5004 Comm: syz-executor105 Not tainted 6.4.0-rc6-syzkaller-01304-gc08afcdcf952 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
> print_report mm/kasan/report.c:462 [inline]
> kasan_report+0x11c/0x130 mm/kasan/report.c:572
> ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
> raw_ioctl+0x4e/0x1e0 net/ipv4/raw.c:881
> sock_ioctl_out net/core/sock.c:4186 [inline]
> sk_ioctl+0x151/0x440 net/core/sock.c:4214
> inet_ioctl+0x18c/0x380 net/ipv4/af_inet.c:1001
> sock_do_ioctl+0xcc/0x230 net/socket.c:1189
> sock_ioctl+0x1f8/0x680 net/socket.c:1306
> vfs_ioctl fs/ioctl.c:51 [inline]
> __do_sys_ioctl fs/ioctl.c:870 [inline]
> __se_sys_ioctl fs/ioctl.c:856 [inline]
> __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f2944bf6ad9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd8897a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2944bf6ad9
> RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
> RBP: 00007f2944bbac80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2944bbad10
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> </TASK>
> 
> The buggy address belongs to stack of task syz-executor105/5004
> and is located at offset 36 in frame:
> sk_ioctl+0x0/0x440 net/core/sock.c:4172
> 
> This frame has 2 objects:
> [32, 36) 'karg'
> [48, 88) 'buffer'
> 
> Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl callbacks")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/linux/icmpv6.h |  6 ------
>  include/linux/mroute.h | 11 -----------
>  net/core/sock.c        |  4 ++--
>  3 files changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
> index 1fe33e6741cca2685082da214afbc94c7974f4ce..db0f4fcfdaf4f138d75dc6c4073cb286364f2923 100644
> --- a/include/linux/icmpv6.h
> +++ b/include/linux/icmpv6.h
> @@ -111,10 +111,4 @@ static inline bool icmpv6_is_err(int type)
>  	return false;
>  }
>  
> -static inline int sk_is_icmpv6(struct sock *sk)
> -{
> -	return sk->sk_family == AF_INET6 &&
> -		inet_sk(sk)->inet_num == IPPROTO_ICMPV6;
> -}
> -
>  #endif
> diff --git a/include/linux/mroute.h b/include/linux/mroute.h
> index 94c6e6f549f0a503f6707d1175f1c47a0f0cd887..4c5003afee6c51962bc13879978845bc7daf08fa 100644
> --- a/include/linux/mroute.h
> +++ b/include/linux/mroute.h
> @@ -16,12 +16,6 @@ static inline int ip_mroute_opt(int opt)
>  	return opt >= MRT_BASE && opt <= MRT_MAX;
>  }
>  
> -static inline int sk_is_ipmr(struct sock *sk)
> -{
> -	return sk->sk_family == AF_INET &&
> -		inet_sk(sk)->inet_num == IPPROTO_IGMP;
> -}
> -
>  int ip_mroute_setsockopt(struct sock *, int, sockptr_t, unsigned int);
>  int ip_mroute_getsockopt(struct sock *, int, sockptr_t, sockptr_t);
>  int ipmr_ioctl(struct sock *sk, int cmd, void *arg);
> @@ -57,11 +51,6 @@ static inline int ip_mroute_opt(int opt)
>  	return 0;
>  }
>  
> -static inline int sk_is_ipmr(struct sock *sk)
> -{
> -	return 0;
> -}
> -
>  static inline bool ipmr_rule_default(const struct fib_rule *rule)
>  {
>  	return true;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index cff3e82514d17513bc96300dc18014083a0d7ea7..8ec8f4c9911f2a6dd3dd946798d512394d62a861 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -4199,9 +4199,9 @@ int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
>  {
>  	int rc = 1;
>  
> -	if (sk_is_ipmr(sk))
> +	if (sk->sk_type == SOCK_RAW && sk->sk_family == AF_INET)
>  		rc = ipmr_sk_ioctl(sk, cmd, arg);
> -	else if (sk_is_icmpv6(sk))
> +	else if (sk->sk_type == SOCK_RAW && sk->sk_family == AF_INET6)
>  		rc = ip6mr_sk_ioctl(sk, cmd, arg);
>  	else if (sk_is_phonet(sk))
>  		rc = phonet_sk_ioctl(sk, cmd, arg);

I was staring at the type when reviewing the original patch; I was
expecting to see RAW based on where ipmr_ioctl (and v6 version) is
called. That's why I asked about the testing of the patch, so I am not
surprised by this followup.

Reviewed-by: David Ahern <dsahern@kernel.org>



