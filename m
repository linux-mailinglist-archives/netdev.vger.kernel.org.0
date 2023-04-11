Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47906DE11E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDKQkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 12:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKQkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 12:40:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2096.outbound.protection.outlook.com [40.107.243.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DE649D4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 09:40:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1nHDczegwnTfR3pMDCwM4JOrDUWcAtihzIZZyFsXyllDg8xb0435w69l1LhhHlV8dcYUKZj6wWafplAnJbF66AuWpjyDDeuOIjwzEjWRxducMHCP1LFPTQAzRyKXyoNiLBrpHr4QnDzM/85LmjB7JUbbqLt9e9IYLH7JGABf/l+x4ZCEx0tCrurBZjAkxMle3ry9G7DYaSXQkb70Ci+P5svT/FJMseQTHBko2QDVAMXg5oHPY0sTjuHllKy3gaKIKXKbvnJuLYtkZqLWCOuMcA0fNZdDF13rpHZPskiDwtQrH4/0n8GUacEztMuz2YDyKOVX7J3zuHHqlJiTuze+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mE0/xLvjQA6txVKJ3IIp5zJupIxSu0zLHtcx3Sr0ns=;
 b=SKCnuYJiPhrus8lA7+Bp1PFOIb6ptF2ropy7PCBvqKr2un4Ldqh5YIRUNQDzQd2A4eGjpaBsGolGPSa3oDzAuFpAr6uTCagzwmT9kNTFCPXEwR/lJBi7AZj/dwm/gBcGcGU+XdngmoKaKS+4cwXeKlIkx/GwkMxnVy0qFg2ZdMObVpdrS6Hyqr49uwBYazcumF+ril9XbuHwUqq9MiRECUygyikEiHxVjed+iv6HJgFOQCONqs/6bj/7hT/71oNqB9VJabspoFZVDe3uCz4LPbCrdrFvVzat26AqFx+9P+3aD/yv/vIh1ffbVLlR5oGAgncaevt848mNCNG14bzmZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mE0/xLvjQA6txVKJ3IIp5zJupIxSu0zLHtcx3Sr0ns=;
 b=m0fNXK3D8dpZ9A6/eqUwNhrrASYOqoB9yRyg2n4Ew6hiBArhckSsWaoJ1tBL3SLMTAVBuZg5KjaNaMLR/ekbNE64cAGnQgF7UfJhF75GMDRt/mfvx1q19TB645fbCV6BzVe9T0PQWqcUnlM+8/M1UrjIOjQt/GVIr0xhqrfvhJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5090.namprd13.prod.outlook.com (2603:10b6:208:33d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 16:40:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 16:40:00 +0000
Date:   Tue, 11 Apr 2023 18:39:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 02/10] net/mlx5e: Check IPsec packet offload
 tunnel capabilities
Message-ID: <ZDWNWnno1eoPSP3f@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <e3b42fa8ccd8e1d1cfda9c8d34a198b43c9d7769.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b42fa8ccd8e1d1cfda9c8d34a198b43c9d7769.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0072.eurprd07.prod.outlook.com
 (2603:10a6:207:4::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea2f04d-30e6-414b-3808-08db3aab64b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kr2dy5Zr3ogOl89JrBeD5ERhdN2i9hTPIgnp+qJJ0ngbObh9ph+am+e1flHiOrkDETlKpcO4oyo9SQH5GvUKMqv6W4bhPvWSQ65Dr3xFSQn5V2SOHDAZG0E/LqLbojdMB4o3KIIghEvKTddO+Wqx9qTDdXNv20Hd/4fcL5A4/pmzdJ76TofF9asm7m1T9/lOKHLQpWa7qowGVtkEvp+KCvxGiFzGHMfW1MpSyU8X7OOYK8mrOwafYHGYpWC7HLqYStUDhec6+ty3pRWP0igVQW/E+xhMmHxHUBIimW4I/Jgy982KNqgDmqvJuE4IlBoJOSqFbs4g8zfPk9ZO0ny4hNgnf7SPR2gXH1c2MCFnarxKoNXvvsnELU+UJVNlOuU7s11RQDTB8AF6YmZ8vUpQrJlbjYvn7d4PChivU71TzBxhVxh7L9OPcFpOoeOv0NR4aLK/gmp91odJsk7iK9Mp7dZOTsEaNsMYyh8cw7zuYJb/x/GyYi/uUaG7xy9AzqTrqaVrBb3rkNt2dDNpU8WKKelNpvJJFYYmOoKC7jfxQyB/vAhKNOtk0Jm5JE+3skNqcrGw8sUX9MNoRMHnSQL3+F+z25WS7txWO/il4nromEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39850400004)(396003)(136003)(376002)(346002)(451199021)(6666004)(186003)(6486002)(66476007)(41300700001)(2616005)(6512007)(66556008)(38100700002)(83380400001)(6506007)(478600001)(316002)(2906002)(7416002)(6916009)(86362001)(4326008)(8676002)(5660300002)(558084003)(66946007)(44832011)(54906003)(36756003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ktbO0wyuj/qtt8qyaSyOLIt5nlmMnVyF0drTqsgGXNVu8jWEyWh5aAqrDoKb?=
 =?us-ascii?Q?lrAflBRNaZlyN+dYqohXvQ6klmhAP4VKedJg48YOxaf6UL2ISBeY4TKQ3rCn?=
 =?us-ascii?Q?ixPoBTAaJwAs8xqWq0sbIlFm7RiMQC52m7JgC9LPVeNdX3YuJko2Or1AsvFL?=
 =?us-ascii?Q?zEVAtXj8htz6XWlAFHQmLsw4FyqpevUUSw2WCH0HzSsy7wCMomE3/Sqlotvz?=
 =?us-ascii?Q?+slxp2UilJJ04gcYKk3N2wr+MI2+ZoB8gOAacHsc8bEGRCPqavudOhPfk6oX?=
 =?us-ascii?Q?MLQ71sEeZGs3zEvEisBCaal+8BXDkPxkhyD3FbjPsdAwBHZBBomWYn1Hh3B5?=
 =?us-ascii?Q?R2FaZIgi29CXxIaUVcMYgijcnJ9UD1nDeoa9hrmFiADGbrwsKvHtQHaK5qRs?=
 =?us-ascii?Q?i75a0O4RqU6kjAYeT6jhHd4hCQmD96putOcg9khdaMk0RHRbdf0fX+HPadzV?=
 =?us-ascii?Q?UNLsKl67YlnJImlwFpXm/jNwZ7Q+cbGPsxJSakfzBpj/061N6BoBhV6qhGx7?=
 =?us-ascii?Q?3A0lfEf1Ubf+WjZamfyy2wQ2w8PnWaCGAIRsrI3WgqWWGRMVnm39muctBJd4?=
 =?us-ascii?Q?yBzk2IK+IAXjcCWWjk2NmHwVT5rlG+M1OxE1Bik+RPCCjJRqn26dkFFMuNHa?=
 =?us-ascii?Q?604DO/iyjrD8CYWa347cRDapJoGm64WlKvtfgx/hH1Od4atpU8pdy9ZrDpYV?=
 =?us-ascii?Q?/WjEOVSQ6oOIGUFibQiaStp0N2TzCvqPlGDEapq9/c4NGWAxvLosnZ0d0v7t?=
 =?us-ascii?Q?4QLjJHbMyUOGMCCfYm5fzDQK6ShKMnMXnrMcknagq1v8+VSQoo0aae9xng6Q?=
 =?us-ascii?Q?ycHl0n6Q4zG63zVzj/GAdvB1GWYzVyLx7Afwm17YhM5Rz8JhyxbE4ZoAGhXf?=
 =?us-ascii?Q?1MkldppaAMfrHS9Ix4goBSKipcW36EUnZJgYe7953stWwJtFaaV29SfXiP3q?=
 =?us-ascii?Q?G7HVBtUv/8ci6BCs2RPFRyBhmOGrJXeVGSQUoaeCqqVT3UWcUpgQnOE3n2cF?=
 =?us-ascii?Q?89Mr2/ab8qG4AT9OuTnKWCpRxfYRVezvqc92EG1dOkEjnZrBA0echzxO9cQP?=
 =?us-ascii?Q?gajFnCjr2fciu20J8cVB/7aY3OE9gBsWheLMUuy6HBLrZuhmRPU53tugQGNZ?=
 =?us-ascii?Q?xHlDQHWdjyNz/a+cEwBIHUxvwLmz45SOtbWPh9IgDNYzv2ILdTByGnIfmGqd?=
 =?us-ascii?Q?U5a0sgxhAremWlW1xIc8YzfMn2R3WZ0W7ThB3G2g2uepy1/g432YXUOmBIUU?=
 =?us-ascii?Q?uQK5n802kcJ8146qQsi1nUyV7TEZd0HanKO1f+2wuEpXMc2EoGelc3a+sa9p?=
 =?us-ascii?Q?N9UgddaB6OfIew7elRkcPwKNoxEX2TS71NvFDxEeQxSCtazG8YFatDaG3T9X?=
 =?us-ascii?Q?nnZLAg8bRVvtls8zQ/I43s0U0llXtL1dOJ9wfmI2ktuo2CImWkDryxrIL34q?=
 =?us-ascii?Q?Wa1mKWFIrtOBdbGYk2r3Vz1FDlyLDXsMWXcj//WmlXI5L2ZaBeYlmofR9Sko?=
 =?us-ascii?Q?IW5JBtHHVky2ymwmdnwXNgIrVr2EegU2VZR5jHFZcJh/JSyQ1n7oY9B4Kd5H?=
 =?us-ascii?Q?Qx2YUwM1afRDMw6dXPoUqdVxRl6RYK8X+CCRD1zwUc7wzXQVoExyOTFbtS6Z?=
 =?us-ascii?Q?YnZZRubgvTienQuU6mKUeVNgTeOF/74J+dnDFfqIsm8fw6slTojzPC8EqqJs?=
 =?us-ascii?Q?SYIbqw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea2f04d-30e6-414b-3808-08db3aab64b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 16:40:00.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1ALW+kJi28EaSHssR+QdFpqDeS6p2Neos3/ZwkESKrFG0CFbWa7+kZnaVD2UFy5j2i/7f7f4EEoBtdaFuNXgXoDSjEUGTxpTgs5p7V9gC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5090
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:04AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Validate tunnel mode support for IPsec packet offload.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

