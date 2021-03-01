Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D023D328113
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 15:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhCAOhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 09:37:10 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:48239 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhCAOhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 09:37:00 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E68B722178;
        Mon,  1 Mar 2021 15:36:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1614609376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gNeQD5SbVZhSy9PEjYx9m0NatLXIR3ItEm76eCsnb8Y=;
        b=UsEejf03W4nLbirbIuTz7rq3YV8ELlTzclUw1oEUThvo9fnJ16t1om/StLKXk5iRr1E/Oc
        vpDlUlE4D9SJA7+xhlVXp/CrQGbKK8Gf1/ghxSeu8j9gmGbyhGelDACR9i/2eHuCCLstNQ
        aIi08qpyiA592dfAA9HK0nIVX4Ggyys=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Mar 2021 15:36:15 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Markus_Bl=C3=B6ch?= =?UTF-8?Q?l?= 
        <Markus.Bloechl@ipetronik.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
In-Reply-To: <20210228224804.2zpenxrkh5vv45ph@skbuf>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
 <20210228224804.2zpenxrkh5vv45ph@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-28 23:48, schrieb Vladimir Oltean:
> On Sat, Feb 27, 2021 at 02:18:20PM +0100, Michael Walle wrote:
>> Am 2021-02-27 01:16, schrieb Vladimir Oltean:
>> > On Fri, Feb 26, 2021 at 03:49:22PM -0800, Jakub Kicinski wrote:
>> > > On Sat, 27 Feb 2021 01:42:44 +0200 Vladimir Oltean wrote:
>> > > > On Fri, Feb 26, 2021 at 03:28:36PM -0800, Jakub Kicinski wrote:
>> > > > > I don't understand what you're fixing tho.
>> > > > >
>> > > > > Are we trying to establish vlan-filter-on as the expected behavior?
>> > > >
>> > > > What I'm fixing is unexpected behavior, according to the applicable
>> > > > standards I could find.
>> 
>> In the referenced thread you quoted from the IEEE802.3 about the 
>> promisc
>> mode.
>>   The MAC sublayer may also provide the capability of operating in the
>>   promiscuous receive mode. In this mode of operation, the MAC 
>> sublayer
>>   recognizes and accepts all valid frames, regardless of their 
>> Destination
>>   Address field values.
>> 
>> Your argument was that the standard just talks about disabling the 
>> DMAC
>> filter. But was that really the _intention_ of the standard? Does the
>> standard even mention a possible vlan tag? What I mean is: maybe the
>> standard just mention the DMAC because it is the only filtering 
>> mechanism
>> in this standard and it's enough to disable it to "accept all valid 
>> frames".
>> 
>> I was biten by "the NIC drops frames with an unknown VLAN" even if
>> promisc mode was enabled. And IMHO it was quite suprising for me.
> 
> In short, promiscuity is a function of the MAC sublayer, which is the
> lower portion of the Data Link Layer (the higher portion being the
> Logical Link Control layer - LLC). The MAC sublayer is governed by IEEE
> 802.3, and IEEE 802.1Q does not change anything related to promiscuity,
> so everything still applies.
> 
> The MAC sublayer provides its services to the MAC client through
> something called the MAC service, which uses the following primitives:
> 
> MA_DATA.request(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	frame_check_sequence)
> 
> to send a frame, and
> 
> MA_DATA.indication(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	frame_check_sequence,
> 	ReceiveStatus)
> 
> to receive a frame.
> 
> One particular component of the MAC sublayer seems to be called the
> Internal Sublayer Service (ISS), and this one is defined in IEEE
> 802.1AC-2016. To be frank, I don't quite grok why there needs to exist
> this extra layering, but nonetheless, the ISS has some similar service
> primitives to the MAC sublayer as well, and these are:
> 
> M_UNITDATA.indication(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	priority,
> 	drop_eligible,
> 	frame_check_sequence,
> 	service_access_point_identifier,
> 	connection_identifier)
> 
> M_UNITDATA.request(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	priority,
> 	drop_eligible,
> 	frame_check_sequence,
> 	service_access_point_identifier,
> 	connection_identifier)
> 
> where a "unit of data" is basically just very pompous speak for
> "a frame", I guess.
> 
> Promiscuity is defined in IEEE 802.3 clause 4A.2.9 Frame reception,
> which _in_context_ talks about the interface between the MAC client and
> the MAC sublayer, so that means about the M_UNITDATA.indication or the
> MA_DATA.indication.
> 
> Whereas VLAN filtering, as well as adding and removing VLAN tags, is
> governed by IEEE 802.1Q, as a function of the Enhanced Internal 
> Sublayer
> Service (EISS), i.e. clause 6.8. In fact, the EISS is just an ISS
> enhanced for VLAN filtering, as the naming and definition implies.
> 
> Of course (why not), the EISS has its own service primitives towards 
> its
> higher-level clients for transmitting and receiving a frame. These are:
> 
> EM_UNITDATA.request(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	priority,
> 	drop_eligible,
> 	vlan_identifier,
> 	frame_check_sequence,
> 	service_access_point_identifier,
> 	connection_identifier,
> 	flow_hash,
> 	time_to_live)
> 
> EM_UNITDATA.indication(
> 	destination_address,
> 	source_address,
> 	mac_service_data_unit,
> 	priority,
> 	drop_eligible,
> 	vlan_identifier,
> 	frame_check_sequence,
> 	service_access_point_identifier,
> 	connection_identifier,
> 	flow_hash,
> 	time_to_live)
> 
> There's a big note in IEEE 802.1Q that says:
> 
> The destination_address, source_address, mac_service_data_unit,
> priority, drop_eligible, service_access_point_identifier,
> connection_identifier, and frame_check_sequence parameters are as
> defined for the ISS.
> 
> So basically, although the EISS extends the ISS, it has not changed the
> aspects of it regarding what constitutes a destination_address. So 
> there
> is nothing that redefines the promiscuity concept to extend it with the
> vlan_identifier.
> 
> Additionally, the 802.1Q spec talks about this EISS Multiplex Entity
> thing, which can be used by a VLAN-aware end station to provide a SAP
> (Service Access Point, in context it means an instance of the Internal
> Sublayer Service), one per VID of interest, to separate MAC clients.
> That is to say, the EISS Multiplex Entity provides multiple
> M_UNITDATA.indication and M_UNITDATA.request services to multiple MAC
> clients, one per VLAN. Each individual service can be in "promiscuous"
> mode. This is similar to how in Linux, each 8021q upper of a physical
> interface can be promiscuous or not.

Ok, I see, so your proposed behavior is backed by the standards. But
OTOH there was a summary by Markus of the behavior of other drivers:
https://lore.kernel.org/netdev/20201119153751.ix73o5h4n6dgv4az@ipetronik.com/
And a conclusion by Jakub:
https://lore.kernel.org/netdev/20201112164457.6af0fbaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/#t
And a propsed core change to disable vlan filtering with promisc mode.
Do I understand you correctly, that this shouldn't be done either?

Don't get me wrong, I don't vote against or in favor of this patch.
I just want to understand the behavior.

I haven't had time to actually test this, but what if you do:
  - don't load the 8021q module (or don't enable kernel support)
  - enable promisc
  (1)
  - load 8021q module
  (2)
  - add a vlan interface
  (3)
  - add another vlan interface
  (4)

What frames would you actually receive on the base interface
in (1), (2), (3), (4) and what is the user expectation?
I'd say its the same every time. (IIRC there is already some
discrepancy due to the VLAN filter hardware offloading)

>> > > > If I don't mark this change as a bug fix but as
>> > > > a simple patch, somebody could claim it's a regression, since promiscuity
>> > > > used to be enough to see packets with unknown VLANs, and now it no
>> > > > longer is...
>> > >
>> > > Can we take it into net-next? What's your feeling on that option?
>> >
>> > I see how you can view this patch as pointless, but there is some
>> > context to it. It isn't just for tcpdump/debugging, instead NXP has some
>> > TSN use cases which involve some asymmetric tc-vlan rules, which is how
>> > I arrived at this topic in the first place. I've already established
>> > that tc-vlan only works with ethtool -K eth0 rx-vlan-filter off:
>> > https://lore.kernel.org/netdev/CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com/
>> 
>> Wasn't the conclusion that the VID should be added to the filter so it
>> also works with vlan filter enabled? Am I missing another discussion?
> 
> Well, the conclusion was just that a tc-flower key that contains a VLAN
> ID will not be accepted by a VLAN-filtering NIC. Similarly, a tc-flower
> key that contains a destination MAC address will not be accepted by a
> NIC with IFF_UNICAST_FLT.
> 
> There was no further discussion, it is just an elementary deduction 
> from
> that point. There are two equally valid options:
> - make tc-flower use the vlan_vid_add API when it installs a vlan_id
>   key, and the dev_uc_add/dev_mc_add API when it installs a dst_mac key
> OR
> - disable VLAN filtering if you're using vlan_id keys on VLAN-aware
>   NICs, and put the interface in promiscuous mode if you're using
>   dst_mac keys that are different from the NIC's filtering list.
> 
> I chose option 2 because it was way simpler and was just as correct.

Fair, but it will also put additional burden to the user to also
disable the vlan filtering, right?. Otherwise it would just work. And
it will waste CPU cycles for unwanted frames.
Although your new patch version contains a new "(yet)" ;)

-michael
