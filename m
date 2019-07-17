Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6E6C35A
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfGQW6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:58:20 -0400
Received: from mx.0dd.nl ([5.2.79.48]:37312 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfGQW6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 18:58:20 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1B4F75FEB1;
        Thu, 18 Jul 2019 00:58:17 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="q3KOsV2O";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id D196C1D1603A;
        Thu, 18 Jul 2019 00:58:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com D196C1D1603A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563404296;
        bh=TsBhyJwxhs6d4xkQU+8Qt2UZIqwnyy+SqU0c71oU3uA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3KOsV2OUQd6Gm9VfemUn2wj2ux7uIYrjrtQqbR1r80yIdsfcvBxF4ZUAfU0mGVek
         np4QHe85/sGiwYcxHq5xbsb/fzsd9pCZvs+TuORTh8Gk9FVs3mlQ6JEJfyc+blEJ5U
         nslWvgY6okU7ihgNXQisEZVf9V6lik6m8ekQtzKO6Lu3d9RwPSm8OhDj638wVsGFYa
         v1x1b6+denR7amwmAXHGlZMoBWNz6f8oHhGYttXSI17nRowoTyvBJW8r9daBtjQtst
         EfluekdaZG+js29ibwl9VhsPC+OV6NJg+92mzxFz1hQ1jNQeEaxBcMCtacIB4NxPx+
         aCh3nlupyqgkA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Wed, 17 Jul 2019 22:58:16 +0000
Date:   Wed, 17 Jul 2019 22:58:16 +0000
Message-ID: <20190717225816.Horde.Lym7vHLMewe-3L_Elk45WIQ@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: phylink: flow control on fixed-link not working.
References: <20190717213111.Horde.nir2D5kAJww569fjh8BZgZm@www.vdorst.com>
 <20190717215150.tk3gvq7lqc56scac@shell.armlinux.org.uk>
In-Reply-To: <20190717215150.tk3gvq7lqc56scac@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Wed, Jul 17, 2019 at 09:31:11PM +0000, René van Dorst wrote:
>> Hi,
>>
>> I am trying to enable flow control/pause on PHYLINK and fixed-link.
>>
>> My setup SOC mac (mt7621) <-> RGMII <-> SWITCH mac (mt7530).
>>
>> It seems that in fixed-link mode all the flow control/pause bits are cleared
>> in
>> phylink_parse_fixedlink(). If I read phylink_parse_fixedlink() [0]  
>> correctly,
>> I see that pl->link_config.advertising is AND with pl->supprted  
>> which has only
>> the PHY_SETTING() modes bits set. pl->link_config.advertising is  
>> losing Pause
>> bits. pl->link_config.advertising is used in phylink_resolve_flow()  
>> to set the
>> MLO_PAUSE_RX/TX BITS.
>>
>> I think this is an error.
>> Because in phylink_start() see this part [1].
>>
>>  /* Apply the link configuration to the MAC when starting. This allows
>>   * a fixed-link to start with the correct parameters, and also
>>   * ensures that we set the appropriate advertisement for Serdes links.
>>   */
>>  phylink_resolve_flow(pl, &pl->link_config);
>>  phylink_mac_config(pl, &pl->link_config);
>>
>>
>> If I add a this hacky patch below, flow control is enabled on the  
>> fixed-link.
>>         if (s) {
>>                 __set_bit(s->bit, pl->supported);
>> +               if (phylink_test(pl->link_config.advertising, Pause))
>> +                       phylink_set(pl->supported, Pause);
>>         } else {
>>
>> So is phylink_parse_fixedlink() broken or should it handled in a other way?
>
> Quite simply, if the MAC says it doesn't support pause modes (i.o.w.
> the validate callback clears them) then pause modes aren't supported.

Hi Russel,

Thanks for your response.

I believe that I am setting pause bits right on both ends see SOC [0] and
SWITCH [1] and also in the DTS [2].

Correct me if it is not the right way.


Maybe I am looking in the wrong part of the code.
But I added many debug lines in phylink_parse_fixedlink() [3] to see what
happens with the Pause bit in the pl->link_config.advertising and  
pl->supported.


This is the dmesg output.
[    1.991245] libphy: Fixed MDIO Bus: probed
[    2.031260] phylink_create: config0: Pause
[    2.039410] phylink_create: supported: Pause
[    2.047904] mtk_validate: mask: Pause
[    2.055186] mtk_validate: supported: Pause
[    2.063332] mtk_validate: advertising: Pause
[    2.071825] phylink_create: config1: Pause
[    2.079966] phylink_create: config2: Pause
[    2.088132] phylink_parse_fixedlink: config: Pause
[    2.097660] phylink_parse_fixedlink: support: Pause
[    2.107366] mtk_validate: mask: Pause
[    2.114647] mtk_validate: supported: Pause
[    2.122792] mtk_validate: advertising: Pause
[    2.131283] phylink_parse_fixedlink: config2: Pause
[    2.140971] phylink_parse_fixedlink: support2: Pause
[    2.150845] phylink_parse_fixedlink: config3: Pause
[    2.160546] phylink_parse_fixedlink: support3: Pause
[    2.170420] phylink_parse_fixedlink: config4: Pause
[    2.180120] phylink_parse_fixedlink: config5: Pause

[    5.854674] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
[    5.867665] phylink_resolve_flow: PAUSE_AN: pause: 0, 12, 8dfba630
[    5.867670] phylink_resolve_flow: new_pause: 0
[    5.879980] mt7530 mdio-bus:1f: phylink_mac_config:  
mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1  
an=1
[    6.651239] DSA: tree 0 setup
[    6.658192] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    6.672108] mt7530 mdio-bus:1f: phylink_mac_config:  
mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1  
an=1
[   28.937543] mtk_soc_eth 1e100000.ethernet eth0: configuring for  
fixed/trgmii link mode
[   28.965884] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:  
mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1  
an=1
[   29.000740] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:  
mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1  
an=1
[   29.026392] mtk_soc_eth 1e100000.ethernet eth0: Link is Up -  
1Gbps/Full - flow control off
[   29.373577] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready


I don't see the "config6:" [4] debug.
I think the pause bits are always cleared in  
pl->link_config.advertising by phylink_parse_fixedlink()

Again I may understand the code wrong or I am looking at the wrong place.
So I hope you can point me in the right direction.

Greats,

René


[0]:  
https://github.com/vDorst/linux-1/blob/8538cdefd425592d249a71445c466159b0f27475/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L502
[1]:  
https://github.com/vDorst/linux-1/blob/8538cdefd425592d249a71445c466159b0f27475/drivers/net/dsa/mt7530.c#L1468
[2]:  
https://github.com/vDorst/linux-1/blob/8538cdefd425592d249a71445c466159b0f27475/drivers/staging/mt7621-dts/UBNT-ER-e50.dtsi#L122
[3]:  
https://github.com/vDorst/linux-1/blob/8538cdefd425592d249a71445c466159b0f27475/drivers/net/phy/phylink.c#L214
[4]:  
https://github.com/vDorst/linux-1/blob/8538cdefd425592d249a71445c466159b0f27475/drivers/net/phy/phylink.c#L263

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



