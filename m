Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119C069A46C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjBQDkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjBQDkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:02 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695D9474EF;
        Thu, 16 Feb 2023 19:40:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AO0oe+GqQGw38CnvNo+CWHsE/ppE3vnyZ++sPY56CgBgHrmf8fztAG3FFk2flErsMJ//CGehedoYcYwR6d65pZAsHlIFOtszOA1ptRnursOFgs59h//dHQqLISyPPb011joTCxgjkBPa4kSwlelHGYhWu9cl4CfeoQstyuASHbIKWFcVcabCb5+b132g0O99Dr80eVkruBs/0sjzBsT2UWtp+q+y3MbkRQ4O+nOofk3y98ZkITXZbDZ9TakDeUQRkjfkC5tj98c1WA/NcMKD2ERp5AjcH0ZiCs2fAagisRzZhnQpno30NH7cBiSzFjVHFAWZQleAR0JnKvzWvhtF+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BfGxj9j9RgqihMUgbghvqQ+2mJNsr3OsUn3w80nIUQ=;
 b=SRwirgeM4ivm6gE5anf/Kn9Bpxdk+r1a38aRgF4XhC18v/Pah3m7/jLFMfSMuyCcNveX3uUsyyZxtmn1D+cpAJBXLfBraomwR6TLLPRq1mcsmEQTkfZVhr7hC16g4iPoWKjIMDUlby+Ko7mSA5jWzKZfo+oF6bkEp/jwK7/Wfsm5FTajFGEhRATmJlkU9cMV3vgtXVwNV5C29xtCFhsftWWuywGtB2qIeG2Uf4nI32a03iPvGYVqqNJbX+faR7duah35KtAU4NqWhzRYWEBJNp7Hv/ZVTH0lNXQwCf+vT7TvilWkG5pgbJEGiVoD6p8TrgVZoyAfBDfCwulKe9LDoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BfGxj9j9RgqihMUgbghvqQ+2mJNsr3OsUn3w80nIUQ=;
 b=heh8dFh531m8TevxWilC9yTdbKY9q9BceAns+BAaTmTpNQjVqNXERtOUKmTkt5CgH7xVQFtzgle21qTq4vCzWF74P3JuqoZ3JN53hWYHhgBiyNuRj1kKcSLNSIvqBpsH+WZWRT5+GvRuArJoLv5BLNkSOXbMRS9Z5Ocg8zpp6aDya9UThHE+fFgLvN/ZeKJ/r/o4mN9hn/2uGrY3tPUkTuKwUpm2N9Mb67f3qklkQQnD/CvHZE2VTlJynaIKzIkP4mUK/uLQplvrQxc2JDjPlVn9fntU86d9roV3cCAUzI0jeN7ILyO9xueV2SOijNDVu6c65rrQ79n8RWqekW6wqw==
Received: from BN8PR07CA0035.namprd07.prod.outlook.com (2603:10b6:408:ac::48)
 by SN7PR12MB8003.namprd12.prod.outlook.com (2603:10b6:806:32a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 03:39:59 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::2a) by BN8PR07CA0035.outlook.office365.com
 (2603:10b6:408:ac::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 03:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.15 via Frontend Transport; Fri, 17 Feb 2023 03:39:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:44 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:41 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 0/5] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Fri, 17 Feb 2023 05:39:20 +0200
Message-ID: <20230217033925.160195-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT043:EE_|SN7PR12MB8003:EE_
X-MS-Office365-Filtering-Correlation-Id: e979958d-8ecc-4efb-ad1a-08db1098a4f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eokPgWPS8/qQSoDpTwC00e5/SgpQEsQn5TiLOIxsw2qK3jm4UdF0Ld5ADlcmOxhyIKpsU2PF2RQ40xDtR5z0reyIEXycn3PJR7s+ulkeHRTWdyz9G6iBgrnjMIiMMw1/EEpcL9inNrJSx7Fh1+gkVsklz9JK1/I+PRJkaZkGhqHXqJvRGUPlcI3R51oIAXigqzn3F9rn/7IVBYpLj5vAtF+ysYLvc5GMVxIuWiS06eDbvq66x7WDItP5ouE6ziggKhvM/psojBnxp4ADMguSRDV07MqQkd9wsLap9FO6654mPPGVmgy+337qeo+SXnRLi4q0Yeure7HPyJDMrLhGVBCJnCGCKcbNV8u3lIOx2AQMSAIHgDYz9zUWslM828H4CVi9ODlN1SRUy+Z1agM+9c5Fj/l4VeXvZBQCYR9LtduCqpKKVFfavEb2mDszAwMzK5/DmUFtvuuID6nrQKlykh53Vefqomi/I3t1W4LXKsb/NNmzNJwOpz4AVBzxlXEiMAXQeBU37YDpuVNPuQwMzVtheK00oyLxUAHE3bjh6Yg3MIRIMXm/KY1R4RZXt21pPcYf3ks1LD9JFhAwRo+/V98rtEGg5mZOd4VY8DSlE+9CBklrAJK8fRhkyLrqZ6DWJOrdt/JQWNnA/JlDZRb5+2wki+GLGu/luU6yePrD2Uv1TEm+PQMdhA3H2ClwMnbE6YiweIomIWVoL0YwB2mIg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199018)(46966006)(40470700004)(36840700001)(41300700001)(356005)(110136005)(316002)(8936002)(54906003)(82310400005)(5660300002)(82740400003)(70586007)(70206006)(4326008)(8676002)(7636003)(6286002)(186003)(16526019)(26005)(2906002)(36860700001)(478600001)(86362001)(7696005)(47076005)(36756003)(336012)(40460700003)(1076003)(426003)(6666004)(83380400001)(107886003)(55016003)(2616005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:39:58.9179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e979958d-8ecc-4efb-ad1a-08db1098a4f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8003
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds HW offloading support for TC flows with VxLAN GBP encap/decap.

Patch-1: Remove unused argument from functions.
Patch-2: Expose helper function vxlan_build_gbp_hdr.
Patch-3: Add helper function for encap_info_equal for tunnels with options.
Patch-4: constify input argument of ip_tunnel_info_opts.
Patch-5: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (5):
  vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
    vxlan_build_gpe_hdr( )
---
changelog:
v2->v3
- Addressed comments from Paolo Abeni
- Add new patch
---
  vxlan: Expose helper vxlan_build_gbp_hdr
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Use const to annotate read-only the pointer parameter
---
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Replace confusing pointer arithmetic with function call
- Use boolean operator NOT to check if the function return value is not zero
---
  ip_tunnel: constify input argument of ip_tunnel_info_opts( )
---
changelog:
v2->v3
- Addressed comments from Alexander Lobakin
- Add new patch
---
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
v2->v3
- Addressed comments from Alexander Lobakin
- Remove the WA by casting away
v1->v2
- Addressed comments from Alexander Lobakin
- Add a separate pair of braces around bitops
- Remove the WA by casting away
- Fit all log messages into one line
- Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
---

Gavin Li (5):
  vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
    vxlan_build_gpe_hdr( )
  vxlan: Expose helper vxlan_build_gbp_hdr
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
  ip_tunnel: constify input argument of ip_tunnel_info_opts( )
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 27 +------
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/ip_tunnels.h                      |  4 +-
 include/net/vxlan.h                           | 19 +++++
 9 files changed, 151 insertions(+), 53 deletions(-)

-- 
2.31.1

