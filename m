Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089F931F576
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 08:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBSHxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 02:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbhBSHxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 02:53:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB8E64EC7;
        Fri, 19 Feb 2021 07:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613721137;
        bh=8qKIm+crD0AThYzSX/y8v/BQrxRoZpW2o08jNZp7es8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=trzlbeDCmmkt3oPXaemLZeiJn0O7iZbpRzXJz1QLozIgyP5GkfFt9ctFf4trwoYaQ
         6uL2L6zkhTKH23o89mbMUw38st35yVhaQejZkERa5oaakduOq4+oOBB7JGP2j1TTyC
         rtt3FOxkY5D9KI/mYGHj14nUenFFr/5MgHggbc4A4fAeNUkB9tjD06U4Q5JqwLPSGN
         SO9mKZRb6HGDRoMzNyM5CBXiN+8ZH0/Fh8fFOcpBjJJQ3qHS3y4QjTjDCpgMa/tP31
         O5OOASpu+0eUb9fBCkBWFFnWbFvbJRxeO4EZWaj9h9g4IhDUZt8zV/q2Mm1dkTnnyA
         gV9cflwqCgO4A==
Date:   Fri, 19 Feb 2021 09:52:12 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YC9uLDAQJK9KgxbB@unreal>
References: <YC4+V6W7s7ytwiC6@unreal>
 <20210218223950.GA1004646@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218223950.GA1004646@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 04:39:50PM -0600, Bjorn Helgaas wrote:
> On Thu, Feb 18, 2021 at 12:15:51PM +0200, Leon Romanovsky wrote:
> > On Wed, Feb 17, 2021 at 12:02:39PM -0600, Bjorn Helgaas wrote:
> > > [+cc Greg in case he wants to chime in on the sysfs discussion.
> > > TL;DR: we're trying to add/remove sysfs files when a PCI driver that
> > > supports certain callbacks binds or unbinds; series at
> > > https://lore.kernel.org/r/20210209133445.700225-1-leon@kernel.org]
> > >
> > > On Tue, Feb 16, 2021 at 09:58:25PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Feb 16, 2021 at 10:12:12AM -0600, Bjorn Helgaas wrote:
> > > > > On Tue, Feb 16, 2021 at 09:33:44AM +0200, Leon Romanovsky wrote:
> > > > > > On Mon, Feb 15, 2021 at 03:01:06PM -0600, Bjorn Helgaas wrote:
> > > > > > > On Tue, Feb 09, 2021 at 03:34:42PM +0200, Leon Romanovsky wrote:
> > > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > > > > > > +int pci_enable_vf_overlay(struct pci_dev *dev)
> > > > > > > > +{
> > > > > > > > +	struct pci_dev *virtfn;
> > > > > > > > +	int id, ret;
> > > > > > > > +
> > > > > > > > +	if (!dev->is_physfn || !dev->sriov->num_VFs)
> > > > > > > > +		return 0;
> > > > > > > > +
> > > > > > > > +	ret = sysfs_create_files(&dev->dev.kobj, sriov_pf_dev_attrs);
> > > > > > >
> > > > > > > But I still don't like the fact that we're calling
> > > > > > > sysfs_create_files() and sysfs_remove_files() directly.  It makes
> > > > > > > complication and opportunities for errors.
> > > > > >
> > > > > > It is not different from any other code that we have in the kernel.
> > > > >
> > > > > It *is* different.  There is a general rule that drivers should not
> > > > > call sysfs_* [1].  The PCI core is arguably not a "driver," but it is
> > > > > still true that callers of sysfs_create_files() are very special, and
> > > > > I'd prefer not to add another one.
> > > >
> > > > PCI for me is a bus, and bus is the right place to manage sysfs.
> > > > But it doesn't matter, we understand each other positions.
> > > >
> > > > > > Let's be concrete, can you point to the errors in this code that I
> > > > > > should fix?
> > > > >
> > > > > I'm not saying there are current errors; I'm saying the additional
> > > > > code makes errors possible in future code.  For example, we hope that
> > > > > other drivers can use these sysfs interfaces, and it's possible they
> > > > > may not call pci_enable_vf_overlay() or pci_disable_vfs_overlay()
> > > > > correctly.
> > > >
> > > > If not, we will fix, we just need is to ensure that sysfs name won't
> > > > change, everything else is easy to change.
> > > >
> > > > > Or there may be races in device addition/removal.  We have current
> > > > > issues in this area, e.g., [2], and they're fairly subtle.  I'm not
> > > > > saying your patches have these issues; only that extra code makes more
> > > > > chances for mistakes and it's more work to validate it.
> > > > >
> > > > > > > I don't see the advantage of creating these files only when
> > > > > > > the PF driver supports this.  The management tools have to
> > > > > > > deal with sriov_vf_total_msix == 0 and sriov_vf_msix_count ==
> > > > > > > 0 anyway.  Having the sysfs files not be present at all might
> > > > > > > be slightly prettier to the person running "ls", but I'm not
> > > > > > > sure the code complication is worth that.
> > > > > >
> > > > > > It is more than "ls", right now sriov_numvfs is visible without
> > > > > > relation to the driver, even if driver doesn't implement
> > > > > > ".sriov_configure", which IMHO bad. We didn't want to repeat.
> > > > > >
> > > > > > Right now, we have many devices that supports SR-IOV, but small
> > > > > > amount of them are capable to rewrite their VF MSI-X table siz.
> > > > > > We don't want "to punish" and clatter their sysfs.
> > > > >
> > > > > I agree, it's clutter, but at least it's just cosmetic clutter
> > > > > (but I'm willing to hear discussion about why it's more than
> > > > > cosmetic; see below).
> > > >
> > > > It is more than cosmetic and IMHO it is related to the driver role.
> > > > This feature is advertised, managed and configured by PF. It is very
> > > > natural request that the PF will view/hide those sysfs files.
> > >
> > > Agreed, it's natural if the PF driver adds/removes those files.  But I
> > > don't think it's *essential*, and they *could* be static because of
> > > this:
> > >
> > > > > From the management software point of view, I don't think it matters.
> > > > > That software already needs to deal with files that don't exist (on
> > > > > old kernels) and files that contain zero (feature not supported or no
> > > > > vectors are available).
> > >
> > > I wonder if sysfs_update_group() would let us have our cake and eat
> > > it, too?  Maybe we could define these files as static attributes and
> > > call sysfs_update_group() when the PF driver binds or unbinds?
> > >
> > > Makes me wonder if the device core could call sysfs_update_group()
> > > when binding/unbinding drivers.  But there are only a few existing
> > > callers, and it looks like none of them are for the bind/unbind
> > > situation, so maybe that would be pointless.
> >
> > Also it will be not an easy task to do it in driver/core. Our
> > attributes need to be visible if driver is bound -> we will call to
> > sysfs_update_group() after ->bind() callback. It means that in
> > uwind, we will call to sysfs_update_group() before ->unbind() and
> > the driver will be still bound. So the check is is_supported() for
> > driver exists/or not won't be possible.
>
> Poking around some more, I found .dev_groups, which might be
> applicable?  The test patch below applies to v5.11 and makes the "bh"
> file visible in devices bound to the uhci_hcd driver if the function
> number is odd.

This solution can be applicable for generic drivers where we can afford
to have custom sysfs files for this driver. In our case, we are talking
about hardware device driver. Both RDMA and netdev are against allowing
for such drivers to create their own sysfs. It will be real nightmare to
have different names/layout/output for the same functionality.

This .dev_groups moves responsibility over sysfs to the drivers and it
is no-go for us.

Another problem with this approach is addition of VFs, not only every
driver will start to manage its own sysfs, but it will need to iterate
over PCI bus or internal lists to find VFs, because we want to create
.set_msix_vec on VFs after PF is bound.

So instead of one, controlled place, we will find ourselves with many
genius implementations of the same thing in the drivers.

Bjorn, we really do standard enable/disable flow with out overlay thing.

Thanks

>
> This thread has more details and some samples:
> https://lore.kernel.org/lkml/20190731124349.4474-1-gregkh@linuxfoundation.org/
>
> On qemu, with 00:1a.[012] and 00:1d.[012] set up as uhci_hcd devices:
>
>   root@ubuntu:~# ls /sys/bus/pci/drivers/uhci_hcd
>   0000:00:1a.0  0000:00:1a.2  0000:00:1d.1  bind    new_id     uevent
>   0000:00:1a.1  0000:00:1d.0  0000:00:1d.2  module  remove_id  unbind
>   root@ubuntu:~# grep . /sys/devices/pci0000:00/0000:00:*/bh /dev/null
>   /sys/devices/pci0000:00/0000:00:1a.1/bh:hi bjorn
>   /sys/devices/pci0000:00/0000:00:1d.1/bh:hi bjorn
>
> diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
> index 9b88745d247f..17ea5bf0dab0 100644
> --- a/drivers/usb/host/uhci-pci.c
> +++ b/drivers/usb/host/uhci-pci.c
> @@ -297,6 +297,38 @@ static int uhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	return usb_hcd_pci_probe(dev, id, &uhci_driver);
>  }
>
> +static ssize_t bh_show(struct device *dev, struct device_attribute *attr,
> +			char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "hi bjorn\n");
> +}
> +static DEVICE_ATTR_RO(bh);
> +
> +static umode_t bh_is_visible(struct kobject *kobj, struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	umode_t mode = (PCI_FUNC(pdev->devfn) % 2) ? 0444 : 0;
> +
> +	dev_info(dev, "%s mode %o\n", __func__, mode);
> +	return mode;
> +}
> +
> +static struct attribute *bh_attrs[] = {
> +	&dev_attr_bh.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group bh_group = {
> +	.attrs = bh_attrs,
> +	.is_visible = bh_is_visible,
> +};
> +
> +static const struct attribute_group *bh_groups[] = {
> +	&bh_group,
> +	NULL
> +};
> +
>  static struct pci_driver uhci_pci_driver = {
>  	.name =		hcd_name,
>  	.id_table =	uhci_pci_ids,
> @@ -307,7 +339,8 @@ static struct pci_driver uhci_pci_driver = {
>
>  #ifdef CONFIG_PM
>  	.driver =	{
> -		.pm =	&usb_hcd_pci_pm_ops
> +		.pm =	&usb_hcd_pci_pm_ops,
> +		.dev_groups = bh_groups,
>  	},
>  #endif
>  };
