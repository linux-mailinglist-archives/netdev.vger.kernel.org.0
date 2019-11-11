Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7BBF7624
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKKOOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKOOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 09:14:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA40C21925;
        Mon, 11 Nov 2019 14:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573481672;
        bh=0IDDU6b5/Y6auVkjsPzFNFLTUrYbv58q9hkKdzQUSNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XdzM8eMhYSmS19YTBemsLCBU/GHzm2gOp6gPrWol5hs9QTFY6JVhAlBUh7YD3I1l1
         Z+TnpWQLpX2z5dMlOECaQKZyQa14MpK0euWtP0BiZWBNc9iuT3Z+y2/luEZmm88FWV
         3ZIkZYj0SuRNAmGlF9cD6Gtm6QsRKPqhLH5GPJ0M=
Date:   Mon, 11 Nov 2019 15:14:30 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20191111141430.GB585609@kroah.com>
References: <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
 <20191109092747.26a1a37e@cakuba>
 <20191110091855.GE1435668@kroah.com>
 <20191110194601.0d6ed1a0@cakuba>
 <20191111133026.GA2202@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111133026.GA2202@nanopsycho>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 02:30:26PM +0100, Jiri Pirko wrote:
> Mon, Nov 11, 2019 at 04:46:01AM CET, jakub.kicinski@netronome.com wrote:
> >On Sun, 10 Nov 2019 10:18:55 +0100, gregkh@linuxfoundation.org wrote:
> >> > What I'm missing is why is it so bad to have a driver register to
> >> > multiple subsystems.  
> >> 
> >> Because these PCI devices seem to do "different" things all in one PCI
> >> resource set.  Blame the hardware designers :)
> >
> >See below, I don't think you can blame the HW designers in this
> >particular case :)
> >
> >> > For the nfp I think the _real_ reason to have a bus was that it
> >> > was expected to have some out-of-tree modules bind to it. Something 
> >> > I would not encourage :)  
> >> 
> >> That's not ok, and I agree with you.
> >> 
> >> But there seems to be some more complex PCI devices that do lots of
> >> different things all at once.  Kind of like a PCI device that wants to
> >> be both a keyboard and a storage device at the same time (i.e. a button
> >> on a disk drive...)
> >
> >The keyboard which is also a storage device may be a clear cut case
> >where multiple devices were integrated into one bus endpoint.
> 
> Also, I think that very important differentiator between keyboard/button
> and NIC is that keyboard/button is fixed. You have driver bus with 2
> devices on constant addresses.
> 
> However in case of NIC subfunctions. You have 0 at he beginning and user
> instructs to create more (maybe hundreds). Now important questions
> appear:
> 
> 1) How to create devices (what API) - mdev has this figured out
> 2) How to to do the addressing of the devices. Needs to be
>    predictable/defined by the user - mdev has this figured out
> 3) Udev names of netdevices - udev names that according to the
>    bus/address. That is straightforeward with mdev.
>    I can't really see how to figure this one in particular with
>    per-driver busses :/

Are network devices somehow only allowed to be on mdev busses?

No, don't be silly, userspace handles this just fine today on any type
of bus, it's not an issue.

You don't have to like individual "driver busses", but you had better
not be using a fake platform device to use mdev.  That's my main
objection...

thanks,

greg k-h
