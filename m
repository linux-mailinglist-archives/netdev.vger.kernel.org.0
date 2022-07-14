Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A59574713
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbiGNIhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236882AbiGNIhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:37:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2095.outbound.protection.outlook.com [40.107.93.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B5E3ED4A
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpO4VPZoPEjlF7/wGTz3Zto10GeScqpkhfBu7EpQv6NyUkx3ssMsrFY7Iqr/LXgZeKXEcrFnWvp8ESrWHnFCYyGaVbVDy6JMnFmEXEosagSBvC/CAO9vSCc9OvlrMs994scTDcA8OVGu2DNhIF/hFs9SpKaLwa+/1JhDeqLmH4zNpkNz5PEY09f9JAxpiGfWphXfD8neLgWhoMQDmaIt6LCV56F4rkMqB8oUATxX8MBv566/drnmA9ud3kyou+Cz6ThnPuoZRfxH4tlmNdRIa/uGf2CmOV/v6F4uBrBfzjilTZ8Vd4hQMQbMaQ2gRgxOjO9t0LvddTgYaqG+hzaNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGkxoFOjole82Ss962m5URwBWpiTkm2Vq6qZJ/06dkM=;
 b=ENfXlQ8uJDw6OqnmL0WPJ1tKvrIJY304/oAeUHHQu5BJDBJ9Ot5tWRrKsGbptMnrFM4ZCfHqIu1U0mOYEFIWf3LvGlVd19nIHR2T0J45Q1uczQOB9DCvdIycb+RoWZYTF/O538ulwyyGT6moXfqzYgOwV/IRQJQyFuJJttgfYzS5T/El7HwZO3CGMwIj58MjH3wYJ+8Ji9E13TJ2UYv3GuKL7BWauA5/O/OfmJV3i8lGoWeLGEKnehgpOCmQl+XwN0xvxCRmVJOOhiFz92pfejMTEIyi8mT91yOLJBXWq2G2GXLylOzRWabxY0/x3ExwFEQQ8yB1mTyv2ZUTYZKMsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGkxoFOjole82Ss962m5URwBWpiTkm2Vq6qZJ/06dkM=;
 b=OVDYHFMe1yhXoYY7Akdv3SZdU4u7NohSFMHzM8ccbiYzW3V/5yd5RoUMAvwbKedV7iPuqR9/8FyP1Ri1FHV9LrVUNpAmyzRKM6a23z31Rm0IsjmyFqXy9N6Ccn4rWSqscYGHV7cFHPOtoAKjgB7c4we8xYUC4jGqHREriFb9eoM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB1346.namprd13.prod.outlook.com (2603:10b6:404:6d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 08:36:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%9]) with mapi id 15.20.5438.011; Thu, 14 Jul 2022
 08:36:58 +0000
Date:   Thu, 14 Jul 2022 10:36:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: flower: configure tunnel neighbour on cmsg rx
Message-ID: <Ys/VpbZtrJ2JU7eg@corigine.com>
References: <20220713085620.102550-1-simon.horman@corigine.com>
 <20220713204100.6fd9b277@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713204100.6fd9b277@kernel.org>
X-ClientProxiedBy: AM0PR07CA0029.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 914eff90-347b-4b9b-2a61-08da6574042c
X-MS-TrafficTypeDiagnostic: BN6PR13MB1346:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+7pAGoTRYAV60+jf/Ok2nmCzs4REko8dib+R4U+zo2VBEbU83ZPOkXssov9W9oRfjot4s+vWoby3javKqtxhNirl5AdzeZEzlykCE6YpumR028+OcHNm+SdFaTkk2JbCBb75WOt7Lql2FL+m70uhY3gPZKWQkN5yCRun6NzTxvHS002mWrWbUO/UnBDfV9nEHBO4FQiflY/JnmEBkG+KAnaAcybnVpMvy0LhFuyOJuYpuatJ+7VE5pnv3Ot17MJL80ScZgqWULxJRR9RPgBPqQ/q3kT7diQueClUQUGh7W4rGofnDZukZs0AU8Mf7dvKcn6xfYPJavYNryl++CKXnVvr+LWZv9SfePtQ6SgFc7C4LTkpsSTqoCtKF8hXPnbsNg+emBSFL3bQU/POg7FKVkXro+5vCAFd7/of/6rrRD2dQBnYJJvP/JQkXY7jJCg4ZOituFD36ktYB7zrbSah9SkPveVq2r5CtTPuz3sUkXjGJZ3anvsjco6yLyeHHalCv/LzO8IsVJdnpYPlAGkh2zSlI9/FjPqgOz2jh8IcU3gMK5fRhpbkNAfDlhbMRH0zSWfqHFq6+NHjkVgfXq0d0xkBfCIdhfegks2ujH3MlYxiHqEhqFsTQaBqUiOWnHHipGcIxORSdm1Hi6zz/HOTGi5TipJfZr7QiO8ZHx91vidE0cwWVor75TRrHCWqy31KBqzv2Db6khGt4JrU/OhQtnWDpe1hhZnSt79ea0AxiiET63uTMdkyGQY+O+LKMI04HO1OXtGsY0iORLq0guCkCiDavj7Hq/KgagdGihDO8YYBdyFuslL0GKQpnXacf+oABaH7Nx3so5dA20L41INzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39830400003)(346002)(376002)(396003)(8936002)(4744005)(44832011)(38100700002)(316002)(5660300002)(54906003)(6916009)(6512007)(107886003)(478600001)(6486002)(2616005)(52116002)(966005)(41300700001)(66476007)(186003)(6666004)(66556008)(8676002)(4326008)(66946007)(36756003)(2906002)(86362001)(6506007)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?028cihftcKa4Q/Xm5lD7GwcXxLKqQrEt5YeSQqTXKrMBNnt+I2O4hckrMcwK?=
 =?us-ascii?Q?Qes4e4OW+Sc61k/Pwn2lnUJRquvDbTPOOib5zIxvZRL2FDscYqWEjlVUS3TS?=
 =?us-ascii?Q?0gY9KYf1Ioe0eO0I15WDSB3k9lndDSUUVEs+ITUnlLtvB7Jf2YnlMGVfqhp2?=
 =?us-ascii?Q?MahPR9pVvEoExJaPZKwzip99WKEazhqQbgJb443eOHUGG3npze9jO7ReiPQ2?=
 =?us-ascii?Q?nLUgG+kMafwqYak6SroyA4y4fUyALzQg4YzEh7DBH7d0nCiW3DJn2WOuZVtV?=
 =?us-ascii?Q?MY+bwQdVGFkW7tVDopMhqkd2MjtmksJsfNI1wE3/6Cx6FrOhJPHJVdzMKsvJ?=
 =?us-ascii?Q?9CCpkBvXPG2UR9IdKIx08cmY6OJp3gOT/bGzmChaFbNlYa1gmwDRGhxLKdYh?=
 =?us-ascii?Q?5u02xUJGP4SAVkE90sRCoEBnm+t3KcregNX1bjggdtQHXwXHR3xqmaSoLKIg?=
 =?us-ascii?Q?/WfqHgdAzmSfvBEEeGZNef2nHVLVZMKwjykieoOBjwOjEGzZTWaE1qHZPFT7?=
 =?us-ascii?Q?eQH3BxGqmRyHOxPYOODx7vwrxwjB5MnrutpAKtI+OeGeaekUlxTHjrlCQkzW?=
 =?us-ascii?Q?i6OdFT46BwYz2sE7ECcrlm5o6cwmFgTrASVZUO3kJoW/CK9ugUlatqKFzGKx?=
 =?us-ascii?Q?NdluWlfxe3VOKnw2+vJ1HJN81R+4QHG62Y/QmPkE7P/JmRhrGcn2WLwYYzA4?=
 =?us-ascii?Q?a0vQy+gZFaEFsqaLCgGRN5pUkpA/kMqHZbUQfH6ZgF7FNRxFBDeEhaXT/vw5?=
 =?us-ascii?Q?zYKa2neU/2zEwKzdgOCUCMaTLPBbmX08RJJEnNUrl8Bc6E9Z52ZeUVl5bxBb?=
 =?us-ascii?Q?h/bLPYIaGmjD0ez6ILonftoCEhoJ8BTVF2S8laKEaXcZHg1UFqco0raZy7LE?=
 =?us-ascii?Q?6aWK08bfPJStN5b5aocN6eLe39/unlTdZxr0Fm17bir41kcYP9NsuEAMiMVw?=
 =?us-ascii?Q?wlDqbnHf9MVlvXQfscTQC4P2F2mOtoXLPAyNWMFDvgrYDJd2/CxJGB1AOnxe?=
 =?us-ascii?Q?mf2td+/wrdNKdS8T9WGXlSiwsj+/ZZt1lWEhpO74sCBhUSKsvleKmhQq8rH8?=
 =?us-ascii?Q?qCNSLkazS2KD2pzeWT90NA+ZFM0Q65bEHtAuV/5kOn4F8ms2cscSA/EVxGnY?=
 =?us-ascii?Q?XG/SuwhxZsw/GhJ5dMySrYw5IHHJN/bfC/qYpnRJdtzim18acK//2pjP1WnE?=
 =?us-ascii?Q?mZ1KWbsDugSmFMaasEybd6OB2KuA6P8KZB6/tL8wRY21KR35QVlwIUO4I2uI?=
 =?us-ascii?Q?1EMLzgoPUfODkMFBJlhqQkq2iCY0bgSWx0TsIB/qypY1KoZbeGbMJAAOnF7W?=
 =?us-ascii?Q?e4Kmkd0TmTF/72uM0j/jNZuVTZjPVoV3Qdlj0rvkGqioEhg7WUw/zyx0e0aB?=
 =?us-ascii?Q?jueqPhvrbQSejmtLIoyFOTKBb8ryntvFdwA0LZAxhAQ7oFc48+nIUVuidSMN?=
 =?us-ascii?Q?g4W/VQGBsh6lcIBklVxRy+CeoD3i51HOz0AXZ9Wh98tv/4Ti3DD/YUvEnLiq?=
 =?us-ascii?Q?KylhBFJUtenHzSfX0h4BiglWSM2IqqBBHHJEQD95jF9gZ2k+z5j3ESm5nbnB?=
 =?us-ascii?Q?l3Q+J2e0S3s65jnfuMTCzlDNqp15tsixkENZtRv+v4YYW6EX3vrG7oW/efI9?=
 =?us-ascii?Q?K8QjhSIcvB/H779g4GSh7Wvxyxm544YLW9PWjR14unf6Qeu48JSxFxE39Dhp?=
 =?us-ascii?Q?beNBjw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914eff90-347b-4b9b-2a61-08da6574042c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:36:58.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nHnZBqs5e3BhsWA40VYuWwlGK9VGmf6RYF2HYp8HMyfNVXMIQjHyzM5lxiysXM7ic/8gUV36xVu6yD+XT7mkY0VrC89YzH5tOAz1Vgxt7og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1346
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 08:41:00PM -0700, Jakub Kicinski wrote:
> On Wed, 13 Jul 2022 10:56:20 +0200 Simon Horman wrote:
> > From: Tianyu Yuan <tianyu.yuan@corigine.com>
> > 
> > nfp_tun_write_neigh() function will configure a tunnel neighbour when
> > calling nfp_tun_neigh_event_handler() or nfp_flower_cmsg_process_one_rx()
> > (with no tunnel neighbour type) from firmware.
> > 
> > When configuring IP on physical port as a tunnel endpoint, no operation
> > will be performed after receiving the cmsg mentioned above.
> > 
> > Therefore, add a progress to configure tunnel neighbour in this case.
> > 
> > Fixes: f1df7956c11f("nfp: flower: rework tunnel neighbour configuration")
> 
> Missing space between the hash and the subject.

Thanks, fixed in v2.
- https://lore.kernel.org/netdev/20220714081915.148378-1-simon.horman@corigine.com/
