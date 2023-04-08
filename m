Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA856DBB91
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjDHO3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDHO3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:29:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE360CA07;
        Sat,  8 Apr 2023 07:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6QtNng78MxEXaNHb499oaH2mlPOWiB1F3POj5ULcTgCSoDqogkDImqQSJGHl+QzflcuZkfmTLWSFjckg+dZkLnh6p0dQWIaa7um0JoY7QV02R8BTGTakmYe6R/dyIOt5ubeRhyXzk3SZI8ZiSB/V+9D0m5CzcLhb8DbnI4AcX8ZcgpRe1DEvQdZJlt+PMKBH+oWThJWE+fIcnksnpNol9cNBk/uvwI2bnuFukQKJByArHZNis1AXl8KbceVUS/j5cEF3nYyhjp0x/SUmuoiY7QXJC7YIYfFTI/raNp7hOMnSjkdFk8U55fpxDTo0v34VACZHHQ45DSqpT3HGlXSwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNvcsytE44nq0KiTnn5sujh1ZpzlQY/WYOo/ihDByh4=;
 b=EbtYjhGpWFoxtcU5cao5hqkhAwv6JwKVHXshJp+Tv5CcOFW+/IXn2q4E/y/1vIfKgOa0zM2xCZgpS/sO+0pIFUqe44+mmbxWnvtFsJcqNa/tlrn/HZptDj8Zae8eyc/d/eXEBsAOXIAzjIgvMzr823kSr9M31o3aF25JJeYTA9AvzRjgGcvnRUqkcguYP50QOlx4cnFGw7QBgfFx6XbyolkDJAmF9qsdS56doZtztm706Oo5WHQt+DY4yfMA0o5eMW+dI3qpe5fQHn05bZvEFTtyJ4KGxTyAWvVgDrn6lQW0eGObpQ4Mavbfge9YZLSgSXAWnFX09zDB0FGN2QOXcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNvcsytE44nq0KiTnn5sujh1ZpzlQY/WYOo/ihDByh4=;
 b=YYm5KiHS00gLjSFfRdclCwOfUNBICsL+uM2inz5a8guoyWtwxFapIOVL9sh81XflLsDg0oy5lGe0jfSIjfI3gWUBKZ3Cu8De4V9vFa/VFlyvQgDUexfnVFeM49K6J2psn8VYDnomL7/sKPuffkhU0CXQtHqRAGR9p4QOOSZHpVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SN4PR13MB5812.namprd13.prod.outlook.com (2603:10b6:806:21c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 14:29:41 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:29:40 +0000
Date:   Sat, 8 Apr 2023 16:29:32 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v2 7/7] octeontx2-pf: Disable packet I/O for graceful
 exit
Message-ID: <ZDF6TC+Tm5NvfePi@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-8-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-8-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SN4PR13MB5812:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a23976e-452a-4d2f-0f98-08db383db03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CARqzSi1BcEUVW/HBusSdpWEL+8VKJS8aeG3mtck83TWqyvtnQ/5wLnjsYJC/nJx0QMicTkmES1AYIf3hB7inJJLO5qYgSlXFgFjdlGKEdF1bz/R49ohzVXgb3IPkNEObSLbC0r6Xt/bj8Zzl7ikCf50zMBEZxnUu1pOm8BD0txL78Wi38qMrQLF4py8LhhB/G9zi19zLIslnicuONwDSC3HXEMmtpvCERSiKfMfFeajU0zVmbGKc08ziRRsyEGfFsIdiz1iIKzDmZpkczbhfKPaRZVqb8LnuIZW0FOfqHCzb1njOXyjOQ4jNJd3Y9NOdywCGzeTSYs4j2esz/J9ha2lxIlqd8SpuEk9A3o/605j3XiQeFrXzK5UIFobiMCu8btPoJZY9ZqD8/Q79T6rKcOrhX+SBqTHgI6M+8I6niHtJ4MjNK556uzGgYL7pYyjcGJhckiOQqd/RvhjfkFsMNTg7Ea9lLBqxpB6G1KgT7wefiwcFUKl1oHo4ib9lbTjHTgUun78CR6yzQM2JLw/mxH+zKSxL48A3aZrIDOmKsMIUYig/Zs2Y4/SHnA/onYiYyh9aEfm//R0jnJOfwoJrPChzMk+P9AMXFunrXu5wurE6u4u5MHlyuvx54+lt+ZxmMx17V8y5RvaHYhW786UVcuGHuHEGgWvDeoBzPviHgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(396003)(346002)(376002)(451199021)(316002)(38100700002)(66556008)(66476007)(8676002)(66946007)(86362001)(478600001)(6916009)(4326008)(83380400001)(2616005)(186003)(41300700001)(36756003)(2906002)(6512007)(6506007)(44832011)(8936002)(6666004)(5660300002)(7416002)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3tm5RzlXkRjQ8ApqkNdATL3wujI9Xj0s3VL2DKeY2AzFinzGjzjyBGpZz4MZ?=
 =?us-ascii?Q?8xRHsnNY3ahTs9gtdypG5ODTFTCPHf01Uq7Xtuo5OJJqf9hJybKRe879LoPT?=
 =?us-ascii?Q?3UrNhBhscvJDuvRtcsS5FsOa8ey46Kwul/G8bayqa1yqFY3elcPbc63ECeuL?=
 =?us-ascii?Q?LL7RNGsNHeZVt10YVT79Z+Jz9S5NerjVbGAadQVko+Cu4NmYnEJESzppX8FY?=
 =?us-ascii?Q?3oAqTDiOtK//LacLldYy+UOaiabCLqdqwzj10LMm8sJSThj5IszpysV3NPhP?=
 =?us-ascii?Q?Ani9TQuXgzoSbAa8uJBSuMvRrAxSki53TtG5W+Zf6lmeiQLCqvZa01vjyDC/?=
 =?us-ascii?Q?saSRAvpqNktsGHZGZn+Rqwz0hEs47zuY+pBOxU6BuUKXC5t5aWlC3P2Drh9d?=
 =?us-ascii?Q?mnADnqxQBMMSkF6XKrCDx5fJ01H216u+fozwKXsR2NPBZDM5y3WsSlqOeWvK?=
 =?us-ascii?Q?fo4h6fHygr6JxAEBfDb+yJe76yWydJ4+a+6joWSq3TyXK7KfPWqt6KYt97bJ?=
 =?us-ascii?Q?YssxGWXEll+sN4+4CEGRcFl/NPBAdQxKJ67mAHtpO5g4BezveZU8NfBQMOm6?=
 =?us-ascii?Q?Ifjt0W7tmBqhtwdPVFTxgCnTtNbNo0vAnlOZXpT8WsR16BytTo25saEMJExi?=
 =?us-ascii?Q?Yl6eXCvUgxM9B/I5S6OVD7N3B2ITwAiT26nKyCPJ796wkHjr4eUJzjk+x2a9?=
 =?us-ascii?Q?/TUIwyJanPuV3D0EhMHfj/Fl1VbsoFn1+W5Jo55e5agVDZOpR2QHdZcUE7A/?=
 =?us-ascii?Q?xGYCUsjAhAxgrRAulhBCECVnBzUuMYxUBRraxXd49i7Iye9UX4HShmKH9oLG?=
 =?us-ascii?Q?MVWEz6oBc0UR6Jtp1jsZQ4A5Kbsz/HGhKkHk9KFFEZfJIL2Iu7+Mmgsesg1O?=
 =?us-ascii?Q?96tFguwmsAU85aVk5bN0aj71VqCT8cI0zGfXw4jHcB1xtVBhxyDXeIGdSgzQ?=
 =?us-ascii?Q?e4dQi6MlYuOJz/Ql59Awe2wt2sn50gY+0ss8k/AhOwFmow76jSavA3MYMIIF?=
 =?us-ascii?Q?MmW3XFs/tUgUBmSpOVyuiJN86CdJ2o/+Ha6D4aI3fnVFLbFLXP8Rm2MxWftY?=
 =?us-ascii?Q?MFle24iYvETJ7zHE04OnP0qq3xEgm+GeXTgWnXJo1aDrJulbvsV6nQ6ywKX9?=
 =?us-ascii?Q?qEqKl/z1Z/TRF44DyrRB1ZKw0GcYFAi0t3qAinuO22n7hni8sahnVyTTY4oe?=
 =?us-ascii?Q?SThSrbq3GhifP5QjPcLckOU2bqqIKPQp725B/rm8rul/l/l6TEDuRZ2phyS9?=
 =?us-ascii?Q?hmtPlR6otppyvLYmMkWnxWPDhHtWqnze1NS0gn9kWsluLUv4DZMmdzpt/W5x?=
 =?us-ascii?Q?fGdPJc5ZrbELKmEsXpnnQrP9N4gpDSKPfemkpz7fBPgEZIL8AHXErVezhb/e?=
 =?us-ascii?Q?+kOs1e2c5z7H7JTefPX5EXnGBysMdVJXyvq3Yt9b9ZynhTf7WoMbclGSix6E?=
 =?us-ascii?Q?VDJW7264vxc4q97M/8Nr7W0Wqb8rkpiB5PWpcWRJ177lbyQanYIDylLps5cG?=
 =?us-ascii?Q?ia6coBKJxj6hX3GnKskt6xRla/zlVfzdfqozf0q5DBP/9LhJwKAsDOQI4q91?=
 =?us-ascii?Q?gdrD+upgOQjQVnLSbIXMS9FfS5FdOmn2xDYOmZonqvtQ/Eqeg10kYHjbm5aq?=
 =?us-ascii?Q?9dzJ9in4iYU1ZHaBriHp5cF/Vu6Dukk8q5LfSVFsjfrjEHFKZunmtuxq1hzx?=
 =?us-ascii?Q?gVoQ6Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a23976e-452a-4d2f-0f98-08db383db03a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:29:40.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XoC1/UMrlBMi7JKomXmI3AcmOSb7pcd3DbY7wpSBGr//g23Z7ycR3mTQHIk2nVp1cM9bxrkVuewUt98OAKya9ZmE3Xahd4j706MQT5GGMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5812
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:44PM +0530, Sai Krishna wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> At the stage of enabling packet I/O in otx2_open, If mailbox
> timeout occurs then interface ends up in down state where as
> hardware packet I/O is enabled. Hence disable packet I/O also
> before bailing out. This patch also free the LMTST per cpu structure
> on teardown, if the lmt_info pointer is not NULL.
> 
> Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

...

> @@ -709,7 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  err_ptp_destroy:
>  	otx2_ptp_destroy(vf);
>  err_detach_rsrc:
> -	free_percpu(vf->hw.lmt_info);
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);

free_percpu does nothing if it's argument is NULL.
So there is no need for the if clause added here.

>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2_detach_resources(&vf->mbox);
> @@ -763,7 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>  	otx2_shutdown_tc(vf);
>  	otx2vf_disable_mbox_intr(vf);
>  	otx2_detach_resources(&vf->mbox);
> -	free_percpu(vf->hw.lmt_info);
> +	if (vf->hw.lmt_info)
> +		free_percpu(vf->hw.lmt_info);

Ditto.

>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2vf_vfaf_mbox_destroy(vf);
> -- 
> 2.25.1
> 
