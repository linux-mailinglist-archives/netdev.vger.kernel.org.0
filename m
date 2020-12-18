Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA6A2DE9F8
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733285AbgLRT7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:59:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732542AbgLRT7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 14:59:17 -0500
Date:   Fri, 18 Dec 2020 11:58:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608321516;
        bh=9ngB505xju7IsMH0G1hSgFXxGJ2q97uYt4vXPItOjzU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3GMhE5Uklef/dvvJrkxTWvSWaLi01HsE3bq34FMywBDFWE4KsZjtCgNtVJUivMVB
         AkCuw2vt3hGM2ZH/DakWo6/IyQ/06yllm0TYef9LZJ6baQNeD/M6eEhb4feMWZiV46
         4KtkRgXIrws+Ige3bc48//rFS/3uv1H4fVbfnVD1DbI0U0FQ4HcNzS2nigxy+sBivQ
         2/qkZKyFVBzyQMp8yUMJaziDJNKaOHE5JaUh7rhsiraXwipSBdozcfVlOfL46v/67u
         Ru6pJ+7oRcb8KJ7+dxoGfD0hXtz/gca8Oog4V1sWwE6cx7Tb7uz64Ok8vPOftzwQks
         wh4pRCHl3vBeA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Message-ID: <20201218115834.0f710e0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322009AFF1E26F8BEF72C72DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
        <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322009AFF1E26F8BEF72C72DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 05:23:10 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Thursday, December 17, 2020 5:42 AM
> > 
> > On Wed, 16 Dec 2020 05:19:15 +0000 Parav Pandit wrote:  
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > Sent: Wednesday, December 16, 2020 6:14 AM
> > > >
> > > > On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:  
> > > > > +static ssize_t sfnum_show(struct device *dev, struct
> > > > > +device_attribute *attr, char *buf) {
> > > > > +	struct auxiliary_device *adev = container_of(dev, struct  
> > > > auxiliary_device, dev);  
> > > > > +	struct mlx5_sf_dev *sf_dev = container_of(adev, struct
> > > > > +mlx5_sf_dev, adev);
> > > > > +
> > > > > +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum); }
> > > > > +static DEVICE_ATTR_RO(sfnum);
> > > > > +
> > > > > +static struct attribute *sf_device_attrs[] = {
> > > > > +	&dev_attr_sfnum.attr,
> > > > > +	NULL,
> > > > > +};
> > > > > +
> > > > > +static const struct attribute_group sf_attr_group = {
> > > > > +	.attrs = sf_device_attrs,
> > > > > +};
> > > > > +
> > > > > +static const struct attribute_group *sf_attr_groups[2] = {
> > > > > +	&sf_attr_group,
> > > > > +	NULL
> > > > > +};  
> > > >
> > > > Why the sysfs attribute? Devlink should be able to report device
> > > > name so there's no need for a tie in from the other end.  
> > > There isn't a need to enforce a devlink instance creation either,  
> > 
> > You mean there isn't a need for the SF to be spawned by devlink?
> >  
> No. sorry for the confusion.
> Let me list down the sequence and plumbing.
> 1. Devlink instance having eswitch spawns the SF port (port add, flavour = pcisf [..]).
> 2. This SF is either for local or external controller. Just like today's VF.
> 3. When SF port is activated (port function set state), SF auxiliary device is spawned on the hosting PF.
> 4. This SF auxiliary device when attached to mlx5_core driver it registers devlink instance (auxiliary/mlx5_core.sf.4).
> 5. When netdev of SF dev is created, it register devlink port of virtual flavour with link to its netdev.
> /sys/class/net/<sf_netdev>/device points to the auxiliary device.
> /sys/class/infiniband/<sf_rdma_dev>/device points to the auxiliary device.
> 
> 6. SF auxiliary device has the sysfs file read by systemd/udev to rename netdev and rdma devices of SF.

Why can't the SF ID match aux dev ID? You only register one aux dev per
SF, right? Or one for RDMA, one for netdev, etc?

> Steps 4,5,6 are equivalent to an existing VF.
