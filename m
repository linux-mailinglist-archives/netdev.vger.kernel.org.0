Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A765466297
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 01:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfGKXyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 19:54:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32836 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfGKXyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 19:54:43 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hlitK-0002sg-9a; Thu, 11 Jul 2019 19:54:26 -0400
Date:   Thu, 11 Jul 2019 19:53:54 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190711235354.GA30396@hmswarspite.think-freely.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190711123909.GA10978@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711123909.GA10978@splinter>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 03:39:09PM +0300, Ido Schimmel wrote:
> On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
> > From: Ido Schimmel <idosch@idosch.org>
> > Date: Sun,  7 Jul 2019 10:58:17 +0300
> > 
> > > Users have several ways to debug the kernel and understand why a packet
> > > was dropped. For example, using "drop monitor" and "perf". Both
> > > utilities trace kfree_skb(), which is the function called when a packet
> > > is freed as part of a failure. The information provided by these tools
> > > is invaluable when trying to understand the cause of a packet loss.
> > > 
> > > In recent years, large portions of the kernel data path were offloaded
> > > to capable devices. Today, it is possible to perform L2 and L3
> > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> > > Different TC classifiers and actions are also offloaded to capable
> > > devices, at both ingress and egress.
> > > 
> > > However, when the data path is offloaded it is not possible to achieve
> > > the same level of introspection as tools such "perf" and "drop monitor"
> > > become irrelevant.
> > > 
> > > This patchset aims to solve this by allowing users to monitor packets
> > > that the underlying device decided to drop along with relevant metadata
> > > such as the drop reason and ingress port.
> > 
> > We are now going to have 5 or so ways to capture packets passing through
> > the system, this is nonsense.
> > 
> > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
> > devlink thing.
> > 
> > This is insanity, too many ways to do the same thing and therefore the
> > worst possible user experience.
> > 
> > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
> > XDP perf events, and these taps there too.
> > 
> > I mean really, think about it from the average user's perspective.  To
> > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
> > listen on devlink but configure a special tap thing beforehand and then
> > if someone is using XDP I gotta setup another perf event buffer capture
> > thing too.
> 
> Dave,
> 
> Before I start working on v2, I would like to get your feedback on the
> high level plan. Also adding Neil who is the maintainer of drop_monitor
> (and counterpart DropWatch tool [1]).
> 
> IIUC, the problem you point out is that users need to use different
> tools to monitor packet drops based on where these drops occur
> (SW/HW/XDP).
> 
> Therefore, my plan is to extend the existing drop_monitor netlink
> channel to also cover HW drops. I will add a new message type and a new
> multicast group for HW drops and encode in the message what is currently
> encoded in the devlink events.
> 
A few things here:
IIRC we don't announce individual hardware drops, drivers record them in
internal structures, and they are retrieved on demand via ethtool calls, so you
will either need to include some polling (probably not a very performant idea),
or some sort of flagging mechanism to indicate that on the next message sent to
user space you should go retrieve hw stats from a given interface.  I certainly
wouldn't mind seeing this happen, but its more work than just adding a new
netlink message.

Also, regarding XDP drops, we wont see them if the xdp program is offloaded to
hardware (you'll need your hw drop gathering mechanism for that), but for xdp
programs run on the cpu, dropwatch should alrady catch those.  I.e. if the xdp
program returns a DROP result for a packet being processed, the OS will call
kfree_skb on its behalf, and dropwatch wil call that.

> I would like to emphasize that the configuration of whether these
> dropped packets are even sent to the CPU from the device still needs to
> reside in devlink given this is the go-to tool for device-specific
> configuration. In addition, these drop traps are a small subset of the
> entire packet traps devices support and all have similar needs such as
> HW policer configuration and statistics.
> 
> In the future we might also want to report events that indicate the
> formation of possible problems. For example, in case packets are queued
> above a certain threshold or for long periods of time. I hope we could
> re-use drop_monitor for this as well, thereby making it the go-to
> channel for diagnosing current and to-be problems in the data path.
> 
Thats an interesting idea, but dropwatch certainly isn't currently setup for
that kind of messaging.  It may be worth creating a v2 of the netlink protocol
and really thinking out what you want to communicate.

Best
Neil

> Thanks
> 
> [1] https://github.com/nhorman/dropwatch
> 
