Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D390C59822A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244443AbiHRLUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbiHRLUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:20:45 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2102.outbound.protection.outlook.com [40.107.212.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E7EAE9D5;
        Thu, 18 Aug 2022 04:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGc3SZgtUS5IzErK91MJGJHu419jugc73Jl3WcREXe7wMuU88JAen7yKhv60akKcq8pctgWEJj5h7AZ3v1Zu80pAQ1UIf5AmRGT254+mAwJrgp83+6gxuL1xraLEzOUF16BgVN20pET5k9yOivS2YQ+4Hz8X5NBzektbtU6c16dk4DxFGp4yCb+RSbBri/pFjCpzWt2sqlksRI60p6Dp7+AoY0Rhq6IXKmXVd8EC8xLA+CrhdxRJJRsXd+xNgUUhNg3QvoSBlNKwQGX+yZvcFfSAxew/Ehdc0ZdfTx0xSZYVk+EubbGh0m0VL2E8gNtPMciCyChSmV0C00AG+VZlcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEyE2/fkIa/Xa7QfO74Z1IOa7ObHNQ6WQKtwcvPDnPE=;
 b=eqq+X4MBzyOwIr95cTJXhfy6c07+/UHVc8FozsTg+MvxItVfdQwNsmYL3UdwENy1kvRz7CokCPrOD0JEAUNLpDCipY4HvR7wG+hByrvkM6JV7rFF5My5il17y4WEJW0B9hwb1oqgg0tPvUSWYEC4dHjAX4wgMEESt1ZzTMYYjqzSnAtBvDQb7CUkVjRXeIDPp1eiwgRlfCZlP9AoiznuReraN/1AIQjV2lLZWeGXokKuSNPfsvy+L1pc/O/3IrosGa9EOFjJbu+Rq+pH0tju0JwaqVIMzA5Cbo4bzKjaW0QGMTXQFPbrhD3KKvGysEePSvVQcuoXrYLMjv36QoM1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEyE2/fkIa/Xa7QfO74Z1IOa7ObHNQ6WQKtwcvPDnPE=;
 b=to9MdB8OvhqthRgR0+PLlKzfEmqXOJYFLfmcOQompDxLuPK3/TSxxj/bx07GSLzzU6aJzRRoI0cHJY+HtF4mKvJJxF2FSeqY/LAMS6cBm33T9/xFvDBhADNlxJw3Pzwm+rZ2cwwm30nMWBihWtmg42m+oCuAcVkFO1jTFk44Wiw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5553.namprd13.prod.outlook.com (2603:10b6:303:180::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.4; Thu, 18 Aug
 2022 11:20:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5525.007; Thu, 18 Aug 2022
 11:20:36 +0000
Date:   Thu, 18 Aug 2022 13:20:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     ecree@xilinx.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        michael.chan@broadcom.com, andy@greyhouse.net, saeed@kernel.org,
        jiri@resnulli.us, snelson@pensando.io, alexander.duyck@gmail.com,
        rdunlap@infradead.org, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
Message-ID: <Yv4geqG6r3OVDNvB@corigine.com>
References: <20220815142251.8909-1-ecree@xilinx.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815142251.8909-1-ecree@xilinx.com>
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe7c853-1b52-435a-45db-08da810bac82
X-MS-TrafficTypeDiagnostic: MW4PR13MB5553:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IikDb2DgdOITPqNUzA88/Vqunf7PFMYT/85O6pQMRGaqXAIONh7aCoa8kuz5788c+IaTPzGQ9CQE9iheMwSq1jNNNfVAuojkQALzzY27wmS84BZVjPX2+rbPE4Fsca0iqwHqrzbOjO71KM9fiTg+KhEB7P+073qUOTQCjKv78LXvz8d62VCf+z6MalS5lgS6bxVzZBZfZ+fTKWRxv9a6SXyCaEYowZOo2hBEeWoeCZl5cvx3oUjozTn/scVa8NM9X6pYIudn5/KLXlB/YZyLqhU3DA0tsqKMaYuhXkxfH+ZdBc8nEd8ZVNHJrCL6NmOqO6kNs4lerxHDlLS7zysmW3EAxb3ll6DV8kFf/wcE9pfaz7+UwaiV8c78GqMr3OiXUPbIWz0yJrZvUeOwyJwVl3oiK9xCDAVAf7NeKnZSd7+P3Zfd9R78aLcXTCkixta4lDuKYpD0Ze1FhAJZIbAlXRdpUhaM9Q0EEH9xZ4JCEYOqXNg1aiKK9T4ubUHSRCcQQmEfsrJ8P8qUpXPMh3uxFtobtyeJ3+86sgLHG5FcSmwSdPZNoYlJ7gqz2k2DSKvKnX2SyqB9JZmNy/W94rDvx8wu/kqrK6m8MzlEI/CNg6vJo7HocRuYGUhwmvdyBI38DXfNI3vb8Lno581rHhCPVktJrpMsrxKvf31kPzDC3y4dbMkRo0UEi4yils0Ot9kXBo/B9HduF5IBX8cw8oOjIbNIfS5tZRm20BSFVYObk02VlKIfSdWzLjDLeXagKCmc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39850400004)(396003)(376002)(6512007)(2616005)(66556008)(8676002)(66476007)(4326008)(316002)(36756003)(186003)(66946007)(6916009)(52116002)(6506007)(41300700001)(6486002)(6666004)(4744005)(7416002)(5660300002)(44832011)(8936002)(86362001)(478600001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gJNrq49dfEhb61Voe6r6iRDnNrpgLVYuebPwDR3JoAvz2SV//KJJFXud1nwJ?=
 =?us-ascii?Q?xKfMWSgSj38e2CqOmU+ZFO4zpGMSqQQjp8jnU0Xm8qapsW9D4hQLTupfZzN+?=
 =?us-ascii?Q?EGKAMbkn0drJKCxr7AW/Nsj776sHzKN7NeEDy7gNfyWxZQGYQvhOJsGCVUE7?=
 =?us-ascii?Q?draR2C4kFDYhU8ABuhzjeFtp2hWQwCBlKBierax2plwA4OqqcIT69ZpqfLM8?=
 =?us-ascii?Q?OQwfMyHrcDwkv1A3XNEZfOOu4YDD0Npa/7vzISkX6FSZpLfAHrBnFc2keMI6?=
 =?us-ascii?Q?mnBZ5XOswWU2JbccOinjjUtFwY7xV7t0em5MJFn73MfqvFaUHvStW6Kct+q9?=
 =?us-ascii?Q?rT8T5ZSW/4WhJyzY5zAy2jHjogkp8N9ySETtrTJJv9nio8G2dO7O9nYCY8gK?=
 =?us-ascii?Q?hdwga9WWbZ02oDOJPQ1o/dqlUDlfCba4lYfJ8BCvsmKZuGW3rR667naNxvuq?=
 =?us-ascii?Q?l9tUxK4g2MfKLhA6gxsbztHe8QH+IYl6nPkw9mZowEks/R/Cq7G1JX1tUuSA?=
 =?us-ascii?Q?k4oH18s0tf/uEZXo4UatdqUge2it2bedjsqucOWuMnn7WcaenzOoqqGbO+nA?=
 =?us-ascii?Q?NIDoQq5SH1QodXTJx0FEOoeQ1NITxFaOP8p00ay4B1QLd44hx4ELOFnqmZac?=
 =?us-ascii?Q?3R0PM8s0vekrMsOQgvzwJcTKvpH42iQN9WFRDGTnx7ZnOeYcprdkBlVl2Fgh?=
 =?us-ascii?Q?yf1l6WvUkoKkdhXmFrMYqnzr+joY+1citnI+MgB0oXSVgvmI0GDwRtDV7iWA?=
 =?us-ascii?Q?rIidWissNYQRtxcNk/9jB8wD/U+aqf/Xk776QqqSfsywmHY7lc4K15/BHh8c?=
 =?us-ascii?Q?PjwVBDF2Xsjqm05M29B3/oqnqolfuPicr7VGkwbQ233+LOOaODII9OXRKGA7?=
 =?us-ascii?Q?vi0B30HhMCaJDDEIckkEQ8zAMOIy4Kr2F7Cp2VSbZTXMQj6We7oizQeWNnzk?=
 =?us-ascii?Q?XfVHfM0RViHaIBq04xKIC4sw+LQ1V4DYTXwC6q/a/vNL5IjdeFkAa8zGQdYA?=
 =?us-ascii?Q?mx3oWJWT1db3908Gov4wAcYwDvk2JCDGqDE+xod2UkNIvS0Q+8TAK3rD3L+X?=
 =?us-ascii?Q?oQkDamSKNA4PVrNLogDWKamDSEyuNvsfOwxZhgPV82RgGA7LsYJ9ueCE2p72?=
 =?us-ascii?Q?FyXPddwzFAoKgG/Q1zw1Qy/F+vfR48y0AWyyr3t/HHllvDYru2m3CTA8Ze5E?=
 =?us-ascii?Q?z/pQsEXQjUI2JQX4mQcMQN8EFSVjH5E0X7mJvixFwJfcOZOjnS6SP73FawKc?=
 =?us-ascii?Q?PcdGYIEURr3h4msobZZ0j1aaupFHEDXPzmhsn6D5Ne0bPYTdBlU13MsQcw1H?=
 =?us-ascii?Q?67TDBgAsPpcFfm/aNUBqeu98FpXZnbUC17uRpjRmQoQ5e+7np/oI5uXBGwGm?=
 =?us-ascii?Q?ux0WDEtTmb1fWagtz43yLKI7eCMXIPW+Qz9tM36Ce3Lr+diO4sDOoKD7BGMG?=
 =?us-ascii?Q?EfbuP28HlyiB7VeMo7sA0QotvbIN9dOBI25Tl2q0euaSZVJnPOPucru2+c4F?=
 =?us-ascii?Q?cySfcWkliYL+b7D8oCWJ+gkphfNXFqbGqTtLOtBXBCoB8sCSXjU3iGfZkG22?=
 =?us-ascii?Q?n2bgzeVpIgSVKVMdqvSownehv4xrfvd1QWIwWkclTkP5c/h/9fJJFiUQyZ5e?=
 =?us-ascii?Q?XRQ33lhZOLUGpiaTngUkLBIbj7aOlZ58tF+4OiHkuKjesZcYC317Z1P0hb26?=
 =?us-ascii?Q?Y2TeqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe7c853-1b52-435a-45db-08da810bac82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:20:36.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXIXcU3sypkV2ARDqDSzPezSzLvoteSbi9xVsig4ET63N4GROQqIyA+4bVayexKYK6toYtlJdIGx6NClqvZCNkMwqPwGBvcelfFt8ONACNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 03:22:51PM +0100, ecree@xilinx.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> There's no clear explanation of what VF Representors are for, their
>  semantics, etc., outside of vendor docs and random conference slides.
> Add a document explaining Representors and defining what drivers that
>  implement them are expected to do.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Thanks a lot for working on this, it looks very nice to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

