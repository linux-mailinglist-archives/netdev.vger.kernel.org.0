Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562983AB39D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFQMf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:35:26 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:45452 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhFQMfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:35:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3F0303E904;
        Thu, 17 Jun 2021 14:33:12 +0200 (CEST)
Date:   Thu, 17 Jun 2021 14:33:09 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Cc:     dsahern@kernel.org, nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, troglobit@gmail.com
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Message-ID: <20210617123309.GB2262@otheros>
References: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
 <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Callum,

On Thu, Jun 17, 2021 at 09:50:20PM +1200, Callum Sinclair wrote:
> +mc_snooping - BOOLEAN
> +	Enable multicast snooping on the interface. This allows any given
> +	multicast group to be received without explicitly being joined.
> +	The kernel needs to be compiled with CONFIG_MROUTE and/or
> +	CONFIG_IPV6_MROUTE.
> +	conf/all/mc_snooping must also be set to TRUE to enable multicast
> +	snooping for the interface.
> +

Generally this sounds like a useful feature. One note: When there
are snooping bridges/switches involved, you might run into issues
in receiving all multicast packets, as due to the missing IGMP/MLD
reports the snooping switches won't forward to you.

In that case, to conform to RFC4541 you would also need to become
the selected IGMP/MLD querier and send IGMP/MLD query messages. Or
better, you'd need to send Multicast Router Advertisements
(RFC4286). The latter is the recommended, more flexible way but
might not be supported by all multicast snooping switches yet.
The Linux bridge supports this.

There is a userspace tool called mrdisc you can use for MRD-Adv.
though: https://github.com/troglobit/mrdisc. So no need to
implement MRD Advertisements in the kernel with this patch (though
I could imagine that it might be a useful feature to have, having
MRD support out-of-the-box with this option). Just a note that some
IGMP/MLD Querier or MRD Adv. would be needed when IGMP/MLD snooping
switches are invoved might be nice to have in the mc_snooping
description for now, to avoid potential confusion later.


I'm also wondering if it could be useful to configure it via
setsockopt() per application instead of per device via sysctl. Either by
adding a new socket option. Or by allowing the any IP address
0.0.0.0 / :: with IP_ADD_MEMBERSHIP/IPV6_JOIN_GROUP. So that you
could use this for instance:

$ socat -u UDP6-RECV:1234,reuseaddr,ipv6-join-group="[::]:eth0" -
(currently :: fails with "Invalid argument")

I'm not sure however what the requirements for adding or extending
socket options are, if there are some POSIX standards that'd need
to be followed for compatibility with other OSes, for instance.


Hm, actually, I just noticed that there seem to be some multicast
related setsockopt()s already:

- PACKET_MR_PROMISC
- PACKET_MR_MULTICAST
- PACKET_MR_ALLMULTI

The last one seems to be what you are looking for, I think, the
manpage here says:

"PACKET_MR_ALLMULTI sets the socket up to receive all multicast
packets arriving at the interface"
https://www.man7.org/linux/man-pages/man7/packet.7.html

Or would you prefer to be able to use a layer 3 IP instead of
a layer 2 packet socket?

Regards, Linus
