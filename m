Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B51623109
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiKIRGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKIRGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:06:08 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F835107
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668013567; x=1699549567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jUB98y9lDg/2WtNPN7G6LrAoGSJw8m7DnhcvXdCGarE=;
  b=Q/EUND/89lvH3tMF/pbbEAyGHygoBxD1z+uoQb303RlGzLaZEhot1dK4
   4Hrjs7mAdnhZP4ubGn5Ug/VEm3b+3qGysbyTDJOOM+Z3/8J7wE0MScRCT
   6d59/59/MPvj19uP9YklNkwyLtp3wxwdugm2lt1TsWKQ6l6IaTPMAEX/Y
   jJUlTCuXbV53jAuLQ3fF0iK8neiU9p8azYGAvCWH26Y0W+SzNH5QaUgF4
   E39eC6E7w0+h7mQ3pEyAiKP7U0iptAj7Q1oLQqz25adM3VZ/0ABhJ6I66
   EUbHuE9jpT5PmeszYpt0n/iLgB9EWEmatDSYWfxI/YANBp+nIJZmsTnY0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="294410410"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="294410410"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 09:05:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="614757062"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="614757062"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 09 Nov 2022 09:05:56 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A9H5tHv007416;
        Wed, 9 Nov 2022 17:05:55 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>, tirtha@gmail.com,
        magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH intel-next] i40e: allow toggling loopback mode via
Date:   Wed,  9 Nov 2022 18:02:10 +0100
Message-Id: <20221109170210.1155273-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109152016.66326-1-tirthendu.sarkar@intel.com>
References: <20221109152016.66326-1-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Date: Wed,  9 Nov 2022 20:50:16 +0530

> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> This sets the MAC Tx->Rx loopback.
> 
> This feature is used for the xsk selftests, and might have other uses
> too.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 22 +++++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 +++++++++++++++++++
>  .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
>  3 files changed, 53 insertions(+)

[...]

> @@ -13721,6 +13747,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
>  	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
>  		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
>  
> +	hw_features |= NETIF_F_LOOPBACK;
> +
>  	netdev->hw_features |= hw_features;
>  
>  	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;

So here it will be enabled by default, which shouldn't happen as it
breaks traffic flow.
Just add it directly to netdev->hw_features one line above.

> diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
> index ebdcde6f1aeb..9a71121420c3 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
> @@ -105,6 +105,9 @@ enum i40e_status_code i40e_aq_set_phy_config(struct i40e_hw *hw,
>  				struct i40e_asq_cmd_details *cmd_details);
>  enum i40e_status_code i40e_set_fc(struct i40e_hw *hw, u8 *aq_failures,
>  				  bool atomic_reset);
> +i40e_status i40e_aq_set_mac_loopback(struct i40e_hw *hw,
> +				     bool ena_lpbk,
> +				     struct i40e_asq_cmd_details *cmd_details);
>  i40e_status i40e_aq_set_phy_int_mask(struct i40e_hw *hw, u16 mask,
>  				     struct i40e_asq_cmd_details *cmd_details);
>  i40e_status i40e_aq_clear_pxe_mode(struct i40e_hw *hw,
> -- 
> 2.34.1

Thanks,
Olek
