Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA5628408
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiKNPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbiKNPey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:34:54 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EF6A449
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668440093; x=1699976093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJkfJRZR7K95nUyNsR9cwriGa3huIpyA2BFQHIESubU=;
  b=ixUNJwhW7aK62gf0hibAXYGUKkkv6s1z0vwHZSMlkB/F4gf1XG9iqCDv
   bTrMKE2J+sVQYm7AZTMnpEIA0MUsT8y+u+JeTEQCRKm60chO57GHw151h
   swUzjTTQNPjPId/Zl1cr1MNUcJPRLqv5qrEd4UDjFhRwZBXlMfplYo/CN
   93gt8Pn0a6Pt8w8gfiUxo0OcR9WNFWabuuyycdSu1Y7FVSF7heYLfxAKC
   EzJoV/FyPpWkbMIpKQTNCjzUMfrr40Rx7dXEct+Ljl8ar2nCdFRgb9Jxx
   ssKlfuwqh++qzNmSqYOMLcq7c6uPmnf9w6q/26tDAts4bX5wCjA6mbof/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295362460"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295362460"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:34:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="967611174"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="967611174"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 14 Nov 2022 07:34:51 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEFYo5q029686;
        Mon, 14 Nov 2022 15:34:51 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Date:   Mon, 14 Nov 2022 16:34:38 +0100
Message-Id: <20221114153438.703209-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-2-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Tue,  8 Nov 2022 19:19:03 +0800

> From: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> Add to get media type and physical layer module, support I2C access.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---

[...]

> @@ -277,11 +647,30 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
>  	struct wx_hw *wxhw = &hw->wxhw;
>  	int status;
>  
> +	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
> +	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
> +	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
> +	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;

Please merge this with the first declaration block, there must be
only one.
Also, are you sure you need all this simultaneously? Maybe reuse
some of them?

> +
>  	/* Call adapter stop to disable tx/rx and clear interrupts */
>  	status = wx_stop_adapter(wxhw);
>  	if (status != 0)
>  		return status;
>  
> +	/* Identify PHY and related function pointers */

[...]

> +	if (!hw->phy.orig_link_settings_stored) {
> +		hw->phy.orig_sr_pcs_ctl2 = sr_pcs_ctl;
> +		hw->phy.orig_sr_pma_mmd_ctl1 = sr_pma_mmd_ctl1;
> +		hw->phy.orig_sr_an_mmd_ctl = sr_an_mmd_ctl;
> +		hw->phy.orig_sr_an_mmd_adv_reg2 = sr_an_mmd_adv_reg2;
> +		hw->phy.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
> +						vr_xs_or_pcs_mmd_digi_ctl1;
> +		hw->phy.orig_link_settings_stored = true;
> +	} else {
> +		hw->phy.orig_sr_pcs_ctl2 = curr_sr_pcs_ctl;
> +		hw->phy.orig_sr_pma_mmd_ctl1 = curr_sr_pma_mmd_ctl1;
> +		hw->phy.orig_sr_an_mmd_ctl = curr_sr_an_mmd_ctl;
> +		hw->phy.orig_sr_an_mmd_adv_reg2 =
> +					curr_sr_an_mmd_adv_reg2;
> +		hw->phy.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
> +					curr_vr_xs_or_pcs_mmd_digi_ctl1;
> +	}
> +
> +	/*make sure phy power is up*/
> +	msleep(100);

Can we poll something to check if it is up already? 100 ms is a ton,
I would try to avoid such huge sleeps if possible.

> +
>  	/* Store the permanent mac address */
>  	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);

[...]

> -- 
> 2.38.1

Thanks,
Olek
