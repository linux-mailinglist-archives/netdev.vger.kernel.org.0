Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA3E20BE19
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgF0ERx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgF0ERx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 00:17:53 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AA862080C;
        Sat, 27 Jun 2020 04:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593231472;
        bh=ImDTdmNMUl24ckIJAdQlNOfLvEIXNTp6wiqa4etOBTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4XjlZZ/kQQHM89T6FT/N1aKgNbdENDi3scF6r/V0WbsUzcAdBD3EJnnymhImzb6l
         DlPST8hMavKtePxVaDNUgaosqGjBeRT8m//xtzlvOC13u1ve8vkTFstBOcIdY9t5Tx
         1EavtHqLttzUwGtGmxc0CwcjMPoB47ujk0gh7JME=
Date:   Fri, 26 Jun 2020 21:17:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200626211750.66cd6d6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626205011.GA24127@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
        <20200625155510.01e3c1c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200626100614.GA23240@chelsio.com>
        <20200626095549.1dc4da9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200626205011.GA24127@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Jun 2020 02:20:12 +0530 Rahul Lakkireddy wrote:
> On Friday, June 06/26/20, 2020 at 09:55:49 -0700, Jakub Kicinski wrote:
> > On Fri, 26 Jun 2020 15:36:15 +0530 Rahul Lakkireddy wrote:  
> > > On Thursday, June 06/25/20, 2020 at 15:55:10 -0700, Jakub Kicinski wrote:  
> > > > On Thu, 25 Jun 2020 17:28:40 +0530 Rahul Lakkireddy wrote:    
> > > > > This series of patches add support to mirror all ingress traffic
> > > > > for TC-MATCHALL ingress offload.
> > > > > 
> > > > > Patch 1 adds support to dynamically create a mirror Virtual Interface
> > > > > (VI) that accepts all mirror ingress traffic when mirror action is
> > > > > set in TC-MATCHALL offload.
> > > > > 
> > > > > Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> > > > > mirror VI.
> > > > > 
> > > > > Patch 3 adds support to replicate all the main VI configuration to
> > > > > mirror VI. This includes replicating MTU, promiscuous mode,
> > > > > all-multicast mode, and enabled netdev Rx feature offloads.    
> > > > 
> > > > Could you say more about this mirror VI? Is this an internal object
> > > > within the NIC or something visible to the user?
> > > >     
> > > 
> > > The Virtual Interface (VI) is an internal object managed by firmware
> > > and Multi Port Switch (MPS) module in hardware. Each VI can be
> > > programmed with a unique MAC address in the MPS TCAM. So, 1 physical
> > > port can have multiple VIs, each with their own MAC address. It's
> > > also possible for VIs to share the same MAC address, which would
> > > result in MPS setting the replication mode for that entry in the
> > > TCAM. In this case, the incoming packet would get replicated and
> > > sent to all the VIs sharing the MAC address. When MPS is able to
> > > classify the destination MAC in the incoming packet with an entry
> > > in the MPS TCAM, it forwards the packet to the corresponding VI(s).
> > > 
> > > In case of Mirror VI, we program the same MAC as the existing main
> > > VI. This will result in MPS setting the replication mode for that
> > > existing entry in the MPS TCAM. So, the MPS would replicate the
> > > incoming packet and send it to both the main VI and mirror VI.  
> > 
> > So far sounds good.
> >   
> > > Note that for the main VI, we also programmed the flow Lookup Engine
> > > (LE) module to switch the packet back out on one of the underlying
> > > ports. So, when this rule hits in the LE, the main VI's packet would
> > > get switched back out in hardware to one of the underlying ports and
> > > will not reach driver. The mirror VI's packet will not hit any rule
> > > in the LE and will be received by the driver and will be sent up to
> > > Linux networking stack.  
> > 
> > This I'm not sure I'm following. Are you saying that if there is another
> > (flower, not matchall) rule programmed it will be ignored as far 
> > as the matchall filter is concerned? I assume you ensure the matchall
> > rule is at higher prio in that case?
> >   
> 
> The order is still maintained. If there's a higher priority
> flower rule, then that rule will be considered first before
> considering the matchall rule.
> 
> For example, let's say we have 2 rules like below:
> 
> # tc filter add dev enp2s0f4 ingress protocol ip pref 1 \
> 	flower skip_sw src_ip 10.1.3.3 action drop
> 
> # tc filter add dev enp2s0f4 ingress pref 100 \
> 	matchall skip_sw action mirred egress mirror dev enp2s0f4d1
> 
> 
> If we're receiving a packet with src_ip 10.1.3.3, then rule prio 1
> will hit first and the lower prio 100 matchall rule will never hit
> for that packet. For all other packets, the matchall rule prio 100
> will always hit.
> 
> I had tried to explain that some special care must be taken to make
> sure that the redirect action of the mirror rule must only be performed
> for the main VI's packet, so that it gets switched out to enp2s0f4d1 and
> _must not_ reach the driver. The same redirect action must not be
> performed for the mirror VI's replicated packet and the packet _must_
> reach the driver. We're ensuring this by explicitly programming the
> main VI's index for the filter entry in hardware. This way the hardware
> will redirect out only the main VI's packet to enp2s0f4d1. It will not
> perform redirect on the replicated packet coming from mirror VI.
> If no VI index is programmed, then hardware will redirect out
> both the main and mirror VI packets to enp2s0f4d1 and none of
> the replicated packets will reach the driver, which is unexpected.
> 
> I hope I'm making sense... :)

What's the main use case for this feature? It appears that you're
allocating queues in patch 2. At the same time I don't see SWITCHDEV
mode / representors in this driver. So the use case is to redirect a
packet out to another port while still receiving a copy?
