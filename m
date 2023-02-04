Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F668A90A
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 09:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbjBDIsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 03:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjBDIs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 03:48:29 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA3298D4;
        Sat,  4 Feb 2023 00:48:27 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 0664718839AA;
        Sat,  4 Feb 2023 08:48:25 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E1FE9250007B;
        Sat,  4 Feb 2023 08:48:24 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id D3B8191201E4; Sat,  4 Feb 2023 08:48:24 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sat, 04 Feb 2023 09:48:24 +0100
From:   netdev@kapio-technology.com
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        =?UTF-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
In-Reply-To: <Y94TebdRQRHMMj/c@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com> <20230203204422.4wrhyathxfhj6hdt@skbuf>
 <Y94TebdRQRHMMj/c@corigine.com>
User-Agent: Gigahost Webmail
Message-ID: <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
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

On 2023-02-04 09:12, Simon Horman wrote:
> On Fri, Feb 03, 2023 at 10:44:22PM +0200, Vladimir Oltean wrote:
>> On Fri, Feb 03, 2023 at 09:20:22AM +0100, Simon Horman wrote:
>> > > else if (someflag)
>> > >         dosomething();
>> > >
>> > > For now only one flag will actually be set and they are mutually exclusive,
>> > > as they will not make sense together with the potential flags I know, but
>> > > that can change at some time of course.
>> >
>> > Yes, I see that is workable. I do feel that checking for other flags would
>> > be a bit more robust. But as you say, there are none. So whichever
>> > approach you prefer is fine by me.
>> 
>> The model we have for unsupported bits in the 
>> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
>> and SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handlers is essentially this:
>> 
>> 	if (flags & ~(supported_flag_mask))
>> 		return -EOPNOTSUPP;
>> 
>> 	if (flags & supported_flag_1)
>> 		...
>> 
>> 	if (flags & supported_flag_2)
>> 		...
>> 
>> I suppose applying this model here would address Simon's extensibility 
>> concern.
> 
> Yes, that is the model I had in mind.

The only thing is that we actually need to return both 0 and -EOPNOTSUPP 
for unsupported flags. The dynamic flag requires 0 when not supported 
(and supported) AFAICS.
Setting a mask as 'supported' for a feature that is not really supported 
defeats the notion of 'supported' IMHO.
