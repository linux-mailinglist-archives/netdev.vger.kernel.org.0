Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE44341E1
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJSXGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:06:48 -0400
Received: from mail-sn1anam02on2074.outbound.protection.outlook.com ([40.107.96.74]:24750
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229498AbhJSXGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 19:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g11he0f2TBDnFpn+0/+ht4jQ+6meyos/j4bfpXGu2jhubVg5vcS0KWTO/5WnwoPWevmkkCLzYE9kW5n3aIMCIjnTIiruFo2n3HdAZ7IUYDRqaIqGSg0tHVZykggf7+ysO/mAoWdRntbdor7U1If2EpsJ/oRoaV28JUEGYzQOHq8+mMQpd3+vnXJ705V/e9+JGdWMf4s6LTUTTtO53fYzs3mcnlrF3R4CasjetIHgvbNXmswTnVC0LnFo/0xzPiE10f8JjDj36z2TCjjLOZDcNdt8pAxiwwZfB2lDFmnAMj9wagdvkTfRr6zdA0i1YG4wSdG0COPx9Lubt5IGeukAGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m82I/mzGce+VJySsIA423DHBKi4DTDphYXAmbeBkcPc=;
 b=PaAK9k4in6alh9fWVewR+lJ1soV4CQ0Sq5GpYnl968ke+++8IVa28idmlz81vq+iw8o7TW6uxxV00aAUQUjKsid7wYq39F9txHYGXD4rQtkuTt1wTiyfSwEmW7wwdkRfvWTB2Qjjxun0Ff7jqJLX2OkJgwCpu0x2gvgR5rnT+Clfsllg7lRo+Pgawp7wHPkjnpTYMRALYB0SmNcZ9Gm4zi8yhD5qOs0W64BjlYnET9tN+qg4avboow2UMuCHdtNO7XPcoOOA1Euyk8y9MeKLYfGFUt5uwl3sonNGDKpehXhXddOa9qHf03ixDQavpTnXLBSL1PyBkQ6lKEgegpC+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m82I/mzGce+VJySsIA423DHBKi4DTDphYXAmbeBkcPc=;
 b=n+23Qy4LiPGEymx4DkWQ87PPMolPLR7TgCiaEkgT9Q8Ed3p+5f970zTNCEtb8jfA9ReoeWBfm7vXIbh0dHz3/AJBLktzR1dprRYKrqFvycjrRxsNTgeCw+P8GWt95dv2iX3iemYrAWfAa049os/QHJNV6urS+a7HJNNjv5hMEI2jG/zAIcU5DhsNk5r39MlUoafIgeNFfjLsoFZVqWl18Xfa+uDVP3lgvVajIPjGpfEFjCN0KcPjQm771AArjlyQqHmlp1bk8XXO2ZWwfMrIfyyhOIKBAHvcV09wCL6ijr01CNOuwFZp+Z+WHe0+1QKwZWVBQ046kuVBwpLaXKxA0g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 19 Oct
 2021 23:04:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 23:04:32 +0000
Date:   Tue, 19 Oct 2021 20:04:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211019230431.GA2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0093.namprd13.prod.outlook.com (2603:10b6:208:2b9::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 23:04:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcy9n-00H93F-SO; Tue, 19 Oct 2021 20:04:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63a30c9a-06c2-4dcb-b5a8-08d99354cffe
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53046C96FBF42A17AACB19C8C2BD9@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deomxttXiDUW8AuSFMpKG2dXiYBvA5GG93evhYVDBqjE8as4QQ8v5yj/vQlp92nn8nE4UvfgODHBeLP4CJ7yxHmSaNY2SBbfrLCYF6YelgcBtBr6VyWWWPO1sTiHQ+va7mgDskxcvVUvY4V4JuIJALD7IrrUnYLhnY3nmvNOyNJu9CmSvPYz01R9VmruNlGW5Hdb6uGPtw2Y+T2f4tIHu4m5aIPxUHP2+bPiD4dFXHWY01HB59/6jX7DL4t49zlmNT159KOVAdZhwUR4XMRzADSjtRtpHv0s9igWPycU9tEH3Lx0N+1guPXv2ny/LjGF3sSZzcV3NAfGYs7XM+9FZrH3NpVjbd4VxXE9fGssRxaLN/erKhJDxx7RzG26hL4D7dEg3/5p3cVSUObWsTWrMSZKs5aPrJCd2TVCIrRPhX3Zolk3C107kwlHNQGjaudjXaO+w0meguecBY5IsCkMGeBJmiWrHGHTI5fLwf8kZ+CAhWFzTK+1i+2U82kIXBJglMOGt4j8VUyUEhddjeaFahwXrKz1AhOTgl0O5bGOiWiEFb8SOjJJwEvERpPYr8HWaEK0tDwAIqjV6sC9Mo0UBushtqI6vTjzvQk5d21NYk8Dyb0PczGCHDt1tEpiabrQr5T9aDLgQArgncEuy9Sy2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66476007)(38100700002)(33656002)(426003)(2616005)(186003)(86362001)(66556008)(5660300002)(8936002)(316002)(66946007)(36756003)(9786002)(8676002)(9746002)(4326008)(83380400001)(107886003)(26005)(1076003)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1j27q0K3pHVIWu5+q26i2sZvt8j/gbmpukArC6Zw54YzorZMi8POOtKyz1yA?=
 =?us-ascii?Q?CWbMVMRG+/usN7o/123hPXCTKblJqqUAN8LPy51PM2OR2mZx1/Q+FOfHsRBU?=
 =?us-ascii?Q?nyS8tIUkEvnuHB5xDzVyK4PVsWIRQXj1xb4YDPXVuERVd8p7c7vHTm2KcPRl?=
 =?us-ascii?Q?vsc2fy7iFTBFUQDloLXhS5Fi/GQG6CjSi7jwgIJgeMTfET0p7L5c2nag3+OE?=
 =?us-ascii?Q?+BTmUtjc83cDs7BET7b7ZHQhtr/b7tcVsyq95nH35r3KqaEjpErQC53623CD?=
 =?us-ascii?Q?HwOZW/IbXrfFpNSLjbjCA5h4AalAMkk2AcBN0DDX2b1tpiANx39+WdUEJvNK?=
 =?us-ascii?Q?JK8Vswx5FZd9sTzSG20H2UwFoVhyllMxjUtoo4+S6NUoYOpTMQGKutwCby/3?=
 =?us-ascii?Q?lNx2PN8eJod2cMsCPajD3KSFPR0Fo+tiHegGif5GI6yBMlzWW/VSRsnCB4N2?=
 =?us-ascii?Q?UqXI4x0MCVe0e/f+XJwBoCh3bUqc+Nq8jdBshmTGn0GgEZQI9A14+Ct5iBaO?=
 =?us-ascii?Q?asJ05RN5i/BmZsHWJR6KJS32pDCg6yvqn7OHcSGU9V2rrBGIHSNw2dboVETU?=
 =?us-ascii?Q?/OcI4V1Y6C0+JYIfG7DGJ94Hx8p1r/t/Ezwj8P77yYkltGDk7gfPHrhjJw2t?=
 =?us-ascii?Q?wGbjW8aPZJz0J8YuLmaJ2bHp5iEdbtR6MBHGL7RAuB9DylM7ps9Tk3hXRDp4?=
 =?us-ascii?Q?yixvIfBJ7MC8JP/CttbWHRZFWUmQdN1QY5mdZI1WlncXqraBPTl3+mZFJq/Z?=
 =?us-ascii?Q?p1cv4e5gtOFuX7rANZxz0/yzXABhyDZKD97AkaTayz1BL8XUShJtkRBQK5dP?=
 =?us-ascii?Q?HFPqP0K3yugKjNePr8VAA1OSA+rYOxP8sr2hsr4oOwuiqxoYgI8lWO6q+PL9?=
 =?us-ascii?Q?lwKNf3y/aUyxPsq21lzd6OrmTJbQe0Hvxsu7iO2hxzqwZUzw4aFQP1PzSkU1?=
 =?us-ascii?Q?Uweorur0n9xhlk8GqNVEdhkJHa1lMB3FbTXmvCdC2s2I6LFlQBACDvAgraFX?=
 =?us-ascii?Q?iRAIQOWHA7B/m2sHZproN/r1rOrkGnvTU3a3kCf5DQnpY4gMy/JWe/EPMLXG?=
 =?us-ascii?Q?lyLZeWh1vtz/HZ06I4/4tWDW7MQabVc50V7goZAvOtdQVU3QbH5qs0EBMk5p?=
 =?us-ascii?Q?uJrAadvYVmNdfnLPqosgPJUobWDT4y5kcxhcTIqQYKQT3hqHV4WrtfPmGY4x?=
 =?us-ascii?Q?nkou2+ht86/auuloDtwM5mTYoH0P1EhLdK9coZZtuHxNk1iCnymOkd2GiH6a?=
 =?us-ascii?Q?ssRpM101nOoFZrrOOcWiHeHBjeIbKFRsLWJBbQPDgH2BWgfOhAHED0taRbfG?=
 =?us-ascii?Q?dfCSy6Asf6xcnMqw5H0LRnGt/HL915raVwtS42Ble4lRdKoeHuhYTxuMCjb6?=
 =?us-ascii?Q?jJ7dp4wdfZeWUp9qM86d/R2XAFa8erbXTOSQAAF8FnAoK2kzyLMeIQlrxWcN?=
 =?us-ascii?Q?sbxzm5EOaeI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a30c9a-06c2-4dcb-b5a8-08d99354cffe
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 23:04:32.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote:
> I think that gives us this table:
> 
> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> +----------+----------+----------+----------+ ---
> |     X    |     0    |     0    |     0    |  ^
> +----------+----------+----------+----------+  |
> |     0    |     0    |     0    |     1    |  |
> +----------+----------+----------+----------+  |
> |     X    |     0    |     1    |     0    |
> +----------+----------+----------+----------+  NDMA value is either compatible
> |     0    |     0    |     1    |     1    |  to existing behavior or don't
> +----------+----------+----------+----------+  care due to redundancy vs
> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/ERROR
> +----------+----------+----------+----------+
> |     X    |     1    |     0    |     1    |  |
> +----------+----------+----------+----------+  |
> |     X    |     1    |     1    |     0    |  |
> +----------+----------+----------+----------+  |
> |     X    |     1    |     1    |     1    |  v
> +----------+----------+----------+----------+ ---
> |     1    |     0    |     0    |     1    |  ^
> +----------+----------+----------+----------+  Desired new useful cases
> |     1    |     0    |     1    |     1    |  v
> +----------+----------+----------+----------+ ---
> 
> Specifically, rows 1, 3, 5 with NDMA = 1 are valid states a user can
> set which are simply redundant to the NDMA = 0 cases.  

It seems right

> Row 6 remains invalid due to lack of support for pre-copy (_RESUMING
> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
> are error states and cannot be set by userspace.

I wonder, did Yishai's series capture this row 6 restriction? Yishai?

> Like other bits, setting the bit should be effective at the completion
> of writing device state.  Therefore the device would need to flush any
> outbound DMA queues before returning.

Yes, the device commands are expected to achieve this.

> The question I was really trying to get to though is whether we have a
> supportable interface without such an extension.  There's currently
> only an experimental version of vfio migration support for PCI devices
> in QEMU (afaik), 

If I recall this only matters if you have a VM that is causing
migratable devices to interact with each other. So long as the devices
are only interacting with the CPU this extra step is not strictly
needed.

So, single device cases can be fine as-is

IMHO the multi-device case the VMM should probably demand this support
from the migration drivers, otherwise it cannot know if it is safe for
sure.

A config option to override the block if the admin knows there is no
use case to cause devices to interact - eg two NVMe devices without
CMB do not have a useful interaction.

> so it seems like we could make use of the bus-master bit to fill
> this gap in QEMU currently, before we claim non-experimental
> support, but this new device agnostic extension would be required
> for non-PCI device support (and PCI support should adopt it as
> available).  Does that sound right?  Thanks,

I don't think the bus master support is really a substitute, tripping
bus master will stop DMA but it will not do so in a clean way and is
likely to be non-transparent to the VM's driver.

The single-device-assigned case is a cleaner restriction, IMHO.

Alternatively we can add the 4th bit and insist that migration drivers
support all the states. I'm just unsure what other HW can do, I get
the feeling people have been designing to the migration description in
the header file for a while and this is a new idea.

Jason
