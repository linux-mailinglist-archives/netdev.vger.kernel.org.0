Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5951FBA7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiEILsb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 May 2022 07:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiEILsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:48:30 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 04:44:31 PDT
Received: from anubis.tmit.bme.hu (anubis.tmit.bme.hu [152.66.245.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FC71A01;
        Mon,  9 May 2022 04:44:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by anubis.tmit.bme.hu (Postfix) with ESMTP id 52E0F33D64;
        Mon,  9 May 2022 13:27:31 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at tmit.bme.hu
Received: from anubis.tmit.bme.hu ([127.0.0.1])
        by localhost (anubis.tmit.bme.hu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aYLOkPk-8LOo; Mon,  9 May 2022 13:27:28 +0200 (CEST)
Date:   Mon, 9 May 2022 13:27:27 +0200
From:   =?iso-8859-1?Q?Istv=E1n_Moldov=E1n?= <moldovan@tmit.bme.hu>
Message-ID: <17110700998.20220509132727@tmit.bme.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        =?iso-8859-1?Q?Bal=E1zs_Varga_A?= <balazs.a.varga@ericsson.com>,
        Janos Farkas <Janos.Farkas@ericsson.com>,
        =?iso-8859-1?Q?Mikl=F3s_M=E1t=E9?= <mate@tmit.bme.hu>
Subject: Re: [RFC, net-next] net: qos: introduce a frer action to implement 802.1CB
In-Reply-To: <20220506193103.hla2jlpawn6te5cl@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com> 
  <df67ceaa-4240-d084-7ba1-d703f0c38f33@ericsson.com>
  <20220506122334.i7eqt2ngbfwqlrwn@skbuf>
  <ef5ef65f-0410-2d0a-dff4-4f4421e34fb1@ericsson.com>
  <20220506193103.hla2jlpawn6te5cl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It is an interesting conversation, see my comments below.

> On Fri, May 06, 2022 at 02:44:17PM +0000, Ferenc Fejes wrote:
>> > Glad to see someone familiar with 802.1CB. I have a few questions and
>> > concerns if you don't mind.
>> 
>> I CCd Balazs Varga  and Janos Farkas, experts of the TSN topics
>> including 802.1CB as well. Istvan Moldovan's can also give valuable
>> feedback as the author of our in-house userspace FRER. I'll also try my
>> best to answer but I'm the least competent in the topic.
>> 

> Nope, that would probably be me ;)
> I am commenting on Xiaoliang's patch without having even run it, and I
> have only looked through the code diagonally, and I'm not exactly an
> expert on the use cases that drove the standard either. So plenty of
> chances to make mistakes. But nonetheless I hope that by explaining to
> me where I'm wrong we'll be able to make progress with this.

>> >
>> > I think we are seeing a bit of a stall on the topic of FRER modeling in
>> > the Linux networking stack, in no small part due to the fact that we are
>> > working with pre-standard hardware.
>> >
>> > The limitation with Xiaoliang's proposal here (to model FRER stream
>> > replication and recovery as a tc action) is that I don't think it works
>> > well for traffic termination - it only covers properly the use case of a
>> > switch. More precisely, there isn't a single convergent termination
>> > point for either locally originating traffic, or locally received
>> > traffic (i.e. you, as user, don't know on which interface of several
>> > available to open a socket).
>> >
>> > In our hardware, this limitation isn't really visible because of the way
>> > in which the Ethernet switch is connected inside the NXP LS1028A.
>> 
>> We have some NXP LS1028As as well so at least I familiar with the box :-)

> Cool, this means we'll eventually reach a common understanding of the
> topic.

>> > It is something like this:
>> >
>> >    +---------------------------------------+
>> >    |                                       |
>> >    |           +------+ +------+           |
>> >    |           | eno2 | | eno3 |           |
>> >    |           +------+ +------+           |
>> >    |              |         |              |
>> >    |           +------+ +------+           |
>> >    |           | swp4 | | swp5 |           |
>> >    |           +------+ +------+           |
>> >    |  +------+ +------+ +------+ +------+  |
>> >    |  | swp0 | | swp1 | | swp2 | | swp3 |  |
>> >    +--+------+-+------+-+------+-+------+--+
>> >
>> > In the above picture, the switch ports swp0-swp3 have eno3 as a DSA
>> > master (connected to the internal swp5, a CPU port). The other internal
>> > port, swp5, is configured as a DSA user port, so it has a net device.
>> > Analogously, while eno3 is a DSA master and receives DSA-tagged traffic
>> > (so it is useless for direct IP termination), eno2 receives DSA untagged
>> > traffic and is therefore an IP termination endpoint into a switched
>> > network.
>>
>> Unfortunately I'm not familiar with the distributed switch architecture
>> (I only read a netdev paper from that and thats all) but I try to grasp
>> on the problem.
>> In my understanding, the main issue is the distinction between the
>> locally terminated and forwarded TSN streams, because currently the DSA
>> metadata tags are required to do that? Can you explain the problem for
>> one who not familiar with DSA?

> Forget about DSA, what I'm trying to get at is that you might one day
> read the release notes of the Linux kernel and see that it gained
> support for FRER using tc, and get all excited, download and compile it,
> set up 2 machines connected through 2 port pairs, and try to configure
> the systems to ping each other redundantly, to become familiar with how
> it works. Start with something simple, what can be so hard about a ping ;)

> You'll say something along the lines of

> 1. ok, I have 2 IP addresses, so I need 2 streams, one A -> B and one B -> A
Don't forget about the background traffic. Nothing will work if ARP is not working, 
and ARP packets have broadcast destination (they will not be identified as part of
the streams). So besides the FRER forwarding, normal bridging should also be working!

> 2. I want to use the null stream identification function (MAC DA, VLAN ID
>    for those following along) so I have to resolve each IP address to a
>    MAC address to use as a stream identifier, but how? since the 2
>    Ethernet cards on each system have different MAC addresses. Anyway,
>    pick one and put the other card in promisc for now.
TSN streams by definition are Layer 2, so we suppose that MAC addresses (and VLANs) are known.


> 3. I have the MACs now, I want to configure the streams. The stream "A -> B"
>    needs to be configured for splitting on the first system, and for
>    sequence recovery on the second system. The stream "B -> A" needs to
>    be configured for recovery on the first system and for splitting on
>    the second.

> 4. Let's start with splitting, this is just the "mirred egress mirror"
>    action, nothing FRER specific about it. There's also the "frer rtag
>    tag-action tag-push" action which adds the redundancy tag. Good thing
>    these actions can be chained. So let's put a filter on the egress
>    qdisc of eth0, that matches on the MAC address of B, and has a mirred
>    mirror action to eth1, and a "rtag tag-push" action. Notice how by
>    this time, eth0 becomes sort of a "primary" interface and eth1 sort
>    of a "secondary" interface. So if you ping, you need to use eth0.
>    What if the link goes down on eth0 you ask, how does the "redundancy"
>    in "frer" come into play, with the traffic still going through eth1?
>    No time to ask questions like that, let's move on.
Well, there should be no "primary" or "secondary". The two interfaces should be equally
handled, otherwise a lot of other issues appear...

> 5. Let's say that both links are up, and system B is receiving a
>    replicated stream with FRER tags on both eth0 and eth1. It wants to
>    eliminate the duplicates and see a continuous flow of ICMP requests
>    without the extra FRER tag. Back to the documentation. We see 2 kinds
>    of stream recovery, one is "individual" recovery which is a
>    "frer rtag recover" action put on the ingress qdisc of an interface,
>    and the other is just "recovery", which is the same action but put on
>    the egress qdisc. We don't want individual sequence recovery processes
>    on eth0 and eth1 of station B, since those won't consider the packets
>    as being members of the same stream, and the'll still be duplicated.
>    So we want the normal recovery. But on whose netdev's egress qdisc do
>    we put the "rtag recover" action? Both eth0 and eth1 are receiving.
>    There is no central convergence point.

> Now you're stumped and thinking, how is this supposed to be used?
> What can you do with it? I mean, I can probably create a veth pair as
> that aforementioned missing convergence point, and guide packets from
> {eth0, eth1} towards the lefthand side of the veth pair, using mirred
> redirect.
> Then I can put the frer rules on the egress qdisc of the lefthand side
> of the veth pair, and recover the plaintext traffic (no duplicates, no
> RTAG) on the righthand side of the veth pair. But... seriously?
> And there is not even one mention of this in the documentation?
> And even so. You need to send the request through eno0 and expect to
> receive the reply through a veth interface? How is any user space
> application ever going to work?
We definitely need a convergence point for the elimination part. Frames from both 
redundant paths should be received by the elimination function.
A virtual interface (like tap0 ) or a special netdevice could be the convergence point.

> Now comes the connection with DSA. Xiaoliang made tc-frer with LS1028A
> offloading in mind. No criticism there, after all it is the hardware we
> are working with.

> The intended usage pattern is to put the FRER rules on the switch port
> netdevices, and to do the termination on the switch-unaware netdevices.
> In other words, it's as if eno2 is connected to a completely external
> RedBox, and tc-frer only serves externally received traffic. Except that
> those 2 isolated parts of the system are physically embedded in one.

> So at step (1) you put the IP on eno2, at step (2) you choose the MAC
> address for the stream to be that of eno2, at step (4) you configure the
> split action (mirred towards the external ports, plus FRER tag push) on
> the _ingress_ of swp4 (traffic sent by eno2 is received by swp4).
> At step (5) you put the sequence recovery on the _egress_ of swp4
> (traffic that egresses swp4 ingresses eno2).

> So then you might ask, what would we do if we didn't have that eno2 <->
> swp4 port pair? Is tc-frer useful for someone who doesn't, but is maybe
> even able to offload 802.1CB streams, including termination, through
> some other paradigm? The thing is that, as far as I can tell, Linux does
> not really like to set up a network for the exclusive use of others
> (pure forwarding), to which it has no local access. This is essentially
> the design of tc-frer, and my issue with it.

I think the DSA case is a special one, and the solution should also work having 
just two NICs. Besides having a tap/veth port we can also put the replication/
elimination point to the bridge.
Of course, in that case the we don't need a virtual interface, but instead we 
are tied to the Linux bridge. The HW offload could also work - but a bit differently. 
I'm not saying this is a better solution, but it is an other way to implement FRER, 
and it has the advantage of handling the background traffic as well.

>> >
>> > What we do in this case is put tc-frer rules for stream replication and
>> > recovery on swp4 itself, and we use eno2 as the convergence point for
>> > locally terminated streams.
>> >
>> > However, naturally, a hardware design that does not look like this can't
>> > terminate traffic like this.
>> 
>> Yes, this is my concern too. What would be a nice to have thing if the
>> user can configure the SW implementation and the HW offload with the
>> same commands and the original tc-frer approach fits well to this
>> concept. Anything towards that direction is the way forward IMO, even if
>> the underlying implementation will change.
>> >
>> > My idea was that it might be better if FRER was its own virtual network
>> > interface (like a bridge), with multiple slave interfaces. The FRER net
>> > device could keep its own database of streams and actions (completely
>> > outside of tc) which would be managed similar to "bridge fdb add ...".
>> > This way, the frer0 netdevice would be the local termination endpoint,
>> > logically speaking.
>> 
>> Interesting approach. To be honest I dont see the long term implications
>> of this solution, others might have ideas about the pros and cons, but
>> that looks like a solution where local stream termination is trivial.

> The implication is that you can easily do stuff with FRER. Maybe I'm
> relying too much on ping as an example, but I am really lacking real
> life use cases. Feedback here would be extremely appreciated.
Ping is OK as test traffic, but probably in real life you can expect VLAN tagged 
traffic. Also, as I mentioned ARP is not part of the TSN stream, but it should go through.
Just like for ping.

>> > What I don't know for sure is if a FRER netdevice is supposed to forward
>> > frames which aren't in its list of streams (and if so, by which rules).
>> 
>> Yes this sounds correct, somehow non-local packets should be forwarded
>> too with a bridge. Is it possible to the linux bridge recognize if one
>> port is a frer0 port (or on the frer0 if that is enslaved) and do the
>> forwarding of the streams? Re-implementing bridge functions just for the
>> frer device would be redundant. Unfortunately I never dug myself deep
>> enough into the linux bridge code, just when debugged VXLAN ARP
>> suppression for EVPN, but I think it would be possible to exchange some
>> metadatas between the bridge and the frer device to do the
>> forwarding/terminating decision, something like here [0]

I think FRER frames need to be handled before entering the bridge. Or if the 
bridge does the FRER, then the first thing is to identify and handle the FRER streams...

> The other question if you're in favor of "FRER as net device" is whether
> we should have a FRER interface per TSN stream (or per stream pair, RX
> and TX, since streams are unidirectional), or a FRER interface for all
> TSN streams. If the latter, we're moving more towards "FRER integrated
> in bridge" territory. Or... maybe even resolve local termination through
> some other mechanism, and still build on top of a tc-frer action.
We don't need FRER device per stream. However, per-stream state needs to
be maintained. If we have a FRER netdevice, we have to assign the related interfaces
as "slave" ports. These ports will have to identify the FRER streams and forward them
to the FRER netdevice, and the rest of the traffic needs to be handled normally.
So besides the FRER netdevice we can still have a bridge running to handle the other traffic.
On the other hand, we can still have multiple FRER netdevices, if needed, and we can assign 
different slave interfaces to the different FRER netdevices.

> The thing with "FRER as net device" on the other hand is that we've
> already started modeling PSFP through tc. So if the FRER device has its
> own rules, then "these" streams are not the same as "those" streams, and
> a user would have to duplicate parts of the configuration. Whereas I
> think the PSFP standard refers to stream identifiers directly from 802.1CB.
Unfortunately this is true, we have to configure the filtering at the ingress interface,
and further configuration is needed at the FRER netdevice. 


>> > Because if a FRER netdevice is supposed to behave like a regular bridge
>> > for non-streams, the implication is that the FRER logic should then be
>> > integrated into the Linux bridge.
>>
>> This is (for me) more appealing. Also we can keep that in mind when
>> Linux will support deterministic layer3 networking (IETF DetNet WG RFCs)
>> it would be nice to have mapping between TSN and DetNet streams, then
>> forward the packets on DetNet tunnels as well (with different
>> endpoints). This is something our team researching so Balazs and Istvan
>> might give you some info about that. But I admit that thinking about
>> playing nicely with DetNet in regard of the current linux FRER
>> implementation is more than overwhelming, but the Linux bridge would be
>> a nice place to map TSN flows to DetNet flow like currently EVPN maps
>> VLANs to VXLANs.

Having FRER in the bridge also has some disadvantages. What if I want to use 
openvswitch? Netdevice based FRER can work with Linux bridge and openvswitch too.


> So what would be the use case for bridging packets belonging to
> unrecognized TSN streams? In my toy setups I almost ran out of ideas how
> to drop unwanted traffic and prevent it from being looped forever.
> STP, MSTP, MRP are all out the window, this is active redundancy, you
> need to embrace the loops, so it isn't as if you can pretend that
> something sane is going to happen with a packet if it isn't part of a
> stream that gets special handling from 802.1CB. No broadcast, no
> multicast, and self address filtering on all switch ports.
It is really important that FRER streams need to be identified immediately
and not handled as normal traffic. If we identify the FRER streams first,
and handle them, then we can avoid the loops. So it is not enough to use a hook,
we need to prevent further processing of FRER frames.
The rest of the traffic can be handled normally, even broadcast/multicast.
The unrecognized TSN streams may cause loop, that's true, but I think that is a
misconfiguration, and can not be avoided. 

>> > Also, this new FRER software model complicates the offloading on NXP
>> > LS1028A, but let's leave that aside, since it shouldn't really be the
>> > decisive factor on what should the software model look like.
>> >
>> > Do you have any comments on this topic?
>> I would like to see if others can join to the discussion as well, I will
>> try to think about this problem more too.
>>
>> [0] https://lore.kernel.org/netdev/20220301050439.31785-10-roopa@nvidia.com/
>>
>> Best,
>> Ferenc



-- 
Üdvözlettel
István Moldován
mailto:moldovan@tmit.bme.hu

