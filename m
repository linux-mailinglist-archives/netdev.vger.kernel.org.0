Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C813165FB9C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjAFGu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAFGuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:50:55 -0500
Received: from out29-198.mail.aliyun.com (out29-198.mail.aliyun.com [115.124.29.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBCD657B;
        Thu,  5 Jan 2023 22:50:52 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07442372|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.371436-0.000974272-0.62759;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.QlmbPk7_1672987848;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QlmbPk7_1672987848)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 14:50:49 +0800
Message-ID: <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
Date:   Fri, 6 Jan 2023 14:51:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Frank <Frank.Sae@motor-comm.com>
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
Content-Language: en-US
In-Reply-To: <Y7bN4vJXMi66FF6v@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/5 21:17, Andrew Lunn wrote:
>> +  motorcomm,rx-delay-basic:
>> +    description: |
>> +      Tristate, setup the basic RGMII RX Clock delay of PHY.
>> +      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
>> +      This basic delay usually auto set by hardware according to the voltage
>> +      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
>> +      If not exist, this delay is controlled by hardware.
>> +      0: turn off;   1: turn on.
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    enum: [0, 1]
> 
> Why is this needed? When the MAC driver connects to the PHY, it passes
> phy-mode. For RGMII, this is one of:

> linux/phy.h:	PHY_INTERFACE_MODE_RGMII,
> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_ID,
> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_RXID,
> linux/phy.h:	PHY_INTERFACE_MODE_RGMII_TXID,
> 
> This tells you if you need to add a delay for the RX clock line, the
> TX clock line, or both. That is all you need to know for basic RGMII
> delays.
> 

This basic delay can be controlled by hardware or the phy-mode which
passes from MAC driver.
Default value depends on power on strapping, according to the voltage
of RXD0 pin (low = 0, turn off;   high = 1, turn on).

Add this for the case that This basic delay is controlled by hardware,
and software don't change this.

>> +  motorcomm,rx-delay-additional-ps:
> 
> ethernet-phy.yaml defines rx-internal-delay-ps. Please use that.
> 

I will fix.

>> +    description: |
>> +      Setup the additional RGMII RX Clock delay of PHY defined in pico seconds.
>> +      RGMII RX Clock Delay = rx-delay-basic + rx-delay-additional-ps.
>> +    enum:
>> +      - 0
>> +      - 150
>> +      - 300
>> +      - 450
>> +      - 600
>> +      - 750
>> +      - 900
>> +      - 1050
>> +      - 1200
>> +      - 1350
>> +      - 1500
>> +      - 1650
>> +      - 1800
>> +      - 1950
>> +      - 2100
>> +      - 2250
> 
> Is this property mandatory? If not, please document what value is used
> if it is not present.
> 

I will fix.

>> +
>> +  motorcomm,tx-delay-ge-ps:
> 
> tx-internal-delay-ps
> 
> And please define the default.
> 
>> +  motorcomm,tx-delay-fe-ps:
> 
> So you can only set the TX delay? What is RX delay set to? Same as 1G?
> I would suggest you call this motorcomm,tx-internal-delay-fe-ps, so
> that it is similar to the standard tx-internal-delay-ps.
> 

TX delay has two type: tx-delay-ge-ps for 1G and tx-delay-fe-ps for 100M.

RX delay set for 1G and 100M, but it has two type, rx-delay-basic and
rx-delay-additional-ps, RX delay = rx-delay-basic + rx-delay-additional-ps.

I will rename to  tx-internal-delay-fe-ps and  tx-internal-delay-ge-ps.

>> +    description: |
>> +      Setup PHY's RGMII TX Clock delay  defined in pico seconds when the speed
>> +      is 100Mbps or 10Mbps.
>> +    enum:
>> +      - 0
>> +      - 150
>> +      - 300
>> +      - 450
>> +      - 600
>> +      - 750
>> +      - 900
>> +      - 1050
>> +      - 1200
>> +      - 1350
>> +      - 1500
>> +      - 1650
>> +      - 1800
>> +      - 1950
>> +      - 2100
>> +      - 2250
>> +
>> +  motorcomm,keep-pll-enabled:
>> +    description: |
>> +      If set, keep the PLL enabled even if there is no link. Useful if you
>> +      want to use the clock output without an ethernet link.
>> +    type: boolean
>> +
>> +  motorcomm,auto-sleep-disabled:
>> +    description: |
>> +      If set, PHY will not enter sleep mode and close AFE after unplug cable
>> +      for a timer.
>> +    type: boolean
> 
> These two i can see being useful. But everything afterwards seems like
> just copy/paste from vendor SDK for things which the hardware can do,
> but probably nobody ever uses. Do you have a board using any of the
> following properties?
> 

tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted and
tx-clk-1000-inverted is used and tested by  Yanhong
Wang<yanhong.wang@starfivetech.com>. They used yt8531 on
jh7110-starfive-visionfive-v2. This will provide an additional way to
adjust the tx clk delay on yt8531.

sds-tx-amplitude can be tested on my yt8531s board.

>> +
>> +  motorcomm,tx-clk-adj-enabled:
>> +    description: |
>> +      Useful if you want to use tx-clk-xxxx-inverted to adj the delay of tx clk.
>> +    type: boolean
>> +
>> +  motorcomm,tx-clk-10-inverted:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 10Mbps.
>> +    type: boolean
>> +
>> +  motorcomm,tx-clk-100-inverted:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 100Mbps.
>> +    type: boolean
>> +
>> +  motorcomm,tx-clk-1000-inverted:
>> +    description: |
>> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
>> +      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
>> +    type: boolean
>> +
>> +  motorcomm,sds-tx-amplitude:
>> +    description: |
>> +      Setup the tx driver amplitude control of SerDes. Higher amplitude is
>> +      helpful for long distance.
>> +      0: low;   1: middle;   2: high.
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    enum: [0, 1, 2]
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    ethernet {
>> +        #address-cells = <1>;
>> +        #size-cells = <0>;
>> +        ethernet-phy@5 {
>> +            reg = <5>;
> 
> PHYs are on MDIO busses, so i would expect to see an MDIO bus here,
> not Ethernet.
> 

I will fix.

>     Andrew
