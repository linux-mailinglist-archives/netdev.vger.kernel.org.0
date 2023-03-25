Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58DC6C8C9E
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 09:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCYI3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 04:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjCYI3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 04:29:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4A132FF;
        Sat, 25 Mar 2023 01:29:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6Q70zcrBh/w3YPEf2Lr0GZR9yl9HhJbHaQuQkGExFiC2LxjOSSEKtYx/indsq4wfZlijvUrSV+FrCCCP5Z3q4mU0COJT/98iEh0aafMDVIQYZ7OyyBWRTUnEE5c/x/Cwjzkbd6KvdMViKER7+eMUFyT86AiNsB137Fp6K71AYcoyeDEAZB6iLgFi8L1yOhxuek+O3BS9Orgd6R3W54b3WdPsXeUNOLOQVX0/aQ8cFVoaVfgqogkOBw2DpCvYhs1W7QViJBTjUX/NATklI5wG2ZzgmVyYaIdCDjAlTTlUfkcJjoY0aj1bottkDepEJ3W6pqt3+o8UuuMyCXjdavDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIEpkknAula/2tkcYtrMEFmwnuL6tdv2pxL0e3IdOIs=;
 b=hffI6Z7b+sCS6VwCxzN9mrxgGLDcmTJQz87cFBihR9CnKByHzk2k5/9fFLqXlUkf9nT48IWnNj/yg+it41dV/8k2HXlH1S8EEhdG8qkzeseuZbiNA4awsYvCc3++Wf8bBO87hJO41t7t3bFbLc80XgfoSp4Elj0z9CQQkxdGpASAAZ5t4fotu/wcMJINIE9lRoeZrjrhP9WcCQNhw+5C96iLoSXgO8n+UryleAqGpUQWBrK7vpSpwBneVup+qR6Na50jdOyI6OLB3otInGUd/XvMWqp6r29CyB7zyChJ9+60RlbCZRditrRS/30ZjZC4PFGvH8JDZdMmsqF6pFtUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIEpkknAula/2tkcYtrMEFmwnuL6tdv2pxL0e3IdOIs=;
 b=TQ34O0aY4DSOD+Fydsc1JC/iEm2+r+rb1QfVlTaRfhFLQxmCk4+s/PsFB7iL10uQM16vPugCTO7hsUgNNqMcaqSJf4IRpr/kLMALSd6fxNEVkJZ6MUHM8/4TFo/odln5zhib4PCF/O3j58n7sdMXLRu0KhG03LdyVdnopHbZYf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5834.namprd13.prod.outlook.com (2603:10b6:8:41::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Sat, 25 Mar 2023 08:29:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 08:29:18 +0000
Date:   Sat, 25 Mar 2023 09:29:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 09/10] net: sunhme: Inline error returns
Message-ID: <ZB6w14Z88yA7Hdp/@corigine.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-10-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324175136.321588-10-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR01CA0168.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: 282c021a-4e18-44c6-4990-08db2d0b0663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fDIfTl8ru3wRFTQ/n3BIZLGzQrhyBSCuk5TrOmbMJdCu3QI+4h6ymXTDu1kxsqJ2enYQWqlkw3lwLxHX0tEVjJACh56HjEBNOvPJXfIScjVu4/NoP6PytOcCKG5gpnMpdE4z9QmqPGrIDIWfMYs+pKA1d2W2KFsNDZ6PtFlqnOo7CckxZLldV9viEGqAAeGrnuRmqhTojrxPzGFW23F9JAocHwINM6DX/r0X7MKVKcZmQv22COEw07Wz+UC3bFszrtVJqzkb45c1nOyK2ldbWXyzKzmlTyizpLvr1LGZzl3IkwMo/UYVrBAHIQbobh4UNxCA/mXxY3h9Tez2s284/DrpCBmJxBpUkmeOyx00LcNAdpMvS7TEWmmDkNygOLD/6245ja56M0MhDmwmcMFNANmnwpP/K92rqeU6x3CNpqPJcIC/DNMx6sin9L8dr39KW+lqhP4pK10JmLG4B+I03/ejS5xk4T7ZWr8fTJYGABb6M56gQSBAocu1V7/h8jAa8oXoMbPSWXRALHh9JfKJQEDn+hkMdOM03A6JaxRcJNY0EbhJD29GqmpEXO4baFG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(376002)(136003)(346002)(396003)(451199021)(8676002)(6916009)(4326008)(2906002)(6486002)(66476007)(66556008)(44832011)(66946007)(186003)(6506007)(6512007)(5660300002)(4744005)(86362001)(316002)(41300700001)(8936002)(54906003)(6666004)(38100700002)(478600001)(36756003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tsWDudFTvYk542Q6+pQSf5olacrk+X/TUGZ9XCsNYxPPDrAHjy4atCKh4Chu?=
 =?us-ascii?Q?9bq9cgsnHXx12z8DGzJ0SUHcyXTzRriU4y2kBeXAEeFy1vRFGICm+r7tTAAN?=
 =?us-ascii?Q?ROkozcXvVfAIXnf7QBRZiCp7vVXimw8A/5aWJy6J2pXN6DAE7s/7pkh5Hdvr?=
 =?us-ascii?Q?qfjp4mZBd37cmOBlJ/3kFJ3iOmZw0WT/oaMBwfIRy6x9jNeCjOdY743UR2yJ?=
 =?us-ascii?Q?/B/BPEq2uMhx6EJY5lkKBm43NwJ42chaSU+xLFv7YIiEgiixk0kCdL4yHRAn?=
 =?us-ascii?Q?59af7k6NNMg9jVwz4EACu2oYeV/6+PBZy/I8fjzqWA8x6B0pJTrJalCQhHGq?=
 =?us-ascii?Q?8yIf54rKtym+XNUSKNY8yx3JacTruSuFVwfUkiSUJpsdDZ0sq+DjAsyYhIpn?=
 =?us-ascii?Q?HKtV/tpYzmhAo/FkyVZu3ewXE0AuyOKywvDw+crukZotdJeNjQWeV0zoDUHM?=
 =?us-ascii?Q?KlmvDcOeav8Z/xuISLWzbE0+Um74eodCEp+bpt1klI6Uv6+ox49rHpmNsyuI?=
 =?us-ascii?Q?G0jtgUjs7kTU/EH5QNvAMkh2fFNdNZT5Y9EJN215Qu2HbwDbCoSFm+VbtV3l?=
 =?us-ascii?Q?QC+aosBUaHWqsxj+GTVyfBL4CZsBaG6SJtUE3Tjbw2SVoPp/FQNai/CFGxVT?=
 =?us-ascii?Q?Tq7VOJ7S+tf+gamVh23Sx5/cSHoFKj/Txv1ujl8HBkjPVjwsBtcD4EJoXCdU?=
 =?us-ascii?Q?X3wuR4cqkkq9siCK9MDjplyzclc3Uv6gCE0cTyl7MSQ/hxesh7ls4+Vi6N/e?=
 =?us-ascii?Q?h1h6q8fNuk1CznuPih4dHGddJXg/dKs3mGbw1+d+ZFHFDC+wZZhtqNVGZm6P?=
 =?us-ascii?Q?nYdSs0U+xqkkruLQzrQOVIDhA69i/Sj2H1BfLrR0HGT4CAO92fp7HVPKSuab?=
 =?us-ascii?Q?DKwoPdAyS7GFwQns52uqxwnayodOFpCmhqnaw7FV111wEDzVqLwgnOxdW1ZB?=
 =?us-ascii?Q?8d5lLl75oqLHIstnXzOIntyZb3LFczV+/hRBkGihuzdw6nBiBK40T9d9GX34?=
 =?us-ascii?Q?hGSrXUoBjovt1g1ojBbLF/YOmKBle5xC5BsBlYduvXnHYeI3i+fWlf4l3Twl?=
 =?us-ascii?Q?Pmpje0coy2zxPNdDiJpKo3lL2ON6pEQY20Yp9f87rY53q0NmBGBudxpPNCTa?=
 =?us-ascii?Q?F5hhYrpcCGBa7Vm+rdtnZtGMhnf8yCmve8BVeevSQcnB9K6uSF9jqKpMMdST?=
 =?us-ascii?Q?k4VQlVdNyq+yuvpiNpUtdInwRkd+u5BgzXmNHc7EGClmZvrFUlk2O5pZDddq?=
 =?us-ascii?Q?vBcO6o0qnJpyrzPUHi2wQsVtNaVEeIqPCL15hHDRiXOO80GchKFqD6m/tQXc?=
 =?us-ascii?Q?cmXLXgNA7hclhdD+EeT0TQZIRiUCGZFQbjYhoDLbD2pgwswtEgj+vmPHUUIb?=
 =?us-ascii?Q?80b/1trlucvZzWtLJQ2n5to6I3XcNvICU/mUxtK+xxdbLOfgT51o1ZVG0iw0?=
 =?us-ascii?Q?rfGZ0TehPSbzgo3I/meYPrh96XmwM06ZK4d0+Jx422rQ5tQKzw5Xi4mQMNKx?=
 =?us-ascii?Q?7IEntKvb2K3I93vEI6fGGlJiRzEVdcn4ubSH2CO0PuVsmkryYzPhWU12f9SX?=
 =?us-ascii?Q?0aaHGYlsn+sY3/v/bECrNbrCDMfT9WY5oV88RQbRLuv+QS2fUdYY/W47g2AO?=
 =?us-ascii?Q?5F8nGtQvI3b+8rfeMBDi7DrElyGwYlN4RcQsG4gn8UDs1tn+rVQCcuw5LQVc?=
 =?us-ascii?Q?vtcTdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282c021a-4e18-44c6-4990-08db2d0b0663
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 08:29:17.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOFVFxOrctv8jr/AvNWPqAC8TP3e6l2eWwyuv8yHpUw0kFcqhB8ADgsyx5QiyyXP8XwTyAzr7ssQY3K8XKJ6ABJqG/GcDDHpuDnz/ciazdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5834
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 01:51:35PM -0400, Sean Anderson wrote:
> The err_out label used to have cleanup. Now that it just returns, inline it
> everywhere.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

Sorry for the duplicate, I previously responded with
a different email address, which wasn't what I intended.
