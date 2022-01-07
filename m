Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5315C48714D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiAGDmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:42:22 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiAGDmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:42:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B0CDB8248F
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958DDC36AE9;
        Fri,  7 Jan 2022 03:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641526940;
        bh=sGSH6/Zs04TZTZhPLpYZePvC0kyLbo5BYKwpIz5y6DY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UkDLwywnZ/dyTxWoSp4NSloeTWJsleFP/aXrXH+crTISAp+pvrD4gMAeQ3mTCVZmf
         GiIwlH26eloCY9w4+9a2nSezqD15IRgZy9er3YkWilLMgHVLrnYNk+IB37mt1xQwr/
         eew1IuBJNWtawOukDkTutVX9H1QSTEqrgLIwLqkQ9nu6aXBSyHsQKHveQRM8GJ4kDQ
         QKG4cqjnQSGmJyunH6mCRxKVWyo8R77iIDs8k/O34Lg68pweSK2dlNSlT4wKok4kAa
         cKMzUqpPsf4Qq5qL8/DszXItuKBoA3sgKMYcsXCdtVOXVhZe0Bf09Q2O5+dgDs7zoM
         HQh+HhIOriaYQ==
Date:   Thu, 6 Jan 2022 19:42:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
Subject: Re: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Message-ID: <20220106194218.0bba07fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220105031515.29276-3-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-3-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jan 2022 00:15:06 -0300 Luiz Angelo Daros de Luca wrote:
>  /**
> - * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
> + * struct realtek_ops - vtable for the per-SMI-chiptype operations
>   * @detect: detects the chiptype

This kdoc is missing decriptions for a lot of members.

Would you mind adding a patch to the front of the series to resolve all
kdoc issues in realtek-smi-core.h AKA realtek.h so that we don't get
the errors re-reported each time the file is renamed in the series?
Since the kdoc doesn't add much here I think you can just replace the
/** with a /* for now, or remove it completely.

>   */
> -struct realtek_smi_ops {
> -	int	(*detect)(struct realtek_smi *smi);
> -	int	(*reset_chip)(struct realtek_smi *smi);
> -	int	(*setup)(struct realtek_smi *smi);
> -	void	(*cleanup)(struct realtek_smi *smi);
> -	int	(*get_mib_counter)(struct realtek_smi *smi,
> +struct realtek_ops {
> +	int	(*detect)(struct realtek_priv *priv);
> +	int	(*reset_chip)(struct realtek_priv *priv);
> +	int	(*setup)(struct realtek_priv *priv);
> +	void	(*cleanup)(struct realtek_priv *priv);
> +	int	(*get_mib_counter)(struct realtek_priv *priv,
>  				   int port,
>  				   struct rtl8366_mib_counter *mib,
>  				   u64 *mibvalue);
> -	int	(*get_vlan_mc)(struct realtek_smi *smi, u32 index,
> +	int	(*get_vlan_mc)(struct realtek_priv *priv, u32 index,
>  			       struct rtl8366_vlan_mc *vlanmc);
> -	int	(*set_vlan_mc)(struct realtek_smi *smi, u32 index,
> +	int	(*set_vlan_mc)(struct realtek_priv *priv, u32 index,
>  			       const struct rtl8366_vlan_mc *vlanmc);
> -	int	(*get_vlan_4k)(struct realtek_smi *smi, u32 vid,
> +	int	(*get_vlan_4k)(struct realtek_priv *priv, u32 vid,
>  			       struct rtl8366_vlan_4k *vlan4k);
> -	int	(*set_vlan_4k)(struct realtek_smi *smi,
> +	int	(*set_vlan_4k)(struct realtek_priv *priv,
>  			       const struct rtl8366_vlan_4k *vlan4k);
> -	int	(*get_mc_index)(struct realtek_smi *smi, int port, int *val);
> -	int	(*set_mc_index)(struct realtek_smi *smi, int port, int index);
> -	bool	(*is_vlan_valid)(struct realtek_smi *smi, unsigned int vlan);
> -	int	(*enable_vlan)(struct realtek_smi *smi, bool enable);
> -	int	(*enable_vlan4k)(struct realtek_smi *smi, bool enable);
> -	int	(*enable_port)(struct realtek_smi *smi, int port, bool enable);
> -	int	(*phy_read)(struct realtek_smi *smi, int phy, int regnum);
> -	int	(*phy_write)(struct realtek_smi *smi, int phy, int regnum,
> +	int	(*get_mc_index)(struct realtek_priv *priv, int port, int *val);
> +	int	(*set_mc_index)(struct realtek_priv *priv, int port, int index);
> +	bool	(*is_vlan_valid)(struct realtek_priv *priv, unsigned int vlan);
> +	int	(*enable_vlan)(struct realtek_priv *priv, bool enable);
> +	int	(*enable_vlan4k)(struct realtek_priv *priv, bool enable);
> +	int	(*enable_port)(struct realtek_priv *priv, int port, bool enable);
> +	int	(*phy_read)(struct realtek_priv *priv, int phy, int regnum);
> +	int	(*phy_write)(struct realtek_priv *priv, int phy, int regnum,
>  			     u16 val);
>  };
