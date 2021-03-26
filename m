Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3734ACEF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCZQ4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:56:34 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:47712
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230363AbhCZQ4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 12:56:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSAkJwqgd65buw1f8T60Fx53ygLpx6llseI6yyf+iNnynNEpS/+HJ/NrodswYPlsQcHpEldC8jOcLBHSBdhOMsvGhxvva2DHyFsa2fWFUIA5+Z4Vhb30TjJL7Qt/ClRlKLc/uE34UqO7s9g7hGyfH5+91RamKctrfu2ls3yIWZO4iy0TueUoklb7A+cuv3BaF1vtHSH93SyJmpZAb+meLusLr2K71cEe0ayLrKFQ+4eQ0LZHD61/VsDD5eZFw8sFktUnjdA2w7u1Lq1LK97K+R/LHI+hcJomcSt5DJS3V2wNupv9aUkh8mYWDbz09qdaAl7OOShMBDcp/buF1o3bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e+fzLhrIfaHaYmaZT4a5tP7lxyNmilppEo+NB56Opg=;
 b=RES2k2v0d18xtR1ekijhkCw39vDTUyaYiMtBXHHD4dq7H3p48RjchPhXNTIoSgIapL1Zsz1BtfpeqMMavzrRNlvlHJIiKZNoqJdajbTABSYz+eOCULn9t42isduGxJ7TolHL07utsDXd1ExyU29+bPwDylnWrOUEjEM8QqshTgW15Zl/ahqqf/G4u5uhuU5nev+RnSFyy/NlxoPDMZ6UZxhTIkhtNKlOue3Asu98CSR9WzfGKpXjzu+05gHzD6/odVg+UbWtW151GXI/PMcGOTHf0OVbUOB/MME4IfLtv3sBr87ZnIUhpORGSjw8ufa4nIrehXQlMGE/T3xR1MQFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e+fzLhrIfaHaYmaZT4a5tP7lxyNmilppEo+NB56Opg=;
 b=Pk/YPcjD8VY8z74dLh0MTXAbIxt1wuOC821ModYB+mArbLJEcZY9w6bOrCBbAulCSXpg3Y7vlbH6nZsk/aWxy5qD/hfpVK4p7G1qILYGlsZH5JI1O6d6OX1i7Sm2AxH/Iw40IxOt/em9qaZ5AP0tU+SQ6N3y7Z7UzsHFffoyUe2KC6ik1WuagpfLuCqPwPs0GCgXrsck0IKt9HSfgzCbTV+Lvuaf6Vso/eyGupKc5t+jKEXHUeDmvnYeOE41IBpt8N0q5MhZppFt+D9HAIQj/HkSlTbT6sLvnTLeHDHBSfs9ukwU9Eak0UkqA6wJQpnHSRjd8esUpc4kX4B1KLA58Q==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3739.namprd12.prod.outlook.com (2603:10b6:5:1c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 16:56:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 16:56:14 +0000
Date:   Fri, 26 Mar 2021 13:56:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210326165612.GO2356281@nvidia.com>
References: <20210325173646.GG2356281@nvidia.com>
 <20210325182021.GA795636@bjorn-Precision-5520>
 <20210325182836.GJ2356281@nvidia.com>
 <YF2CtFmOxL6Noi96@unreal>
 <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:208:237::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0046.namprd15.prod.outlook.com (2603:10b6:208:237::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Fri, 26 Mar 2021 16:56:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPpkq-003bYx-OW; Fri, 26 Mar 2021 13:56:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41a8d7ad-877c-4038-ed5e-08d8f07810b9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739E23B3199F539D31178DAC2619@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6HXiUnn9mxcITPTxOyvHJyB5mWOEzLITRtn14BHMS+khKrn7hz7DbL0yON6CfmRWK/r6vaq56Th9tmkI4L8vOc0vapVV3gC/HUJtb3fWXL5GsL8D9NchJISNvEJRcaSyeiDZgzLySCh1RKugiDWMFLs/fWAfWVnTEKLpoP83W+hXATiOgnpYxyn/lDClBXCQiUt8POv/t48PgE8mftoHqbur4L605BFst9fOExnahJSiPAOJaairYGfksR1ovX7znfdC0Zthm8rRmhYVvkXudxGBs+h5I18AoKybklgAkTjCF73sIaHhx1GqBerLKvCPEYn+eOe/GoCmRLAnzjI4azaY/UNHXmMTRlZGNZjtZJuMeZT9tzNgmJ9E4uEWT2carAPPz7Eip/01+sRW5QKyr1WpubWm33XgJTTCgLUbxunmOga4j7tKHsVODeIOwnOiKeAjZ5e9BFQEjoT7tshhGIfO7EnigWiRhQ+KnywP0ts1TgN4nW7IsP1aoZO4SJbWjLUfhwxEv6V0/Qe5YO+NLZhTu6YcFETj280ulqojbr4ZHJiyzd0YT4Akz6rtQtYIlMn9o0KNlOxbdpddUBpCjnJKxZqBDHM6F6VQZoh6vnwzphv5H+usKfzw9oWf/3pscOmBWi80tXCmN0oyi6KNlLIZwwlFeiYj2sFie4JUes=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(53546011)(7416002)(2616005)(5660300002)(4326008)(54906003)(36756003)(66946007)(26005)(6916009)(426003)(186003)(478600001)(38100700001)(8676002)(66476007)(66556008)(33656002)(1076003)(8936002)(2906002)(316002)(86362001)(9786002)(9746002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Yxqo9EWOVsB8UGb+AJKSHQYIb/v3NvaM2GUukm9+Q/I75pyzxWIIJolVEALf?=
 =?us-ascii?Q?NNV+z0dsocW9b+Fc0dZwQnfMUD0+fhZVd/6XBamvABvwBficqZW2PhXNCRMn?=
 =?us-ascii?Q?04hf3B89w0WV5nwU/Bew2zij6a3jQG47CkfWEPyzGTRYEXdM1j645T7h8zFW?=
 =?us-ascii?Q?YfjLnqTgqCwL04FtgoKW3sBPDyhr1e35VSiHexcQAhJu2t3SCselAmF4KbAZ?=
 =?us-ascii?Q?sP34dT5GIASGlk74qi2oAZk9/NkmslB2GUOXKVRna/UK7EJP8OfznTvLLkIM?=
 =?us-ascii?Q?pD4ZNuTAEV0yw6pIhTpuCOlxykAqjqQykvzhAlcLQPTLQWeEhwMeL2tk0KM8?=
 =?us-ascii?Q?kdQt3ahUCOT/HOeRtwMn1cG7aXZoTx0GtEAjddRJ6dbspxoJz9vJItxAqON/?=
 =?us-ascii?Q?zEPe2ybUIFNkDavdDDH+hSH0Fu8o3S9PqRCk5PrOBUnV7pgpaka59/FtXd49?=
 =?us-ascii?Q?KmDxb4O5/uNQHrQL3/hZEfQuMfd4qAwYFe9VAv1YNa4qmeQKfbXeuLousCNX?=
 =?us-ascii?Q?XOYrZ9bn5M3Eq7X2bxMZ7d43oSRbf+nLA7RDq4BBAnmVeOR1n0oXV8RyOfBw?=
 =?us-ascii?Q?WIABRGElr+ZW9LFOtfGnFu+iSjO8J2MT3Eh7YXllVDDgqpL/h+GfsJt95qLW?=
 =?us-ascii?Q?b2tIbnHUJWs7VQGGbfPcvIBhjEzN4T3Ip2f+SK0ypNHppHf6GBBZRqTB3Pfk?=
 =?us-ascii?Q?gUXnTcxnRdNmKzEtKOlPSCTDeC7Wx+APN5f1CSvLkDnqT7C+aiF2SLmyNBNh?=
 =?us-ascii?Q?xCGNbxmydWHN1HURXX07Lz189Jv+BQijtg2ozZ0PO43SMNbak50QO8flx81d?=
 =?us-ascii?Q?lYwljHptrpC/8ZQ8Of1ULnFQxDIDjMOcN87GP6wSJOYXpsxK3madAOLTWokW?=
 =?us-ascii?Q?sAi8b4C3ntmoY0CY6656aMKSuDvNPc0X//iW1j9n+BWxzZcTY4hOVa0yaQEN?=
 =?us-ascii?Q?KsXS5u21BHXe/tZ72wgMgE0Lgqu7koWlFCzC2XBT+8Gyaod8G3i0GwqbY0RZ?=
 =?us-ascii?Q?PS8eUc3yYfx+AEOFGYx9qMY317UsNvsFWY/fjlIJqWSBpTd8cjUnv8laffh7?=
 =?us-ascii?Q?gTqatqUpkT+vMh3HPtu5Blr+fLWeOI5qEGifKw8DaNFeJqxNbm2JaMjY9Ek0?=
 =?us-ascii?Q?ZKOF00jCAg/oyGLujfl18xzEGMlVwMVbRsm04z3g4QfCs2DULhOrNRzl2AGp?=
 =?us-ascii?Q?vKuLGWyaq+5An9Si4x8fbQ0VZDoKkGXFcOm57YOAmRRkgIo/xsC0twbzPBUi?=
 =?us-ascii?Q?fEFF2LYNgkJeJSKim/pq1Daq5ywE1ug4YvgnyPHrQsOjpZOXKoLsziVeUVDo?=
 =?us-ascii?Q?iiv740IOeVaJW5EUtuC6r0WYTWc/3F2AO+uBgRMzUvT7Tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a8d7ad-877c-4038-ed5e-08d8f07810b9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 16:56:14.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dZoddN67RdC9gvQq5eQL/MKJpK4QImVpGtVmxrqs45xh6IShkmS3TyaPMehemul
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 09:00:50AM -0700, Alexander Duyck wrote:
> On Thu, Mar 25, 2021 at 11:44 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Mar 25, 2021 at 03:28:36PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> > > > On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > > > >
> > > > > > NVMe and mlx5 have basically identical functionality in this respect.
> > > > > > Other devices and vendors will likely implement similar functionality.
> > > > > > It would be ideal if we had an interface generic enough to support
> > > > > > them all.
> > > > > >
> > > > > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > > > > model?  I think it's close, but not quite, because the the NVMe
> > > > > > "offline" state isn't explicitly visible in the mlx5 model.
> > > > >
> > > > > I thought Keith basically said "offline" wasn't really useful as a
> > > > > distinct idea. It is an artifact of nvme being a standards body
> > > > > divorced from the operating system.
> > > > >
> > > > > In linux offline and no driver attached are the same thing, you'd
> > > > > never want an API to make a nvme device with a driver attached offline
> > > > > because it would break the driver.
> > > >
> > > > I think the sticky part is that Linux driver attach is not visible to
> > > > the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> > > > can only assign resources to a VF when the VF is offline, and the VF
> > > > is only usable when it is online.
> > > >
> > > > For NVMe, software must ask the PF to make those online/offline
> > > > transitions via Secondary Controller Offline and Secondary Controller
> > > > Online commands [1].  How would this be integrated into this sysfs
> > > > interface?
> > >
> > > Either the NVMe PF driver tracks the driver attach state using a bus
> > > notifier and mirrors it to the offline state, or it simply
> > > offline/onlines as part of the sequence to program the MSI change.
> > >
> > > I don't see why we need any additional modeling of this behavior.
> > >
> > > What would be the point of onlining a device without a driver?
> >
> > Agree, we should remember that we are talking about Linux kernel model
> > and implementation, where _no_driver_ means _offline_.
> 
> The only means you have of guaranteeing the driver is "offline" is by
> holding on the device lock and checking it. So it is only really
> useful for one operation and then you have to release the lock. The
> idea behind having an "offline" state would be to allow you to
> aggregate multiple potential operations into a single change.

What we really want is a solution where the SRIOV device exist for the
HW but isn't registered yet as a pci_device. We have endless problems
with needing to configure SRIOV instances at the PF before they get
plugged into the kernel and the no driver autoprobe buisness is such a
hack.

But that is a huge problem and not this series.

Jason
