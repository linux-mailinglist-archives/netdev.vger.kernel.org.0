Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16B0485325
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiAENB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:01:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:44172 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiAENBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:01:55 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n55vC-0000E1-9Z; Wed, 05 Jan 2022 14:01:42 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n55vB-000GBK-Rr; Wed, 05 Jan 2022 14:01:41 +0100
Subject: Re: [PATCH v2 net-next 1/2] net: bpf: handle return value of
 BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
References: <20211230080305.1068950-1-imagedong@tencent.com>
 <20211230080305.1068950-2-imagedong@tencent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5cf64605-7005-ac06-6ee1-18547910697a@iogearbox.net>
Date:   Wed, 5 Jan 2022 14:01:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211230080305.1068950-2-imagedong@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26413/Wed Jan  5 10:23:50 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/21 9:03 AM, menglong8.dong@gmail.com wrote:
[...]
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 44cc25f0bae7..f5fc0432374e 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1209,6 +1209,7 @@ struct proto {
>   	void			(*unhash)(struct sock *sk);
>   	void			(*rehash)(struct sock *sk);
>   	int			(*get_port)(struct sock *sk, unsigned short snum);
> +	void			(*put_port)(struct sock *sk);
>   #ifdef CONFIG_BPF_SYSCALL
>   	int			(*psock_update_sk_prot)(struct sock *sk,
>   							struct sk_psock *psock,
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 5d18d32557d2..8784e72d4b8b 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -531,6 +531,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>   			err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
>   			if (err) {
>   				inet->inet_saddr = inet->inet_rcv_saddr = 0;
> +				if (sk->sk_prot->get_port)
> +					sk->sk_prot->put_port(sk);
>   				goto out_release_sock;
>   			}
>   		}
[...]
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index d1636425654e..ddfc6821e682 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -413,6 +413,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>   			if (err) {
>   				sk->sk_ipv6only = saved_ipv6only;
>   				inet_reset_saddr(sk);
> +				if (sk->sk_prot->get_port)
> +					sk->sk_prot->put_port(sk);
>   				goto out;
>   			}
>   		}

I presume both tests above should test for non-zero sk->sk_prot->put_port
callback given that is what they end up calling when true, no?

Thanks,
Daniel
