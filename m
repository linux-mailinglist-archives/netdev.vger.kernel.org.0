Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA576DBBAE
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjDHO4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDHO4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:56:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B802D75;
        Sat,  8 Apr 2023 07:56:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fX6KYl9PpOQETsfg8HNT5ur+0VCmYd076LUP/9dS+HVM1mrm9FFMeUriLUvkvIY3xXmD2Qnz+GFSGI3+UlOlc2XFZl/fs56Fp69fHTqH1Y91WGtw8hvb0rurRMTYbEo3J/50EWVPewU94fzplBngWsAxTM5syXmwNz1mV7K6B6XK3zwpH6+84rsRyU+GlBXuWcbpjvxxM34k89xykfHVlxx9cgYENAfVw9R8vCqCvE3z5qBahl62ztBYXRRXYqX/1fCCWXQTSiYoIjpCCz7PtbP3seVsssgY4guP8eIsaSZ/9pz1/ANpE0ryMv5kPDuMnw5nSlvxYaNis9DLnU6w5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1tXe25F+LYRcak0UW957qYdRRjW9fkSEuI8bRe/T+o=;
 b=WJ7XyDFiXQD+MUTU50wyyu0Vx/PDfEyQMe0E1Hx6H3b7BvbnyTlCF9J0rIWSEOfJQtGQgMeIoGvzyMvfz0wT8tRFjJFnDjnx3vFRR9A3+MumfBQ2BYxANCScHT7nt0gTPScSQYQZdXCIvjh0PC9ehWBIMGdYjeddiFLmeBOwZOVWlhmHSEl3yD10GJf5DU24yaBtZYK+itFtyPGaNcB7RafZx7yQUqp1C6YnSne4lSYIbLmX/8tlMG9dq36vcK4jJmky4MhwcD2d7TcKAbLfjRy9fBAusXGe0LzjX0tBPejj+gAY8sZv8I2TpAP9dPF4eYk3m5/POsYBQP9EAB4asQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1tXe25F+LYRcak0UW957qYdRRjW9fkSEuI8bRe/T+o=;
 b=WUtVM6SR8rLoEDAiVf4Ep+6o5SB8uogQ19HkZDxaSBl7YyNo8P9+xc917KwOO7Nzj39IPGcB/2uOCIh0J1kSIOMymcEROZ+WthsYnMhlqK2tfigW7teyXrC6PpwbEMZ0+m6pfdpCSWe1fIZxxEBUbte7Vzd7MU4sXPzvxeomhBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CH0PR13MB5219.namprd13.prod.outlook.com (2603:10b6:610:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Sat, 8 Apr
 2023 14:56:30 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:56:30 +0000
Date:   Sat, 8 Apr 2023 16:56:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 6/7] octeontx2-af: Skip PFs if not enabled
Message-ID: <ZDGAlpI+5hfcHe3r@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-7-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-7-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::18) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CH0PR13MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e8c9c2-cf49-4c15-25b4-08db38416ff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2LdlFgUO8tCxKLjVawuhVLqhm+xxHHO/WurWt6QiLsjinxRpIGvUoSfKERR5RNeH7iqIxrN0l42ZgE2wzqOk2qvDcGnTC5jSnQx3Xwtx681FBFkp44eUa7btIXC9TMWOXJMlHnNQSXMcvC0oD8Xe2OG+fAduo+qLiKj97kwFQAUi/Ctmrq1hyiAF8SCk8oTjB7fI/N7YAt5Wav0pCLL4o859O+CkM6CXfE1nmso9sqKXHQdhIDFoU7A0gfufc+Mza3q43VrxfC0VJqaLsw4+21a333AJWbbJ0H0IUtp4cB/t8+cK45arMahdv5ypLoq0V06w/0g8kUDzbF5hCkuWpTeE3IR2TuBqHJpYTvXYk9/drwX00Ku7LsacbKTfsX5vd9XbiLasHoAfqKQAuY/4W/+KjUb4jgUSK7cLfyr+dqUadvSANglbW7oGiUdU/8BM3pKVG47j+OW1MigoUXiGp9hChpEkrVezN5yhW6iV+C8IPgB5msH9YGApVFJKELfUQIqMJZ8H0mrqBNnHlc4K+T/5X03I3vVooFfWH54O3BMsWBFhiGZLD0691tuk8EWsLA3h8ZionMLOubunpEKEOq0cmAfXJoK0h+OeNKXvf7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(39830400003)(376002)(451199021)(36756003)(86362001)(2906002)(2616005)(6486002)(6666004)(83380400001)(186003)(6512007)(6506007)(478600001)(66556008)(66476007)(6916009)(4326008)(66946007)(7416002)(41300700001)(8936002)(8676002)(38100700002)(316002)(44832011)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGVPFQmOQ9UT8sFIhXwZQawWx8l/dBuKT4yxzSZwi5YyG8p0eJffk7rA8aVI?=
 =?us-ascii?Q?ux+pMtVSKefDUsif4WjLdX8N0pV75JmLFgu1mXWa8tnNyiU3i1CZ9yTGou1O?=
 =?us-ascii?Q?4dSG5QelbURTDrqOzZes3mreNSt+AvkzJMIw8qdVGV3mbEe5QUWubbcRMrJF?=
 =?us-ascii?Q?dUsLRmB1jU/+hpf2RTqv1skSLL8xD4iqX/QY9TdsDxif5nVXkEDXMXGArg9z?=
 =?us-ascii?Q?6FwZ0PkawRKHdQ2BU61Sc9o1DDi1PRjUTo2Tb3ydQSiTOIajxY23IXzq1FfW?=
 =?us-ascii?Q?65iUIw2PtZF1zlE9jNzzpWp8z6m6PTyv/y/cews8RE33v6EiJdDQaZvEmawV?=
 =?us-ascii?Q?sKyXVaVNVgi2OJC3dHrVK5cDshqGDvDgvHnXRVuMI4o0XK4pGzMjPdD4qyVF?=
 =?us-ascii?Q?F/1tqhH52FKnz4ONzlxgxWKUMVrAIigb1Hxvcuh7IApMXz7FO0SN5NKemqRI?=
 =?us-ascii?Q?Ule/Fvt/dvKsHovAQaEU+T9RNT9+GBiTfUbIURgjnBs6pRQiwZnajrl8iHEr?=
 =?us-ascii?Q?vxIHfr8hrZGox+zZQ95y5aqgeii5wfyGVBdWA1W58wuE05fqBteOkb4e6FLc?=
 =?us-ascii?Q?9h77y5PJUcSVgy0zdJBFisSg2MvwBrPQOXgh9nO+wUIHB+pXSGu0bsQtxbgk?=
 =?us-ascii?Q?+U0FnE+2Px9W073YEo9YDLmdGejXrBmL4aqgcJ8StCiJUdjejYHVCbD/izDM?=
 =?us-ascii?Q?E2GWWPjoDpNvSmTJWEKXaiweyfqrCFbpZNIS9VrHe5Pe6u60iy/1yB3nAjpK?=
 =?us-ascii?Q?yPDvy+8KMNIxN5nb0I7H2QGxt5eqyS9+kGjhdWW2Mqpu5hLfha1s7VKa8t0W?=
 =?us-ascii?Q?1JkRtaAwfsdTWqKLL/P/laO3obWHNJI+LINQUBR0s8edGtiXLxfs8s5ccBGa?=
 =?us-ascii?Q?4v4K7xr/ULLqaYys88546NO4TsPNVQYDxPGcvTfWtMYPG5gPNXOZMEM331zI?=
 =?us-ascii?Q?JEKgo4YEfgHRQY1TbxAKicwdNb+0684i+4Uf7li0oh8ByXQ9a63Ckdr249Kc?=
 =?us-ascii?Q?sKLlwuozvvI9NpACOI6Q9/qZxMfcceBUsXB0yGtoryfClNZl3PJMqbh7Kzor?=
 =?us-ascii?Q?HkengQYpzLTjRiCTT2PJVUBAk5oaGtkl5BATKlZ/ZcKRhoNF7RMIdTO6FrKY?=
 =?us-ascii?Q?DlhbxgIesqQ3HIGKTIB6lBKqNW8V0IMTsmZqtF+Wr/gRpUnmd9GK6o/atUZd?=
 =?us-ascii?Q?zJjTDwRxI4aJGJIOk9WLslRJ3wvk1BgVjpejHS2kp1V1o7vgFKRfGgY4hCU5?=
 =?us-ascii?Q?rhmP/nG14XLS5CHpFLF24kbISEs0+QrxV/0CDAdfL1nVyJzbpJV0LP6yEUgM?=
 =?us-ascii?Q?JdnbS+/Rkp+rt1Ir9tWlvSUgPq9oB6h87p5UE8umUkmlLtv2OwParMQXHX1W?=
 =?us-ascii?Q?cuU2+1FUj3kxe8Q8z1VgH+R2zhHUnJU4pPx/wdOTjrYEj2oMzSJnXH6OYc1W?=
 =?us-ascii?Q?xEVZSB/F0uCVLY2sZ2CXRf90cgqVXbg85GQXNmN7oabr1xv3WQhi9J+bmf4T?=
 =?us-ascii?Q?SeEaH80z4UMEW+TH8OSeTMC8BjC+J0AB4N83nyj5koR29+UtfB191HcTOmWQ?=
 =?us-ascii?Q?HG4hH7I3mtiO9afhKm3ndtctAAKV6C3b+k9w3BaMl17GO2FDgRaf/kihe6dV?=
 =?us-ascii?Q?VBYMnzlX32THPk06uYpQPYI+RJNRtF7Zx18U0Ut0iiEBKeB/fkTvemBX2mmq?=
 =?us-ascii?Q?safs9w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e8c9c2-cf49-4c15-25b4-08db38416ff1
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:56:30.6654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwXyA0QYowwCUKGXopwnptV7XspOn52jbnmONT/5Hh0GnFpGOtQvO85JBMCrGaxLWKfHP5JstOk+jWx28y5G+x0kegr0slTzwIESEo77FSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5219
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:43PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Skip mbox initialization of disabled PFs. Firmware configures PFs
> and allocate mbox resources etc. Linux should configure particular
> PFs, which ever are enabled by firmware.
> 
> Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

...

> @@ -2343,8 +2349,27 @@ static int rvu_mbox_init(struct rvu *rvu, struct mbox_wq_info *mw,
>  	int err = -EINVAL, i, dir, dir_up;
>  	void __iomem *reg_base;
>  	struct rvu_work *mwork;
> +	unsigned long *pf_bmap;
>  	void **mbox_regions;
>  	const char *name;
> +	u64 cfg;
> +
> +	pf_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(num), sizeof(long), GFP_KERNEL);

Hi Sai and Ratheesh,

I am a little confused about the lifecycle of pf_bmap.
It is a local variable of this function.
But it is allocated using devm_kcalloc(), so it will persist for
the life of the device.

Also, I note that rvu_mbox_init() has too call sites.
So is there a situation where a pf_bmap is allocated more than once
for the same rvu->dev instance?

It seems to me it would be more appropriate to allocate bf_bmap using
kcalloc() take clear to free it before leaving rvu_mbox_init(),
as is already done for mbox_regions.

> +	if (!pf_bmap)
> +		return -ENOMEM;

...
