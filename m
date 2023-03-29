Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF366CF16B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjC2Rtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC2Rti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:49:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2105.outbound.protection.outlook.com [40.107.244.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D270189;
        Wed, 29 Mar 2023 10:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9DX8oKNaTl4b8YUbznMpahm1g5l2qCzX2udpa9pvPTySsQCUcE9TyTByUyZQdyEWaUl+/aUhhwH3NJw1vSwPenIoGbyDmW5ZsTxIa3hxyATDccjIaGg8KF1Hmpd8yNUWq7aOuv0XInv2GWJe50d2kEPajZNnTRa9BiQ9FHSZ19niKw8eyJOAXa2NAOllkrcc6IMtDJxHFn/wX6oKt4e6mkGbQdZWLJtQqlukTmo/HbtS9cM2QclMcgRHhQR+uLYEBDKBQn1d2hRy3kzVPiWbcfxuY41oG2tvU/1LcXEuHzyiu4YlLAJWB8+Y9lH25k7Oz2oUdGx/uttD49iHJnZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oJddHsGoY4KcTcXzRAuDyuN0DIhxJCfvR1qryGImOo=;
 b=i+BiZz3A0MD6hvvIhe++ZcbtsEjcKE+Ai+NRAS8aLQYKvG7gSV0dyhNGaiiB800xPjjQNeq8EiwuyUf6x6KS6nrjlJglCNnhO8dleUEjQiHZJqJP4W2MC4OB/R7XxNtmb02T1M8xi5y5U7q+MgiRtE/56FMu/JwZDt5g+0GxNNlDdlVLtijjL3UypOwgnVLPHCv12sFLQdoGU6LvPoySth9vLg5LKGAp1rFiOybW+7NdCu/F3DQK0uWeeAkkxUEtbSDZ/wL+PIGVNzGxKdOc8aLubMsPV7PHCSDOEGJfkIJNInCASWp6s4zZc++Zhi8O1uGvC0KiES5d8naAWDN+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oJddHsGoY4KcTcXzRAuDyuN0DIhxJCfvR1qryGImOo=;
 b=uCnU5La8gt+PNvqrSHF4bJuMzCq3MOKDmizd1CpvrF0giueHAFuPAVzoxYn+P7Oa2RD69ZhllA5/lnmVSN6P0+kA4syWVNDKOLsXNjWbHzQe0AAQTy+k9B6hdiaR43A3u2b4jk0qZaFWnjNvcSR6bDphOxAcYjUp+pWblDtgXsU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5748.namprd13.prod.outlook.com (2603:10b6:510:123::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 17:49:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 17:49:34 +0000
Date:   Wed, 29 Mar 2023 19:49:27 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v6 vfio 7/7] vfio/pds: Add Kconfig and documentation
Message-ID: <ZCR6J9Y7hD5FpNZA@corigine.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
 <20230327200553.13951-8-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327200553.13951-8-brett.creeley@amd.com>
X-ClientProxiedBy: AM0PR04CA0054.eurprd04.prod.outlook.com
 (2603:10a6:208:1::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 65cd0a5d-ff0c-4c6a-5254-08db307df4ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxVJ76CF46QLUzoeBGM3dcORiXjt17NwjK5EcE9C5Xw91nGavbdkZxoxckoB4I7Dh5fYZC1MmDndK9zsV2QqafQCkP9j6avJYFSmd3PUADU1Dv2kbpQRlpA5y63Jb0iUX0JWd8QhivcWi7z7yJJzFw5UgBLN5L/CQ/3I0W+t+47Ad27p2MiA4JTGJkTD/B+LTEleRDb4DT9vPaxRD7fZN5YfjUQ7JU85kEVTdse5awMlh+zzcI/kz/UKVf3wITbfP5VwAdrZN/a/JP1/DjUca/k1/6QLi1UBkvxa+8b7A+7KTbnOKnAyYHUuteKtxRwWkQy0kHvUcX4smrKg84DdRVnd63O87EnxnfpnG9EfKCebqe/l14ChFjAYOlJz6eP8bBZsWakl4eRakcFFzDGwCuXOZe7QpQStA8KPBtrP7C9gE3ECZAVkUnfWwPNOsq/rW+uKYxmSky5TbpgorAN/cLo+bVIUnsayba7RYsUGex9dn43Ht5jgP9c85bV1kLFZNEWEQXmp+uoRJannfVXqdLt0uxCb9GjDl+uzLfD1q0qTEWHpI8ZdM25pQbgwpJzrFqWyg2NOJmA81TuGpvlMUrwS8LiQmLr5Eir/mvDmRDI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39840400004)(376002)(366004)(451199021)(36756003)(86362001)(186003)(4744005)(2616005)(6506007)(6512007)(44832011)(7416002)(8936002)(6666004)(5660300002)(6486002)(41300700001)(4326008)(8676002)(66556008)(2906002)(38100700002)(66946007)(316002)(66476007)(6916009)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PiGDwG4liQSLfASQsdfFeN9mxLOTwqE66KMeAk+p2kQprcthbTOR7dSamgK+?=
 =?us-ascii?Q?MgYvduzQbTvwE5pTpeJ7gAmQEE7/WZsyixcbvc+BigWDDn5Ed84Ovh0iJXAk?=
 =?us-ascii?Q?aR2S+QzHj9g9AQViI+aZrhk6Z6iLTUuJ3GWwzbvSZ94vgpmUfL6Exaz1ep7U?=
 =?us-ascii?Q?x2NkVAPi4aH8ZvQ0gFeB+GFaE959wT/KWje+N4JcoHShwT854JN7Vq+uWueg?=
 =?us-ascii?Q?wU0TZ+TgjtY8pPlkXQ3Yda2HKJz0zRFe+bK87cEUDekO/FPmLW+B9cNLr9nf?=
 =?us-ascii?Q?wW7C+lFmJD4yfWyc3rnE5FrT21oljaUYpX1Ymx+4zoAhcCwz2baV4i/3iD3p?=
 =?us-ascii?Q?z5e2wYbEJGc8hWXz0G9CkqN5szLESIxrBcgkZYNRSU9WBMbs/eWYlWoFO4IS?=
 =?us-ascii?Q?UwzibgaxrJ/4yC9KjSwuco3Su9EsrZn7WgasD8UI4rpJkDPL33VKKwOKeuEi?=
 =?us-ascii?Q?9929twii+PqRKTnY3B1FPDDUPjT7CEkWsuC0vMgtMyvICvEnXaYywKKn+QWH?=
 =?us-ascii?Q?aQHyd7JFOHIsA//zq0LFo6gQjmL5UVFar7qLVZqoKXRMlVUj25xVPVysWlI2?=
 =?us-ascii?Q?7yXW8ZBjqTVpHo68x8sxyR9wHt8oClRRG0gCH6iIw/DlHt7ndhkXl0l+8Dw/?=
 =?us-ascii?Q?W01TpUFoUT6XwLMFNvig9N//1vcTrvxa8RuJ2R12kxHPhxlzeB2VQGFxJFbr?=
 =?us-ascii?Q?g1FmNrZwPnMP4dvjg8Q+EMULjIGGO91VdC3rTHK0tEzP+49SBiNm/skuQyCp?=
 =?us-ascii?Q?mX8CO/iY41KFhx7ay2HOoRGJM8rw6KmXsMkEHxmiByKDWsGwi4vnS2FgS1BE?=
 =?us-ascii?Q?iMqBridgx5o5hL0F96k7zaBGhfslMLWFG7ulf0Y5CVV/a5L0l6x5zMIIyUVE?=
 =?us-ascii?Q?8hfVyw8GuGYjimy+N5DvyYxfpg7NUjC4swj6gO1Tjc9C8P/kuljkO7NE5P95?=
 =?us-ascii?Q?F3pKtMnSpFfNkCQJw46XsJ6Ow1yTrNNZzK5+YzrRQWwHTAEGs0ChfnaeaQJO?=
 =?us-ascii?Q?1lzlOu9Qg/wGaozGJhCB2kpA3ZMWa+rAC1fGlAAuWtXYf/2v99mDmkQgRHbq?=
 =?us-ascii?Q?4ufLdqIX1Ci5hArssXKRbmFaBR3IzTZtXiJN3Z7H+iy6UB1HROW6HbscaBbQ?=
 =?us-ascii?Q?D0GA8FtZ/ObkdJ2L1r5F74Ri6A616FRWlk2C1c4nCeO5aar6ivJQ/s7h22C6?=
 =?us-ascii?Q?h/PV6/J5KBv3ju/EFDfJzIJAXhsfAyzJrLCCtyCMSjJ8lGd7/ADkMEqJpTKa?=
 =?us-ascii?Q?BLcfsRw6/GtPyNzD3OgcPeCEDaEycsp9ya4c5/lbvaXnnY301upDck3X0/WY?=
 =?us-ascii?Q?PcwVcUnKuZXaXcoXho/dvABgixcTMbdLMLL26BuIq+3WK1qlGuvG6UC0cIwL?=
 =?us-ascii?Q?TTcpYJ8GI8jbLA95tRQQMzSJfTQE6DX5XTmbAhys0bXQw4dJPNWKllv/H9la?=
 =?us-ascii?Q?+hANL7HW2W65iE5rYliTLWPUTlemx2Hq7vpZpaTWc0fNGkKvCEenvbyIG6C2?=
 =?us-ascii?Q?QJDhYLX1i0wiH/CQEaj8itZneCzaxUSc/fD5wyiJ+P+ZKAPlrw0N4x4bm4mP?=
 =?us-ascii?Q?m2KDClI8qUcsJwl5uZfsGbWWfq2P71inkQ+B/HTYxL8KC5uMIHX4B6+2Al53?=
 =?us-ascii?Q?6QesVP3H/UfjHqtahlm8KE6mkBzZO29hM1ONSvevhd5zpIoiVW9GcnLHDN1C?=
 =?us-ascii?Q?FnwMuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cd0a5d-ff0c-4c6a-5254-08db307df4ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 17:49:34.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xddbx2ATY7ZC3NG+IpmQza7wrUtp2hyU1shN3tgYI0ApPtuD5+62s9Yo34iWmLlbdua8Jt+6c1bpf8ZtekxOC1+VBCaKsvDYu6L7O4w2YSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5748
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:05:53PM -0700, Brett Creeley wrote:
> Add Kconfig entries and pds_vfio.rst. Also, add an entry in the
> MAINTAINERS file for this new driver.
> 
> It's not clear where documentation for vendor specific VFIO
> drivers should live, so just re-use the current amd
> ethernet location.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

