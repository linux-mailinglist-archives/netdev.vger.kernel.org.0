Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53120BAE3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgFZVC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:02:56 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:45253 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFZVC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:02:56 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05QL2o7G031271;
        Fri, 26 Jun 2020 14:02:51 -0700
Date:   Sat, 27 Jun 2020 02:20:12 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200626205011.GA24127@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
 <20200625155510.01e3c1c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200626100614.GA23240@chelsio.com>
 <20200626095549.1dc4da9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626095549.1dc4da9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, June 06/26/20, 2020 at 09:55:49 -0700, Jakub Kicinski wrote:
> On Fri, 26 Jun 2020 15:36:15 +0530 Rahul Lakkireddy wrote:
> > On Thursday, June 06/25/20, 2020 at 15:55:10 -0700, Jakub Kicinski wrote:
> > > On Thu, 25 Jun 2020 17:28:40 +0530 Rahul Lakkireddy wrote:  
> > > > This series of patches add support to mirror all ingress traffic
> > > > for TC-MATCHALL ingress offload.
> > > > 
> > > > Patch 1 adds support to dynamically create a mirror Virtual Interface
> > > > (VI) that accepts all mirror ingress traffic when mirror action is
> > > > set in TC-MATCHALL offload.
> > > > 
> > > > Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> > > > mirror VI.
> > > > 
> > > > Patch 3 adds support to replicate all the main VI configuration to
> > > > mirror VI. This includes replicating MTU, promiscuous mode,
> > > > all-multicast mode, and enabled netdev Rx feature offloads.  
> > > 
> > > Could you say more about this mirror VI? Is this an internal object
> > > within the NIC or something visible to the user?
> > >   
> > 
> > The Virtual Interface (VI) is an internal object managed by firmware
> > and Multi Port Switch (MPS) module in hardware. Each VI can be
> > programmed with a unique MAC address in the MPS TCAM. So, 1 physical
> > port can have multiple VIs, each with their own MAC address. It's
> > also possible for VIs to share the same MAC address, which would
> > result in MPS setting the replication mode for that entry in the
> > TCAM. In this case, the incoming packet would get replicated and
> > sent to all the VIs sharing the MAC address. When MPS is able to
> > classify the destination MAC in the incoming packet with an entry
> > in the MPS TCAM, it forwards the packet to the corresponding VI(s).
> > 
> > In case of Mirror VI, we program the same MAC as the existing main
> > VI. This will result in MPS setting the replication mode for that
> > existing entry in the MPS TCAM. So, the MPS would replicate the
> > incoming packet and send it to both the main VI and mirror VI.
> 
> So far sounds good.
> 
> > Note that for the main VI, we also programmed the flow Lookup Engine
> > (LE) module to switch the packet back out on one of the underlying
> > ports. So, when this rule hits in the LE, the main VI's packet would
> > get switched back out in hardware to one of the underlying ports and
> > will not reach driver. The mirror VI's packet will not hit any rule
> > in the LE and will be received by the driver and will be sent up to
> > Linux networking stack.
> 
> This I'm not sure I'm following. Are you saying that if there is another
> (flower, not matchall) rule programmed it will be ignored as far 
> as the matchall filter is concerned? I assume you ensure the matchall
> rule is at higher prio in that case?
> 

The order is still maintained. If there's a higher priority
flower rule, then that rule will be considered first before
considering the matchall rule.

For example, let's say we have 2 rules like below:

# tc filter add dev enp2s0f4 ingress protocol ip pref 1 \
	flower skip_sw src_ip 10.1.3.3 action drop

# tc filter add dev enp2s0f4 ingress pref 100 \
	matchall skip_sw action mirred egress mirror dev enp2s0f4d1


If we're receiving a packet with src_ip 10.1.3.3, then rule prio 1
will hit first and the lower prio 100 matchall rule will never hit
for that packet. For all other packets, the matchall rule prio 100
will always hit.

I had tried to explain that some special care must be taken to make
sure that the redirect action of the mirror rule must only be performed
for the main VI's packet, so that it gets switched out to enp2s0f4d1 and
_must not_ reach the driver. The same redirect action must not be
performed for the mirror VI's replicated packet and the packet _must_
reach the driver. We're ensuring this by explicitly programming the
main VI's index for the filter entry in hardware. This way the hardware
will redirect out only the main VI's packet to enp2s0f4d1. It will not
perform redirect on the replicated packet coming from mirror VI.
If no VI index is programmed, then hardware will redirect out
both the main and mirror VI packets to enp2s0f4d1 and none of
the replicated packets will reach the driver, which is unexpected.

I hope I'm making sense... :)

> > > Also looking at the implementation of redirect:
> > > 
> > > 		case FLOW_ACTION_REDIRECT: {
> > > 			struct net_device *out = act->dev;
> > > 			struct port_info *pi = netdev_priv(out);
> > > 
> > > 			fs->action = FILTER_SWITCH;
> > > 			fs->eport = pi->port_id;
> > > 			}
> > > 
> > > How do you know the output interface is controlled by your driver, and
> > > therefore it's sage to cast netdev_priv() to port_info?  
> > 
> > We're validating it earlier in cxgb4_validate_flow_actions().
> > Here's the code snippet. We're saving the netdevice pointer returned
> > by alloc_etherdev_mq() during PCI probe in cxgb4_main.c::init_one()
> > and using it to compare the netdevice given by redirect action. If
> > the redirect action's netdevice doesn't match any of our underlying
> > ports, then we fail offloading this rule.
> > 
> > 		case FLOW_ACTION_REDIRECT: {
> > 			struct adapter *adap = netdev2adap(dev);
> > 			struct net_device *n_dev, *target_dev;
> > 			unsigned int i;
> > 			bool found = false;
> > 
> > 			target_dev = act->dev;
> > 			for_each_port(adap, i) {
> > 				n_dev = adap->port[i];
> > 				if (target_dev == n_dev) {
> > 					found = true;
> > 					break;
> > 				}
> > 			}
> > 
> > 			/* If interface doesn't belong to our hw, then
> > 			 * the provided output port is not valid
> > 			 */
> > 			if (!found) {
> > 				netdev_err(dev, "%s: Out port invalid\n",
> > 					   __func__);
> > 				return -EINVAL;
> > 			}
> > 			act_redir = true;
> > 			}
> > 			break;
> 
> Thanks, FWIW this is what netdev_port_same_parent_id() is for.

Looks like I need to add ndo_get_port_parent_id() support in the
driver for this to work. I'll look into adding this support in
follow up patches.

Thanks,
Rahul
