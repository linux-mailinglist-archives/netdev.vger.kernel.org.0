Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0F2333718
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCJIPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhCJIOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 03:14:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F088464F77;
        Wed, 10 Mar 2021 08:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615364085;
        bh=REML057x1YQ7kil2IiGWp6ZVMYBK2+JotB4MVnn0E14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rm9l+M/so2zxYZOvcoFXMmUstRW/gq7/audoTuIgy7Z88P8XFDWuETkSpf6AT03Xh
         dRlbYqJ7PdohEWizQm7dROy1L4xsG7Fomo8d17vHI2gxmZh+uDixCzBHY2Xh2SfggQ
         H0L0jvAdBXhEsdJFfx6CpARdg/Fs4VoJ15mZtmLA=
Date:   Wed, 10 Mar 2021 09:14:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v10 14/20] dlb: add start domain ioctl
Message-ID: <YEh/8kGCXx6VIweA@kroah.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-15-mike.ximing.chen@intel.com>
 <YEc/8RxroJzrN3xm@kroah.com>
 <BYAPR11MB3095CCF0E4931A4DB75AB3F7D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3095CCF0E4931A4DB75AB3F7D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 02:45:10AM +0000, Chen, Mike Ximing wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > On Wed, Feb 10, 2021 at 11:54:17AM -0600, Mike Ximing Chen wrote:
> > >
> > > diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
> > > index 6a311b969643..9b05344f03c8 100644
> > > --- a/drivers/misc/dlb/dlb_ioctl.c
> > > +++ b/drivers/misc/dlb/dlb_ioctl.c
> > > @@ -51,6 +51,7 @@
> > DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_ldb_queue)
> > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
> > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
> > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
> > > +DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
> > >
> > > --- a/drivers/misc/dlb/dlb_pf_ops.c
> > > +++ b/drivers/misc/dlb/dlb_pf_ops.c
> > > @@ -160,6 +160,14 @@ dlb_pf_create_dir_port(struct dlb_hw *hw, u32 id,
> > >  				       resp, false, 0);
> > >  }
> > >
> > > +static int
> > > +dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
> > > +		    struct dlb_start_domain_args *args,
> > > +		    struct dlb_cmd_response *resp)
> > > +{
> > > +	return dlb_hw_start_domain(hw, id, args, resp, false, 0);
> > > +}
> > > +
> > >  static int dlb_pf_get_num_resources(struct dlb_hw *hw,
> > >  				    struct dlb_get_num_resources_args *args)
> > >  {
> > > @@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops = {
> > >  	.create_dir_queue = dlb_pf_create_dir_queue,
> > >  	.create_ldb_port = dlb_pf_create_ldb_port,
> > >  	.create_dir_port = dlb_pf_create_dir_port,
> > > +	.start_domain = dlb_pf_start_domain,
> > 
> > Why do you have a "callback" when you only ever call one function?  Why
> > is that needed at all?
> > 
> In our next submission, we are going to add virtual function (VF) support. The
> callbacks for VFs are different from those for PF which is what we support in this
> submission. We can defer the introduction of  the callback structure to when we 
> add the VF support. But since we have many callback functions, that approach
> will generate many changes in then "existing" code. We thought that putting
> the callback structure in place now would make the job of adding VF support easier.
> Is it OK?

No, do not add additional complexity when it is not needed.  It causes
much more review work and I and no one else have any idea that
"something might be coming in the future", so please do not make our
lives harder.

Make it simple, and work, now.  You can always add additional changes
later, if it is ever needed.

thanks,

greg k-h
