Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8EB5FC1F1
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJLIZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiJLIY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:24:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5B615A38
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAOc5CqHeBxKqwiXWa0pgY2aqBYvJxHAkSlqFlFzRN5a8lZdBZo49YYYuVvfJPRYPWHcClzskmo50Bxql7qvmDtrBoLNLBs+VrzQqOjAHBBOzaH7+eQcGSQH5QZEx+6oQlI87zZzP/wBzkPP0gojRHJdzUxAOU85o8Lh/ED2BLAbHZkz4bGKzePFoBm1o9Z34VioiZqdL1UNb7IGp9EHn4fGVKh3sKctd2QJvzAvHT1spb1BsgAS2TQ65ezzQQ3oRZvV6F5k/1BKntDX2fNmt+0cBnB9Gh2HgIprgEM2bm1RCFCCdEIGPjc3qPus6n+CkFSjDPwapRbHWbjEcAk3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5SwIu3RQo6abx/t8ai0KAa0ZRjRG80eKIAahLgOsH4=;
 b=InTlMQacU+mm4519AjRKDF6+q9lOM3Mq02quW6EmpX6sZDSkvx+r+rEqhlDm4lJMKh/AFicB8WcK8KLJAHbb06/qQVbKY4OlVUq2NHqav1O0MULFMNkXeSv9sdQIkS3mcOl1U8Gkak6X038vCU/Oc/Lww9+aWGpGRayicmhposG3NfMrL4ygDWlOCygnhee2/AacPE+NwT+WynfaKs762B/8OTa0GdX/NNkvYbg/KS4r8qJ0TddA5ADmCYGPypIfiopV64oamOeUtD8rajwh6QbbkxKC6eEKAdgxdlVzhXb8C7JWK82U/OpbcW+rE7iLbCjoSoav0EMMBigXAFGepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5SwIu3RQo6abx/t8ai0KAa0ZRjRG80eKIAahLgOsH4=;
 b=IDvFjFv7hg9Jp9ABkJ83xncsNaAN9RrkoAarQf/rW9YQgFUErEIEVDHKAyfYL4wg/wCz67haj0Zy5nNtIJUT5LsgjzwGWPUzZTkB7v9ZQRJJ9RyU6EMeZyL8fk4hjN4TaEdCnbcWytMlt/kyubdUmFS7Hj0OGnFrymyKyT3xptdINCM0puuTSAodlDKSx3FKPR8cN+hiTmespytKQ1acD9z7by4oEwA9360XuU/+6TgKKqDfIh8lCwkUY83OpLlc2qo3sPqP+WrwFcjl0fI1h/6exh8VCU0OF1sW2ek1m1sfz03vhla7euNDVjPazxQ6HPIYh048ZbJXor9d/JKTKg==
Received: from MN2PR04CA0025.namprd04.prod.outlook.com (2603:10b6:208:d4::38)
 by MW4PR12MB6876.namprd12.prod.outlook.com (2603:10b6:303:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 08:24:35 +0000
Received: from BL02EPF0000C405.namprd05.prod.outlook.com
 (2603:10b6:208:d4:cafe::80) by MN2PR04CA0025.outlook.office365.com
 (2603:10b6:208:d4::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Wed, 12 Oct 2022 08:24:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0000C405.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Wed, 12 Oct 2022 08:24:34 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 12 Oct
 2022 01:24:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 12 Oct
 2022 01:24:20 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Wed, 12 Oct 2022 01:24:17 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v4 0/2] net: Fix return value of qdisc ingress handling on success
Date:   Wed, 12 Oct 2022 11:24:11 +0300
Message-ID: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C405:EE_|MW4PR12MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e325d5a-e432-4404-a32a-08daac2b3202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVdhZr0gqEvOwoE8lmMiD92cvcTAh0WooEtMoMVzVhquv+7RBhdoowz0MSpL/zbZ02AHdb9Vyvk0T5zEFPCZ0OosFEHOaeenG5XKLPYeILrbmb1V34h3Vn0MAEwz7e/XxKbeB66hrQfCDzY1Yhn3iqC/udJML4jtk9gTxw+6hEE0TJYgol9VrtfwEHXzGhmOOzuSvVFWtwxKytIEtl2nvmmFtLwubrU5izrxd5XsU+Ic6pJc+/06NQYdLqL8imcWINQzwLsse5jFup2TV1IFTCMtu8VWrO8uYxxllXH9TqRxDdVaAZygUoHJRLNIrkrBuliGlN5kOHZoUsx/avMH4W7/3Z96Vg536ftUN4nizWy+W/kkgv+Hk6kG7UHsL5ah/uHWlVhPXVjkP9dIM3zlecoGyX6cAhA2GkCNtglc1NPgSlxFw54XCnlq2uZogNHkWtRyJ+0Ysr7Taz3BffybOmkIonrrcVV0h4tOFz0jhm/7Vc41CJoLHmQd2xcKSWvPUAVNrzRrFGQJvEdvuU/8CL0P83XHrEFq7ICkWDidaPSKfGDuwdwnfuWjW0KPujEUY6SytCdDqSKXeb7rRc5Y7vqy2NQi3mJFjxt/p516hfPzUBD7QsE69H2dAqZCfghQ8nuumUh7SesOy2e+l8RKpLJbbPUQH8HlDMweT5ZnsHVLXbAZOhQXvylMnxJ2/g70vkUaZl8ShN5LTdD/jRTEXIkuRteylryN61SOqsS8O3ndtXXAQrVXy8IrpDHGqAx4ASRET/ZIO0LKWNODE3WONg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(82740400003)(36756003)(86362001)(7636003)(356005)(426003)(186003)(2906002)(5660300002)(83380400001)(47076005)(336012)(40480700001)(4744005)(36860700001)(2616005)(26005)(6666004)(4326008)(8676002)(70586007)(6636002)(40460700003)(70206006)(110136005)(41300700001)(316002)(82310400005)(8936002)(478600001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 08:24:34.6451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e325d5a-e432-4404-a32a-08daac2b3202
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C405.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix patch + self-test with the currently broken scenario.

v3->v4:
  Updated self-test to not use iperf, and use diff ips

v2->v3:
  Added DROP return to TC_ACT_SHOT case (Cong).

v1->v2:
  Changed blamed commit
  Added self-test

Paul Blakey (2):
  net: Fix return value of qdisc ingress handling on success
  selftests: add selftest for chaining of tc ingress handling to egress

 net/core/dev.c                                |  4 +
 tools/testing/selftests/net/Makefile          |  1 +
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 3 files changed, 86 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

-- 
2.30.1

