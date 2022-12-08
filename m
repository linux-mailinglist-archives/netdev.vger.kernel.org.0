Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC6647207
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLHOlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLHOlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:41:44 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DAC63B96;
        Thu,  8 Dec 2022 06:41:41 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id DA1A618845A4;
        Thu,  8 Dec 2022 14:41:24 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id CB56A25002E1;
        Thu,  8 Dec 2022 14:41:24 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id C129D9EC0025; Thu,  8 Dec 2022 14:41:24 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 08 Dec 2022 15:41:24 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221208133524.uiqt3vwecrketc5y@skbuf>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
 <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
 <20221207202935.eil7swy4osu65qlb@skbuf>
 <1b0d42df6b3f2f17f77cfb45cf8339da@kapio-technology.com>
 <20221208133524.uiqt3vwecrketc5y@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <c9dc3682dd9e4c2a9d81a7df0f3f9124@kapio-technology.com>
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

On 2022-12-08 14:35, Vladimir Oltean wrote:
> On Thu, Dec 08, 2022 at 01:28:27PM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2022-12-07 21:29, Vladimir Oltean wrote:
>> > On Tue, Dec 06, 2022 at 05:36:42PM +0100, netdev@kapio-technology.com wrote:
>> > > > I was under the impression that we agreed that the locking change will
>> > > > be split to a separate patch.
>> > >
>> > > Sorry, I guess that because of the quite long time that has passed as I
>> > > needed to get this FID=0 issue sorted out, and had many other different
>> > > changes to attend, I forgot.
>> >
>> > Well, at least you got the FID=0 issue sorted out... right?
>> > What was the cause, what is the solution?
>> 
>> Well I got it sorted out in the way that I have identified that it is 
>> the
>> ATU op that fails some times. I don't think there is anything that can 
>> be
>> done about that, other than what I do and let the interrupt routing 
>> return
>> an error.
> 
> Yikes. But why would you call that "sorted out", though? Just to make 
> it
> appear as though you really spent some time on it, and use it as an
> excuse for something else?
> 
>> it is the ATU op that fails some times.
> 
> Let's start with the assumption that this is correct. A person with
> critical thinking will ask "can I prove that it is?".
> 
> If the ATU operation fails sometimes, I would expect that it always
> fails in the same way, by returning FID 0, where 0 is some kind of
> "invalid" value.
> 
> But if FID 0 is actually FID_STANDALONE, then you'd read FID_STANDALONE
> even if you change the value of FID_STANDALONE in the driver to
> something else, like 1.
> 
> Something ultra hackish like this will install VLAN 3050 as first VID 
> in
> the switch, and that will gain FID 0. Then, MV886XXX_VID_STANDALONE 
> will
> gain FID 1. So we need to adjust the definitions.
> 

Here is an example of the output I have when running the 
locked_port_mab() under the selftests...

mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6xxx_g1_atu_prob_irq_thread_fn: 13 callbacks suppressed
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2

the -22 errors are all when it returns FID=0, and it is the same mac all 
the way.


I have other logs, where the -22 occurs at random other times, f.ex. 
same test:

mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6xxx_g1_atu_prob_irq_thread_fn: 4 callbacks suppressed
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU miss violation for 
8e:a9:fc:14:58:06 portvec 0 spid 2
mv88e6085 1002b000.ethernet-1:04: ATU problem: error -22 while handling 
interrupt

What else conclusion than it is the ATU op that fails?
