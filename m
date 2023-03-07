Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CEF6ADD3A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCGL1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCGL1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:27:09 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7406D37542;
        Tue,  7 Mar 2023 03:27:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678188377; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=BPkMiJfMNGTEJlUmVH0YDuLKtaiBwss4eMv0yjEp53AnSr/0riTP/xKDz5E7HQPQenEPTUy4A7HRvjL4+hyeqYhEnsdF9LEIQuc191lKCM7JH8RobAt0cUSXOCexFyipf9XbvWJU43hcdShcqVahmBeJ0iQgkPeDk9nY7nDjYCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678188377; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+7/qmZLaHjjfxCYjNJsCYZ5/nHivH/ph12W74gSRfo4=; 
        b=n5xvtv8B36zcM/7j7tnCcJNuvqh0i85CC9CqmucBz7zg6Za06Qe+Mn1FToQvSjeSh2UdGzZ/rcwrAFwF7seKOf0kHQFS8x/xoaWZUZg89PhofZvQklvl92kjWWuTR8xuHRrPOlRoKm/wTk920+BwlhNihhFonwq7aidgng6pmUI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678188377;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=+7/qmZLaHjjfxCYjNJsCYZ5/nHivH/ph12W74gSRfo4=;
        b=iG84a1Vep245sF1QqwSB3OL5UIp/lwhqXOjC0MY0d7PLKWaSJVrZw39OwgK+OEan
        o29MCLUfzm94//dBDBeR5mKOZuwSIwQwe+FNXdxh4CpnPDp5nliZD0Ci2tjvIFrvOlX
        G/bW42wDqtKulWRB7NP4/TnuCQzDZdMVtQVWkj1A=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 167818837544070.97573534295577; Tue, 7 Mar 2023 03:26:15 -0800 (PST)
Message-ID: <a8ad9299-1f9f-e184-4429-eef9950e22d8@arinc9.com>
Date:   Tue, 7 Mar 2023 14:26:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [RFC PATCH net] net: dsa: mt7530: move PLL setup out of port 6
 pad configuration
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Alexander Couzens <lynxis@fe80.eu>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230304125453.53476-1-arinc.unal@arinc9.com>
 <20230306154552.26o6sbwf3rfekcyz@skbuf>
 <65f84ef3-8f72-d823-e6f9-44d33a953697@arinc9.com>
 <20230306201905.yothcuxokzlk3mcq@skbuf>
Content-Language: en-US
In-Reply-To: <20230306201905.yothcuxokzlk3mcq@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.03.2023 23:19, Vladimir Oltean wrote:
> On Mon, Mar 06, 2023 at 08:03:54PM +0300, Arınç ÜNAL wrote:
>> Looking at the Wikipedia page for Media-independent interface [0], the data
>> interface must be clocked at 125 MHz for gigabit MIIs, which I believe what
>> the "PLL" here refers to. trgmii needs higher frequency in some cases so if
>> both CPU ports are enabled, the table would be:
>>
>>      priv->p5_interface        priv->p6_interface       ncpo1 value
>>          gmii                     rgmii                     125MHz
>>          mii                      rgmii                     125MHz
>>          rgmii                    rgmii                     125MHz
>>          gmii                     trgmii                    125-250MHz
>>          mii                      trgmii                    125-250MHz
>>          rgmii                    trgmii                    125-250MHz
>>
>> [0] https://en.wikipedia.org/wiki/Media-independent_interface#GMII
> 
> Wikipedia will only tell you what the frequency of the interface signals
> needs to be. That is useful to keep in mind, but without information from
> the datasheet regarding what the SoC's clock distribution tree looks like,
> it's hard to know how that interface clock is derived from internal PLLs
> and ultimately from the oscillators. I was hoping that was the kind of
> information you could provide. The manuals I have access to, through charity,
> don't say anything on that front.

I wish I could. There are three people associated with MediaTek CC'd 
here. Maybe one will care to inform us.

> 
> Since I don't know what I'm commenting on, I'll stop commenting any further.
> 
>>> right now, you let the p6_interface logic overwrite the ncpo1 selected
>>> by the p5_interface logic like crazy, and it's not clear to me that this
>>> is what you want.
>>
>> This seems to be fine as p6 sets the frequency either the same or higher.
> 
> (...)

Sorry for the vague reply, my assumption was that interfaces with slower 
speeds, 100M, 1000M, etc. works fine at higher PLL frequency whilst they 
won't work the other way around.

> 
>> This looks much better, thanks a lot! The only missing part is setting the
>> PLL frequency when only port 5 is enabled.
> 
> True. Although with the limited information I have, I'm not sure that
> the ncpo1 value written into CORE_PLL_GROUP5 is needed by port5 either
> way. The fact that you claim port5 works when ncpo1 ranges from 125 to
> 250 MHz tells me that it's either very tolerant of the ncpo1 value
> (through mechanisms unknown to me), or simply unaffected by it (more
> likely ATM). Since I don't have any details regarding the value, I'd
> just like to treat the configuration procedure as plain code, and not
> make any changes until there's a proof that they're needed.
> 
>> I'll test it regardless.
> 
> Thanks.

Port 5 as CPU port works fine with this patch. I completely removed from 
port 6 phy modes.

With your patch on MT7621 (remember port 5 always worked on MT7623):

- Port 5 at rgmii as the only CPU port works, even though the PLL 
frequency won't be set. The download/upload speed is not affected.

- port 6 at trgmii mode won't work if the PLL frequency is not set. The 
SoC's MAC (gmac0) won't receive anything. It checks out since setting 
the PLL frequency is put under the "Setup the MT7530 TRGMII Tx Clock" 
comment. So port 6 cannot properly transmit frames to the SoC's MAC.

- Port 6 at rgmii mode works without setting the PLL frequency. Speed is 
not affected.

I commented out core_write(priv, CORE_PLL_GROUP5, 
RG_LCDDS_PCW_NCPO1(ncpo1)); to stop setting the PLL frequency.

In conclusion, setting the PLL frequency is only needed for the trgmii 
mode, so I believe we can get rid of it on other cases.

One more thing, on MT7621, xtal matches to both HWTRAP_XTAL_40MHZ and 
HWTRAP_XTAL_25MHZ so the final value of ncpo1 is 0x0a00. I'm not sure if 
xtal matching both of them is the expected behaviour.

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index fbf27d4ab5d9..12cea89ae0ac 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -439,8 +439,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>  			/* PLL frequency: 150MHz: 1.2GBit */
>  			if (xtal == HWTRAP_XTAL_40MHZ)
>  				ncpo1 = 0x0780;
> +				dev_info(priv->dev, "XTAL is 40MHz, ncpo1 is 0x0780\n");
>  			if (xtal == HWTRAP_XTAL_25MHZ)
>  				ncpo1 = 0x0a00;
> +				dev_info(priv->dev, "XTAL is 25MHz, ncpo1 is 0x0a00\n");
> +			if (xtal == HWTRAP_XTAL_20MHZ)
> +				dev_info(priv->dev, "XTAL is 20MHz too\n");
>  		} else { /* PLL frequency: 250MHz: 2.0Gbit */
>  			if (xtal == HWTRAP_XTAL_40MHZ)
>  				ncpo1 = 0x0c80;

> [    0.710455] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
> [    0.734419] mt7530 mdio-bus:1f: configuring for fixed/rgmii link mode
> [    0.741766] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
> [    0.743647] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
> [    0.755422] mt7530 mdio-bus:1f: XTAL is 40MHz, ncpo1 is 0x0780
> [    0.761250] mt7530 mdio-bus:1f: XTAL is 25MHz, ncpo1 is 0x0a00
> [    0.769414] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
> [    0.772067] mt7530 mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=17)
> [    0.788647] mt7530 mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=18)
> [    0.800354] mt7530 mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=19)
> [    0.812031] mt7530 mdio-bus:1f lan4 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=20)
> [    0.823418] mtk_soc_eth 1e100000.ethernet eth1: entered promiscuous mode
> [    0.830250] mtk_soc_eth 1e100000.ethernet eth0: entered promiscuous mode
> [    0.837007] DSA: tree 0 setup

Thunderbird limits lines to about 72 columns, so I'm pasting as 
quotation which seems to bypass that.

Arınç
