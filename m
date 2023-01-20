Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557FD675F86
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjATVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjATVQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:16:10 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86101DB94;
        Fri, 20 Jan 2023 13:16:05 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 4A5AF1883A74;
        Fri, 20 Jan 2023 21:16:03 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 412112500327;
        Fri, 20 Jan 2023 21:16:03 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 2D75D91201E4; Fri, 20 Jan 2023 21:16:03 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 20 Jan 2023 22:16:03 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [RFC PATCH net-next 1/5] net: bridge: add dynamic flag to
 switchdev notifier
In-Reply-To: <20230119134045.fqdt6zrna5x3iavt@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-2-netdev@kapio-technology.com>
 <20230117230806.ipwcbnq4jcc4qs7z@skbuf>
 <a3bba3eb856a00b5e5e0c1e2ffe8749a@kapio-technology.com>
 <20230119093358.gbyka2x4qbxxr43b@skbuf>
 <20230119134045.fqdt6zrna5x3iavt@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <29501147c96e7e2f06c999410d42e2bf@kapio-technology.com>
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

On 2023-01-19 14:40, Vladimir Oltean wrote:
> On Thu, Jan 19, 2023 at 11:33:58AM +0200, Vladimir Oltean wrote:
>> On Wed, Jan 18, 2023 at 11:14:00PM +0100, netdev@kapio-technology.com 
>> wrote:
>> > > > +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags);
>> > >
>> > > Why reverse logic? Why not just name this "is_static" and leave any
>> > > further interpretations up to the consumer?
>> >
>> > My reasoning for this is that the common case is to have static entries,
>> > thus is_dyn=false, so whenever someone uses a switchdev_notifier_fdb_info
>> > struct the common case does not need to be entered.
>> > Otherwise it might also break something when someone uses this struct and if
>> > it was 'is_static' and they forget to code is_static=true they will get
>> > dynamic entries without wanting it and it can be hard to find such an error.
>> 
>> I'll leave it up to bridge maintainers if this is preferable to 
>> patching
>> all callers of SWITCHDEV_FDB_ADD_TO_BRIDGE such that they set 
>> is_static=true.
> 
> Actually, why would you assume that all users of 
> SWITCHDEV_FDB_ADD_TO_BRIDGE
> want to add static FDB entries? You can't avoid inspecting the code and
> making sure that the is_dyn/is_static flag is set correctly either way.

Well, up until this patch set there is no option, besides entries from 
SWITCHDEV_FDB_ADD_TO_BRIDGE events will get the external learned flag 
set, so they will not be aged by the bridge, and so dynamic entries that 
way don't make much sense I think. Is that not right?
