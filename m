Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528816B9C14
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCNQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCNQs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:48:58 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1672896F0D;
        Tue, 14 Mar 2023 09:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y28boKVDL7AHRA35X5E+3+Mfyq+1fjPv+TzeJzSLhjzGyVjeEuYeOLj65Oq1WsvbkChL6VpaslEZeGTcVqHVbbVqF23H8eW7yEAi6cfgNRUGSbXrH1lkyhSd0kte2pXSpeIunb9feu3onYCvR+9rmseHgpxLaWH0/L74S2PTPdlL2/jbnjWuhwBEQMZ1FP8A3qgs7idHT+CSTexjJCJdZW5Qoc8idtFAfaEmnOy2AIRg8U2/6BfTnJ2EneMWx0s30v+ydqb50THwx/jxvt4F0JfmnwpNXoEVPi6/ef1F24HQ+1c/UI7S8kr5r8LhlgMmsatVIR2hlbK8kokLM94FcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gQ/OfMW2T0WFhJJUf1q6t2hWwMv5mPLotz8BewmKLE=;
 b=bjSlGHocTalEfaqkxfxb4CnR5Sm92ElC8FjJuD3UoorlRabpxIrSSpdsaa1koXMH8PtWWGMLD2V3SVMSRnbsBzjyqHzFSbXEytPrkrBYwHgix92iP/aBOWSTXcUMPTPnTVEuq1b+ZTZGeMyT5PYnTlpZRdTvhk+UYMtaU3Lt6EZsOn++/fd/uRX1oI845HpUadCtiDJKwWjWB1Cnk4wB+l/oBNebYVZ0Lat/kHPoKaJS0vlT6Ks/q0OlDGd+ZHmwLvsEbtcAuhCoxo4Aq4r9ZBpT5VizzuhuZM/ivCBMg8M3pN46gfMTxanpta8+w0+XzTMzgGR46ApZ/XcjCOk8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gQ/OfMW2T0WFhJJUf1q6t2hWwMv5mPLotz8BewmKLE=;
 b=mWRJHL4ffGD8nL6lrDzTQJk/jx3kCDaWUBHZCVKmwwKFkJR+cpy3n9s5fzYgM5YlBIRq7OErbkUouETFryB9zH36i5mNT4hYVsNko9mGzs5CaceoH8pfZzmuKRqwUjP7BtXK0nU/8bnq+mGMFBMoqZXnZn0mfZ31QGaUDBGsJsY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5802.namprd13.prod.outlook.com (2603:10b6:a03:3e9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 16:48:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 16:48:49 +0000
Date:   Tue, 14 Mar 2023 17:48:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3] can: rcar_canfd: Improve error messages
Message-ID: <ZBClaxLZdFJSCaI+@corigine.com>
References: <70d430248415a3304573df4faec19f6a3135db28.1678811267.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70d430248415a3304573df4faec19f6a3135db28.1678811267.git.geert+renesas@glider.be>
X-ClientProxiedBy: AS4P251CA0017.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: d32a047f-e974-4856-bb44-08db24abfbdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyQmZUz264we+upKfhrh2h+p7OI0ZT5dKYYqHgD17yaxv5aUm0oBzD4LRTmUIE0P0+mjNVnjMOjY5E9al6QjJHsEeefwhEb0oOYrFA0ZcSlxtjJa6mVuZfE9naHUwEUy4ie7QLQHg6PU+pWwHLFpbXguF4KHA8Yuf0AGUuseTGuJwM6N+1kUMrnSipPKqp/idUsq5tymOYRrjOtu9jK0XXF0xheTsmmMQplM1Oafh6pSplMV2mCaTfdQZlp3H62pyg19ZMSV23U+KpULaDV2QkyKg2IOZTdkAa1bVje/8D1HF/cep7tbX2UXIQl/D2I85BfVy3A5I/vrszOINaaa/l922kl7TFX0iXsXqovhf/MypJStYd5u7jArMZZOGuuFzbpH02tUoIyEWLZon0/iNXw+bTzxxqCIOjeWwjQm2Fq+sLftbZF/PISDuP/nA+2sa25RT0YevDVbMakkoVumEwJgoG2d59gaEKWxpFbKIQAW+X+LE8MFkvSnCI/ruVCgVxNnDnb/A5DEqeQ2XzaJupkqtbOUaekBfWzv7JKt7B7f5s+IId0tgjkKjR1NtkpYSlFQn6bcV4YgAnglzTek30tD9jSGhOAOIv7t/13/yWk8vQRMHLWUwap/v/UJp+lB8nk1saV9G9o63n6yLDNFGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39840400004)(451199018)(15650500001)(2906002)(41300700001)(8676002)(66556008)(54906003)(4326008)(36756003)(478600001)(66476007)(316002)(86362001)(66946007)(38100700002)(6486002)(4744005)(5660300002)(44832011)(6506007)(6512007)(2616005)(186003)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VcrqTcUsI1OOWDq5yRSn/CdkkukJK6QnubGquyZfeX3yu+XDTCDmXhJr4azL?=
 =?us-ascii?Q?i/ep406SEq62qVK5Rz8iP3NxKB/Iz1kHNY19G3PeWuUZR5GLJ5sOd0oKnOga?=
 =?us-ascii?Q?cMUhi8j2b/BD6dROxKw4skcOwZvpJXmskGs6b8obQvXq3HuEHn/S7g+U3IF/?=
 =?us-ascii?Q?+r6+DTWt6wIbgptx761geNu7cwH1oQBoKRBQxcGgiksKnMs2locASp3qpm5o?=
 =?us-ascii?Q?msUpjq9FSvY3FbBb4aj3dMglSmmjXIgzcqNPJXvntTN9tAE8cvPnTQsuYR+e?=
 =?us-ascii?Q?k0S2DNAUU/6CCnvUve7k9uFV+cbajZoKw05xEnhuYin4jmxozhVjj07UgiYR?=
 =?us-ascii?Q?fJNHvjwxPMolE0RzuoX5aJFpmyU7q1I8M7+m91s1skCX+pDKHS6YP76MVjrA?=
 =?us-ascii?Q?28LiVqYs1aCQN+3lKqWTGe8+aZ9UYkLw+mRm9VgeRhby/KP2zRM5HHqZP4Sg?=
 =?us-ascii?Q?nHORNCatuguA16rJBh6pF2/eXuY/4/+IeZNKnJCjTgAQi4wSFKLtDXZeXOyd?=
 =?us-ascii?Q?Khu54vl29z7uHGe8YHyWyB4QVIOUdyPSZQatJcri2s8XTm0dwr4wRyktr3A2?=
 =?us-ascii?Q?2E01QZJObxLLCPW2EDztmfmVOHzRJuogbsqSs39MZRwW+KjEtT1PukZrHqA/?=
 =?us-ascii?Q?ZkM3sUmjtnCO2ee6usOuIZc43EPbdIJ9VpC0pD7Yxqh8hcnXbhiAua14aApn?=
 =?us-ascii?Q?EKh1Iq9wCZ4kjVDinaG00vjJSgSX7rFelom+c04jKDZWQtonDE7Ydl/uRRDX?=
 =?us-ascii?Q?8fBbtSCd2eItShEewIBpMnLfcNaFY1WTiWmkDdWrcf23/o5qdrMTuRI5Qrp1?=
 =?us-ascii?Q?6mKRAYQstIPNud3asvQioXbAMyT3rCQ9hSK0PhTbISBAOIltv6tExZ0NS6Pp?=
 =?us-ascii?Q?QviJ6bBV7WLMVXkA7BpO1ca7nJj+CxVI+WHgshRJ4dXNt6S2T1h7n8Z4j7Gj?=
 =?us-ascii?Q?mcc3eaEEwDGknbwb693rusmpHXlPEAeNvv50hczuveljt8Du2F5FZZa5MVaE?=
 =?us-ascii?Q?EjrJqib0K4mBlzi0dgR4uDaQkmj8fM9mfCSP4IxoyIegWVrzmo+xsKkwMhJ+?=
 =?us-ascii?Q?VWNmTH9zyfpr/pabhBd6yYzq0ZqRxsReuj4eG0fP+0bBblnacnerxBn+p0DS?=
 =?us-ascii?Q?b82x2fu3+2QxQM7gW8NuRPu/vx/vztN8qg2Ve+RZXtcG+p2wUIGc+u2qZDnz?=
 =?us-ascii?Q?Wa4RDGY6osOQ/gYq00R2kClkgMelmVPphYSvrClvTqVS5OpmiKEFh1PQAJbH?=
 =?us-ascii?Q?taTPX8yDrHgs8tqD67UCR1+puo7BsrFAKC5f/8Sw3WV5EFdFfrTzFkQt91Uk?=
 =?us-ascii?Q?euVfKV88o7nmVBKyCwFgKO7I0OdmwzRMlybr9uaStcrubwgA8m3hJ7gUCIjN?=
 =?us-ascii?Q?tSFNbyurMvbNQXkkLbU9E5FLBlCymlaJoBBHvf8MjTWpqB8M/tyai8iHb0GB?=
 =?us-ascii?Q?py9+cksSiS8jWp1HhNO2+03hSCqA3f5Z6Fm323zij0zNkTTcsc2D0eR3krBp?=
 =?us-ascii?Q?XQ+cQ0vc2vxQ2oxuuVLET5gy9DBveETIkS3ULQZ/a39xruuPKQArbygmWGGX?=
 =?us-ascii?Q?V5tEsGZa1MErkIBA4r9E1WUv+QFAh/CckY3MVvAM8bf23CwOo7AhTiOK4yYx?=
 =?us-ascii?Q?PhwAJbwUHp/eI7mD7TxxqBlcm+3RA6vtc//UCOkSrRpcRST1AfwIuyjUX1v3?=
 =?us-ascii?Q?xrTTsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32a047f-e974-4856-bb44-08db24abfbdc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 16:48:48.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/u0lP/ySVafNFydaGhB5ZaRF3ETPZ866vZn+hWNnEVPLfWA3e9tGHaZp7Esf8OhpTDqO1LtptdQQpsO2khm+EcywDFWdyLXoLUWbxIO50s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5802
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:29:25PM +0100, Geert Uytterhoeven wrote:
> Improve printed error messages:
>   - Replace numerical error codes by mnemotechnic error codes, to
>     improve the user experience in case of errors,
>   - Drop parentheses around printed numbers, cfr.
>     Documentation/process/coding-style.rst,
>   - Drop printing of an error message in case of out-of-memory, as the
>     core memory allocation code already takes care of this.
> 
> Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

