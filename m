Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E90682D0C
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjAaMzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaMzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:55:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B8474E4;
        Tue, 31 Jan 2023 04:55:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An0jswdOqLjIdYcjGpRsC0MqWG5cJbeAioTcikQckdICBPdytmDu0684kJ2ALtqS7Qs3CrqtMv0CAZWFcdKgWPMYbTTzajrRw2KyoXuEoATSDBlCN1ZEajMOB2co0B1ubF3hyqZ8/h+/sr+K45eOQ79cFTOK3kHL6B1AfkTlqRoYccBLzT7yu5hF2HmMSNpAPes2w48xwTr8H0E7pFdshYfREQ0SLBcFOTPzEhK7bWDOpNXv+snDs498RBYUWfyB08uJYESjiJyAf6iubRmGBD52E0qqOX4F9FrkDtutilsdR9y25vy5zZV3b7xcNNcFFcgF81saKDx2ZWJ63QoNMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/w8IU/YoMlWKV6zR42GYD9hlnv5OPE7ODkxnEVlgoZE=;
 b=VPRKO+d9M8MZp+8JE/poxjz2D/zef+wJDR1m+dEchkAtCoBRqaXoi6BHNQrHr5EArx5ii6mtGBS/WwckwkB9RojabSoFObJFg5zUKvNl9/yvIb26lwvob6NrvhHcsyL7q9dGvAIIaBQqN41jb9DeQFw6PrBy0vRYIchBJYdYplY62JFd1dAjo/VSzeoUfX1XZ/RN+M4kmpLttT4cmNZ1fqIjtJbzL/zZaapbVOEr7zRhnBkv2GZLUTktrl6QZV9Gf2L2/AQQ+8RJ5KmEmpe+KXvh2dfMEezi86BLKP0oHr5nFt4WSVE29lw/lD/oHaFFqCEFSKVjEuHhpWLf/qQH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/w8IU/YoMlWKV6zR42GYD9hlnv5OPE7ODkxnEVlgoZE=;
 b=FQ13gK8LAtLqGErw98plsAfkRQwkJxrTzpp5yI5NspbHfxXrX6m0I3nTmMoa6xnHUwMrpTxXYJdSzyqBzUDdl1QO40KO0pA6mJDLCRCrK0/+ScxPdWec2qH+RtR6vaae22qmOEgeClSADUNVtD7Eg8krUd9RdtQ9p0T2Iof+2qg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4432.namprd13.prod.outlook.com (2603:10b6:5:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 12:55:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 12:55:08 +0000
Date:   Tue, 31 Jan 2023 13:55:01 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
Message-ID: <Y9kPpY9YmaALN9qV@corigine.com>
References: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AM0PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:208:14::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a3ae4ae-fff5-4da0-c40d-08db038a61c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mlv1PiEd/4Q/haR2rniy1dsQ99EW+7SZHblrjFjii2KNo0r34Hl96oN8kaMDXcVjNNCuF8BlTq/TEqQh/D/6ZVbDjfYGo/clrvjnJg1+yjKyuU3vvOhg7UVdp7BTtplGadDt/XrUg9vmVTukbhMoz1ApAG6icsC1GcjZhq6byXQT6af2goeJXsV+4BAooxf+KY/pymVm8YlCiMpdpMFwGfMfVgm45qkqAbgUN5zxXvqp4/4R/C5tEjWH1YvPBQelEME/bUtdQiyCqv1hZI9THvjmoPvFHTBhs2U3qGge3KE5SVMhCwTnVgsIqYQk6cEhpwaBpAop4sqIkDTFwTCjIyyfDYM8mG0g7f2agYcKHF3xKmNsPLebaAxC7NoFmXEdytg2nPKyfJHCi5CATt9nKd4+nNIXVcTnoFKEY7OdaBY5eeupjEywVIDCRa0zvXezC7NH/X/vC7ztzdV6pAscussWuBQFxPP+Qoe1/cmiBT1q8leq9vs+3nkqjMH1ZBaXyrC93joB2H0jFwKy9t2l3SX5ntVLwShlrW54YQYwt1floFXkl0/R2TA1US5Ov6yxJGFz5WhvVuw7glkW2JUqXDzLqIzyLhbqYBInIvY5gnF4y3Ln3ZdsFtENRtDU3QVyVijafW8fNtUrlnAi2hLeuhYb3mVvtD9xo+aJhFgVmV8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(396003)(346002)(376002)(366004)(451199018)(44832011)(4744005)(7416002)(5660300002)(2906002)(8936002)(41300700001)(4326008)(83380400001)(66946007)(66556008)(66476007)(8676002)(36756003)(6916009)(966005)(6486002)(478600001)(6506007)(6512007)(186003)(6666004)(86362001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zAsOIj6FXU/1pdnrahK2oJyGZMlMGQFFQS+kZohR2xiTJDSKMMMNr07QPJl4?=
 =?us-ascii?Q?jf/zquA8/v4BI4qee3jJgb31uVTlnpP3WGoTsXjB2Zi3Ib3KHvWp5Uw23Nvd?=
 =?us-ascii?Q?IG3XImtflYpgLMKYLPF4E5Q4KmRxfFVNHiHeidbS+2nFxl7ZEbiJohu64GdM?=
 =?us-ascii?Q?sR+QF3p+0Fog/VAGhBBb2c3SC4NRUJu4vnErwWRl89drT1xI1uA8b32VcKeJ?=
 =?us-ascii?Q?aGHiesA6AsRhpLgTSuNPYQBnlCQ7jw5drdp6uh2XiDpX7uoRR3+IYTYTwbpg?=
 =?us-ascii?Q?84UOKvJ0OfEfIX0rmuKEhwWu2qP0AN5fG3jqNgqiJR4xlp/XW9dNXf2M8lTU?=
 =?us-ascii?Q?mxdT5/+lCP0Jdj1mznehEJs+3SGfszKrJvYlXQff7p7Rx02bD3NWxowOF8qk?=
 =?us-ascii?Q?pjGIbKf6noHm9P4JXfdmKgSQnp34nqunL6f+HQLKJmz+4FOb2SrkHiRUeBfj?=
 =?us-ascii?Q?QZazRQKw+KRzF7OMiRbZt8K9EcJtxn/KNpOGX8l+rP2n6di6IoIEF5g/d7ta?=
 =?us-ascii?Q?dpWJpWMiyTP6OK3Z+8lJnyYElWBh3hSNKlXFyLJ9VY8mLhnJ7NiOMS6I4o5k?=
 =?us-ascii?Q?6awPZ7jXOIsqFgidN5dJegf5XIf6jpJnSm4aQUSX4pO15dVOXedz6TJ8YQ6c?=
 =?us-ascii?Q?KUNZlqmrmTT1qdNdXKe2W8h7ah7dnXTqjrlNWTJSjSOWRe11GK0XAzAkGAMr?=
 =?us-ascii?Q?GwJEq9WyGWuBBsE+dGlmfqjgtweZ6qOp253q+WeEzqlb3B5yGy3sJXWZ71hN?=
 =?us-ascii?Q?tu65qfKH++G5c5f6/59rxjbSSWpq0pc8FTgdOfFGPaW/87ec0+ET/tGMVx33?=
 =?us-ascii?Q?gPjVCLt4qIzpsHBP8RlEBHnUamwt+FixFjM+/Qd6iatMAGXAsXQKhDV6x4he?=
 =?us-ascii?Q?4CfVZ+EyFu7IgavP7amhwm1gI4qfuHGGcSodQZXePe6D85hS6Ts6hXZG1fSP?=
 =?us-ascii?Q?+IYlaNLTUMywycKd13mHNBPlTst2LIeqj260Ht79hbsQxkYV3trZxivWKClr?=
 =?us-ascii?Q?3bDYSro+q3OOBALIxZjWCKIBIG+iP+slFRVV0mmEdrOpS7WPJY9o5QcGzFzF?=
 =?us-ascii?Q?iFlxemheJQD/ZhihlyBfmUOYEIk1zxvOshzjEcINPtkxDLfZekfzbK9lolke?=
 =?us-ascii?Q?xpNkxwaCx4ZvfAcQmqe5qPomQOqccoRb4V0RPcVxTXtAHNSGNOtarp5OXC6I?=
 =?us-ascii?Q?hLNhKfKcN2Bsn2vneFgRTbJQ0PHpqPeoMVHmzMvhCp42KNhRNT2bmtdzR6qX?=
 =?us-ascii?Q?LHZPtDOtQBct5Molt4LbGsS/W/O5Xklbe6/Bw8yrUhiPEaax+Oc+v8t8GQBz?=
 =?us-ascii?Q?+hVPXdAEjQfWMVX2cdB1sWoybT7Zwr+SsJslVYY/vOMCL0dqJRSbJIvDK+8l?=
 =?us-ascii?Q?eC3AqdSNqopil0v7gwVW39ON0agn6VH9o7eTw4cFiSTQwu9Gxca3nkADBqfI?=
 =?us-ascii?Q?KQW6plPYpzfzE2J9esSNNn4ORnh+fbBXh9vWfWJIa1Oj2FprdkprJpFpcd59?=
 =?us-ascii?Q?h8uNzccZwayO89Y1gnjbh+3MJkP24SpC4oqzuYpxHkBQysYbBfRxEMx+Cefm?=
 =?us-ascii?Q?dWrQa5vsPIvsUO2m3vfv3mTNiUQ3EPDnvvIw8t7c61T+7ztVDxTGXuyJhH6E?=
 =?us-ascii?Q?P75QjG5TbdnU4EJXNGS5UnQ2CbcIeaOA2X64admzD82Lv+pE6z3q0VDIzGsu?=
 =?us-ascii?Q?1sw0hQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3ae4ae-fff5-4da0-c40d-08db038a61c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 12:55:08.6539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eR0sUgze5Av8PCzODs86mMwvVDNaa3L8QzdrNxw0N1kx4MT/F1XhnZ+tEojubHWtFvSTLZG5/vYhuFC1QjfmLsgsmrcdtOmLkqCrRUaxBi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4432
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 02:34:56PM +0800, Jiapeng Chong wrote:
> Swap is a function interface that provides exchange function. To avoid
> code duplication, we can use swap function.
> 
> ./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

