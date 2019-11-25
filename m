Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9075E1095AC
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbfKYWpZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 17:45:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:45:23 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A20A15071D04;
        Mon, 25 Nov 2019 14:45:23 -0800 (PST)
Date:   Mon, 25 Nov 2019 14:45:22 -0800 (PST)
Message-Id: <20191125.144522.2288594830565793222.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] net: port < inet_prot_sock(net) -->
 inet_port_requires_bind_service(net, port)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191124092715.252532-1-zenczykowski@gmail.com>
References: <CANP3RGfi3vwAjYu45xRG7HqMw-CGEr4uxES8Cd7vHs+q4W4wLQ@mail.gmail.com>
        <20191124092715.252532-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 14:45:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Sun, 24 Nov 2019 01:27:15 -0800

> -static inline int inet_prot_sock(struct net *net)
> +static inline bool inet_port_requires_bind_service(struct net *net, int port)


"int port"

> -static inline int inet_prot_sock(struct net *net)
> +static inline bool inet_port_requires_bind_service(struct net *net, int port)

"int port"

> @@ -495,7 +495,7 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  
>  	snum = ntohs(addr->sin_port);
>  	err = -EACCES;
> -	if (snum && snum < inet_prot_sock(net) &&
> +	if (snum && inet_port_requires_bind_service(net, snum) &&

"unsigned short snum"

> @@ -292,7 +292,7 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  		return -EINVAL;
>  
>  	snum = ntohs(addr->sin6_port);
> -	if (snum && snum < inet_prot_sock(net) &&
> +	if (snum && inet_port_requires_bind_service(net, snum) &&

"unsigned short snum"

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 3be7398901e0..8d14a1acbc37 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -423,7 +423,7 @@ ip_vs_service_find(struct netns_ipvs *ipvs, int af, __u32 fwmark, __u16 protocol
>  
>  	if (!svc && protocol == IPPROTO_TCP &&
>  	    atomic_read(&ipvs->ftpsvc_counter) &&
> -	    (vport == FTPDATA || ntohs(vport) >= inet_prot_sock(ipvs->net))) {
> +	    (vport == FTPDATA || !inet_port_requires_bind_service(ipvs->net, ntohs(vport)))) {

ntohs(__be16 vport)

> @@ -384,7 +384,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>  		}
>  	}
>  
> -	if (snum && snum < inet_prot_sock(net) &&
> +	if (snum && inet_port_requires_bind_service(net, snum) &&

"unsigned short snum"

And so on and so forth.

Please make the types in the helper(s) match actual usage, thank you.
