Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B150A6CC271
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbjC1Opd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjC1Op2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:45:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2095.outbound.protection.outlook.com [40.107.223.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CDCDC0;
        Tue, 28 Mar 2023 07:45:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0AdlAncvpGclxXzMrd+rnzRKNrv0NkSpcASVFvgtSylGsNX0mS0CTcRPhqq1korNceWWPO0lliZUxBhq18jylfNoCR0nv/3Hm9qZcGv6/KvqPfPn8Byd+RyW2g8oWKxRrLzqe9btK55chEFLsWejNi0PbA1fYhrDZpi7tMCGg2gTMDz57MtixCt7tcStT2CQRa+gpYDtmIQSYH5mAhJBTNbP4rx3KiZK2gM/3qvWx2lq0wEMqj/XOlPMKrGcxVWsZcxRZpMSkfEIXzZ4OPzKPVqQk+fOm3E1TnoadSca1CAmpF2+NJB5u3UqxK1CNygN/iMiqmDk1mjo2EGPXxczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6tSr0a0QEbB5eEoP6u2RMAx6F1sSpQqQlC89fvxDPf8=;
 b=aB9BRpprfOelBz2nn69AAExt7Tr/Zn7B/yYPY4ScZK+cB8Pg2e5aeXahk7F8xdd09pXQbtPox2d102wIFcLlKQ8HuqHdReD5lmNvnhnb/HhAyCQtzuP0IZ50m18/fBZ0xoX1tfw27hsgRJF85HXtMLYXLe7d8s2Rn+0e2jnxdb5DHThwEckQZj3uRClg932PdlPvIw6g0EdQ9oVsdTL0WrBdMTy5FYZdOT509EN9qFK8RtHoVk+u6sH3De9WZ0+qUer8d19GI4wd+OM/9huS1kyMCOdLwswnTRA6EyUlF23FRAzwIr7klQTAlbSOA5KkausmK1kdgqhUSwQLg8b7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tSr0a0QEbB5eEoP6u2RMAx6F1sSpQqQlC89fvxDPf8=;
 b=PT0XcMKTn4ksRJlJkr3QjfcavltzqkN24Kr3QuzSio+fj+2F+dzXmvZ4VsCmSRHjqn6A2bHhjxa82antR23P3OKS6tBbwOJAfJxGTdudCc7CDvcqDroThrgNg1dlX4qUaABEh2d1+aDIZjpjb8MaChmUqRz9G2GDLD/Tbfi6TyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4635.namprd13.prod.outlook.com (2603:10b6:610:c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 14:45:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:45:05 +0000
Date:   Tue, 28 Mar 2023 16:44:59 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 4/6] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Message-ID: <ZCL9a5kXqMCx7n7L@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-5-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-5-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR01CA0166.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c15ac5-0a0a-448d-dfcb-08db2f9b0522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lLjn98+5rSRMIplNL/rQwFzj4bS46bVjh814+0y4WW0wFmFNQzTOgpMgQGhAy3HEgDwkS/2iZBUf6Y1iTAYcELLuiekP11yTYSkZHk6ehp/Fl9VlbFLtELzfd2WigIwBhWpQBEbnXMtOp+cYw+zyFvKn9NaSiUeindaJwXxLFcHLmh2Up7yTDBEenl+cD9mOycEpNFXUkBUn5KDjEGQXHpJA6g0rmGVtd2b7eSQig8g5+XHJfMgLHh18zPzLg9yjg6DovOOhnjvsHAvZRIJFP7uJrFCBbpgLrb4ksK5x43S4pCcxMW3AnJXYVKt6AYT9MzpRJT9uFM2F2GE5xFtmgejPrrx4P4HQd7paQEj9ISexSXhgW8wB6qedFykBWukAElKmFgZhfub9Azib7ttrK99rF6JTvlSo7+kV6Qi0l/JcThabdOj20gFA3CNS4DcAuEyJe4R/vI8Z9OzuwNqjXhegidnovlF0QJixNb4Dv4Vd8pR2eLFXNhOGADdLjskppIlHe94ThXbPPejIpOMPtQiIuNUisFmEzyrokGG8YujbMwc3WgOZ4LhttHpjwqku
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(366004)(136003)(396003)(346002)(451199021)(186003)(6666004)(316002)(6512007)(6506007)(2616005)(83380400001)(6486002)(44832011)(478600001)(4744005)(38100700002)(8936002)(7416002)(86362001)(5660300002)(41300700001)(36756003)(66476007)(4326008)(66946007)(66556008)(6916009)(8676002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fl10f2jP9tFLdcRdPhLgHL+qY+nJRr2JXqydG3rYqAIVNHIaDKcspV2TmhLu?=
 =?us-ascii?Q?MiClXriXp16ur12asc/87diJqWbhUc5Fhf1msKr5T6MIr2cmhxebghprk/gf?=
 =?us-ascii?Q?E8Nnq99vTdk8r3yLLDI0ZIVwrfnXgNJL0wjl86trxDewVCHzqOvEAEMrhusU?=
 =?us-ascii?Q?7ZUQc6Np7PmfjdpwnjO92i0uVBIF09X3bx3loxCvLZ6UwUyO8DXZXZm+NRWZ?=
 =?us-ascii?Q?Zb7+SGwjEWynoXPQ+qGVrvPG+weeLi2dCrEUbWKeYr1n7Ym98RKgwxrXZQaQ?=
 =?us-ascii?Q?hB9fMwe3FOHxm8P0WpJcUiJiVmU6tzOOJLjpairIKFRTrfGYh6Eq91mJJPTr?=
 =?us-ascii?Q?CxZVDJHwALCFBCteHE4tTUBJvtOSX4n8LhLEEuA0k4HCoO/WsrEpSdgwQRDA?=
 =?us-ascii?Q?8Quy0hY8vW4R+H4jDayxbkfoMvN0HTq9nFJzkDDw6jFXE3drWxNSTPIm7GP3?=
 =?us-ascii?Q?Z1FeemJwqUSD0KWRfZiVLVyiPWgj9p9rhelwacd69DqIWo4sIVgkthFFqyYj?=
 =?us-ascii?Q?/1DW4+IVRFljvK3csBUKi7zn7GaUArBwnaYNQt8EnCkwgNWKRTqhiIYNo6Tc?=
 =?us-ascii?Q?gTiApEDDUcCNjln2mcDqFXVTHgnGb8qx/9B38hiN9RrR/35FChNP5P+p3JZS?=
 =?us-ascii?Q?/aLaM30BAC/p/gYe+7kg99eu4oTf9zB77B/zgPwS5jmjryiyYBbO0Z1n8gFt?=
 =?us-ascii?Q?/pqxz3e+/zGDEqUWd9kvftmqG1KXnP4ppAOT60QetKvXrkBhMPuHssUWJdKi?=
 =?us-ascii?Q?Vb3S5qfwb2qhuqCRKZExs1aAEgurgO54JMaxV+v7ZcZLfE+78/saE8Q37mra?=
 =?us-ascii?Q?UunCz+qEFhvxrtlpoVOCTcolJXb0XH3dYrQSC4jJPEWsgtR9hKaeilyoja4U?=
 =?us-ascii?Q?hiyKhcsx9p7jMFrOqdLO2Qgu9fVAjqwEXnkQwoG1E81ZCKz+l3iLm1DWg5kT?=
 =?us-ascii?Q?MSUwwLxHPEuA7M4OZL31Qi0v5k7U+w0ZQZ4t2RIm/gUIXjscJpGb4CvWfIH6?=
 =?us-ascii?Q?wbc9AqaKndbmN/MH7fRAffoVCbk+tki47F+iwMqLQkHYOBFrND2eUAX++G/H?=
 =?us-ascii?Q?KcCs9FxsbddJoFidqwYnBZ3hGB8lkQWYT6lhHazFl7qRRx9nyGyJlMIX0kC6?=
 =?us-ascii?Q?74Dgdxv5gowyqsFqjGT8/MHocVL/g2+TvLFf3AVuz0+gzpwf5z8b9NxGhR9G?=
 =?us-ascii?Q?uxL3uhE/lfN+fyfA2UtrVaMU9p5DfcxZgSAxx5UkXrB8HEuTdcGXVXTKU39q?=
 =?us-ascii?Q?WPzloqn3m6TKJEyKwXpqUztZQXiBdVTByrPhnXZ0FOK2eLPX2PDh9FwUxv1F?=
 =?us-ascii?Q?9X8dXF32NMRo/zl1E3IKJzoK6cdaAzcNQTfCsC07mryz3gMk8Z+7lTXzjORw?=
 =?us-ascii?Q?NfNhAwE/DcY2D1SKnRarPUoqFeozyDNs16qG5dmvZf/NDo7+2NuDv+9uL+L4?=
 =?us-ascii?Q?kieoQWVGWZPX6Q6szJH6DykJ6NCdki6aDEsVs1/FuQioWT0IagnLgekwLvjS?=
 =?us-ascii?Q?/xwHNPRnr5MvY7RD/AuW8zSeguHckwzcDidUdxyJe/D7E0ErDeUWesqEdkXG?=
 =?us-ascii?Q?/Lf4R6u5cx1LA90KbEyVqXI7XJMX8OinVvb8eHkxaYaxkpCHMNSw+G44IrPU?=
 =?us-ascii?Q?AVEmzPvBHI20E5LQdIX+zM5szOVz+ChY0FBTx6Gd2FZwQR6W+0EH5Na06gxh?=
 =?us-ascii?Q?koL/gw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c15ac5-0a0a-448d-dfcb-08db2f9b0522
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:45:05.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBK96AksLaZjC1lkCxpfcp5NxHnLKJMI95Vfv74RloU7fw2crLjinyPT+FW1M258cV8mIdY5Kr4f+8hTTrbq0jqldddxc/zHw77Fy2mNTD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4635
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:43PM +0530, Hariprasad Kelam wrote:
> Multiple transmit scheduler queues can be configured at different
> levels to support traffic shaping and scheduling. But on txschq free
> requests, the transmit schedular config in hardware is not getting
> reset. This patch adds support to reset the stale config.
> 
> The txschq alloc response handler updates the default txschq
> array which is used to configure the transmit packet path from
> SMQ to TL2 levels. However, for new features such as QoS offload
> that requires it's own txschq queues, this handler is still
> invoked and results in undefined behavior. The code now handles
> txschq response in the mbox caller function.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

