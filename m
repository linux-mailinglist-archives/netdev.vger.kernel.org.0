Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1D681697
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbjA3Qku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbjA3Qks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:40:48 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA0B3BD87
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:40:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UInGynQP+qQo277S2HguFCubg8ypZIorxs0t3YCRkIvYJHBUV4mhsCPy4MYxIfhYelAMFMkBYQF4G5Aey5ac1aZlYFo8bZgfmbsvIt3KDZ6xVRGYuZ9yRJ3k17r1qUwU7VzSXRXob/B81tK+it1GMznm75jPPMheRVqRECiPH78i8EPSVsWBLMTG+jDpz1kbt08DK9ciUV7UwiO9A0GRmX4uS8Z/N3KdPnnbRjOYbOL2ziWnqrLqr5VhKLinnZQLNd1Ikve+lxh2XnNwbLIBSGol0RAMVL9bd9ixG8fT+E1sB0Os41cv/5Q931GCkZPy8/AjxZfNGpoY7UdTJaLd0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEYcjGLeN2PAe3hx+13kv5hbVLYLpO/uGUiXjfsh9eE=;
 b=RMRRIibtHThvp5/jXxTMT9LGgim5Ck88VxIUpJ1QGD430Fx2G1lA0DXvBmhq2nMp1JfifpWJiZJMHT6rnELqs4Ekp54P8S531/KEQBiSV14zUv7RX76ur0kVT8YH38kgtKfetMv6DSks5H6SebgAlE/8ZGwkhyY0unKhJLQnvg1maHjLGZJQfiKuXRMrhVtckb21VJtzNe7iKt9/+cTKq9YsDGTaEIFQ6Ku8zw/4k1Ryxlyn/mNVF/N0UzmTuabONGKjuEEzSnOi5Yfc+tkYQ0uD6yEYvYdKh3oc5J+6cjhFoNfYjgF/ewtj0uMO1s/lM9r8tP13a80XivcNQomU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEYcjGLeN2PAe3hx+13kv5hbVLYLpO/uGUiXjfsh9eE=;
 b=f/y5mIpo+qaMLLPOygfK23e7oC/SslQWa2G+gfpn0wpb2aMuVXSXinoejesQN9HOYiYzT9cNcRuwo1MaS31n5nxHWsoltyJyFYifu6R+rj7hm7t4dj40qjtJ+l3Xyirxsu0q9QwvFvgtSgrKYHFGQYI45fzjfZ85ABZlTDT5ivB7+8HZ9J7CAIAWiJWH5MgCWsW6rUmVUF3wG5IWI8+o2KeYcs8RzH38wsBapDq8foImD/AMzUUr4X64LJYq0XG2Xqz4S/1AyF24oKVnWZEkVHtTEQ/UI3kqvLaibl7v98sZD2U/QWFyEpicyVag5OuugFJeazM2ZzLMahaWyX4J4Q==
Received: from MW4P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::26)
 by SJ1PR12MB6121.namprd12.prod.outlook.com (2603:10b6:a03:45c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Mon, 30 Jan
 2023 16:40:39 +0000
Received: from CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::25) by MW4P222CA0021.outlook.office365.com
 (2603:10b6:303:114::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 16:40:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT086.mail.protection.outlook.com (10.13.175.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Mon, 30 Jan 2023 16:40:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:24 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:22 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/4] selftests: mlxsw: Convert to iproute2 dcb
Date:   Mon, 30 Jan 2023 17:40:00 +0100
Message-ID: <cover.1675096231.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT086:EE_|SJ1PR12MB6121:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c1f035-11fb-4020-eb99-08db02e0b833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYRswZge1pksy7H2F5uoM3yqGBA5PeBpv1GadN46gao2SArxAL0OmFZgYcxpURQSr3XWb4/gXwWHn1RXW0vShD3yic6JaCOFM2TaNlTjrZNDGl+myPFnvbvvnQrJcdCdqqlGIckMV9OFH5YL5lUzJ8BnPxroNtRbCWSVPcLtKL0e5MQS8hRTFN7xAMjOAdVnxa7mHuydS5C5gW6nJnK3x+ShD7edG/xSE4i3Uui13s2TubW0mH2F6WAvFO6A4DGb6/cRSWuWtohoL8wdjinS7X3Ka5Nva6AaojSM0viRrNQv3Lh6sfGy5FNwz4aJTKVcsTlQsHYTA6vVDSz0IgVWCO2vEm4jFvBv1YOZiiL25UbwTavPWBOnBSfQDI3U0NKNHUaloGjK1JCCqszuaL7tDNZNK5nNGD5gfofUs4orCuciVWxDMOAKeYiZYTHeNQhMa8j81lz6wuS+qcvszLk0zfk/3sLuADCW0AWfvU/2gWqEIaB50jVcWz9oMHXR1d+oO80wKnqE/+Ry6tU4Hfxygjn5KrUsfVRq1AY6JHau1zKNAp0lnmUth8155Irq1n0i5L2rp8+DdDYiHpDfIH3liHZ56PQWDhEJGcIM8tmPia1IfHGtQt1CWLQu1CeToF5BZfkej9+5v9M+i3eJSgZxdIV50XB9Jee6/dHIg2ZGqCaeicvGQX8e6Y11f+NqM+5W
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(82310400005)(36756003)(2906002)(110136005)(54906003)(478600001)(107886003)(6666004)(41300700001)(5660300002)(40480700001)(70586007)(4326008)(70206006)(4744005)(316002)(8936002)(36860700001)(83380400001)(7636003)(16526019)(186003)(82740400003)(26005)(47076005)(40460700003)(66574015)(2616005)(336012)(426003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:40:38.7835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c1f035-11fb-4020-eb99-08db02e0b833
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6121
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a dedicated tool for configuration of DCB in iproute2. Use it
in the selftests instead of lldpad.

Patches #1-#3 convert three tests. Patch #4 drops the now-unnecessary
lldpad helpers.

Petr Machata (4):
  selftests: mlxsw: qos_dscp_bridge: Convert from lldptool to dcb
  selftests: mlxsw: qos_dscp_router: Convert from lldptool to dcb
  selftests: mlxsw: qos_defprio: Convert from lldptool to dcb
  selftests: net: forwarding: lib: Drop lldpad_app_wait_set(), _del()

 .../drivers/net/mlxsw/qos_defprio.sh          | 68 +++++--------------
 .../drivers/net/mlxsw/qos_dscp_bridge.sh      | 23 ++-----
 .../drivers/net/mlxsw/qos_dscp_router.sh      | 27 ++------
 tools/testing/selftests/net/forwarding/lib.sh | 21 ------
 4 files changed, 27 insertions(+), 112 deletions(-)

-- 
2.39.0

