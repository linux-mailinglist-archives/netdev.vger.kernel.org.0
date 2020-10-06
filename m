Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800B2285069
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJFRCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 13:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgJFRCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 13:02:46 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68D7206DD;
        Tue,  6 Oct 2020 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602003765;
        bh=QWPLv7TnBLoP2/7JXeWMeJKoqaPo0chhYdB6T3EOEmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eULwaUX94P71n9ArVaytNgtse4fJxE4xyDXdi4r4Xza+3wbj97M7FwktYYMTWuhWt
         GFBnYuFT9HL8bAF0YZwSN2Q9ipHExKS+93j4ay6r29nozlgFA1CU/6U6hYUC0XoDN8
         jEWuhb5WzxoIbxmLXTZC5PX9jZbAQQGIMaGCVim0=
Date:   Tue, 6 Oct 2020 20:02:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, parav@mellanox.com, tiwai@suse.de,
        netdev@vger.kernel.org, ranjani.sridharan@linux.intel.com,
        fred.oh@linux.intel.com, linux-rdma@vger.kernel.org,
        dledford@redhat.com, broonie@kernel.org, jgg@nvidia.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        dan.j.williams@intel.com, shiraz.saleem@intel.com,
        davem@davemloft.net, kiran.patil@intel.com
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
Message-ID: <20201006170241.GM1874917@unreal>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrote:
> Thanks for the review Leon.
>
> > > Add support for the Ancillary Bus, ancillary_device and ancillary_driver.
> > > It enables drivers to create an ancillary_device and bind an
> > > ancillary_driver to it.
> >
> > I was under impression that this name is going to be changed.
>
> It's part of the opens stated in the cover letter.

ok, so what are the variants?
system bus (sysbus), sbsystem bus (subbus), crossbus ?

>
> [...]
>
> > > +	const struct my_driver my_drv = {
> > > +		.ancillary_drv = {
> > > +			.driver = {
> > > +				.name = "myancillarydrv",
> >
> > Why do we need to give control over driver name to the driver authors?
> > It can be problematic if author puts name that already exists.
>
> Good point. When I used the ancillary_devices for my own SoundWire test, the
> driver name didn't seem specifically meaningful but needed to be set to
> something, what mattered was the id_table. Just thinking aloud, maybe we can
> add prefixing with KMOD_BUILD, as we've done already to avoid collisions
> between device names?

IMHO, it shouldn't be controlled by the drivers at all and need to have
kernel module name hardwired. Users will use it later for various
bind/unbind/autoprobe tricks and it will give predictability for them.

>
> [...]
>
> > > +int __ancillary_device_add(struct ancillary_device *ancildev, const char *modname)
> > > +{
> > > +	struct device *dev = &ancildev->dev;
> > > +	int ret;
> > > +
> > > +	if (!modname) {
> > > +		pr_err("ancillary device modname is NULL\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ret = dev_set_name(dev, "%s.%s.%d", modname, ancildev->name, ancildev->id);
> > > +	if (ret) {
> > > +		pr_err("ancillary device dev_set_name failed: %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = device_add(dev);
> > > +	if (ret)
> > > +		dev_err(dev, "adding ancillary device failed!: %d\n", ret);
> > > +
> > > +	return ret;
> > > +}
> >
> > Sorry, but this is very strange API that requires users to put
> > internal call to "dev" that is buried inside "struct ancillary_device".
> >
> > For example in your next patch, you write this "put_device(&cdev->ancildev.dev);"
> >
> > I'm pretty sure that the amount of bugs in error unwind will be
> > astonishing, so if you are doing wrappers over core code, better do not
> > pass complexity to the users.
>
> In initial reviews, there was pushback on adding wrappers that don't do
> anything except for a pointer indirection.
>
> Others had concerns that the API wasn't balanced and blurring layers.

Are you talking about internal review or public?
If it is public, can I get a link to it?

>
> Both points have merits IMHO. Do we want wrappers for everything and
> completely hide the low-level device?

This API is partially obscures low level driver-core code and needs to
provide clear and proper abstractions without need to remember about
put_device. There is already _add() interface why don't you do
put_device() in it?

>
> >
> > > +EXPORT_SYMBOL_GPL(__ancillary_device_add);
> > > +
> > > +static int ancillary_probe_driver(struct device *dev)
> > > +{
> > > +	struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
> > > +	struct ancillary_device *ancildev = to_ancillary_dev(dev);
> > > +	int ret;
> > > +
> > > +	ret = dev_pm_domain_attach(dev, true);
> > > +	if (ret) {
> > > +		dev_warn(dev, "Failed to attach to PM Domain : %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = ancildrv->probe(ancildev, ancillary_match_id(ancildrv->id_table, ancildev));
> >
> > I don't think that you need to call ->probe() if ancillary_match_id()
> > returned NULL and probably that check should be done before
> > dev_pm_domain_attach().
>
> we'll look into this.
>
> >
> > > +	if (ret)
> > > +		dev_pm_domain_detach(dev, true);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int ancillary_remove_driver(struct device *dev)
> > > +{
> > > +	struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
> > > +	struct ancillary_device *ancildev = to_ancillary_dev(dev);
> > > +	int ret;
> > > +
> > > +	ret = ancildrv->remove(ancildev);
> > > +	dev_pm_domain_detach(dev, true);
> > > +
> > > +	return ret;
> >
> > You returned an error to user and detached from PM, what will user do
> > with this information? Should user ignore it? retry?
>
> That comment was also provided in earlier reviews. In practice the error is
> typically ignored so there was a suggestion to move the return type to void,
> that could be done if this was desired by the majority.

+1 from me.

>
> [...]
>
> > > diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> > > index 5b08a473cdba..7d596dc30833 100644
> > > --- a/include/linux/mod_devicetable.h
> > > +++ b/include/linux/mod_devicetable.h
> > > @@ -838,4 +838,12 @@ struct mhi_device_id {
> > >   	kernel_ulong_t driver_data;
> > >   };
> > >
> > > +#define ANCILLARY_NAME_SIZE 32
> > > +#define ANCILLARY_MODULE_PREFIX "ancillary:"
> > > +
> > > +struct ancillary_device_id {
> > > +	char name[ANCILLARY_NAME_SIZE];
> >
> > I hope that this be enough.
>
> Are you suggesting a different value to allow for a longer string?

I have no idea, but worried that there were no checks at all if name is
more than 32. Maybe compiler warn about it?

Thanks
