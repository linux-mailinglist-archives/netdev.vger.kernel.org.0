Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A3D68BAEA
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBFLD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBFLD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:03:56 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2135.outbound.protection.outlook.com [40.107.95.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BD94232
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 03:03:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lop0wzUVWXleBdhNa8sJ3qUiEcA7LCA/7K/IH+byyxL6YFhosUCL6SrGwG8vgJM9BG5lWXzxMo5/FlxHSpxTa3P4bymU82iY8QaIcirwZuUXzg7y5Wg5g1Xmo2TD2p8grZEAeZEmm9CwhoKxEI/cVUcAFLWUyM6uDcJVFntqPWvapdO1xhkTM3QxrL6VDhCQLWr7glSNliXRtemCciE39V+TCQUMtgqetfB2JXsFubFklVA+w+CPTyL7BzWt55+xiLM+Xahbu3xY+kgditjHBJdlzfq1VVURelvHBZnTSqnYbKlBYKcpWXAg6fywr8PwGfAPnhPlfv6dXj5tMVMkLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mptgLiMlAMkSLv1T65ia+GcZ29UhXsKgNmd3u+OPRVc=;
 b=mKYusBM5OSVWXpmXUBMR/74+NuDLqKcF6nApiBCjsqTxNEkevqGndZ1a2SYsQTVMzXV/Bqlkuj+pBNvBWhF7U3wwj9rU4DZfETT6m/3ObVKWJsUnU/gmg2Z4q2qcpE2ztGPWKFmL1q18pJHPPiU75lOFswdcK5ozTWSUkZ/nUG+YBWHm7iVLHpHpOH3Ecr4iy6A+6+EUyBN2IK4+xSyCWb7lAGD8ax1HrO+GzjcPYAo300isbokIMLcyKxY8CSAlNgymDhJrUXGt0VK/aLZ+dgOEDdUQUCvYwdfBgGrOW7i5Wj+nIuTui9gxFnzoh73dFM03qvginyeRqXszr12GKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mptgLiMlAMkSLv1T65ia+GcZ29UhXsKgNmd3u+OPRVc=;
 b=SNi2zUfAF/zv1VeLn1CgDxxe/UY9+e3V1frL/D47Rj94JuxV8P8W3q8UKTHbGs9kLVry5bDk6oSxyBGAR0uo9BPW50F22pjJjt6CNCej9FcQ6nmpZUZkKjyUe3tUnr4QkGi4jPWjQG9ZP+0XB4+lhOFjAaxULPsQypGvg8V4kJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5050.namprd13.prod.outlook.com (2603:10b6:510:a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 11:03:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 11:03:50 +0000
Date:   Mon, 6 Feb 2023 12:03:34 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v2 9/9] net/sched: TC, support per action stats
Message-ID: <Y+DehoC/fE9LA0uI@corigine.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
 <20230205135525.27760-10-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205135525.27760-10-ozsh@nvidia.com>
X-ClientProxiedBy: AS4P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: 55ef0899-9939-4274-1f70-08db0831d3c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2fyrdUosRleIYxYf+XQwd+KlEg00eEaFURkJm2JHCvRUlvICFi9t+53gSvutfcJ+QxaJ4z4OS2+PDDMhlVftVLMo7KgsVFoCL0mx2OzhyHmdu+UelwCr0kQ1w+MqRuiCgtCGK1VG7UVo6ZIO1+gEgjA82EHto4shWFwXasYR+8uE40ULwLNItySNBW1sM32oddOdaBNkS33xhhEYUyH5+Paosihn2uClmdm8Yb06u+ZFjBEwtQzN4AgHoNHIrDFi8lVDIXO1U+lskz57/6ebdmh5jLYVs1GH6nSHVXvzMSs6KIa978OBgiuFYS2wAxFn4YH6MoNjuZijso5l4cxL9saKfBoBOE1qP7lbyTaJ5PAJzXVoxx72y0OcWcwfF+NCDlVR9wIwURvy+WmvjQnqC8vUFquzgXFGGaU6b6Ct7PWa1bedl2unQdb0UnGCTaMNbMYt+oCwNXXiT9i7zJu/aUfDirJziA2sN5iyPehbnQ7SdDVsWUkeg3XuxWMR0W3h1a23RZYE7eGM9+1hFtDOAGYh3JfFN9WJTxvncy3s/W2wePlUYt3rMz9oCzmohqi/ty0QNEszd5VLAcUaEChfkDYvX5NbilvJPnaBFHFzBdgc+QIR7wLD2XMmL2pivkojtsXYNdX4MzgrDz35wcdjSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39840400004)(136003)(396003)(376002)(451199018)(54906003)(316002)(83380400001)(38100700002)(4326008)(66476007)(66556008)(41300700001)(8936002)(66946007)(6916009)(8676002)(6666004)(478600001)(2616005)(36756003)(6512007)(44832011)(186003)(86362001)(2906002)(6486002)(6506007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPxGarckp5135QRTqmKu+9DdRqaqMB3gLXA4B+XsIIPfMf2kbPibdP0CHr0f?=
 =?us-ascii?Q?vLzEFE9k7VzEw+U8OAc0tnYl7WYvPn9wSy6262+WwG0PuRh/4Hu2C9abzKkn?=
 =?us-ascii?Q?zo0RTM2Rl5dbWTRZL/YAO6LRDfp0bBBwU24EU/UQO3ZgJVLtW8UKiVvle3QR?=
 =?us-ascii?Q?ii+xYf5KYOIkGyU/3AnOeXNSUOhTvTeuKgtqIfo6GRgXFG6hWhHh35ppBx0W?=
 =?us-ascii?Q?pEzEJX3PQkNS/Dcd+9Kq9Lqq1D3X0G6iP5snCqueZKn5U2X5B2pxpufnd8p+?=
 =?us-ascii?Q?cdesapHUFwbtKFXGvHZNhkjwUZXmFmJZU7UH3x1Fy2HBInCFyCpDkx84sQyx?=
 =?us-ascii?Q?Jze7pxs2tynqtNQVqApc3YC1jQ8n7M+3fI0QWdWkkF1t74EJ1dAkd8CbWE2M?=
 =?us-ascii?Q?vyEbhXSVxXHJqh5FYMhcjVxTv/0KzVMl9LaZ6+4oXgDiFHzBbg1zJafYfL4L?=
 =?us-ascii?Q?J6vEvXvDrCzClKsIhEVpnnaDU1MOWZUmNxaBwNKKk+raD16IOqDsoa8dBd8S?=
 =?us-ascii?Q?awz5axBUX0mUBTqPhDsGV35sLHEg4AZDww5WTJ7wIB/r3fghN715Duf5CRCN?=
 =?us-ascii?Q?16PbN2EsPaH8Y5tfp0//rgSDYqTg8lhoIRqpN2B2+a591tyxom1rv+aDZ6Py?=
 =?us-ascii?Q?etQu3WIGDzAlUrVZRdjlKgG/AMHFh2m2gww63JimWEiRw9Xeg7hZyB0//bPb?=
 =?us-ascii?Q?osnHCIu5hXncYR2rQB75vTCZucWYPhWuY/t1/fGefKSjwO0IplEiQpslK5zp?=
 =?us-ascii?Q?S0vqBo9RNLOtSnS8ARFyclSdU9P0Kn/rjM+Sg9gQeCjnKw/eHnGaBR/OHMMt?=
 =?us-ascii?Q?6v3xA7A4ofh27WpC7DhSZJKAZrRlAtB4faHoqNLFajH7HIxgLAgYNoj6fjvr?=
 =?us-ascii?Q?1u4FzlBQy+uiYTlvDWbeG6JI1W+XiYAhbp7ROFo0h5WvffFjPBbblr7V2MwF?=
 =?us-ascii?Q?wgK8YO02p7GkAdRnpxRe33W0p9UK0Rz+fVxKqHGmFhTadXIpjBsLsbzUXdm6?=
 =?us-ascii?Q?2NIB+E4jOWFCybqQ+JeOcdGFeKI57dqlOmjRuS6MHYWn6brahI5WnXa4x84x?=
 =?us-ascii?Q?I/1HQzy3tyWVoczjSxO7OXDJ8xZnZJ5sNZUiO9I2PdByXDaaV8/DRbq/2Fra?=
 =?us-ascii?Q?W+bZ0OB3AdOr+tno8HnYxwrMJWrmmW/esS95j7bfVLnreAhwXwSRiAzyMsca?=
 =?us-ascii?Q?yJ7jXN8pZPm/UpdUtUAsXmWni9CH0rkYJe59zXX1mAnL6t6SPK8gIJYulwez?=
 =?us-ascii?Q?5mYQGVVL+Fp8YDcOqTl5YfBg00PaAfTAVUg+ICLqRIODab2n5jZ3PNPqUc06?=
 =?us-ascii?Q?2dvGO2T2oqO9xhCvUzY4mPRlhOKY+sPzh/wUdV1PNX2vjlSjVgrRSUN5eexH?=
 =?us-ascii?Q?V8HhtlAl/cSqo24Y8zL3+qI2tWREQa+7F04kWLIjTugZimh2+oPOYDVJsQ53?=
 =?us-ascii?Q?p0GCwrTC8h8uk23mOSfqDEmIaLlsre8tq9b8b4E5vNo/BFWTf7qjvQDNYYzF?=
 =?us-ascii?Q?pQGeNbHVzLPkGg09cwdhhzyF8deb5DvzOsRyKx/NO2vVD4kHInivoOKjwWIQ?=
 =?us-ascii?Q?LF5ajaFfA1C6oaQXbQO5QxaEElrYDXsbZS0zzl2kK9KgRJfWNf0owptbBkv9?=
 =?us-ascii?Q?2Q/pqkbSQt/EQkb7Ria9eDnXelU8vpQ5DT+NPQpQHm9XvDGb7nSus1YPsqQk?=
 =?us-ascii?Q?IDFsxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ef0899-9939-4274-1f70-08db0831d3c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 11:03:50.3950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOqaEYjs4mRuTLWY+uphuH3sowBQBaJhfgQuCLc132MCJLp2opBTfZlw97axLHkDGFEAyrcyelptqJrjDZR5zMpTsqGbYU6YB2kv0O+i5Cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5050
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 03:55:25PM +0200, Oz Shlomo wrote:
> Extend the action stats callback implementation to update stats for actions
> that are associated with hw counters.
> Note that the callback may be called from tc action utility or from tc
> flower. Both apis expect the driver to return the stats difference from
> the last update. As such, query the raw counter value and maintain
> the diff from the last api call in the tc layer, instead of the fs_core
> layer.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>

nit: I think the prefix for this patch should be 'net/mlx5e'

> ---
>  .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
>  .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 44 ++++++++++++++++++++++
>  .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  4 ++
>  .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 39 +++++++++++++------
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  2 +
>  .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 10 +++++
>  include/linux/mlx5/fs.h                            |  2 +
>  8 files changed, 91 insertions(+), 13 deletions(-)

...
