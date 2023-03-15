Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28546BAE20
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCOKuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjCOKts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:49:48 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20704.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::704])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3645C1EFC7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:49:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxgD2JcFxlEJ0WEVddXTb5UwSWiBTCmMpdLuR6qs0TWrqPYLWtSnJyTl36tQbmBmQClFHsU+VmFiMpLUHte5rBj/cRb0X6hIt4iuHPwsJ8ZVhwGjBue1mJJSv+Gq54HtQOngrgHj3bCcLp1zJxssnljsPIXagTJNf+CEMGwjM0z4DtOCgEZbkOtIMHfOuAAuSRz65RR6LRfzK81gvu83Cif7NgHJPgFb7G27NBZn+n5iV7XwYUfiWLPpFW0kCCMf6On2kH+N2Xe7INkmpwNgxCbUYeD0liVvyq6TwLqN69AfXJ0NTsvYqIyoM6S2FZJEEq519H4gpHpgSQ1gDyBbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMKiPWLpE1y3fHOTaWIYTfhUzDU7yreDyNh0M1KdhWU=;
 b=FHBEZd0+T9IfbTRczrHV8rdmIAKcHsf7cQDCqb4oUzJuU4us9V+YdDDHRA+65fFW6u68EOPdUGNVA03vNEF7GR4Mv+zwfUjHS4miwKpK6IIPAjv8L5Vtxy7ae4euH9ekclhmtxPKeEmDrQudDUJkjaG8oKcS8JFT9s3BQwSyq9Hv4JHPramJCXY0nGetdI74fcyq2amxfCVRd1ptprn7CJQjs9BBzEh+bPmQbEP2grDzr3ka1X/eF6vos4sQ1qbyPl4WBFNzpzSuk2lXuJBzvpsmSd4WyKe+n88yz8l4p9aaX+0YOE1M+nJAYeB58wRX7JYlgZPLy0YsYdVOaHif/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMKiPWLpE1y3fHOTaWIYTfhUzDU7yreDyNh0M1KdhWU=;
 b=dswWXFRDv4/saE0TCIaNO9nbRSeWpVg+d597UXqQDcVStg7sFILnjF+0lATeCTRE+HVP/4Sa2B2oBEra111VHQYICpKDWO2gzbrcDu2DjrZs2fWZ64qLTkJIXnAv77p3LT4Z33+kbWKtFGeMy1CK+IhSeb/Pp6lMug1kEtrOEt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4145.namprd13.prod.outlook.com (2603:10b6:5:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 10:49:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 10:49:40 +0000
Date:   Wed, 15 Mar 2023 11:49:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCH net-next] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
Message-ID: <ZBGivb7ve9LThAX1@corigine.com>
References: <20230314193321.554475-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314193321.554475-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4145:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b60120-249f-43b4-3165-08db2542fa85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGw3MrXaqKqEaWqT+xQu2gqFGiiqGCbMotiaaPci/1syAItJzRnsPNnX3E/Xfb/fncfGIypjSdi/wrmkoA0600FbMYk+7vGKk3EkB8HgPBxrK4xUqL9NIacV9W+IkwWEtF8y61Cfi7ie8QJaQh4kXubk+HM1BE1WxTaWpB8yhPmi1AEtSpfzcOTSpXad837lCraBGhUjGYYlMmIFue+gaU9b4y6flQcD63HYum6FNB67BXkpXGyJZiYlmb3RDL6Xgt4//2ColA2c9kgWV+NBdA53EaBGCmGC92cx5Y+NttwkF8H8KF3NAY7tYV2ghJEb0Yi6BAuJiHtr9WCsaw1obI7G0qSavPFq/WSllr2hVkP1jZRwXjPct95kcDan0DUjYBmV5lIE4vKgQZ4wVaBxpSGvoOUwueB3J6FpbYBx8SGDWpCf3TGaYKk5j+IrmDfxfsdeWOJlH0GIhqiKkNmA3YqipVzOqtqiJIYxanuQCh+UbBi2mLS1j6CEPDPN9Fq0cXsecsgw+h82pzP/8S5L0uN68Yy1Ya13s8klpONwEq+7O6iRvIzXOS2lVi0hrfrlw3ryCjjx/DV6WaQzQr9nq8bSYmUnpDVqlX7nh/59jT50pfzKZLUf+hmhCkr27cegosletB1QnY/a1le3cSnsGG+dhtJa1xWs6tdeuDAgUp2zN9XMv1vtkiQ259a2qPNt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(451199018)(2906002)(8676002)(66476007)(83380400001)(36756003)(7416002)(44832011)(5660300002)(4744005)(6916009)(41300700001)(66946007)(66556008)(8936002)(4326008)(316002)(38100700002)(186003)(86362001)(478600001)(2616005)(6512007)(6666004)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aDy0+uq7xAv+Q+b87kb50WnonzEdQaAprfolz5ETBcxeP0QXoCW3jBHdG00m?=
 =?us-ascii?Q?pqqgTXG/RRCyabHLqjxeK8/cKHrQeEMHjhB/Ea683HKL+xEBrbeEE7tyYWtB?=
 =?us-ascii?Q?zFdXiZdHr7G9Ajd3IGACmJyu7JavlI92KGZeV3w2rQ1yg5DdI7+LNoEeYLxi?=
 =?us-ascii?Q?O3YJeB8rZ8/VT94btc7JmBkoSUiqxUkCaKiC0q7G4TvbC7AlDH9kSm8iPZSm?=
 =?us-ascii?Q?xDe/OhtPH7kohW3edsq4KpOqe4fhrdneyWynWkzf+PE7Rhanl6y2xmKHHt4w?=
 =?us-ascii?Q?9Swl0PB/bGTd36DhhdeAZ8urEVSVkxEym1Ad+zsgyDZ1w628bN21IYkFl0bA?=
 =?us-ascii?Q?lf6buxZNR3UOchlXDaYtVj5QNxTerhk24mxITKKxNj8ywfDKD9vhxjk5s/w4?=
 =?us-ascii?Q?R1Hle6aPVtBeALMfDTNkVIfO5XvSrjcAdv1I/E8B7zLaQhDAfz5ML/ep/u8m?=
 =?us-ascii?Q?5BxVWGEVSwP0fJqWzpXqO+Cbh8ZLIpOYJoCij5ig6GYZthJtChRMteqR9buW?=
 =?us-ascii?Q?kX7mAqq9YsohbjnKnAHzOm3KPodjdKl314nPkWfktQfb1fvZDnzydhMSSUqW?=
 =?us-ascii?Q?G+h3GbxsD/ER+dobd1L4c8j3eBzjY0M6Mp91SCkAIJaqN+7cK+Dj/4D+RH6N?=
 =?us-ascii?Q?rpjiE0pNmxzlVnqYYlDCvlPp7Dd+8cO+fiq3hgp6V/AT36y94KJstRTc0RYW?=
 =?us-ascii?Q?i3PWov8WqGzA6T6ZgF9F1aZOZNwhffnEaQ+xi8Gv5BOxGuSnaG+ig2feEVZb?=
 =?us-ascii?Q?dPbsfHAD1O9WF3OU08w5yrrUxooQBRccgswzmIvfXz5R2pj00n7eejZa6hC+?=
 =?us-ascii?Q?HHbPn19QLi3mL3yHnlrzSaLE3qrlPL01jdV1bPqPyOPyhh8XZufcb9RkJxEg?=
 =?us-ascii?Q?dwbb6F1OLZAwXqyOo+jbccp2Q1HJ38e07ezsQG8Ep/CI4ix+IGnRmA64Mtg9?=
 =?us-ascii?Q?zFlJgeYArabT02e2VB4dKc/jlaMtP+HD4SVr46eoZCFW41EcpdfVtXzgbc2I?=
 =?us-ascii?Q?md+jsVqQlRIl3l9vrJpLc/nVrZaBQQY946J6KNNNSlfxnsvt2V9MRlSis6ls?=
 =?us-ascii?Q?ogqbZEhU4BHVZcrmw3mskburpgr9pPpq2XX9Mes9ZV2br2jMhoWlxgL5VP+V?=
 =?us-ascii?Q?hojpa/CDVxSNx/JtFSqU7d4bsE2c0nNKaxusqUJ1bMgOtv/7WDeShjh5yPdV?=
 =?us-ascii?Q?NEP2ONVHvZkUGHM+poKvvEiXiTtQBVskGQP5Xrpmfr82YzTB5VJg/weSqxnB?=
 =?us-ascii?Q?vvKKO+98Z/Tgai9H+u02xVNoMAE+HiT5x2H5519A8ZBaJ0ABgBH/FyBp5KZb?=
 =?us-ascii?Q?J6tBHXbiBKpy1cM8LMT1jOic/YIZiDqEKQFmzjZiCUOrlNHk9wqUNsswF50k?=
 =?us-ascii?Q?b6CuekCYkFQ04nMuchIr0bl4mrfAcsZzZNjkLVZFFS++zG/qfJkUx2L7a/tz?=
 =?us-ascii?Q?K6dxEKZSwfRldq+vWadd0sAtVcfBEEiZgqV86zSA4ScOX93+qEWmikXY2yzl?=
 =?us-ascii?Q?oIEGwtz5i3Gsp8ptDdaNfvnwQdK/fSiwUGAaaYZvZb3Rs91EHKlx3YTIfbxh?=
 =?us-ascii?Q?QFUxkWtPq2gjDDU0yAVOLsyIz2Nm673aFT8dhTu/5QdF+1AV/+x6P6DDPOX1?=
 =?us-ascii?Q?EzysMZJA9tSBbJxxQPLLEU7nDNSN9NLlnqAi40me977QJoGf5OiMsO7K/2Gc?=
 =?us-ascii?Q?+3vPzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b60120-249f-43b4-3165-08db2542fa85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 10:49:40.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q57s/qVV3cZtnwJgtxHg/nas+BQCoPv3akcWtv31zywSB+CSirGIjmECYg454QHDjhPTKPt0TRlYZ/HaF3nqqXE86C2HrCxwLz7JXglgZus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4145
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:33:21PM -0300, Pedro Tammela wrote:
> 3 places in the act api code are using 'TCA_' definitions where they should be using
> 'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.
> 
> Cc: Hangbin Liu <haliu@redhat.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Hi Pedro,

this looks good, but should the instance of TCA_KIND in tcf_del_walker()
also be updated?
