Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A501179966
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgCDT7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgCDT7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:59:04 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63E921556;
        Wed,  4 Mar 2020 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583351944;
        bh=/1IBA75y5Uh1ACJFN9DkCu/lV0jhKqR4AiO/tn64k1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jPz/cypsa+JeQwoVU0MmnrVlMzsxinA/bCDZuc9no/v+hxTEm2II3d7xusDsuvd5h
         SB82bBw/4M3Pgbh//VkM6BZ8wdKr7DnCMk0ZEI+tdGs59Im4FGoJW7GPRz9I7+twDL
         xWksTVy650TVw7aWPthRrplboa4jNjMcAMVmnKzs=
Date:   Wed, 4 Mar 2020 11:59:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/8] ionic: support ethtool rxhash disable
Message-ID: <20200304115902.011ff647@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304042013.51970-6-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
        <20200304042013.51970-6-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Mar 2020 20:20:10 -0800 Shannon Nelson wrote:
> We can disable rxhashing by setting rss_types to 0.  The user
> can toggle this with "ethtool -K <ethX> rxhash off|on",
> which calls into the .ndo_set_features callback with the
> NETIF_F_RXHASH feature bit set or cleared.  This patch adds
> a check for that bit and updates the FW if necessary.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index d1567e477b1f..4b953f9e9084 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1094,6 +1094,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
>  	u64 vlan_flags = IONIC_ETH_HW_VLAN_TX_TAG |
>  			 IONIC_ETH_HW_VLAN_RX_STRIP |
>  			 IONIC_ETH_HW_VLAN_RX_FILTER;
> +	u64 old_hw_features;
>  	int err;
>  
>  	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
> @@ -1101,9 +1102,13 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
>  	if (err)
>  		return err;
>  
> +	old_hw_features = lif->hw_features;
>  	lif->hw_features = le64_to_cpu(ctx.cmd.lif_setattr.features &
>  				       ctx.comp.lif_setattr.features);
>  
> +	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
> +		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);

Is this change coming from the HW or from ethtool? AFAIK hw_features
are what's supported, features is what's enabled..

>  	if ((vlan_flags & features) &&
>  	    !(vlan_flags & le64_to_cpu(ctx.comp.lif_setattr.features)))
>  		dev_info_once(lif->ionic->dev, "NIC is not supporting vlan offload, likely in SmartNIC mode\n");
> @@ -1357,13 +1362,15 @@ int ionic_lif_rss_config(struct ionic_lif *lif, const u16 types,
>  		.cmd.lif_setattr = {
>  			.opcode = IONIC_CMD_LIF_SETATTR,
>  			.attr = IONIC_LIF_ATTR_RSS,
> -			.rss.types = cpu_to_le16(types),
>  			.rss.addr = cpu_to_le64(lif->rss_ind_tbl_pa),
>  		},
>  	};
>  	unsigned int i, tbl_sz;
>  
> -	lif->rss_types = types;
> +	if (lif->hw_features & IONIC_ETH_HW_RX_HASH) {
> +		lif->rss_types = types;
> +		ctx.cmd.lif_setattr.rss.types = cpu_to_le16(types);
> +	}
>  
>  	if (key)
>  		memcpy(lif->rss_hash_key, key, IONIC_RSS_HASH_KEY_SIZE);

