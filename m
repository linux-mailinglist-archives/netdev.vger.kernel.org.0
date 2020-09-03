Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE60F25CB72
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgICUpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgICUpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:45:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D472071B;
        Thu,  3 Sep 2020 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599165909;
        bh=QYHVfR0NQAieDh4HfZyNv8BsfYUTyyIqJIBzMwcLsE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XKyUBlP4WcX9JN7BVOIUm/yyJI5JqK+BBVFvZj8ei6j99H3N5VwD+TIKYtFERfT3c
         +QcjuvTECnhnY57NcTjL1HNO5JHPbUBDJmGcD1AO7iGAb1wqf5PJhdAlQd7OHib8t+
         QLFK8GZQLIfRgSE4s7KQ+oEgKQnFvbQhGJ3bdkGo=
Date:   Thu, 3 Sep 2020 13:45:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, f.fainelli@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz, dsahern@gmail.com,
        Michael Chan <michael.chan@broadcom.com>, saeedm@mellanox.com,
        rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
Message-ID: <20200903134507.4ba426f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKOOJTwwZ0wug6Wn6vVmvyWX=vz_n1shu5t_Gf-NT21MP7HMxg@mail.gmail.com>
References: <20200903020336.2302858-1-kuba@kernel.org>
        <CAKOOJTwwZ0wug6Wn6vVmvyWX=vz_n1shu5t_Gf-NT21MP7HMxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 09:29:22 -0700 Edwin Peer wrote:
> On Wed, Sep 2, 2020 at 7:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > +Drivers should report all statistics which have a matching member in
> > +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` exclusively
> > +via `.ndo_get_stats64`. Reporting such standard stats via ethtool
> > +or debugfs will not be accepted.  
> 
> Should existing drivers that currently duplicate standard stats in the
> ethtool list be revised also?

That's probably considered uAPI land. I've removed the stats from the
nfp awhile back, and nobody complained, but I'm thinking to leave the
decision to individual maintainers.

Funnily enough number of 10G and 40G drivers report tx_heartbeat_errors
in their ethtool stats (always as 0). Explainer what the statistic
counts for a contemporary reader:

http://www.ethermanage.com/ethernet/sqe/sqe.html

> > + * @rx_packets: Number of good packets received by the interface.
> > + *   For hardware interfaces counts all good packets seen by the host,
> > + *   including packets which host had to drop at various stages of processing
> > + *   (even in the driver).  
> 
> This is perhaps a bit ambiguous. I think you mean to say packets received from
> the device, but I could also interpret the above to mean received by the device
> if 'host' is read to be the whole physical machine (ie. including NIC hardware)
> instead of the part that is apart from the NIC from the NIC's perspective.

How about:

  For hardware interfaces counts all good packets received from the
  device by the host, including packets which host had to drop...

> > + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.
> > + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.  
> 
> Including or excluding FCS?

Good point, no FCS is probably a reasonable expectation.

I'm not sure what to say about pad. I'm tempted to also mention that
for tx we shouldn't count pad, no? (IOW Ethernet Frame - FCS - pad)

> > + *   For Ethernet devices this counter may be equivalent to:
> > + *
> > + *    - 30.3.1.1.21 aMulticastFramesReceivedOK  
> 
> You mention the IEEE standard in your commit message, but I don't think this
> document properly cites what you are referring to here? It might be an idea to
> say "IEEE 30.3.1.1.21 aMulticastFramesReceivedOK" here and provide an
> appropriate citation reference at the end, or perhaps a link.

How about I replace Ethernet with IEEE 802.3:

  For IEEE 802.3 devices this counter may be equivalent to:

   - 30.3.1.1.21 aMulticastFramesReceivedOK
