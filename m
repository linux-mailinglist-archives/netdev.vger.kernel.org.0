Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8599736
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbfHVOot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:44:49 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44126 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732378AbfHVOos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ups/VrVzSUhhwl/GEM5YSxWOiDm7bA4AN942AhbRqwo=; b=sQhrwnvpafZLPmo5FsdfINJTy
        gqrWQhb1Z+5QCrEIDeMoEi3SdBeRlQ0v769zMUgIPnlfHp+R1toUOanWZs4j4fAgaJJx1+1pNN3Pk
        sNHT4ZUjpanIjfQnjDQrwSSarOzK6SevySl9bvgFrqzO6breQcO9593EEUjk1JNQrOqUxmxuFJU0c
        TpuUduJ3+r+cF0iBFl5sEupcoYvbP5YoYJ3FOfWGLzUpxFTU5tFekqHvRaVXIpVmTTl0GqkOdI5eb
        pqV3DqYa6AYnAb68AilWTr+NCyLz1cmjlmYN/zsAZnyRurU3lp3eQ/w5Z3yHwvYigqb2Bblzib3XI
        tYyrEZhDg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48060)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i0oKL-0007ES-Kj; Thu, 22 Aug 2019 15:44:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i0oKH-0007m8-RC; Thu, 22 Aug 2019 15:44:33 +0100
Date:   Thu, 22 Aug 2019 15:44:33 +0100
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
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: mediatek: Re-add support
 SGMII
Message-ID: <20190822144433.GT13294@shell.armlinux.org.uk>
References: <20190821144336.9259-1-opensource@vdorst.com>
 <20190821144336.9259-3-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821144336.9259-3-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 04:43:35PM +0200, René van Dorst wrote:
> +	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
> +		if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
>  			phylink_set(mask, 1000baseT_Full);
>  			phylink_set(mask, 1000baseX_Full);
> +		} else {
> +			phylink_set(mask, 2500baseT_Full);
> +			phylink_set(mask, 2500baseX_Full);
> +		}

If you can dynamically switch between 1000BASE-X and 2500BASE-X, then
you need to have both set.  See mvneta.c:

        if (pp->comphy || state->interface != PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 1000baseT_Full);
                phylink_set(mask, 1000baseX_Full);
        }
        if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
                phylink_set(mask, 2500baseT_Full);
                phylink_set(mask, 2500baseX_Full);
        }

What this is saying is, if we have a comphy (which is the serdes lane
facing component, where the data rate is setup) then we can support
both speeds (and so mask ends up with all four bits set.)  Otherwise,
we only support a single-speed (1000Gbps for non-2500BASE-X etc.)

> +	} else {
> +		if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
> +			phylink_set(mask, 1000baseT_Full);
> +		} else {
> +			phylink_set(mask, 10baseT_Half);
> +			phylink_set(mask, 10baseT_Full);
> +			phylink_set(mask, 100baseT_Half);
> +			phylink_set(mask, 100baseT_Full);
> +
> +			if (state->interface != PHY_INTERFACE_MODE_MII) {
> +				phylink_set(mask, 1000baseT_Half);
> +				phylink_set(mask, 1000baseT_Full);
> +				phylink_set(mask, 1000baseX_Full);
> +			}

I'm also wondering about the "MTK_HAS_CAPS(mac->hw->soc->caps,
MTK_SGMII)" above.

(Here comes a reason why using SGMII to cover all single-lane serdes
modes causes confusion - unfortunately, some folk use SGMII to describe
all these modes.  So, I'm going to use the terminology "Cisco SGMII"
to mean exactly the SGMII format published by Cisco, "802.3 1000BASE-X"
to mean the original IEEE 802.3 format running at 1.25Gbps, and
"up-clocked 2500BASE-X" to mean the 3.125Gbps version of the 802.3
1000BASE-X protocol.)

Isn't this set for Cisco SGMII as well as for 802.3 1000BASE-X and
the up-clocked 2500BASE-X modes?

If so, is there a reason why 10Mbps and 100Mbps speeds aren't
supported on Cisco SGMII links?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
