Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF96E2DB764
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgLPADO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:03:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41080 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgLPABe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 19:01:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 025BB4CE938AB;
        Tue, 15 Dec 2020 16:00:52 -0800 (PST)
Date:   Tue, 15 Dec 2020 16:00:49 -0800 (PST)
Message-Id: <20201215.160049.2258791262841288557.davem@davemloft.net>
To:     dmytro@shytyi.net
Cc:     kuba@kernel.org, yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        liuhangbin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V8] net: Variable SLAAC: SLAAC with prefixes
 of arbitrary length in PIO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
References: <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
        <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
        <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 15 Dec 2020 16:00:53 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Shytyi <dmytro@shytyi.net>
Date: Wed, 09 Dec 2020 04:27:54 +0100

> Variable SLAAC [Can be activated via sysctl]: 
> SLAAC with prefixes of arbitrary length in PIO (randomly
> generated hostID or stable privacy + privacy extensions).
> The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
> carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
> SLAAC is required so that downstream interfaces can be further subnetted.
> Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
> assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to
> Load-Balancer and /72 to wired connected devices.
> IETF document that defines problem statement:
> draft-mishra-v6ops-variable-slaac-problem-stmt
> IETF document that specifies variable slaac:
> draft-mishra-6man-variable-slaac
> 
> Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
> ---
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index dda61d150a13..67ca3925463c 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -75,6 +75,7 @@ struct ipv6_devconf {
>  	__s32		disable_policy;
>  	__s32           ndisc_tclass;
>  	__s32		rpl_seg_enabled;
> +	__s32		variable_slaac;
>  
>  	struct ctl_table_header *sysctl_header;
>  };
> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> index 13e8751bf24a..f2af4f9fba2d 100644
> --- a/include/uapi/linux/ipv6.h
> +++ b/include/uapi/linux/ipv6.h
> @@ -189,7 +189,8 @@ enum {
>  	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
>  	DEVCONF_NDISC_TCLASS,
>  	DEVCONF_RPL_SEG_ENABLED,
> -	DEVCONF_MAX
> +	DEVCONF_MAX,
> +	DEVCONF_VARIABLE_SLAAC
>  };
>  
>  
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eff2cacd5209..07afe4ce984e 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -236,6 +236,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
>  	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
>  	.disable_policy		= 0,
>  	.rpl_seg_enabled	= 0,
> +	.variable_slaac		= 0,
>  };
>  
>  static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
> @@ -291,6 +292,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
>  	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
>  	.disable_policy		= 0,
>  	.rpl_seg_enabled	= 0,
> +	.variable_slaac		= 0,
>  };
>  
>  /* Check if link is ready: is it up and is a valid qdisc available */
> @@ -1340,9 +1342,15 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
>  		goto out;
>  	}
>  	in6_ifa_hold(ifp);
> -	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
> -	ipv6_gen_rnd_iid(&addr);
>  
> +	if (ifp->prefix_len == 64) {
> +		memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
> +		ipv6_gen_rnd_iid(&addr);
> +	} else if (ifp->prefix_len > 0 && ifp->prefix_len <= 128 &&
> +		   idev->cnf.variable_slaac) {
> +		get_random_bytes(addr.s6_addr, 16);
> +		ipv6_addr_prefix_copy(&addr, &ifp->addr, ifp->prefix_len);
> +	}
>  	age = (now - ifp->tstamp) / HZ;
>  
>  	regen_advance = idev->cnf.regen_max_retry *
> @@ -2569,6 +2577,37 @@ static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
>  	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM;
>  }
>  
> +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp,
> +						      struct inet6_dev *in6_dev,
> +						      struct net *net,
> +						      const struct prefix_info *pinfo)
> +{
> +	struct inet6_ifaddr *result_base = NULL;
> +	struct inet6_ifaddr *result = NULL;
> +	bool prfxs_equal;
> +
> +	result_base = result;

This is NULL, are you sure you didn't mewan to init this to 'ifp'
 or similar instead?

Thanks.
