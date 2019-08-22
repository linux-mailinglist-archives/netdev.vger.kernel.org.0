Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C9199687
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbfHVO2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:28:10 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43872 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731487AbfHVO2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fg0ublZzgw0A5Szj0n+RkN+2zqyaQU5CTNzjkTpcOJ8=; b=rCPArFXYhmfM98sv0h9BelJSm
        tbLpRAGrRGuQ3+j/EAJjtdH6ZkCsUUaoDtmTMMxj6z5sF9GJkzLhO2vNR06oxoTYCmTOzM73rRrfr
        axkoasy9w9Yot1Q5SnpyRIdAyUDkhwOzUJ9xUFvEAEZR2U3clyZB6xvJFg9iL53Ms8AGzesHd0GLw
        kbYuB6Kff4HYqNQni9GCj/Wkr+JELdcecTABRBjmfS+P8tw8aZgxh6M2Rp+OdDzfvhhJTYhicfeVE
        owyJGvIEzxW0IXGZmfjzojfLYd/fpHEC6q36/hgE0wG78WGF7yYfn/BqeI5t1nEEWRvCHlpW/+Y9N
        7JzH9RBNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59702)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i0o43-00078p-7T; Thu, 22 Aug 2019 15:27:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i0o3w-0007kt-33; Thu, 22 Aug 2019 15:27:40 +0100
Date:   Thu, 22 Aug 2019 15:27:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, Stefan Roese <sr@denx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: mediatek: Add basic
 PHYLINK support
Message-ID: <20190822142739.GS13294@shell.armlinux.org.uk>
References: <20190821144336.9259-1-opensource@vdorst.com>
 <20190821144336.9259-2-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821144336.9259-2-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 04:43:34PM +0200, René van Dorst wrote:
> +static void mtk_mac_link_down(struct phylink_config *config, unsigned int mode,
> +			      phy_interface_t interface)
> +{
> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
> +					   phylink_config);
>  
> -	return 0;
> +	mtk_w32(mac->hw, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(mac->id));
>  }

You set the MAC_MCR_FORCE_MODE bit here...

> +static void mtk_mac_link_up(struct phylink_config *config, unsigned int mode,
> +			    phy_interface_t interface,
> +			    struct phy_device *phy)
>  {
> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
> +					   phylink_config);
> +	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  
> +	mcr |= MAC_MCR_TX_EN | MAC_MCR_RX_EN;
> +	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
> +}

Looking at this, a link_down() followed by a link_up() would result in
this register containing MAC_MCR_FORCE_MODE | MAC_MCR_TX_EN |
MAC_MCR_RX_EN ?  Is that actually correct?  (MAC_MCR_FORCE_LINK isn't
set, so it looks to me like it still forces the link down.)

Note that link up/down forcing should not be done for in-band AN.

> +static void mtk_validate(struct phylink_config *config,
> +			 unsigned long *supported,
> +			 struct phylink_link_state *state)
> +{
> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
> +					   phylink_config);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    state->interface != PHY_INTERFACE_MODE_MII &&
> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> +	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII) &&
> +	      phy_interface_mode_is_rgmii(state->interface)) &&
> +	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) &&
> +	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII)) {
> +		linkmode_zero(supported);
> +		return;
>  	}
>  
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Autoneg);
>  
> +	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +	} else {
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +
> +		if (state->interface != PHY_INTERFACE_MODE_MII) {
> +			phylink_set(mask, 1000baseT_Half);
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +		}
> +	}
>  
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
>  
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
>  }

This looks fine.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
