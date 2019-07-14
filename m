Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C542E67ED1
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfGNL3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 07:29:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46280 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbfGNL3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 07:29:52 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hmchA-0002aJ-M8; Sun, 14 Jul 2019 07:29:39 -0400
Date:   Sun, 14 Jul 2019 07:29:04 -0400
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
Message-ID: <20190714112904.GA5082@hmswarspite.think-freely.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190711123909.GA10978@splinter>
 <20190711235354.GA30396@hmswarspite.think-freely.org>
 <20190712135230.GA13108@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712135230.GA13108@splinter>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 04:52:30PM +0300, Ido Schimmel wrote:
> On Thu, Jul 11, 2019 at 07:53:54PM -0400, Neil Horman wrote:
> > A few things here:
> > IIRC we don't announce individual hardware drops, drivers record them in
> > internal structures, and they are retrieved on demand via ethtool calls, so you
> > will either need to include some polling (probably not a very performant idea),
> > or some sort of flagging mechanism to indicate that on the next message sent to
> > user space you should go retrieve hw stats from a given interface.  I certainly
> > wouldn't mind seeing this happen, but its more work than just adding a new
> > netlink message.
> 
> Neil,
> 
> The idea of this series is to pass the dropped packets themselves to
> user space along with metadata, such as the drop reason and the ingress
> port. In the future more metadata could be added thanks to the
> extensible nature of netlink.
> 
I had experimented with this idea previously.  Specifically I had investigated
the possibility of creating a dummy net_device that received only dropped
packets so that utilities like tcpdump could monitor the interface for said
packets along with the metadata that described where they dropped.

The concern I had was, as Dave mentioned, that you would wind up with either a
head of line blocking issue, or simply lots of lost "dropped" packets due to
queue overflow on receive, which kind of defeated the purpose of drop monitor.

That said, I like the idea, and if we can find a way around the fact that we
could potentially receive way more dropped packets than we could bounce back to
userspace, it would be a major improvement.

> In v1 these packets were notified to user space as devlink events
> and my plan for v2 is to send them as drop_monitor events, given it's an
> existing generic netlink channel used to monitor SW drops. This will
> allow users to listen on one netlink channel to diagnose potential
> problems in either SW or HW (and hopefully XDP in the future).
> 
Yeah, I'm supportive of that.

> Please note that the packets I'm talking about are packets users
> currently do not see. They are dropped - potentially silently - by the
> underlying device, thereby making it hard to debug whatever issues you
> might be experiencing in your network.
> 
Right I get that, you want the ability to register a listener of sorts to
monitor drops in hardware and report that back to user space as an drop even
with a location that (instead of being a kernel address, is a 'special location'
representing a hardware instance.  Makes sense.  Having that be a location +
counter tuple would make sense, but I don't think we can pass the skb itself (as
you mention above), without seeing significant loss.

> The control path that determines if these packets are even sent to the
> CPU from the HW needs to remain in devlink for the reasons I outlined in
> my previous reply. However, the monitoring of these drops will be over
> drop_monitor. This is similar to what we are currently doing with
> tc-sample, where the control path that triggers the sampling and
> determines the sampling rate and truncation is done over rtnetlink (tc),
> but the sampled packets are notified over the generic netlink psample
> channel.
> 
> To make it more real, you can check the example of the dissected devlink
> message that notifies the drop of a packet due to a multicast source
> MAC: https://marc.info/?l=linux-netdev&m=156248736710238&w=2
> 
> I will obviously have to create another Wireshark dissector for
> drop_monitor in order to get the same information.
> 
yes, Of course.
> > Thats an interesting idea, but dropwatch certainly isn't currently setup for
> > that kind of messaging.  It may be worth creating a v2 of the netlink protocol
> > and really thinking out what you want to communicate.
> 
> I don't think we need a v2 of the netlink protocol. My current plan is
> to extend the existing protocol with: New message type (e.g.,
> NET_DM_CMD_HW_ALERT), new multicast group and a set of attributes to
> encode the information that is currently encoded in the example message
> I pasted above.
> 
Ok, that makes sense.  I think we already do some very rudimentary version of
that (see trace_napi_poll_hit).  Here we check the device we receive frames on
to see if its rx_dropped count has increased, and if it has, store that as a
drop count in the NULL location.  Thats obviously insufficient, but I wonder if
its worth looking at using the dm_hw_stat_delta to encode and record those event
for sending with your new message type.

> Thanks
> 
