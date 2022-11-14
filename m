Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83239628455
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiKNPsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiKNPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:48:30 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481B9BF6E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668440909; x=1699976909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a8/DfVVZ7jKQ41JobXRUGMrhJQPWwmHLiK6Wbp8uIi4=;
  b=m2qBsdMKJnYO00H7R9jsZhj/R+j8jThp9EgdOylPauCCFVVygsJ2k2sI
   BeAG5WR7lyg/z2jEd2xAP7svppmaQG9cjNG/yCNk0mL5W8yRV4aKcx+qC
   7I8wguv28ifeRNMfL+iFq32WzxJHmXbOfZRR8r3pSEb9PvNnO2AdkIwuY
   +Z1TF5hDoWH2pEtgmVA+E5lDMqK3BL4x7DC5QDyIxBUJjQwfQMlAO31YA
   uhBECR9Vqq8lMfoEeDEFoMU5QuVAKJu7xsq2gX+GfvsQY/CdLQ2sKG/76
   z5nkyN4391cQN9eFwDoiXZfPolqEzfjA5sAAQ69Jxd2D4kT48TjRan3fS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313807151"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="313807151"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:48:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702051015"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702051015"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 07:48:27 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEFmQq2031520;
        Mon, 14 Nov 2022 15:48:26 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 3/5] net: txgbe: Support to setup link
Date:   Mon, 14 Nov 2022 16:48:24 +0100
Message-Id: <20221114154824.704046-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-4-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-4-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Tue,  8 Nov 2022 19:19:05 +0800

> From: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> Get link capabilities, setup MAC and PHY link, and support to enable
> or disable Tx laser.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
> 
> [...]
> 
> @@ -46,6 +55,13 @@ struct txgbe_adapter {
>  	struct timer_list service_timer;
>  	struct work_struct service_task;
>  
> +	u32 flags;
> +
> +	bool link_up;

Use can reuse the previous field flags to store link status.

Also pls try to avoid placing bools in structures, there are lots of
discussions around it and how compilers place/declare them, but
better to know for sure it would work the same way on each setup,
right?

> +	u32 link_speed;
> +	unsigned long sfp_poll_time;
> +	unsigned long link_check_timeout;
> +
>  	/* structs defined in txgbe_type.h */
>  	struct txgbe_hw hw;
>  	u16 msg_enable;

[...]

> @@ -188,11 +280,22 @@ struct txgbe_phy_info {
>  	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
>  	bool orig_link_settings_stored;
>  	bool multispeed_fiber;
> +	bool autotry_restart;

Could be also one u32, e.g. via bitfields:

	u32 orig_link_settings_stored:1;
	u32 multispeed_fiber:1;
	u32 autotry_restart:1;

There will be 29 free slots more here then for new flags.

> +	u32 autoneg_advertised;
> +	u32 link_mode;
> +};
> +
> +/* link status for KX/KX4 */
> +enum txgbe_link_status {
> +	TXGBE_LINK_STATUS_NONE = 0,
> +	TXGBE_LINK_STATUS_KX,
> +	TXGBE_LINK_STATUS_KX4
>  };
>  
>  struct txgbe_hw {
>  	struct wx_hw wxhw;
>  	struct txgbe_phy_info phy;
> +	enum txgbe_link_status link_status;
>  };
>  
>  #endif /* _TXGBE_TYPE_H_ */
> -- 
> 2.38.1

Thanks,
Olek
