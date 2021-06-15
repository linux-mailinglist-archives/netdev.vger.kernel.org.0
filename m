Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E7B3A89C2
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhFOTvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhFOTvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7999061246;
        Tue, 15 Jun 2021 19:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623786553;
        bh=YMYLrhelDjWIC3iMmIrOYrADkVc/iGd03Vt4y+Brc/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cVAxYiyxUAMbkOY0+zVqijztU/W+glxr+VP3y+/O35yFqvjr2QL2dR1dTRufkTxtm
         lpLYoYHacQU7eW4JQK9Vrokd8WMqOOwkSlAKUbKY10W0KqLipdx9LoGmn0dT3B+nKJ
         6KRao4iW25FX1PCg3tm1G9jQHJg4NEfiUh9ljpcHA/Zue+LhB6gT++qEW3ihvhWE52
         Q4w+ZxcXHSK1iKlL02KrKVomHP82VHv2MvDHblidgr0vFa/M5TzSsDzLIdo53i8dLm
         UBPDMxlGYDYAzRLxn5N7cC2+oWcbWhUZiwuHCEf8X7AAwTNE8qHGetvuOATxLBEUC7
         RdkcCbrrYkSoA==
Date:   Tue, 15 Jun 2021 12:49:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v3, 05/10] ethtool: add a new command for getting
 PHC virtual clocks
Message-ID: <20210615124911.15e64ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210615094517.48752-6-yangbo.lu@nxp.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
        <20210615094517.48752-6-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 17:45:12 +0800 Yangbo Lu wrote:
> Add an interface for getting PHC (PTP Hardware Clock)
> virtual clocks, which are based on PHC physical clock
> providing hardware timestamp to network packets.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index cfef6b08169a..0fb04f945767 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -17,6 +17,7 @@
>  #include <linux/const.h>
>  #include <linux/types.h>
>  #include <linux/if_ether.h>
> +#include <linux/ptp_clock.h>
>  
>  #ifndef __KERNEL__
>  #include <limits.h> /* for INT_MAX */
> @@ -1341,6 +1342,18 @@ struct ethtool_ts_info {
>  	__u32	rx_reserved[3];
>  };
>  
> +/**
> + * struct ethtool_phc_vclocks - holds a device's PTP virtual clocks
> + * @cmd: command number = %ETHTOOL_GET_PHC_VCLOCKS
> + * @num: number of PTP vclocks
> + * @index: all index values of PTP vclocks
> + */
> +struct ethtool_phc_vclocks {
> +	__u32	cmd;
> +	__u8	num;
> +	__s32	index[PTP_MAX_VCLOCKS];
> +};
> +
>  /*
>   * %ETHTOOL_SFEATURES changes features present in features[].valid to the
>   * values of corresponding bits in features[].requested. Bits in .requested
> @@ -1552,6 +1565,7 @@ enum ethtool_fec_config_bits {
>  #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
>  #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
>  #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
> +#define ETHTOOL_GET_PHC_VCLOCKS	0x00000052 /* Get PHC virtual clocks info */

We don't add new IOCTL commands, only netlink API is going to be
extended. Please remove the IOCTL interface & uAPI.

>  /* compatibility with older code */
>  #define SPARC_ETH_GSET		ETHTOOL_GSET

> +/* PHC VCLOCKS */
> +
> +enum {
> +	ETHTOOL_A_PHC_VCLOCKS_UNSPEC,
> +	ETHTOOL_A_PHC_VCLOCKS_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PHC_VCLOCKS_NUM,			/* u8 */

u32, no need to limit yourself, the netlink attribute is rounded up to
4B anyway.

> +	ETHTOOL_A_PHC_VCLOCKS_INDEX,			/* s32 */

This is an array, AFAICT, not a single s32.

> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PHC_VCLOCKS_CNT,
> +	ETHTOOL_A_PHC_VCLOCKS_MAX = (__ETHTOOL_A_PHC_VCLOCKS_CNT - 1)
> +};
> +
>  /* CABLE TEST */
>  
>  enum {

> +static int phc_vclocks_fill_reply(struct sk_buff *skb,
> +				  const struct ethnl_req_info *req_base,
> +				  const struct ethnl_reply_data *reply_base)
> +{
> +	const struct phc_vclocks_reply_data *data =
> +		PHC_VCLOCKS_REPDATA(reply_base);
> +	const struct ethtool_phc_vclocks *phc_vclocks = &data->phc_vclocks;
> +
> +	if (phc_vclocks->num <= 0)
> +		return 0;
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_PHC_VCLOCKS_NUM, phc_vclocks->num) ||
> +	    nla_put(skb, ETHTOOL_A_PHC_VCLOCKS_INDEX,
> +		    sizeof(phc_vclocks->index), phc_vclocks->index))

Looks like you'll report the whole array, why not just num?

> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +const struct ethnl_request_ops ethnl_phc_vclocks_request_ops = {
> +	.request_cmd		= ETHTOOL_MSG_PHC_VCLOCKS_GET,
> +	.reply_cmd		= ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
> +	.hdr_attr		= ETHTOOL_A_PHC_VCLOCKS_HEADER,
> +	.req_info_size		= sizeof(struct phc_vclocks_req_info),
> +	.reply_data_size	= sizeof(struct phc_vclocks_reply_data),
> +
> +	.prepare_data		= phc_vclocks_prepare_data,
> +	.reply_size		= phc_vclocks_reply_size,
> +	.fill_reply		= phc_vclocks_fill_reply,
> +};

