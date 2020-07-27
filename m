Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCB322FC0D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgG0WWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:22:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:22:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48197B626;
        Mon, 27 Jul 2020 22:22:09 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5D27D6073D; Tue, 28 Jul 2020 00:21:58 +0200 (CEST)
Date:   Tue, 28 Jul 2020 00:21:58 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
Message-ID: <20200727222158.bg52mg2mfsta2f37@lion.mk-sys.cz>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727214700.5915-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
> The ethtool netlink API can send bitsets without an associated bitmask.
> These do not get displayed properly, because the dump_link_modes, and
> bitset_get_bit to not check whether the provided bitset is a NOMASK
> bitset. This results in the inability to display peer advertised link
> modes.
> 
> The dump_link_modes and bitset_get_bit functions are designed so they
> can print either the values or the mask. For a nomask bitmap, this
> doesn't make sense. There is no mask.
> 
> Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
> bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
> regardless of the request to display the mask or the value. For full
> size bitmaps, the set of provided bits indicates the valid values,
> without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
> bits without this attribute if nomask is set. This essentially means
> that dump_link_modes will treat a NOMASK bitset as having a mask
> equivalent to all of its set bits.
> 
> For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
> bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
> For full bitmaps, if nomask is set, then always return true of the bit
> is in the set, rather than only if it provides an
> ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
> bits.
> 
> This fixes display of link partner advertised fields when using the
> netlink API.
> 
> Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  netlink/bitset.c   | 9 ++++++---
>  netlink/settings.c | 8 +++++---
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/netlink/bitset.c b/netlink/bitset.c
> index 130bcdb5b52c..ba5d3ea77ff7 100644
> --- a/netlink/bitset.c
> +++ b/netlink/bitset.c
> @@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>  	DECLARE_ATTR_TB_INFO(bitset_tb);
>  	const struct nlattr *bits;
>  	const struct nlattr *bit;
> +	bool nomask;
>  	int ret;
>  
>  	*retptr = 0;
> @@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>  	if (ret < 0)
>  		goto err;
>  
> -	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> -		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
> +
> +	bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> +		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
>  	if (bits) {
>  		const uint32_t *bitmap =
>  			(const uint32_t *)mnl_attr_get_payload(bits);

I don't like this part: (mask && nomask) is a situation which should
never happen as it would mean we are trying to get mask value from
a bitmap which does not any. In other words, if we ever see such
combination, it is a result of a bug either on ethtool side or on kernel
side.

Rather than silently returning something else than asked, we should
IMHO report an error. Which is easy in dump_link_modes() but it would
require rewriting bitset_get_bit().

Michal

> @@ -87,7 +90,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>  
>  		my_idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
>  		if (my_idx == idx)
> -			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
> +			return mask || nomask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
>  	}
>  
>  	return false;
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 35ba2f5dd6d5..29557653336e 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -280,9 +280,11 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  	const struct nlattr *bit;
>  	bool first = true;
>  	int prev = -2;
> +	bool nomask;
>  	int ret;
>  
>  	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
>  	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
>  	if (ret < 0)
>  		goto err_nonl;
> @@ -297,8 +299,8 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  			goto err_nonl;
>  		lm_strings = global_stringset(ETH_SS_LINK_MODES,
>  					      nlctx->ethnl2_socket);
> -		bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> -			      bitset_tb[ETHTOOL_A_BITSET_VALUE];
> +		bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
> +			                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
>  		ret = -EFAULT;
>  		if (!bits || !bitset_tb[ETHTOOL_A_BITSET_SIZE])
>  			goto err_nonl;
> @@ -354,7 +356,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
>  		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
>  		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
>  			goto err;
> -		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
> +		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
>  			continue;
>  
>  		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
> -- 
> 2.26.2
> 
