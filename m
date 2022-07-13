Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97559572ED3
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiGMHKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiGMHKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:10:04 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEC212097;
        Wed, 13 Jul 2022 00:10:01 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 68F651886A00;
        Wed, 13 Jul 2022 07:09:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 618F625032B7;
        Wed, 13 Jul 2022 07:09:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4745DA1E0083; Wed, 13 Jul 2022 07:09:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Wed, 13 Jul 2022 09:09:58 +0200
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
In-Reply-To: <YsqPWK67U0+Iw2Ru@shredder>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
User-Agent: Gigahost Webmail
Message-ID: <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM14,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-10 10:35, Ido Schimmel wrote:
> On Fri, Jul 08, 2022 at 02:34:25PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-07-08 13:56, Vladimir Oltean wrote:
>> > On Fri, Jul 08, 2022 at 11:50:33AM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > On 2022-07-08 11:15, Vladimir Oltean wrote:
>> > > > When the possibility for it to be true will exist, _all_ switchdev
>> > > > drivers will need to be updated to ignore that (mlxsw, cpss, ocelot,
>> > > > rocker, prestera, etc etc), not just DSA. And you don't need to
>> > > > propagate the is_locked flag to all individual DSA sub-drivers when none
>> > > > care about is_locked in the ADD_TO_DEVICE direction, you can just ignore
>> > > > within DSA until needed otherwise.
>> > > >
>> > >
>> > > Maybe I have it wrong, but I think that Ido requested me to send it
>> > > to all
>> > > the drivers, and have them ignore entries with is_locked=true ...
>> >
>> > I don't think Ido requested you to ignore is_locked from all DSA
>> > drivers, but instead from all switchdev drivers maybe. Quite different.
>> 
>> So without changing the signature on port_fdb_add(). If that is to 
>> avoid
>> changing that signature, which needs to be changed anyhow for any 
>> switchcore
>> driver to act on it, then my next patch set will change the signarure 
>> also
>> as it is needed for creating dynamic ATU entries from userspace, which 
>> is
>> needed to make the whole thing complete.
>> 
>> As it is already done (with the is_locked to the drivers) and needed 
>> for
>> future application, I would like Ido to comment on it before I take 
>> action.
> 
> It's related to my reply here [1]. AFAICT, we have two classes of 
> device
> drivers:
> 
> 1. Drivers like mv88e6xxx that report locked entries to the bridge
> driver via 'SWITCHDEV_FDB_ADD_TO_BRIDGE'.
> 
> 2. Drivers like mlxsw that trap packets that incurred an FDB miss to 
> the
> bridge driver. These packets will cause the bridge driver to emit
> 'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications with the locked flag.
> 
> If we can agree that locked entries are only meant to signal to user
> space that a certain MAC tried to gain authorization and that the 
> bridge
> should ignore them while forwarding, then there is no point in
> generating the 'SWITCHDEV_FDB_ADD_TO_DEVICE' notifications. We should
> teach the bridge driver to suppress these so that there is no need to
> patch all the device drivers.

I do not know of all about what other switchcores there are and how they 
work, but those that I have knowledge of, it has been prudent in 
connection with the locked port feature to install Storm Prevention or 
zero-DPV (Destination Port Vector) FDB entries. I would think that that 
should be the case for other switchcores too.
Those entries cannot normally be installed from userspace (of course 
special tools can do anything).

But if the decision is to drop locked entries at the DSA layer, I can do 
that. I just want to ensure that all considerations have been taken.

> 
> [1] https://lore.kernel.org/netdev/YsqLyxTRtUjzDj6D@shredder/
> 
>> 
>> >
>> > In any case I'm going to take a look at this patch set more closely and
>> > run the selftest on my Marvell switch, but I can't do this today
>> > unfortunately. I'll return with more comments.
>> 
>> Yes :-)
