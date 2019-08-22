Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4FD997CF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389454AbfHVPLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 11:11:20 -0400
Received: from mx.0dd.nl ([5.2.79.48]:57788 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387755AbfHVPLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 11:11:19 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id CC0475FC44;
        Thu, 22 Aug 2019 17:11:16 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="dYtNjIu0";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 793D71D85FE6;
        Thu, 22 Aug 2019 17:11:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 793D71D85FE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566486676;
        bh=pWtXsRVEPvLed/m0NhhlKu1CLza7De9LHyjrNdYZbdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dYtNjIu04is6DPPpcRUqOnSHBRAWJuENhjamzlkFcc69mGO3UfQ3rsngHuva405Ha
         Sf5D+/HMAqHmafBNG8I9vTUaW1SbS+dtuyQPKaqOEwzoP+22izycD/C2tswjAIR9A8
         z4YKAjK0nuAEI1H0+0Mk7BEakNXjYBNeM5QDi79kZSKYlaquhliHINULslkHDOW2aI
         c4/YqK5inUtYUUTbx5tmLY0lheFwhmR28bcfPzcQMTIqHRgOayJpgCQbp62D9Q9sHW
         +pgb9NVMHtGsvrCejRaJDOJF/5b0maqGgeBus9yWOdWZRepvuqnmewN04zsKY/7BzC
         wH5MogCvoHYew==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Thu, 22 Aug 2019 15:11:16 +0000
Date:   Thu, 22 Aug 2019 15:11:16 +0000
Message-ID: <20190822151116.Horde.3pVh2Kr0MEO82EWm7859Zd2@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
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
References: <20190821144336.9259-1-opensource@vdorst.com>
 <20190821144336.9259-2-opensource@vdorst.com>
 <20190822142739.GS13294@shell.armlinux.org.uk>
In-Reply-To: <20190822142739.GS13294@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Wed, Aug 21, 2019 at 04:43:34PM +0200, René van Dorst wrote:
>> +static void mtk_mac_link_down(struct phylink_config *config,  
>> unsigned int mode,
>> +			      phy_interface_t interface)
>> +{
>> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
>> +					   phylink_config);
>>
>> -	return 0;
>> +	mtk_w32(mac->hw, MAC_MCR_FORCE_LINK_DOWN, MTK_MAC_MCR(mac->id));
>>  }
>
> You set the MAC_MCR_FORCE_MODE bit here...
>
>> +static void mtk_mac_link_up(struct phylink_config *config,  
>> unsigned int mode,
>> +			    phy_interface_t interface,
>> +			    struct phy_device *phy)
>>  {
>> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
>> +					   phylink_config);
>> +	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>>
>> +	mcr |= MAC_MCR_TX_EN | MAC_MCR_RX_EN;
>> +	mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
>> +}
>
> Looking at this, a link_down() followed by a link_up() would result in
> this register containing MAC_MCR_FORCE_MODE | MAC_MCR_TX_EN |
> MAC_MCR_RX_EN ?  Is that actually correct?  (MAC_MCR_FORCE_LINK isn't
> set, so it looks to me like it still forces the link down.)

Thanks for reviewing.

Probably not.
I assumed that mac_config() is always called before link_up()

I simply can make it the opposite of link_up()

like this:
static void mtk_mac_link_down(struct phylink_config *config, unsigned  
int mode,
                               phy_interface_t interface)
{
       struct mtk_mac *mac = container_of(config, struct mtk_mac,
                                  phylink_config);
       u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));

       mcr &= (MAC_MCR_TX_EN | MAC_MCR_RX_EN);
       mtk_w32(mac->hw, mcr, MTK_MAC_MCR(mac->id));
}

>
> Note that link up/down forcing should not be done for in-band AN.
>

This means that mac_config() of the SGMII patch is also incorrect?

mac_config() always sets the MAC in a force mode.
But the SGMII block is set in AN.

Mainline code seems to do the same.
Puts the SGMII block in AN or forced mode and always set the MAC in  
forced mode.

>> +static void mtk_validate(struct phylink_config *config,
>> +			 unsigned long *supported,
>> +			 struct phylink_link_state *state)
>> +{
>> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
>> +					   phylink_config);
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>>
>> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
>> +	    state->interface != PHY_INTERFACE_MODE_MII &&
>> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
>> +	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_RGMII) &&
>> +	      phy_interface_mode_is_rgmii(state->interface)) &&
>> +	    !(MTK_HAS_CAPS(mac->hw->soc->caps, MTK_TRGMII) &&
>> +	      !mac->id && state->interface == PHY_INTERFACE_MODE_TRGMII)) {
>> +		linkmode_zero(supported);
>> +		return;
>>  	}
>>
>> +	phylink_set_port_modes(mask);
>> +	phylink_set(mask, Autoneg);
>>
>> +	if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
>> +		phylink_set(mask, 1000baseT_Full);
>> +	} else {
>> +		phylink_set(mask, 10baseT_Half);
>> +		phylink_set(mask, 10baseT_Full);
>> +		phylink_set(mask, 100baseT_Half);
>> +		phylink_set(mask, 100baseT_Full);
>> +
>> +		if (state->interface != PHY_INTERFACE_MODE_MII) {
>> +			phylink_set(mask, 1000baseT_Half);
>> +			phylink_set(mask, 1000baseT_Full);
>> +			phylink_set(mask, 1000baseX_Full);
>> +		}
>> +	}
>>
>> +	phylink_set(mask, Pause);
>> +	phylink_set(mask, Asym_Pause);
>>
>> +	linkmode_and(supported, supported, mask);
>> +	linkmode_and(state->advertising, state->advertising, mask);
>>  }
>
> This looks fine.

OK.

> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Greats,

René


