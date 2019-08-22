Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9F9A07B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfHVTuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:50:40 -0400
Received: from mx.0dd.nl ([5.2.79.48]:58488 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbfHVTuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 15:50:39 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 6B52F5FC44;
        Thu, 22 Aug 2019 21:50:33 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="sGYPkcV9";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 0DD7B1D86FCC;
        Thu, 22 Aug 2019 21:50:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 0DD7B1D86FCC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566503433;
        bh=LjRruTF0hUMFvK2uGE5RnytC6AgYmuenDz6R68xhRik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGYPkcV9fmCnpgvWArSMG24obibm7EhdIhj6zFao2ORYC5m1Qys4QivQC7HEMIzJt
         W1W+jUlFZCSgYclOf9Ocf1Fx8NFe1qM3oF6Z1Hs/y26TeE3/Xcv/BOBPGDiB6xBGNQ
         T1Snx58ome1+G0ukthjyNzuGjrwQjpXVu6TDMOlBmMuJon0ChZPvRMDGcQT0tQcN2g
         xRw1nwwBQkMH6fL/DcKZG6zVz3I8UwHaeYihVuCfO+/MurddtloHhqsOl3Fwszcz7g
         3h+bWKRP8qkG0EiOrDOoH7lPBzxHKL/3iwhhMFkjXbRYKdYHpxuQsrnu+Luz8XzTvy
         re6kVoPAuf+LA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Thu, 22 Aug 2019 19:50:33 +0000
Date:   Thu, 22 Aug 2019 19:50:33 +0000
Message-ID: <20190822195033.Horde.hEW8FBGNfFrugQOCv0gaDfx@www.vdorst.com>
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
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: mediatek: Re-add support
 SGMII
References: <20190821144336.9259-1-opensource@vdorst.com>
 <20190821144336.9259-3-opensource@vdorst.com>
 <20190822144433.GT13294@shell.armlinux.org.uk>
In-Reply-To: <20190822144433.GT13294@shell.armlinux.org.uk>
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

> On Wed, Aug 21, 2019 at 04:43:35PM +0200, René van Dorst wrote:
>> +	if (MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII)) {
>> +		if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
>>  			phylink_set(mask, 1000baseT_Full);
>>  			phylink_set(mask, 1000baseX_Full);
>> +		} else {
>> +			phylink_set(mask, 2500baseT_Full);
>> +			phylink_set(mask, 2500baseX_Full);
>> +		}
>
> If you can dynamically switch between 1000BASE-X and 2500BASE-X, then
> you need to have both set.  See mvneta.c:
>
>         if (pp->comphy || state->interface != PHY_INTERFACE_MODE_2500BASEX) {
>                 phylink_set(mask, 1000baseT_Full);
>                 phylink_set(mask, 1000baseX_Full);
>         }
>         if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
>                 phylink_set(mask, 2500baseT_Full);
>                 phylink_set(mask, 2500baseX_Full);
>         }
>
> What this is saying is, if we have a comphy (which is the serdes lane
> facing component, where the data rate is setup) then we can support
> both speeds (and so mask ends up with all four bits set.)  Otherwise,
> we only support a single-speed (1000Gbps for non-2500BASE-X etc.)
>
>> +	} else {
>> +		if (state->interface == PHY_INTERFACE_MODE_TRGMII) {
>> +			phylink_set(mask, 1000baseT_Full);
>> +		} else {
>> +			phylink_set(mask, 10baseT_Half);
>> +			phylink_set(mask, 10baseT_Full);
>> +			phylink_set(mask, 100baseT_Half);
>> +			phylink_set(mask, 100baseT_Full);
>> +
>> +			if (state->interface != PHY_INTERFACE_MODE_MII) {
>> +				phylink_set(mask, 1000baseT_Half);
>> +				phylink_set(mask, 1000baseT_Full);
>> +				phylink_set(mask, 1000baseX_Full);
>> +			}
>
> I'm also wondering about the "MTK_HAS_CAPS(mac->hw->soc->caps,
> MTK_SGMII)" above.

This totally wrong.
MTK_HAS_CAPS(mac->hw->soc->caps, MTK_SGMII) tells me that the SOC has SGMII
lane(s). Having a SGMII block doesn't mean that other functions aren't
supported. I have to redo this!

> (Here comes a reason why using SGMII to cover all single-lane serdes
> modes causes confusion - unfortunately, some folk use SGMII to describe
> all these modes.  So, I'm going to use the terminology "Cisco SGMII"
> to mean exactly the SGMII format published by Cisco, "802.3 1000BASE-X"
> to mean the original IEEE 802.3 format running at 1.25Gbps, and
> "up-clocked 2500BASE-X" to mean the 3.125Gbps version of the 802.3
> 1000BASE-X protocol.)

Thanks for the explanation. In your previous review v1 you also explained it.
I did change the forced modes for x-BaseX modes and auto negotiation for Cisco
SGMII. But I seems to miss the link that I also have to improve this  
validation
part.

>
> Isn't this set for Cisco SGMII as well as for 802.3 1000BASE-X and
> the up-clocked 2500BASE-X modes?
>
> If so, is there a reason why 10Mbps and 100Mbps speeds aren't
> supported on Cisco SGMII links?

I can only tell a bit about the mt7622 SOC, datasheet tells me that:

The SGMII is the interface between 10/100/1000/2500 Mbps PHY and Ethernet MAC,
the spec is raised by Cisco in 1999, which is aims for pin reduction compare
with the GMII. It uses 2 differential data pair for TX and RX with clock
embedded bit stream to convey frame data and port ability information.
The core leverages the 1000Base-X PCS and Auto-Negotiation from IEEE 802.3
specification (clause 36/37). This IP can support up to 3.125G baud  
for 2.5Gbps
(proprietary 2500Base-X) data rate of MAC by overclocking.

Also features tells me: Support 10/100/1000/2500 Mbps in full duplex mode and
10/100 Mbps in half duplex mode.

I going make a new version.

Greats,

René

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



