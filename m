Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E18629D49
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKOPYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiKOPYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:24:08 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06C2DF09;
        Tue, 15 Nov 2022 07:24:05 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id E3B971883A1A;
        Tue, 15 Nov 2022 15:24:02 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id DCD3225002DE;
        Tue, 15 Nov 2022 15:24:02 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id CC2C49EC0020; Tue, 15 Nov 2022 15:24:02 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 16:24:02 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <Y3Osehw6Ra28HhYv@shredder>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <Y3NixroyU4XGL5j6@shredder>
 <864c4ae8e549721ba1ac5cf6ef77db9d@kapio-technology.com>
 <Y3Osehw6Ra28HhYv@shredder>
User-Agent: Gigahost Webmail
Message-ID: <5a8195cfa02a95d614e782b9ae55546b@kapio-technology.com>
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

On 2022-11-15 16:12, Ido Schimmel wrote:
> On Tue, Nov 15, 2022 at 11:36:38AM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2022-11-15 10:58, Ido Schimmel wrote:
>> > On Sat, Nov 12, 2022 at 09:37:48PM +0100, Hans J. Schultz wrote:
>> > > diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> > > b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> > > index 8a874b6fc8e1..0a57f4e7dd46 100644
>> > > --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> > > +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> > > @@ -12,6 +12,7 @@
>> > >
>> > >  #include "chip.h"
>> > >  #include "global1.h"
>> > > +#include "switchdev.h"
>> > >
>> > >  /* Offset 0x01: ATU FID Register */
>> > >
>> > > @@ -426,6 +427,8 @@ static irqreturn_t
>> > > mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>> > >  	if (err)
>> > >  		goto out;
>> > >
>> > > +	mv88e6xxx_reg_unlock(chip);
>> >
>> > Why? At minimum such a change needs to be explained in the commit
>> > message and probably split to a separate preparatory patch, assuming the
>> > change is actually required.
>> 
>> This was a change done long time ago related to that the violation 
>> handle
>> function takes the NL lock,
>> which could lead to a double-lock deadlock afair if the chip lock is 
>> taken
>> throughout the handler.
> 
> Why do you need to take RTNL lock? br_switchdev_event() which receives
> the 'SWITCHDEV_FDB_ADD_TO_BRIDGE' event has this comment:
> "/* called with RTNL or RCU */"
> And it's using br_port_get_rtnl_rcu(), so looks like RCU is enough.

As I understand, dsa_port_to_bridge_port() needs to be called with the 
NL lock taken...
