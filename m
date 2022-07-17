Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BE057772C
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiGQPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGQPx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:53:26 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAA0DF69;
        Sun, 17 Jul 2022 08:53:23 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 76F881884D64;
        Sun, 17 Jul 2022 15:53:22 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 5FACA25032B7;
        Sun, 17 Jul 2022 15:53:22 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 56240A1E00AF; Sun, 17 Jul 2022 15:53:22 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 17 Jul 2022 17:53:22 +0200
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
In-Reply-To: <YtQosZV0exwyH6qo@shredder>
References: <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <YtQosZV0exwyH6qo@shredder>
User-Agent: Gigahost Webmail
Message-ID: <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
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

On 2022-07-17 17:20, Ido Schimmel wrote:
> On Sun, Jul 17, 2022 at 02:21:47PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-07-13 14:39, Ido Schimmel wrote:
>> > On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com
>> > wrote:
>> 
>> >
>> > What are "Storm Prevention" and "zero-DPV" FDB entries?
>> 
>> They are both FDB entries that at the HW level drops all packets 
>> having a
>> specific SA, thus using minimum resources.
>> (thus the name "Storm Prevention" aka, protection against DOS attacks. 
>> We
>> must remember that we operate with CPU based learning.)
>> 
>> >
>> > There is no decision that I'm aware of. I'm simply trying to understand
>> > how FDB entries that have 'BR_FDB_ENTRY_LOCKED' set are handled in
>> > mv88e6xxx and other devices in this class. We have at least three
>> > different implementations to consolidate:
>> >
>> > 1. The bridge driver, pure software forwarding. The locked entry is
>> > dynamically created by the bridge. Packets received via the locked port
>> > with a SA corresponding to the locked entry will be dropped, but will
>> > refresh the entry. On the other hand, packets with a DA corresponding to
>> > the locked entry will be forwarded as known unicast through the locked
>> > port.
>> >
>> > 2. Hardware implementations like Spectrum that can be programmed to trap
>> > packets that incurred an FDB miss. Like in the first case, the locked
>> > entry is dynamically created by the bridge driver and also aged by it.
>> > Unlike in the first case, since this entry is not present in hardware,
>> > packets with a DA corresponding to the locked entry will be flooded as
>> > unknown unicast.
>> >
>> > 3. Hardware implementations like mv88e6xxx that fire an interrupt upon
>> > FDB miss. Need your help to understand how the above works there and
>> > why. Specifically, how locked entries are represented in hardware (if at
>> > all) and what is the significance of not installing corresponding
>> > entries in hardware.
>> >
>> 
>> With the mv88e6xxx, a miss violation with the SA occurs when there is 
>> no
>> entry. If you then add a normal entry with the SA, the port is open 
>> for that
>> SA of course.
> 
> Good
> 
>> The zero-DPV entry is an entry that ensures that there is no more miss
>> violation interrupts from that SA, while dropping all entries with the
>> SA.
> 
> Few questions:
> 
> 1. Is it correct to think of this entry as an entry pointing to a
> special /dev/null port?

I guess you can think of it like that. It's internal to the chipset how 
it does it.

> 
> 2. After installing this entry, you no longer get miss violation
> interrupts because packets with this SA incur a mismatch violation
> (src_port != /dev/null) and therefore discarded in hardware?

Yes, and mismatch violations are suppressed in this implementation when 
locking the port.

> 
> 3. What happens to packets with a DA matching the zero-DPV entry, are
> they also discarded in hardware? If so, here we differ from the bridge
> driver implementation where such packets will be forwarded according to
> the locked entry and egress the locked port

I understand that egress will follow what is setup with regard to UC, MC 
and BC, though I haven't tested that. But no replies will get through of 
course as long as the port hasn't been opened for the iface behind the 
locked port.

> 
> 4. The reason for installing this entry is to suppress further miss
> violation interrupts?

Yes, while still HW dropping all ingress packets with the same (SA-mac, 
vlan) on  the port.

> 
> 5. If not replaced, will this entry always age out after the ageing
> time? Not sure what can refresh it given that traffic does not ingress
> from the /dev/null port.

That is where my implementation keeps the entries in a list and removes 
them after the bridge timeout using a kernel worker and jiffies.
So by default they age out after approx. 5 min.

> 
> Thanks
