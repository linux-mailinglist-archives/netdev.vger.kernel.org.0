Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A8201E12
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgFSWgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:36:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgFSWgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 18:36:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmPcE-001KkJ-UZ; Sat, 20 Jun 2020 00:36:06 +0200
Date:   Sat, 20 Jun 2020 00:36:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jason Cobham <jcobham@questertangent.com>
Cc:     Daniel Mack <daniel@zonque.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
Message-ID: <20200619223606.GO279339@lunn.ch>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
 <20200619215817.GN279339@lunn.ch>
 <72f92622c69143b0880125dfe9f9a955@questertangent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72f92622c69143b0880125dfe9f9a955@questertangent.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I've run into the same issue. To resolve it,  In my case, in the same file, I've had to send all IGMP control traffic to the CPU:
> 	skb->offload_fwd_mark = 1;
> 	switch (ih->type) {
> 		case IGMP_HOST_MEMBERSHIP_REPORT:
> 		case IGMPV2_HOST_MEMBERSHIP_REPORT:
> 		case IGMPV3_HOST_MEMBERSHIP_REPORT:
> 		case IGMP_HOST_MEMBERSHIP_QUERY:
> 		case IGMP_HOST_LEAVE_MESSAGE:
> 			skb->offload_fwd_mark = 0;
> 		break;
> 	}
> 
> I'd be interested if there is a better way.

It might depend on the switch generation, but i think some switches
indicate the sort of packet in the DSA header. For 6390, Octet 3 of
the header, bits 3-5 contains a code.

0=BDPU
1=Frame2Reg
2=IGMP/MLD
3=Policy
4=ARP Mirror
5=Policy Mirror

We can look at these bits and not set skb->offload_fwd_mark depending
on its value.

The 6352 family has the same bits. 6161 has a few less bits, but does
have IGMP/MLD. I don't know about the 6085. Do you have the datasheet?

     Andrew
