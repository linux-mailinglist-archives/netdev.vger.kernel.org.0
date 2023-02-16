Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D209699504
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjBPM74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBPM7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:59:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531BD305CC
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4015B82591
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347E0C433D2;
        Thu, 16 Feb 2023 12:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676552391;
        bh=wHROhOnrwnrzkzQlPdmezVlpXPrVFwu8E6QNIge0wmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSFO2eBAU8eQCKW2120tLRUNeGRxTOqKhnPlzzozxvQ+fgdOPRdjI8K6Lta/Cm0Ic
         hcrG9scuz3JlH0AjcbbB8uAuR4lr77qir3GMDFD4cq3oeXN6RdlWK+6L7eYGidlDbK
         zBEQnsSHQ1L0/QGkVew7CWrx+2JAnq8KQPEZam9w=
Date:   Thu, 16 Feb 2023 13:59:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Temerkhanov, Sergey" <sergey.temerkhanov@intel.com>,
        netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] auxiliary: Implement refcounting
Message-ID: <Y+4oxWE0HsTcVGFw@kroah.com>
References: <20230216121621.37063-1-sergey.temerkhanov@intel.com>
 <Y+4kwf3SRq5NBzBz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+4kwf3SRq5NBzBz@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:42:41PM +0200, Leon Romanovsky wrote:
> + Greg KH
> 
> On Thu, Feb 16, 2023 at 01:16:21PM +0100, Temerkhanov, Sergey wrote:
> > From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
> > 
> > Implement reference counting to make it possible to synchronize
> > deinitialization and removal of interfaces published via aux bus
> > with the client modules.
> > Reference counting can be used in both sleeping and non-sleeping
> > contexts so this approach is intended to replace device_lock()
> > (mutex acquisition) with an additional lock on top of it
> > which is not always possible to take in client code.
> 
> I want to see this patch as part of your client code series.
> It is unclear why same aux device is used from different drivers.
> 
> Otherwise, this whole refcnt is useless and just hides bugs in driver
> which accesses released devices.
> 
> > 
> > Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
> > ---
> >  drivers/base/auxiliary.c      | 18 ++++++++++++++++++
> >  include/linux/auxiliary_bus.h | 34 +++++++++++++++++++++++++---------
> >  2 files changed, 43 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
> > index 8c5e65930617..082b3ebd143d 100644
> > --- a/drivers/base/auxiliary.c
> > +++ b/drivers/base/auxiliary.c
> > @@ -287,10 +287,28 @@ int auxiliary_device_init(struct auxiliary_device *auxdev)
> >  
> >  	dev->bus = &auxiliary_bus_type;
> >  	device_initialize(&auxdev->dev);
> > +	init_waitqueue_head(&auxdev->wq_head);
> > +	refcount_set(&auxdev->refcnt, 1);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(auxiliary_device_init);
> >  
> > +void auxiliary_device_uninit(struct auxiliary_device *auxdev)
> > +{
> > +	wait_event_interruptible(auxdev->wq_head,
> > +				 refcount_dec_if_one(&auxdev->refcnt));
> > +}
> > +EXPORT_SYMBOL_GPL(auxiliary_device_uninit);
> > +
> > +void auxiliary_device_delete(struct auxiliary_device *auxdev)
> > +{
> > +	WARN_ON(refcount_read(&auxdev->refcnt));

There are 3 things wrong with this single line of code, pretty
impressive!

First off, never use WARN_ON unless you want to reboot people's
machines.  Handle the issue if it can really happen and keep on moving.
Don't just throw up your hands and yell at userspace and stop the box
(remember panic-on-warn is real.)

Second, if this is a real problem, HANDLE IT!  Don't just free memory
as obviously someone actually has the memory in use!

Third, NEVER read the reference count and do something based on it.
That's not how reference counts work at all, unless you are using the
correct reference count function (hint, this is not it.)

> > +
> > +	device_del(&auxdev->dev);

No, no no no no .

I see why you didn't cc me on this thread to start with, you were trying
to get this by without review, that's not ok.

You now have the required penance of having to get an internal-Intel
review and signed-off-by FIRST before sending this patch series out
again.

greg k-h
