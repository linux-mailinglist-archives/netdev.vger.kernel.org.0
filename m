Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2E6B2580
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjCINdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCINdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:33:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7336E34C02
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 05:33:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0DJrzQJCJNO+4//XRJy3yr1pjBw5N9veJOC0PYgrPrw/uQSE8sqYRN/h5XnpkDxdju6OqfLzrdnonq68Hi8/NJpCsNIeGYyy3+cJLTf/IChfMxWgveiJqG0iARmmyhMi5BaWsWpFhT2lK58sJSIvmsb7hxofKe9j4zUtMX0Jpqwtpkk8zFiVg1n38+tvb2/5iJXU+fpHfc4QqfIFhREoOG5T5I2llKIoxuNCGMuI6KkyrJmTlQaGstZ7zczgrCSajT6a8dZqt+uE7mGdfxiXnXASOMHOA4N21L3z2UIDysDTH3I1KCCkK3Yzks2YqKMSQwy3xZtjEN7TgXvkgtPeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TC1Rs6kTnzH8kNRHkYzlkzXxjae4PWTHyAmQYIWnhhU=;
 b=V38GisIV6zA5QDpRdrcqqoWeUl3l0tyFJgxYQN+FCwWYuQShpjoBABkg6sdjOIgzJzbHea9uZ7XdGs/HFhjceVFYZY/jQDuZT+Q2SA/87fYFOl2sd93E0jhAV/PrCbNX7QTk/qomtT+zqbTH88g8rl0JHtPntYPulm2/k3q57L8cJvesIaVCa5Qqv6ibAI+IWUMDKBoL5GREv0V7/HeJk/gdOIZc4v2noNhdz7SzbCSV7meRkjhoA3fbW4vZZbbcn4ix0ggbVaMCbhZPG8wtpm9H2rUT0Asq5sO5izDOgPjycSfs101ZUYWQtGqGLRXVLxLAob3NV8XA++bQwDcZUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TC1Rs6kTnzH8kNRHkYzlkzXxjae4PWTHyAmQYIWnhhU=;
 b=XiAODpr9ze8eZU2ksHT8Y1CjPmzT1ePaIghKpl5HJz9a+w+WfPYD3HHVgGT+gSWMcVTxtqDNwp2jjmXANQyqj78xzFBhuU9txM+MXkWcVTbwtU2I97Su+IZSMDpP11i8PAaoni0zMKAkPKCeH3UKSTZtgbG8/YG4Xd3FuRjwg8Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5925.namprd13.prod.outlook.com (2603:10b6:303:1c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:33:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 13:33:20 +0000
Date:   Thu, 9 Mar 2023 14:33:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next v2 1/2] skbuff: Replace open-coded
 skb_propagate_pfmemalloc()s
Message-ID: <ZAngGn+qs/6hSF+a@corigine.com>
References: <20230308131720.2103611-1-gal@nvidia.com>
 <20230308131720.2103611-2-gal@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131720.2103611-2-gal@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0131.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 903cdbec-32ef-4e55-f3f4-08db20a2d93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NU+iqrK1DoE+t97vOhmj8klqqsyyhIpZQPNf3B0I3mLMxQF63QXbAnOV4o3IWu9Ib4+29xMsbQeK4MwwctnWTNq0WhNLhfTBrR2z7M8e8YIhSHgDU0xNgOJdkzc7LoJKiJQF7RUH6Etp79xJt0Bo8SLkmbY0KPqRmj8dyF0QpsS9FHsL/K/Dwas6PlJC1x7oqlTiGHWQLdZAlJGOrw8FN3JFr5bXFwSRoY+BA/qgCIcmyseQwtgUDiznC5xQeaS+Vvi8+4aM2fpUu6DUm2WPSAGqBKzUx0qmL1mvVtxSsvtqEq2Z9cVPKT/VuRwve6EzQRWwIqjjoyCX+3xUm7g5+GMzNl0C3C0DTvtpndyUlLHYt8PTFfLwTSWXL0fHkm7+DF5OnnydTFMf1zHpcDcQQyXxptjZJPbEI9pjBAuQgxCVplqXMFRyjiL23KaQzOMBxQeSmy9yXoC0okHie3/vEon9iJnAuOzPLqEHTqIQV8MMRi//3LpKcs0Le8VsVqVM6QYEeh2uJTbXRtFrvJNKik52DM5chbXJ+RDAfmgxXbwiUA3yd+mIArxCmyKRUFADjkXBzXkVPuhr5zAXYhtLhT/1sVDSryrt/tc4kYU7w+VrSx/bcW5c4bi9xxhcpcszKOa7zTw1hktBy7Vb+OQNB9CcYRm6MD1kephI5jKHgFa7+O/vt/EZkQYnn/DpJo3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39840400004)(366004)(451199018)(2906002)(44832011)(5660300002)(4744005)(8936002)(36756003)(41300700001)(66476007)(66556008)(66946007)(4326008)(8676002)(6916009)(316002)(86362001)(54906003)(478600001)(6486002)(6666004)(38100700002)(6506007)(6512007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7w7On4OaGTW5wYYRwsDSvHzlRSkMon59Wl7soXlLNJKc0CGYmQZP99dRLm4D?=
 =?us-ascii?Q?k+L1SX2z5Yh7Isl1PF/Nz0F7sly1ODy7Csmw+GGKmDlUQCSYLX7Wf6Qbnzqv?=
 =?us-ascii?Q?mUn/Rd8PLEGssCjHtqK+g9nBUoLwwh3u9wKKi5AmOHM0jixcNFpnHN7kRL7M?=
 =?us-ascii?Q?Q6t3DMIiX+nnrpRA5ubu35voyA90uhBgQcV9zNgrzTYG0RqtaqGZD8cfyi/J?=
 =?us-ascii?Q?tXdlI3KXGSe2cv0EAMvWhGF3tAbdYwpD+b/TTtPPWJRuW1aflrIqEdhMtE+Y?=
 =?us-ascii?Q?/Jthd4hLOL899ZYzvE6wCWsSw8/Vp5COGZMmKYq957NxWdVE36PpiXsOIkJg?=
 =?us-ascii?Q?CI0dZVRj3Jw8pI6n7Atg0V5ZBXvf/Dar+Kah3ytr2bLp/sv/WzATxu1LZ53K?=
 =?us-ascii?Q?wmW74anb2ZljVyd6i0ZpMO7JsotlEO+BplYZ91pFctrWIY3QWUB06cOif4Gz?=
 =?us-ascii?Q?LFVhtystNu5qpLEOWlvZQxIf1Iv6QEWPGknxxL1EIrKuIq0aTEItjCZk/Kl+?=
 =?us-ascii?Q?ixM29AreXM6orB4Ynd8xW6WFIGett6uHJ53PuW7swXWSd/WXw0WehSLziGfz?=
 =?us-ascii?Q?5PzOZioI0uuyyMJ9qJJS4++gEtxfjETgcc4z4VUcfRmsiboJFmDPOMhOhtYR?=
 =?us-ascii?Q?2gy3QRFLefU5XTYx2TLI0KQOooibL1hqwaU+kmVGOFzoB/MRxRfnrc+Wd/YU?=
 =?us-ascii?Q?Y8U0hS0fvqvFEJ0KnLChKz4jRTdZJbBCxQbpPIS1wMQSJHG0aUBLIbiF77P/?=
 =?us-ascii?Q?7F+kaWBJGnkwkVO9G/YobFcD8Lhy4s2S+3ZaXhBaabtZQijhhjU0Ytv1WuSq?=
 =?us-ascii?Q?ydJZvWvVBOccgOrkRngS4Hhd6uf9qFBbcxKgSOKplVenzfe47n3L4kMARW68?=
 =?us-ascii?Q?taIWsWtyj3ZqTgxUqAA9tAQk9mJbI1Gs3Tw1A3OJUPzJxJLvv65kZVrVkFwF?=
 =?us-ascii?Q?cv+o7MoZICbG8LqCpT3XpO71iKSV8Q6l7hRm/o8Scdez1QaBqXn76L1ax9Bk?=
 =?us-ascii?Q?PxJBMXT10InI6AoXQst9iw3uYbGAXKf1ybxBK0aDA002IR/+lgDy1am0oAFG?=
 =?us-ascii?Q?uRyV8LUmKvjWvBuNejTZEGtYGvjOBCBIoyZb3c/NH3acbEoXsOJ4QcyTZ7tb?=
 =?us-ascii?Q?I5OqES2rP7deI5O2giRPQavgzqOdRuojCCOyr0OIvF2TyogprydEtlqpF/DC?=
 =?us-ascii?Q?fGCveWhfGQGYQXhvteG4SECGXSElH4kCsi09EeiSVQbY1dHRI9VrS7eDbFc9?=
 =?us-ascii?Q?hsO541Z0ekRuQXmTDJSJTzIrfjPpexXJYqRYujMfnuwIBLmrCSp0TAxySrOB?=
 =?us-ascii?Q?/qVNf4Wkw+S6bFpSCPI2SN5AqgfZI8Df2cM1RBj5CMF4Ml+aYpDdOC+qD071?=
 =?us-ascii?Q?0Hjm8AaWu2DGx6qM66zDiErqXEqzX9JAsUmBwbqexP+frg8YRaXygzaoYrcW?=
 =?us-ascii?Q?xAqp3Hnyem4/BtLhwFuLN8aiLGqNIQB4nGRyxQvnDhR89Qr2aw1vizcJkL1K?=
 =?us-ascii?Q?HJpS3wSYhyin1oAns+eQd7Iurx16k0M0XypBv0HSqaPZklCApCwMMvUzzoMF?=
 =?us-ascii?Q?e4CJ09z94H131Zn7EEy+ROIMC/Q7uxEhyLeixKx99QFYvU7/iHiZCo+/DrG2?=
 =?us-ascii?Q?pwHqMznvIzsALSRgLRb2Q6YNqmyFm2PFksnPPkvsAOtH+mMega18clA28yjj?=
 =?us-ascii?Q?W8n3Rg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903cdbec-32ef-4e55-f3f4-08db20a2d93d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:33:20.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ILRjEtpncsY2tJCX6MnJMM/F6TmJpLkqqFYx21v5zDzigqq4V/hyuWkCs8UTqPz5FzDFxiAO+xK92AQOo//7BMHu/0z0PADbCeLwqYXjXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5925
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 03:17:19PM +0200, Gal Pressman wrote:
> Use skb_propagate_pfmemalloc() in build_skb()/build_skb_around() instead
> of open-coding it.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

