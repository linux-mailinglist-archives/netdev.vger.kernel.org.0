Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0D8193737
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 05:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgCZEAP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 00:00:15 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:47522 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgCZEAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 00:00:15 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 00:00:15 EDT
Received: from macmini.redfish-solutions.com (macmini.redfish-solutions.com [192.168.1.38])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 02Q3rRbc023117
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 21:53:28 -0600
From:   Philip Prindeville <philipp_subx@redfish-solutions.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Fwd: tc question about ingress bandwidth splitting
Message-Id: <A408B33D-5EC7-4B29-B26D-1A881FA12778@redfish-solutions.com>
References: <74CFEE65-9CE8-4CF7-9706-2E2E67B24E08@redfish-solutions.com>
To:     netdev@vger.kernel.org
Date:   Wed, 25 Mar 2020 21:53:27 -0600
X-Mailer: Apple Mail (2.3445.104.11)
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Had originally posted this to LARTC but realized that “netdev” is probably the better forum.

Was hoping someone familiar with the nuts and bolts of tc and scheduler minutiae could help me come up with a configuration to use as a starting point, then I could tweak it, gather some numbers, make graphs etc, and write a LARTC or LWN article around the findings.

I’d be trying to do shaping in both directions.  Sure, egress shaping is trivial and obviously works.

But I was also thinking about ingress shaping on the last hop, i.e. as traffic flows into the last-hop CPE router, and limiting/delaying it so that the entire end-to-end path is appropriately perceived by the sender, since the effective bandwidth of a [non-multipath] route is the min bandwidth of all individual hops, right?

So that min could be experienced at the final hop before the receiver as delay injected between packets to shape the bitrate.

How far off-base am I?

And what would some tc scripting look like to measure my thesis?



> Begin forwarded message:
> 
> From: Philip Prindeville <philipp_subx@redfish-solutions.com>
> Subject: tc question about ingress bandwidth splitting
> Date: March 22, 2020 at 3:56:46 PM MDT
> To: lartc@vger.kernel.org
> 
> Hi all,
> 
> I asked around on IRC but no one seems to know the answer, so I thought I’d go to the source…
> 
> I have a SoHo router with two physical subnets, which we’ll call “production” (eth0) and “guest” (eth1), and the egress interface “wan” (eth5).
> 
> The uplink is G.PON 50/10 mbps.  I’d like to cap the usage on “guest” to 10/2 mbps.  Any unused bandwidth from “guest” goes to “production”.
> 
> I thought about marking the traffic coming in off “wan" (the public interface).  Then using HTB to have a 50 mbps cap at the root, and allocating 10mb/s to the child “guest”.  The other sibling would be “production”, and he gets the remaining traffic.
> 
> Upstream would be the reverse, marking ingress traffic from “guest” with a separate tag.  Allocating upstream root on “wan” with 10 mbps, and the child “guest” getting 2 mbps.  The remainder goes to the sibling “production”.
> 
> Should be straightforward enough, right? (Well, forwarding is more straightforward than traffic terminating on the router itself, I guess… bonus points for getting that right, too.)
> 
> I’m hoping that the limiting will work adequately so that the end-to-end path has adequate congestion avoidance happening, and that upstream doesn’t overrun the receiver and cause a lot of packets to be dropped on the last hop (work case of wasted bandwidth).  Not sure if I need special accommodations for bursting or if that would just delay the “settling” of congestion avoidance into steady-state.
> 
> Also not sure if ECN is worth marking at this point.  Congestion control is supposed to work better than congestion avoidance, right?
> 
> Anyone know what the steps would look like to accomplish the above?
> 
> A bunch of people responded, “yeah, I’ve been wanting to do that too…” when I brought up my question, so if I get a good solution I’ll submit a FAQ entry.
> 
> Thanks,
> 
> -Philip
> 

