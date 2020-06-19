Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2720201E11
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgFSWfK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jun 2020 18:35:10 -0400
Received: from mail.questertangent.com ([64.251.73.34]:28736 "EHLO
        mail.questertangent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729388AbgFSWfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:35:09 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 18:35:09 EDT
Received: from Charlie.questercorp.local ([192.168.0.16])
        by mail.questertangent.com
        over TLS secured channel (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        with XWall v3.54 ;
        Fri, 19 Jun 2020 15:05:08 -0700
Received: from Charlie.questercorp.local (192.168.0.16) by
 Charlie.questercorp.local (192.168.0.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1591.10; Fri, 19 Jun 2020 15:05:08 -0700
Received: from Charlie.questercorp.local ([fe80::e4f1:8cc1:8d1c:6cc5]) by
 Charlie.questercorp.local ([fe80::e4f1:8cc1:8d1c:6cc5%4]) with mapi id
 15.01.1591.017; Fri, 19 Jun 2020 15:05:08 -0700
From:   Jason Cobham <jcobham@questertangent.com>
To:     'Andrew Lunn' <andrew@lunn.ch>, Daniel Mack <daniel@zonque.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: Question on DSA switches, IGMP forwarding and switchdev
Thread-Topic: Question on DSA switches, IGMP forwarding and switchdev
Thread-Index: AQHWRoTECsAM8QUyz02U8YgWn2bsWqjgfUzA
Date:   Fri, 19 Jun 2020 22:05:08 +0000
Message-ID: <72f92622c69143b0880125dfe9f9a955@questertangent.com>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
In-Reply-To: <20200619215817.GN279339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.0.67]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Andrew Lunn
> Sent: Friday, June 19, 2020 2:58 PM
> To: Daniel Mack
> Cc: netdev@vger.kernel.org; Ido Schimmel; Jiri Pirko; Ivan Vecera; Florian
> Fainelli
> Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
> 
> On Fri, Jun 19, 2020 at 11:31:04PM +0200, Daniel Mack wrote:
> > Hi,
> >
> > I'm working on a custom board featuring a Marvell mv88e6085 Ethernet
> > switch controlled by the Linux DSA driver, and I'm facing an issue with
> > IGMP packet flows.
> >
> > Consider two Ethernet stations, each connected to the switch on a
> > dedicated port. A Linux bridge combines the two ports. In my setup, I
> > need these two stations to send and receive multicast traffic, with IGMP
> > snooping enabled.
> >
> > When an IGMP query enters the switch, it is redirected to the CPU port
> > as all 'external' ports are configured for IGMP/MLP snooping by the
> > driver. The issue that I'm seeing is that the Linux bridge does not
> > forward the IGMP frames to any other port, no matter whether the bridge
> > is in snooping mode or not. This needs to happen however, otherwise the
> > stations will not see IGMP queries, and unsolicited membership reports
> > are not being transferred either.
> 
> Hi Daniel
> 
> I think all the testing i've done in this area i've had the bridge
> acting as the IGMP queirer. Hence it has replied to the query, rather
> than forward it out other ports.
> 
> So this could be a bug.
> 
> > I've traced these frames through the bridge code and figured forwarding
> > fails in should_deliver() in net/bridge/br_forward.c because
> > nbp_switchdev_allowed_egress() denies it due to the fact that the frame
> > has already been forwarded by the same parent device.
> 
> To get this far, has the bridge determined it is not the elected
> querier?  I guess it must of done. Otherwise it would not be
> forwarding it.
> 
> > So my question now is how to fix that. Would the DSA driver need to mark
> > the ports as independent somehow?
> 
> The problem here is:
> 
> https://elixir.bootlin.com/linux/v5.8-rc1/source/net/dsa/tag_edsa.c#L159
> 
> Setting offload_fwd_mark means the switch has forwarded the frame as
> needed to other ports of the switch. If the frame is an IGMP query
> frame, and the bridge is not the elected quierer, i guess we need to
> set this false? Or we need an FDB in the switch to forward it. What
> group address is being used?
> 
>     Andrew

I've run into the same issue. To resolve it,  In my case, in the same file, I've had to send all IGMP control traffic to the CPU:
	skb->offload_fwd_mark = 1;
	switch (ih->type) {
		case IGMP_HOST_MEMBERSHIP_REPORT:
		case IGMPV2_HOST_MEMBERSHIP_REPORT:
		case IGMPV3_HOST_MEMBERSHIP_REPORT:
		case IGMP_HOST_MEMBERSHIP_QUERY:
		case IGMP_HOST_LEAVE_MESSAGE:
			skb->offload_fwd_mark = 0;
		break;
	}

I'd be interested if there is a better way.

Jason
