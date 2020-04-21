Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0841B1F9A
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDUHOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgDUHOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:14:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28BFF2087E;
        Tue, 21 Apr 2020 07:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587453245;
        bh=NpWjsua2Ps0YcMb9Vidj0joQYgcnX8efm48CHmdQmVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CeF1k7rj64dTCjhP0CXrACOS9xpKzbZ892ZWACewS5/EJ63v5QqurhQePNwHdktZN
         KBqqAUF7eAhCjwTr7TP+B4iL1PJz+SKzMFIEaOx6jCw9+xFtmkDwbAUO46K2JBblVw
         9sDURqwRbp9kyUl6C8f8qaVw4uKtNg0VOxy5B4lU=
Date:   Tue, 21 Apr 2020 10:14:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework definitions
Message-ID: <20200421071401.GF121146@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-2-jeffrey.t.kirsher@intel.com>
 <20200417193421.GB3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7DCD4853F@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:23:45AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC PATCH v5 01/16] RDMA/irdma: Add driver framework
> > definitions
> >
> > On Fri, Apr 17, 2020 at 10:12:36AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Register irdma as a virtbus driver capable of supporting virtbus
> > > devices from multi-generation RDMA capable Intel HW. Establish the
> > > interface with all supported netdev peer drivers and initialize HW.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > ---
> > >  drivers/infiniband/hw/irdma/i40iw_if.c | 228 ++++++++++
> > > drivers/infiniband/hw/irdma/irdma_if.c | 449 ++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/main.c     | 573 +++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/main.h     | 599 +++++++++++++++++++++++++
> > >  4 files changed, 1849 insertions(+)
> > >  create mode 100644 drivers/infiniband/hw/irdma/i40iw_if.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/irdma_if.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/main.h
> > >
> >
> > I didn't look in too much details, but three things caught my attention immediately:
> > 1. Existence of ARP cache management logic in RDMA driver.
>
> Our HW has an independent ARP table for the rdma block.
> driver needs to add an ARP table entry via an rdma admin
> queue command before QP transitions to RTS.
>
> > 2. Extensive use of dev_*() prints while we have ibdev_*() prints
> The ib device object is not available till the end of the device init
> similarly its unavailable early on in device deinit flows. So dev_*
> is all we can use in those places.

I think that I saw those dev_ prints in all flows and not in
initialization only. Anyway like Jason said below, it is better to fix
set_name to be sure that it exists as early as possible.

Thanks
