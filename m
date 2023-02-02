Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DD688408
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbjBBQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 11:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBBQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 11:19:19 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9686F4CE69;
        Thu,  2 Feb 2023 08:19:11 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id C5A801883528;
        Thu,  2 Feb 2023 16:19:07 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id BABFF250007B;
        Thu,  2 Feb 2023 16:19:07 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id B0E8191201E4; Thu,  2 Feb 2023 16:19:07 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 02 Feb 2023 17:19:07 +0100
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
In-Reply-To: <Y9vaIOefIf/gI0BR@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <Y9lrIWMnWLqGreZL@shredder>
 <e2535b002be9044958ab0003d8bd6966@kapio-technology.com>
 <Y9vaIOefIf/gI0BR@shredder>
User-Agent: Gigahost Webmail
Message-ID: <3cecf4425b0e6f38646e25e40fd8f0fd@kapio-technology.com>
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

On 2023-02-02 16:43, Ido Schimmel wrote:
> On Thu, Feb 02, 2023 at 08:37:08AM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2023-01-31 20:25, Ido Schimmel wrote:
>> >
>> > Will try to review tomorrow, but it looks like this set is missing
>> > selftests. What about extending bridge_locked_port.sh?
>> 
>> I knew you would take this up. :-)
>> But I am not sure that it's so easy to have selftests here as it is 
>> timing
>> based and it would take the 5+ minutes just waiting to test in the 
>> stadard
>> case, and there is opnly support for mv88e6xxx driver with this patch 
>> set.
> 
> The ageing time is configurable: See commit 081197591769 ("selftests:
> net: bridge: Parameterize ageing timeout"). Please add test cases in 
> the
> next version.

When I was looking at configuring the ageing time last time, my finding 
was that the ageing time could not be set very low as there was some 
part in the DSA layer etc, and confusion wrt units. I think the minimum 
secured was like around 2 min. (not validated), which is not that much 
of an improvement for fast testing. If you know what would be a good low 
timeout to set, I would like to know.
