Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE349507A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbiATOnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:43:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236043AbiATOnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nxj5VSKBQ1eE2/4hawOM8H1yWQH46Q1DRgmPSIc4qPQ=; b=LD0Q+TUCVXDQFAt+qfd9WkSCtx
        jjW3G1Jwcl3vHGGPk7d7YBmxzmMe0mcKbYnK6FhdMInE7BxtzohB1tk5w/gsRXL+Y8O7qnHYxzOZG
        5XjMMZOxje/DJLHhGlialNFhJ+v4tXRUB5ze/TbsS1HcraQiMn+X/AkQPl8i1siHhAIU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAYeg-002007-Ko; Thu, 20 Jan 2022 15:43:14 +0100
Date:   Thu, 20 Jan 2022 15:43:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Tal <moshet@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] ethtool: Fix link extended state for big endian
Message-ID: <Yel1AuSIcab+VUsO@lunn.ch>
References: <20220120095550.5056-1-moshet@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120095550.5056-1-moshet@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 11:55:50AM +0200, Moshe Tal wrote:
> The link extended sub-states are assigned as enum that is an integer
> size but read from a union as u8, this is working for small values on
> little endian systems but for big endian this always give 0. Fix the
> variable in the union to match the enum size.
> 
> Fixes: ecc31c60240b ("ethtool: Add link extended state")
> Signed-off-by: Moshe Tal <moshet@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  include/linux/ethtool.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index a26f37a27167..11efc45de66a 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -111,7 +111,7 @@ struct ethtool_link_ext_state_info {
>  		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
>  		enum ethtool_link_ext_substate_cable_issue cable_issue;
>  		enum ethtool_link_ext_substate_module module;
> -		u8 __link_ext_substate;
> +		u32 __link_ext_substate;

Not my area of expertise, but:

static int linkstate_reply_size(const struct ethnl_req_info *req_base,
                                const struct ethnl_reply_data *reply_base)
{
        struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
        int len;

       if (data->ethtool_link_ext_state_info.__link_ext_substate)
                len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_SUBSTATE */

and

static int linkstate_fill_reply(struct sk_buff *skb,
                                const struct ethnl_req_info *req_base,
                                const struct ethnl_reply_data *reply_base)
{

		if (data->ethtool_link_ext_state_info.__link_ext_substate &&
                    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,
                               data->ethtool_link_ext_state_info.__link_ext_substate))
                        return -EMSGSIZE;

This seems to suggest it is a u8, not a u32.

I guess i don't understand something here...

  Andrew
