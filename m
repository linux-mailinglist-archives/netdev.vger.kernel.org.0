Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFAA41F7E4
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhJAW6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:58:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:61509 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356172AbhJAW57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:57:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="222401574"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="222401574"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 15:56:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="480775114"
Received: from unknown (HELO vcostago-mobl3) ([10.134.46.83])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 15:56:12 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
In-Reply-To: <20211001175524.3sa2m3occzham5og@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <87lf3cfyfj.fsf@intel.com> <20211001175524.3sa2m3occzham5og@skbuf>
Date:   Fri, 01 Oct 2021 15:56:12 -0700
Message-ID: <87fstkfj77.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Fri, Oct 01, 2021 at 10:27:12AM -0700, Vinicius Costa Gomes wrote:
>> Xiaoliang Yang <xiaoliang.yang_1@nxp.com> writes:
>> 
>> > Hi Vinicius,
>> >
>> > On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
>> >> > This patch introduce a frer action to implement frame replication and
>> >> > elimination for reliability, which is defined in IEEE P802.1CB.
>> >> >
>> >> 
>> >> An action seems, to me, a bit too limiting/fine grained for a frame replication
>> >> and elimination feature.
>> >> 
>> >> At least I want to hear the reasons that the current hsr/prp support cannot be
>> >> extended to support one more tag format/protocol.
>> >> 
>> >> And the current name for the spec is IEEE 802.1CB-2017.
>> >> 
>> > 802.1CB can be set on bridge ports, and need to use bridge forward
>> > Function as a relay system. It only works on identified streams,
>> > unrecognized flows still need to pass through the bridged network
>> > normally.
>> 
>> This ("only on identified streams") is the strongest argument so far to
>> have FRER also as an action, in adition to the current hsr netdevice
>> approach.
>> 
>> >
>> > But current hsr/prp seems only support two ports, and cannot use the
>> > ports in bridge. It's hard to implement FRER functions on current HSR
>> > driver.
>> 
>> That the hsr netdevice only support two ports, I think is more a bug
>> than a design issue. Which will need to get fixed at some point. 
>
> What do you mean 'a bug'? HSR and PRP, as protocols, use _two_ ports,
> see IEC 62439-3, that's where the "D" (doubly attached node) in DANH and
> DANP comes from. There's no TANH/TANH for "triply attached node".
> It doesn't scale.

First of all, thank you for taking the time to write such detailed
answer, really helpful.

Another spec that I should take some time and read if I want to keep
commenting on this stuff.

>
>> Speaking of functions, one thing that might be interesting is trying to
>> see if it makes sense to make part of the current hsr functionality a
>> "library" so it can be used by tc-frer as well. (less duplication of
>> bugs).
>
> You mean tc-frer should inherit from the get-go the plethora of bugs
> from the unmaintained hsr driver? :)
>
> That would be good for hsr, which is in a pretty poor state, but the
> design of the 802.1CB spec isn't really in its favor sadly.
>

Fair enough.

So what I am going to suggest is for you folks to write in the RFC how
to use tc-frer (the "toolbox" idea) in "IEC 62439-9 mode", not necessary
to implement it, just to write it down. The idea is that we have a path
forward to better maintained alternatives, as you said, if we stop
recommending people to use/experiment with net/hsr.

>> >
>> > You can see chapter "D.2 Example 2: Various stack positions" in IEEE 802.1CB-2017,
>> > Protocol stack for relay system is like follows:
>> >
>> >              Stream Transfer Function
>> >                 |             |
>> >   				|    	Sequence generation
>> >                 |       	Sequence encode/decode
>> >   Stream identification		Active Stream identification
>> > 				|			  |
>> >   			    |		Internal LAN---- Relay system forwarding
>> > 				|						|		|
>> > 				MAC						MAC		MAC
>> >
>> > Use port actions to easily implement FRER tag add/delete, split, and
>> > recover functions.
>> >
>> > Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
>> > Action to be used for stream RTAG/HSR/PRP set and recover.
>> 
>> I am still reading the spec and trying to imagine how things would fit
>> together:
>>   - for which use cases tc-frer would be useful;
>>   - for which use cases the hsr netdevice would be useful;
>>   - would it make sense to have them in the same system?
>
> You could use FRER in networks where normally you'd use HSR (aka rings).
> In fact the 802.1CB demonstration I have, which uses the NXP tsntool
> program with the downstream genetlink tsn interface, does exactly that:
> https://github.com/vladimiroltean/tsn-scripts
>

After a very quick look, interesting stuff here. Will take a better
look. (even more reading for the weekend)

> Basically FRER is IEEE's take on redundancy protocols and more like a
> generalization of HSR/PRP, the big changes are:
> - not limited to two (or any number of) ports
> - more than one type of stream/flow identification function: can look at
>   source/destination MAC, source/destination IP, VLAN, and most
>   importantly, there can be passive stream identification functions (don't
>   modify the packet) and active stream identification functions (do
>   modify the packet).
>
> Please note that we've already started modeling IEEE 802.1CB stream
> identification functions as tc flower filters, since those map nicely on top.
> We use these for PSFP (former 802.1Qci) tc-police and tc-gate actions
> (yes, tc-police is single-bucket and color-unaware, that needs to be improved).
>
> Basically IEEE 802.1CB is a huge toolbox, the spec gives you the tools
> but it doesn't tell you how to use them, that's why the stream
> identification functions are so generic and decoupled from the
> redundancy protocol itself.
>
> In both HSR and PRP, sequence numbers are kept per source MAC address,
> that is absolutely baken into the standard.
>
> But think about this. When the sequence number is kept per source
> station, frames sent from node A to multiple destinations (nodes B and C)
> will be part of the same stream. So nodes B and C will see
> discontinuities in the sequence numbers when node A talks to them.
>
> The opposite is true as well. When sequence numbers are kept per
> destination MAC address, then frames sent from multiple talkers (nodes A
> and B) to the same destination (node C) will be interpreted as part of
> the same stream by the listener. So there will be jumps in sequence
> numbers seen by C when A and B are simultaneously transmitting to it.
>
> Which type of stream identification you need depends on the traffic you
> need to support, and the topology.

Good insight here. Even if I can imagine those simple stream identification
functions working on simple topologies, I totally get you point. 

>
> So again, IEEE 802.1CB doesn't tell you what to do, but it gives you the
> tools. You can do source MAC based stream identification, and you can
> emulate HSR, or you can do something that encompasses both source node
> information as well as destination node information.
>
> It's one whole degree of freedom more flexible, plain and simple.
> And the topologies are not limited to:
> - the rings that HSR supports
> - the disjoint IP networks that PRP supports
> but are rather generic graphs.
>
> I fully expect there to be hardware out there already that can convert
> between the HSR/PRP frame format on one set of ports to 802.1CB frame
> format on another set of ports. Maybe that's something that some thought
> needs to be put into.

In short, I am reasonably satisfied with the proposal that tc-frer
offers a superset of net/hsr can do.

Suggestions for the cover letter:
 - Expand a bit on the whole superset/toolbox idea;
 - Document how to use the toolbox to emulate HSR/PRP;


Cheers,
-- 
Vinicius
