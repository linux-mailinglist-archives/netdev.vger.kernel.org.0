Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6F31E344
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhBQXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:52:55 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18099 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhBQXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 18:52:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602dac2a0000>; Wed, 17 Feb 2021 15:52:10 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 23:52:09 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Feb
 2021 23:52:07 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 17 Feb 2021 23:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeyZ1Wh238bvlISxGV1tlDcQP2yb4A8bi6EJpvOLKXasH1ZToToQPGB5bWdIddTK4DR9LausaOxt2nVRbYPVRCjrnMdoEEYRSx29QBye4zuoYm2WhnneGr8+9yaUc0KDgxsFX5HOhETDOqSze6nBVJDCgORuPTDlROJwhpXNtJpuEBpv4jmNEFMJej2h+f1JDEVnH5I5cAo6k5Z30LChfFDvNCvEGIGe3PhIYovrZGZsUw7ln8Uh4FmtZ52wsoCypE7jndqCC26CunUc1S0LF5INZNDdSh463CqNLvKyT2P36Y72yA6Aj+KfP9Tz0QOmbogYDPDjqvqqWrQ+zHlkzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCpilRsxkTZsacGgYRZV0GUIJUyZamMB4n1nsZX42Ao=;
 b=Wj3bG+1jWu5t+4+wNddC3IXfPfIxmeADR9VAyHGpqLp8HPkVJbCD56OoLyNpxOdbyH60mwm1GmmLQ/PylMrysHuHnj0cU6Y76dVzFjbJ8x4e8kPjPgQJz0d2nL68Qt6w14I30iQKZX452Y4B0WlRLXCLpd0bHV+ghGNivGrkp2aswv3dlL7cEp7eqnSk3raGk1o4UT+7Vh6bXKAabiN6OglRQI/IwiFqPpneL6p5Fv+HvjgjbGZjHYD2W1kR7DkZdBloi4bjhBCAtsOklQoD+/FuQIC+cbWxmCTf32RNpe9mMSnUxrHMCGLDp8n0o1BoZ33lsWJixOLVoJyVSaiKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1756.namprd12.prod.outlook.com (2603:10b6:3:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Wed, 17 Feb
 2021 23:52:04 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Wed, 17 Feb 2021
 23:52:04 +0000
Date:   Wed, 17 Feb 2021 19:52:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210217235201.GX4247@nvidia.com>
References: <20210217192522.GW4247@nvidia.com>
 <20210217202835.GA906388@bjorn-Precision-5520>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210217202835.GA906388@bjorn-Precision-5520>
X-ClientProxiedBy: BL1PR13CA0213.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0213.namprd13.prod.outlook.com (2603:10b6:208:2bf::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Wed, 17 Feb 2021 23:52:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lCWbx-00AEVY-W7; Wed, 17 Feb 2021 19:52:02 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613605930; bh=OCpilRsxkTZsacGgYRZV0GUIJUyZamMB4n1nsZX42Ao=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=aEBMnrrzvuy2nKcZnPFZuPtwtlRs9Jyxsh1lDx1M15p8MkTwXYm9//KH5DtGTfK8E
         de8DDnjZB+yyoUubmr0oqeFdBRwv5GYy6XKWJEB+1qpk2d6UjW64O6p2iV2qxpv9rM
         Tl6n4R7xMfRl+9BXR0zvwh+RML7NbvFQfXTNVuXrSPmI95SaUyQpDTXezIKxJx/keM
         L8yvnI8bMqFZBjVHa4nehoQKGeeNOQzHnEYKLarSwJs48XxXdJvdmGRkBnFdeB5AwE
         Tfbh/Yyw/MkP4Y+RIpnVZvXONOCQokQOdo7j4nqqL036AFtAM1qH1uhkJ0BO4mYumI
         a7rbiL3WiDJHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 02:28:35PM -0600, Bjorn Helgaas wrote:
> On Wed, Feb 17, 2021 at 03:25:22PM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 17, 2021 at 12:02:39PM -0600, Bjorn Helgaas wrote:
> > 
> > > > BTW, I asked more than once how these sysfs knobs should be handled
> > > > in the PCI/core.
> > > 
> > > Thanks for the pointers.  This is the first instance I can think of
> > > where we want to create PCI core sysfs files based on a driver
> > > binding, so there really isn't a precedent.
> > 
> > The MSI stuff does it today, doesn't it? eg:
> > 
> > virtblk_probe (this is a driver bind)
> >   init_vq
> >    virtio_find_vqs
> >     vp_modern_find_vqs
> >      vp_find_vqs
> >       vp_find_vqs_msix
> >        vp_request_msix_vectors
> >         pci_alloc_irq_vectors_affinity
> >          __pci_enable_msi_range
> >           msi_capability_init
> > 	   populate_msi_sysfs
> > 	    	ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
> > 
> > And the sysfs is removed during pci_disable_msi(), also called by the
> > driver
> 
> Yes, you're right, I didn't notice that one.
> 
> I'm not quite convinced that we clean up correctly in all cases --
> pci_disable_msix(), pci_disable_msi(), pci_free_irq_vectors(),
> pcim_release(), etc are called by several drivers, but in my quick
> look I didn't see a guaranteed-to-be-called path to the cleanup during
> driver unbind.  I probably just missed it.
 
I think the contract is the driver has to pair the msi enable with the
msi disable on its own? It is very similar to what is happening here.

Probably there are bugs in drivers on error paths, but there are
always bugs in drivers on error paths..

Jason
