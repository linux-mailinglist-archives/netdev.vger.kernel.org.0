Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718C7669ECF
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjAMQ4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAMQ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:56:40 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B219FCD9;
        Fri, 13 Jan 2023 08:56:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoelQtQqDXIdLYNtyWavO3kP7m3B2DDH/q/Oh3weHSffQBR/aP6vr5lFYG9KAn6OXhCiVBJ/ekoL1lZ7dkQgdZ5E6LGOdFp9ipGnp5gEUXZ8PABTMXH9jhj0LxZQn0us2zPUucQpf6QBmQI8oz1SgfCHkBTrDJ1S64253Ey1hreyuCygdhXTRMe0xlO2SFEjWQTlSxGHAYO5bfFvQE6ufWI78+QVnqzyPXxcGfNPY/IY6UAMkSFUC5cDYlKqJPKMntl2IVUxzXx0q5e8HSNfibktgg6G3sua3GoNgj/BKSgs42pabV3qFaA0ANthVfTF4q8xU28+EbYmQJM86VwjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vx1cDsV2qmtqrjq6tD3R/oOa4kvVIxnEwk2dgdag8qM=;
 b=mj3E1UYS0j0CIe2IYWflR0rr5JZd1d0/xufntfISfMfRM6+Q/tWvLlf37sSPN0Nn2jJ7uVQfedEU3Spvvw2LA82sJFzm8gk9IPS6Ii49TYYyHkAfOrMAJrwPsNNzsOee6IEEkRHDyqliz9GFGVgJLmEZE2i80hXqamML9BWbooC1PXfziOWcbc2FQ2sDDlRSrwXZs3Z+ATpnpg88cK7gBL2WoNTs8LomaGX/fXBq05RtVc3dC15B+D6fZqWLITcLVV9gClPWFXJVQ/XHDh2qkj3FyGcdNLCC7UlH9UrosTU+CuZnngh7XT6LkwV0+7Du/BkLiM8nBRETi9zOz4DINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vx1cDsV2qmtqrjq6tD3R/oOa4kvVIxnEwk2dgdag8qM=;
 b=TOtpCLi1PdACo6uOoIo2ye5DETK5VUUEu/Vmic1gpkJlRLerPhJpE8rbbQ6fwjh36aisBS2xPxa9zHiDSi6YMvecG21/rJMfKBtHWptH7hvG2k+nORqMeo5n0gywlW3DpkxwCfAzoihrBPs8VxaqdfUKI+ELqkOFMS+40UFvSJpgNbel5aYEFrxnIi4a+lPbCp4HmucyAI/e/3mBW3H0VSCfi8K3L3GOe7bZaO3OUVZD9Vjn2vEbJIxuWsDH8w8sEsLdB/HeF5NKRp0YRfL95iDO9lh89juu8LnpDqwEAzplbNH8wkgnBc+/XL2RuLKpH6lRtG/ACD+1bO2uTFAiFQ==
Received: from DM6PR02CA0056.namprd02.prod.outlook.com (2603:10b6:5:177::33)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 16:56:37 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::c9) by DM6PR02CA0056.outlook.office365.com
 (2603:10b6:5:177::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:23 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:23 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:19 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Fri, 13 Jan 2023 17:55:41 +0100
Message-ID: <20230113165548.2692720-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT050:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: 0016c971-04e6-456c-8f0b-08daf587227b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVvGtoV0S8BKlncCnzrWPbQFI0dgwMfHSx83DEp4IULnl1hzciOzn0i0Xxt3YvlpSuGxisdsyBEARaZ3e9okrDCFXBKa589fPaxD4EePn+nDeOK0+Ck8nGAloecVGZlwJQs1npBfpJR5ZNGqhuCbsAZ4TSfn487zUUMqFSn89f5/S39yW5qsyKKNbWERfglODUvgN7lp06yUGW0tAewR42VWwgLavLkVFcOXY/Ap+cgQvr71XiSjakPf7TtxX32z+NZQXXGr/MYQctQI9VL6awSIdm/v1SwhhxlNRjDcugK0C+jvVnBJHw/1WXDdy8qZPUg/ccy6Z3kr0ANZWOWVAaed18scMq8JRHsiSb4tnmBld4K6W+6zKd0vL10E2pg2ekozDz4xjjGLDEtZep6PNz3sZgtRbtySGdCFdfPHk0PcY775T85cw6Bb6ssEJOfx3NAhC2I3zcUOr5GujbeV5p/gtVy+yIl++LZHp8sAgfFD+qqfj2YpKfjA6JDicida2HAAp9+vx2DhsBdHvR7BjXAacZTAHneMn1OK9gex0OnS/HpEgJsyoG/FRXHEYopaa1p0QjTwvquHU5n0Uns5UjwfCpRNWls2Ml5jRoHltzlWFcsqTpI/vuyBca7wGylZmgm0oTvSRgSyVRARv6X0NqovRqd1jwWCQBSJqvBfH230kgUIWcPmbahfHqK30jMz3Q1lDSvS6mpdBa/D/+vRK1/Of81LC2wGx1D0jzxpQrc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(36840700001)(40470700004)(46966006)(4326008)(8676002)(54906003)(316002)(7696005)(70586007)(110136005)(70206006)(356005)(8936002)(7416002)(40480700001)(5660300002)(40460700003)(426003)(41300700001)(7636003)(36860700001)(36756003)(186003)(86362001)(83380400001)(6666004)(107886003)(478600001)(336012)(47076005)(2616005)(26005)(82740400003)(2906002)(1076003)(82310400005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:37.2540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0016c971-04e6-456c-8f0b-08daf587227b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
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

- CT meta action metadata doesn't store ctinfo as "established" or
  "established replied" is assumed depending on the direction.
  Explicitly provide ctinfo as a new structure field and modify act_ct
  to set it according to current connection state.

- Fix flow_table offload fixup algorithm to calculate flow timeout
  according to current connection state instead of hardcoded
  "established" value.

- Add new flow_table flow flag that designates bidirectional connections
  instead of assuming it and hardcoding hardware offload of every flow
  in both directions.

- Add new flow_table flow flag that marks the flow for asynchronous
  update. Hardware offload state of such flows is updated by gc task by
  leveraging existing flow 'refresh' code.

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
  netfilter: flowtable: allow updating offloaded rules asynchronously
  net/sched: act_ct: set ctinfo in meta action depending on ct state
  net/sched: act_ct: offload UDP NEW connections
  netfilter: nf_conntrack: allow early drop of offloaded UDP conns

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++
 include/net/flow_offload.h                    |  2 +
 include/net/netfilter/nf_flow_table.h         |  4 +-
 net/netfilter/nf_conntrack_core.c             | 11 ++--
 net/netfilter/nf_flow_table_core.c            | 25 +++++++--
 net/netfilter/nf_flow_table_offload.c         | 17 ++++--
 net/sched/act_ct.c                            | 56 ++++++++++++++-----
 8 files changed, 104 insertions(+), 33 deletions(-)

-- 
2.38.1

