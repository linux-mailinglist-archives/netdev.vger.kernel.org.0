Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21D2B55F4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgKQBHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgKQBHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:07:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A646B24680;
        Tue, 17 Nov 2020 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605575259;
        bh=83ws0V7Wr/b88b1q5KzzBDLsuhyTt36b0ivIgh9T4hI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l6EtXFQct8gd/EPC3M8OrGqAdFAj45/jfybKT6XOkiXFo4bO++GM+DQxNean0rgby
         GHSPBfrVZDLBSzu2uPmVjsMotgL6CTlAlEitQrktfSps3kOlBekX07z7cDCud10pKR
         jqiYgE1tUiwRm8W2faG5zEFVg9u8kDjbfcGn1fls=
Date:   Mon, 16 Nov 2020 17:07:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [net-next 1/4] i40e: add support for PTP external
 synchronization clock
Message-ID: <20201116170737.1688ebeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114001057.2133426-2-anthony.l.nguyen@intel.com>
References: <20201114001057.2133426-1-anthony.l.nguyen@intel.com>
        <20201114001057.2133426-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 16:10:54 -0800 Tony Nguyen wrote:
> From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
> 
> Add support for external synchronization clock via GPIOs.
> 1PPS signals are handled via the dedicated 3 GPIOs: SDP3_2,
> SDP3_3 and GPIO_4.
> Previously it was not possible to use the external PTP
> synchronization clock.

Please _always_ CC Richard on PTP changes.


> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index 537300e762f0..8f5eecbff3d6 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -196,6 +196,11 @@ enum i40e_fd_stat_idx {
>  #define I40E_FD_ATR_TUNNEL_STAT_IDX(pf_id) \
>  			(I40E_FD_STAT_PF_IDX(pf_id) + I40E_FD_STAT_ATR_TUNNEL)
>  
> +/* get PTP pins for ioctl */
> +#define SIOCGPINS	(SIOCDEVPRIVATE + 0)
> +/* set PTP pins for ioctl */
> +#define SIOCSPINS	(SIOCDEVPRIVATE + 1)

This is unexpected.. is it really normal to declare private device
IOCTLs to configure PPS pins? Or are you just exposing this so you're
able to play with GPIOs from user space?

>  /* The following structure contains the data parsed from the user-defined
>   * field of the ethtool_rx_flow_spec structure.
>   */
> @@ -344,7 +349,6 @@ struct i40e_ddp_old_profile_list {
>  					     I40E_FLEX_SET_FSIZE(fsize) | \
>  					     I40E_FLEX_SET_SRC_WORD(src))
>  
> -

Please move all the empty line removal to a separate patch.

>  #define I40E_MAX_FLEX_SRC_OFFSET 0x1F
>  
>  /* macros related to GLQF_ORT */

> @@ -2692,7 +2692,15 @@ int i40e_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
>  	case SIOCGHWTSTAMP:
>  		return i40e_ptp_get_ts_config(pf, ifr);
>  	case SIOCSHWTSTAMP:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;

If you needed this, this should be a fix for net. But you don't, core
checks it.

>  		return i40e_ptp_set_ts_config(pf, ifr);
> +	case SIOCSPINS:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EACCES;
> +		return i40e_ptp_set_pins_ioctl(pf, ifr);
> +	case SIOCGPINS:
> +		return i40e_ptp_get_pins(pf, ifr);
>  	default:
>  		return -EOPNOTSUPP;
>  	}
