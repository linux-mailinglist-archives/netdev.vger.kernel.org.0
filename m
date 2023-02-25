Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0556A2AB5
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjBYQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBYQaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:30:20 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2114.outbound.protection.outlook.com [40.107.100.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1693E04B
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:30:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBzCRtmJs9VWnowQN4o9vVPg7iAgQh+JRkxUlUfSJEbYxW6/8d5hqz/11YcTTSL4EY8qmbsqqMtd0Ep0+pDM7ap0ztiIX8fHeObrjun8vqlKe67RKDrySsl6Obwhng8x2cslVVTx07o3QKBPuC4cUGQivhDCLT4wo/VoKVo1jBW+qtZTCEfVu25jT2ENlzfvLOLMj7tksH1Zu1k30BBaXENmThGGJkAtNW9zCU7JgkZ4MoXNZrRbgpdSCU/xD3bqFCBqJeLxnXh7C7JkQvw/z8SyFjwn3XITMHBq8/6ghcRnbO0Vuq1c7IrGkr4/lxTo3TORJC4Oubl+A6VsP0Gu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuclT8QtmAdtLf1BfYblj1ecxSuumJHDJ1f52pfGUDM=;
 b=V4s3wrbaEdUx/5pTHUslBDP+c5us8ZCgiBhGxrnft+OVkHiKHN7SKSMzAscmGvfvDEIMJllexRFaF/SXyHoeL36uVghnFvIoomchU2ydYcv2N/3lDo+96w9K+yNje/8nsWvFttINssg/d6mgLnkd5mJT82EB17gLOQYiyr7aZPSZfuYUW/MRPXkrlZFXZrwR2y3cEdGtT53nIk5iUjtsiKk1PIIk0ihfvAdKERum6mAQ2AJGRYIBGhaG+Rt1dMRLuaW1wGcP7cH/Vf/NCVlIhW06F/PfPWEjpWjHbdbjfenf5TN1DDlLNaXeRfd9CWaPaZONsz0gzUFaD6TKgwMxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuclT8QtmAdtLf1BfYblj1ecxSuumJHDJ1f52pfGUDM=;
 b=p+dFhSLwfo9bYTPjRg/qhKnC/OBqREYdXom1OBBkFuqlJDgmIF//zn2422qm5eoZO8k9qCjLme+czytg25Ifu73Gg4UhH5ZFShB8sh9zWqEInaFjMgIuBJIk5RfG+DbuSJxBhA/wfNcBqVxbLB2LImvKwLiVEMMu4/gBCuEbCvU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6269.namprd13.prod.outlook.com (2603:10b6:510:250::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 16:30:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 16:30:14 +0000
Date:   Sat, 25 Feb 2023 17:30:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, liuhangbin@gmail.com
Subject: Re: [PATCH] net/sched: act_api: move TCA_EXT_WARN_MSG to the correct
 hierarchy
Message-ID: <Y/o3j6nk1roVqzNH@corigine.com>
References: <20230224175601.180102-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224175601.180102-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR10CA0073.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b11549d-5955-4ebe-0cb8-08db174d9269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yCl35nXVW1U5/OYl4IYtgdQ8dG9HsoFS5R6RJ8zq6XIx6eHxgiS3NbLmrJtb/xEtQHEsTaUKjaMm4OfTRmSlafhcnOv5DWzfc8ZyeEGOqLdXEGzcngkGWR9rO7eljcdoL/eJSJ8d+ned5cLIA+8Vi4XygCrYutPT+NmIy5CIKyxRcPQRczDb0Uf0YzqJl1p/T9B9c1mVQzNKM4jx8p5JZ9Ktq1X1cJNjtPtDolj/2hPEVJZv8+5NLlo1+QiG73o6B6WOaAaXXZMFvw1XdeJ6GQTcP9r6eOyzYgvPgud93C5WyDTOA3jznuPhvmW6UbBNM74dD0tc6ZkKEUpkEWoGrd04kVy9FA7Ddy5XIWiF9SL3GVWknGFXOjIufeNlHEhHse7dXe+RrjRx7iiyp8ew5avDHJEWUcqbBbE6omOIpbEwpkb34ZwEBU57oY+psCeZORIPIVJU1qh6uOlU8UO3Igj9aqW7ADt8e+qEaszEndmH3IsVYLUUddWsuusp61/p2g5yilAAy/riHfzH3TWlosLDWlvw0BS4wXteEDzyxzoHAgPTtk0yYpdwPlQ9y/CdMdJMIov8zZtPNH5bpEXkli6FVN4Q9Qnv+NtCH1kq+bJBeJsDvs9iRJbcRlrqxe4R0DsuqRWLxPm1Ubc4LcOV/bUxYVu8HhEswFfNyhOxxoN0qrmueL77k4LM18eHswbt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(376002)(136003)(39830400003)(451199018)(4744005)(6506007)(6666004)(6512007)(7416002)(186003)(8936002)(2616005)(44832011)(5660300002)(2906002)(36756003)(83380400001)(38100700002)(6486002)(86362001)(316002)(478600001)(4326008)(6916009)(8676002)(41300700001)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1MMuKcXsqqBKLs0El19Gp1h5eNV08PL1QfmF2q/X8sDkUgDnWaN/SlOMET+N?=
 =?us-ascii?Q?UKZw5GrsRw+2bGsM2ijHk1m/GXoN94I50wTgUme6hjW+BjKNKfy0AzLr7FfD?=
 =?us-ascii?Q?PGXxF8UH6SXeg2t/zmetwwi3MhCwhB+wO4NraZmxVxOpWli7U0HBeNL9bWq3?=
 =?us-ascii?Q?py27QOA//RWCtAFszYREEpCxDDQduD0U8GchShVuRZB21PK1nReAI9BMijsb?=
 =?us-ascii?Q?BI9jmRp33XxiDyJtUxt+6BinArgQmnBShYXi7CCRxkckPbu/5XHbwZW8u8yD?=
 =?us-ascii?Q?vpYPNBkaYES/hqI8kyikcZit0QUFDdFs3juyznIlwHJV2Mnot7jIPNHpSqdq?=
 =?us-ascii?Q?mUjVv3P2ZStZke96mJmc3feWnbIwT6AB3a1f5MSfgn1akwwsN9WOuINeBd6B?=
 =?us-ascii?Q?e1v47mpocAnW3syvLx23RcanSQ9TT8H+Z9ejZ0oegtNHUpaw1s67o5F8RiYt?=
 =?us-ascii?Q?f7qvXpsvbLzoDK/zQoVD35QMpmlrzC1YHzIk9flwKrYWALGJUr7HKuZcUk8/?=
 =?us-ascii?Q?73i0knuZwb+0s/YSk23HEzOSatYinVZLZxpcsZ/8LtpKjCypBNUTtZ/7kSp2?=
 =?us-ascii?Q?6KhtBJbF68zsKKpfUI/ZeJ6YRLBKrgGj1ypo2oujubMzjErYHQOH4ufoNL65?=
 =?us-ascii?Q?C7KmZujlDrzBtR02WTUqPFAeNQ4XJKvDaPOzLB390YvUdjup39TghLYh2GEF?=
 =?us-ascii?Q?Vf/PyRX5+2HKH9d597tXPQMpk5Xqf+zbdEGs51qlJj7aQqVqZKHv6vDzxAOj?=
 =?us-ascii?Q?SxObwicq6CXFHbAwKKKunl7LJ6eRb/2JQiRcctWfwiOCIKf+qTYwJ2VQMqJT?=
 =?us-ascii?Q?1cWqp060pAjtT02eGkFZO+6hELlYeLLwe+VoVSyD302mWmCdFsuZOdl1GHhq?=
 =?us-ascii?Q?0FVsWW5bB2m5kDYY/Sz9lEvoCUMg7T/54OejeNNM/BF8yLtE+aKXARHMd2hk?=
 =?us-ascii?Q?oxED6uGy4TUPr8997xljuNzHZfcfIvlJsJdIrpTiYJsn7qpVWy560znwautL?=
 =?us-ascii?Q?zrohlpTsyuhm06E0Zl1mq82J48gtu7YZcEcXULp4eZgbvyxKRGR3XgHkaVPd?=
 =?us-ascii?Q?BHWDyQbpZO09CSL00TA5f52U7NPpFFl9bWkoHJqb9q1Iod5uZTEWM6bNTGcu?=
 =?us-ascii?Q?00dinQXsJEFCw++Cu8uqCctE3MEKWVYOdyZBO+1p8HSHmrWhuUXpuUr57kDj?=
 =?us-ascii?Q?NQ1Iv9lSXRS6C0K8K6f3YLFkoHOlTZiSyjXet4a0rTThacPvc1YOpJUkULvD?=
 =?us-ascii?Q?op9YOdh9OI3K4n7EpqmoSX9/3S/S9ogiUjB7AkiXhzvcWng1A/qeCU1Hf63z?=
 =?us-ascii?Q?/uqL5P/XYE/jNlT1LIgkYxO/y0kq1hK/Kvz59zGcK9Vrmf1Cf0jWDiLxIYWA?=
 =?us-ascii?Q?buH4l5xqzF7V/tvvf34ad1Dq5pARtn/qSQAJGDf3KRwvhzONn8p62P9VMgz7?=
 =?us-ascii?Q?W7KZfIR2SNdLBk194pJXFpppmy5YfMkgN4WKd+tPiv8LMI2NSzFl9ZYnoLVy?=
 =?us-ascii?Q?PpxBRWVgRdREWVZVOtTsjz5hLqTkgkIgHvpqznpx1CzX5tHTuDvyAA0fL/9h?=
 =?us-ascii?Q?N0Zo9gVBPPBwxV2CNt6Qa+UAnW8VNkc9Q0YoQsW+UPdjXkNy7R7KIaTGh4ck?=
 =?us-ascii?Q?nwiHWMQSCc+UvBzLtUaIDGrS3/toiPMqdIRyT6SFnxraxtbkcqG4F7JPsjTp?=
 =?us-ascii?Q?g7cXDQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b11549d-5955-4ebe-0cb8-08db174d9269
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 16:30:14.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPOk61178cXUWVDyXrvL+6nqci3Q5M6Ni7mMgIVYLlOZzN4cOPeQUp8Xuh6JMOFg51aOqt42EupY2i8tPudtigd0XGk+eiDl340OA2iG3A0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6269
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 02:56:01PM -0300, Pedro Tammela wrote:
> TCA_EXT_WARN_MSG is currently sitting outside of the expected hierarchy
> for the tc actions code. It should sit within TCA_ACT_TAB.
> 
> Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
