Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C908F6EF419
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbjDZMOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjDZMOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:14:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10hn2204.outbound.protection.outlook.com [52.100.156.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1A82121
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 05:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQsYXhNmraXWVqJRzhwiunn2r48HNxYOqHxDO4OhM5fc06TziczxjmXE3w+mN5lVd87lwdf6gzJEj0DU5C8/uqlUkbU9PFyYFEmElxKm2g6l6YikBKXgn/jvDTxZR/bhIcLZFP+ALyy+n4pE451Gqilqy5ToB9OfeKrhoLSM4cMy9SVmrb9Xu6ZRpySJu7K4LPwa3ZEzAWiRE5L+NmBNGCCh9wQ34WDDLC7L2n/d522Ub6QXNXyu9QYNhfXKFG7AYQx7+qyjdLQBCUBayirHM/gNPgNQWCWZFJZNczz4WpNXBMgsSitkRh1MM38y3sF8qaKvBOYGDrNyZ6k7MRejVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bitLQkMfAzTdtdmZFlkUrzxoGOFLpcAyaOUUHZDWrE=;
 b=jOz4y966hHFGIlr4AdTB1J3Nx2Vo2RQZ4tu79q70CfdwmNoXuOwoGogfGxzQIndubH4WazcgKqLt4NJZAtcRzIZhF5ix0EbOwUYgEry00EYk+GLZCSiWsqRrEJXoqSmxKhZ7260uoSEE943UcMjEykCOKq8D5rmkFZkkeoxWp26oep5wzpC/+AQ/iPxy3CLpz/R2NBC1sSOwXVNjHCPd2+fgt2dT9fu1Gx/CWLVcU1wkcX/b7k0LA7ncLmtw/hzFyJFKmf8uHOFq1o+YKYJ0AALgYbSl38srsQO7UwR7RqNdNn5SH7OcuZVJPo1W2AvdK8mF8Hclpg7tprIM5g+nVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bitLQkMfAzTdtdmZFlkUrzxoGOFLpcAyaOUUHZDWrE=;
 b=QqldeNVyOId7yeIXBdcVPeiKjWuqupF75DuwhC7IDzQ5qzX26mD95B/HdMxOTMzox2MLhxQJN7zCYk7TiPnD3QvM/tZ1ap5Cnrz/muj8fLUvUoSeIn0BUong7VIBfEojbqNROhlw+T3Vi56NTEzcHngydqeRh5iZBHjK2KpZ/iFoFp12Usrbx/cDClgg5FULHNd9S1dKQiwkqbUsybb11PV4Eu72yhE/Y+a2mDobnCMRilZNA52Hi/JeRZO/1EA/F2bNJHCaGu7X+ScC2nXlsdI9q8Mq1BtO9ETbYG6s1Si1JmuOoI3f221Z9KNXIyAC2bjMGIS6A/W5r2ThPXUGKg==
Received: from BN8PR07CA0002.namprd07.prod.outlook.com (2603:10b6:408:ac::15)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 12:14:40 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::5c) by BN8PR07CA0002.outlook.office365.com
 (2603:10b6:408:ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 12:14:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 12:14:39 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 05:14:28 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 05:14:28 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 26 Apr
 2023 05:14:25 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 0/2] Fixes for miss to tc action series
Date:   Wed, 26 Apr 2023 14:14:13 +0200
Message-ID: <20230426121415.2149732-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: fd26df08-d148-4020-f6f2-08db464fcf5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oqhYcmtznZZ5icPHeaveWZJeaMlyzSjRtBU0oAVC4cCwiUzhoOJlqOebNiSf+kiCfof6el2F5d+IZXIJdiu8SA/mW0P8C8gpE603lJ/G1i83qzWh1QjlxJqYaSYjJjV1aOvQMVx9esjMymIqu4mTMoZGFib79aWquS8w2S4tOaXsLssIL59M3srxZW1OVLps1wwV0ZWR50Xer/883H8Ol2BaYuICJTSgLwbf+AlSVeX+WfZmb7YY7tqB9e6QHl6c0MUgorYpo+PHKLzO0Hck+FenwWGO0MT6/8ZrmAhcK0Uz40O5BSNLfToNAciuDJad+iJVPEp9EhSGmJ9U7EDzvdLyXb+ANJYv6/TNOOywiGFnt/qrOZP+S26Oz1FNX84gsESnpgb4fLcBuyS6bkTLjEVTVY+pIYYMXkFaGkfMtkToxPNsClc9Od6CxZhyYa4ddj3qW33qBr3a1KjJN24bYQfNudsjeu2medT+yqdJEOKYR3DOKq3y8Awn/8Pa3QQwHHwgGXSj9YeFLJo+bzXWOCu5oQtxkeKpL34P81gj/xUUQZuhwaJphyWTzPjGIB3S/cflBOhVlR8yf8Fgsx/Mc7zVUiU7shMps4GNm9rSWbpAS2rDzvdWwi7NS1tYIejMHnT0bLwj6oUsMsY4AlAkH9Gkzv9IkkCihZ4jdfXHIZL//ApJwYzjW4dKIZpszgSE7SdKmr0I3leiQT9zyBVlfjbm9W0gYTVPVCQkVrxQ2nT9S+b+nQ4muBjOHtUAyLG00vPvpr0EWF8vg8SI/zJYQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(5400799015)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(110136005)(36756003)(54906003)(34020700004)(558084003)(82310400005)(478600001)(86362001)(8676002)(8936002)(7636003)(2906002)(41300700001)(4326008)(40480700001)(82740400003)(356005)(70586007)(70206006)(316002)(107886003)(5660300002)(1076003)(186003)(26005)(426003)(83380400001)(47076005)(336012)(2616005)(36860700001)(7696005)(6666004)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 12:14:39.6650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd26df08-d148-4020-f6f2-08db464fcf5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad Buslov (2):
  net/sched: flower: fix filter idr initialization
  net/sched: flower: fix error handler on replace

 net/sched/cls_flower.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.39.2

