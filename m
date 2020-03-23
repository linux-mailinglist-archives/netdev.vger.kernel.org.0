Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791C118FD85
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCWTV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgCWTV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 15:21:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2053E206F8;
        Mon, 23 Mar 2020 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584991287;
        bh=5VCP31QEXux5xllsu7lkzwDuad+0eLLVICL8qL2bmn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iMPyama8zxdSRArcxYcNAics9MFZQzvO/IrhNiF2u9sIkH+ecYOCFN3XCdk27i3wM
         dFMy6adcDFkzxOtHwDIGojrj/h5qog5OoM2CU2FLk474s3c+8zOprPbicAA7SdhVs3
         xUT7Qj0p+b5ADM85V5H1DoO+z7jUpu1+lxRKZXq4=
Date:   Mon, 23 Mar 2020 12:21:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200321093525.GJ11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 10:35:25 +0100 Jiri Pirko wrote:
> Fri, Mar 20, 2020 at 10:25:08PM CET, kuba@kernel.org wrote:
> >On Fri, 20 Mar 2020 08:35:55 +0100 Jiri Pirko wrote:  
> >> Fri, Mar 20, 2020 at 04:32:53AM CET, kuba@kernel.org wrote:  
> >> >On Thu, 19 Mar 2020 20:27:19 +0100 Jiri Pirko wrote:    
> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||            Overall illustration of example setup             ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> Note that there are 2 hosts in the picture. Host A may be the smartnic host,
> >> >> Host B may be one of the hosts which gets PF. Also, you might omit
> >> >> the Host B and just see Host A like an ordinary nic in a host.    
> >> >
> >> >Could you enumerate the use scenarios for the SmartNIC?
> >> >
> >> >Is SmartNIC always "in-line", i.e. separating the host from the network?    
> >> 
> >> As far as I know, it is. The host is always given a PF which is a leg of
> >> eswitch managed on the SmartNIC.  
> >
> >Cool, I was hoping that's the case. One less configuration mode :)
> >  
> >> >Do we need a distinction based on whether the SmartNIC controls Host's
> >> >eswitch vs just the Host in its entirety (i.e. VF switching vs bare
> >> >metal)?    
> >> 
> >> I have this described in the "PFs" section. Basically we need to have a
> >> toggle to say "host is managing it's own nested eswitch.
> >>   
> >> >I find it really useful to be able to list use cases, and constraints
> >> >first. Then go onto the design.
> >> >    
> >> >> Note that the PF is merged with physical port representor.
> >> >> That is due to simpler and flawless transition from legacy mode and back.
> >> >> The devlink_ports and netdevs for physical ports are staying during
> >> >> the transition.    
> >> >
> >> >When users put an interface under bridge or a bond they have to move 
> >> >IP addresses etc. onto the bond. Changing mode to "switchdev" is a more
> >> >destructive operation and there should be no expectation that
> >> >configuration survives.    
> >> 
> >> Yeah, I was saying the same thing when our arch came up with this, but
> >> I now think it is just fine. It is drivers responsibility to do the
> >> shift. And the entities representing the uplink port: netdevs and
> >> devlink_port instances. They can easily stay during the transition. The
> >> transition only applies to the eswitch and VF entities.  
> >
> >If PF is split from the uplink I think the MAC address should stay with
> >the PF, not the uplink (which becomes just a repr in a Host case).
> >  
> >> >The merging of the PF with the physical port representor is flawed.    
> >> 
> >> Why?  
> >
> >See below.
> >  
> >> >People push Qdisc offloads into devlink because of design shortcuts
> >> >like this.    
> >> 
> >> Could you please explain how it is related to "Qdisc offloads"  
> >
> >Certain users have designed with constrained PCIe bandwidth in the
> >server. Meaning NIC needs to do buffering much like a switch would.
> >So we need to separate the uplink from the PF to attach the Qdisc
> >offload for configuring details of PCIe queuing.  
> 
> Hmm, I'm not sure I understand. Then PF and uplink is the same entity,
> you can still attach the qdisc to this entity, right? What prevents the
> same functionality as with the "split"?

The same problem we have with the VF TX rate. We only have Qdisc APIs
for the TX direction. If we only have one port its TX is the TX onto
wire. If we split it into MAC/phys and PCIe - the TX of PCI is the RX
of the host, allowing us to control queuing on the PCIe interface.

> >> >> |  | |  netdev enp6s0f0np1                           |             |    |
> >> >> |  | +->health reporters, params                     |             |    |
> >> >> |  | |                                               |             |    |
> >> >> |  | +->slice_pci/0000:06:00.0/0+--------------------+             |    |
> >> >> |  |       flavour physical                                        |    |
> >> >> |  |                                                               |    |
> >> >> |  +-+port_pci/0000:06:00.0/1+-----------------------+-------------|----+
> >> >> |  | |  flavour physical pfnum 1  (phys port and pf) |             |
> >> >> |  | |  netdev enp6s0f0np2                           |             |
> >> >> |  | +->health reporters, params                     |             |
> >> >> |  | |                                               |             |
> >> >> |  | +->slice_pci/0000:06:00.0/1+--------------------+             |
> >> >> |  |       flavour physical                                        |
> >> >> |  |                                                               |
> >> >> |  +-+-+port_pci/0000:06:00.0/2+-----------+-------------------+   |
> >> >> |  | | |  flavour pcipf pfnum 2            ^                   |   |
> >> >> |  | | |  netdev enp6s0f0pf2               |                   |   |
> >> >> |  | + +->params                           |                   |   |
> >> >> |  | |                                     |                   |   |
> >> >> |  | +->slice_pci/0000:06:00.0/2+----------+                   |   |
> >> >> |  |       flavour pcipf                                       |   |
> >> >> |  |                                                           |   |
> >> >> |  +-+-+port_pci/0000:06:00.0/3+-----------+----------------+  |   |
> >> >> |  | | |  flavour pcivf pfnum 2 vfnum 0    ^                |  |   |
> >> >> |  | | |  netdev enp6s0pf2vf0              |                |  |   |
> >> >> |  | | +->params                           |                |  |   |
> >> >> |  | |                                     |                |  |   |
> >> >> |  | +-+slice_pci/0000:06:00.0/3+----------+                |  |   |
> >> >> |  |   |   flavour pcivf                                    |  |   |
> >> >> |  |   +->rate (qos), mpgroup, mac                          |  |   |
> >> >> |  |                                                        |  |   |
> >> >> |  +-+-+port_pci/0000:06:00.0/4+-----------+-------------+  |  |   |
> >> >> |  | | |  flavour pcivf pfnum 0 vfnum 0    ^             |  |  |   |    
> >> >
> >> >So PF 0 is both on the SmartNIC where it is physical and on the Hosts?
> >> >Is this just error in the diagram?    
> >> 
> >> I think it is error in the reading. This is the VF representation
> >> of VF pci/0000:06:00.1, on the same host A, which is the SmartNIC host.  
> >
> >Hm, I see pf 0 as the first port that has a line to uplink,
> >and here pf 0 vf 0 has a line to Host B.  
> 
> No. The lane is to "Host A"

Ah damn, half of the boxed below are also Host A! Got it now.

> >The VF above is "pfnum 2 vfnum 0" which makes sense, PF 2 is 
> >Host B's PF. So VF 0 of PF 2 is also on Host B.
> >  
> >> >> |  | | |  netdev enp6s0pf0vf0              |             |  |  |   |
> >> >> |  | | +->params                           |             |  |  |   |
> >> >> |  | |                                     |             |  |  |   |
> >> >> |  | +-+slice_pci/0000:06:00.0/4+----------+             |  |  |   |
> >> >> |  |   |   flavour pcivf                                 |  |  |   |
> >> >> |  |   +->rate (qos), mpgroup, mac                       |  |  |   |
> >> >> |  |                                                     |  |  |   |
> >> >> |  +-+-+port_pci/0000:06:00.0/5+-----------+----------+  |  |  |   |
> >> >> |  | | |  flavour pcisf pfnum 0 sfnum 1    ^          |  |  |  |   |
> >> >> |  | | |  netdev enp6s0pf0sf1              |          |  |  |  |   |
> >> >> |  | | +->params                           |          |  |  |  |   |
> >> >> |  | |                                     |          |  |  |  |   |
> >> >> |  | +-+slice_pci/0000:06:00.0/5+----------+          |  |  |  |   |
> >> >> |  |   |   flavour pcisf                              |  |  |  |   |
> >> >> |  |   +->rate (qos), mpgroup, mac                    |  |  |  |   |
> >> >> |  |                                                  |  |  |  |   |
> >> >> |  +-+slice_pci/0000:06:00.0/6+--------------------+  |  |  |  |   |
> >> >> |        flavour pcivf pfnum 0 vfnum 1             |  |  |  |  |   |
> >> >> |            (non-ethernet (IB, NVE)               |  |  |  |  |   |
> >> >> |                                                  |  |  |  |  |   |
> >> >> +------------------------------------------------------------------+
> >> >>                                                    |  |  |  |  |
> >> >>                                                    |  |  |  |  |
> >> >>                                                    |  |  |  |  |
> >> >> +----------------------------------------------+   |  |  |  |  |
> >> >> |  devlink instance PF (other host)    HOST B  |   |  |  |  |  |
> >> >> |                                              |   |  |  |  |  |
> >> >> |  pci/0000:10:00.0  (devlink dev)             |   |  |  |  |  |
> >> >> |  +->health reporters, info                   |   |  |  |  |  |
> >> >> |  |                                           |   |  |  |  |  |
> >> >> |  +-+port_pci/0000:10:00.0/1+---------------------------------+
> >> >> |    |  flavour virtual                        |   |  |  |  |
> >> >> |    |  netdev enp16s0f0                       |   |  |  |  |
> >> >> |    +->health reporters                       |   |  |  |  |
> >> >> |                                              |   |  |  |  |
> >> >> +----------------------------------------------+   |  |  |  |
> >> >>                                                    |  |  |  |
> >> >> +----------------------------------------------+   |  |  |  |
> >> >> |  devlink instance VF (other host)    HOST B  |   |  |  |  |
> >> >> |                                              |   |  |  |  |
> >> >> |  pci/0000:10:00.1  (devlink dev)             |   |  |  |  |
> >> >> |  +->health reporters, info                   |   |  |  |  |
> >> >> |  |                                           |   |  |  |  |
> >> >> |  +-+port_pci/0000:10:00.1/1+------------------------------+
> >> >> |    |  flavour virtual                        |   |  |  |
> >> >> |    |  netdev enp16s0f0v0                     |   |  |  |
> >> >> |    +->health reporters                       |   |  |  |
> >> >> |                                              |   |  |  |
> >> >> +----------------------------------------------+   |  |  |
> >> >>                                                    |  |  |
> >> >> +----------------------------------------------+   |  |  |
> >> >> |  devlink instance VF                 HOST A  |   |  |  |
> >> >> |                                              |   |  |  |
> >> >> |  pci/0000:06:00.1  (devlink dev)             |   |  |  |
> >> >> |  +->health reporters, info                   |   |  |  |
> >> >> |  |                                           |   |  |  |
> >> >> |  +-+port_pci/0000:06:00.1/1+---------------------------+
> >> >> |    |  flavour virtual                        |   |  |
> >> >> |    |  netdev enp6s0f0v0                      |   |  |
> >> >> |    +->health reporters                       |   |  |
> >> >> |                                              |   |  |
> >> >> +----------------------------------------------+   |  |
> >> >>                                                    |  |
> >> >> +----------------------------------------------+   |  |
> >> >> |  devlink instance SF                 HOST A  |   |  |
> >> >> |                                              |   |  |
> >> >> |  pci/0000:06:00.0%sf1    (devlink dev)       |   |  |
> >> >> |  +->health reporters, info                   |   |  |
> >> >> |  |                                           |   |  |
> >> >> |  +-+port_pci/0000:06:00.0%sf1/1+--------------------+
> >> >> |    |  flavour virtual                        |   |
> >> >> |    |  netdev enp6s0f0s1                      |   |
> >> >> |    +->health reporters                       |   |
> >> >> |                                              |   |
> >> >> +----------------------------------------------+   |
> >> >>                                                    |
> >> >> +----------------------------------------------+   |
> >> >> |  devlink instance VF                 HOST A  |   |
> >> >> |                                              |   |
> >> >> |  pci/0000:06:00.2  (devlink dev)+----------------+
> >> >> |  +->health reporters, info                   |
> >> >> |                                              |
> >> >> +----------------------------------------------+
> >> >> 
> >> >> 
> >> >> 
> >> >> 
> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||                 what needs to be implemented                 ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> 1) physical port "pfnum". When PF and physical port representor
> >> >>    are merged, the instance of devlink_port representing the physical port
> >> >>    and PF needs to have "pfnum" attribute to be in sync
> >> >>    with other PF port representors.    
> >> >
> >> >See above.
> >> >    
> >> >> 2) per-port health reporters are not implemented yet.    
> >> >
> >> >Which health reports are visible on a SmartNIC port?     
> >> 
> >> I think there is usecase for SmartNIC uplink/pf port health reporters.
> >> Those are the ones which we have for TX/RX queues on devlink instance
> >> now (that was a mistake). 
> >>   
> >> >
> >> >The Host ones or the SmartNIC ones?    
> >> 
> >> In the host, I think there is a usecase for VF/SF devlink_port health
> >> reporters - also for TX/RX queues.
> >>   
> >> >I think queue reporters should be per-queue, see below.    
> >> 
> >> Depends. There are reporters, like "fw" that are per-asic.
> >> 
> >>   
> >> >    
> >> >> 3) devlink_port instance in PF/VF/SF flavour "virtual". In PF/VF/SF devlink
> >> >>    instance (in VM for example), there would make sense to have devlink_port
> >> >>    instance. At least to carry link to netdevice name (otherwise we have
> >> >>    no easy way to find out devlink instance and netdevice belong to each other).
> >> >>    I was thinking about flavour name, we have to distinguish from eswitch
> >> >>    devlink port flavours "pcipf, pcivf, pcisf".    
> >> >
> >> >Virtual is the flavor for the VF port, IIUC, so what's left to name?
> >> >Do you mean pick a phys_port_name format?    
> >> 
> >> No. "virtual" is devlink_port flavour in the host in the VF devlink  
> >
> >Yeah, I'm not 100% sure what you're describing as missing.
> >
> >Perhaps you could rephrase this point?  
> 
> If you look at the example above. See:
> pci/0000:10:00.0
> That is a devlink instance in host B. It has a port:
> pci/0000:10:00.0/1
> with flavour "virtual"
> that tells the user that this is a virtual link, to the parent eswitch.
> 
> 
> >  
> >> >>    This was recently implemented by Parav:
> >> >> commit 0a303214f8cb8e2043a03f7b727dba620e07e68d
> >> >> Merge: c04d102ba56e 162add8cbae4
> >> >> Author: David S. Miller <davem@davemloft.net>
> >> >> Date:   Tue Mar 3 15:40:40 2020 -0800
> >> >> 
> >> >>     Merge branch 'devlink-virtual-port'
> >> >> 
> >> >>    What is missing is the "virtual" flavour for nested PF.
> >> >> 
> >> >> 4) slice is not implemented yet. This is the original "vdev/subdev" concept.
> >> >>    See below section "Slice user cmdline API draft".
> >> >> 
> >> >> 5) SFs are not implemented.
> >> >>    See below section "SF (subfunction) user cmdline API draft".
> >> >> 
> >> >> 6) rate for slice are not implemented yet.
> >> >>    See below section "Slice rate user cmdline API draft".
> >> >> 
> >> >> 7) mpgroup for slice is not implemented yet.
> >> >>    See below section "Slice mpgroup user cmdline API draft".
> >> >> 
> >> >> 8) VF manual creation using devlink is not implemented yet.
> >> >>    See below section "VF manual creation and activation user cmdline API draft".
> >> >>  
> >> >> 9) PF aliasing. One devlink instance and multiple PFs sharing it as they have one
> >> >>    merged e-switch.
> >> >> 
> >> >> 
> >> >> 
> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||                  Issues/open questions                       ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> 1) "pfnum" has to be per-asic(/devlink instance), not per-host.
> >> >>    That means that in smartNIC scenario, we cannot have "pfnum 0"
> >> >>    for smartNIC and "pfnum 0" for host as well.    
> >> >
> >> >Right, exactly, NFP already does that.
> >> >    
> >> >> 2) Q: for TX, RX queues reporters, should it be bound to devlink_port?
> >> >>    For which flavours this might make sense?
> >> >>    Most probably for flavours "physical"/"virtual".
> >> >>    How about the reporters in VF/SF?    
> >> >
> >> >I think with the work Magnus is doing we should have queues as first    
> >> 
> >> Can you point me to the "work"?  
> >
> >There was a presentation at LPC last year, and some API proposal
> >circulated off-list :( Let's CC Magnus.  
> 
> Ok.
> 
> 
> >  
> >> >class citizens to be able to allocate them to ports.
> >> >
> >> >Would this mean we can hang reporters off queues?    
> >> 
> >> Yes, If we have a "queue object", the per-queue reporter would make sense.
> >> 
> >>   
> >> >    
> >> >> 3) How the management of nested switch is handled. The PFs created dynamically
> >> >>    or the ones in hosts in smartnic scenario may themselves be each a manager
> >> >>    of nested e-switch. How to toggle this capability?
> >> >>    During creation by a cmdline option?
> >> >>    During lifetime in case the PF does not have any childs (VFs/SFs)?    
> >> >
> >> >Maybe the grouping of functions into devlink instances would help? 
> >> >SmartNIC could control if the host can perform switching between
> >> >functions by either putting them in the same Host side devlink 
> >> >instance or not.    
> >> 
> >> I'm not sure I follow. There is a number of PFs created "on probe".
> >> Those are fixed and driver knows where to put them.
> >> The comment was about possible "dynamic PF" created by user in the same
> >> was he creates SF, by devlink cmdline.  
> >
> >How does the driver differentiate between a dynamic and static PF, 
> >and why are they different in the first place? :S  
> 
> They are not different. The driver just has to know to instantiate the
> static ones on probe, so in SmartNIC case each host has a PF.
> 
> 
> >
> >Also, once the PFs are created user may want to use them together 
> >or delegate to a VM/namespace. So when I was thinking we'd need some 
> >sort of a secure handshake between PFs and FW for the host to prove 
> >to FW that the PFs belong to the same domain of control, and their
> >resources (and eswitches) can be pooled.
> >
> >I'm digressing..  
> 
> Yeah. This needs to be sorted out.
> 
> 
> >  
> >> Now the PF itself can have a "nested eswitch" to manage. The "parent
> >> eswitch" where the PF was created would only see one leg to the "nested
> >> eswitch".
> >> 
> >> This "nested eswitch management" might or might not be required. Depends
> >> on a usecare. The question was, how to configure that I as a user
> >> want this or not.  
> >
> >Ack. I'm extending your question. I think the question is not only who
> >controls the eswitch but also which PFs share the eswitch.  
> 
> Yes.
> 
> >
> >I think eswitch is just one capability, but SmartNIC will want to
> >control which ports see what capabilities in general. crypto offloads
> >and such.
> >
> >I presume in your model if host controls eswitch the smartNIC sees just  
> 
> host may control the "nested eswitch" in the SmartNIC case.

By nested eswitch you mean eswitch between ports of the same Host, or
within one PF? Then SmartNIC may switch between PFs or multiple hosts?

> >what what comes out of Hosts single "uplink"? What if SmartNIC wants
> >the host to be able to control the forwarding but not loose the ability
> >to tap the VF to VF traffic?  
> 
> You mean that the VF representors would be in both SmartNIC host and
> host? I don't know how that could work. I think it has to be either
> there or there.

That'd certainly be easier. Without representors we can't even check
traffic stats, though. SmartNIC may want to see the resource
utilization of ports even if it doesn't see the ports. That's just a
theoretical divagation, I don't think it's required.

> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||                Slice user cmdline API draft                  ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> Note that some of the "devlink port" attributes may be forgotten or misordered.
> >> >> 
> >> >> Slices and ports are created together by device driver. The driver defines
> >> >> the relationships during creation.
> >> >> 
> >> >> 
> >> >> $ devlink port show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 0
> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 type eth netdev enp6s0pf0vf1 slice 1
> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 type eth netdev enp6s0pf1vf0 slice 2
> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 type eth netdev enp6s0pf1vf1 slice 3
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr 10:22:33:44:55:77 state active
> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2
> >> >> 
> >> >> In these 2 outputs you can see the relationships. Attributes "slice" and "port"
> >> >> indicate the slice-port pairs.
> >> >> 
> >> >> Also, there is a fixed "state" attribute with value "active". This is by
> >> >> default as the VFs are always created active. In future, it is planned
> >> >> to implement manual VF creation and activation, similar to what is below
> >> >> described for SFs.
> >> >> 
> >> >> Note that for non-ethernet slice (the last one) does not have any
> >> >> related port port. It can be for example NVE or IB. But since
> >> >> the "hw_addr" attribute is also omitted, it isn't IB.
> >> >> 
> >> >>  
> >> >> Now set a different MAC address for VF1 on PF0:
> >> >> $ devlink slice set pci/0000:06:00.0/3 hw_addr aa:bb:cc:dd:ee:ff
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2    
> >> >
> >> >What are slices?    
> >> 
> >> Slice is basically a piece of ASIC. pf/vf/sf. They serve for
> >> configuration of the "other side of the wire". Like the mac. Hypervizor
> >> admin can use the slite to set the mac address of a VF which is in the
> >> virtual machine. Basically this should be a replacement of "ip vf"
> >> command.  
> >
> >I lost my mail archive but didn't we already have a long thread with
> >Parav about this?  
> 
> I believe so.

Oh, well. I still don't see the need for it :( If it's one to one with
ports why add another API, and have to do some cross linking to get
from one to the other?

I'd much rather resources hanging off the port.

> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||          SF (subfunction) user cmdline API draft             ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> Note that some of the "devlink port" attributes may be forgotten or misordered.
> >> >> 
> >> >> Note that some of the "devlink slice" attributes in show commands
> >> >> are omitted on purpose.
> >> >> 
> >> >> $ devlink port show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 2
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66
> >> >> 
> >> >> There is one VF on the NIC.
> >> >> 
> >> >> 
> >> >> Now create subfunction of SF0 on PF1, index of the slice is going to be 100
> >> >> and hw_address aa:bb:cc:aa:bb:cc.
> >> >> 
> >> >> $ devlink slice add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10 hw_addr aa:bb:cc:aa:bb:cc    
> >> >
> >> >Why is the SF number specified by the user rather than allocated?    
> >> 
> >> Because it is snown in representor netdevice name. And you need to have
> >> it predetermined: enp6s0pf1sf10  
> >
> >I'd think you need to know what was assigned, not necessarily pick
> >upfront.. I feel like we had this conversation before as well.  
> 
> Yeah. For the scripting sake, always when you create something, you can
> directly use it later in the script. Like if you create a bridge, you
> assign it a name so you can use it.
> 
> The "what was assigned" would mean that the assigne
> value has to be somehow returned from the kernel and passed to the
> script. Not sure how. Do you have any example where this is happening in
> networking?

Not really, but when allocating objects it seems idiomatic to get the
id / handle / address of the new entity in response. Seems to me we're
not doing it because the infrastructure for it is not in place, but
it'd be a good extension.

Times are a little crazy but I can take a poke at implementing
something along those lines once I find some time..

> I think it is very clear to pass a handle to the command so you can
> later on use this handle to manipulate the entity.
> 
> + I don't see the benefit of the auto-allocation. Do you?
>
> >> >> The devlink kernel code calls down to device driver (devlink op) and asks
> >> >> it to create a slice with particular attributes. Driver then instatiates
> >> >> the slice and port in the same way it is done for VF:
> >> >> 
> >> >> $ devlink port show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0 slice 2
> >> >> pci/0000:06:00.0/3: flavour pcisf pfnum 1 sfnum 10 type eth netdev enp6s0pf1sf10 slice 100
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66
> >> >> pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 port 3 hw_addr aa:bb:cc:aa:bb:cc state inactive
> >> >> 
> >> >> Note that the SF slice is created but not active. That means the
> >> >> entities are created on devlink side, the e-switch port representor
> >> >> is created, but the SF device itself it not yet out there (same host
> >> >> or different, depends on where the parent PF is - in this case the same host).
> >> >> User might use e-switch port representor enp6s0pf1sf10 to do settings,
> >> >> putting it into bridge, adding TC rules, etc.
> >> >> It's like the cable is unplugged on the other side.    
> >> >
> >> >If it's just "cable unplugged" can't we just use the fact the
> >> >representor is down to indicate no traffic can flow?    
> >> 
> >> It is not "cable unplugged". This "state inactive/action" is admin
> >> state. You as a eswitch admin say, "I'm done with configuring a slice
> >> (MAC) and a representor (bridge, TC, etc) for this particular SF and
> >> I want the HOST to instantiate the SF instance (with the configured
> >> MAC).  
> >
> >I'm not opposed, I just don't understand the need. If ASIC will not 
> >RX or TX any traffic from/to this new entity until repr is brought up
> >there should be no problem.  
> 
> The only need I see is that the eswitch manager can configure things for
> the slice and representor until the "activation kick" makes the device
> appear on the host. What you suggest is to do the "activation kick" by
> representor netdevice admin_up. There is a connection from slice to
> netdevice, but it is indirect:
> devlink_slice->devlink_port->netdev.
> Also, some slices may not have netdev (IB/NVE/etc).

Not sure what activation on IB and NVM looks like, but isn't just not
serving requests until ready not an option there?

> >> >> Now we activate (deploy) the SF:
> >> >> $ devlink slice set pci/0000:06:00.0/100 state active
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66
> >> >> pci/0000:06:00.0/100: flavour pcisf pfnum 1 sfnum 10 port 3 hw_addr aa:bb:cc:aa:bb:cc state active
> >> >> 
> >> >> Upon the activation, the device driver asks the device to instantiate
> >> >> the actual SF device on particular PF. Does not matter if that is
> >> >> on the same host or not.
> >> >> 
> >> >> On the other side, the PF driver instance gets the event from device
> >> >> that particular SF was activated. It's the cue to put the device on bus
> >> >> probe it and instantiate netdev and devlink instances for it.    
> >> >
> >> >Seems backwards. It's the PF that wants the new function, why can't it
> >> >just create it and either get an error from the other side or never get
> >> >link up?    
> >> 
> >> We discussed that many times internally. I think it makes sense that
> >> the SF is created by the same entity that manages the related eswitch
> >> SF-representor. In other words, the "devlink slice" and related "devlink
> >> port" object are under the same devlink instance.
> >> 
> >> If the PF in host manages nested switch, it can create the SF inside and
> >> manages the neste eswitch SF-representor as you describe.
> >> 
> >> It is a matter of "nested eswitch manager on/off" configuration.
> >> 
> >> I think this is clean model and it is known who has what
> >> responsibilities.  
> >
> >I see so you want the creation to be controlled by the same entity that
> >controls the eswitch..
> >
> >To me the creation should be on the side that actually needs/will use
> >the new port. And if it's not eswitch manager then eswitch manager
> >needs to ack it.  
> 
> Hmm. The question is, is it worth to complicate things in this way?
> I don't know. I see a lot of potential misunderstandings :/

I'd see requesting SFs over devlink/sysfs as simplification, if
anything.

> >The precedence is probably not a strong argument, but that'd be the
> >same way VFs work.. I don't think you can change how VFs work, right?  
> 
> You can't, but since the VF model is not optimal as it turned out, do we
> want to stick with it for the SFs too?

The VF model is not optimal in what sense? I thought the main reason
for SFs is that they are significantly more light weight on Si side.

> And perhaps the "furute VF
> implementation" can be done in a way this fits - that is described in
> the "VF manual creation and activation user cmdline API draft" section
> below.
> 
> You see that there are "dummies" created by default. I think that Jason
> argued that these dummies should be created for max_vfs. That way the
> eswitch manager can configure all possible VF representors, no matter
> when the host decides to spawn them.
> 
> 
> >  
> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||   VF manual creation and activation user cmdline API draft   ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> To enter manual mode, the user has to turn off VF dummies creation:
> >> >> $ devlink dev set pci/0000:06:00.0 vf_dummies disabled
> >> >> $ devlink dev show
> >> >> pci/0000:06:00.0: vf_dummies disabled
> >> >> 
> >> >> It is "enabled" by default in order not to break existing users.
> >> >> 
> >> >> By setting the "vf_dummies" attribute to "disabled", the driver
> >> >> removes all dummy VFs. Only physical ports are present:
> >> >> 
> >> >> $ devlink port show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> >> >> 
> >> >> Then the user is able to create them in a similar way as SFs:
> >> >> 
> >> >> $ devlink slice add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8 hw_addr aa:bb:cc:aa:bb:cc
> >> >> 
> >> >> The devlink kernel code calls down to device driver (devlink op) and asks
> >> >> it to create a slice with particular attributes. Driver then instatiates
> >> >> the slice and port:
> >> >> 
> >> >> $ devlink port show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 1 vfnum 8 type eth netdev enp6s0pf1vf0 slice 99
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >> >> pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 port 2 hw_addr aa:bb:cc:aa:bb:cc state inactive
> >> >> 
> >> >> Now we activate (deploy) the VF:
> >> >> $ devlink slice set pci/0000:06:00.0/99 state active
> >> >> 
> >> >> $ devlink slice show
> >> >> pci/0000:06:00.0/99: flavour pcivf pfnum 1 vfnum 8 port 2 hw_addr aa:bb:cc:aa:bb:cc state active
> >> >> 
> >> >> ==================================================================
> >> >> ||                                                              ||
> >> >> ||                             PFs                              ||
> >> >> ||                                                              ||
> >> >> ==================================================================
> >> >> 
> >> >> There are 2 flavours of PFs:
> >> >> 1) Parent PF. That is coupled with uplink port. The slice flavour is
> >> >>    therefore "physical", to be in sync of the flavour of the uplink port.
> >> >>    In case this Parent PF is actually a leg of upstream embedded switch,
> >> >>    the slice flavour is "virtual" (same as the port flavour).
> >> >> 
> >> >>    $ devlink port show
> >> >>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0
> >> >> 
> >> >>    $ devlink slice show
> >> >>    pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >> 
> >> >>    This slice is shown in both "switchdev" and "legacy" modes.
> >> >> 
> >> >>    If there is another parent PF, say "0000:06:00.1", that share the
> >> >>    same embedded switch, the aliasing is established for devlink handles.
> >> >> 
> >> >>    The user can use devlink handles:
> >> >>    pci/0000:06:00.0
> >> >>    pci/0000:06:00.1
> >> >>    as equivalents, pointing to the same devlink instance.
> >> >> 
> >> >>    Parent PFs are the ones that may be in control of managing
> >> >>    embedded switch, on any hierarchy level.
> >> >> 
> >> >> 2) Child PF. This is a leg of a PF put to the parent PF. It is
> >> >>    represented by a slice, and a port (with a netdevice):
> >> >> 
> >> >>    $ devlink port show
> >> >>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1 slice 0
> >> >>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2 slice 20
> >> >> 
> >> >>    $ devlink slice show
> >> >>    pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >> >>    pci/0000:06:00.0/20: flavour pcipf pfnum 1 port 1 hw_addr aa:bb:cc:aa:bb:87 state active  <<<<<<<<<<
> >> >> 
> >> >>    This is a typical smartnic scenario. You would see this list on
> >> >>    the smartnic CPU. The slice pci/0000:06:00.0/20 is a leg to
> >> >>    one of the hosts. If you send packets to enp6s0f0pf2, they will
> >> >>    go to he host.
> >> >> 
> >> >>    Note that inside the host, the PF is represented again as "Parent PF"
> >> >>    and may be used to configure nested embedded switch.    
> >> >
> >> >This parent/child PF I don't understand. Does it stem from some HW
> >> >limitations you have?    
> >> 
> >> No limitation. It's just a name for 2 roles. I didn't know how else to
> >> name it for the documentation purposes. Perhaps you can help me.
> >> 
> >> The child can simply manage a "nested eswich". The "parent eswitch"
> >> would see one leg (pf representor) one way or another. Only in case the
> >> "nested eswitch" is there, the child would manage it - have separate
> >> representors for vfs/sfs under its devlink instance.  
> >
> >I see! I wouldn't use the term PF. I think we need a notion of 
> >a "virtual" port within the NIC to model the eswitch being managed 
> >by the Host.  
> 
> But it is a PF (or maybe VF). The fact that it may or may not have
> nested switch inside does not change the view of the parent eswitch
> manager instance. Why would it?

See the first comment on mixing PCIe ports with uplink :)

> >If Host manages the Eswitch - SmartNIC will no longer deal with its
> >PCIe ports, but only with its virtual uplink.  
> 
> What do you mean by "PCIe ports"?

PF/VF/SFs, basically PCIe side ingress/egress/queuing.
