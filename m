Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E72CFE71
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLETe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:34:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgLETe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:34:26 -0500
Date:   Sat, 5 Dec 2020 16:51:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607183422;
        bh=PQ69+Tx5HitWyIcatLXcVOYusWMncetXLlHJ6cpFLvI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=obVwWTPBgowRIlgR/YFaNaEEEhRcfnyHlRw/AhzQOSjfG0IGgfw0tFWEV0XoUQVID
         Ay/YtrGkq467MNtFa5rzttgvJKrH+o3tabpljx7gRaUKF7TM+hLgvYovL14G0Ipyfh
         b28V6+/JlrduTXFuQAuYyrfpWz39VqAQ6wwaWoMk=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <X8usiKhLCU3PGL9J@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 08:41:09AM -0800, Dan Williams wrote:
> On Fri, Dec 4, 2020 at 3:41 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> > > From: Dave Ertman <david.m.ertman@intel.com>
> > >
> > > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > > It enables drivers to create an auxiliary_device and bind an
> > > auxiliary_driver to it.
> > >
> > > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > > Each auxiliary_device has a unique string based id; driver binds to
> > > an auxiliary_device based on this id through the bus.
> > >
> > > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Reviewed-by: Martin Habets <mhabets@solarflare.com>
> > > Link: https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > > This patch is "To:" the maintainers that have a pending backlog of
> > > driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> > > understand you have asked for more time to fully review this and apply
> > > it to driver-core.git, likely for v5.12, but please consider Acking it
> > > for v5.11 instead. It looks good to me and several other stakeholders.
> > > Namely, stakeholders that have pressure building up behind this facility
> > > in particular Mellanox RDMA, but also SOF, Intel Ethernet, and later on
> > > Compute Express Link.
> > >
> > > I will take the blame for the 2 months of silence that made this awkward
> > > to take through driver-core.git, but at the same time I do not want to
> > > see that communication mistake inconvenience other parties that
> > > reasonably thought this was shaping up to land in v5.11.
> > >
> > > I am willing to host this version at:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux tags/auxiliary-bus-for-5.11
> > >
> > > ...for all the independent drivers to have a common commit baseline. It
> > > is not there yet pending Greg's Ack.
> > >
> > > For example implementations incorporating this patch, see Dave Ertman's
> > > SOF series:
> > >
> > > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > >
> > > ...and Leon's mlx5 series:
> > >
> > > http://lore.kernel.org/r/20201026111849.1035786-1-leon@kernel.org
> > >
> > > PS: Greg I know I promised some review on newcomer patches to help with
> > > your queue, unfortunately Intel-internal review is keeping my plate
> > > full. Again, I do not want other stakeholder to be waiting on me to
> > > resolve that backlog.
> >
> > Ok, I spent some hours today playing around with this.  I wrote up a
> > small test-patch for this (how did anyone test this thing???) and while
> > it feels awkward in places, and it feels like there is still way too
> > much "boilerplate" code that a user has to write and manage, I don't
> > have the time myself to fix it up right now.
> >
> > So I'll go apply this to my tree, and provide a tag for everyone else to
> > be able to pull from for their different development trees so they can
> > work on.
> >
> > I do have 3 follow-on patches that I will send to the list in response
> > to this message that I will be applying on top of this patch.  They do
> > some minor code formatting changes, as well as change the return type of
> > the remove function to make it more future-proof.  That last change will
> > require users of this code to change their implementations, but it will
> > be obvious what to do as you will get a build warning.
> >
> > Note, I'm still not comfortable with a few things here.  The
> > documentation feels odd, and didn't really help me out in writing any
> > test code, which doesn't seem right.  Also the use of strings and '.' as
> > part of the api feels awkward, and messy, and of course, totally
> > undocumented.
> >
> > But, as the use of '.' is undocumented, that means we can change it in
> > the future!  Because no driver or device name should ever be a user api
> > reliant thing, if we come up with a better way to do all of this in the
> > future, that shouldn't be a problem to change existing users over to
> > this.  So this is a warning to everyone, you CAN NOT depend on the sysfs
> > name of a device or bus name for any tool.  If so, your userspace tool
> > is broken.
> >
> > Thanks for everyone in sticking with this, I know it's been a long slog,
> > hopefully this will help some driver authors move forward with their
> > crazy complex devices :)
> 
> To me, the documentation was written, and reviewed, more from the
> perspective of "why not open code a custom bus instead". So I can see
> after the fact how that is a bit too much theory and justification and
> not enough practical application. Before the fact though this was a
> bold mechanism to propose and it was not clear that everyone was
> grokking the "why" and the tradeoffs.

Understood, I guess I read this from the "of course you should do this,
now how do I use it?" point of view.  Which still needs to be addressed
I feel.

> I also think it was a bit early to identify consistent design patterns
> across the implementations and codify those. I expect this to evolve
> convenience macros just like other parts of the driver-core gained
> over time. Now that it is in though, another pass through the
> documentation to pull in more examples seems warranted.

A real, working, example would be great to have, so that people can know
how to use this.  Trying to dig through the sound or IB patches to view
how it is being used is not a trivial thing to do, which is why
reviewing this took so much work.  Having a simple example test module,
that creates a number of devices on a bus, ideally tied into the ktest
framework, would be great.  I'll attach below a .c file that I used for
some basic local testing to verify some of this working, but it does not
implement a aux bus driver, which needs to be also tested.

thanks,

greg k-h

-------------


// SPDX-License-Identifier: GPL-2.0-only


#include <linux/init.h>
#include <linux/device.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/auxiliary_bus.h>
#include <linux/platform_device.h>


struct aux_test_device {
	struct auxiliary_device auxdev;
	int foo;
	void *data;
};

#define aux_dev_to_test_device(auxdev)	\
	container_of(auxdev, struct aux_test_device, auxdev)

static void aux_test_dev_release(struct device *dev)
{
	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
	struct aux_test_device *test_dev = aux_dev_to_test_device(auxdev);

	kfree(test_dev);
}

static struct aux_test_device *test_device_alloc(struct device *parent,
						 const char *name, u32 id)
{
	struct aux_test_device *test_dev;
	struct auxiliary_device *auxdev;
	int retval;

	test_dev = kzalloc(sizeof(*test_dev), GFP_KERNEL);
	if (!test_dev)
		return NULL;

	auxdev= &test_dev->auxdev;
	auxdev->name = name;
	auxdev->dev.parent = parent;
	auxdev->dev.release = aux_test_dev_release;
	auxdev->id = id;

	retval = auxiliary_device_init(auxdev);
	if (retval) {
		dev_err(parent, "aux device failed to init\n");
		kfree(test_dev);
		return NULL;
	}

	return test_dev;
}

static struct aux_test_device *test_device_create(struct device *parent,
						  const char *name, u32 id)
{
	struct aux_test_device *test_dev;
	int retval;

	test_dev = test_device_alloc(parent, name, id);
	if (!test_dev) {
		dev_err(parent, "aux device %s failed to be created\n", name);
		return NULL;
	}

	retval = auxiliary_device_add(&test_dev->auxdev);
	if (retval) {
		dev_err(parent, "aux device %s failed to be added, error %d\n",
			name, retval);
		auxiliary_device_uninit(&test_dev->auxdev);
		return NULL;
	}

	return test_dev;
}

static void test_dev_del(struct aux_test_device *test_dev)
{
	if (!test_dev)
		return;

	auxiliary_device_delete(&test_dev->auxdev);
	auxiliary_device_uninit(&test_dev->auxdev);
}


static struct aux_test_device *tdev1, *tdev2, *tdev3;

/* Make a random device to be the "parent" of our tests */
static struct platform_device *root_device;

static void root_device_release(struct device *dev)
{
	struct platform_device *pdev = to_platform_device(dev);
	kfree(pdev);
}

static int __init aux_test_init(void)
{
	int retval;

	root_device = kzalloc(sizeof(*root_device), GFP_KERNEL);
	if (!root_device)
		return -ENOMEM;

	root_device->name = "aux_test_root";
	root_device->dev.release = root_device_release;

	retval = platform_device_register(root_device);
	if (retval) {
		kfree(root_device);
		return retval;
	}

	/* Allocate 3 test devices as a child of this parent */
	tdev1 = test_device_create(&root_device->dev, "test_dev_1", 21);
	tdev2 = test_device_create(&root_device->dev, "test_dev_2", 32);
	tdev3 = test_device_create(&root_device->dev, "test_dev_3", 43);

	return 0;
}

static void __exit aux_test_exit(void)
{
	test_dev_del(tdev1);
	test_dev_del(tdev2);
	test_dev_del(tdev3);
	platform_device_unregister(root_device);

}



module_init(aux_test_init);
module_exit(aux_test_exit);


MODULE_LICENSE("GPL v2");
