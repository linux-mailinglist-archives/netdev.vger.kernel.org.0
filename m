Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176973E153E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbhHENDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhHENDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:03:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E289A60525;
        Thu,  5 Aug 2021 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628168608;
        bh=J4aXlV0QhcBHC6UrZcmoPMU66i7z71OMuYAFJ+YUEB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ehsnsFXsilzBSldf1ZZOenvufVr1Kgqe09K2o1ZQOCWMI+9kASKjffkcqboWEsKu0
         y8PYBBUS2fiALRUh+xwx02DYg5dTUPSjrzbAeGMP7F3xf9XuZ2z16Sw3s9Z7nIylBn
         yyhokaI6JH4Z4PoVpdVzA+h2YcgZwbcRO3E6b1iN39GuDBGDUsu9SrgLHLYqY1OVi/
         OPtpjdsobN8e9iIU10hWZiOJTUswfJYZzjNTubMKDpa367pxO7KROsDa8EQDuEgKuQ
         2c/Ra/RnbiMlV9hqG/27nwGR/MgWtPwLqE0Jl/IsE7xn5rOxgIc6yvwpXgbT4amWml
         QktDAnMklk2cg==
Date:   Thu, 5 Aug 2021 06:03:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210805060326.4c5fbef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210804235223.rkyxuvdeowcf7wgl@bsd-mbp.dhcp.thefacebook.com>
References: <20210804033327.345759-1-jonathan.lemon@gmail.com>
        <20210804140957.1fd894dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210804235223.rkyxuvdeowcf7wgl@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 16:52:23 -0700 Jonathan Lemon wrote:
> > > +static int
> > > +ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
> > > +			 struct netlink_ext_ack *extack)
> > > +{
> > > +	struct ptp_ocp *bp = devlink_priv(devlink);
> > > +	char buf[32];
> > > +	int err;
> > > +
> > > +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (bp->pending_image) {
> > > +		err = devlink_info_version_stored_put(req,
> > > +						      "timecard", "pending");  
> > 
> > "pending" is not a version. It seems you're talking to the flash
> > directly, why not read the version?  
> 
> We're not talking to the flash yet.  We're writing a new image, but don't
> know the image version, since it's not accessible from the FPGA blob.  So
> since we're don't know what the stored image is until we reboot, I've set
> it to 'pending' here - aka "pending reboot".  Could also be "unknown".

Having the driver remember that the device was flashed is not a solid
indication that the image is actually different. It may be that user
flashed the same version, driver may get reloaded and lose the
indication.. Let's not make a precedent for (ab) use of the version
field to indicate reset required.

> > > +	}
> > > +
> > > +	if (bp->image) {
> > > +		u32 ver = ioread32(&bp->image->version);
> > > +
> > > +		if (ver & 0xffff) {
> > > +			sprintf(buf, "%d", ver);
> > > +			err = devlink_info_version_running_put(req,
> > > +							       "timecard",
> > > +							       buf);
> > > +		} else {
> > > +			sprintf(buf, "%d", ver >> 16);
> > > +			err = devlink_info_version_running_put(req,
> > > +							       "golden flash",
> > > +							       buf);  
> > 
> > What's the difference between "timecard" and "golden flash"?  
> 
> There are two images stored in flash: "golden image", an image that
> just provides flash functionality, and the actual featured FPGA image.
> 
> > Why call firmware for a timecard timecard? We don't call NIC
> > firmware "NIC".  
> 
> I didn't see a standard string to use.  I can call it 'fw.version', just
> needed to differentiate it between the 'golden flash' loader and actual
> firmware.

Is the 'golden flash' a backup in case full featured image does not
work or 'first stage' image/'loader'? IIUC it's the latter so maybe
we can just use "loader"? "fw" for the actual image would be better 
than "fw.version" the entire string is a version after all.

> > > +static void
> > > +ptp_ocp_devlink_health_register(struct devlink *devlink)
> > > +{
> > > +	struct ptp_ocp *bp = devlink_priv(devlink);
> > > +	struct devlink_health_reporter *r;
> > > +
> > > +	r = devlink_health_reporter_create(devlink, &ptp_ocp_health_ops, 0, bp);
> > > +	if (IS_ERR(r))
> > > +		dev_err(&bp->pdev->dev, "Failed to create reporter, err %ld\n",
> > > +			PTR_ERR(r));
> > > +	bp->health = r;
> > > +}  
> > 
> > What made you use devlink health here? Why not just print that "No GPS
> > signal" message to the logs? Devlink health is supposed to give us
> > meaningful context dumps and remediation, here neither is used.  
> 
> The initial idea was to use 'devlink monitor' report the immediate
> failure of the GNSS signal (rather than going through the kernel logs)
> The 'devlink health' also keeps a count of how often the GPS signal
> is lost.
> 
> Our application guys decided to use a different monitoring method,
> so I can rip this out if objectionable. 

Great, thanks!
