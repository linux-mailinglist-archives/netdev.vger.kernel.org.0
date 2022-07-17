Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0235A5776D5
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiGQO54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGQO5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:57:55 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7826613CD6;
        Sun, 17 Jul 2022 07:57:53 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 1409A1886609;
        Sun, 17 Jul 2022 14:57:51 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 0A60E25032B8;
        Sun, 17 Jul 2022 14:57:51 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id EA7C7A1E00AF; Sun, 17 Jul 2022 14:57:50 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 17 Jul 2022 16:57:50 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
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
In-Reply-To: <20220717135951.ho4raw3bzwlgixpb@skbuf>
References: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <20220717125718.mj7b3j3jmltu6gm5@skbuf>
 <a6ec816279b282a4ea72252a7400d5b3@kapio-technology.com>
 <20220717135951.ho4raw3bzwlgixpb@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <e1c1e7c114f0226b116d9549cea8e7a9@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM28,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-17 15:59, Vladimir Oltean wrote:
> On Sun, Jul 17, 2022 at 03:09:10PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-07-17 14:57, Vladimir Oltean wrote:
>> > On Sun, Jul 17, 2022 at 02:21:47PM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > On 2022-07-13 14:39, Ido Schimmel wrote:
>> > > > On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com
>> > > > wrote:
>> > >
>> > > >
>> > > > What are "Storm Prevention" and "zero-DPV" FDB entries?
>> > >
>> > > They are both FDB entries that at the HW level drops all packets
>> > > having a
>> > > specific SA, thus using minimum resources.
>> > > (thus the name "Storm Prevention" aka, protection against DOS
>> > > attacks. We
>> > > must remember that we operate with CPU based learning.)
>> >
>> > DPV means Destination Port Vector, and an ATU entry with a DPV of 0
>> > essentially means a FDB entry pointing nowhere, so it will drop the
>> > packet. That's a slight problem with Hans' implementation, the bridge
>> > thinks that the locked FDB entry belongs to port X, but in reality it
>> > matches on all bridged ports (since it matches by FID). FID allocation
>> > in mv88e6xxx is slightly strange, all VLAN-unaware bridge ports,
>> > belonging to any bridge, share the same FID, so the FDB databases are
>> > not exactly isolated from each other.
>> 
>> But if the locked port is vlan aware and has a pvid, it should not 
>> block
>> other ports.
> 
> I don't understand what you want to say by that. It will block all 
> other
> packets with the same MAC SA that are classified to the same FID.
> In case of VLAN-aware bridges, the mv88e6xxx driver allocates a new FID
> for each VID (see mv88e6xxx_atu_new). In other words, if a locked port
> is VLAN-aware and has a pvid, then whatever the PVID may be, all ports
> in that same VLAN are still blocked in the same way.

Maybe I am just trying to understand the problem you are posing, so 
afaics MAC addresses should be unique and having the same MAC address 
behind a locked port and a not-locked port seems like a 
mis-configuration regardless of vlan setup? As the zero-DPV entry only 
blocks the specific SA MAC on a specific vlan, which is behind a locked 
port, there shouldn't be any problem...?

If the host behind a locked port starts sending on another vlan than 
where it got the first locked entry, another locked entry will occur, as 
the locked entries are MAC + vlan.

> 
>> Besides the fid will be zero with vlan unaware afaik, and all with
>> zero fid do not create locked entries.
> 
> If by 0 you mean 1 (MV88E6XXX_FID_BRIDGED), then you are correct: ports
> with FID 0 (MV88E6XXX_FID_STANDALONE) should not create locked FDB
> entries, because they are, well, standalone and not bridged.
> Again I don't exactly see the relevance though.
