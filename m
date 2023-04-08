Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C236DBBA4
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDHOmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjDHOmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:42:49 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD68CC13;
        Sat,  8 Apr 2023 07:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ohBVtrIzvzpzip9agCEFtUzxVMbeA7CoqK8cP0xA/3acasIRkFx+GOom6AIlssSJgiFMiq1UqPD5m2yAb9ckSh2p8mqeYTYqbxAw+WrWEZRVeUqzJQaJj3Kz6DwL4nEzM9Ek9gTdIfC5pI8lrBG4lfTpl/CgBRt2cRb1o9GkwLhss9X2DoaxgBNBlVWbHiNMG0L0IdgyHXRqGrN1nEtp1KcGBpeE266h3XB/WSBHbnlnegsUlpSESD7fUqLb0/XNp6vymAdwxthnmrmNRzRpff2+86xy9trbll2QArL07V9fUwr+TXEovYxkinE4ZMbBM6G+VwT60jboyA7ZbkSbbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GCC53jQYgFTn7p3phbtZNd7doiDwDMEH5nQxwjkHRU=;
 b=bh4K9HbrNkXLhtWSgD6IIVUjPFeGI+Ut443l1SvDss71NYwFVgC1Y8J8LjxLuCeHtYJXCVftOKmRzd1uT+E848w5xMNSkU1vDXrwaAQvQA/JkktioNMKaXcaIKFczPIbhFHspM03l+mu8cMl10FAGcSOfUqxOTcEIrQc4PEnHZFJEwqUt6esf/DkVkchNZOnMH2Hxc6mylUAp5BimFak4Hhgh3zTkXS5ypceZPkD5Q0xwY2Tyrnc1E8Cu+KKnuf7Ecaxuyu0/VM8p3wI47k7JFxvGlF9F6KiiCxXlJ/nYSC2xBda9aV88rpjz+qnfet7FFjxuj9L0da+moFrPCZMRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GCC53jQYgFTn7p3phbtZNd7doiDwDMEH5nQxwjkHRU=;
 b=k8JW+6qrP6cbnbhSNxsvo9ncOFibRF/XhEVN52PioLAnyYhb6NvDiZFU9uQNsLiMfsDMZJ4cyZYPXMOu5qydMPvkcz7/u5bql6CEysCnbYpC63AegOdACK64ksVzbs289N7NYW7ii0la4BxZSKomqolbsM/ahiD9kdafio+Vlrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by MW3PR13MB3962.namprd13.prod.outlook.com (2603:10b6:303:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Sat, 8 Apr
 2023 14:42:40 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::8e7a:5558:6bfc:85f9%3]) with mapi id 15.20.6277.036; Sat, 8 Apr 2023
 14:42:40 +0000
Date:   Sat, 8 Apr 2023 16:42:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, richardcochran@gmail.com, lcherian@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH v2 3/7] octeontx2-af: Add validation for lmac type
Message-ID: <ZDF9VsgHl41cL4wE@corigine.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-4-saikrishnag@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407122344.4059-4-saikrishnag@marvell.com>
X-ClientProxiedBy: AS4P190CA0048.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::21) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|MW3PR13MB3962:EE_
X-MS-Office365-Filtering-Correlation-Id: eae1e2a5-d47d-4ee8-35f8-08db383f80c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWToYjg8yvYM5jnwJERTc3vlccFcdiv4s/jLVtssRCoJGAI4NFRHIhEULeWroE6KBSeKx7Gy4v1Cxg6lI12ZeXdOw9OiOAt1ljl8Fb3y0YP9FZU3j9qUJzK+fUzJ6LfSACn4ryd54ohgmZPkdw0YzfsjmgjhSN6LNP/g6O1eMg2oWrqHCYqryy+gKCUyf7ihB3WRSigHB9uIQgSlLXG46FUT0/IDCTIVIhyCBfv05oVPSpGVlJAgtv6l6+FHbColG1OorqQDCTSUftabnZrnkz8hwj6VZMJSeD2cpNFBxib+d3DutAyYmntVAuqqNAWLOLINz/NtQNrTi9EaVsHmYJqupmw8FyzFFZc8Vajd3bRRSZgGPrirLemcFkDkGG7Mz6BeFzPkt6IIHEhawRGbi/oE5sovtWO6BGzm7EUini4cxdn4ZvZIEOQAWhlEbCSZS9vu4sk7WJb9HNI3/Fkqwr/O2sSjPA8t+Ssno52flreAW1MyZ6dl5211KpdvhHPw89ZXmg3x9SgNyOPzq9wdyqp/vGW/SGEK+QUm14yMHfOIPBaHAWHNT0sYmkWKdX+um1I8fqCzYWmh1dlVebAhjIUXVOyfxVUHEhabuJJlqj8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(346002)(136003)(376002)(451199021)(38100700002)(6666004)(186003)(6512007)(6506007)(83380400001)(44832011)(2616005)(2906002)(7416002)(5660300002)(8936002)(45080400002)(86362001)(36756003)(478600001)(6486002)(66946007)(6916009)(4326008)(66556008)(66476007)(8676002)(41300700001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQtkQHlVJlm9fyuSldr5K5HuCmHHvGgH0YxJVJhJ4PSggPLYPGXXcMpQ6miR?=
 =?us-ascii?Q?7zAStlwyw4ZjmZg6AsvsJrI03dKc/cq+ZFZoTO6Zlo56elWj9hrxBj2w6kqv?=
 =?us-ascii?Q?6XACKjdnTChoBU8FV31N5OQ66VyhIVVy8w3MATjM+A9oLs6btTnJHz/DEDeD?=
 =?us-ascii?Q?YCRfHpqCShSX1VcS9w0/sQq/7RhRzyJNRDKmuvYqKJBMZBFstdq5tVWTajsn?=
 =?us-ascii?Q?4qo24OCedEFdBtVzgQR0gV4PTvvVDVEpTG74Vmlms7Cjgt5+kT2aDHV3WoaQ?=
 =?us-ascii?Q?BPb8TGfvTOm5vPoMwMV6ezc16PYutv4A0GNZp6q0Pfq1ckM22SGwd1yZxi81?=
 =?us-ascii?Q?4fIwEXue5ye2EQJt34mNskdQxrz1znY2YSav83d6Eopug2CulTnXJi6H0lZa?=
 =?us-ascii?Q?GO2wqKAPwY3+6+noghhmIukLRQDKdwbYvqaUJudDOx3IKZOCuSHxcgSKor+I?=
 =?us-ascii?Q?k9u9pKgj8XudNhVOpccurVSCXAxTg+i1R5k9OX7VnE+GFZ82s0vyI19st2HX?=
 =?us-ascii?Q?5uWXO+NYqNTImNwy2zmjzaLPpZJYTeopEEJpweitGVtT59eWq3AWvnkVFx/u?=
 =?us-ascii?Q?gFlD9/8QqvEtFXJZS/BiikBsZwsw9/W/EIm8K9VF7ciuqL0wqMy6Dv2XRWcH?=
 =?us-ascii?Q?91AqPMzpZhgZdBxoM9A2AgqvWQASqSFkuyxWJvkEhiFGrp/nr+iMcATUOfoL?=
 =?us-ascii?Q?bH+/DOLn3aTgRpdgSR/VjH28/f3bJPNLLWtsEKWttzBnFPzDuVFeb8z3XSWs?=
 =?us-ascii?Q?7cJjfCNmk8N5HIUh15ElCKhvMqDwNrqxRbeZqKvaGsiu6DQFe862KCY26kK8?=
 =?us-ascii?Q?vIJSkFabJ3ydq7vPocaE1WMypJYClovNkMvXqW+Wo7a9BQrmRgow1QVwLV3e?=
 =?us-ascii?Q?xIM39JDbVWPStSOU4rZCY4Z2qr05vAb+FuRta7J3xHQ5FcV3tYk9TZXYAg/I?=
 =?us-ascii?Q?4u+isGj7d1UW63Pd1BQ+Ms4j6vvHgO+U4jy6aT3UPVnRJuzWf+Dcy5TnyIas?=
 =?us-ascii?Q?VPpKezjcYrORRxsQ6wenFm8actmh/WD+s3ngGEGNeVyXtkpoiqD6W8mV0Lvr?=
 =?us-ascii?Q?DrsY5PAoUNv96Xb1GXhzeEkVpIJEEbDbNLuKE/IZi7d6wAcDzAj9/v4Ccj9F?=
 =?us-ascii?Q?nIf+bl8IURkHDvzFFjD8A5qt1FZd3eYH61oasEfDd/OJwfBNvG9iWTbfAtUd?=
 =?us-ascii?Q?Q1L+MAM1QFSO/4WSxopt5Yb1AZA6dullybLBCDebmq27A/renlTY6e6rieXw?=
 =?us-ascii?Q?3VpugmJzrBQOzlL2qo/I0iw4HpCdUwuKMsIDJ0iHX2TrgcTpGAn7sx42dlrM?=
 =?us-ascii?Q?QpbIM62tuxKrSlI+6xhDOT4f15pFiDwib2Q2zekiSdza3zhrP96k2raDr8ib?=
 =?us-ascii?Q?O1/JJkRqvQ+lcLZuDrfBs6MtAFhPJSwz6EYPHeFRj+sjCl6jVyL0d9zB58ds?=
 =?us-ascii?Q?f0pgvYGjCtiBJQLw8hz+LPA9r+TFBrvvLdflSUf2ca9dmCDF0k1lRGdVs4ic?=
 =?us-ascii?Q?Z0OSDaSBm3ekzPsLMqMFoQ4dtoxMrbwzs8EGX5dulC3dyu+0sdi+q4K1Elbf?=
 =?us-ascii?Q?EVbg5vpOwdaq9oqrTvyMUzSHbBN7IUxJI6ufHGBh59F0GqzHPrLp73mfqpeK?=
 =?us-ascii?Q?jue2ZzBrJzT+wcANb+H0c9o4rAXVnJsDzRmuaH81s6vhpBVGqyO67Pl2dcMO?=
 =?us-ascii?Q?vl1YZQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae1e2a5-d47d-4ee8-35f8-08db383f80c0
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 14:42:40.0665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lUlqLW9rqjuVwmqC9+0iM9q/76UuKpIJb2jJOOtdT3WvQ0nUkCRYvkYJadmZzzsnOWrdXzXwZNekf67/TyoFccR00LJydTW1TAbm0oV/Shw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3962
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 05:53:40PM +0530, Sai Krishna wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> Upon physical link change, firmware reports to the kernel about the
> change along with the details like speed, lmac_type_id, etc.
> Kernel derives lmac_type based on lmac_type_id received from firmware.
> 
> In a few scenarios, firmware returns an invalid lmac_type_id, which
> is resulting in below kernel panic. This patch adds the missing
> validation of the lmac_type_id field.
> 
> Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [   35.321595] Modules linked in:
> [   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
> 5.4.210-g2e3169d8e1bc-dirty #17
> [   35.337014] Hardware name: Marvell CN103XX board (DT)
> [   35.344297] Workqueue: events work_for_cpu_fn
> [   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
> [   35.360267] pc : strncpy+0x10/0x30
> [   35.366595] lr : cgx_link_change_handler+0x90/0x180
> 
> Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> 
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

