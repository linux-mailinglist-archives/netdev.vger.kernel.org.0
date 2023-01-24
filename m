Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A06679B11
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjAXOEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbjAXOEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:04:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F6442F4;
        Tue, 24 Jan 2023 06:04:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeRg/9lvEj9wEl+m7I4H7MAr8MgxC+CKcVnEo5c4r3Xd0m4R/PVb0lZTg3iZzsHMflISrnb068b7IPIaWHbhrRnTgQ1Ijvdm8UTh6VdOmT+wPgdzzvpILXL4E7MT7xOtNR1NH4Awn/sxlEhzCZH/nB59SCrL1EMmzYyHqatgbehX5Vl9UUZ3zrp3LjvJ64QPL2NKc082dtFGhE/KdJwfjnwPj2Rva5KcB52cq78NmpRrrJFuFgCPIl2tE88dbVz9+ecHghX7O067ZNGVSXk+nHogwUBF3XU8QSOGrqCOluWAzm061NBlaeNsKwetsbl8SYu1wkaFOGv66JZPLUKmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rz+HTIgLF4cv3numWmCcln5WQzwNgbogiST4HyBCOC0=;
 b=VLlDHHDo5DRVkiR81lvAyh7flQs91FIqP65c2XJc7TGy1a0roqoTJWmItC4m08bS0jUwZ/6hbbxMLcpMUoGSP1lw7VnH20eKUETUwLy7Gm2tYA2MAMfprCIZqEzFoufvoHqWnWdMcWP0L1LwPWZjMDxi4KJCJ/HUrjd4/1+KkXPOB/wi2kyWFyCuaHFGUk16QQp6G+GR5IOryIeBFoCUovuLrZWdsGOelFzn7aPd/i4JR7dZlgXxJU8rx28xnKcDQQHwGrser6iTKEFTOn/UJ7HCeWRnbTy8CrHgg4mRTFVKKx4rktHyKaMzp+EAPbdyseHVP+fVh18I5tjmlvpLTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rz+HTIgLF4cv3numWmCcln5WQzwNgbogiST4HyBCOC0=;
 b=Y+/3KwU/NMX5yWIcx0RWFDBAd5enq3ALG6C5NbaEgiWFD1GAzs8KKpG6YhC7mLR5TLA13E+mtj5GDjyMyRKYszhyNzPkz8p6pr+rxi8XDu43iWPNOh9juVIExEfLgF42nDwV8A1j+fxzM0bvpgYvaX5MpQTUb0MgS3RbgLgai5cLzic5ytNqfdiy2Q5pTIEuJyd2KjxzPAhjuqM2zcGkXhAeLU2waKhcPldVM/tpZCy5XGbI6WpcyRUjIa4WY63PDz80TksO1H0Sc9nXfuf0L0KP+6OcxDHrWI39GwsouTtCIpdDc5SsgCt8wSLEPQQW0BqtVZe8zFJCrq1mh3Okuw==
Received: from BN6PR17CA0060.namprd17.prod.outlook.com (2603:10b6:405:75::49)
 by PH0PR12MB5498.namprd12.prod.outlook.com (2603:10b6:510:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:10 +0000
Received: from BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::3c) by BN6PR17CA0060.outlook.office365.com
 (2603:10b6:405:75::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT079.mail.protection.outlook.com (10.13.177.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:06 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:47 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:47 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:02:43 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Tue, 24 Jan 2023 15:02:00 +0100
Message-ID: <20230124140207.3975283-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT079:EE_|PH0PR12MB5498:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e4a29a7-a24f-4832-becf-08dafe13b7ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: thyUMkjToffMkN6JXvhtXvcUkFgBFz3h/eIn6eRI1Ca8effnSMF7V4JMHD57IqrBdEjXjl6WgFWC9kCOqbl5+WFbBiMdGsUwkVpIj54veV3Bpj8vhZ/dJzOBuV/cy5fAb+00O+MjQvY2eMB5BkHp+p3//mG8HBOdAlEPrP8GwRItbUNQ85QpL0NjLC/6PRFz4HSVVt2EfTsO0pVi3J/jHHC/L7Kq5pLNKa/SUKW9jCcle4GUIpeEAth1XN99OCs69ySE3B0/9Y2/vaMCixHkbca31CX4CcDLff+bPr5lEptmYgkPsaveaQ3YUmjZf3EePlgPxsYT4WTEK5QB6dQeyqtDYqVMT8sXqCj/iMpE6ZBZ4D2nqN0TQ9pJBWkcRnSVWNWKw/r+AcbSb+7m5qTQF1tqhiWdjWdpfJuzvfQlhGeXWCgQr06xx4Jo+yPrJW9GfLnhwZiFF4ZkzZkCp3+RgdntfvP4+pDZCzGqDxDDFNmkBV9PfGbRu9JfypS3Dagt41Ek45KLigxXT6dsZGNdS62MzEzOM2FEkTGNB9zMoPX5ewcvSU4xE53Jz2qPqYigBap9ay8pDa+bReEibqu4m9ELI6avbo2NlF1cPKFlx6+tSMx3q4NXTrQdWTN7KHSKs46ODr4iSx3svO/y0mfMveeV08konuI61ww0oHVvPVkM+oSSQCYpxNxiLDM02ClV
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(451199015)(46966006)(40470700004)(36840700001)(7636003)(40460700003)(36756003)(356005)(82310400005)(498600001)(86362001)(336012)(110136005)(8676002)(70206006)(70586007)(4326008)(2616005)(426003)(47076005)(7696005)(54906003)(2906002)(1076003)(36860700001)(83380400001)(6666004)(5660300002)(26005)(186003)(107886003)(7416002)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:06.8091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4a29a7-a24f-4832-becf-08dafe13b7ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5498
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only bidirectional established connections can be offloaded
via act_ct. Such approach allows to hardcode a lot of assumptions into
act_ct, flow_table and flow_offload intermediate layer codes. In order
to enabled offloading of unidirectional UDP NEW connections start with
incrementally changing the following assumptions:

- Drivers assume that only established connections are offloaded and
  don't support updating existing connections. Extract ctinfo from meta
  action cookie and refuse offloading of new connections in the drivers.

- Fix flow_table offload fixup algorithm to calculate flow timeout
  according to current connection state instead of hardcoded
  "established" value.

- Add new flow_table flow flag that designates bidirectional connections
  instead of assuming it and hardcoding hardware offload of every flow
  in both directions.

- Add new flow_table flow "ext_data" field and use it in act_ct to track
  the ctinfo of offloaded flows instead of assuming that it is always
  "established".

With all the necessary infrastructure in place modify act_ct to offload
UDP NEW as unidirectional connection. Pass reply direction traffic to CT
and promote connection to bidirectional when UDP connection state
changes to "assured". Rely on refresh mechanism to propagate connection
state change to supporting drivers.

Note that early drop algorithm that is designed to free up some space in
connection tracking table when it becomes full (by randomly deleting up
to 5% of non-established connections) currently ignores connections
marked as "offloaded". Now, with UDP NEW connections becoming
"offloaded" it could allow malicious user to perform DoS attack by
filling the table with non-droppable UDP NEW connections by sending just
one packet in single direction. To prevent such scenario change early
drop algorithm to also consider "offloaded" connections for deletion.

Vlad Buslov (7):
  net: flow_offload: provision conntrack info in ct_metadata
  netfilter: flowtable: fixup UDP timeout depending on ct state
  netfilter: flowtable: allow unidirectional rules
  netfilter: flowtable: save ctinfo in flow_offload
  net/sched: act_ct: set ctinfo in meta action depending on ct state
  net/sched: act_ct: offload UDP NEW connections
  netfilter: nf_conntrack: allow early drop of offloaded UDP conns

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |   4 +
 .../ethernet/netronome/nfp/flower/conntrack.c |  24 +++++
 include/net/netfilter/nf_flow_table.h         |  14 ++-
 net/netfilter/nf_conntrack_core.c             |  11 +-
 net/netfilter/nf_flow_table_core.c            |  40 ++++---
 net/netfilter/nf_flow_table_inet.c            |   2 +-
 net/netfilter/nf_flow_table_ip.c              |  17 +--
 net/netfilter/nf_flow_table_offload.c         |  18 ++--
 net/sched/act_ct.c                            | 100 ++++++++++++++----
 9 files changed, 175 insertions(+), 55 deletions(-)

-- 
2.38.1

