Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5759BA9C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 09:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiHVHtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 03:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiHVHtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 03:49:39 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D7416586;
        Mon, 22 Aug 2022 00:49:32 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id F28C81884643;
        Mon, 22 Aug 2022 07:49:28 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id E1D1E25032B7;
        Mon, 22 Aug 2022 07:49:28 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BB1D4A1A0048; Mon, 22 Aug 2022 07:49:28 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 22 Aug 2022 09:49:28 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
In-Reply-To: <YwMW4iGccDu6jpaZ@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
User-Agent: Gigahost Webmail
Message-ID: <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-22 07:40, Ido Schimmel wrote:
> On Sun, Aug 21, 2022 at 03:43:04PM +0200, netdev@kapio-technology.com 
> wrote:
> 
> I personally think that the mv88e6xxx semantics are very weird (e.g., 
> no
> roaming, traffic blackhole) and I don't want them to determine how the
> feature works in the pure software bridge or other hardware
> implementations. On the other hand, I understand your constraints and I
> don't want to create a situation where user space is unable to
> understand how the data path works from the bridge FDB dump with
> mv88e6xxx.
> 
> My suggestion is to have mv88e6xxx report the "locked" entry to the
> bridge driver with additional flags that describe its behavior in terms
> of roaming, ageing and forwarding.
> 
> In terms of roaming, since in mv88e6xxx the entry can't roam you should
> report the entry with the "sticky" flag.

As I am not familiar with roaming in this context, I need to know how 
the SW bridge should behave in this case. In this I am assuming that 
roaming is regarding unauthorized entries.
In this case, is the roaming only between locked ports or does the 
roaming include that the entry can move to a unlocked port, resulting in 
the locked flag getting removed?

> In terms of ageing, since
> mv88e6xxx is the one doing the ageing and not the bridge driver, report
> the entry with the "extern_learn" flag.

Just for the record, I see that entries coming from the driver to the 
bridge will always have the "extern learn" flag set as can be seen from 
the SWITCHDEV_FDB_ADD_TO_BRIDGE events handling in br_switchdev_event() 
in br.c, which I think is the correct behavior.

> In terms of forwarding, in
> mv88e6xxx the entry discards all matching packets. We can introduce a
> new FDB flag that instructs the entry to silently discard all matching
> packets. Like we have with blackhole routes and nexthops.

Any suggestions to the name of this flag?

> 
> I believe that the above suggestion allows you to fully describe how
> these entries work in mv88e6xxx while keeping the bridge driver in sync
> with complete visibility towards user space.
> 
> It also frees the pure software implementation from the constraints of
> mv88e6xxx, allowing "locked" entries to behave like any other
> dynamically learned entries modulo the fact that they cannot "unlock" a
> locked port.
> 
> Yes, it does mean that user space will get a bit different behavior 
> with
> mv88e6xxx compared to a pure software solution, but a) It's only the
> corner cases that act a bit differently. As a whole, the feature works
> largely the same. b) User space has complete visibility to understand
> the behavior of the offloaded data path.
> 

>> 
>> I will change it in iproute2 to:
>> bridge link set dev DEV mab on|off
> 
> And s/BR_PORT_MACAUTH/BR_PORT_MAB/ ?

Sure, I will do that. :-)
