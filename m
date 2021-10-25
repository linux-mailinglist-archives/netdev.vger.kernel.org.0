Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EBD439E36
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJYSPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:15:05 -0400
Received: from ink.ssi.bg ([178.16.128.7]:60177 "EHLO ink.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhJYSPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:15:04 -0400
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id DAE5F3C09C0;
        Mon, 25 Oct 2021 21:12:36 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 19PICXia016733;
        Mon, 25 Oct 2021 21:12:35 +0300
Date:   Mon, 25 Oct 2021 21:12:33 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     yangxingwu <xingwu.yang@gmail.com>
cc:     Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] ipvs: Fix reuse connection if RS weight is 0
In-Reply-To: <20211025115910.2595-1-xingwu.yang@gmail.com>
Message-ID: <707b5fb3-6b61-c53-e983-bc1373aa2bf@ssi.bg>
References: <20211025115910.2595-1-xingwu.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 25 Oct 2021, yangxingwu wrote:

> Since commit dc7b3eb900aa ("ipvs: Fix reuse connection if real server is
> dead"), new connections to dead servers are redistributed immediately to
> new servers.
> 
> Then commit d752c3645717 ("ipvs: allow rescheduling of new connections when
> port reuse is detected") disable expire_nodest_conn if conn_reuse_mode is
> 0. And new connection may be distributed to a real server with weight 0.

	Your change does not look correct to me. At the time
expire_nodest_conn was created, it was not checked when
weight is 0. At different places different terms are used
but in short, we have two independent states for real server:

- inhibited: weight=0 and no new connections should be served,
	packets for existing connections can be routed to server
	if it is still available and packets are not dropped
	by expire_nodest_conn.
	The new feature is that port reuse detection can
	redirect the new TCP connection into a new IPVS conn and
	to expire the existing cp/ct.

- unavailable (!IP_VS_DEST_F_AVAILABLE): server is removed,
	can be temporary, drop traffic for existing connections
	but on expire_nodest_conn we can select different server

	The new conn_reuse_mode flag allows port reuse to
be detected. Only then expire_nodest_conn has the
opportunity with commit dc7b3eb900aa to check weight=0
and to consider the old traffic as finished. If a new
server is selected, any retrans from previous connection
would be considered as part from the new connection. It
is a rapid way to switch server without checking with
is_new_conn_expected() because we can not have many
conns/conntracks to different servers.

> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> ---
>  Documentation/networking/ipvs-sysctl.rst | 3 +--
>  net/netfilter/ipvs/ip_vs_core.c          | 5 +++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
> index 2afccc63856e..1cfbf1add2fc 100644
> --- a/Documentation/networking/ipvs-sysctl.rst
> +++ b/Documentation/networking/ipvs-sysctl.rst
> @@ -37,8 +37,7 @@ conn_reuse_mode - INTEGER
>  
>  	0: disable any special handling on port reuse. The new
>  	connection will be delivered to the same real server that was
> -	servicing the previous connection. This will effectively
> -	disable expire_nodest_conn.
> +	servicing the previous connection.
>  
>  	bit 1: enable rescheduling of new connections when it is safe.
>  	That is, whenever expire_nodest_conn and for TCP sockets, when
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 128690c512df..9279aed69e23 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2042,14 +2042,15 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>  			     ipvs, af, skb, &iph);
>  
>  	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> -	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> +	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
>  		bool old_ct = false, resched = false;
>  
>  		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
>  		    unlikely(!atomic_read(&cp->dest->weight))) {
>  			resched = true;
>  			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
> -		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
> +		} else if (conn_reuse_mode &&
> +			   is_new_conn_expected(cp, conn_reuse_mode)) {
>  			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
>  			if (!atomic_read(&cp->n_control)) {
>  				resched = true;
> -- 
> 2.30.2

Regards

--
Julian Anastasov <ja@ssi.bg>
