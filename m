Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F035744AFB1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhKIOqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:46:48 -0500
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:47009
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230212AbhKIOqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:46:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L80SYVgxNmHR4lGh+Rt+/9hAgw1834TkSH7MMC5qBxhVUCDQ0GGZSFVv85zwojrRbjTDP7HEz5wmIiCbu2XB67jHT6NzNzE/hhPVr5fKoEGInSYFSxVDW7hdZdgB+N+BS0nfpsPgkMn5/wHPUjtDSTu0m4JVCqtkf29RoyOLAznMloEdb0eSbtt3doSu6yeUhVW0M+C5ZO0PhWI5yefbqZAtqsdmr7nkIQeGOyWEaWAtBGU6BNuYzVVMduf1s7XeOseerwOf2xt9uqLJlXo9fdS1kK9pke9lHEqZ0Hyi+hBJtLP6QhzoHbzg8GQinkmh3a+hUiERqV3d9VMx/cbsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttTypTcBKaNeGkFTwIo59KcX9BwoPvgNJlbV21hAJyA=;
 b=aAfDZdVThumpt9ynLxen25gCiad/3GrgghkUEbeb21m++8LBc+cohSoh3ywqvpLc9ORg9nEDvVxNLXSlEF97MKOw/cRoLsGGtpl16uOcwFyXse0wqDu36QAFQrUBZ9LtGq53kcZhCMHHVhtKck2zCc4/+DigU8M8xl08kMnzf10gnYNw5BiNW0yRLCOlPEu3PsZ5kB/+LgStUhYj8m1FbSHqSR61a824fG2YRC9oNGBetwZG6Q9zL97gcaYLRS5XIlWeEvyYHllJhjRKo81mgsGbm+ADDaaIeT7pZg6eAOQdEeHL+rE/E3R/az+bVv5NvMCTy0lye7XfC9gWMxcB7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttTypTcBKaNeGkFTwIo59KcX9BwoPvgNJlbV21hAJyA=;
 b=W4MY/cc16dkZoPSLGChOx3OpHfyww3HNoCU+tEKJ2p3e9lFagrvRKOuCknWO/GiNmSyPdGKwguS+/6TQqkjBYRTRvxlStZ6mEKIErw9MHmqKKdtN0nqABQqFE9cykZFQnSadlhgTGa38vkdg4RyFH3pL02lLFEOQwVuvvPqfs5pxPI/v9Kw7hqU18VTeTFGbEaTna2Mmjte2VB1Jarprlv+HMzUQFTkaimadZCjz6BCpLnM1lh363HcOjktNXlmCWi7HsaJH7BraP/yl3DfwOaHzs6suqQoKmClegRN+EHiwReYXID1Alf3Dtx3YO4+6Hl3zoEFrAN27tschlGRnUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 14:44:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 14:44:00 +0000
Date:   Tue, 9 Nov 2021 10:43:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109144358.GA1824154@nvidia.com>
References: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR01CA0048.prod.exchangelabs.com (2603:10b6:208:23f::17)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0048.prod.exchangelabs.com (2603:10b6:208:23f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Tue, 9 Nov 2021 14:43:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mkSLu-007ers-OB; Tue, 09 Nov 2021 10:43:58 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f3ebe99-9dc4-49c6-b3fe-08d9a38f5db9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362AD4993AE9A3AD557CFFBC2929@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QSnbrg0KtZn4gVCK5rU2mzcSE8wQfB6TAUUFxaqUPSxvE/5REZ0Z8K98pUuWs9PdNlVu+dfr+ffIy0x4BkYudaDUPkxACyWA9sWLuLMBqEPN8js5yy5/sXQYeecfSV2UEEvFOYUGEz46Ah27kYjHoI4wVJfCpYU+S939SUr41Fa72RxUcvtBaZk8/FCMEmx/Wd8YTypTd6rENPGe/j91Bn++88fAMypRL5gtuxgu9aMcVPGoMa2uXc9vTd4UptCMEZeLy2IDRgZVDHtaR4kPuQaX5zraLlTC46fLVz+6QAgGphqZJDcZPewodl8xwOYRrOpujkk6/nTskMrn0zPm2jo4ZNjfWqpiLsl6a2gxx1XOAplY4xyIVBuGCRQe8k8SqsfPs5MyUl8Ee5qg0Cy2swwFca8oM7BRrUN068Ak/ZhuWFGvMxFQlGj6O2YRrcLpHR8/KuwLGy5Qn82ZNktZBdOZHt3x2X5ksDXxfpJnhmtZYgwRr7ydESv7QQbC9ClajUi6flY8aIfFm6mkXBgISZIidx8Du70U+r/HM6G5qSvHFFyhK3MxobgTo6ICbncU/9dxpXdaosdW0pD0Xu1HP0MqPWB0AvOG5tZ6HvfBnREa4nF4FTGrDM/xPF9jppiTFJGgDhoVR302V6kHmv2GRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(38100700002)(186003)(4326008)(1076003)(426003)(83380400001)(33656002)(36756003)(86362001)(2906002)(26005)(5660300002)(66946007)(508600001)(8676002)(66476007)(6916009)(54906003)(316002)(66556008)(9786002)(8936002)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i0Tx3zj8WFdoBcwD9UCiVY526G1hdvxTdDuYGbhxf514scLbuoQ2aJDTNxQa?=
 =?us-ascii?Q?7eeMRIoEDYg820UCADoKCsUw/RMib3+xhfVuux9ls3KDUtuioGMZE82874y6?=
 =?us-ascii?Q?ePl2JKhM5GBUSAkWF8PTgwtX3q0PFbG/6fNzSNb4UAw6GECe84SO8mL89lsv?=
 =?us-ascii?Q?lU51/wk0ZsGtb7f9CJT3soAGtNDlNXpiK24spkg/tAr5U0uZ7tx8eTlq40Gy?=
 =?us-ascii?Q?LYy6DyhU1LJbCxtSeRmExP3/dJolj75Exo+3DV09jwYvPsVOi/fZor7WjmRF?=
 =?us-ascii?Q?+QN+t5bzLDydvj1NYqN8lcL9YLO0yor2ApcW7cVZylKCn8QDjtR8bKYc4TWM?=
 =?us-ascii?Q?K2vcRtsWi3FE/zpHZjgJdNMIQ0qbN0kXELEksz7+obCKoZhI7TkbGkc9TmIn?=
 =?us-ascii?Q?cgM0hvybN51UOODweEiQ5PQvVkwBUNPzELvEYFbK0AC13nS0fyTKjk+6muXl?=
 =?us-ascii?Q?uyTeqvXTC/N7jUiMs3vddqx+91TL7wP2MddnX8dBzYaFy8EB1y0SHyEo3EPm?=
 =?us-ascii?Q?TsfLZqWqlVtezrb0PlMhEWXD1wA1H6mpz6L6hm7u5nFyYQT8dzdvEoIcscCD?=
 =?us-ascii?Q?eDsQf5/c1pz/0zuvIOTUOMbgDykWAg7jwF/55vNS9hlbpPdyLXo/adH18pIH?=
 =?us-ascii?Q?HzBPsA9cnzhLwqO2n51U9k4Lpf6xV7mmjjRU/SwFQiDsiBFC3SOstp8VPesn?=
 =?us-ascii?Q?ausMlHI//YaUYshZQ05ODXT47frOqlO7CQJ0940m6DlKZcorfb/pxkj9zK53?=
 =?us-ascii?Q?bpodzhdel/gwLAVPkYtLPycYFnJuYEbU5jC8SGE+LtIkTuBsa20hi43ms6AW?=
 =?us-ascii?Q?9MWbTudsQHTtXYjka+Ndzw6AF2VrbUGpn+TlxVsiFE+5gTFVu8LvftuZzsAW?=
 =?us-ascii?Q?6c5KKah6uEFt9X2tkIz/+bxj3iU8cd5ZioDJw2FCOxjvhyu0VY0J9ViKUznl?=
 =?us-ascii?Q?bL93DIW3ty3KnKOhCjzbFWAy+c6TKSqzpni3FQew3umNh0N8VK1dZK9sEGQb?=
 =?us-ascii?Q?W1BMR4QQj1Epp2Cyrux6MuCcpNje8a58cdCwU0gYAI7l6kx9tmhdA1V1It1P?=
 =?us-ascii?Q?9dp+CMR7M+KNQ4u34LDuBa02ISFMAGcTQY2XgaGpNpYF9aGaw+XShFSM9du3?=
 =?us-ascii?Q?Y11Md2JqZMkKZyiYPYc5W/cknCQIc2Z1RSxVZn/lYlc9x6mIAK8nHp14lxBe?=
 =?us-ascii?Q?4JP0y1EQAqHk/ifRZEI2tVZSI7n3OnWks+mjtmyqtNoIWFuMAI9XoljF3U01?=
 =?us-ascii?Q?O99BsumFaxa6QrpmvoXsWv2Se3XMDNvgr4K7G9CIFpv6TjDg/rFKNvQVtM7t?=
 =?us-ascii?Q?JZn4AplBCeviTOJXtNZYoXpGWrM6r+kHm12ndcldnFwgVWeX0k0HEFlTtC6y?=
 =?us-ascii?Q?6gPqX1G3WggTfsVKJDDMACo8QEexCCj4l8T6ZIdlF6p1gRCppBG7SDRTI1r8?=
 =?us-ascii?Q?RjFVJrjYKmyh2ihp81NYLYFQ3G8lOuAzmV2zHdmZrMYcuQZ8vixuBh3F2GEb?=
 =?us-ascii?Q?Vc0tyVwl2NGztokMLh61E7oNo3uZeeNyvXW9YD2rmrMXYAVbrlY6pm1PMXPM?=
 =?us-ascii?Q?gjSzvb98pDxiZuz90/M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3ebe99-9dc4-49c6-b3fe-08d9a38f5db9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 14:44:00.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFTG1BB4RqA7a0q+TEzOo2APKZeqjfKeV9E/a0RH0c3zKjrZ9mEt+jsbRG7Ol69J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:31:26PM -0800, Jakub Kicinski wrote:
> On Mon, 8 Nov 2021 21:58:36 +0200 Leon Romanovsky wrote:
> > > > > nfp will benefit from the simplified locking as well, and so will bnxt,
> > > > > although I'm not sure the maintainers will opt for using devlink framework
> > > > > due to the downstream requirements.    
> > > > 
> > > > Exactly why devlink should be fixed first.  
> > > 
> > > If by "fixed first" you mean it needs 5 locks to be added and to remove
> > > any guarantees on sub-object lifetime then no thanks.  
> > 
> > How do you plan to fix pernet_ops_rwsem lock? By exposing devlink state
> > to the drivers? By providing unlocked version of unregister_netdevice_notifier?
> > 
> > This simple scenario has deadlocks:
> > sudo ip netns add n1
> > sudo devlink dev reload pci/0000:00:09.0 netns n1
> > sudo ip netns del n1
> 
> Okay - I'm not sure why you're asking me this. This is not related to
> devlink locking as far as I can tell. Neither are you fixing this
> problem in your own RFC.
> 
> You'd need to tell me more about what the notifier is used for (I see
> RoCE in the call trace). I don't understand why you need to re-register 
> a global (i.e. not per netns) notifier when devlink is switching name
> spaces.

This becomes all entangled in the aux device stuff we did before.

devlink reload is defined, for reasons unrelated to netns, to do a
complete restart of the aux devices below the devlink. This happens
necessarily during actual reconfiguration operations, for instance.

So we have a situation, which seems like bad design, where reload is
also triggered by net namespace change that has nothing to do with
reconfiguring. In this case the per-net-ns becomes a BKL that gets
held across way too much stuff as it recuses down the reload path,
through aux devices, into the driver core and beyond.

When I looked at trying to fix this from the RDMA side I could not
find any remedy that didn't involve some kind of change in netdev
land. The drivers must be able to register/unregister notifiers in
their struct device_driver probe/remove functions.

I once sketched out fixing this by removing the need to hold the
per_net_rwsem just for list iteration, which in turn avoids holding it
over the devlink reload paths. It seemed like a reasonable step toward
finer grained locking.

Jason
