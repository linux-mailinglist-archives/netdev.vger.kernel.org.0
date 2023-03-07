Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2A6ADE0C
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjCGLxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCGLxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:53:10 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402692D5D;
        Tue,  7 Mar 2023 03:52:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678189894; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=bN4terWzMz3Cx2nE5lzMPtvgaA8Qhz3rlRR7IW5vQGbKml+WeZObmNrIqZZ39ICREqzXUD5E0s1bnkq7czaEZlhLcYL71txRgd1UeEnho7XBTygnnCJ0ixV4bmG7mXebAXhi4fyfU8hfIwjXMhmE/eyYMikkiYc5BjLv0L9DoCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678189894; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=S8JhKSBiaNHIyLyUlz+oitCeFzdpaOnBlopKxSYbxvY=; 
        b=Ap7XNsA8LdZEFCULrrooseETC5o/tXxx9jNLr68q+siokDvFGxAyVdu7BMH3HnBE47t9nBztrZ4wyfNowopU+qcfH32vjAqnUCScDcrXLpeFawj+fFF9DwhbhzEgUgWOnycbvgtmLt1AAfdbU/BONTvnX9PtTEP/O+QivBgH0oY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678189894;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=S8JhKSBiaNHIyLyUlz+oitCeFzdpaOnBlopKxSYbxvY=;
        b=T0iEyhVc6BuvgrJpHnEjxOrG155f+RGFO/tGdyLCq9ewFfYt2kco5tRjhCSm35pI
        88oxbiX4NpqLGDHMRT3omIyYVCtdxRxkPoTdxVfX9AsuKBQYD8Etsc8oda+2lRyhJBd
        FDAUxD0ZMBnYzwKhxRJiMdVuKN0PEK5zBaUj1a+4=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678189892501666.1333603647004; Tue, 7 Mar 2023 03:51:32 -0800 (PST)
Message-ID: <6572f054-1e29-b6ad-4cec-b8fac67797ab@arinc9.com>
Date:   Tue, 7 Mar 2023 14:51:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
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
 <a8ad9299-1f9f-e184-4429-eef9950e22d8@arinc9.com>
 <20230307113728.4lg6xqfhj5szcpd3@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230307113728.4lg6xqfhj5szcpd3@skbuf>
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

On 7.03.2023 14:37, Vladimir Oltean wrote:
> On Tue, Mar 07, 2023 at 02:26:08PM +0300, Arınç ÜNAL wrote:
>> Port 5 as CPU port works fine with this patch. I completely removed from
>> port 6 phy modes.
>>
>> With your patch on MT7621 (remember port 5 always worked on MT7623):
>>
>> - Port 5 at rgmii as the only CPU port works, even though the PLL frequency
>> won't be set. The download/upload speed is not affected.
> 
> That's good. Empirically it seems to prove that ncpo1 only affects p6,
> which was my initial assumption.
> 
>> - port 6 at trgmii mode won't work if the PLL frequency is not set. The
>> SoC's MAC (gmac0) won't receive anything. It checks out since setting the
>> PLL frequency is put under the "Setup the MT7530 TRGMII Tx Clock" comment.
>> So port 6 cannot properly transmit frames to the SoC's MAC.
>>
>> - Port 6 at rgmii mode works without setting the PLL frequency. Speed is not
>> affected.
>>
>> I commented out core_write(priv, CORE_PLL_GROUP5,
>> RG_LCDDS_PCW_NCPO1(ncpo1)); to stop setting the PLL frequency.
>>
>> In conclusion, setting the PLL frequency is only needed for the trgmii mode,
>> so I believe we can get rid of it on other cases.
> 
> Got it, sounds expected, then? My patch can be submitted as-is, correct?

Yup, your patch is a go! I can submit other patches to address the 
incorrect comment regarding port 5, and remove ncpo1 from rgmii mode for 
port 6.

> 
>> One more thing, on MT7621, xtal matches to both HWTRAP_XTAL_40MHZ and
>> HWTRAP_XTAL_25MHZ so the final value of ncpo1 is 0x0a00. I'm not sure if
>> xtal matching both of them is the expected behaviour.
>>
>>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>>> index fbf27d4ab5d9..12cea89ae0ac 100644
>>> --- a/drivers/net/dsa/mt7530.c
>>> +++ b/drivers/net/dsa/mt7530.c
>>> @@ -439,8 +439,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>>>   			/* PLL frequency: 150MHz: 1.2GBit */
>>>   			if (xtal == HWTRAP_XTAL_40MHZ)
>>>   				ncpo1 = 0x0780;
>>> +				dev_info(priv->dev, "XTAL is 40MHz, ncpo1 is 0x0780\n");
> 
> In the C language, you need to put brackets { } around multi-statement
> "if" blocks. Otherwise, despite the indentation, "dev_info" will be
> executed unconditionally (unlike in Python for example). There should
> also be a warning with newer gcc compilers about the misleading
> indentation not leading to the expected code.
> 
> Like this:
> 
> 			if (xtal == HWTRAP_XTAL_40MHZ) {
> 				ncpo1 = 0x0780;
> 				dev_info(priv->dev, "XTAL is 40MHz, ncpo1 is 0x0780\n");
> 			}
> 

Oh that figures, thanks a bunch. Clearly I've got a lot to learn. Now I 
see only 40MHz.

[    0.763772] mt7530 mdio-bus:1f: XTAL is 40MHz, ncpo1 is 0x0780

>>>   			if (xtal == HWTRAP_XTAL_25MHZ)
>>>   				ncpo1 = 0x0a00;
>>> +				dev_info(priv->dev, "XTAL is 25MHz, ncpo1 is 0x0a00\n");
>>> +			if (xtal == HWTRAP_XTAL_20MHZ)
>>> +				dev_info(priv->dev, "XTAL is 20MHz too\n");
>>>   		} else { /* PLL frequency: 250MHz: 2.0Gbit */
>>>   			if (xtal == HWTRAP_XTAL_40MHZ)
>>>   				ncpo1 = 0x0c80;
>>
>>> [    0.710455] mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
>>> [    0.734419] mt7530 mdio-bus:1f: configuring for fixed/rgmii link mode
>>> [    0.741766] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [    0.743647] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
>>> [    0.755422] mt7530 mdio-bus:1f: XTAL is 40MHz, ncpo1 is 0x0780
>>> [    0.761250] mt7530 mdio-bus:1f: XTAL is 25MHz, ncpo1 is 0x0a00
>>> [    0.769414] mt7530 mdio-bus:1f: Link is Up - 1Gbps/Full - flow control rx/tx
>>> [    0.772067] mt7530 mdio-bus:1f lan1 (uninitialized): PHY [mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=17)
>>> [    0.788647] mt7530 mdio-bus:1f lan2 (uninitialized): PHY [mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=18)
>>> [    0.800354] mt7530 mdio-bus:1f lan3 (uninitialized): PHY [mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=19)
>>> [    0.812031] mt7530 mdio-bus:1f lan4 (uninitialized): PHY [mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=20)
>>> [    0.823418] mtk_soc_eth 1e100000.ethernet eth1: entered promiscuous mode
>>> [    0.830250] mtk_soc_eth 1e100000.ethernet eth0: entered promiscuous mode
>>> [    0.837007] DSA: tree 0 setup
>>
>> Thunderbird limits lines to about 72 columns, so I'm pasting as quotation
>> which seems to bypass that.
> 
> That seems to have worked, but shouldn't have been needed. I've uninstalled
> Thunderbird in favor of mutt + vim for email editing.. although, isn't
> there a Word Wrap option which you can just turn off?

It turns out there is indeed:

https://support.mozilla.org/en-US/questions/1307935

Mutt seems to be too techy for my taste but one can't know until they 
try it, thanks for the info.

Arınç
