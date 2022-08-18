Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40859841C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbiHRNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242702AbiHRNYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:24:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FBA356D9
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhNjjyK9YyUPCp6mrRHLIwQF7r/jDv4LI4gQSPTIfiJ4XpvOY3PxPpba/7mHFYt6/8xWVoLjhkkRP7VJa/M3mfRRHMCbT9RhKxN1VfpL4XWX8GRQ0GjjwHPz6MoR9pq1yS7ZnjOCBblj9c7I8+ytHhWu2FZqk5c5S7uRjT0+KWCIKuKVDxQt9OHiRVgQVYXyNrXBRxXAB/YINF+pbgvV0tK1AMNPrfLAXxCv92VJULh5xOUDZmHSS/UcK6PAXOyl2YaSYXFOu91NjTtUgmWMEEd1zJ21HfzF03mNc1+dar1yGsTq7Jx2uJMavh4xOywNYc8MjmbWEy0mszWPWjaOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8t5FBaeIliBdEJ7RjKVPdrnFKRv2r0k4Dm3nvJdDsk=;
 b=JuZpH2Ne8Hm9bUuiE1+DpsXDc1brHYvIFk1XfkHjFnuwpquNHMIdpAFPRkxEOVFJ/mNzZlHYENkY5XREsGkY3jrTfUWxMhMqWQjaJI3KELCg4nZUhE015GB+sfmp2H3RutJYys3o1GeE1gH+MMac+apK5hnWH6WJbSg1H3rBbbFXfN8Ysao2SlCjjs9Bg8nItp2WnfEX2LVUxOJXdYlxAPV8dSPQYOhmeFZ50hUnfVYx3qspDgA6TRnzVkU5IDEHqgIJHX2xsLYHysqL65MMngQzR4Lv2DSBszcdny3OX97Doi/fdYNS/XyZhnYAT7/yva7rinNuhyHiiVuv6PK+3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8t5FBaeIliBdEJ7RjKVPdrnFKRv2r0k4Dm3nvJdDsk=;
 b=KMbdcPODXR6+sFJmfOn0Y9A84KQ5SzaijH9ovkvbo3C0ocEfhOSJBUbp91sL8MXklswk+XSJWuU8vxfki6ELDMd5DRndphbHagGmxmwBqWDhA7Xx81wBNVkQJSuZgV7NM3AmEu+XrH0NhMd6C7fkmWKLIxsnPcdjKqusnYpH/SdE6ql0eQ1exUJF7BvoAaoDOMW6h314Hm19VwpN+HmoGj6+VR4E0YBIS1GOZQsXSgP/oJ8IZnIhcabcKFQuZfemKlLMp+7FKuUKTGobJMO2g8oY1x7R8a9wCe2NyWggfT3u7m9LhVjXVjMDXsX1NQP/0Xa9MAEZGyYJnFZ9JCVWdg==
Received: from DS7PR06CA0029.namprd06.prod.outlook.com (2603:10b6:8:54::29) by
 CH2PR12MB4807.namprd12.prod.outlook.com (2603:10b6:610:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.10; Thu, 18 Aug 2022 13:24:20 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::11) by DS7PR06CA0029.outlook.office365.com
 (2603:10b6:8:54::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.18 via Frontend
 Transport; Thu, 18 Aug 2022 13:24:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Thu, 18 Aug 2022 13:24:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 18 Aug
 2022 13:24:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 18 Aug
 2022 06:24:19 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 18 Aug 2022 06:24:17 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net-next 00/3] Introduce MACsec skb_metadata_dst
Date:   Thu, 18 Aug 2022 16:24:08 +0300
Message-ID: <20220818132411.578-1-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 053bae31-1341-4e69-9b5d-08da811cf591
X-MS-TrafficTypeDiagnostic: CH2PR12MB4807:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8DTbKl80sN8NOIzPmCkfoaiklqkh1ThNRYTbazIjCQ3x+5j/Zw9oa5csgwU4kvyceZDCqAqt/HLswDPdpFrhCb/4kZcBPhR3ywg0Rw6tFwayQARSNA0boLOT2AE06C/H8baEDL1AS36FwsOoUtNhlxVY02XstwC232m8GptBJTZapqLlw2KdkbrPOa2c9fywgNOI5eBpGoFvPg2j+kPV8NCqS++Ipu9NGhm0X69NNV2cjDMvPzMReawc1w+ihTvYrZBLK29XSysn+Xn9akG1D1fQMXXPhhnc3NGzr2o5if2Zo3CU82xVU6ARKBsCOt6VxUo8uOa8pul3g8kkV6+Xwpp3R9b2YCN/zY2i0dDB+SbofspuVdFoAE6Cy01Zw1FuirUQJnHNmusrrMMu/OoMxfqtB+fwSbiEEwFnKGAsZ0BoD+49UbrniLiAQcTCzA2kYcG3cTId9FyK/wO/vAeLzXlNTdCju6eNyEhJKEdeNq5BGr1MM8bvgKVVH0tSWEeEA3BWGm0LUEpx/f1tw3Oh3apfBR0bn94W6YKSlguZ5f2rnx68nbkZ4sCurbF1KSwmu3fz7wWDW0t6Z4Q5FyYGWRBQCuG7WiSaj5BJG6Bjrp39bl/aoLp58oyTiHYIplvthpCbLsa4Zfy2HBIrAoE5OvydhIrIJbaG+R8kRDZHxSHkWKxa8IpNyE+zD5AcoAk828fweVjKTVq5qeLy3L74CF/bWX5/bNvU0IOx6AvqJ/5V7WhDorv6QLjXaySpgv4ZtPhmzdzqyv2NgW/jR8eGF4dEFp2mZcXoJQ+h+JDE2u1bBAQQsWhLOe/7gbPAYiRt
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(40470700004)(36840700001)(46966006)(110136005)(40460700003)(5660300002)(2906002)(8936002)(40480700001)(86362001)(1076003)(82310400005)(81166007)(356005)(26005)(41300700001)(186003)(426003)(36860700001)(6666004)(336012)(2616005)(478600001)(83380400001)(316002)(82740400003)(107886003)(8676002)(4326008)(47076005)(70206006)(54906003)(70586007)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:24:20.4124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 053bae31-1341-4e69-9b5d-08da811cf591
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4807
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces MACsec skb_metadata_dst to lay the ground
for MACsec HW offload.

MACsec is an IEEE standard (IEEE 802.1AE) for MAC security.
It defines a way to establish a protocol independent connection
between two hosts with data confidentiality, authenticity and/or
integrity, using GCM-AES. MACsec operates on the Ethernet layer and
as such is a layer 2 protocol, which means it’s designed to secure
traffic within a layer 2 network, including DHCP or ARP requests.

Linux has a software implementation of the MACsec standard and
HW offloading support.
The offloading is re-using the logic, netlink API and data
structures of the existing MACsec software implementation.

For Tx:
In the current MACsec offload implementation, MACsec interfaces shares
the same MAC address by default.
Therefore, HW can't distinguish from which MACsec interface the traffic
originated from.

MACsec stack will use skb_metadata_dst to store the SCI value, which is
unique per MACsec interface, skb_metadat_dst will be used later by the
offloading device driver to associate the SKB with the corresponding
offloaded interface (SCI) to facilitate HW MACsec offload.

For Rx:
Like in the Tx changes, if there are more than one MACsec device with
the same MAC address as in the packet's destination MAC, the packet will
be forward only to one of the devices and not neccessarly to the desired one.

Offloading device driver sets the MACsec skb_metadata_dst sci
field with the appropriaate Rx SCI for each SKB so the MACsec rx handler
will know to which port to divert those skbs, instead of wrongly solely
relaying on dst MAC address comparison.

1) patch 0001-0002, Add support to skb_metadata_dst in MACsec code:
net/macsec: Add MACsec skb_metadata_dst Tx Data path support 
net/macsec: Add MACsec skb_metadata_dst Rx Data path support

2) patch 0003, Move some MACsec driver code for sharing with various
drivers that implements offload:
net/macsec: Move some code for sharing with various drivers that
implements offload

Follow-up patchset for Nvidia MACsec HW offload will be submitted
later on.

 drivers/net/macsec.c       | 54 +++++++++++++++++++-------------------
 include/net/dst_metadata.h | 10 +++++++
 include/net/macsec.h       | 24 +++++++++++++++++
 3 files changed, 61 insertions(+), 27 deletions(-)

-- 
2.21.3

