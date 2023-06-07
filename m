Return-Path: <netdev+bounces-8935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B67D726580
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C18280D4B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0BA370FC;
	Wed,  7 Jun 2023 16:11:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2943634D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE2CC433EF;
	Wed,  7 Jun 2023 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686154266;
	bh=dPe6xwsaMvNULvoHtwGUabGflzSWiVqBB2vfJFXm3bo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XwuD2OsL7ti/KNJh0Lxp+TNo8aOqHbfHOvbnFBs4PY/cf2mD9PUoz1J9ktgvpNTl+
	 5u107lNzo+Y/4DgisH+hb3QFlHs8Lo9JIHkmXo9OVME2JoyDo995FzYy3xZpf2OMQ2
	 lX6AoWh4apOv5j0GTi++33k8KVUdshMVio2BxzBp7LMPFkJVrpSYUOalOZBycbNkYZ
	 7GQttwqymAqyiGHEYFtH5p4R7v/hm1mo6H03AdWARwpH+JPkd05dVYStjecS8tTD4b
	 kjjS6by0CghgTosszZOgCtZYxdDjD3YW0LSfY5pOZaEFYti9PyRmjR2DVpZFCQVpx2
	 iomtr5SmEkARQ==
Message-ID: <bdb865d4-57c8-34c6-21a4-e631555fc41d@kernel.org>
Date: Wed, 7 Jun 2023 10:11:04 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net] ping6: Fix send to link-local addresses with VRF.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
 Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
References: <6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <6c8b53108816a8d0d5705ae37bdc5a8322b5e3d9.1686153846.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/7/23 10:05 AM, Guillaume Nault wrote:
> Ping sockets can't send packets when they're bound to a VRF master
> device and the output interface is set to a slave device.
> 
> For example, when net.ipv4.ping_group_range is properly set, so that
> ping6 can use ping sockets, the following kind of commands fails:
>   $ ip vrf exec red ping6 fe80::854:e7ff:fe88:4bf1%eth1
> 
> What happens is that sk->sk_bound_dev_if is set to the VRF master
> device, but 'oif' is set to the real output device. Since both are set
> but different, ping_v6_sendmsg() sees their value as inconsistent and
> fails.
> 
> Fix this by allowing 'oif' to be a slave device of ->sk_bound_dev_if.
> 
> This fixes the following kselftest failure:
>   $ ./fcnal-test.sh -t ipv6_ping
>   [...]
>   TEST: ping out, vrf device+address bind - ns-B IPv6 LLA        [FAIL]

Thank you for resolving that one.

> 
> Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
> Closes: https://lore.kernel.org/netdev/b6191f90-ffca-dbca-7d06-88a9788def9c@alu.unizg.hr/
> Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
> Fixes: 5e457896986e ("net: ipv6: Fix ping to link-local addresses.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv6/ping.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index c4835dbdfcff..f804c11e2146 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -114,7 +114,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  	addr_type = ipv6_addr_type(daddr);
>  	if ((__ipv6_addr_needs_scope_id(addr_type) && !oif) ||
>  	    (addr_type & IPV6_ADDR_MAPPED) ||
> -	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if))
> +	    (oif && sk->sk_bound_dev_if && oif != sk->sk_bound_dev_if &&
> +	     l3mdev_master_ifindex_by_index(sock_net(sk), oif) != sk->sk_bound_dev_if))
>  		return -EINVAL;
>  
>  	ipcm6_init_sk(&ipc6, np);

Reviewed-by: David Ahern <dsahern@kernel.org>


