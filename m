Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0CC2DECB2
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 03:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgLSCEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 21:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgLSCEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 21:04:05 -0500
Date:   Fri, 18 Dec 2020 18:03:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608343404;
        bh=LRWx2UwowbM43Qok+Y+OWJ8MI9EOFTfB8pfPhT1b0CY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=h/OCCp38XzuG+mcbkr8HRQ9NVlaUlYuVgoexk3zXb3w+MEBKuHY0UptOJDH9EV6e7
         IWRbmp5STdzVxc3A6rQOobAytPNRvPSIz1XOKC2O9Q9YvxdiHVgnPaIAOffsfeZu/n
         Tg09zxDPizur0cD1/esqr3a6wsSGacEna48oAIWOuO0izp9pAVda3Zplmf2Df2VAxN
         XPYqyKpy8Lp3sma90cmlS46xKjVtbtCZoy8XS4Zuo4WS/YCiMA6EvDFtmlOUfx50B3
         5JuuD2E0ojrlz+99apdYy4VDoNMdFUgwrDMayMMmQHh8oYlo86yYe6NVh0vfAXouZN
         /PusgjnQUyg0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Joel Scherpelz <jscherpelz@google.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Subject: Re: [PATCH net-next V9] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
        <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
        <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
        <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
        <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It'd be great if someone more familiar with our IPv6 code could take a
look. Adding some folks to the CC.

On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:
> Variable SLAAC [Can be activated via sysctl]: 
> SLAAC with prefixes of arbitrary length in PIO (randomly
> generated hostID or stable privacy + privacy extensions).
> The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
> carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
> SLAAC is required so that downstream interfaces can be further subnetted.
> Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
> assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer 
> and /72 to wired connected devices.
> IETF document that defines problem statement:
> draft-mishra-v6ops-variable-slaac-problem-stmt
> IETF document that specifies variable slaac:
> draft-mishra-6man-variable-slaac
> 
> Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>

The RFC mentions checking a flag in RA, but I don't see that in this
patch, could you explain?

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

MAX should be the last field, no? Isn't it used for sizing tables?

> +	DEVCONF_VARIABLE_SLAAC
>  };
>  
>  
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eff2cacd5209..4afaf2bc8d8b 100644
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
> @@ -2569,6 +2577,31 @@ static bool is_addr_mode_generate_stable(struct inet6_dev *idev)
>  	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM;
>  }
>  
> +static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp,
> +						      struct inet6_dev *in6_dev,
> +						      struct net *net,
> +						      const struct prefix_info *pinfo)
> +{
> +	struct inet6_ifaddr *result = NULL;
> +	bool prfxs_equal;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
> +		if (!net_eq(dev_net(ifp->idev->dev), net))
> +			continue;
> +		prfxs_equal =
> +			ipv6_prefix_equal(&pinfo->prefix, &ifp->addr, pinfo->prefix_len);
> +		if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) {
> +			result = ifp;
> +			in6_ifa_hold(ifp);
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return result;
> +}
> +
>  int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
>  				 const struct prefix_info *pinfo,
>  				 struct inet6_dev *in6_dev,
> @@ -2576,9 +2609,17 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
>  				 u32 addr_flags, bool sllao, bool tokenized,
>  				 __u32 valid_lft, u32 prefered_lft)
>  {
> -	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
> +	struct inet6_ifaddr *ifp = NULL;
> +	int plen = pinfo->prefix_len;
>  	int create = 0;
>  
> +	if (plen > 0 && plen <= 128 && plen != 64 &&
> +	    in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY &&
> +	    in6_dev->cnf.variable_slaac)
> +		ifp = ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, pinfo);
> +	else
> +		ifp = ipv6_get_ifaddr(net, addr, dev, 1);
> +
>  	if (!ifp && valid_lft) {
>  		int max_addresses = in6_dev->cnf.max_addresses;
>  		struct ifa6_config cfg = {
> @@ -2657,6 +2698,90 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(addrconf_prefix_rcv_add_addr);
>  
> +static bool ipv6_reserved_interfaceid(struct in6_addr address)
> +{
> +	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
> +		return true;
> +
> +	if (address.s6_addr32[2] == htonl(0x02005eff) &&
> +	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
> +		return true;
> +
> +	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
> +	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
> +		return true;
> +
> +	return false;
> +}
> +
> +static int ipv6_gen_addr_var_plen(struct in6_addr *address,
> +				  u8 dad_count,
> +				  const struct inet6_dev *idev,
> +				  unsigned int rcvd_prfx_len,
> +				  bool stable_privacy_mode)
> +{
> +	static union {
> +		char __data[SHA1_BLOCK_SIZE];
> +		struct {
> +			struct in6_addr secret;
> +			__be32 prefix[2];
> +			unsigned char hwaddr[MAX_ADDR_LEN];
> +			u8 dad_count;
> +		} __packed;
> +	} data;
> +	static __u32 workspace[SHA1_WORKSPACE_WORDS];
> +	static __u32 digest[SHA1_DIGEST_WORDS];
> +	struct net *net = dev_net(idev->dev);
> +	static DEFINE_SPINLOCK(lock);
> +	struct in6_addr secret;
> +	struct in6_addr temp;
> +
> +	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
> +
> +	if (stable_privacy_mode) {
> +		if (idev->cnf.stable_secret.initialized)
> +			secret = idev->cnf.stable_secret.secret;
> +		else if (net->ipv6.devconf_dflt->stable_secret.initialized)
> +			secret = net->ipv6.devconf_dflt->stable_secret.secret;
> +		else
> +			return -1;
> +	}
> +
> +retry:
> +	spin_lock_bh(&lock);
> +	if (stable_privacy_mode) {
> +		sha1_init(digest);
> +		memset(&data, 0, sizeof(data));
> +		memset(workspace, 0, sizeof(workspace));
> +		memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
> +		data.prefix[0] = address->s6_addr32[0];
> +		data.prefix[1] = address->s6_addr32[1];
> +		data.secret = secret;
> +		data.dad_count = dad_count;
> +
> +		sha1_transform(digest, data.__data, workspace);
> +
> +		temp.s6_addr32[0] = (__force __be32)digest[0];
> +		temp.s6_addr32[1] = (__force __be32)digest[1];
> +		temp.s6_addr32[2] = (__force __be32)digest[2];
> +		temp.s6_addr32[3] = (__force __be32)digest[3];
> +	} else {
> +		get_random_bytes(temp.s6_addr32, 16);
> +	}
> +
> +	spin_unlock_bh(&lock);

Is there a reason this code declares all this state on the stack and
protects it with a lock rather than just allocating the memory with
kmalloc()?

> +	if (ipv6_reserved_interfaceid(temp)) {
> +		dad_count++;
> +		if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_retries)
> +			return -1;
> +		goto retry;
> +	}
> +	ipv6_addr_prefix_copy(&temp, address, rcvd_prfx_len);
> +	*address = temp;
> +	return 0;
> +}
> +
>  void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
>  {
>  	struct prefix_info *pinfo;
> @@ -2781,9 +2906,34 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
>  				dev_addr_generated = true;
>  			}
>  			goto ok;
> +		} else if (pinfo->prefix_len != 64 &&
> +			   pinfo->prefix_len > 0 && pinfo->prefix_len <= 128 &&
> +			   in6_dev->cnf.variable_slaac) {
> +			/* SLAAC with prefixes of arbitrary length (Variable SLAAC).
> +			 * draft-mishra-6man-variable-slaac
> +			 * draft-mishra-v6ops-variable-slaac-problem-stmt
> +			 */
> +			memcpy(&addr, &pinfo->prefix, 16);
> +			if (in6_dev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY) {
> +				if (!ipv6_gen_addr_var_plen(&addr,
> +							    0,
> +							    in6_dev,
> +							    pinfo->prefix_len,
> +							    true)) {
> +					addr_flags |= IFA_F_STABLE_PRIVACY;
> +					goto ok;
> +				}
> +			} else if (!ipv6_gen_addr_var_plen(&addr,
> +							   0,
> +							   in6_dev,
> +							   pinfo->prefix_len,
> +							   false)) {
> +				goto ok;
> +			}
> +		} else {
> +			net_dbg_ratelimited("IPv6: Prefix with unexpected length %d\n",
> +					    pinfo->prefix_len);
>  		}
> -		net_dbg_ratelimited("IPv6 addrconf: prefix with wrong length %d\n",
> -				    pinfo->prefix_len);
>  		goto put;
>  
>  ok:
> @@ -3186,22 +3336,6 @@ void addrconf_add_linklocal(struct inet6_dev *idev,
>  }
>  EXPORT_SYMBOL_GPL(addrconf_add_linklocal);
>  
> -static bool ipv6_reserved_interfaceid(struct in6_addr address)
> -{
> -	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
> -		return true;
> -
> -	if (address.s6_addr32[2] == htonl(0x02005eff) &&
> -	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
> -		return true;
> -
> -	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
> -	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
> -		return true;
> -
> -	return false;
> -}
> -
>  static int ipv6_generate_stable_address(struct in6_addr *address,
>  					u8 dad_count,
>  					const struct inet6_dev *idev)
> @@ -5517,6 +5651,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
>  	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
>  	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
>  	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
> +	array[DEVCONF_VARIABLE_SLAAC] = cnf->variable_slaac;
>  }
>  
>  static inline size_t inet6_ifla6_size(void)
> @@ -6897,6 +7032,13 @@ static const struct ctl_table addrconf_sysctl[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "variable_slaac",
> +		.data		= &ipv6_devconf.variable_slaac,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
>  	{
>  		/* sentinel */
>  	}

