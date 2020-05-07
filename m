Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1CE1C93AB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgEGPHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgEGPHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:07:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DA920857;
        Thu,  7 May 2020 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588864020;
        bh=SNchQWMbobxyeDm1lRw8XiPEDFnWnN7W8PfMbg+sG7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIpqMuqZEpDOzR549bW3VDCA3rN+OAcfz1o7tjq1qzArVucACWqCEYEOnpp+EhLt3
         IbT5miBppeb8mNGk82HsgWx5nAzdb8EoSZjFVcmaEfLWNfUML65383th9EnyXQhCZn
         KjnH94miON46B9Kvs8wX9LmqNpr5ZHTu2TY20Gpg=
Date:   Thu, 7 May 2020 17:06:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
Message-ID: <20200507150658.GA1886648@kroah.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
 <20200507081737.GC1024567@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7DCD6B850@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD6B850@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 02:04:04PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
> > 
> > On Wed, May 06, 2020 at 02:04:58PM -0700, Jeff Kirsher wrote:
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > The RDMA block does not have its own PCI function, instead it must
> > > utilize the ice driver to gain access to the PCI device. Create a
> > > virtual bus device so the irdma driver can register a virtual bus
> > > driver to bind to it and receive device data. The device data contains
> > > all of the relevant information that the irdma peer will need to
> > > access this PF's IIDC API callbacks.
> > 
> > But there is no virtual bus driver in this patch!
> 
> Hi Greg - 
> 
> The irdma driver is the virtbus driver that would bind to the virtual devices created
> in this netdev driver.

Then why even have the virtbus code in this patch if there are no users?

And without any users, you are creating "virtbus devices" that live on
what bus?  How does that work at all?  Kind of defeats the purpose of a
virtual bus entirely if you do not use it, right?

> It is decoupled from this series as it was deemed in a prior discussion that irdma driver
> would go in a +1 cycle from net series to avoid conflicts. See discussion here --
> https://lore.kernel.org/netdev/46ed855e75f9eda89118bfad9c6f7b16dd372c71.camel@intel.com/
> 
> The irdma driver is currently posted as an RFC series with its most recent submission here --
> https://lore.kernel.org/linux-rdma/20200417171251.1533371-1-jeffrey.t.kirsher@intel.com/

I can't accept that this series is using a virtual bus properly without
actually using the virtual bus driver code, can you?

If this is the case, it better be REALLY REALLY REALLY well documented
when one would, and would not, want to do that, as it doesn't make sense
to me...

thanks,

greg k-h
