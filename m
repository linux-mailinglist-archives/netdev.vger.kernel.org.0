Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260324457BD
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhKDRAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:00:00 -0400
Received: from mg.ssi.bg ([193.238.174.37]:44958 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhKDQ7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 12:59:45 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 12:59:42 EDT
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id DF8402883C;
        Thu,  4 Nov 2021 18:48:01 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 2593F287A6;
        Thu,  4 Nov 2021 18:48:00 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 290F93C0325;
        Thu,  4 Nov 2021 18:47:56 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 1A4GlsFT007224;
        Thu, 4 Nov 2021 18:47:55 +0200
Date:   Thu, 4 Nov 2021 18:47:54 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     yangxingwu <xingwu.yang@gmail.com>
cc:     Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, Chuanqi Liu <legend050709@qq.com>
Subject: Re: [PATCH nf-next v6] netfilter: ipvs: Fix reuse connection if RS
 weight is 0
In-Reply-To: <20211104031029.157366-1-xingwu.yang@gmail.com>
Message-ID: <72d07ec2-ec1-9024-ca98-c923f5d8f74@ssi.bg>
References: <20211104031029.157366-1-xingwu.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 4 Nov 2021, yangxingwu wrote:

> We are changing expire_nodest_conn to work even for reused connections when
> conn_reuse_mode=0, just as what was done with commit dc7b3eb900aa ("ipvs:
> Fix reuse connection if real server is dead").
> 
> For controlled and persistent connections, the new connection will get the
> needed real server depending on the rules in ip_vs_check_template().
> 
> Fixes: d752c3645717 ("ipvs: allow rescheduling of new connections when port reuse is detected")
> Co-developed-by: Chuanqi Liu <legend050709@qq.com>
> Signed-off-by: Chuanqi Liu <legend050709@qq.com>
> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  Documentation/networking/ipvs-sysctl.rst | 3 +--
>  net/netfilter/ipvs/ip_vs_core.c          | 8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
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
> index 128690c512df..393058a43aa7 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1964,7 +1964,6 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>  	struct ip_vs_proto_data *pd;
>  	struct ip_vs_conn *cp;
>  	int ret, pkts;
> -	int conn_reuse_mode;
>  	struct sock *sk;
>  
>  	/* Already marked as IPVS request or reply? */
> @@ -2041,15 +2040,16 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>  	cp = INDIRECT_CALL_1(pp->conn_in_get, ip_vs_conn_in_get_proto,
>  			     ipvs, af, skb, &iph);
>  
> -	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
> -	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> +	if (!iph.fragoffs && is_new_conn(skb, &iph) && cp) {
> +		int conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
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

