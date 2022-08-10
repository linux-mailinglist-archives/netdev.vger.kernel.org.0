Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090D658E8F0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiHJIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiHJIku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:40:50 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE45E2BB0C;
        Wed, 10 Aug 2022 01:40:47 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3CB0B188494E;
        Wed, 10 Aug 2022 08:40:46 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 344BB25032B7;
        Wed, 10 Aug 2022 08:40:46 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 2B1A7A1A004D; Wed, 10 Aug 2022 08:40:46 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Wed, 10 Aug 2022 10:40:45 +0200
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
In-Reply-To: <YvNcitNnyFxTw8bs@shredder>
References: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
 <YvIm+OvXvxbH6POv@shredder>
 <6c6fe135ce7b5b118289dc370135b0d3@kapio-technology.com>
 <YvNcitNnyFxTw8bs@shredder>
User-Agent: Gigahost Webmail
Message-ID: <2491232d5c017d94ca3213197a3fb283@kapio-technology.com>
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

On 2022-08-10 09:21, Ido Schimmel wrote:
> On Tue, Aug 09, 2022 at 10:00:49PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-08-09 11:20, Ido Schimmel wrote:
>> > On Mon, Aug 01, 2022 at 05:33:49PM +0200, netdev@kapio-technology.com
>> > wrote:
>> > > On 2022-07-13 14:39, Ido Schimmel wrote:
>> > >
>> > > >
>> > > > What are "Storm Prevention" and "zero-DPV" FDB entries?
>> > > >
>> > >
>> > > For the zero-DPV entries, I can summarize:
>> > >
>> > > Since a CPU can become saturated from constant SA Miss Violations
>> > > from a
>> > > denied source, source MAC address are masked by loading a zero-DPV
>> > > (Destination Port Vector) entry in the ATU. As the address now
>> > > appears in
>> > > the database it will not cause more Miss Violations. ANY port trying
>> > > to send
>> > > a frame to this unauthorized address is discarded. Any locked port
>> > > trying to
>> > > use this unauthorized address has its frames discarded too (as the
>> > > ports SA
>> > > bit is not set in the ATU entry).
>> >
>> > What happens to unlocked ports that have learning enabled and are trying
>> > to use this address as SMAC? AFAICT, at least in the bridge driver, the
>> > locked entry will roam, but will keep the "locked" flag, which is
>> > probably not what we want. Let's see if we can agree on these semantics
>> > for a "locked" entry:
>> 
>> The next version of this will block forwarding to locked entries in 
>> the
>> bridge, so they will behave like the zero-DPV entries.
> 
> I'm talking about roaming, not forwarding. Let's say you have a locked
> entry with MAC X pointing to port Y. Now you get a packet with SMAC X
> from port Z which is unlocked. Will the FDB entry roam to port Z? I
> think it should, but at least in current implementation it seems that
> the "locked" flag will not be reset and having locked entries pointing
> to an unlocked port looks like a bug.
> 

Remember that zero-DPV entries blackhole (mask) the MAC, so whenever a 
packet appears with the same MAC on another port it is just dropped in 
the HW, so there is no possibility of doing any CPU processing in this 
case. Only after the timeout (5 min) can the MAC get a normal ATU on an 
open port.
For the bridge to do what you suggest, a FDB search would be needed 
afaics, and this might be in a process sensitive part of the code, thus 
leading to too heavy a cost.

>> 
>> >
>> > 1. It discards packets with matching DMAC, regardless of ingress port. I
>> > read the document [1] you linked to in a different reply and could not
>> > find anything against this approach, so this might be fine or at least
>> > not very significant.
>> >
>> > Note that this means that "locked" entries need to be notified to device
>> > drivers so that they will install a matching entry in the HW FDB.
>> 
>> Okay, so as V4 does (just without the error noted).
>> 
>> >
>> > 2. It is not refreshed and has ageing enabled. That is, after initial
>> > installation it will be removed by the bridge driver after configured
>> > ageing time unless converted to a regular (unlocked) entry.
>> >
>> > I assume this allows you to remove the timer implementation from your
>> > driver and let the bridge driver notify you about the removal of this
>> > entry.
>> 
>> Okay, but only if the scheme is not so that the driver creates the 
>> locked
>> entries itself, unless you indicate that the driver notifies the 
>> bridge,
>> which then notifies back to the driver and installs the zero-DPV 
>> entry? If
>> not I think the current implementation for the mv88e6xxx is fine.
> 
> I don't see a problem in having the driver notifying the bridge about
> the installation of this entry and the bridge notifying the driver that
> the entry needs to be removed. It removes complexity from device 
> drivers
> like mv88e6xxx and doesn't add extra complexity to the bridge driver.
> 
> Actually, there is one complication, 'SWITCHDEV_FDB_ADD_TO_BRIDGE' will
> add the locked entry as externally learned, which means the bridge will
> not age it. Might need something like this:
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index e7f4fccb6adb..5f73d0b44ed9 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -530,7 +530,8 @@ void br_fdb_cleanup(struct work_struct *work)
>  		unsigned long this_timer = f->updated + delay;
> 
>  		if (test_bit(BR_FDB_STATIC, &f->flags) ||
> -		    test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags)) {
> +		    (test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &f->flags) &&
> +		     !test_bit(BR_FDB_ENTRY_LOCKED, &f->flags))) {
>  			if (test_bit(BR_FDB_NOTIFY, &f->flags)) {
>  				if (time_after(this_timer, now))
>  					work_delay = min(work_delay,
> 

There is a case of ownership of the FDB/ATU entry, which if I remember 
correctly, will point to the current implementation being the right way 
to do it, thus having the driver keeping ownership of the entry and 
thereby also ageing it, but I think Vladimir should have his say here.

>> 
>> >
>> > 3. With regards to roaming, the entry cannot roam between locked ports
>> > (they need to have learning disabled anyway), but can roam to an
>> > unlocked port, in which case it becomes a regular entry that can roam
>> > and age.
>> >
>> > If we agree on these semantics, then I can try to verify that at least
>> > Spectrum can support them (it seems mv88e6xxx can).
>> 
>> The consensus here is that at least for the mv88e6xxx, learning should 
>> be on
>> and link local learning should be blocked by the userspace setting you
>> pointed to earlier.
> 
> Why learning needs to be on in the bridge (not mv88e6xxx) driver?

I think it is seen as 'cheating' to enable learning only in the driver 
behind the scenes, so kind of hackish. E.g. 'bridge -d link show' will 
then report 'learning off', while learning is on in the driver.
And learning needs to be on for the driver as discussed earlier, which 
only gives rise to the link local learning problem, which is then solved 
by the user space setting.
