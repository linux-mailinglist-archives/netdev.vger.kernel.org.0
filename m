Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F446F5E18
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfKIIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfKIIrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 03:47:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 976A4214E0;
        Sat,  9 Nov 2019 08:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573289222;
        bh=rlfVeh3hFAuUqU1iwmWMP9/hCo+EzMqimLNvLzKizuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qRtEOwuVMZJ7p3kkY8QF7AbYlsidmiKDkVxKL9yeTjNE7m0NsL+o6xSCyO/uiYre8
         lA71Ubq7LLTVyW+fN44qPHeWaLMROlxthzTVqvVQkyMxzE9Er3GeDJKjSHhJIMO+4x
         mN2v09hOWO7k0usvWF1iGmZ53fbdQxal9tX1zmQ4=
Date:   Sat, 9 Nov 2019 09:46:59 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <20191109084659.GB1289838@kroah.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109004426.GB31761@ziepe.ca>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 08:44:26PM -0400, Jason Gunthorpe wrote:
> There has been some lack of clarity on what the ?? should be. People
> have proposed platform and MFD, and those seem to be no-goes. So, it
> looks like ?? will be a mlx5_driver on a mlx5_bus, and Intel will use
> an ice_driver on a ice_bus, ditto for cxgb4, if I understand Greg's
> guidance.

Yes, that is the only way it can work because you really are just
sharing a single PCI device in a vendor-specific way, and they all need
to get along with each one properly for that vendor-specific way.  So
each vendor needs its own "bus" to be able to work out things properly,
I doubt you can make this more generic than that easily.

> Though I'm wondering if we should have a 'multi_subsystem_device' that
> was really just about passing a 'void *core_handle' from the 'core'
> (ie the bus) to the driver (ie RDMA, netdev, etc). 

Ick, no.

> It seems weakly defined, but also exactly what every driver doing this
> needs.. It is basically what this series is abusing mdev to accomplish.

What is so hard about writing a bus?  Last I tried it was just a few
hundred lines of code, if that.  I know it's not the easiest in places,
but we have loads of examples to crib from.  If you have
problems/questions, just ask!

Or, worst case, you just do what I asked in this thread somewhere, and
write a "virtual bus" where you just create devices and bind them to the
driver before registering and away you go.  No auto-loading needed (or
possible), but then you have a generic layer that everyone can use if
they want to (but you loose some functionality at the expense of
generic code.)

Are these constant long email threads a way that people are just trying
to get me to do this work for them?  Because if it is, it's working...

thanks,

greg k-h
