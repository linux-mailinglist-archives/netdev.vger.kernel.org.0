Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131BF43BE0C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbhJZXp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:45:29 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:33857
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234592AbhJZXp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:45:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMowE56XUwATUpvClx2Ehmz9KEGBwqvE59X16ZEGFUgUC5Op2McSlFAUK/5JSr/wd7ull3eZqEt5ef+i7VWMbqdN9wRLvbuVeCstmV2w60AraBjjyLGorK8HZkhiqmBFQvT8R/6/2iAhfgitaandXKgeBgE739jd8WD1snzy5Jdu7M/Dnhwvx5Fjp050PDdes8EZOJGkLFeJm2U2+3JRxpN5FnIlZeJXKQ+d3NKkJjcfi+jSd9PCMDSsO3IEvBjjhTRxBXnvyB2oXNz82kYyouU82yda9M8y3VGd0k6sEia2VonskMeD8vxoycr731fAOYdEru6WVZXtLb8Z75rk7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzBm/8skyBx8tZ1pw3mD2dxjTgjNAFlb0792iTG6PKk=;
 b=SHAIxIva1kJixR99OLOb3iSOzC4gFLZR2IELNyiNFplY3bLmCYTA2qQBsnldz3+8KytFlknOut5ezCb0jb6YJW5+ZOyf+VerTDdVSL/YQMVwhzfIUUWTCVPfJ7i0k5s7ikkYV9XI8M9KGf3sZLRAXrb9mui8MMlZ6t6qare2QkCuAFFtwjTgoNASsWmQPlpHvNi+MjsBFAZFTY12vyTVdit1DU4SwMW9RmK3F75LudR3x4LgveIDmtxiVcze0JRp4VKr4FeKZpCwnmCCtYPBdDD218cabv3C/B+zdgb6fkSA3GDEhzk8HJEGha6X4dNitBwnCXpTUDs/mVB3M4EnfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzBm/8skyBx8tZ1pw3mD2dxjTgjNAFlb0792iTG6PKk=;
 b=HkGJbexWzdkwHfZC3jDhMPnI+6WuNAmNZlj5a82eTUCc/mzNZcYdqjYUH6la8sZ8SUop6FfNMaCQs5AnG3m/KexjYLw5FDmNPq/NWRB3pImtpDGtMBo4PleyEUoREBzFlAs1RXjDh9gmd4t5rKlPSkvI07iNe8HiQmEZp5SId33MV+WDyU2MTHtWq/0eVa6vrqTiz9xYDGGUbaypHdoPdFW3hQnoZncpblEj5HlpStQ8GCsvAGt375/Doz1gIb+h6twTjCwkgnR/MPC89EuE4jj5ZR4O235r1HbPT7DJ/qts3pwrgSGKaFA4C8c8hmTAU/HJx1rYKuhT3JwZWOCqGQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 23:43:02 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 23:43:02 +0000
Date:   Tue, 26 Oct 2021 20:43:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026234300.GA2744544@nvidia.com>
References: <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026135046.5190e103.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR03CA0445.namprd03.prod.outlook.com
 (2603:10b6:610:10e::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0445.namprd03.prod.outlook.com (2603:10b6:610:10e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 23:43:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfW5s-002EpJ-4s; Tue, 26 Oct 2021 20:43:00 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f6c9fc5-62d8-4ee6-fe20-08d998da5940
X-MS-TrafficTypeDiagnostic: BL0PR12MB5508:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55082557DAC2DF0097052045C2849@BL0PR12MB5508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HADTDb0mCTnh3kyf04gA/Et0aStw78F+Lntd+jJKBazNzQqgYlVfL138bHBM4iewGqhtvXYb18rvCjBzYYMYFOZ0QGP4LHIAK2xaKcbChwdc04a2FbLI42L/K5lqq3pMkmoXnLPEbLzCqghOYnsntX3fOxJhSo0mgKaBGEmll+8IcBpSA8OeTy5KOl+wsRqtoO+bQV5Qjm1Wo4U4zcY8S5bVUZNOVNBU5KqkIsorr9a6qwsKsieheptjy+V+vje/X3udCNAnBIO+e5gAEjeoNlV0gHktumEBJ2itCrCwx+VrN4hw4yBKWrCXZY7wX7CaqokWG+0r8JC7XUQRZEFb3LB0/2o72KHAmC1Er2p7QMBxapoYkqxYlb6ziwEyDULllU9lkKkbOUsvahzmxNww/CFjbrsdQLvps1SRhqNjbsJ6D2p91EiNAvRoR/x75YU/YDG/LFI8+BDFOWLL/WxDg87Ga63LzX2KLNDJbltRBrUJgotnRGZPiUW6KYsFR3lM4lX6MHqEADa6MrNM+L+w4fi8UGP9y/6Xd6WwOPops149lS1uyhv7/0op0kBTEyTXCmhnt60rylqh4fXEz9hQCKQs5C0Z28hnjBT55xT+MzhufG752TML/sKW7EI5IT1n3UXE+ycDH5kKfd4s/G3DHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(316002)(54906003)(2906002)(36756003)(9746002)(508600001)(426003)(66556008)(8676002)(83380400001)(1076003)(33656002)(8936002)(86362001)(26005)(5660300002)(6916009)(186003)(38100700002)(66946007)(4326008)(66476007)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKExXvyV8T+CNKLIVy/hFoKJ0LRvO0rFMxY+8HbxCMXh/wR3ki1PQKx7dWoX?=
 =?us-ascii?Q?WyBkR62asoyuvZsScEmDpY5KCwlx0LtTf7yfJ3b0V6XElGIGxGAiqipYlfqH?=
 =?us-ascii?Q?MtxfEA+11ERU6ubO14yVSHZ01kIjmo8s8CDCMAEKIRpp1ZWfmOORV1qIGttk?=
 =?us-ascii?Q?/Y8IO5Izpeu0lDIKKN0AqoDEVV3F4/QL1zfxFNBu1kYJA40sRAl9vBYfXQ0d?=
 =?us-ascii?Q?4c2RfJv9EJtBBofPJLK2L0bX7uJjYmh5hxQw/qLutPoKfM0QX/YsnxO84Rib?=
 =?us-ascii?Q?zvelyn3PcZV6UPdrQ8PwzF5Abpw5boJHpepDT1TjFWIHi8805FuLY9ZTVEsq?=
 =?us-ascii?Q?tsx48NszxLlaG8nrhkwquBanxAP6Qv5rmI69OVThD3z8rUh00zFYvyZbJl1j?=
 =?us-ascii?Q?8UUptCf7VTY0PZag8AcmrY6S/JpWUCMSDPUqfscZ2fZPjIp72es309GBaGPZ?=
 =?us-ascii?Q?uy6jwobEbfXmCll/IGTMs0J2pqJpQDfm98J5ayxjOsjKwZtJTsD2VUSh0KPE?=
 =?us-ascii?Q?1rtVIL/3D9d1dvbPy6Oe7orDukhx90dG1H/nQqutJ/DgTXvFvttSboaNGbgh?=
 =?us-ascii?Q?5tLNXBk7eiJEw+WPuiwLznNohJf9r3UqghSHWPr5ttJJgynXjL6h8lIF63rz?=
 =?us-ascii?Q?Dj4G8FIyLtdfOjEF/ElQJQgipY+kYctBYanSNmBVgYczDmMc/PEOeHT/nwu1?=
 =?us-ascii?Q?7tWIslkuzidLJ9Ma59Nz1XJMHztZs7Q2Oxo8Ex7Y7GTBqo28pijN802uyETh?=
 =?us-ascii?Q?jJ7/PGpI4XxoKpsTAuRFr8juigVL/MWOKMnw6yFLF8qRVHFWdtDakWskl8u0?=
 =?us-ascii?Q?1WfoXV9Vy6bq+sgVTqtPWA2MtQMDxLCnSVdpr4f1+PosRHlDANtXFS0ys5f9?=
 =?us-ascii?Q?e5NJ1QMxNbiw6horgqfG+aegS6p3USW05nfblhIp1z1k+iH42lL/72zuBdr9?=
 =?us-ascii?Q?y/pfPS2UeHw4dHn02QgCKI5KtL4+wfHuyu4oQRh/8r/XyOof7B0On3ZQnwAP?=
 =?us-ascii?Q?ShL5etr+BaBTOeigntFxrMEQvd6EthXYs2eTCvXtRwZQxB7EkOik0Pq+RihA?=
 =?us-ascii?Q?hCE9B5vwmam5TFADYuydOPw10Yf6NP0uB+oXhNl2kAydViClqkaY88Tbc6FU?=
 =?us-ascii?Q?lU7SVE5lsStEXqXy94yyAVmITeQUjOiVQ+w5xLXmncRWwuDh/kJfcG2l+z/x?=
 =?us-ascii?Q?AI0tHDFxoT6bmPKBZm3wcZlkguL6fEOv8wGaADlHejk7JnLUo37c3KdxcUit?=
 =?us-ascii?Q?ZioF8f4pbiMj6hCwlrVe4we9auKHR6QQnH4j2vw9ZwhED2nvaJQznv2kjM/u?=
 =?us-ascii?Q?8yZuRsDUzdCl8gjuTwgCUkhbSoGgl5eDnT+brm/bOaJfZsZyIv888nItZlSS?=
 =?us-ascii?Q?zHUroQs2UUO840IhNKQTGKsjexc1eGVyiBiW6AT0HgYkAeSbVSVWM6CQPN2n?=
 =?us-ascii?Q?uhbao18nCbAEx/5pttlEQbildCjGieIjlZBFqp49BxLPG5EEpnYNp7o4CgE+?=
 =?us-ascii?Q?n5e6p/0V1xriU95biqiITaG42qbhwtuHyXl0hsMj01/Fnat1RBDs7XXZw7p0?=
 =?us-ascii?Q?zRWXhZdraiNIZPrSwD8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6c9fc5-62d8-4ee6-fe20-08d998da5940
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 23:43:01.9062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3apyBOCjCzBOXWcHTD6J3MnIuYz1EbgaX7QFVX0rC+S1AusoQr+2e3/aMOJem/E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 01:50:46PM -0600, Alex Williamson wrote:
> On Tue, 26 Oct 2021 12:18:51 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> > 
> > > > This is also why I don't like it being so transparent as it is
> > > > something userspace needs to care about - especially if the HW cannot
> > > > support such a thing, if we intend to allow that.  
> > > 
> > > Userspace does need to care, but userspace's concern over this should
> > > not be able to compromise the platform and therefore making VF
> > > assignment more susceptible to fatal error conditions to comply with a
> > > migration uAPI is troublesome for me.  
> > 
> > It is an interesting scenario.
> > 
> > I think it points that we are not implementing this fully properly.
> > 
> > The !RUNNING state should be like your reset efforts.
> > 
> > All access to the MMIO memories from userspace should be revoked
> > during !RUNNING
> > 
> > All VMAs zap'd.
> > 
> > All IOMMU peer mappings invalidated.
> > 
> > The kernel should directly block userspace from causing a MMIO TLP
> > before the device driver goes to !RUNNING.
> > 
> > Then the question of what the device does at this edge is not
> > relevant as hostile userspace cannot trigger it.
> > 
> > The logical way to implement this is to key off running and
> > block/unblock MMIO access when !RUNNING.
> > 
> > To me this strongly suggests that the extra bit is the correct way
> > forward as the driver is much simpler to implement and understand if
> > RUNNING directly controls the availability of MMIO instead of having
> > an irregular case where !RUNNING still allows MMIO but only until a
> > pending_bytes read.
> > 
> > Given the complexity of this can we move ahead with the current
> > mlx5_vfio and Yishai&co can come with some followup proposal to split
> > the freeze/queice and block MMIO?
> 
> I know how much we want this driver in, but I'm surprised that you're
> advocating to cut-and-run with an implementation where we've identified
> a potentially significant gap with some hand waving that we'll resolve
> it later.

I don't view it as cut and run, but making reasonable quanta of
progress with patch series of reviewable size and scope.

At a certain point we need to get the base level of functionality,
that matches the currently defined ABI merged so we can talk about
where the ABI needs to go.

If you are uncomfortable about this from a uABI stability perspective
then mark the driver EXPERIMENTAL and do not merge any other migration
drivers until the two details are fully sorted out.

As far as the actual issue, if you hadn't just discovered it now
nobody would have known we have this gap - much like how the very
similar reset issue was present in VFIO for so many years until you
plugged it.

> Deciding at some point in the future to forcefully block device MMIO
> access from userspace when the device stops running is clearly a user
> visible change and therefore subject to the don't-break-userspace
> clause.  

I don't think so, this was done for reset retroactively after
all. Well behaved qmeu should have silenced all MMIO touches as part
of the ABI contract anyhow.

The "don't-break-userspace" is not an absolute prohibition, Linus has
been very clear this limitation is about direct, ideally demonstrable,
breakage to actually deployed software.

> That might also indicate that "freeze" is only an implementation
> specific requirement.  Thanks,

It doesn't matter if a theoretical device can exist that doesn't need
"freeze" - this device does, and so it is the lowest common
denominator for the uAPI contract and userspace must abide by the
restriction.

Further, I can think of no utility to exposing some non-freeze route
as an optional feature. If someone has a scenario where this is useful
they should come with a uAPI design and feature bit to describe how it
works and what it does. This driver will probably not ever set that
feature.

Jason
