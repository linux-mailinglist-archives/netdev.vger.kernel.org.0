Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF67F2B9D4C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgKSWCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:02:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:34968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgKSWCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 17:02:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6FFBAAC41;
        Thu, 19 Nov 2020 22:02:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 13A59603F9; Thu, 19 Nov 2020 23:02:03 +0100 (CET)
Date:   Thu, 19 Nov 2020 23:02:03 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 04:56:42PM +0800, tanhuazhong wrote:
> On 2020/11/19 12:15, Andrew Lunn wrote:
> > > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > > index 9ca87bc..afd8de2 100644
> > > --- a/include/uapi/linux/ethtool.h
> > > +++ b/include/uapi/linux/ethtool.h
> > > @@ -433,6 +433,7 @@ struct ethtool_modinfo {
> > >    *	a TX interrupt, when the packet rate is above @pkt_rate_high.
> > >    * @rate_sample_interval: How often to do adaptive coalescing packet rate
> > >    *	sampling, measured in seconds.  Must not be zero.
> > > + * @use_dim: Use DIM for IRQ coalescing, if adaptive coalescing is enabled.
> > >    *
> > >    * Each pair of (usecs, max_frames) fields specifies that interrupts
> > >    * should be coalesced until
> > > @@ -483,6 +484,7 @@ struct ethtool_coalesce {
> > >   	__u32	tx_coalesce_usecs_high;
> > >   	__u32	tx_max_coalesced_frames_high;
> > >   	__u32	rate_sample_interval;
> > > +	__u32	use_dim;
> > >   };
> > 
> > You cannot do this.
> > 
> > static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
> >                                                     void __user *useraddr)
> > {
> >          struct ethtool_coalesce coalesce;
> >          int ret;
> > 
> >          if (!dev->ethtool_ops->set_coalesce)
> >                  return -EOPNOTSUPP;
> > 
> >          if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
> >                  return -EFAULT;
> > 
> > An old ethtool binary is not going to set this extra last byte to
> > anything meaningful. You cannot tell if you have an old or new user
> > space, so you have no idea if it put anything into use_dim, or if it
> > is random junk.

Even worse, as there is no indication of data length, ETHTOOL_GCOALESCE
ioctl request from old ethtool on new kernel would result in kernel
writing past the end of userspace buffer.

> > You have to leave the IOCTL interface unchanged, and limit this new
> > feature to the netlink API.
> > 
> 
> Hi, Andrew.
> thanks for pointing out this problem, i will fix it.
> without callling set_coalesce/set_coalesce of ethtool_ops, do you have any
> suggestion for writing/reading this new attribute to/from the driver? add a
> new field in net_device or a new callback function in ethtool_ops seems not
> good.

We could use a similar approach as struct ethtool_link_ksettings, e.g.

	struct kernel_ethtool_coalesce {
		struct ethtool_coalesce base;
		/* new members which are not part of UAPI */
	}

get_coalesce() and set_coalesce() would get pointer to struct
kernel_ethtool_coalesce and ioctl code would be modified to only touch
the base (legacy?) part.

While already changing the ops arguments, we could also add extack
pointer, either as a separate argument or as struct member (I slightly
prefer the former).

BtW, please don't forget to update the message descriptions in
Documentation/networking/ethtool-netlink.rst

Michal
