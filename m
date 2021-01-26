Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7F303A5F
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 11:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404017AbhAZKdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 05:33:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404096AbhAZKcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 05:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611657043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KuZg9upurN3kgrK07D1i3fm6HoQPuTKGYFjpYfOzLAo=;
        b=BRCH3eRMLQz32M3PH6T2+9sCGrOt7wM6O7GEy7ovMFLzWmXcdzraMdMbRiB8FeZnLu3whW
        Nl/i9Qrsgpg188SRwDCmGMu+tIxWNndk+IDq0K+RdaSKL5Yx9K8V5iVFlnANWpKLXuMWKz
        YLFsUaHCwacuUK7CeTiDn4oTGmNbEqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-hdxK8C7DOsWxFZjpwsOrHQ-1; Tue, 26 Jan 2021 05:30:40 -0500
X-MC-Unique: hdxK8C7DOsWxFZjpwsOrHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCE0318C8C03;
        Tue, 26 Jan 2021 10:30:38 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-118.ams2.redhat.com [10.36.112.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BB73710DC;
        Tue, 26 Jan 2021 10:30:38 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 252A5A80D7F; Tue, 26 Jan 2021 11:30:37 +0100 (CET)
Date:   Tue, 26 Jan 2021 11:30:37 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     sasha.neftin@intel.com
Subject: Re: [Intel-wired-lan] igc: fix link speed advertising
Message-ID: <20210126103037.GH4393@calimero.vinschen.de>
Mail-Followup-To: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com
References: <20201117195040.178651-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117195040.178651-1-vinschen@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping?

It looks like this patch got lost somehow.  Without this patch,
setting link speed advertising is broken.


Thanks,
Corinna


On Nov 17 20:50, Corinna Vinschen wrote:
> Link speed advertising in igc has two problems:
> 
> - When setting the advertisement via ethtool, the link speed is converted
>   to the legacy 32 bit representation for the intel PHY code.
>   This inadvertently drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT (being
>   beyond bit 31).  As a result, any call to `ethtool -s ...' drops the
>   2500Mbit/s link speed from the PHY settings.  Only reloading the driver
>   alleviates that problem.
> 
>   Fix this by converting the ETHTOOL_LINK_MODE_2500baseT_Full_BIT to the
>   Intel PHY ADVERTISE_2500_FULL bit explicitely.
> 
> - Rather than checking the actual PHY setting, the .get_link_ksettings
>   function always fills link_modes.advertising with all link speeds
>   the device is capable of.
> 
>   Fix this by checking the PHY autoneg_advertised settings and report
>   only the actually advertised speeds up to ethtool.
> 
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 +++++++++++++++-----
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> index 61d331ce38cd..75cb4ca36bac 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> @@ -1675,12 +1675,18 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
>  	cmd->base.phy_address = hw->phy.addr;
>  
>  	/* advertising link modes */
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
> -	ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_10_HALF)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Half);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_10_FULL)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 10baseT_Full);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_100_HALF)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Half);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_100_FULL)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 100baseT_Full);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_1000_FULL)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 1000baseT_Full);
> +	if (hw->phy.autoneg_advertised & ADVERTISE_2500_FULL)
> +		ethtool_link_ksettings_add_link_mode(cmd, advertising, 2500baseT_Full);
>  
>  	/* set autoneg settings */
>  	if (hw->mac.autoneg == 1) {
> @@ -1792,6 +1798,12 @@ igc_ethtool_set_link_ksettings(struct net_device *netdev,
>  
>  	ethtool_convert_link_mode_to_legacy_u32(&advertising,
>  						cmd->link_modes.advertising);
> +	/* Converting to legacy u32 drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT.
> +	 * We have to check this and convert it to ADVERTISE_2500_FULL
> +	 * (aka ETHTOOL_LINK_MODE_2500baseX_Full_BIT) explicitely.
> +	 */
> +	if (ethtool_link_ksettings_test_link_mode(cmd, advertising, 2500baseT_Full))
> +		advertising |= ADVERTISE_2500_FULL;
>  
>  	if (cmd->base.autoneg == AUTONEG_ENABLE) {
>  		hw->mac.autoneg = 1;
> -- 
> 2.27.0
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

