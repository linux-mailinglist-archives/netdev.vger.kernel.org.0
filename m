Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F81568853A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjBBRSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjBBRSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:18:13 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096A21632D;
        Thu,  2 Feb 2023 09:18:11 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 5FBE31883A58;
        Thu,  2 Feb 2023 17:18:10 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 463FE250007B;
        Thu,  2 Feb 2023 17:18:10 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 3ECC991201E4; Thu,  2 Feb 2023 17:18:10 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 02 Feb 2023 18:18:10 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Cl=C3=A9m?= =?UTF-8?Q?ent_L=C3=A9ger?= 
        <clement.leger@bootlin.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 0/5] ATU and FDB synchronization on locked ports
In-Reply-To: <Y9lrIWMnWLqGreZL@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <Y9lrIWMnWLqGreZL@shredder>
User-Agent: Gigahost Webmail
Message-ID: <1fe06ed3010fe318728ebd73eee7f092@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-31 20:25, Ido Schimmel wrote:
>> command like:
>> 
>> bridge fdb replace ADDR dev <DEV> master dynamic
>> 
>> We choose only to support this feature on locked ports, as it involves
>> utilizing the CPU to handle ATU related switchcore events (typically
>> interrupts) and thus can result in significant performance loss if
>> exposed to heavy traffic.
> 
> Not sure I understand this reasoning. I was under the impression that
> hostapd is installing dynamic entries instead of static ones since the
> latter are not flushed when carrier is lost. Therefore, with static
> entries it is possible to unplug a host (potentially plugging a
> different one) and not lose authentication.
> 

Both auth schemes 802.1X and MAB install dynamic entries as you point 
out, and both use locked ports.
In the case of non locked ports, they just learn normally and age and 
refresh their entries, so the use case of a userspace added dynamic FDB 
entry is hard for me to see. And having userspace being notified of an 
ordinary event that a FDB entry has been aged out could maybe be used, 
but for the reasons mentioned it is not supported here.

>> 
>> On locked ports it is important for userspace to know when an 
>> authorized
>> station has become silent, hence not breaking the communication of a
>> station that has been authorized based on the MAC-Authentication 
>> Bypass
>> (MAB) scheme. Thus if the station keeps being active after 
>> authorization,
>> it will continue to have an open port as long as it is active. Only 
>> after
>> a silent period will it have to be reauthorized. As the ageing process 
>> in
>> the ATU is dependent on incoming traffic to the switchcore port, it is
>> necessary for the ATU to signal that an entry has aged out, so that 
>> the
>> FDB can be updated at the correct time.
> 
> Why mention MAB at all? Don't you want user space to always use dynamic
> entries to authenticate hosts regardless of 802.1X/MAB?

Yes, you are right about that. I guess it came about as this was 
developed much in the same time and with the code of MAB.
