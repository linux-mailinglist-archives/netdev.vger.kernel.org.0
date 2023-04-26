Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6398C6EF41C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbjDZMO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240815AbjDZMOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:14:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11hn2200.outbound.protection.outlook.com [52.100.171.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF01049D7
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:14:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anJzr3FwJVAOZ8di5w6b6aI+KST20Hx34tj5NLBaJZuUAIaCX3LjmgX+kneRPqu3YosYaPwRexMlJ4abhKgQggBmXZLwgdL8hcDoDIDhJdcNUwdyyTwm55cjfr/piKp4Rl0Lx3lBf8yO2DlOYDzI6ax6pijgngxFxRGuJOOvtjxEZIZrZi3oDV1mXEPxkiQtOTAF61aNeDewDrMBvfwyz4gycMEeki156JPzw4P4jL+dFh8HruUCgiB2G4Jd1Pr3jl6x65W4yeO/O6x+orC67kLhoYUEnlALGVvptZxHKQrq2Mrhe8dhg+LIIPEr9XmOdzTis/8ucS0Ovg9YBA+ywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzMxoxOZmlyCmKcmS6NVHQAWOp9Fb34kbKE4/Dbbzro=;
 b=V6kpF0NPXxOrcYX2g7Grs+/eUJQMeFez0gajfmwyDq5w9Qu20jDy4zNZNN364a5Quq+RoPQqPIOlzI4y4zTx71NW7iFBf4r/mcO0K1PZdv3NrcR01+N9ddmiaTj8pzGsT9k+rlKyRB5lO0dtBHLtVVce4uZ0YRD4SeaEFVTOY3SRLaefeHg0BjymARKabDUc5AJAkH3KFPpd1Jm9GLAQlKhJu7tf7Iz+wdBdMQXk+0IL+sbrqVFHEQBKsVzXrnDVnAU8bE+cle5jNdXvqXQAayxHAC59VL6V+IQBG1NYj6jJqFTmS9jAvHKwDff/CADN8neZ/gOKWMLvwR0PVgiMaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzMxoxOZmlyCmKcmS6NVHQAWOp9Fb34kbKE4/Dbbzro=;
 b=UllwOMWJ7D7btvNtBeBAAA6blXsBKdaExBwq5/LFg9+64r7FfOgVEIdYF4V7sHjrihh0IOQAOt5/lXIV/x4xOhIFaAAaD4fmWM6whQabr4JyDwF5hvR4ISqSbOXzaRgScz9I98KqvKhp1saRinWlPxjOzR244xw5w0AVefvjAFc3kMrh20KKyD0ySag3yIRPpPyflSzams5BzpMF4Gpmi1IekDlp0PSRC1YNgyeWryMU6nMVvmD/i26DgthWHbNdGWWxxER0ELfGWRTy1CR5WctylqyZpPuvjDfUsXUFhpPFUI49Pplcta/K6u1FAZC3wl21iE8hMGVf8EYOpu1wSA==
Received: from MW4PR02CA0008.namprd02.prod.outlook.com (2603:10b6:303:16d::27)
 by DS7PR12MB5838.namprd12.prod.outlook.com (2603:10b6:8:79::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 12:14:47 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::21) by MW4PR02CA0008.outlook.office365.com
 (2603:10b6:303:16d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 12:14:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 12:14:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 05:14:35 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 05:14:35 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 26 Apr
 2023 05:14:32 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Date:   Wed, 26 Apr 2023 14:14:15 +0200
Message-ID: <20230426121415.2149732-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230426121415.2149732-1-vladbu@nvidia.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|DS7PR12MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 465ecf9e-8876-470c-ff14-08db464fd3de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdPGdrIR3q/u1zE7vC0Eq75QMxb+xlxAINegtZYKAPY4XTa7kvpoCg1oieJf44z24WqAs1DosPtmZ2y1LLBFBV79YuF3wN+08YjIvaz1WtR06u5xDPOLXbO3M9OHygWax6wv9CevPj7je6+8KZv3FavSVNITvjPNrv8SOrWqFvXajyaK9Vx9stoLfjyUVbxcYBjEWpzye8MRz+Rbk5bv3LBtYwmqyfhvVKRIMPRvCDvjzGTMBckoiOdw01tBWJLYuDr//Gpm353o97yosg932YTeNoLddUXYT4ZSRVTX2ASXhCVxMtD42k2a9/h0tMmORZ68bLEkk4zY4JcWx7XxiSdzFaKAY7/LYPKeStfEpFfSmDmaOmo1Np8ZwSCVFVmAahdY7N8SnytQef8XgMF0zAyPsYZ6i9a5HvW/Mlqkq+mIopdiVOH6AQOzxmHJ2gxIjujIY6wBIXy7QWhEYH8Ir8cXhLfH0IGYjI0h4TXQKtHNCKruDBzmxFfzzJ+vhyNS3izZlT7FLqzhH1hVXG96qf5z36T+DNgCFAv5CUdclZx3C/l+Kfjjit2rC4UwovQgauzlkp36wFVOrgGTha23nyVvVVAb1Q1H5hful6K/VLJMrIGj3K4L3oNiAhgFL5i4PbO8uUwHse+F8pov6PMRwOSuuZYhyRVzOPaU38OlmgpEtwX4pZY8RHgeztIH9E6ZhJ8WqTgI4GXt5ttuZQrKtn6oC1X0OVGS4EEP/2w3DJ9xdFkyakSGeRxby5daumsQ62ToOQRDdF2e1oA+9Zl2yg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(346002)(396003)(5400799015)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(5660300002)(2906002)(8936002)(8676002)(36756003)(82310400005)(86362001)(7696005)(40480700001)(6666004)(107886003)(26005)(1076003)(54906003)(34020700004)(478600001)(36860700001)(2616005)(83380400001)(47076005)(336012)(426003)(186003)(70206006)(70586007)(356005)(316002)(82740400003)(41300700001)(7636003)(110136005)(4326008)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 12:14:47.2462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 465ecf9e-8876-470c-ff14-08db464fd3de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5838
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
new filter to idr is postponed until later in code since handle is already
provided by the user. However, the error handling code in fl_change()
always assumes that the new filter had been inserted into idr. If error
handler is reached when replacing existing filter it may remove it from idr
therefore making it unreachable for delete or dump afterwards. Fix the
issue by verifying that 'fold' argument wasn't provided by caller before
calling idr_remove().

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_flower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 1844545bef37..a1c4ee2e0be2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 errout_mask:
 	fl_mask_put(head, fnew->mask);
 errout_idr:
-	idr_remove(&head->handle_idr, fnew->handle);
+	if (!fold)
+		idr_remove(&head->handle_idr, fnew->handle);
 	__fl_put(fnew);
 errout_tb:
 	kfree(tb);
-- 
2.39.2

