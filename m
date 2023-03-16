Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CE56BCBE1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCPKEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjCPKD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:03:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2105.outbound.protection.outlook.com [40.107.243.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AC39BE0F;
        Thu, 16 Mar 2023 03:03:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GY8HvkG2G0/63GVmDCj8VLsqukcuCmMe0gaS2O/13D5kpkg8RQgmxfNdMNy411h3+7ifjb8B3HwdpdILRh2NQotgn6gXoPqW0GkDjZRCht9n/cI3wPOs0twk88fbZat5QE40sMMyz6X32lISkeX8SxYdIN7nGccKbl+KqImzverlX2fIQgooq31HaqV58DuXjH6jaIcx1QhaYu3W0NoCWnvyAJEB36J4m9500bMQp3Ly2XNmNMBTzQ6GMwioDcZU9zHrwCIQQ3qrVWa+i5UKOtzUTHT5jktp3WL2mUhAbh4yIZgKro7LGLTP+LXo/KFBhl08z28UktWzL5DwhWrUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1o3bTo/Xiy9VzKUbaPdV7gs/EU8fGJBG/80lamwPFY=;
 b=dhLO/7uMhMtxE0dgw/tdIUNTf1PoVMqxWvTklUfN59pl6+bhuijqBMyw5lGHFffVL7T7vmH6SXly67adbfz+I1aXbc642Alh0hniUlA+QC0F9XFAZ5g9Tj4sWNj5J+PDAUfkvBUxvh1nJORWtNqUe03rlZqXYjVvE+53UamwiN0HAS++oxpVLIrED+eIWnboxcgGduKI288gZmwVY905wHxXvjZPsVtpwx64UF5yTkE6UzgcIBQHCeNqn/RvRvhqs/jh/fGKUMrxYWEikUhc7K69s58t/rXpQ0MJQ7svJsLWA9W99muqyY8Ea0dP/tP95RafbdWJ2MDjBzxOapfPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1o3bTo/Xiy9VzKUbaPdV7gs/EU8fGJBG/80lamwPFY=;
 b=p5PtkhgGpZcyvPYLe7M1yMvUGangc46PIMEYaHYsMKZoPRIz/zZVyMfxg2VsEYEhXyXeOE/AYzNL0YVndLFbvRS1tu86U9UotckMjboLDm+HA0OVvmInUXOzUGNWfnALIT6Aksb74tIxPX7x5Xy1hJUCFDt7awLMHAxr3YEJ4Vc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4066.namprd13.prod.outlook.com (2603:10b6:5:2ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 10:03:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:03:54 +0000
Date:   Thu, 16 Mar 2023 11:03:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/16] can: m_can: Keep interrupts enabled during
 peripheral read
Message-ID: <ZBLphKHVYQltkLpb@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-6-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-6-msp@baylibre.com>
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a405304-cd9d-480f-1bcc-08db2605c02d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEPXMr/vUqpxHmJzba84M6bP7e0b9gOkp9hTWo1gMW3T+s84APjxKIrT3IvIknOrYhOly0HA2ayzriQOzEStw92SKRlk4CjC5QZCK0ARIVuAkbmnXtj2ydRVDaBnsceG3rbqA73lBN9r/xzsT36pr6nkyOU2RHloiUf/0q7y2hd2mb/EOkPxs1twrzi5Bn/Tt6zK9pZD+hi0KSOE3ukQt92z2o+hfh5DWT+R6TVYJkvrVZosoCeSCPkk/VhGlAqSSki+GQP39epjWGm9f5xgT5p/8tZ+XXpI7b2x5DZ3APazLLpsgzd9ow0WqgFYjE6QIOarutiAPpDvipZQK48n6sVrIyXi9B5YU4jN27NEa07zdOekjgydg4n8DjFd+D3B8Z9N3VNzziYnANJuBFkg0BSm9jUmzmL1XUwhu14parWcDsu1jlQ00TXV1odiAAhK2QS6eHMGWVvQ+4g9SYRyK9mrHlJ3PTVt85W+Eh0bMRjLTxnVV7DNvW/3ZY5jgqroTiGHi7ty9RIG2EETbJQAgkjeipLTLVU23zKzrJ/AbGbb8KJGXLk6IZ8twbGe4BQYGp9wHJjB5WYYS6AQV1xjKn7lGqggCt7TmARxb/R1GJ1S7BwudY/rkbP9IoB2rnLTSWxuWOZkgcbvfQvPOjkzvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199018)(36756003)(44832011)(478600001)(2906002)(186003)(316002)(83380400001)(41300700001)(2616005)(54906003)(4744005)(6512007)(6506007)(6486002)(5660300002)(8936002)(66946007)(6666004)(66556008)(66476007)(6916009)(4326008)(8676002)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kaDoNdIc1ihEYp03r9IXqDUJtuInF6+51ED1C7EsWO8c5TjkKYOv+KneAsfK?=
 =?us-ascii?Q?dJqBaPTzJBeQc1iZXcl6OrfL7Bm0bCPkcvklaCkWwEPAR3YlOmZR5SJ7u5zF?=
 =?us-ascii?Q?cjnwwUyZ8L2QiK0dNfYHB/6cKEwE1KqsXhCSpJYdZhZBrKy1+/lHBur0cd7L?=
 =?us-ascii?Q?4cV0qRqlInv+RAgQuGU9gDW/OY9rfdcqbFwq7cD2TG+LdksvGNHZyaDJo3jf?=
 =?us-ascii?Q?3DXI3qAi91kKYSyXBbf3VSVW+jnbwsO+zjTux6NtPcYenxdDtyFGZrHgOZga?=
 =?us-ascii?Q?1YAZQt2JaPIOTiL9AmZe6YX7Ryli5PCTZQbyXCEE0wh40hseWJmC75+NPMWT?=
 =?us-ascii?Q?bjBYkXqLkL42rft+IKQnRr/Z5dUuZk5mWu/i17qO6sYOEVBNut+IcRZBGOS8?=
 =?us-ascii?Q?JEwDytzy/MpV3Ol+YGk5cD8LOlH5VjIJTRVmWmbe7TKWI3dbE9iGiq387aQq?=
 =?us-ascii?Q?T6QyYU0a0v5ibsRsn7fv5RsdqCe9q9Y0VeQ2AzFLJF+2lDstRAaaHFb1NSZD?=
 =?us-ascii?Q?LCgQ5uy8U7TsTmM8EFzDYSWtQrDwRwnuaeHMqYHPKJgVbBZRt6MRqS4CnKJM?=
 =?us-ascii?Q?PGfS1MjqaMzZpdw2n7mqN7WRs7kbTUnkHktWBYHx9Gm+XmQcwqPURN/zCz1r?=
 =?us-ascii?Q?1cMrnlT6SiK+FpY5bNnJcNcoj9S18HEAb0Ckkjf4WOHiC9uiEtveK2bL6Gr7?=
 =?us-ascii?Q?Fhys8Z8NA/w0Qb5IJPvXWWnAsfzuTFWxXqusPW1p1WE5TAkhnnbhCBuqlnEt?=
 =?us-ascii?Q?QonIIOADzSeRtQ7kndpwZZ32/EYC3Nz2TKKyx9xklYcpwKOq/U/yxQ+qNFDe?=
 =?us-ascii?Q?Vn5zzVhdQEVW/2ldBgEMLxxkPJFDyS5MJ/bMv5LJk3LUH6uKSjcVrF5z9rJg?=
 =?us-ascii?Q?FXAg1CwQr/KZc6DL1KK6ag9gXIL/jGaooOeW1ayp2XpW3qL6EEhKcaGvSpWS?=
 =?us-ascii?Q?uPH7MxMwsDqtQijPd3JIM0Xz783j83vKlLDT58aag2c9LUkiy5GJLY26AbGP?=
 =?us-ascii?Q?iUF8DChpFlkS1UtH6C/5eDuyGmI3pNM4a+rvoCLV17iSQD2u4Ef3jpnJLJFK?=
 =?us-ascii?Q?8UN971Qq/NWfKHWM25f5STVJ25HWwGpU0aGKJ5/wVfbiKeuz/hCI9Auaau3p?=
 =?us-ascii?Q?3cK0BGujzduS8aooUUtokQc5tNtukoRBUYTuRlcUO0498iKLWVb75SGOtuVk?=
 =?us-ascii?Q?1j8k7I1Csn+fS2laN4HfATuFipv8dLp8iNlnu0GFf2GJ5zgnmR6pSlz/5wus?=
 =?us-ascii?Q?9/NjQlErteSSkQm2b78GBn9gtCjdZ2uMTHeBL8XL9TecVm3ZtXmqpaJuXkuH?=
 =?us-ascii?Q?oLngpw0XOK08fXcg2aKX1Srt8C2hfrX0niWcCGxCDz2z9WD24D8tk0MQUbts?=
 =?us-ascii?Q?tFJ7B401nI7s6iDRU3jMcAZU9nYXNhwNs7JJZP0Sqm1qkMvIpsP1nfinHEOi?=
 =?us-ascii?Q?Oh5LCinSF5L+hVUESxpVVvtvUr4s3WnrTziG8USSJjiTMpO7uLEUGwL0mHYx?=
 =?us-ascii?Q?CeqLM4KPVYffGZNQJEWDS3lu2PsN3O5KggwCKIvPzkoQmvauo8c1lo4Qg2XJ?=
 =?us-ascii?Q?nnEorAK5rUYWVeIMv1ZsNF0CywaMcKaqH0gYIhffVr8VB1aELUmxGBzqZgSE?=
 =?us-ascii?Q?MM79gy1qfHiVHSGoeWIoVHat0WJJ7hPeY6x+hBKePAsCSVNbyIoC4WEHszLQ?=
 =?us-ascii?Q?CQ4i9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a405304-cd9d-480f-1bcc-08db2605c02d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:03:54.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEeK7sHiH2fjQ5iQgOjCqWNdDSj0MKXq0XnnxpSsOHB9q4rzxpxVEzAyeOd3NtgBCEYFcFWKv5Wsi0xDzC21p/iv5R19yIngOQn6mWZwLWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:35PM +0100, Markus Schneider-Pargmann wrote:
> Interrupts currently get disabled if the interrupt status shows new
> received data. Non-peripheral chips handle receiving in a worker thread,
> but peripheral chips are handling the receive process in the threaded
> interrupt routine itself without scheduling it for a different worker.
> So there is no need to disable interrupts for peripheral chips.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
