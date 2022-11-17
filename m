Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA0962E14E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbiKQQQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240112AbiKQQQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:16:00 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EAB74A85
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668701758; x=1700237758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5v3zHBia4Ks3Qtrh/XRhhD0ZANV2CcggzZB25D8knjE=;
  b=QKX/HGEmyz2Nev5XXh73s0px9iRY2wVCr11+hL0kuY+JUwNpCc0lIAEt
   UtV0Vif0+qQSLHb+gHoAx9PXGUQQiAwgcYHeqGHirmgDlA9fBSFM+DoeO
   dE8M2dEocIVL6bKLkCJbGsXwdnd/3gNBNs4sxRHxOSCkmo8SSEnkqJG1y
   ASf4CQZoHl+dltANOkyo+mYpPBrRQ8TPoJg1tvcesSXFDPrF7MhTHofqc
   WCEc7er1h2bKokDuZIAj9D0XCRpbHBiPLyUzVSpEEJV+tvpXMY7PkvpeU
   d/6IFyUPKuispFgaPQqqs6/puTzcekRU598MuiQgf2Xz1p9BWsQvlk72E
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="314709319"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="314709319"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 08:15:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="745597938"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="745597938"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 17 Nov 2022 08:15:55 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AHGFsgg004324;
        Thu, 17 Nov 2022 16:15:54 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, tirtha@gmail.com,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH intel-next v3] i40e: allow toggling loopback mode via ndo_set_features callback
Date:   Thu, 17 Nov 2022 17:15:18 +0100
Message-Id: <20221117161518.3450087-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116164709.9201-1-tirthendu.sarkar@intel.com>
References: <20221116164709.9201-1-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Date: Wed, 16 Nov 2022 22:17:09 +0530

> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> This sets the MAC Tx->Rx loopback.
> 
> This feature is used for the xsk selftests, and might have other uses
> too.
> 
> Changelog:
>     v2 -> v3:
>      - Fixed loopback macros as per NVM version 6.01+.
>      - Renamed existing macros as *_LEGACY
>      - Based on NVM verison appropriate macro is used for MAC loopback.
> 
>     v1 -> v2:
>      - Moved loopback to netdev's hardware features as suggested by
>        Alexandr Lobakin.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  .../net/ethernet/intel/i40e/i40e_adminq_cmd.h | 10 +++++--
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 26 +++++++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 ++++++++++++++++++-
>  .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
>  4 files changed, 63 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> index 60f9e0a6aaca..7532553a6982 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
> @@ -1795,9 +1795,13 @@ I40E_CHECK_CMD_LENGTH(i40e_aqc_an_advt_reg);
>  /* Set Loopback mode (0x0618) */
>  struct i40e_aqc_set_lb_mode {
>  	__le16	lb_mode;
> -#define I40E_AQ_LB_PHY_LOCAL	0x01
> -#define I40E_AQ_LB_PHY_REMOTE	0x02
> -#define I40E_AQ_LB_MAC_LOCAL	0x04
> +#define I40E_LEGACY_LOOPBACK_NVM_VER	0x6000
> +#define I40E_AQ_LB_MAC_LOCAL		0x01
> +#define I40E_AQ_LB_PHY_LOCAL		0x05
> +#define I40E_AQ_LB_PHY_REMOTE		0x06
> +#define I40E_AQ_LB_PHY_LOCAL_LEGACY   	0x01
> +#define I40E_AQ_LB_PHY_REMOTE_LEGACY  	0x02
> +#define I40E_AQ_LB_MAC_LOCAL_LEGACY   	0x04

Do you need any of those, apart from MAC_LOCAL{,_LEGACY}? I think
it's better to keep only the values you actually use.

>  	u8	reserved[14];
>  };
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
> index 4f01e2a6b6bb..8f764ff5c990 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_common.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
> @@ -1830,6 +1830,32 @@ i40e_status i40e_aq_set_phy_int_mask(struct i40e_hw *hw,
>  	return status;
>  }
>  
> +/**
> + * i40e_aq_set_mac_loopback
> + * @hw: pointer to the HW struct
> + * @ena_lpbk: Enable or Disable loopback
> + * @cmd_details: pointer to command details structure or NULL
> + *
> + * Enable/disable loopback on a given port
> + */
> +i40e_status i40e_aq_set_mac_loopback(struct i40e_hw *hw, bool ena_lpbk,
> +				     struct i40e_asq_cmd_details *cmd_details)
> +{
> +	struct i40e_aq_desc desc;
> +	struct i40e_aqc_set_lb_mode *cmd =
> +		(struct i40e_aqc_set_lb_mode *)&desc.params.raw;
> +
> +	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_set_lb_modes);
> +	if (ena_lpbk) {
> +		if (hw->nvm.version <= I40E_LEGACY_LOOPBACK_NVM_VER)
> +			cmd->lb_mode = cpu_to_le16(I40E_AQ_LB_MAC_LOCAL_LEGACY);
> +		else
> +			cmd->lb_mode = cpu_to_le16(I40E_AQ_LB_MAC_LOCAL);
> +	}
> +
> +	return i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
> +}
> +
>  /**
>   * i40e_aq_set_phy_debug
>   * @hw: pointer to the hw struct
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 4880b740fa6e..1941715b6223 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -12920,6 +12920,28 @@ static void i40e_clear_rss_lut(struct i40e_vsi *vsi)
>  	}
>  }
>  
> +/**
> + * i40e_set_loopback - turn on/off loopback mode on underlying PF
> + * @vsi: ptr to VSI
> + * @ena: flag to indicate the on/off setting
> + */
> +static int i40e_set_loopback(struct i40e_vsi *vsi, bool ena)
> +{
> +	bool if_running = netif_running(vsi->netdev);
> +	int ret;
> +
> +	if (if_running && !test_and_set_bit(__I40E_VSI_DOWN, vsi->state))
> +		i40e_down(vsi);
> +
> +	ret = i40e_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
> +	if (ret)
> +		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
> +	if (if_running)
> +		i40e_up(vsi);

You do i40e_down() only if %__I40E_VSI_DOWN was not set. So I guess
you need to do ifup only if you did ifdown. So I think the function
start must be a bit differen? Like:

	if (if_running && !test_and_set_bit())
		i40e_down();
	else
		if_running = false;

To not do an ifup when it wasn't you who did an ifdown?

> +
> +	return ret;
> +}
> +
>  /**
>   * i40e_set_features - set the netdev feature flags
>   * @netdev: ptr to the netdev being adjusted
> @@ -12960,6 +12982,10 @@ static int i40e_set_features(struct net_device *netdev,
>  	if (need_reset)
>  		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
>  
> +	if (netdev->hw_features & NETIF_F_LOOPBACK)

Isn't that condition redundant? I think you add %NETIF_F_LOOPBACK
to ::hw_features unconditionally, it's always there?

> +		if (i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK)))

The double negation is redundant as the second argument is bool.

> +			return -EINVAL;

Why don't you propagate return value from i40e_set_loopback() and
return only 0 or -%EINVAL? If you don't need the actual return code,
just make set_loopback() return bool, otherwise

	if (changed_features & NETIF_F_LOOPBACK)
		return i40e_set_loopback(vsi, features & NETIF_F_LOOPBACK);

	return 0;

> +
>  	return 0;
>  }

[...]

> -- 
> 2.34.1

Thanks,
Olek
