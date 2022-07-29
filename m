Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6F584B7E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 08:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiG2GO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 02:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiG2GOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 02:14:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2133.outbound.protection.outlook.com [40.107.237.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88A67D78B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 23:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHFE3rac3dyxM5wvFUknNigM+3RJ8wKA2I+FXd9PRBvKH5aoqagi3AQjj7NFP/64RqKRiCLCLeqikkbF1DWYYBGwh0SK/9rTD65PruMqkKr6kb8XRvUbYWT8RHZCdGlcHfoMq9XIctRM12TEtLiY/qe6X6Jb5nVPaAq8bqyil3xMGO3EFRJRMJsA7Wgu2B6//BOq13+Z0m1nHcLm3VgIIXAMBU03QSwHpY9T+WycClryq9Lpbkm8fNIdjXggfi9rVVSoUnGc+2MkSH9ecUwFtUC/FITC9IueN8wpzchHBtvPPeSKubh5/yAr/4Xe9XZIZ2I6DVa+vUpSIZVrUSIpng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oosmDu6IiRaoZwmKV0sUzmSVceOpWq+gc4lt1r+rdA=;
 b=XoRvspv+5iOeIck1teYKXJG9I/7iOviCz1giJQLwr71c8UGkdOnAXhF1k9fPkx1pS7hAZdUY/MArZ7/Xh0784n5kejMDVC00BKyl3qISTeDVxMGeI27rJd8S6/GTBwnnmv1LLH61P/pcDHhvIdF0HeO7eTJU4H3gUXYJ1jw/+VugxISG8aGnIveVCuAUYZrkq4yXDDvOK4TSa1McPbSrjdILoA6IPRWZTyfqsjoBIPCoJ4aUwQCXcTfZCRYWv4k8+gCU55yHw76vx+dKzxpb2YuyaMqcBVcXRIEUecIlD9/qqfCUEwcby5kqUQ0DIhpkqM1zO56m1xacnhjnJtA2SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oosmDu6IiRaoZwmKV0sUzmSVceOpWq+gc4lt1r+rdA=;
 b=AVIAxDFQ4pIIPc9HG2o7HUN4eKschf9GkHdvU9ksCIA9zOU2uOHcaiH2IPeFOiL5StlR4q+MkKGNvzDqGMTlVLQEJIy8QBFlyCOitnpt/pSfTetL4m4LOwkqFNJ/TpIInQUjmEn7R6blYGNihIyndPCRpqVTKGCW9ViOzjgNuKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB2524.namprd13.prod.outlook.com (2603:10b6:5:ca::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.15; Fri, 29 Jul
 2022 06:14:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 06:14:31 +0000
Date:   Fri, 29 Jul 2022 08:14:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [net-next 06/15] net/mlx5e: TC, Support tc action api for police
Message-ID: <YuN6v+L7LQNQdbQf@corigine.com>
References: <20220728205728.143074-1-saeed@kernel.org>
 <20220728205728.143074-7-saeed@kernel.org>
 <20220728221852.432ff5a7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728221852.432ff5a7@kernel.org>
X-ClientProxiedBy: MR1P264CA0154.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc98a932-70e5-4b75-d62f-08da712999b3
X-MS-TrafficTypeDiagnostic: DM6PR13MB2524:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXMDdom1HZ/TQH6EwZmJWAH7lMyDu7HZwM/2+kPFFU3j6v/K0yh5yfXqjGC3PEu0AWy2J4E9Su035sM7HGGim/FnZT56uAY0RBNbYF5DCR+4gyugEzN4EyFhAyQhO40BRkhHzs+4M7GiYY+UPBIMXVZjY+zQ6mWyDjXBijHk3KmE+xgmTPtmn05V2nvm5gf9eXJiUAPe2oRups42MkP7uFsWPaYeUXvrGiaf6RQ0mSZEDkerIBKKTJOTIm/15+b8wSbuzGn6Nr1HDaH4VceD7jbdxnRcjUfPyk2h7M2gYRa6LbugSBljBowKXbGK+uPZ4UCWcoIMzuztc55aJjoCeMuavIBgPsHQyH5ThlnIejdUMnSXO4XDoy+pBgcTQb8IGap9trMDSQC1S7PX7LQCZ1Ami0MUnDhJJsYWgyl+vBajc7WWgal7ttfAc2q7hNq/hHk2uWc5Jt6FOd8EHSaSPNvjamjqtK7uErg2jcMN6X+abct/vbQK/1LEcmtTnT6L6Fk3qcigmrCoBf8suE8hvh5HT6OPUQ8gtq9FJWPejYNQGYzm531TX4BsIQszKvDHuLpwmgN9BBUYhv/nj6AGvMqyzL7CL+IKPJIuniBbpI1rp8N+HuMUL2ijygDQLnKmZ/YPET9+h4oaNUhU9mC5SKD8xvlfvWDHhaDIAVc8kVSeHgsgwdT28OGCS2fxk6/tICD6wPZuiO53AKJRiRNiwB2WIytFZsrx9yN4vVeY0spu2MnTLp7eoVR50iaBWtLXkWSn/PzAVUv/B5uP716+H3rxqyE95VcrBD22UMnVrx6aCUaRLhb60bSKYcZ2Ediomg4ww+MMLSEYPHX7Tn3YZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39840400004)(136003)(346002)(366004)(396003)(36756003)(8676002)(38350700002)(6512007)(8936002)(478600001)(186003)(6916009)(52116002)(66556008)(41300700001)(2906002)(26005)(6506007)(66946007)(54906003)(4744005)(86362001)(6486002)(44832011)(316002)(5660300002)(38100700002)(6666004)(2616005)(66476007)(4326008)(107886003)(7416002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TVmy9vsVFeltT1gyzuBCguqkqZigIR+ha3+tN1aXcf6vP5dd2tFmLYHq6yl3?=
 =?us-ascii?Q?0t4BB9JHKQcox2VgjSF/0/gQG9qYLWAKfSNRd5oztZ9UhMeZ9NLjg5g+6KVz?=
 =?us-ascii?Q?ZmHMpYET9y59L3AFCw9Y2qlDh3gRmAYB5AB4Eu6WkLR9wokzCvYaSvnepy4G?=
 =?us-ascii?Q?wA7YXEYKRIxyIkKPK2NNk3m748tOfObWZOtE56G5l0FSLI4tqy/Wi/hWyDQh?=
 =?us-ascii?Q?Q6jVN0jfZ2VVRCNOgApPu0QTExH95KrLnVWwmtmE9cJiI0qs0XGyP0BKc70n?=
 =?us-ascii?Q?HiumeCkhCTWi0DCxJ4vYFZikMGRXxmd/5A8DPFMWLiaXaoEmJUfxD7ebXv+E?=
 =?us-ascii?Q?iiWv10Kn7jvyHN2Grsfi6aHhXibP56f3gaqBr1ix79uUCpR8hx6ziGLWf4hM?=
 =?us-ascii?Q?Tpv9zGRAZ9fezjzI4WS4G2sT3gRLN0OwTn0weJPB3FkvbrDYYKAxS3/Hv7cJ?=
 =?us-ascii?Q?xPeyPSCcUFNIXeqzP3gk1cBM367j/C9XD5ORToJIDVcJ4sPLHbHompR5K7+1?=
 =?us-ascii?Q?96ds2/26e5TvqUwlwdKMVcqZKVs2fycfq9D/jqo7TsxISfC4qhP8up10xM7+?=
 =?us-ascii?Q?hyvJXQpNpuNhmuayzAzS9ahjWcZyJxJiVcUM9Fax6auyKx8H7cCNqXxe/wm8?=
 =?us-ascii?Q?Y+GOptO0wAditGXEnCeMiGC+XHjdcSbjnQnq/WUoy9gMPeUFehYrvZB36o95?=
 =?us-ascii?Q?RtrF521ZaSXwMdx3qcK9+5FdiMOj3xPdF5brCFigfl4CemKUT9cZvKk97o9N?=
 =?us-ascii?Q?9JhzXc8g+ssZvsxQCUr29YsiEDKyHlyAokwvRmkM4TvWymzzC/4uRSptLYMY?=
 =?us-ascii?Q?bchi6B4Ro/FsC5KRl8xyhm8AtY8gFBJ9CNDjP3xvLYP3TaQNXMRuLki4pjkh?=
 =?us-ascii?Q?/zFsti6SEZ09hDDHo9WQ+vKtzEaZz1So9GGdb3iIs10prKxdKF9Y5mnrivz2?=
 =?us-ascii?Q?ZaaQD5ULszYDBEGHT+/uBpJKOOyVfGcHeRngj+NzOn28uewnlaVsSOXzpSs+?=
 =?us-ascii?Q?sHjRsV9/VjXY7Y7X0J/u0IEQSagqH7zQWhtzQ0hxydztcwp0Pt301xvenQ4P?=
 =?us-ascii?Q?Uuhc5zr75d1uB8fm5Bgk8krZkfibWdTDBaLu82iRSFn/iyZ9/zETlawXqMa5?=
 =?us-ascii?Q?GktuRvjbq/VUK/jxj4JcQevQE7SA2DkFgHXO3oWif07oj8acNPpQQqt8sfqj?=
 =?us-ascii?Q?pbGnE6412hnYoklI1kLV2LC07skYH1GnrYMg+qeUS7c8HTOfPpb7trBX9vZH?=
 =?us-ascii?Q?W+2tyewYEub/MYRu0rf7x9r0LpKWK6VYNuzdj83HZazUnqwM9KaRLYh55F/Q?=
 =?us-ascii?Q?tZeiMRHUL/WHm35s4VRxqxerM0Lfn3CmNA2Z9cNGNbAjH8U/qgDKHeLKZqv+?=
 =?us-ascii?Q?SfxAJ6fZZtlUQohP4N822iPLGphJxwFEZlR+K/BBQUHh+mvfkJko3v6XN7I6?=
 =?us-ascii?Q?oADU5m4ybFCHYmQX1LSViUtL410Rw7EpUWD4RWLbj9adTq57LT1uETwtdTWy?=
 =?us-ascii?Q?vrlm/xrtEl5gNqkp/UM0iV3rMQqhBVvCkeNi8EUJnbb3U24/Brgxt+ri8bsZ?=
 =?us-ascii?Q?QzqcsT8DCe0K4sXqZgkEbdDBCTqbWUHgQxoDolvksOcUAQrZxEXcaHNZat5o?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc98a932-70e5-4b75-d62f-08da712999b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 06:14:31.4675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nG8KTbB9M90T9E0Nm+wRfhuC2lotsEOZK09TF5nBr5atlJ3qpFU2K22xZ5oodMIz5tqydm3dQZezEVUxL3svboXp56qBlmcdXQSa9aLI6C0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2524
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 10:18:52PM -0700, Jakub Kicinski wrote:
> On Thu, 28 Jul 2022 13:57:19 -0700 Saeed Mahameed wrote:
> > From: Roi Dayan <roid@nvidia.com>
> > 
> > Add support for tc action api for police.
> > Offloading standalone police action without
> > a tc rule and reporting stats.
> 
> Do you already support shared actions? I don't see anything later 
> in the series that'd allow the binding of rules.
> 
> The metering in this series is for specific flower flows or the entire
> port?
> 
> 
> Simon, Baowen, would you be willing to look thru these patches to make
> sure the action sharing works as expected?

Certainly, we will review them.
