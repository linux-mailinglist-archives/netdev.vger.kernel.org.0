Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2EB63685B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbiKWSOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 13:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiKWSNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 13:13:49 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D9DC67C0;
        Wed, 23 Nov 2022 10:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669227019; x=1700763019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t/23rNgY8Q9RGRSPf2krv88SYbO32lpe4ZQwFdkeaYg=;
  b=CG46AJhPXCPAR2wUFzaB4AuvKjyHRjjKVF1TNkS3924l/OorMVNSkE6V
   OZzMrZIS1YxWqfhUNkcRgygESpxxsj3cJGUFx78WAUjnpvZEkulglvrNC
   /GWV0qfGOK3NQX7N5RSaYCqvUrB9crG8EHFnCpPKjw2PcIVQL2zQWa4VA
   GTZTXSFV89IsWunZSVcxhlbD0FS9M8QOvDAbkHLP4LpcZg83GBsUH970i
   bf/iZl54Qdh2g+YYudS8drSRL0O8wj65HMKwK2sfFo9g/ZOg1RGMRpZeq
   t0JeTzMO2ZK2biblkZR5TdJe8n701XsUvoeHmBMyRuX18aTUQ0V4R2jjU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297490196"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297490196"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 10:10:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="784334985"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784334985"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 10:10:15 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANIADgi031036;
        Wed, 23 Nov 2022 18:10:13 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: Re: [PATCH net v3] net: stmmac: Set MAC's flow control register to reflect current settings
Date:   Wed, 23 Nov 2022 19:09:47 +0100
Message-Id: <20221123180947.488302-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123091529.22018-1-wei.sheng.goh@intel.com>
References: <20221123091529.22018-1-wei.sheng.goh@intel.com>
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

From: "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Date: Wed, 23 Nov 2022 17:15:29 +0800

> Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
> correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
> is issued. This fix ensures the flow control change is reflected directly
> in the GMAC_RX_FLOW_CTRL_RFE register.
> 
> Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> V2 -> V3: Removed value assign for 'flow' in else statement based on review comments
> V1 -> V2: Removed needless condition based on review comments
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 ++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> index c25bfecb4a2d..369db308b1dd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
> @@ -748,6 +748,8 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
>  	if (fc & FLOW_RX) {
>  		pr_debug("\tReceive Flow-Control ON\n");
>  		flow |= GMAC_RX_FLOW_CTRL_RFE;
> +	} else {
> +		pr_debug("\tReceive Flow-Control OFF\n");

Doesn't belong the commit subject. Debug improvements usually are
-next material.
Also, don't use pr_*() when netdev_*(), pci_*() or dev_*() are
available. You won't understand which interface wrote this to the
kernel log currently.

>  	}
>  	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8273e6a175c8..ab7f48f32f5b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1061,8 +1061,16 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>  		ctrl |= priv->hw->link.duplex;
>  
>  	/* Flow Control operation */
> -	if (tx_pause && rx_pause)
> -		stmmac_mac_flow_ctrl(priv, duplex);
> +	if (rx_pause && tx_pause)
> +		priv->flow_ctrl = FLOW_AUTO;
> +	else if (rx_pause && !tx_pause)
> +		priv->flow_ctrl = FLOW_RX;
> +	else if (!rx_pause && tx_pause)
> +		priv->flow_ctrl = FLOW_TX;
> +	else
> +		priv->flow_ctrl = FLOW_OFF;

	priv->flow_ctrl = FLOW_OFF;
	if (rx_pause)
		priv->flow_ctrl |= FLOW_RX;
	if (tx_pause)
		priv->flow_ctrl |= FLOW_TX;

100% identical functionally.

> +
> +	stmmac_mac_flow_ctrl(priv, duplex);
>  
>  	if (ctrl != old_ctrl)
>  		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
> -- 
> 2.17.1

Thanks,
Olek
