Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB114A60AD
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240638AbiBAPtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:49:39 -0500
Received: from mail-dm6nam08on2055.outbound.protection.outlook.com ([40.107.102.55]:11807
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240614AbiBAPtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 10:49:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReS62Xq38s6h82Ehdt4XonFMoxMEXRhJQJzCFBzB8uHBIQCW4haXdUmf103KgYA+DV9dzmL/ZZMKuRzkBzb66J65zPtPLBSmKhc7UloYO/ezwhXZ65LoqiXotBgpId+zqsJ7Htrqs149d2aBm596CYtCs4DdmLsfMdXpUTYDsdvl90NSo+UR+6ZkdKS4gcah3h03Lm9gst3KwedcoQANBuQO8kh2vluRi423wDR/G7V+Js8isMNGgoDXS9T1th2wW9rJ79qi5p6rBKqbNgvoFkPQLkiIAxmVwG2EUZgaoJGteAFb8V6FrrfidgWrHOjmlAihjqy7E4lH9rxvy//N1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZLNYPYjqqGHmIAvxjDYeXydGDIXb22wtOdRsBqRirU=;
 b=eSs9OVPeLrJijGQdyV56W52dKKpEpPnAIdPw2FfOBimotRWxv86Gtp+B4KwBTpQgv79QS5YY9K1voxOKyR0yEtA8/+bkNGvkxJA1SYDtPWIpL2AuHYz0XJ7DVypOjsUCLgLEckHH6WBTu1iN+9h1IuLvVunGdwt2rOO2pqwGzHd3PNKnHVXJMNR7p/jGNHmVG6v8H/MztNHh0tBg0q8TY6FtpPEUVR5KR34u6teu1J4knM05f10hlbY40e/rDYWXr2xXERTlxOm3WOFkMSen4beguaq0m9Sr5UrC8ZeJ2HwSt0/sJRnvFFeZMAEgPnmAdcanqWU0UoYhaAExkxFtCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZLNYPYjqqGHmIAvxjDYeXydGDIXb22wtOdRsBqRirU=;
 b=U4csCotQeYVuYi/aIIQrNi9mjeOk20OvbXGce2WvTsBN6LaxGDLkbDKS4QGRzw0S4G53YlJPxgD8T28PsbvTN/M1i0P5dBQtUClGPfW4eLy/Ypo9qhPOj6+4I/SHiJppUuky9U26m0i95DaAokai25NrV8k0GMjkRnNCbXP91CGg9g2kpWiGgYVzhQaqaswi43lp/JniI5ELIjhZ26FUoxd4Qv9GaeaZRs52rDyu5i0eFG8Qb8KUpllbT1rQiZhep77NQ07BOLU689lHdAQx+5pv5Ve9wL4xm8CZqkunNXs3i6iMvehDd1unWnIuZOyLEYkM9enmrcvR423TZtNkdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1396.namprd12.prod.outlook.com (2603:10b6:404:1b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 15:49:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 15:49:30 +0000
Date:   Tue, 1 Feb 2022 11:49:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 07/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20220201154929.GJ1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-8-yishaih@nvidia.com>
 <20220131164143.6c145fdb.alex.williamson@redhat.com>
 <20220201001148.GY1786498@nvidia.com>
 <20220201084758.17e66f41.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201084758.17e66f41.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR15CA0022.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73b3697c-1ba0-4532-4b6e-08d9e59a6f37
X-MS-TrafficTypeDiagnostic: BN6PR12MB1396:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1396524E9E67878DD1AE1D21C2269@BN6PR12MB1396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOcGTZZd6aSxwA/I/zowtbGO0/P9M48YubYkFg0GzTGISR253nwQzMy6ugCUiSAy7QbbD+rg58lNnqhvQAO7OLF154Oh1RCTK4krzLzY1CMm7fKdJwfI7nMo/wsWyUZsGpiQQoLK/JYsaHc1guKx1pWq1KT1PPHIhzBR3YTIFo9ztlcvpR7tkYMRQA+gaJWbFcE4oO8yRA4MpJXgz8txq1W5rQwZ65uTM7Yf8VH7pYfstAwIyAalzo/QaDr7X+jwwTRoLb6F7UjUe4hBubURqCgoUaoyA8fM6ZHuRSE75Jczgq39M/YGLQWm8bFkc800ZEgzdecjO6K2bIGWuPPPHPZqtQVcEdwF6m4gv+b8YCd/a4hUom3889Su3hclKb752Lt9vNyTUfUYQc9jR1MG+kkOqS5eA7NycijTrhCzRbyKFUtJtF/Yk4r96E7UUO37yczSx5LdWss1DPVWYd2t2F1Zs3N2kQoUOw+ok+4E7x54VC/d9BjaGW5mCV7gvshdNVpgNg9lQ/yvEDotOZfn7A3u8AJTSMz4zfkcOD/3c/Sjs7xoZx9IyZYcy/ctNkBdhJx5Y7cwos7IOF/uDS1tySrR3AzVDW68PuRys0nC1L46I1PBEIam/8GroJaPIHC7YZvCKAB/KGxc7iQ3VK0MXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66476007)(66556008)(6486002)(316002)(86362001)(4326008)(36756003)(66946007)(8936002)(8676002)(6916009)(508600001)(6506007)(5660300002)(1076003)(186003)(26005)(6512007)(107886003)(2616005)(2906002)(83380400001)(33656002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PHXO/D2BCC5xfypSw/Mq0Zm7cUlS+EHwZj5XKesvJJZ4XzBupiTGvghd96Y0?=
 =?us-ascii?Q?IYjnQA/i7jjepo+FuMJ8mmxNUpzCuUdWt8SoIijnbJVKdNwZIBsoHsiX8YNf?=
 =?us-ascii?Q?eW52ZF06iuMHOKWMbcprNRAvJhLLYJ2GsBzg40SAgC8GPWQTYuxOrxc04TCU?=
 =?us-ascii?Q?ftZQSbIrvE39gqTDODuL7XKYcJz8x2sPxWRtvDIs6OFL/5EaxmwuLezhMgAq?=
 =?us-ascii?Q?dvT3W73xgjjtAptJDKv3hcx4GDjjOa1tVAKbc/0W+QOIu4fLpmz85V0zDHuR?=
 =?us-ascii?Q?zXJrNcVttT/DSF9c0MkHx8vPH2Y8xTIDUIaIgyuaRBgczlzMTW0HpTSkhtMT?=
 =?us-ascii?Q?wVEZOr5rjcACO5Rlupq8Hm2EQZ9Bg4BoN3bLXLtRmDSWjdJ+3sl1lZVaKN5y?=
 =?us-ascii?Q?ZnifPTso9kOXg/CjYawKvwbPd7v+X8EBTbznofAXNe2hm8bKheXK6PK4VLLc?=
 =?us-ascii?Q?8F+ZUzQYb9uBpUpyzACu3mljv67dWGCcDc07/9+i32Gw0Ygxo+LNhJS65SgN?=
 =?us-ascii?Q?sVp9E1C0UftcdrAbpMKlLx7EACShPYziZDY1tMDrp5f4+YG7H14ZVk+tfwqy?=
 =?us-ascii?Q?AFfNIhaUriRd0vw4FDhhRTIXrhV3d7GOYVLV9EibkcYiQre6OPW5aS2xvN8s?=
 =?us-ascii?Q?MI6kNG7dnkYg29r3gy0OZfa2wyhAXaCgw1F0uRtYpFDc6m4R61tZyZusBK0z?=
 =?us-ascii?Q?P6Ej8CgNTEifqRemC0BPWRJtV5pLHvji23Jn8TtOlWMlKJadxhMpovKT0G0B?=
 =?us-ascii?Q?A9hqr+6SCzOlZAKOznnvpd9X8jQxCxsjZEU7GMWPpryue4wHhti9jtkBe3Ux?=
 =?us-ascii?Q?na85ifenC08mNKTq59Hxilh74+tyQ9j/wOc6iQNVHq9z9a9ef5oTMbQ9vYaZ?=
 =?us-ascii?Q?ECENAzgy4Wj2lkTRuF8iHThkcIL5RWmInDbsECLvVr8GJnDrrKPmWFvqg0/0?=
 =?us-ascii?Q?DzWCbScWoDH71EFuGM9wrbgQCwVBU1qgB/IzMakzLN3EJ9ht3qLVTpga6Akp?=
 =?us-ascii?Q?eOmGuMg494gfPrgmQ0ymd9Cpx9P90/iiq5UlkQY/0dGxv3BsNJ+Ugxnwszci?=
 =?us-ascii?Q?hV+70TfXG8t9+Npg7Djab4Na6FjGwecBTFDsVnEhD8uoJ5Ve0tFz3fYnJ5S3?=
 =?us-ascii?Q?Lj7Nx4QqZ/5yqs6d7YZIS0Y8OccHbvvIkPn8whMHVLn5NxcRq51CkfXjShSS?=
 =?us-ascii?Q?2RyKSuiqSwmNdG3PPgvbkPmGvJL9yTBaLTBG8pTh8WKzhCogKy93mI24lylG?=
 =?us-ascii?Q?B7MiL/FoygE13iWbv6ZDkxG1rDWBTk32OclM7oOKVI2OMs5tdVLyl7SIqYr2?=
 =?us-ascii?Q?Yi8u8wW7c4LQ3ITWRS7DGIWtwSIrdjEXWO+9H1W9oktHqMFpzNztyocQgz8m?=
 =?us-ascii?Q?o1jtY4sVOYwVo4qRfhEtOLHvcThM/m/cZPjemtpqD/3/l76sphkGPki/o/M0?=
 =?us-ascii?Q?628BP8GJPKFOnoURSQ2Q1oDznFsJxuJ3ftTmkXeDvThiPtoJQV4MIwXb1WmD?=
 =?us-ascii?Q?KnHIPSqHk7F6VILlQ1FLBvN6auZ8/czciRjDUbCnpGIiVnbEuH3RfZ0LPjDL?=
 =?us-ascii?Q?aif4aImxja8DcWRLfuw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b3697c-1ba0-4532-4b6e-08d9e59a6f37
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 15:49:30.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1OXsGv3+7BsoAicJsn1b3SSd0b6eWe/CbyV2shroxkYo5YBWM/lw3Xzf8Hh1wiX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 08:47:58AM -0700, Alex Williamson wrote:
> On Mon, 31 Jan 2022 20:11:48 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jan 31, 2022 at 04:41:43PM -0700, Alex Williamson wrote:
> > > > +int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
> > > > +				void __user *arg, size_t argsz)
> > > > +{
> > > > +	struct vfio_pci_core_device *vdev =
> > > > +		container_of(device, struct vfio_pci_core_device, vdev);
> > > > +	uuid_t uuid;
> > > > +	int ret;  
> > > 
> > > Nit, should uuid at least be scoped within the token code?  Or token
> > > code pushed to a separate function?  
> > 
> > Sure, it wasn't done before, but it would be nicer,.
> > 
> > > > +static inline int vfio_check_feature(u32 flags, size_t argsz, u32 supported_ops,
> > > > +				    size_t minsz)
> > > > +{
> > > > +	if ((flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)) &
> > > > +	    ~supported_ops)
> > > > +		return -EINVAL;  
> > > 
> > > These look like cases where it would be useful for userspace debugging
> > > to differentiate errnos.  
> > 
> > I tried to keep it unchanged from what it was today.
> > 
> > > -EOPNOTSUPP?  
> > 
> > This would be my preference, but it would also be the first use in
> > vfio
> > 
> > > > +	if (flags & VFIO_DEVICE_FEATURE_PROBE)
> > > > +		return 0;
> > > > +	/* Without PROBE one of GET or SET must be requested */
> > > > +	if (!(flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)))
> > > > +		return -EINVAL;
> > > > +	if (argsz < minsz)
> > > > +		return -EINVAL;  
> > >
> > > -ENOSPC?  
> > 
> > Do you want to do all of these minsz then? There are lots..
> 
> Hmm, maybe this one is more correct as EINVAL.  In the existing use
> cases the structure associated with the feature is a fixed size, so
> it's not a matter that we down have space for a return like
> HOT_RESET_INFO, it's simply invalid arguments by the caller.  I guess
> keep this one as EINVAL, but EOPNOTSUPP seems useful for the
> previous.

Do you want EOPNOTSUPP or ENOTTY like most other places in vfio?

Jason
