Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2A7337FD5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 22:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhCKVof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 16:44:35 -0500
Received: from mail-bn8nam08on2044.outbound.protection.outlook.com ([40.107.100.44]:10337
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230386AbhCKVo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 16:44:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs+ZltW8oRK8iJ8LOm0OJeMefDbR+S8x2XBl/VkVvNJIalnI1+TUSIkDmLjFx4fRMYnvR5fBkALiLDa+rxONSckMGXa/dvHtaOM5SVPh7ubspoYnW8N/5GCftQUhp/R8L0sba5aLCMDDpmh+qs402Nb8FMipy5utjSj71AtJAECSUZ9QlwI5Njn99nPvjrO/B/qACDdVw2sMqWMAqendr5VVWB3UEpCv/nPewt7Sx92p7Gd3iTNJjJZvyuaYqaJOL09W4P6gvFkRMflQ5NDNYxDH3yxTcLOD/Xp55lbEFl+exNJ6N9rRBnTRrpERT9/mMNB0L3j599GCfnkrXAjGFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqBP+49LVLKMznFvrI3FNUgTGYtqTgbrH6dNYIaWO0s=;
 b=Lnne4Ij+Fqe0gfUt5ZMn+T0tsc4fxeHnH3WVcXDBjMZU9mdQgByW6TTZR2bdh44JQXOd5QzH0s46lIebLXKp6TL5V1JXSAdTLbBAjR6g8aK4DpvZE0EaT8fnfw/mukyOR6U69YZtOY1Fg8d9wk4kA/NtdmPSY1cSb9220qmVdxEZU1ikKAdmPZleMe+O+9xlueDpp3fa5QnKnyOTA+aahgwzQ2rifkZW/uL4qzTZyOE51/LHUu987QkAcgC/mGTNOis7cRyZGTCWFRrDxfrcqLwH6ht5jL94M5ZW9Zo9qmBgaV/JztNv8oewGrxj65MCi6iIz8XkIi2CpnEN2dkMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqBP+49LVLKMznFvrI3FNUgTGYtqTgbrH6dNYIaWO0s=;
 b=Z5YVdNd9WX/SRuwD92VjrmclDYg1oSpxyetVpWiA6iDVvPMQ7TBQJZ+fsv2vDdstYlnfpAPBmKFvv5m8j+5TbIfNDPq80u6L/25e30CxTqFglN6PN/NJ9k27k/8INSjfjxApsiSnD5yXIFfI8pFg94N6JJdgIx3WsJzyy2YmTVkH02CI680h5vcx8tjfxT95HgevELK6JPQ1Kg58EfLP43oA40irXVcK/wof//Wurj80H7to2326Q+CUvif2uggP2IoQoFT6qhXUXkZ/qwnskYYzMPNYiMXiZVA3k5N0235Vr+r07qEekRWHgcm/Zz0xk0sFear7A2III8CMaKvUHg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 21:44:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 21:44:26 +0000
Date:   Thu, 11 Mar 2021 17:44:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210311214424.GQ2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <20210311191602.GA36893@C02WT3WMHTD6>
 <20210311202234.GO2356281@nvidia.com>
 <20210311205034.GA32525@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311205034.GA32525@redsun51.ssa.fujisawa.hgst.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 21:44:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKT6W-00BY6N-Q5; Thu, 11 Mar 2021 17:44:24 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db7b05a9-a95b-4da9-b4b7-08d8e4d6d747
X-MS-TrafficTypeDiagnostic: DM6PR12MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3834E82748D7D42F85FFA6BBC2909@DM6PR12MB3834.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TnnzG+M5OYZbM9PMo8Yu0Yc6FLpLs0UDImVT/M9eTJ7kFouMRAbHWMlPWn8JGOCi2etOb8uIi003VCtDZzQtCOOQ160FVb7HoS+b7xlx55DdVQwsUimsXuvAYllYN8yafVYnuAti4jYegjx3kMFlIP34n8CpEiZigw41iprZNb4YQq0KUBDcMCEzOEd0GOA5PAlnqzEmwWxzJ2tRlqNuW/q5rzXT/0LcuJ1cc1REC0aPitbHhmzKGqKnE/fCFY0/6KhZekr8VVuAdjsnvyR7PwsiTfhN4DShpU59naVgfG5AkusrkOrXILmtzRu2uNRYzhPC/dqGBxR6gvVd7fzIEwdGwK0mX5crvF0vOPvNtPO7hXa1d49EI0V8BOo8RhcLE0a2bm/7Yry+pLsiRtdjG9uYR49nTYT0auhocmLkv8nm9PspWwPHaab+0u1SsdjIfPb9xIW8huzeMbBD7rMMliufbf0bcz7nhfAtR9iyJ+pQwSnXOOFAa7+Dw32jknNdL+e4BnNKU1+TTwReaq7xTB0ZJziXlcjiNjVKk97sD9sRjXMPAUeAeN0zx8AnKbYPZ6wdR2bioC1bt7p2CtEtYnG5ivmQcnkqQZQtuXuxB5yVg1bIlKsCpDhH2M7SEF17DMdxD1vFjl+TetLraB1DIJX1WiqEmkqnwihNrfqql53fh9LLcA3L5N8mOu4rskvDcGWslsppyRBjeVJnvfqASLUc6wKa5PLqYtlyWv4xmUg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(6916009)(36756003)(26005)(8936002)(2906002)(86362001)(186003)(7416002)(83380400001)(33656002)(66556008)(966005)(66476007)(66946007)(9786002)(8676002)(5660300002)(4326008)(426003)(9746002)(1076003)(2616005)(478600001)(54906003)(316002)(15398625002)(43620500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?spqrqLwa80lpmixl6N4fqtIZ+Q/YqXTtOm3qGrWqeiubnj8mdEqKNTyEUBb4?=
 =?us-ascii?Q?+uko8CYSG0m0btVu95CmcFTbW1NRI9DK+tiFv2ouwdCbp7bpIC4zlApcUlOT?=
 =?us-ascii?Q?P6Md72WHIg8o0mBI9X3PvIamXRcuHR0fwMlkyBdXDgb/unHSgCOVQdob3rpb?=
 =?us-ascii?Q?v9bPgYAcBdwWx6EOqsVUdNZ/+R5XrBKksL3hqZ9hIQUetWSXbC51uDOqWSJE?=
 =?us-ascii?Q?wVMtC4AOna/IxjTD86ws9+Fn7gA1Wtgy+uDr0ymtqgYNRJRxM65dwZ0FbWsh?=
 =?us-ascii?Q?W5rgzCr/k3KikdYyGZpwRPdmpMRgd/xgONFp9WmYugVpRB1/icsG7aTYVa3M?=
 =?us-ascii?Q?CUR/IuvpBcZzbgIIjvnbj3YppoGyBSd468SVEv/x/rrSOw2pR7lIKsDVbaTz?=
 =?us-ascii?Q?SnLY1ChqvejTnWRy8hEvXOKh3hG+JWXw4MyJFS/Iw2TsNvLc70t/1dBnWpRb?=
 =?us-ascii?Q?PWQCt4MmmLIWrFU2wZFaM2a/hSGPI4PCrEqt+iKOOv/zWXRSwPJg/TEymaLT?=
 =?us-ascii?Q?54C6ZEBbxbps0iT+rNqI30Xpey8pVp3H3AmX1ha5NW/ypDa+4OxHDDz3agYg?=
 =?us-ascii?Q?ZoGPPvcGwGd1oL+bHL/lXQpbvVFshu/Lx6HfXln+Cw3wNlad0YH/ZZzXy8Sk?=
 =?us-ascii?Q?yXG+yYYKU1qLfwrhFLEsJb7wk0PllGmkqkRIM/ecYKb/mVUILeMjiM/lXs0l?=
 =?us-ascii?Q?Fe25doIqF/sFaEkHAgoXm0wcey3V4iuWroiDnv0H7WJFmaAba2VsPSreOzY0?=
 =?us-ascii?Q?Q3ImOi7tn3/miaIYYVM7UfosOQMgZ9KrjoeVJyakp9fKHAyBZzX1/FBZktss?=
 =?us-ascii?Q?aPZcokiU+F9Yc4xwU/oGlmofCzq70gkQr4f7A7WCEYRXTO8an5irQPN4j59T?=
 =?us-ascii?Q?v7zN9Oef/v7OGWoh8NVTl1e8DWqUPHOwyU/Hq3913ksZ+740hDfWwEXYd1f/?=
 =?us-ascii?Q?vXOtgrvc/FM+0+qGCD3BRZIdUa1wR562WxOUZ/xU2KcOkPFMVj6k83KcCdDk?=
 =?us-ascii?Q?07gZPQRkGrjnX7KRJ9OWXnnT0AcltvOX76eLF1T3VNefKEG9UfQK9FDdVSU7?=
 =?us-ascii?Q?e6rQaQGzeVgLIVLj/7XYD3muyo6H1qBi0o2aWFw7s8041EOvWUnKqFfYSqrg?=
 =?us-ascii?Q?hCzEk+Fxgu0oFXmjvg8lhx3r+o5+C9SmE5SgSiS4IKngK0c0Rh4/YDfCDlPK?=
 =?us-ascii?Q?18O9LZMhcuRF3rgR56GUpvugRX/atiL/xCX/k2NmmC/GhxFKswkqMoEy30FY?=
 =?us-ascii?Q?thjAjNZQ4CNFjIq1rPcThVy/UYEjrcAWS06SfIuG00/MuF8XDndHrp+pofbB?=
 =?us-ascii?Q?BgfCRSoUt/m69pyJHaE6Bl3UZYDDfevrye3K3UPAtyVvSw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7b05a9-a95b-4da9-b4b7-08d8e4d6d747
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 21:44:26.2058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmvShgkuuuCqG6e/yjl28OQU34FJC0UaaU5gKKNYrdb1YMyA0Y+HNbWF/bkHVyT2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 05:50:34AM +0900, Keith Busch wrote:
> On Thu, Mar 11, 2021 at 04:22:34PM -0400, Jason Gunthorpe wrote:
> > On Thu, Mar 11, 2021 at 12:16:02PM -0700, Keith Busch wrote:
> > > On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> > > > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > > > 
> > > > > I'm not so much worried about management software as the fact that
> > > > > this is a vendor specific implementation detail that is shaping how
> > > > > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > > > > know if there are any other vendors really onboard with this sort of
> > > > > solution.
> > > > 
> > > > I know this is currently vendor-specific, but I thought the value
> > > > proposition of dynamic configuration of VFs for different clients
> > > > sounded compelling enough that other vendors would do something
> > > > similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> > > > maybe that's not the case?
> > > 
> > > NVMe has a similar feature defined by the standard where a PF controller can
> > > dynamically assign MSIx vectors to VFs. The whole thing is managed in user
> > > space with an ioctl, though. I guess we could wire up the driver to handle it
> > > through this sysfs interface too, but I think the protocol specific tooling is
> > > more appropriate for nvme.
> > 
> > Really? Why not share a common uAPI?
> 
> We associate interrupt vectors with other dynamically assigned nvme
> specific resources (IO queues), and these are not always allocated 1:1.

mlx5 is doing that too, the end driver gets to assign the MSI vector
to a CPU and then dynamically attach queues to it.

I'm not sure I get why nvme would want to link those two things as the
CPU assignment and queue attach could happen in a VM while the MSIX
should be in the host?

> A common uAPI for MSIx only gets us half way to configuring the VFs for
> that particular driver.
>
> > Do you have a standards reference for this?
> 
> Yes, sections 5.22 and 8.5 from this spec:
> 
>   https://nvmexpress.org/wp-content/uploads/NVM-Express-1_4a-2020.03.09-Ratified.pdf
> 
> An example of open source tooling implementing this is nvme-cli's
> "nvme virt-mgmt" command.

Oh it is fascinating! 8.5.2 looks like exactly the same thing being
implemented here for mlx5, including changing the "Read only" config
space value

Still confused why this shouldn't be the same API??

Jason
