Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D14F6816
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 10:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfKJJQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 04:16:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfKJJQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 04:16:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44B5E2077C;
        Sun, 10 Nov 2019 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573377393;
        bh=nnLBlfUmoHMXA0dU6gU2Euuk/uB7tOfJ0lcccUPxFJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQw4UgIKmGngQtQ/ZAhDxYdUy3bCT75CIjNEF+qCRolWb69BJMZhT3VbY/p5ZtMSM
         PstjI49E0yjuiLY2DqU8gw/osmK6RXxnKlD7U6Bc4jtQOhBPvL35z2AXbtkj3dhN0q
         uOGY1nlWEXZ7mpdys600SMHiz1VoQkWszzwBCCKY=
Date:   Sun, 10 Nov 2019 10:16:29 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191110091629.GD1435668@kroah.com>
References: <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
 <20191109084659.GB1289838@kroah.com>
 <20191109111809.GA9565@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109111809.GA9565@nanopsycho>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 12:18:09PM +0100, Jiri Pirko wrote:
> Sat, Nov 09, 2019 at 09:46:59AM CET, gregkh@linuxfoundation.org wrote:
> >On Fri, Nov 08, 2019 at 08:44:26PM -0400, Jason Gunthorpe wrote:
> >> There has been some lack of clarity on what the ?? should be. People
> >> have proposed platform and MFD, and those seem to be no-goes. So, it
> >> looks like ?? will be a mlx5_driver on a mlx5_bus, and Intel will use
> >> an ice_driver on a ice_bus, ditto for cxgb4, if I understand Greg's
> >> guidance.
> >
> >Yes, that is the only way it can work because you really are just
> >sharing a single PCI device in a vendor-specific way, and they all need
> >to get along with each one properly for that vendor-specific way.  So
> >each vendor needs its own "bus" to be able to work out things properly,
> >I doubt you can make this more generic than that easily.
> >
> >> Though I'm wondering if we should have a 'multi_subsystem_device' that
> >> was really just about passing a 'void *core_handle' from the 'core'
> >> (ie the bus) to the driver (ie RDMA, netdev, etc). 
> >
> >Ick, no.
> >
> >> It seems weakly defined, but also exactly what every driver doing this
> >> needs.. It is basically what this series is abusing mdev to accomplish.
> >
> >What is so hard about writing a bus?  Last I tried it was just a few
> >hundred lines of code, if that.  I know it's not the easiest in places,
> >but we have loads of examples to crib from.  If you have
> >problems/questions, just ask!
> >
> >Or, worst case, you just do what I asked in this thread somewhere, and
> >write a "virtual bus" where you just create devices and bind them to the
> >driver before registering and away you go.  No auto-loading needed (or
> >possible), but then you have a generic layer that everyone can use if
> >they want to (but you loose some functionality at the expense of
> >generic code.)
> 
> Pardon my ignorance, just to be clear: You suggest to have
> one-virtual-bus-per-driver or rather some common "xbus" to serve this
> purpose for all of them, right?

Yes.

> If so, isn't that a bit ugly to have a bus in every driver?

No, not if that's what you want to have for that specific type of
device.  I.e. you want to have multiple drivers all attached to a single
PCI device and somehow "share" the physical resources properly in a sane
way.

> I wonder if there can be some abstraction found.

The abstraction is just that, the bus one.  It's not all that complex,
is it?

thanks,

greg k-h
