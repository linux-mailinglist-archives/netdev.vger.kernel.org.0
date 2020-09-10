Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9A1263AE5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbgIJB7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 21:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbgIJBka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:40:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E73A22224;
        Thu, 10 Sep 2020 01:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599699793;
        bh=SrGycE3tXzLxgGNej8lGpvIw8Q+2eC+p5GUSNZ0UDbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L6IRR00kfh4YmaeaBtv50BQLF+8zr/jUxy7bgZLfNaRe5LplDdk5RUv2vnZjJn99L
         bJqAzd3VVJA1LlzqdhjJAEdYt9dY2co6rB+WotNVrS9cvBtg25z0MTbsuR5Hscl0B+
         HM0/fPOZmJeyN9SS+7m9IHyjraoHUXHWLPCnkWtw=
Date:   Wed, 9 Sep 2020 18:03:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v4 3/5] devlink: introduce flash update overwrite
 mask
Message-ID: <20200909180310.27a19827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909222653.32994-4-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 15:26:51 -0700 Jacob Keller wrote:
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 40d35145c879..19a573566359 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -228,6 +228,28 @@ enum {
>  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
>  };
>  
> +/* Specify what sections of a flash component can be overwritten when
> + * performing an update. Overwriting of firmware binary sections is always
> + * implicitly assumed to be allowed.
> + *
> + * Each section must be documented in
> + * Documentation/networking/devlink/devlink-flash.rst
> + *
> + */
> +enum {
> +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
> +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
> +
> +	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
> +	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
> +};
> +
> +#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
> +#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
> +
> +#define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> +	(BIT(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)

I don't think you can use BIT() in uAPI headers :(

>  /**
>   * enum devlink_trap_action - Packet trap action.
>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
> @@ -460,6 +482,9 @@ enum devlink_attr {
>  
>  	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
>  	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
> +
> +	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
> +
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index c61f9c8205f6..d0d38ca17ea8 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3125,8 +3125,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  				       struct genl_info *info)
>  {
>  	struct devlink_flash_update_params params = {};
> +	struct nlattr *nla_component, *nla_overwrite;
>  	struct devlink *devlink = info->user_ptr[0];
> -	struct nlattr *nla_component;
>  	u32 supported_params;
>  
>  	if (!devlink->ops->flash_update)
> @@ -3149,6 +3149,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  		params.component = nla_data(nla_component);
>  	}
>  
> +	nla_overwrite = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
> +	if (nla_overwrite) {
> +		struct nla_bitfield32 sections;
> +
> +		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
> +			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite,
> +					    "overwrite is not supported");

settings ... by this device ?

> +			return -EOPNOTSUPP;
> +		}
> +		sections = nla_get_bitfield32(nla_overwrite);
> +		params.overwrite_mask = sections.value & sections.selector;
 
