Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2F222C02
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgGPTdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgGPTdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:33:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA08A2074B;
        Thu, 16 Jul 2020 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594927984;
        bh=f+M7s3qu86tH5gd3QdIs/84UAED1OoATaON89L4NNMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCnxhTB4sdirpYpPKJAiwPVKbXJGvbxPZcmW3DYORX4L3NlGksYgX+j6AJlpogyd9
         MMNb0bnq4bc49I8o5B9rdpP0IpDud25XqAPms8xSQVsohV2n5i9KOCgD2ZPxtNU+BQ
         TM0g52Wa+tDVlTn6aN8bVoPp1wgl/rVV8ormRUsw=
Date:   Thu, 16 Jul 2020 12:33:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, aconole@redhat.com, sbrivio@redhat.com
Subject: Re: [PATCH net-next 2/3] vxlan: allow to disable path mtu learning
 on encap socket
Message-ID: <20200716123301.07a1c723@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200712200705.9796-3-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jul 2020 22:07:04 +0200 Florian Westphal wrote:
> While its already possible to configure VXLAN to never set the DF bit
> on packets that it sends, it was not yet possible to tell kernel to
> not update the encapsulation sockets path MTU.
> 
> This can be used to tell ip stack to always use the interface MTU
> when VXLAN wants to send a packet.
> 
> When packets are routed, VXLAN use skbs existing dst entries to
> propagate the MTU update to the overlay, but on a bridge this doesn't
> work (no routing, no dst entry, and no ip forwarding takes place, so
> nothing emits icmp packet w. mtu update to sender).
> 
> This is only useful when VXLAN is used as a bridge port and the
> network is known to accept packets up to the link MTU to avoid bogus
> pmtu icmp packets from stopping tunneled traffic.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Seems like a general problem for L2 tunnels, could you broaden the CC
list a little, perhaps? Maybe there is a best practice here we can
follow?

Handful of nit picks below :)

> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index a43c97b13924..ceb2940a2a62 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -3316,6 +3316,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
>  	[IFLA_VXLAN_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG },
>  	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
>  	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
> +	[IFLA_VXLAN_PMTUDISC]	= { .type = NLA_U8 },

NLA_POLICY_RANGE?

Also I'm not seeing .strict_start_type here.

>  };
>  
>  static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],

> @@ -3984,6 +3990,21 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
>  
>  	if (data[IFLA_VXLAN_LINK])
>  		conf->remote_ifindex = nla_get_u32(data[IFLA_VXLAN_LINK]);
> +	if (data[IFLA_VXLAN_PMTUDISC]) {
> +		int pmtuv = nla_get_u8(data[IFLA_VXLAN_PMTUDISC]);
> +
> +		if (pmtuv < IP_PMTUDISC_DONT) {
> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value < 0");
> +			return -EOPNOTSUPP;
> +		}
> +		if (pmtuv > IP_PMTUDISC_OMIT) {
> +			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PMTUDISC], "PMTUDISC Value > IP_PMTUDISC_OMIT");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		conf->pmtudisc = 1;
> +		conf->pmtudiscv = pmtuv;
> +	}

Can these conflict with DF settings?

> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index 3a41627cbdfe..1414cfa2005f 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -220,6 +220,8 @@ struct vxlan_config {
>  	unsigned long		age_interval;
>  	unsigned int		addrmax;
>  	bool			no_share;
> +	u8			pmtudisc:1;
> +	u8			pmtudiscv:3;

I must say for my myopic eyes discerning pmtudisc vs pmtudiscv took an
effort. Could you find better names?

>  	enum ifla_vxlan_df	df;
>  };
>  
