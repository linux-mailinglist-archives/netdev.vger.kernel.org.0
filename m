Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177D56144E2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKAHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAHIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:08:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8121181D
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 00:08:18 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N1h1p6GWbz15MD6;
        Tue,  1 Nov 2022 15:08:14 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 15:08:16 +0800
Subject: Re: [RFC] bhash2 and WARN_ON() for inconsistent sk saddr.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuni1840@gmail.com>, <netdev@vger.kernel.org>
References: <20221029001249.86337-1-kuniyu@amazon.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <4bd122d2-d606-b71e-dbe7-63fa293f0a73@huawei.com>
Date:   Tue, 1 Nov 2022 15:08:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20221029001249.86337-1-kuniyu@amazon.com>
Content-Type: multipart/mixed;
        boundary="------------1D573F848E0B75F2BB2E5409"
Content-Language: en-US
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------1D573F848E0B75F2BB2E5409
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit

Hello Kuniyuki Iwashima,

> Hi,
> 
> I want to discuss bhash2 and WARN_ON() being fired every day this month
> on my syzkaller instance without repro.
> 
>   WARNING: CPU: 0 PID: 209 at net/ipv4/inet_connection_sock.c:548 inet_csk_get_port (net/ipv4/inet_connection_sock.c:548 (discriminator 1))
>   ...
>   inet_csk_listen_start (net/ipv4/inet_connection_sock.c:1205)
>   inet_listen (net/ipv4/af_inet.c:228)
>   __sys_listen (net/socket.c:1810)
>   __x64_sys_listen (net/socket.c:1819 net/socket.c:1817 net/socket.c:1817)
>   do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
>   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> 
> For the very first implementation of bhash2, there was a similar report
> hitting the same WARN_ON().  The fix was to update the bhash2 bucket when
> the kernel changes sk->sk_rcv_saddr from INADDR_ANY.  Then, syzbot has a
> repro, so we can indeed confirm that it no longer triggers the warning on
> the latest kernel.
> 
>   https://lore.kernel.org/netdev/0000000000003f33bc05dfaf44fe@google.com/
> 
> However, Mat reported at that time that there were at least two variants,
> the latter being the same as mine.
> 
>   https://lore.kernel.org/netdev/4bae9df4-42c1-85c3-d350-119a151d29@linux.intel.com/
>   https://lore.kernel.org/netdev/23d8e9f4-016-7de1-9737-12c3146872ca@linux.intel.com/
> 
> This week I started looking into this issue and finally figured out
> why we could not catch all cases with a single repro.
> 

Provide another C repro for analysis. See the attachment.

> 
> Now, I'm thinking bhash2 bucket needs a refcnt not to be freed while
> refcnt is greater than 1.  And we need to change the conflict logic
> so that the kernel ignores empty bhash2 bucket.  Such changes could
> be big for the net tree, but the next LTS will likely be v6.1 which
> has bhash2.
> 
> What do you think is the best way to fix the issue?
> 
> Thank you.
> 
> 
> ---8<---
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index 713b7b8dad7e..40640c26680e 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -157,6 +157,8 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * This unhashes the socket and releases the local port, if necessary.
>  	 */
>  	dccp_set_state(sk, DCCP_CLOSED);
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +		inet_reset_saddr(sk);
>  	ip_rt_put(rt);
>  	sk->sk_route_caps = 0;
>  	inet->inet_dport = 0;
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index e57b43006074..626166cb6d7e 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -985,6 +985,8 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  late_failure:
>  	dccp_set_state(sk, DCCP_CLOSED);
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +		inet_reset_saddr(sk);
>  	__sk_dst_reset(sk);
>  failure:
>  	inet->inet_dport = 0;
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7a250ef9d1b7..834245da1e95 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -343,6 +343,8 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	 * if necessary.
>  	 */
>  	tcp_set_state(sk, TCP_CLOSE);
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +		inet_reset_saddr(sk);
>  	ip_rt_put(rt);
>  	sk->sk_route_caps = 0;
>  	inet->inet_dport = 0;
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2a3f9296df1e..81b396e5cf79 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -359,6 +359,8 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  
>  late_failure:
>  	tcp_set_state(sk, TCP_CLOSE);
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +		inet_reset_saddr(sk);
>  failure:
>  	inet->inet_dport = 0;
>  	sk->sk_route_caps = 0;
> ---8<---
> .
> 

--------------1D573F848E0B75F2BB2E5409
Content-Type: text/plain; charset="UTF-8"; name="warning_on_for_bhash2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="warning_on_for_bhash2.c"

#define _GNU_SOURCE 

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
				intptr_t res = 0;
	res = syscall(__NR_socket, 0xaul, 1ul, 0);
	if (res != -1)
		r[0] = res;
*(uint16_t*)0x20000000 = 0xa;
*(uint16_t*)0x20000002 = htobe16(0x4e22);
*(uint32_t*)0x20000004 = htobe32(0);
memset((void*)0x20000008, 0, 16);
*(uint32_t*)0x20000018 = 0;
	syscall(__NR_bind, r[0], 0x20000000ul, 0x1cul);
*(uint16_t*)0x200000c0 = 0xa;
*(uint16_t*)0x200000c2 = htobe16(0x4e24);
*(uint32_t*)0x200000c4 = htobe32(0x285);
memset((void*)0x200000c8, 0, 16);
*(uint32_t*)0x200000d8 = 3;
	syscall(__NR_connect, r[0], 0x200000c0ul, 0x1cul);
	syscall(__NR_listen, r[0], 0);
	return 0;
}
--------------1D573F848E0B75F2BB2E5409--
