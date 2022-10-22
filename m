Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326A860856B
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 09:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJVHZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 03:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJVHZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 03:25:04 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70746213;
        Sat, 22 Oct 2022 00:24:59 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id E208F1884447;
        Sat, 22 Oct 2022 07:24:56 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id DACBB250007B;
        Sat, 22 Oct 2022 07:24:56 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id CA4389EC0002; Sat, 22 Oct 2022 07:24:56 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sat, 22 Oct 2022 09:24:56 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221021181411.sv52q4yxr5r7urab@skbuf>
References: <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <37dc7673fde2b8e166a5ed78431a2078@kapio-technology.com>
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

On 2022-10-21 20:14, Vladimir Oltean wrote:
> On Fri, Oct 21, 2022 at 07:39:34PM +0200, netdev@kapio-technology.com 
> wrote:
>> Well, with this change, to have MAB working, the bridge would need 
>> learning on
>> of course, but how things work with the bridge according to the flags, 
>> they
>> should also work in the offloaded case if you ask me. There should be 
>> no
>> difference between the two, thus MAB in drivers would have to be with
>> learning on.
> 
> Am I proposing for things to work differently in the offload and
> software case, and not realizing it? :-/
> 
> The essence of my proposal was to send a bug fix now which denies
> BR_LEARNING to be set together with BR_PORT_LOCKED. The fact that
> link-local traffic is learned by the software bridge is something
> unintended as far as I understand.
> 
> You tried to fix it here, and as far as I could search in my inbox, 
> that
> didn't go anywhere:
> https://lore.kernel.org/netdev/47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackwall.org/T/#u
> 
> I thought only mv88e6xxx offloads BR_PORT_LOCKED, but now, after
> searching, I also see prestera has support for it, so let me add
> Oleksandr Mazur to the discussion as well. I wonder how they deal with
> this? Has somebody come to rely on learning being enabled on a locked
> port?
> 
> 
> MAB in offloading drivers will have to be with learning on (same as in
> software). When BR_PORT_LOCKED | BR_LEARNING will be allowed together
> back in net-next (to denote the MAB configuration), offloading drivers
> (mv88e6xxx and prestera) will be patched to reject them. They will only
> accept the two together when they implement MAB support.
> 
> Future drivers after this mess has been cleaned up will have to look at
> the BR_PORT_LOCKED and BR_LEARNING flag in combination, to see which
> kind of learning is desired on a port (secure, CPU based learning or
> autonomous learning).
> 
> Am I not making sense?

I will not say that you are not making sense as for the mv88e6xxx, as it
needs port association in all cases with BR_PORT_LOCKED, MAB or not, and
port association is turned on in the driver with learning turned on.

That said, there must be some resolution and agreement overall with this
issue to move on. Right now port association is turned on in the 
mv88e6xxx
driver when locking the port, thus setting learning off after locking 
will
break things.
