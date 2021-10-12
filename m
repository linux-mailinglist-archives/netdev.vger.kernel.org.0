Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDC42A8D9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhJLPzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:55:37 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:47520
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234892AbhJLPzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:55:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMsDkeg9DKVRMZ2QtkAMTklRD7OOrb0DvADfd0W1MFVp1P8vsFdiU8vHX/dxSW3GN4WLsSsfxDvT9Fq2X84qG99hwWmVYtZcvxPTcKi5UGVIRN17vdY0ew3bOJeo7OxXT/Qdbw1dk5fhZnEkRYIDxgOuJK+m514b2tNCMn/rKA63MpmPgxE7/OFb+6RgJNRVoenvhaUXWkNNaEcOmNPOizQPLVRakGFv0guPM052l4XUs09agY6ym0twxDLteORApAGoaUHvxnbn7dbrryATzBADmDNBz8g884otOOVXYHlqde2Fa4gRlNRd2JBQKUC5Cl5nxXLd1qTgZCqURccUtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2I6yOHK4gXm5auQGkrz6eHy5/RYBxspJCYv1fPU9XQI=;
 b=NZtAHwozJu1gC64oEgz6pfh4aaWBbTbZFk4DVzGGjqCOSmiShpyRSCKaSYdTK9tk/neqlmfUTmJs45FSPiqc0DFXX0IVCSFuz/JP3xVYylTAEKDH3bm5k0QAwd+Za0lv4E620tf/G/vjLNr5GDwftJCEfE4jDlJfDInitN1DplNTwkBxZHCxJP/ahxut5TpHPSFuI+TNYnosEBHezcdQdU9g7D29O+XqAUQ0A29QQsh2yQ/Z279Rj14Et2sb+e0rWX0XY5AboNhCmksTfA3V553gRUjCNmIEI+hSEY1XcCjOvWKu8YS3tPjwr6KBGBK77W8gJW7jHH1hJYOSeMRpjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2I6yOHK4gXm5auQGkrz6eHy5/RYBxspJCYv1fPU9XQI=;
 b=Sb2cVj16JvI2AL2VJtVeDXrWpmCd9JoTRj2WYptD2btZPXzlb3gCesbDgSFF9Voi2jyGS6KiEf7tIFSNmuiEoGALen8hD9X0TnMKOS1uS9PGCZ32rGPYd9bJlM8M8tr/Or/M0q+mixejgg3tx7XALC5tBwaOcx3fhf9X24Z3yV5LAExAYZ1SOPRGvivq8JKDHrsalmAhvS6Sji9DS7PoO6ewiCBWAE+7T19DggmxSn8PMZkh97OhKqjqG0j1Y5/Rq0Jteq3ejfvvr7rkgsh1e5fuZBYF1yGpbm+Fzf7LyPj6BX6+Z+LfITVc7+jW+yyi6fzwuYU2vsKs8BpfQirH6Q==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 15:53:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 15:53:33 +0000
Date:   Tue, 12 Oct 2021 12:53:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Mark Zhang <markzhang@nvidia.com>, dledford@redhat.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        dennis.dalessandro@cornelisnetworks.com, galpress@amazon.com,
        kuba@kernel.org, maorg@nvidia.com,
        mike.marciniszyn@cornelisnetworks.com, mustafa.ismail@intel.com,
        bharat@chelsio.com, selvin.xavier@broadcom.com,
        shiraz.saleem@intel.com, yishaih@nvidia.com, zyjzyj2000@gmail.com
Subject: Re: [PATCH rdma-next v4 00/13] Optional counter statistics support
Message-ID: <20211012155330.GX2744544@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
 <20211008185736.GP2744544@nvidia.com>
 <YWFbGLPdXanAeDAG@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWFbGLPdXanAeDAG@unreal>
X-ClientProxiedBy: BLAPR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:208:329::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0079.namprd03.prod.outlook.com (2603:10b6:208:329::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Tue, 12 Oct 2021 15:53:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maK5q-00E8rB-CV; Tue, 12 Oct 2021 12:53:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7a8b548-e48f-4f46-0cd2-08d98d9871c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB514327DBBE82A47BA54D0386C2B69@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFIjaJF+NIoI8NZAU30FlQGzdhFCSnXFBSKiHRq2QLUwT3Spr4uPYT1tftgyexxHJW4Le6/0ZLk8A92ZWZcIgk7ZfVw3EwCkUhaaeWZ+xk9l2E8PNpFojyRloaVkxtLm2yOIgOPg9293Ih5fIoCSFBfT2bfbTCRBqeszMuZNaBF3XlhlcO3Gb3eB1CQhmtoyqXPDYKQF7J8ubTGGO5niXUDNkjbw2HZ/HaNgnOcn+PmsdHFsyUb9n84KuTB0eGnD00uVnAT7JJVUirob55lUZSJHb73lYz550OjMCnqWniS5Pqe1KxHioly7Lt2DawpmNxGZrjsxygrHiOhPsEgBwVoCfrVL+w3PjcLLBmHkhtGicIqxQCNvkroCqy2z4yqKxxzCheVmue6neAVpxP5/F0OKoPS9yYVo306SayYtliL7/Uxm5aq9QwjpB8RVkQT9oizaxpjRsRICJOV4bdYBoWdqB3i/OUmvqVrWj8bhyVNgeqeF9XtaGyP9Zz8eHwEPOKO+S0knik0CBNjKtLZplBZkPTE+9E8aQZ66mk3gDn9M+YVkNhHu9JlI5hx1selty2zZHvXbbCHS73dIrGlv9i0Su01nQlKCXsvNr5V4hY6xNWu0+Y+xZK0oqrn9/nkH4+Sjx4UW9xUqBroIcq+kWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6862004)(38100700002)(33656002)(83380400001)(2906002)(508600001)(36756003)(6636002)(4326008)(426003)(66556008)(8676002)(1076003)(2616005)(66476007)(8936002)(26005)(7416002)(186003)(9746002)(5660300002)(316002)(86362001)(37006003)(66946007)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?49f3/k2DvqzdCovzdCqViD/FdYQG3ws4Oc5P429Sb6shk3wyuKeBPwb07QAd?=
 =?us-ascii?Q?HKfqQ+LPTjRnw/dDr82dWcPxOpy2UxdICkU3sKrBq1GgkjC2OI7gJj/t/w6Z?=
 =?us-ascii?Q?HBG0dfCk/KqJ+35oHXj/AGk1GNnUYASO3q5G6HuxTUruBmVcV0k/1Cy1AORG?=
 =?us-ascii?Q?m7PCUe/B7F0r7LEQQ8OjL0/gnmI12RnXsoua/gDwViEouxfrBU3jCE2jvGd4?=
 =?us-ascii?Q?UBpIEB5yTq+dlhNl/2StwwilT5U4rhwUdGn+CdW3buPn+goBQvGDNrjmFx8n?=
 =?us-ascii?Q?Bvs4ypocjcp5cc2rfwmetbHgNcfbbnNYPa/kvbunmJjN/4JbouayyCM9HyUa?=
 =?us-ascii?Q?HKIWbfGbqWjG6zMIRNgrnrgWeMWTsTpWXcLj0pMCUVPoHGB5OlD0Fv9xM70j?=
 =?us-ascii?Q?QmPnmd4rDO3sgK3skV8+RvLrPvX+xhvZUmGBctctaiWLgjnQ8PuQownPzji+?=
 =?us-ascii?Q?veZtz0IKvXnFZppf0gNtHvA+ME2/uHxxLBxGVahd9u6Sz0BZVD/AqFsddYT1?=
 =?us-ascii?Q?uYHhHdrjv4hp+cnHYf+swHAiZsBFkbzwiKIWkTPwU0PM97QeFvACy0zRXtku?=
 =?us-ascii?Q?6LFoM2JFX3dmTeMb7A/y7su4qLRgd8NH+3cVcfpeEthsAUDjeMx1cyKM8EYF?=
 =?us-ascii?Q?A1ZRNTPN+cs3uOWowy5E/1MUYAGWLsYPoaSu33sV0xl1qVBFB4fG0xWRC0cK?=
 =?us-ascii?Q?6qZ7ujtT4N/oPqb0ikTTh/vDI8BcYjGGPqTZc5sNCxKQDCo94qLVLOkD6GbS?=
 =?us-ascii?Q?lQmbeuza7JdrZqEazxFewO2Og/JCs3pKm6CHPwCKwR384sIrCdRl1GT3xKN/?=
 =?us-ascii?Q?3wOWPq2r04WdahGOeVv0FC2KWRll9NZhI1X0N5KYCbJ0EhsMdZdnKOibn4hK?=
 =?us-ascii?Q?Bpv98aVmgnrA/ULKr32lu8rliuJc/9pTAePPgTZzJMBBo33gGl9MTtTgFh1I?=
 =?us-ascii?Q?aEfSiy8XEwjXHrJ0v5g6zKX8W5Petw6emAYtOkDmjt+bouGPn20bag63CR3d?=
 =?us-ascii?Q?zbDa+HuPLCPs8nTdv7RHiwjfz02f66lkNSf4agPybOh6mn72f8Z7LP8Abnbx?=
 =?us-ascii?Q?7/ip40KenAo3wD76GVeIbW/0cR/mMiXTdwWGHSqDzZhxUQ/KrRzKRyc6hRYO?=
 =?us-ascii?Q?yUKCqEyRI1oddi6VKK8A3mgjfoHKYbMTbVXZbu+W/sg3wqXA8HXv6ALpbZlZ?=
 =?us-ascii?Q?N0npZGOPO5WxYIeOC4sZ2FSeQVRgRPg1MRLJ43d3wKmVKiDxuTS3IoR4SuXo?=
 =?us-ascii?Q?T0HsKE7K+snlpqHSO4/xJbt7t3iLL8D8T0bFsR60lweVORngTv1x6fHlpG6Q?=
 =?us-ascii?Q?AIWtjUdSATGPja4Jh+waI3lx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a8b548-e48f-4f46-0cd2-08d98d9871c3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 15:53:33.5856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uxcsvRcwQpkPxdYjFMPdimNy9TTVyBZlnGv6mllV/cSSeGejV11bryXFUSLUATo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 12:04:24PM +0300, Leon Romanovsky wrote:
> On Fri, Oct 08, 2021 at 03:57:36PM -0300, Jason Gunthorpe wrote:
> > On Fri, Oct 08, 2021 at 03:24:26PM +0300, Mark Zhang wrote:
> > > 
> > > Aharon Landau (12):
> > >   net/mlx5: Add ifc bits to support optional counters
> > >   net/mlx5: Add priorities for counters in RDMA namespaces
> > >   RDMA/counter: Add a descriptor in struct rdma_hw_stats
> > >   RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
> > >   RDMA/counter: Add optional counter support
> > >   RDMA/nldev: Add support to get status of all counters
> > >   RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
> > >   RDMA/nldev: Allow optional-counter status configuration through RDMA
> > >     netlink
> > >   RDMA/mlx5: Support optional counters in hw_stats initialization
> > >   RDMA/mlx5: Add steering support in optional flow counters
> > >   RDMA/mlx5: Add modify_op_stat() support
> > >   RDMA/mlx5: Add optional counter support in get_hw_stats callback
> > > 
> > > Mark Zhang (1):
> > >   RDMA/core: Add a helper API rdma_free_hw_stats_struct
> > 
> > This seems fine now, please update the shared branch
> 
> Thanks, applied
> 
> b8dfed636fc6 net/mlx5: Add priorities for counters in RDMA namespaces
> 8208461d3912 net/mlx5: Add ifc bits to support optional counters

Done

Thanks,
Jason
