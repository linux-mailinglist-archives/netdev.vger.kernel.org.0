Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6C235A9CE
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 03:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhDJBAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 21:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJBAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 21:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17356610CC;
        Sat, 10 Apr 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618016409;
        bh=BfO3ycVU6R2z/SMgva6CTWPu0uE2G45hrfgdRoXMPII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q+tTw8zRoTOCnrnRNxpb2gdExP0wVd4iHeJVn2yS7Ja2f8XP1MobA7PhKtVhoNYCq
         GMu8F1NcLQ7oFyePjAnBoWQZolks6sWARhILStGpmnDmsxthJ9X9has9pAvagQtZax
         vGoEHRzQbAcfDqh9yQ0OUaaROpa4TyHNi4th9GQ2kHCZi15b1IrEBIpBrHfLj7I/bN
         aA/cwzlHS5N8Dl4MUxhmjLACeBHxuX/XFot+/UKEULfVVT56gMoOK8Jb1uxGVGjBCU
         hbx/nDBhbBo4CghYm73gt6NQ6xfX9rwQdSxA7ZMXW06JSzzZsOOkpJJVcodELImp65
         kOcekSX0AurVA==
Date:   Fri, 9 Apr 2021 18:00:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Radoslaw Tyl <radoslawx.tyl@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 2/4] ixgbe: aggregate of all receive errors
 through netdev's rx_errors
Message-ID: <20210409180008.1f23bb7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409190314.946192-3-anthony.l.nguyen@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
        <20210409190314.946192-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 12:03:12 -0700 Tony Nguyen wrote:
> From: Radoslaw Tyl <radoslawx.tyl@intel.com>
> 
> The global rx error does not take into account all the error counters
> that are counted by device.
> 
> Extend rx error with the following counters:
> - illegal byte error
> - number of receive fragment errors
> - receive jabber
> - receive oversize error
> - receive undersize error
> - frames marked as checksum invalid by hardware
> 
> The above were added in order to align statistics with other products.
> 
> Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 7ba1c2985ef7..7711828401d9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -7240,12 +7240,21 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
>  	hwstats->ptc1023 += IXGBE_READ_REG(hw, IXGBE_PTC1023);
>  	hwstats->ptc1522 += IXGBE_READ_REG(hw, IXGBE_PTC1522);
>  	hwstats->bptc += IXGBE_READ_REG(hw, IXGBE_BPTC);
> +	hwstats->illerrc += IXGBE_READ_REG(hw, IXGBE_ILLERRC);
>  
>  	/* Fill out the OS statistics structure */
>  	netdev->stats.multicast = hwstats->mprc;
>  
>  	/* Rx Errors */
> -	netdev->stats.rx_errors = hwstats->crcerrs + hwstats->rlec;
> +	netdev->stats.rx_errors = hwstats->crcerrs +
> +				    hwstats->illerrc +
> +				    hwstats->rlec +
> +				    hwstats->rfc +
> +				    hwstats->rjc +
> +				    hwstats->roc +
> +				    hwstats->ruc +

IDK what the HW counts exactly but perhaps rlec includes other
counters? Note that the stats you add with this patch are RFC 2819 /
RMON counters, and AFAIU they overlap with IEEE counters.

If the RMON counters are somehow exclusively counting their events you
should update rx_length_errors as well.

> +				    hw_csum_rx_error;

AFAICT this is incorrect L4 csum, that's not supposed be counted as NIC
rx_error. Let the appropriate protocol code check this and increment
its own counter.

>  	netdev->stats.rx_dropped = 0;
>  	netdev->stats.rx_length_errors = hwstats->rlec;
>  	netdev->stats.rx_crc_errors = hwstats->crcerrs;

