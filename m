Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45608665747
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbjAKJVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbjAKJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:20:26 -0500
Received: from out29-174.mail.aliyun.com (out29-174.mail.aliyun.com [115.124.29.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B766EBC;
        Wed, 11 Jan 2023 01:20:24 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436429|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.035419-0.00141408-0.963167;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.Qq4njsE_1673428819;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.Qq4njsE_1673428819)
          by smtp.aliyun-inc.com;
          Wed, 11 Jan 2023 17:20:21 +0800
Message-ID: <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
Date:   Wed, 11 Jan 2023 17:20:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com> <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
 <Y7goXXiRBE6XHuCc@lunn.ch>
Content-Language: en-US
In-Reply-To: <Y7goXXiRBE6XHuCc@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/6 21:55, Andrew Lunn wrote:
>>> Why is this needed? When the MAC driver connects to the PHY, it passes
>>> phy-mode. For RGMII, this is one of:
>>
>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
>>> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,
>>>
>>> This tells you if you need to add a delay for the RX clock line, the
>>> TX clock line, or both. That is all you need to know for basic RGMII
>>> delays.
>>>
>>
>> This basic delay can be controlled by hardware or the phy-mode which
>> passes from MAC driver.
>> Default value depends on power on strapping, according to the voltage
>> of RXD0 pin (low = 0, turn off;   high = 1, turn on).
>>
>> Add this for the case that This basic delay is controlled by hardware,
>> and software don't change this.
> 
> You should always do what phy-mode contains. Always. We have had
> problems in the past where a PHY driver ignored the phy-mode, and left
> the PHY however it was strapped. Which worked. But developers put the
> wrong phy-mode value in DT. Then somebody had a board which actually
> required that the DT value really did work, because the strapping was
> wrong. So the driver was fixed to respect the PHY mode, made that
> board work, and broke all the other boards which had the wrong
> phy-mode in DT.
> 
> If the user want the driver to leave the mode alone, use the
> strapping, they should use PHY_INTERFACE_MODE_NA. It is not well
> documented, but it is used in a few places. However, i don't recommend
> it.
> 

RX delay = rx-delay-basic (0ns or 1.9ns) + x-delay-additional-ps
(N*150ps, N = 0 ~ 15)
 If rx-delay-basic is removed and controlled by phy-mode.
 when phy-mode is  rgmii-id or rgmii-rxid, RX delay is 1.9ns + N*150ps.
 But sometimes 1.9ns is still too big, we just need  0ns + N*150ps.

For this case, can we do like following ?
rx-internal-delay-ps:
    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500,
1650, 1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
    default: 0
 rx-internal-delay-ps is 0ns + N*150ps and  1.9ns + N*150ps.
 And check whether need rx-delay-basic (1.9ns) by the val of
rx-internal-delay-ps?

>>>> +  motorcomm,tx-delay-fe-ps:
>>>
>>> So you can only set the TX delay? What is RX delay set to? Same as 1G?
>>> I would suggest you call this motorcomm,tx-internal-delay-fe-ps, so
>>> that it is similar to the standard tx-internal-delay-ps.
>>>
>>
>> TX delay has two type: tx-delay-ge-ps for 1G and tx-delay-fe-ps for 100M.
>>
>> RX delay set for 1G and 100M, but it has two type, rx-delay-basic and
>> rx-delay-additional-ps, RX delay = rx-delay-basic + rx-delay-additional-ps.
>>
>> I will rename to  tx-internal-delay-fe-ps and  tx-internal-delay-ge-ps.
> 
> So you can set the TX delay for 1G and Fast, but RX delay has a single
> setting for both 1G and Fast? Have you seen boards what actually need
> different TX delays like this?
> 
> Just because the hardware supports something does not mean Linux needs
> to support it. Unless there is a real need for it. So i would suggest
> your drop this DT property, and set the Fast delay to the same as the
> 1G delay. If any board actually requires this in the future, the
> property can be added then.
> 
>>
>>> These two i can see being useful. But everything afterwards seems like
>>> just copy/paste from vendor SDK for things which the hardware can do,
>>> but probably nobody ever uses. Do you have a board using any of the
>>> following properties?
>>>
>>
>> tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted and
>> tx-clk-1000-inverted is used and tested by  Yanhong
>> Wang<yanhong.wang@starfivetech.com>. They used yt8531 on
>> jh7110-starfive-visionfive-v2. This will provide an additional way to
>> adjust the tx clk delay on yt8531.
> 
> O.K. So they are used with a real board. Can we reduce this down to
> tx-clk-inverted? Have you ever seen a board which only needs the
> invert for one speed and not the others? To me, that would be a very
> odd design.
> 

We can't reduce this down to tx-clk-inverted.
There are two mac and two yt8531 on their board. Each of yt8531 need
different config in DTS. They need adjust tx clk delay in
link_change_notify callback function according to current speed.

 They configured tx-clk-xxxx-inverted like this :

    speed     GMAC0             GMAC1
    1000M      1                  0		tx-clk-1000-inverted
    100M       1                  1		tx-clk-100-inverted
    10M       0/1                0/1     	tx-clk-10-inverted

Can we put tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted
and tx-clk-1000-inverted in tx-clk-10-inverted like bit in byte?

tx-clk-10-inverted = tx-clk-adj-enabled (bit0),
tx-clk-10-inverted(bit1), tx-clk-100-inverted(bit1) and
tx-clk-1000-inverted(bit2).

>> sds-tx-amplitude can be tested on my yt8531s board.
> 
> Does the board break with the default value? Just because you can test
> it on your RDK does not mean anybody will ever use it.
> 
>    Andrew
