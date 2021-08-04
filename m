Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7361A3E0AFF
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhHDXwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:52:41 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:63144 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbhHDXwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 19:52:41 -0400
Received: (qmail 90912 invoked by uid 89); 4 Aug 2021 23:52:25 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 4 Aug 2021 23:52:25 -0000
Date:   Wed, 4 Aug 2021 16:52:23 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210804235223.rkyxuvdeowcf7wgl@bsd-mbp.dhcp.thefacebook.com>
References: <20210804033327.345759-1-jonathan.lemon@gmail.com>
 <20210804140957.1fd894dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804140957.1fd894dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 02:09:57PM -0700, Jakub Kicinski wrote:
> On Tue,  3 Aug 2021 20:33:27 -0700 Jonathan Lemon wrote:
> > +static const struct devlink_param ptp_ocp_devlink_params[] = {
> > +};
> > +
> > +static void
> > +ptp_ocp_devlink_set_params_init_values(struct devlink *devlink)
> > +{
> > +}
> 
> Why register empty set of params?

I had this filled out at some point, but they got removed.


> > +static int
> > +ptp_ocp_devlink_register(struct devlink *devlink, struct device *dev)
> > +{
> > +	int err;
> > +
> > +	err = devlink_register(devlink, dev);
> > +	if (err)
> > +		return err;
> > +
> > +	err = devlink_params_register(devlink, ptp_ocp_devlink_params,
> > +				      ARRAY_SIZE(ptp_ocp_devlink_params));
> > +	ptp_ocp_devlink_set_params_init_values(devlink);
> > +	if (err)
> > +		goto out;
> > +	devlink_params_publish(devlink);
> > +
> > +	return 0;
> > +
> > +out:
> > +	devlink_unregister(devlink);
> > +	return err;
> > +}
> 
> > +static int
> > +ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
> > +			 struct netlink_ext_ack *extack)
> > +{
> > +	struct ptp_ocp *bp = devlink_priv(devlink);
> > +	char buf[32];
> > +	int err;
> > +
> > +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> > +	if (err)
> > +		return err;
> > +
> > +	if (bp->pending_image) {
> > +		err = devlink_info_version_stored_put(req,
> > +						      "timecard", "pending");
> 
> "pending" is not a version. It seems you're talking to the flash
> directly, why not read the version?

We're not talking to the flash yet.  We're writing a new image, but don't
know the image version, since it's not accessible from the FPGA blob.  So
since we're don't know what the stored image is until we reboot, I've set
it to 'pending' here - aka "pending reboot".  Could also be "unknown".
 

> > +	}
> > +
> > +	if (bp->image) {
> > +		u32 ver = ioread32(&bp->image->version);
> > +
> > +		if (ver & 0xffff) {
> > +			sprintf(buf, "%d", ver);
> > +			err = devlink_info_version_running_put(req,
> > +							       "timecard",
> > +							       buf);
> > +		} else {
> > +			sprintf(buf, "%d", ver >> 16);
> > +			err = devlink_info_version_running_put(req,
> > +							       "golden flash",
> > +							       buf);
> 
> What's the difference between "timecard" and "golden flash"?

There are two images stored in flash: "golden image", an image that
just provides flash functionality, and the actual featured FPGA image.


> Why call firmware for a timecard timecard? We don't call NIC
> firmware "NIC".

I didn't see a standard string to use.  I can call it 'fw.version', just
needed to differentiate it between the 'golden flash' loader and actual
firmware.



> Drivers using devlink should document what they implement and meaning
> of various fields. Please see examples in
> Documentation/networking/devlink/

I'll add things there.


> > +static void
> > +ptp_ocp_devlink_health_register(struct devlink *devlink)
> > +{
> > +	struct ptp_ocp *bp = devlink_priv(devlink);
> > +	struct devlink_health_reporter *r;
> > +
> > +	r = devlink_health_reporter_create(devlink, &ptp_ocp_health_ops, 0, bp);
> > +	if (IS_ERR(r))
> > +		dev_err(&bp->pdev->dev, "Failed to create reporter, err %ld\n",
> > +			PTR_ERR(r));
> > +	bp->health = r;
> > +}
> 
> What made you use devlink health here? Why not just print that "No GPS
> signal" message to the logs? Devlink health is supposed to give us
> meaningful context dumps and remediation, here neither is used.

The initial idea was to use 'devlink monitor' report the immediate
failure of the GNSS signal (rather than going through the kernel logs)
The 'devlink health' also keeps a count of how often the GPS signal
is lost.

Our application guys decided to use a different monitoring method,
so I can rip this out if objectionable. 
-- 
Jonathan
