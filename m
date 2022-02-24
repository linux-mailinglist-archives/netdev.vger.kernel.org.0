Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA66E4C296C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiBXK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiBXK3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:29:51 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2073.outbound.protection.outlook.com [40.107.95.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E7B1E2FCB;
        Thu, 24 Feb 2022 02:29:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwJXgaIAr6z9Zx6NacEB3sYQQ1ZYFSnNIvAw/8kfkLWu4ZJqbbousqvnhktA2UIsOop4tWQz9FKuQpY8iwvQwQRwbySa3M2GKtX0c4RwuaMQwc7/N9DQVH6E1wLjdUZ9iW5qscxti/AawvveVgi/IRM/yzOBHKJH/5yfn5gRa5qXEfFLr29/3AiDA+qIzOvQ6/ugSDV3Z3P9cXK2Rntm77VZWNdWCQlLklKxUDRT4aQTHNtqqPkvQFv/cT3mOgApbkoxgPi7XW6HldiBl3PbQNyRarWjcmIAHTL9gK+vGumaCWRj1ZLvnqGGltAujvMjIvSwvSFKA/7Efmj4cp8gng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAAk1gbzxTvggcjsepkxzzdEjPnwKpakuNwVnUTTQII=;
 b=ayPC0rgJqx5IFxlEaFvSXgJ0jDDI/HqSZjdT6gP+Vj7f2baeA9U5iTAPwnGIxpiXRZ8AmF6keOgIPkVGn4Ul7G6euunaGUac2u98lUjAg7N7eEWX1uwFW28gagzkpfeJyiAOUW3EUVdUlcNT6Ey0jT9pOjzmtgpDCOXy5ra8C2raBuc8pGSk3YPpOXeXk8UN+zWhtOQHE7oA0yI4+ZDApLLW4MkFyodk0n5wljiJqaUilNrkf6XQ6Puc9IkcJppsKomFontAVn8XdWmIFg1OA44n4XUS4ThFFaN2pnBUfD9PJ/00OV8gXBLP5FbFdJYshvzmkhCs2iwSPLfnEFnhcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAAk1gbzxTvggcjsepkxzzdEjPnwKpakuNwVnUTTQII=;
 b=evkJQCBnwgRIpbq8UNINkq/yC2w3vM41s/a7IRM+AWlqxVA9bfPnohvVnoKJIUbTz+rOWnjLJW7ydjcfOcoyE8qmCYIHdaLG0I6YDekWtNcWJxavzDn0SE/HjoVgd8m9OzWP9n2w6AxlaeENsSYrvZAX9Sm0sSVlGcBN1wnxxCOVY1FsUxv0UGk77HjV+yjUc+TBEOST4G5Cx2iSY+OQK5pI+Lcarhn3t1I3q49KLMaN8ybzTDhYGs6As/me77KgvEkW23Sbtzo19Q7wOdtvJ7hOXO0BywCorfONTDjhGxTSGudTPS3xKla5bsn69qAN8juI+z9p/mH/j/imw6el4Q==
Received: from MWHPR1201CA0001.namprd12.prod.outlook.com
 (2603:10b6:301:4a::11) by SA0PR12MB4573.namprd12.prod.outlook.com
 (2603:10b6:806:9c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:29:20 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4a:cafe::4a) by MWHPR1201CA0001.outlook.office365.com
 (2603:10b6:301:4a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 10:29:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 10:29:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 10:29:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 02:29:18 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 02:29:11 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <simon.horman@corigine.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>,
        <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next v3 0/2] flow_offload: add tc police parameters
Date:   Thu, 24 Feb 2022 10:29:06 +0000
Message-ID: <20220224102908.5255-1-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a8aa9d6-0c3c-4d83-b692-08d9f7808474
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB457335479411DF4E38473FB2C53D9@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StMqTprTjr1d5fk8ogFAeQAkqYqsrtK2IMJdKY5c1aCJviSG/PtOGNO7F2qqg1XkRvSZKnQp6QQiLSUtBhJu6kwJnHDyMdQRZhL9xe5fcu2TQCFM027MvTTT3TqroC185GIPcns60FmGLFHcEkFpOVOSTPapbK/JG2mwYjWILfTT6yYu7Os48/lO+W+/1S9AchfIi8o4MglLIzqrJKUBhNezqHNTeSqW/yz5RVsZ/IXtWn7UEI3017Dz80HrP1cCdScGZk5dyjJtkx6PWqUESZ40jyrWbv1NE4c3KJwvc1lliRLN9GIWvqkS2hOPDwMNarI3DLGJqe+Wfv67w1BRdQ1WzUtCy6+Coj1YTmqf7JgX5zJHoCnXn3EcAI6p958xfb+6blt4pT8NPoof9mFwTeRQN8KPP3G4EQ/CQJPlfC4LLsSsYiQcr+ycB8dlyvcHy9rJiRClfFr/iKDL/DnPcpzcthqJ6rtV7ZiCql6/eBwqGa/jaw7MTWPCJiKOLt1VD12Xa9QAbnVK4YHueWidXIvvMEO/tZ0MJPxExd/wEXgV4pJgLF++4Cv3zDTFopHiKmD0FChfVm6RwGfLx6AKowwdYUA5k8l91WOV3iqaDkOekmM+IJUU6h9GmmqViC/DjfF7KDpI1Xw3jdi0/Tkj8Anl8GJ+VTIR//f9N7nuWOLqjLjtWtnKW51zInujKFDhItpIElYJmwVMEfPqdvaIRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70206006)(40460700003)(107886003)(7696005)(8676002)(81166007)(70586007)(4326008)(110136005)(356005)(316002)(82310400004)(186003)(26005)(426003)(336012)(1076003)(6666004)(2616005)(54906003)(47076005)(36756003)(86362001)(8936002)(7416002)(5660300002)(508600001)(36860700001)(2906002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:29:19.8658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8aa9d6-0c3c-4d83-b692-08d9f7808474
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for more advanced police offload in mlx5 (e.g.,
jumping to another chain when bandwidth is not exceeded), extend the
flow offload API with more tc-police parameters. Adjust existing
drivers to reject unsupported configurations.

Changes since v2:
  * Rename index to extval in exceed and notexceed acts.
  * Add policer validate functions for all drivers.

Changes since v1:
  * Add one more strict validation for the control of drop/ok.

Jianbo Liu (2):
  net: flow_offload: add tc police action parameters
  flow_offload: reject offload for all drivers with invalid police
    parameters

 drivers/net/dsa/sja1105/sja1105_flower.c      | 47 +++++++++++++--
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 59 +++++++++++++++----
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 47 +++++++++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 43 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 48 +++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 47 +++++++++++++--
 drivers/net/ethernet/mscc/ocelot_flower.c     | 14 +++--
 drivers/net/ethernet/mscc/ocelot_net.c        | 10 ++--
 drivers/net/ethernet/mscc/ocelot_police.c     | 41 +++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.h     |  5 ++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 40 +++++++++++++
 include/net/flow_offload.h                    | 15 +++++
 include/net/tc_act/tc_police.h                | 30 ++++++++++
 net/sched/act_police.c                        | 46 +++++++++++++++
 14 files changed, 454 insertions(+), 38 deletions(-)

-- 
2.26.2

