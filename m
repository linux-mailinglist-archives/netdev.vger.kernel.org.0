Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8FD25CE2C
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgICXCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgICXCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 19:02:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1115920639;
        Thu,  3 Sep 2020 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599174150;
        bh=l7eDVRMzK5duIQZWWI0otmGumHnKwPrlcG85WmnM+78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dFHnHXAQ6OiqTcaDj5O2uFYLVOf6WDODdt+W97ZiUFC6tIEvOYC+HUAeXPn5qofYh
         EC65oLjd0wEeLwHJY92vcHGrTF/blbEsncDwdHkoYt8vQGuoRF6aQAg1Wjk6LJL8LG
         vJQqLC4aolkT6zxLeIOTjuChM//43s5GvSUug6Vg=
Date:   Thu, 3 Sep 2020 16:02:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jwi@linux.ibm.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        edwin.peer@broadcom.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
Message-ID: <20200903160228.53f68526@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <01db6af0-611d-2391-d661-60cfb4ba2031@gmail.com>
References: <20200903020336.2302858-1-kuba@kernel.org>
        <01db6af0-611d-2391-d661-60cfb4ba2031@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 16:40:54 -0600 David Ahern wrote:
> On 9/2/20 8:03 PM, Jakub Kicinski wrote:
> > +sysfs
> > +-----
> > +
> > +Each device directory in sysfs contains a `statistics` directory (e.g.
> > +`/sys/class/net/lo/statistics/`) with files corresponding to
> > +members of :c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`.
> > +
> > +This simple interface is convenient especially in constrained/embedded
> > +environments without access to tools. However, it's sightly inefficient  
> 
> sightly seems like the wrong word. Did you mean 'highly inefficient'?

Indeed, I'll drop the "slightly". Hopefully the info below is clear
enough for users to understand what's happening. 

> > +when reading multiple stats as it internally performs a full dump of
> > +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>`
> > +and reports only the stat corresponding to the accessed file.
> > +
> > +Sysfs files are documented in
> > +`Documentation/ABI/testing/sysfs-class-net-statistics`.
> > +
> > +
> > +netlink
> > +-------
> > +
> > +`rtnetlink` (`NETLINK_ROUTE`) is the preferred method of accessing
> > +:c:type:`struct rtnl_link_stats64 <rtnl_link_stats64>` stats.
> > +
> > +Statistics are reported both in the responses to link information
> > +requests (`RTM_GETLINK`) and statistic requests (`RTM_GETSTATS`,
> > +when `IFLA_STATS_LINK_64` bit is set in the `.filter_mask` of the request).
> > +
> > +ethtool
> > +-------
> > +
> > +Ethtool IOCTL interface allows drivers to report implementation
> > +specific statistics.  
> 
> an example here would be helpful. e.g., I use `ethool -S` primarily for
> per queue stats which show more details than the other APIs which show
> aggregated stats.

I'll mention the queue stats here.

> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index 7fba4de511de..6ea0fb48739e 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -40,26 +40,191 @@ struct rtnl_link_stats {
> >  	__u32	rx_nohandler;		/* dropped, no handler found	*/
> >  };
> >  
> > -/* The main device statistics structure */
> > +/**
> > + * struct rtnl_link_stats64 - The main device statistics structure.
> > + *
> > + * @rx_packets: Number of good packets received by the interface.
> > + *   For hardware interfaces counts all good packets seen by the host,
> > + *   including packets which host had to drop at various stages of processing
> > + *   (even in the driver).
> > + *
> > + * @tx_packets: Number of packets successfully transmitted.
> > + *   For hardware interfaces counts packets which host was able to successfully
> > + *   hand over to the device, which does not necessarily mean that packets
> > + *   had been successfully transmitted out of the device, only that device
> > + *   acknowledged it copied them out of host memory.
> > + *
> > + * @rx_bytes: Number of good incoming bytes, corresponding to @rx_packets.  
> 
> s/incoming/received/?
> 
> > + *
> > + * @tx_bytes: Number of good incoming bytes, corresponding to @tx_packets.  
> 
> s/incoming/transmitted/

:o I wonder where I got those from.

> Thanks for taking the time to work on this; I'm sure you spent a LOT of
> hours going through all of the drivers and APIs.

And "dusty datasheets" :)
