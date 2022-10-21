Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC2607818
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJUNR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJUNRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:17:23 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA50E17F98E;
        Fri, 21 Oct 2022 06:17:09 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 03CB41884D82;
        Fri, 21 Oct 2022 13:16:22 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id EDB80250007B;
        Fri, 21 Oct 2022 13:16:21 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E48979EC0009; Fri, 21 Oct 2022 13:16:21 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 21 Oct 2022 15:16:21 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
In-Reply-To: <20221021112216.6bw6sjrieh2znlti@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
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

On 2022-10-21 13:22, Vladimir Oltean wrote:
> On Fri, Oct 21, 2022 at 08:47:42AM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-10-21 00:57, Vladimir Oltean wrote:
>> > On Thu, Oct 20, 2022 at 10:20:50PM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > In general locked ports block traffic from a host based on if there
>> > > is a
>> > > FDB entry or not. In the non-offloaded case, there is only CPU
>> > > assisted
>> > > learning, so the normal learning mechanism has to be disabled as any
>> > > learned entry will open the port for the learned MAC,vlan.
>> >
>> > Does it have to be that way? Why can't BR_LEARNING on a BR_PORT_LOCKED
>> > cause the learned FDB entries to have BR_FDB_LOCKED, and everything
>> > would be ok in that case (the port will not be opened for the learned
>> > MAC/VLAN)?
>> 
>> I suppose you are right that basing it solely on BR_FDB_LOCKED is 
>> possible.
>> 
>> The question is then maybe if the common case where you don't need 
>> learned
>> entries for the scheme to work, e.g. with EAPOL link local packets, 
>> requires
>> less CPU load to work and is cleaner than if using BR_FDB_LOCKED 
>> entries?
> 
> I suppose the real question is what does the bridge currently do with
> BR_LEARNING + BR_PORT_LOCKED, and if that is sane and useful in any 
> case?
> It isn't a configuration that's rejected, for sure. The configuration
> could be rejected via a bug fix patch, then in net-next it could be 
> made
> to learn these addresses with the BR_FDB_LOCKED flag.
> 
> To your question regarding the common case (no MAB): that can be 
> supported
> just fine when BR_LEARNING is off and BR_PORT_LOCKED is on, no?
> No BR_FDB_LOCKED entries will be learned.

As it is now in the bridge, the locked port part is handled before 
learning
in the ingress data path, so with BR_LEARNING and BR_PORT_LOCKED, I 
think it
will work as it does now except link local packages.

If your suggestion of BR_LEARNING causing BR_FDB_LOCKED on a locked 
port, I
guess it would be implemented under br_fdb_update() and BR_LEARNING +
BR_PORT_LOCKED would go together, forcing BR_LEARNING in this case, thus 
also
for all drivers?
