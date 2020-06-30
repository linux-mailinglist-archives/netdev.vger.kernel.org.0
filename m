Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6766820FA27
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389610AbgF3RJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:09:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:50884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgF3RJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 13:09:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2D724AE0A;
        Tue, 30 Jun 2020 17:09:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BD436604DC; Tue, 30 Jun 2020 19:09:26 +0200 (CEST)
Date:   Tue, 30 Jun 2020 19:09:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        o.rempel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        jacob.e.keller@intel.com, mlxsw@mellanox.com
Subject: Re: [PATCH ethtool 3/3] netlink: settings: expand
 linkstate_reply_cb() to support link extended state
Message-ID: <20200630170926.2vchf2xfaj3as3zw@lion.mk-sys.cz>
References: <20200630092412.11432-1-amitc@mellanox.com>
 <20200630092412.11432-4-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630092412.11432-4-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:24:12PM +0300, Amit Cohen wrote:
> Print extended state in addition to link state.
> 
> In case that extended state is not provided, print state only.
> If extended substate is provided in addition to the extended state,
> print it also.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> ---
>  netlink/settings.c | 59 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 56 insertions(+), 3 deletions(-)
> 
> diff --git a/netlink/settings.c b/netlink/settings.c
> index 35ba2f5..a4d1908 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -604,6 +604,57 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  	return MNL_CB_OK;
>  }
>  
> +int linkstate_link_ext_substate_print(const struct nlattr *tb[],
> +				      struct nl_context *nlctx, uint8_t link_val,
> +				      uint8_t link_ext_state_val,
> +				      const char *link_ext_state_str)
> +{
> +	uint8_t link_ext_substate_val;
> +	const char *link_ext_substate_str;
> +
> +	if (!tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE])
> +		return -ENODATA;
> +
> +	link_ext_substate_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]);
> +
> +	link_ext_substate_str = link_ext_substate_get(link_ext_state_val, link_ext_substate_val);
> +	if (!link_ext_substate_str)
> +		return -ENODATA;

This does not distinguish between missing attribute (substate not
provided by kernel) and unknown value which can happen when older
ethtool version is used on a newer kernel which returns a new substate
not known by ethtool. IMHO we should fall back to reporting the numeric
value in such case rather than behaving as if the information were not
provided.

> +
> +	print_banner(nlctx);
> +	printf("\tLink detected: %s (%s, %s)\n", link_val ? "yes" : "no",
> +	       link_ext_state_str, link_ext_substate_str);
> +
> +	return 0;
> +}
> +
> +int linkstate_link_ext_state_print(const struct nlattr *tb[],
> +				   struct nl_context *nlctx, uint8_t link_val)
> +{
> +	uint8_t link_ext_state_val;
> +	const char *link_ext_state_str;
> +	int ret;
> +
> +	if (!tb[ETHTOOL_A_LINKSTATE_EXT_STATE])
> +		return -ENODATA;
> +
> +	link_ext_state_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_STATE]);
> +
> +	link_ext_state_str = link_ext_state_get(link_ext_state_val);
> +	if (!link_ext_state_str)
> +		return -ENODATA;

The same problem as above.

> +
> +	ret = linkstate_link_ext_substate_print(tb, nlctx, link_val, link_ext_state_val,
> +						link_ext_state_str);
> +	if (ret < 0) {
> +		print_banner(nlctx);
> +		printf("\tLink detected: %s (%s)\n", link_val ? "yes" : "no",
> +		       link_ext_state_str);
> +	}
> +
> +	return 0;
> +}
> +
>  int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  {
>  	const struct nlattr *tb[ETHTOOL_A_LINKSTATE_MAX + 1] = {};
> @@ -622,9 +673,11 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  
>  	if (tb[ETHTOOL_A_LINKSTATE_LINK]) {
>  		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_LINK]);
> -
> -		print_banner(nlctx);
> -		printf("\tLink detected: %s\n", val ? "yes" : "no");
> +		ret = linkstate_link_ext_state_print(tb, nlctx, val);
> +		if (ret < 0) {
> +			print_banner(nlctx);
> +			printf("\tLink detected: %s\n", val ? "yes" : "no");
> +		}
>  	}
>  
>  	if (tb[ETHTOOL_A_LINKSTATE_SQI]) {

It's a bit impractical to have the banner and first part of the line
printed in three differente places. How about this:

  - linkstate_reply_cb() calls print_banner() and prints what it does
    now, only without the newline
  - linkstate_link_ext_state_print() prints " (%s" or " (%u" with
    extended state if it is provided or bails out if not
  - linkstate_link_ext_substate_print() prints ", %s" or ", %u" with
    extended substate if it is provided
  - linkstate_link_ext_state_print() prints ")"
  - linkstate_reply_cb() prints the newline

Michal
