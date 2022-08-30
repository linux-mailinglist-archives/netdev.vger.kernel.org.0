Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6495A607E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiH3KPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiH3KP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:15:27 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E8FE97E5
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIC6psWwJ06xbi1WMPbuPhfXyeAn1bY7EQxk/DLmRcoMPDTHCnC/dNP7Pe5QekgGeXOsdJf46lDgS2Sb/dShScwTLYI0tPMktoj+aQzyDI/D8P+aHZBw+8tkAJqje1J0YymQqbjsZ+QVeaLPbLuKlkMcwkOuSH6P/o1pjc4w8nowbe5H6NDxzCb9HFXrh4+nmXp+vLy7UwY5pUn1lJnFnHNweaqnLFUQJTuqcVlYCc7VBfSy6N294ATejzrT88cl12qmTJRMXlj0QAVgGVerxnQPYO7JISUWxVPMrQpOjFA9LryhjD5L5rp+u2UB4FrX+HToi4YTpz41nyUAg8WRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ii3Iv+2jiicXWV8EBQ17ykNSYuNQ0t0HUUqAKVO6ZL0=;
 b=LXVwfK1FeHtD5YVwdMEAv3ed76C6Dm81lNW0wcgVG2PkdnOFTIMkqqWE8yAZaBLrqBeiHj3qwzYufen7+RGc4Jy/knRvact7yPvtf0jr2cwxgrSjHmudHUBAjSmtPKy1ErAI0H7HmtsexvVmaqy356eLtyVRMZIJWGVGNR31ybTgtuJLtBjLshDDG60AFccCLWG2Q6gWERZOuX1UXmmEk9wXUrobh5wGKhu5OslE2Eetr2SzH2X6hEIugM4Zzk3PU5A46Ve8mh2hQUYt9tzzNv4UwGa0RVYC3D0pj7m4A4PmXldzYCaeA0i9c5W1DDSZg/28CWtJGMRVwfZX0iZcCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii3Iv+2jiicXWV8EBQ17ykNSYuNQ0t0HUUqAKVO6ZL0=;
 b=jbfrOmQQ4e3MfJGMPLP6ow6+s9ZeuiacA/cE7pXaOzKYsZFT9DXl33aQi2iIQmB0rF04iFWtkoVFT4nM+NToYtiU7m7HrAAQQXv7bdpEpYQUxn+p09HDX8byHHgKInDtzWEhjbWq9tpTsO4Di3iDB4rWPFgRwbSHGnMI65ntuT7PlKfqOJ63qtrX2PO19D9dkOlrPVEV0v7nYlt6Zta5BDlr0r9OMQaC34iO7kVS/EDWB0FuWbPve+Q1Q23Ik1iW+onO0wgXYiykjN9w6PMTtjatwU7CVvulBBbW0Llt+Ap+BnKiIIg/Vmg/Pn+6lQagBhKTs1EcQWB1aAcBFcBcoA==
Received: from CY5PR22CA0106.namprd22.prod.outlook.com (2603:10b6:930:65::19)
 by MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 10:12:47 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:930:65:cafe::85) by CY5PR22CA0106.outlook.office365.com
 (2603:10b6:930:65::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Tue, 30 Aug 2022 10:12:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.7 via Frontend Transport; Tue, 30 Aug 2022 10:12:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 30 Aug
 2022 10:12:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 30 Aug
 2022 03:12:43 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Tue, 30 Aug
 2022 03:12:41 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next] net: ieee802154: Fix compilation error when CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Date:   Tue, 30 Aug 2022 13:12:37 +0300
Message-ID: <20220830101237.22782-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4443662a-8b5e-46d9-578a-08da8a703053
X-MS-TrafficTypeDiagnostic: MW3PR12MB4522:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpu110BJIh5rP5Yt14a++fnD/xI2FSLpYnZT9yRxysb1iXBM/wkWE8c1YkNOe0naxqfEb/rxNGOaEaqF63zylUUsyBY8cGe9D3ehE+dQPrPDyrg766Z6vhQ4yXCYbLyNYBA/zRjykCVxhFA3Yh4JKv9q3/p4RrSyD9bik1xTr2NM7hqM0APDwg/r/D3EpxHR3AwIL3p0uFqLP/RcASWR6jeoETif6FpospE8Km3f7NWxD4Z6NLbyJpMYZVsHHRKos76Wh08dFEL6loQAt3GFeDrGqXc8A9f+RwVt1R8mC/ozu5Vgf+wGNoSQWbpsOxe5syKQzfsw5jsX4Ck213L05wH+xZj/W4ZcmWL/Ae7eaT50iNJTNK7ffa5gCL0ifv9CpDuDT7XUm8+WJy0LCrnGgpsm8WJhB/xc1p3MaiZ5f3TnYnHQ8Ba3AoBLFWWm1+fviulqdWFm4CyVVODrmfYDM/mBnyuA/uaEXrUiYO2nrlR1BbLjk0watfhmgwQ96Z2sR69EAu51ZHFMtWD2zwxYvI9tK/XUtIxgpK+BM3nFMQD2vwagtCr83EXG0qdpiVoQOpi8jMKFibIeSAtfGLqgevaD8JEPxSWmrhzWbppsy7WZ5tcKasT+ckaqzuAg+bG+7rrYPFJarFEgl07vvyrNxY3XFeHLblgFFlC+5T9eUxnU8ujNc5nieqCbOxVZZCaimiVOjbp0ImxneMkM1xh2kQCE5sRw5HbEEBJGsh1K9nUdYOGjzoLVzxOH0sGx5oRg804sS9ULi3/9/GtX99u20/zc/oQYkCwPxBOTMrxNt1WfFO2j0hLIuXifncgHXPvl
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(136003)(46966006)(36840700001)(40470700004)(478600001)(107886003)(41300700001)(36860700001)(8676002)(70586007)(8936002)(4326008)(110136005)(70206006)(40480700001)(86362001)(40460700003)(5660300002)(2616005)(336012)(1076003)(186003)(6666004)(47076005)(2906002)(82310400005)(81166007)(356005)(54906003)(7696005)(26005)(82740400003)(316002)(36756003)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 10:12:47.6835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4443662a-8b5e-46d9-578a-08da8a703053
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
error:
net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
 2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                   NL802154_CMD_SET_CCA_ED_LEVEL

Use __NL802154_CMD_AFTER_LAST instead of
'NL802154_CMD_DEL_SEC_LEVEL + 1' to indicate the last command.

Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 38c4f3cb010e..dbfd24c70bd0 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2500,7 +2500,7 @@ static struct genl_family nl802154_fam __ro_after_init = {
 	.module = THIS_MODULE,
 	.ops = nl802154_ops,
 	.n_ops = ARRAY_SIZE(nl802154_ops),
-	.resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
+	.resv_start_op = __NL802154_CMD_AFTER_LAST,
 	.mcgrps = nl802154_mcgrps,
 	.n_mcgrps = ARRAY_SIZE(nl802154_mcgrps),
 };
-- 
2.25.1

