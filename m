Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017FD42C388
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhJMOlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:41:13 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:45568
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230015AbhJMOlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 10:41:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ectSWsnVL574zocecgrFehS8WM9DPsc1rsCxdlaGsaOEbSz9bZEHInVU/t8ssmvPcLEXr/eGCDTc86PQ0q/119HMc1KalmDG50/khGwbIEC3PIYd63TLzrXYb5eXikRZmzakaCkkN+6whElDmN9Z5E7nQYDVakr3rjnMe9oa7EsiPJh6vDPRhkscKaVKjXf/3iprNe9Xzbjf+Mov57n9CktzroeAl/imMRbO3xua3sebXWzeX5ZF0HvW/TOEfSfIPKV6DChBpEDi7uEDwYUhf0FT0+SIS9wUa5HWN/hOGXL1N0p0GMMqn8WIcw1NQoE23IgZrTJlfPnGIE9jakpi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+iFMV2CrcrQYb2qvXSwYcUCkhfhn+D08UjmJ9meMkc=;
 b=nH6Fot8R/pAeEam2VO/CHL0LzRwFqK3njjCLSsK/KLa7cgfkjFcz3Awvltp/mHNXTPJQRqrHl31XreJM0ND6h74GeELUsdf4V/IBFSEM44ccfXqXP0IS1ufXtcwYGaktcxhRvrxeGRqloev+OThyfaEA5znIdjG9OY87uBB9GWLgu4noV77j9uI3z5Lre8OVPka7rGpYpVC+xBKfp8vYUdhMsrV1JghItKAncUGpYr4TyjuaE6ljPYK0FG6ky61aOaFv0rSen402aNobZep9oVSRPeKOmXFuNkn0hCnV973rZg9r1PSHI7HZcNo6ZGBpnmcMw+U7nlUaPQ+GuR1tWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+iFMV2CrcrQYb2qvXSwYcUCkhfhn+D08UjmJ9meMkc=;
 b=YfpSn7R6b1WnFLsVKy5Yhyjy5oGppFL03vuDfI9RDKkMRCuy2QCCscyrXBk99ZY7ChJs3JPVCUJUMpb8nsWVddKGQkLvahbf9ntic8OGnGbEUTz6L05xPDF9M23EB/pfOkCVAv6p8HV8IfUoFwG9fcRXYwz+7sBJfs8iwCC7Jbp2WuQAfU7esMnFaWI8gAEtHmccrvsDN1v9DD4nTKqx332D/zgZU+rsR2Q0ChgqbHJmRtf0qpTz005hBFMhnwXvYo7+bgcLv/gwHIfZDClpSb9fwC3HgZcOkqGY4ZTx9Wq9n4EOfVjmy3tbSFjpYkCnmhhLnbLEg/oZQXo++dgVTg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:39:07 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:39:07 +0000
Date:   Wed, 13 Oct 2021 11:39:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 6/7] RDMA/mlx5: Move struct mlx5_core_mkey to
 mlx5_ib
Message-ID: <20211013143905.GD2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
 <61e2704c9bb4669186274f08b41544092d96de8d.1634033957.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e2704c9bb4669186274f08b41544092d96de8d.1634033957.git.leonro@nvidia.com>
X-ClientProxiedBy: YT3PR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0040.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:82::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:39:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafPN-00EVR1-QM; Wed, 13 Oct 2021 11:39:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b0f37c6-9ef7-4ec6-6c07-08d98e573654
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5286DD3E2E002764D87C8ECDC2B79@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWbJIuZ5WVbrIa+HU07JBbaGUL4dqWAhu0/M3todAwbskA8T3l7kmxk4sneijYss0ZZGy2HxErifq1fCiqGbezWWd0pEGsxIz7tmVeV7QlUo3M98EvJdP1Sxac9Wxa3SfuKIYbRyDk1n7ltedci/qE1P1RK6AtZRsbty6KV2K4YxykNmsylFroBdUddHhn2O00P791V2QqSZyf/uBZEZFS4i1d8tWCbSdbhAgSLtNtgHJpD5abFkopbEBR9P+YkIr5Hgm/1HOHjlITfdowYz7fOEKwuuEZoLnrU0mttmOz0WPDb1fjlmKRvCDnkfPo5azyYcuu1v2MnPdLjI78HfmsMO675jr4t8tlKEh7yxyLu9qSsxLXO70+y750UH9r9bk2iJUlHyhwSiubk2nsgw9MBzOF4qr7QmOQKStU3E0un6GGOMrBh75JbHU/083zE7yoWgto+et71PHlPHIs3IhQPLhvryVpsc8k7ZmtxUjGf+GXF+UZgLGft0sCje0KzxTpJJmuyxr1Hb9h0pYpIBz4r3DEHIKQX6EsTh70x4+s9oValqUqHrq4SA9Cd2g4yp7eQoTNcx/uZZJQgVl0HRl4s3x0kKerT6o8Yw4ERruuni0krpvBlC4gs0ZysFon9QUuldUnvBUD60RZFt0zBKPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(2906002)(66556008)(66476007)(426003)(33656002)(26005)(9786002)(54906003)(4326008)(5660300002)(186003)(9746002)(316002)(1076003)(36756003)(6916009)(508600001)(8676002)(86362001)(83380400001)(38100700002)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/WQm9wILEsYydv2cdUXVlZ9bPNZBhTK21RgRS8L4KBzfbsGh1hiunsPrjVCm?=
 =?us-ascii?Q?W9cxDm9DvqpBWU5sd5Dgt5kz0qdZSKL7m7iDyoRCtRA4E1S36KAcfDos+CqA?=
 =?us-ascii?Q?EAXckCghoP20IF9lW56WA//dnsGth6Fr9oUuhmquD35uKqUA0FqcM3fZ8vVs?=
 =?us-ascii?Q?K+5K1WgmsTuZR+1rU5tEXByQWhxfryI3j92PjAuz7daQ8cOR2Xe8yZGWXsOF?=
 =?us-ascii?Q?dfnafs49Pr7bgiv51ETWKGHtwUeTgHQvX1Gq77uIlqOcgPQrXyUryq7O5Bo4?=
 =?us-ascii?Q?ApZtnGaOD/WHifZ5NoKD5TV4CgNoUoj97XUF1wuiJW/snmxf+Vzx07tFBVhP?=
 =?us-ascii?Q?0ZQw8tJuLxaHKGx1j6AV9PuWulfyh2cpJtf7oEsiVUW2ys2kI1LqBmRv+8gG?=
 =?us-ascii?Q?2DNC7cjqdhnLoAaFIHsH1A9jyfDxax4c6W6zJGGRfTid7kkJi4n203ZZhTNE?=
 =?us-ascii?Q?w4Q06oo5+CP4+L3bxvrlLIMKxvWPjPz/iJKScQeMDx3zR2tjSM0eR5x+4Qpd?=
 =?us-ascii?Q?f8iztubhO4h4pqsJeWn83dVDH0Srfc634566ywqlptcq96iPddf7w1aU5/YZ?=
 =?us-ascii?Q?N3t7FM0wfGyVt7+FSBKLQnCWqi++g44RCp8/+8v0jipKJOoncsWp2433XohS?=
 =?us-ascii?Q?vERu+uWgNC/ju1Wil3+0pCzLvTf/6ngS5gxTKNfbFmyV5rBzi12pZoDxSrM4?=
 =?us-ascii?Q?hrDrkPvnGjChVly3AgDBM1/n+bnjbvkp/4+pPMAN1k8HT1/CFSa28anBgQuJ?=
 =?us-ascii?Q?4/7yrLfN0Mze5iLK6ACBF0i0+P95pPEtfvzJv4s2N/09lRBC7xHsGfatSWn1?=
 =?us-ascii?Q?VSLd4/iCo2VfnfThI9okyMis8uQizE0chi2O+gOkmDBTif4FaMw5ucXAABfa?=
 =?us-ascii?Q?lpbg/NbNxWmpxs3aBku903PrnhRmekPMrP+eCzJzqdohSMnw1yrDoa2n8Ft5?=
 =?us-ascii?Q?+s8fuXROv2RogUi95xbkzRSd+kgNcTi9GDOwyIxr3pOe5jQkirOS9Rc22OUD?=
 =?us-ascii?Q?h1sicIWkktyUAhIjzA5iY+8lp5UgSXzFa2wlJDyxL0y/FwFZXu7wWlTrquAP?=
 =?us-ascii?Q?yG/45hEtBfxCwhXZL8Gg/Ktsb098YFlC4ysbNihN6pponer81H2BaDisypK1?=
 =?us-ascii?Q?WTc0tqZb39bqAFWP8IVWMUlBctNVjsZaAnjZQ4QApFp6DiMpxc5dZMnR1s3L?=
 =?us-ascii?Q?gjavdNAjN3gJRMG1xfOhOlMs6TkWym8UJLlQ/dD6kGeOS3T6HdsgdEjzTUnP?=
 =?us-ascii?Q?0an51huxvc0u+eiEsv7gCrH3gU5Az2j6X2rNx6v2cFHjxVXdisO0PwWAwyS9?=
 =?us-ascii?Q?zKStQOeQAqpsmvV+55IUp/V2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0f37c6-9ef7-4ec6-6c07-08d98e573654
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:39:07.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIyB5DYPOAdaNRu70sL3gTwOJUNoVwnT/aozPiW8ZKN3vk4ewABAq0YzfjbIPZHL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:26:34PM +0300, Leon Romanovsky wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> Move mlx5_core_mkey struct to mlx5_ib, as the mlx5_core doesn't use it
> at this point.
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>  drivers/infiniband/hw/mlx5/devx.c    |  2 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 25 +++++++++++++++++++------
>  drivers/infiniband/hw/mlx5/mr.c      | 12 +++++-------
>  drivers/infiniband/hw/mlx5/odp.c     |  8 ++++----
>  include/linux/mlx5/driver.h          | 13 -------------
>  5 files changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
> index 465ea835f854..2778b10ffd48 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -1293,7 +1293,7 @@ static int devx_handle_mkey_indirect(struct devx_obj *obj,
>  				     void *in, void *out)
>  {
>  	struct mlx5_ib_devx_mr *devx_mr = &obj->devx_mr;
> -	struct mlx5_core_mkey *mkey;
> +	struct mlx5_ib_mkey *mkey;
>  	void *mkc;
>  	u8 key;
>  
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index cf8b0653f0ce..ef6087a9f93b 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -628,6 +628,19 @@ struct mlx5_user_mmap_entry {
>  	u32 page_idx;
>  };
>  
> +enum mlx5_mkey_type {
> +	MLX5_MKEY_MR = 1,
> +	MLX5_MKEY_MW,
> +	MLX5_MKEY_INDIRECT_DEVX,
> +};
> +
> +struct mlx5_ib_mkey {
> +	u32			key;
> +	enum mlx5_mkey_type	type;
> +	struct wait_queue_head wait;
> +	refcount_t usecount;
> +};

Please drop the horizontal whitespace when you move the struct

Jason
