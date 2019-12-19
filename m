Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4A125CEC
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 09:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSIqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 03:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfLSIqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 03:46:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB0D24650;
        Thu, 19 Dec 2019 08:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576745176;
        bh=0jcEw8Q6rcPxPmipvd7zTyTGS8RWxVITekelo7p9D3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jnMDfrMClBY7y+umTB+2x2S2If75qx+UJMU4/JYHG7MmEmWf0ts2/JVk73aQvXqYP
         136HC9o6AiAgNHK/o6pyDB0Eo2qXi7hZbUitnoCCTbvDu9MLhanWCo2hh8KHw7xvG1
         u86wp9wh5usbmJeipbA4U1icImtI0SKx6P6/DNe4=
Date:   Thu, 19 Dec 2019 09:46:14 +0100
From:   'Greg KH' <gregkh@linuxfoundation.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191219084614.GC1027830@kroah.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
 <20191214083753.GB3318534@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 06:57:10PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to
> > > > provide RDMA
> [.....]
> 
> > > >
> > > > And who owns the memory of this thing that is supposed to be
> > > > dynamically controlled by something OUTSIDE of this driver?  Who
> > > > created that thing 3 pointers deep?  What happens when you leak the
> > > > memory below (hint, you did), and who is supposed to clean it up if
> > > > you need to properly clean it up if something bad happens?
> > >
> > > The i40e_info object memory is tied to the PF driver.
> > 
> > What is a "PF"?
> 
> physical function.
> 
> > 
> > > The object hierarchy is,
> > >
> > > i40e_pf: pointer to i40e_client_instance
> > > 	----- i40e_client_instance: i40e_info
> > > 		----- i40e_info: virtbus_device
> > 
> > So you are 3 pointers deep to get a structure that is dynamically controlled?  Why
> > are those "3 pointers" not also represented in sysfs?
> > You have a heiarchy within the kernel that is not being represented that way to
> > userspace, why?
> > 
> > Hint, I think this is totally wrong, you need to rework this to be sane.
> > 
> > > For each PF, there is a client_instance object allocated.
> > 
> > Great, make it dynamic and in the device tree.
> > 
> > > The i40e_info object is populated and the virtbus_device hanging off this object
> > is registered.
> > 
> > Great, make that dynamic and inthe device tree.
> > 
> > If you think this is too much, then your whole mess here is too much and needs to
> > be made a lot simpler.
> >
> 
> I think we can decouple the virtbus_device object from i40e_info object.
> 
> Instead allocate a i40e_virtbus_device object which contains
> the virtbus_device and a pointer to i40e_info object for the
> RDMA driver to consume on probe(). Register it the virtbus, and provide
> a release callback to free up its memory.
> 
> Sending a patch snippet to hopefully make it clearer.

Yes, this looks a little bit more sane.

greg k-h
