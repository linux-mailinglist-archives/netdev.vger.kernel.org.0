Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B0120B65C
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgFZQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgFZQzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:55:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6B3206BE;
        Fri, 26 Jun 2020 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593190551;
        bh=4g0Y4sVz1NW81FJT1gwYM1JlLjJXAN3HveU2mWMsEqI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XLKBJAbC0Cwdad4oaYVgkXvxoXfKxFTU+JKBBbANCDKhBKG2TQ3NTkjv43RygBubl
         P96NQ65BRiAFq8fSHrgqjnu/lsdp0ThR6YdVAO1JD+Tm+o1WUx2RTCgIFP6FVbCPUO
         Q51pcBTQeh28vnjxNG+ECLmlyurNWCuJnnCWb1ns=
Date:   Fri, 26 Jun 2020 09:55:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200626095549.1dc4da9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626100614.GA23240@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
        <20200625155510.01e3c1c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200626100614.GA23240@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 15:36:15 +0530 Rahul Lakkireddy wrote:
> On Thursday, June 06/25/20, 2020 at 15:55:10 -0700, Jakub Kicinski wrote:
> > On Thu, 25 Jun 2020 17:28:40 +0530 Rahul Lakkireddy wrote:  
> > > This series of patches add support to mirror all ingress traffic
> > > for TC-MATCHALL ingress offload.
> > > 
> > > Patch 1 adds support to dynamically create a mirror Virtual Interface
> > > (VI) that accepts all mirror ingress traffic when mirror action is
> > > set in TC-MATCHALL offload.
> > > 
> > > Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
> > > mirror VI.
> > > 
> > > Patch 3 adds support to replicate all the main VI configuration to
> > > mirror VI. This includes replicating MTU, promiscuous mode,
> > > all-multicast mode, and enabled netdev Rx feature offloads.  
> > 
> > Could you say more about this mirror VI? Is this an internal object
> > within the NIC or something visible to the user?
> >   
> 
> The Virtual Interface (VI) is an internal object managed by firmware
> and Multi Port Switch (MPS) module in hardware. Each VI can be
> programmed with a unique MAC address in the MPS TCAM. So, 1 physical
> port can have multiple VIs, each with their own MAC address. It's
> also possible for VIs to share the same MAC address, which would
> result in MPS setting the replication mode for that entry in the
> TCAM. In this case, the incoming packet would get replicated and
> sent to all the VIs sharing the MAC address. When MPS is able to
> classify the destination MAC in the incoming packet with an entry
> in the MPS TCAM, it forwards the packet to the corresponding VI(s).
> 
> In case of Mirror VI, we program the same MAC as the existing main
> VI. This will result in MPS setting the replication mode for that
> existing entry in the MPS TCAM. So, the MPS would replicate the
> incoming packet and send it to both the main VI and mirror VI.

So far sounds good.

> Note that for the main VI, we also programmed the flow Lookup Engine
> (LE) module to switch the packet back out on one of the underlying
> ports. So, when this rule hits in the LE, the main VI's packet would
> get switched back out in hardware to one of the underlying ports and
> will not reach driver. The mirror VI's packet will not hit any rule
> in the LE and will be received by the driver and will be sent up to
> Linux networking stack.

This I'm not sure I'm following. Are you saying that if there is another
(flower, not matchall) rule programmed it will be ignored as far 
as the matchall filter is concerned? I assume you ensure the matchall
rule is at higher prio in that case?

> > Also looking at the implementation of redirect:
> > 
> > 		case FLOW_ACTION_REDIRECT: {
> > 			struct net_device *out = act->dev;
> > 			struct port_info *pi = netdev_priv(out);
> > 
> > 			fs->action = FILTER_SWITCH;
> > 			fs->eport = pi->port_id;
> > 			}
> > 
> > How do you know the output interface is controlled by your driver, and
> > therefore it's sage to cast netdev_priv() to port_info?  
> 
> We're validating it earlier in cxgb4_validate_flow_actions().
> Here's the code snippet. We're saving the netdevice pointer returned
> by alloc_etherdev_mq() during PCI probe in cxgb4_main.c::init_one()
> and using it to compare the netdevice given by redirect action. If
> the redirect action's netdevice doesn't match any of our underlying
> ports, then we fail offloading this rule.
> 
> 		case FLOW_ACTION_REDIRECT: {
> 			struct adapter *adap = netdev2adap(dev);
> 			struct net_device *n_dev, *target_dev;
> 			unsigned int i;
> 			bool found = false;
> 
> 			target_dev = act->dev;
> 			for_each_port(adap, i) {
> 				n_dev = adap->port[i];
> 				if (target_dev == n_dev) {
> 					found = true;
> 					break;
> 				}
> 			}
> 
> 			/* If interface doesn't belong to our hw, then
> 			 * the provided output port is not valid
> 			 */
> 			if (!found) {
> 				netdev_err(dev, "%s: Out port invalid\n",
> 					   __func__);
> 				return -EINVAL;
> 			}
> 			act_redir = true;
> 			}
> 			break;

Thanks, FWIW this is what netdev_port_same_parent_id() is for.
