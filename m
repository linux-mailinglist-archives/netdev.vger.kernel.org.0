Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13096F32A7
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjEAPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjEAPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:13:13 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2104.outbound.protection.outlook.com [40.107.95.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00321BDC
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:12:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPvU4bDUniEhcTOG1wl5PZ110lmsegcCvix4TViNj2EMEPPdodF3hdG/E+YahHJ4AgQM4vhgUncklGX4PaVPEL8JIALNFdz46AhVCuNSu5LXSqP6gHxd9czegblDXYp+jW7WoLmxee06NKhbcOXc/0B+xCE/D559jtRWPIn4sk4Qw1PF/LBMPSPQMdoaBGV12c0LNLX+12hQ59ha0+OeGSkBdfzpPDeDPyS9zRAtbttnyvgi8gU6LVsGsFrzxpjC0D1DtUweLCJsQdGVZCk+7drn66JJaBoMfRt7QaivXYzugLWEGkNJL5kluhKjnY0jhfE6wdnLuV2Oqzg62JQIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQ/UCL+l6ES4UvXu6VUL7vlqE+A64pTSWA4ukR5tU3s=;
 b=THk4sgxlBaRna4upUq5pnh+oA1MSNq4GL++ZzetRq8FJ9eJSg2wdMkS299gV5JQsPViZ1zDnYEHpvg0CiQdNrpkhaybJIh5hoWU6vIDgtzNcNBpMdZtbJFqAU3xwIi+pHpasdPyvTyFPZ7bopjl0hQ28RB3Ak7I/fTRwo7r555YEgWrK1e65WspG1kCp3V7p0DBc2Dlgtt4yJy9v8hy33EKmDnun7caIpE0Gq6A7qLklDu6fwMxwnt9e5HVtl+9n0HuJ+A3m0v0COLWVTVfY87UJ9lBjtnKRot/Xn5hpfuHKhlIuchNCc4Mmwnj6m0cvR81iO8lDdzLJFuEoullagg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQ/UCL+l6ES4UvXu6VUL7vlqE+A64pTSWA4ukR5tU3s=;
 b=tbPRstO8qNBoTVZNyLdRi9NHtoE4BQkaIO0NpsJeTPXwCg0qabc8ciXtUHot0xlCT5hwEr29Ensdp9sac1sCZ/mJIkimFLPfrZLcKzfkF6hwLbrcs9+7S3SrN8ir7NTxaUrnLHRWrk0B7OumUGZfH0iSswafBRh5xfOoEIkZVmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5059.namprd13.prod.outlook.com (2603:10b6:a03:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:11:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:11:27 +0000
Date:   Mon, 1 May 2023 17:11:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 03/10] pds_vdpa: move enum from common to
 adminq header
Message-ID: <ZE/WmKynquxsjCY/@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-4-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-4-shannon.nelson@amd.com>
X-ClientProxiedBy: AM0PR10CA0104.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b3fc81-9966-47d9-3344-08db4a5655a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxrXGxZTdo859B+jPaQBp5U3IpcJ8RxtjlFXjTVwbOw0uPt6pyNBQDbqRDxM9OIWH1yAQ5KxP6xWL/TKB0bs1T7ji2Pel4LqqxFZ7t4oRlgfeGJMwKlBlr9eZ99eMq/c59LRxXlXyySTh3KalyBlTejMr/0+fMMzGDWpNHbu4xp7pkeRGw+1625teZ/YuFBMgY3qvvwz0Iq15SefMeShERgxwdsaWjQ64WHzbFtV2/6SbjtIbgszH1K5oFF2N1fpZmC/msvaUB245BILzBSuS3/EZzgmCykrQquF9fJdhgLzWgpghrSEBvDYhAhn4qN14fVLhzF2HAypx5XbsOSVe9FzB43bxPyHSefLzKCxWSHL3+sVLooJExeq1nVaPt0Bp6s+nqDeT7IyLP+Lr/jSGuYYUxSr6NTE9iQas4BB3UmhyU/BsXZXnSirgXSJKyv9zduuwEHPuUarWr/e+wdEM2mxeIOb6BNvjvnTQCdcUqhj/nxHs4UXaYvY4Dgm6l5R58UscpDOL1Mfx2BAia/nuIw1bQBkDOPEJWKsOrE1dwuMmcccZnt0RPRSdH0kw+p2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(396003)(376002)(346002)(451199021)(86362001)(83380400001)(6486002)(6666004)(2616005)(6506007)(6512007)(186003)(44832011)(4744005)(2906002)(36756003)(5660300002)(38100700002)(66476007)(66556008)(4326008)(66946007)(6916009)(41300700001)(8676002)(8936002)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPh0BU2qjgcUmAxXZdRnAqlpzHEaGT8qXVIW7A1OVntydlYGJhm02CnbaN93?=
 =?us-ascii?Q?Jt6dE67w7NHtwd1RDDdJkosCqzGn2qRDkvdCHUeBSQJJ8l5J8bS/5bUry6PH?=
 =?us-ascii?Q?5Eqg/Y0baYhQs8mt3hRFTYfh8EB+fiDVO6ZGRKIb6byJX9/54sIqkVGzKH/M?=
 =?us-ascii?Q?TakwI/w7/GXL5tZ9FtTSzESZxyneg/C6yEvvG5uTmj1wiMSCtJJ6NxF6RRnb?=
 =?us-ascii?Q?4Fp5V3EoGN36/s1gKsUGHtPAerS6jX/e7Z5SAyOXI1Qwe8hEoL40H0hUG239?=
 =?us-ascii?Q?R2O3aMXR3niyAqZWmqon4d2ek87d48FBmPRMND8qvigRERdjzGaz4rR/Fh+C?=
 =?us-ascii?Q?ZsC7V+raTRmtXHROpMaCSJVdOvkfrt38VkgWkhb5FoqyUK+xruzgBhkRVlFP?=
 =?us-ascii?Q?MX1uPrsZFJYfb9rV3mhpBS8nKcL5V7r/zN0zK6t64JH3SnOJSvHuT+widdRm?=
 =?us-ascii?Q?lg5ZBDErfiO49vx8RadNEMlYcAr/ufS3dF3LWjv/i+Hk2H6tl06ifd4bEOOB?=
 =?us-ascii?Q?s2vMs6eKZfpDUPm1EdL34dKi1tyUWPxzZaCYo2zlYIlgwHgrETW2wgk0431/?=
 =?us-ascii?Q?UKPPqEDFPtDAKn2gVf7arJkYCuubkJH0+Bs3fFUYuYUoV2zsd/YXWaqS7BdX?=
 =?us-ascii?Q?1qFotbiaxtw6lJ6eTzwgBF8wwv42slW4zLCTvVXkpcfxNVQS+5p1Nfv/Z6j3?=
 =?us-ascii?Q?BSQnGExsMolDW70zyeF85obqXui0i6f3kNKtpGC9pmfdoJBForJlfb+2eA9o?=
 =?us-ascii?Q?FZrXq0+2u0GIT9twj2JjTW9XEYjTOhkWkZz6a62YL9y11YsJT3Zz+d+JUB0C?=
 =?us-ascii?Q?aSwpBX16suJPO/0dgHnBtFfEuOb9RE6ZVMP0fcsDyQ/f9Lb2srVo2LMbyTzA?=
 =?us-ascii?Q?/iWhbeXuQjwjOTpNZQRcqrzi/p1SbtZHp622KB7Z1v4VedarQm3MyzypWd1I?=
 =?us-ascii?Q?sk9be4VSgRQcZx4HHllD5bkgb3vIm+UCCHO7exIVfDhoGmjewBXB5Yt/Zx5O?=
 =?us-ascii?Q?eOjMk+5dO7dxGKFtBM3fYDH65hnc0tAO5wysXL3jJMoWKlw+JGbfE6mzphMh?=
 =?us-ascii?Q?AmcBkLtd5ywYnKQsXi6O2EKbaK/eY0LY9z6fYgzNeLhw9tsi+1dAdTH6Inri?=
 =?us-ascii?Q?ZOJ7UWdt9LNnfxj7HtXaFKrmPXBq+R6TYf+gtRgIOjrmOJe08t93PLgOJTom?=
 =?us-ascii?Q?DOvttooJCs5ZPllhsWAZTR9u0gW5mbiXLGZ73xFl/8kzKGg4nK62cdGq6/s7?=
 =?us-ascii?Q?imC64Iqp8dDURg8VFyEK+S/apc2FUh5eHeBamhZ5nhHPwXtTX90Kb0TLNpNo?=
 =?us-ascii?Q?//U4eqJ3c/HhPbjwRZGmxvSkeSkPDJaPeGLIadEuBh8WWQA1GZiIO9WpJFnX?=
 =?us-ascii?Q?x04qc/1C2TqXqkiiVRyxDA7LqY4p6ovbzYEOZvLYuXrLtsyGeY+gd30o6LFN?=
 =?us-ascii?Q?th3AsAy102cg7oDnCoaJ+wHoMP6oEQKi8syu7zkhJ1NSU+ccAILdjQSyv7Uh?=
 =?us-ascii?Q?klf7xuJyXa3LabWEaWzEVwTx9KoNmb1oWy1Z7SlLNx4EN5v6OZZS1KjiIVfB?=
 =?us-ascii?Q?Np6BMSHkOPTXhxC5S1ciyq3ulJpxuUf0DgBGVwImxLsmqzKPPjGCFuSomTfH?=
 =?us-ascii?Q?i2H8Tig4jrgakmQSqsC91XRDvxZJ+0M2RgmhFqB1M/FbKSuyk3T72XLfXqM3?=
 =?us-ascii?Q?c+JNSQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b3fc81-9966-47d9-3344-08db4a5655a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:11:26.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xg0f+NowZOzhXr9d1XH2Gpo62DGIevOJDUzsgcHVLI+ksGYePrczhE8xa25JJXGXIy7y+uVnbQQZ44BzT0h1nW1d/LeGD0b2s0w7YVhwPBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:55PM -0700, Shannon Nelson wrote:
> The pds_core_logical_qtype enum and IFNAMSIZ are not needed
> in the common PDS header, only needed when working with the
> adminq, so move them to the adminq header.
> 
> Note: This patch might conflict with pds_vfio patches that are
>       in review, depending on which patchset gets pulled first.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

