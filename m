Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392E7201D98
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 23:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgFSV60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 17:58:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49514 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbgFSV6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 17:58:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmP1d-001KZK-SO; Fri, 19 Jun 2020 23:58:17 +0200
Date:   Fri, 19 Jun 2020 23:58:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Question on DSA switches, IGMP forwarding and switchdev
Message-ID: <20200619215817.GN279339@lunn.ch>
References: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59c5ede2-8b52-c250-7396-fd7b19ec6bc7@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:31:04PM +0200, Daniel Mack wrote:
> Hi,
> 
> I'm working on a custom board featuring a Marvell mv88e6085 Ethernet
> switch controlled by the Linux DSA driver, and I'm facing an issue with
> IGMP packet flows.
> 
> Consider two Ethernet stations, each connected to the switch on a
> dedicated port. A Linux bridge combines the two ports. In my setup, I
> need these two stations to send and receive multicast traffic, with IGMP
> snooping enabled.
> 
> When an IGMP query enters the switch, it is redirected to the CPU port
> as all 'external' ports are configured for IGMP/MLP snooping by the
> driver. The issue that I'm seeing is that the Linux bridge does not
> forward the IGMP frames to any other port, no matter whether the bridge
> is in snooping mode or not. This needs to happen however, otherwise the
> stations will not see IGMP queries, and unsolicited membership reports
> are not being transferred either.

Hi Daniel

I think all the testing i've done in this area i've had the bridge
acting as the IGMP queirer. Hence it has replied to the query, rather
than forward it out other ports.

So this could be a bug.

> I've traced these frames through the bridge code and figured forwarding
> fails in should_deliver() in net/bridge/br_forward.c because
> nbp_switchdev_allowed_egress() denies it due to the fact that the frame
> has already been forwarded by the same parent device.

To get this far, has the bridge determined it is not the elected
querier?  I guess it must of done. Otherwise it would not be
forwarding it.

> So my question now is how to fix that. Would the DSA driver need to mark
> the ports as independent somehow?

The problem here is:

https://elixir.bootlin.com/linux/v5.8-rc1/source/net/dsa/tag_edsa.c#L159

Setting offload_fwd_mark means the switch has forwarded the frame as
needed to other ports of the switch. If the frame is an IGMP query
frame, and the bridge is not the elected quierer, i guess we need to
set this false? Or we need an FDB in the switch to forward it. What
group address is being used?

    Andrew
