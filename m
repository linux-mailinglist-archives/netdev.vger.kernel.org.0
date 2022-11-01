Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E061431E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 03:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiKACRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 22:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiKACRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 22:17:43 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022015.outbound.protection.outlook.com [40.93.200.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93351261A;
        Mon, 31 Oct 2022 19:17:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+YsE0enx7GU64bzc29E1iQ4Ia83nnof1tilBCkBhYbzExuG+ZwvMSCa9Qoq0b4wDii9SM3XKeiTIzPZ6XBAqh1dLGN6hi50YSJm7TD1j4MtifxYpGkFij5AG94QEzWhp+JMLlMXTHg9DNY2oY+e2WJoPbPkw4fztJhvn67ry54MKtmb/AO0lCdEUkbNHfgG8lIIske3P2J9beZGzGod/1FVoKBoutPRBHTOWVx/m+mWp6XqFef3vGQg3T8lBS5K5OE1r/cABZxO6ZDts3jQ9blAaEj48jqbWS3M446bCGyt+8G5xfHolEHj9GopoIversiGKIKNe8FrdshnXW/meQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebH3T6d8wTbz/tgUx/Y4uwQgZ3InCnIU1zm4bkDZ0/4=;
 b=RAP1HkakilaWuXVUIyxkDnfd9uIJiwgKMslg6GBun/+AkflbLyFTUC4fuUxb93bPYJnKJyK4VqF5Nx0SEu+xSOCco4oC86Q1k+bOcjVqJq0zb0zqvFyUSSMvb5WUGYHhCa/94pZH+LnVjSI3XVDSPF70/n9+I3l++Q1gnmNt2b04GPfMG/bRh5zG1Vmz5CWR09SWbZs1vb1pTS3cb7gg5XAgw22dRFb1EoPSbKltCvYNEvLb3f4/6nkhwmyBv4bsoHhDVTcu9HIfC1CmzszBa3ZnTIGbLPT/xcHOn7yf65hMQiAGTTPuazn+DthPnXqS1Dp17Ui23MlGGlrvbv+K9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebH3T6d8wTbz/tgUx/Y4uwQgZ3InCnIU1zm4bkDZ0/4=;
 b=bbngdAFVqcqGgMb/rd9QqSjtcLTWmTe1bZnf5ZvBGakFc3lNOSlzW+uMM2OBhat6mwP8FBp3hUP/obhc+AXdLDp0XqJNYgyrh4HHLUGY63ybwMbpQj58NyqfI3roWKDa4DZ0Jtn7W9ylKpyGPKnWyHkCD8hCZRJiY/+bUuw7IB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH7PR21MB3140.namprd21.prod.outlook.com
 (2603:10b6:510:1d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.1; Tue, 1 Nov
 2022 02:17:40 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%7]) with mapi id 15.20.5813.001; Tue, 1 Nov 2022
 02:17:40 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 2/2] vsock: fix possible infinite sleep in vsock_connectible_wait_data()
Date:   Mon, 31 Oct 2022 19:17:06 -0700
Message-Id: <20221101021706.26152-3-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221101021706.26152-1-decui@microsoft.com>
References: <20221101021706.26152-1-decui@microsoft.com>
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:303:2a::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH7PR21MB3140:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f74a72-911f-414c-a920-08dabbaf4039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmAIeY8tBdgTyJ6dMNRvc487Z9Lj380s3o8V9cXGvnwf3+8I0hUwqoBappMiBi2urFTmx3P/D4Jn54G2DzJRHEi471q1m334ffvR3SOR+6ndcMwhQXVc7Vylc3CCQvzfpI/kCdivDraVijRjAsqf18Xb/Af3bqc8n0TQ3Kktft4GSpdeqhJDd3dururHZp5hu2KLWF750WD5oVrraQaIiT+nXYumz0VlzNO7zeIP7JQ0CsezKexnkN4xCLIjk8aBcF2tjnU+ngTMuDhvwSypoGcSgOBmXVik+cRPgPTgif/MvmHyJAFhoZ4rQm8IpM0MwC7j8Y/e/yEAmADzZXnj6gvgE18P/07kc9db43NnuRTEQfLmm2R92cEjfEhH2H20TIPHSj7fY8HjVdd/aCdmqDqQjBTDtSFFfwCfU9bc3dGYP8lfuAh+XcPgwjOuCC+Z2bf62eoOijJfHCpEiRPj20NV6sZCWHm7GCfJuxGNLu18lMqDqVMvnnqubjwS9+gmEko+aaL0XmCYcTXj3mEK/rkfnPjy4jWh15zFRZVU/UVa/reXpQlSQXv+SNiCVcntOEnYq57ewF1XEYlKrnZQYLXLUv2889kW00ytRNenuqUmcCb4uDsxhiRlJRscQxKNKiJQ27NhABLoBOFdnwFU33Q5c3wKbO2034SCasWASfI+3qPRmlIhttkIjoqWV/hk+/mL4l3gQOktDW0zuk85dR9WxwzGcI/cgMtsnftAczFvZq98cj9A70svByMFh8nb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(10290500003)(316002)(52116002)(6506007)(107886003)(6512007)(6666004)(2616005)(478600001)(6486002)(41300700001)(8936002)(8676002)(36756003)(4326008)(66556008)(66476007)(3450700001)(5660300002)(7416002)(38100700002)(82960400001)(86362001)(82950400001)(2906002)(83380400001)(1076003)(66946007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GkqV9cxxC1T/MvqYoHAEd/faJQKBDkoByDKqPA8+VqqCreaoMpwd9ZluK9dh?=
 =?us-ascii?Q?Vtfma7BeDQmu434twndfSt0BV26l2IZBy2YDo4Kp0v317o47+uxj5zMEUa8P?=
 =?us-ascii?Q?HBFAKWkQ+Rq2o8j1nR3lth0G96p/qTsAbqoaAiKE0o/c7uxYvw1h7JFoQzJ0?=
 =?us-ascii?Q?sUGRugeoYKORVcZ5J+Rikc4nFnSPm8kHJF7BMWdfGlebWpX+K29TthBfpOR0?=
 =?us-ascii?Q?tijFsGWqecCB17QcRjA5E/xBHAG6Z5gGosyj1dO5fKfLKaVUzQ9TQmcWoe3X?=
 =?us-ascii?Q?+/Ktoj559DzgYSMfl09qXi/6/1m0+8Ar/fXhQDMgKBVf/FvgMFrwN0V/BKxH?=
 =?us-ascii?Q?wCdEonFNIizDA6f4oZ2zlVcHFhnPYzmgsoDtu4fl4f/TuVTaQMJc2LMSEgh4?=
 =?us-ascii?Q?k4Eh8yFG+8Dqfa6f5Ien7oX8OZnLJqtIJC238sGGUQgF9JD9H8Na4pJAH9X6?=
 =?us-ascii?Q?pgPSpQzi8uvbbaMOsxdvNWQjP5oKbjTbRYwCbXm0eh8Vqqq5PFXCRoz5CRsx?=
 =?us-ascii?Q?WvLlQ9twa0MzTePUz6bBRUcpQndQ+g8TYkGgxoGushcIKJEazf+LqA7AdTcp?=
 =?us-ascii?Q?33NIWmvZIlvmEPWW1LOSvSdIJY8YqYAzXth4QWWaZqodg7G/9p7/dA9DvWNM?=
 =?us-ascii?Q?0/jQWvO2jenoX9K5dkrpm9Vke/Mfd3nqlmOu75P1uqBg9OogTZzNd22Njz4q?=
 =?us-ascii?Q?CkeB6qiGWt4CPAqUzbxpN3KkSWafvfB7qDkQgrIdMEStW70qJvIzX6VUBTQd?=
 =?us-ascii?Q?HYGN0BOwcc24D0B3yACYxzLGu9FhQd9ofSwM3LMQzjYKP1giVmEgeGv+sowY?=
 =?us-ascii?Q?T4nNB9couvBF6C+7I7IblOzFz3MlyYrdTvIrJCKxrQCqhtF0tF2I2Km+bcMU?=
 =?us-ascii?Q?J5ER1585oPePqbOr3KVisbonj3CSrZlCQ5yJQ2ZUySJac6kXez7U19QhjYJO?=
 =?us-ascii?Q?1ODoV83a7lUCLsjJ7xPodl//P26IT8lQGeCft2KuYsm1g44X7xgowp3eXvzq?=
 =?us-ascii?Q?4CeQZZr56rzXcWI0+We41XMPqo3NuGFrKYsl7Ub6C8/1lDRlZM/QaNvMhzut?=
 =?us-ascii?Q?aUJnsZzvNOhpDL59FX4T6J1BbH5SP83C/qmLYBvcmQZ0p0k/cvpSiG2HT3wA?=
 =?us-ascii?Q?0qiM9WuxaDSF5mbcRr/ENjLN9R9u+CdkUQ1KkKhVepgR95xxm3ulcG8fSUCh?=
 =?us-ascii?Q?ViTP9KaQUhy0vNaV5wfM+0HQusgWr8E6xfkq6McysV8jLZMBKCMXsYYRa0VY?=
 =?us-ascii?Q?0TFblQjMDzCee2vOD8vtkJuHZIFwm6LBjqwrr52K4Ew3YO07oq1z+E/I0lNz?=
 =?us-ascii?Q?fcm9tLmnu22KmBQE3wxZs2DFs/+AUZDcyNT1nD/4NapTip3qBZRXFBhpMt22?=
 =?us-ascii?Q?hJVEsDpIA23o4ZSUDGVUcYdHArrnQG0SWO+oRD6Ohm9Jgb3ERBzn3b5loRtA?=
 =?us-ascii?Q?yOFKkGAPlqqZx4qay3qIIYlwubVNrpBzzXCDskNN5vDbKafAqMf0GzYkReQY?=
 =?us-ascii?Q?HRvIIfQYKtHeQIycVViOHogkl90+uMB6pjMVhHoKRZ6qGuuKYbWvivnVmccj?=
 =?us-ascii?Q?FnhmXzqXIk/UTnpc0XOnN/Dhq8CW0/gbpoRkmIqdACLZuMmjY4pEWe+HgBZf?=
 =?us-ascii?Q?s1gMARjU5THtvkOyI+IIg8zChZ7HIuSB2DK5oho7UgJs?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f74a72-911f-414c-a920-08dabbaf4039
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 02:17:39.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyOCrVmDwioPaMQc04WIdXDBVKCkzn70D/fmHL9eS8LFxgLhg61fbVEPmpUDr/nE0ylhEGBDqirXItWLFuwNHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vsock_connectible_has_data() may miss a wakeup operation
between vsock_connectible_has_data() == 0 and the prepare_to_wait().

Fix the race by adding the process to the wait queue before checking
vsock_connectible_has_data().

Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---

Changes in v2 (Thanks Stefano!):
  Fixed a typo in the commit message.
  Removed the unnecessary finish_wait() at the end of the loop.

 net/vmw_vsock/af_vsock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d258fd43092e..884eca7f6743 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1905,8 +1905,11 @@ static int vsock_connectible_wait_data(struct sock *sk,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
+	while (1) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
+		data = vsock_connectible_has_data(vsk);
+		if (data != 0)
+			break;
 
 		if (sk->sk_err != 0 ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
-- 
2.25.1

