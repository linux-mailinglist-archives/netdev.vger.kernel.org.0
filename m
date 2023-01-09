Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED28066271B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbjAINcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbjAINcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:11 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A71EC66
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:31:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmN4mDf0HdAvDN9n9C9Bi8cGlr+6BuS4BFKNq5tgMLwSHNc5AT5XByNjalXFJ0QHuCjEfmuB/I+qh/Cb6Nk+jqembzZzrs5Lu7aLnTCbnnCLUL1Iewz11GIjK0Sh9/seh2v171G+5FnlV43W49gHWb+TBAGvpWPNpbhS846mk2Y9BzMxyaHMFroUQ2FopLBTLJhgS9hGbABumt+8Y6mZiAZ390y2G9IH5Id0gtnCTvVeg5semadQWEjd2OhsSBJYPJrp6cc2+sgpNGaJFVzZrDwU+VdoqFE5mB8YbCOB+8nzHrdmE0pEvLRs0D9pjogb+lvLakbSPf17IKWX1P6iKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcBdc1CIZcJQwKKpPz9wSoQvN9M1A3vvYwhoYzbVhMo=;
 b=f6Jcl/3BJxI5darO19EpK4TWpeOh8XZoeWEEgSxIc4Kb7wwLOeI2o7i0EBknUnO/WNdFBpQPbwJR4npQfMVN4mgPDKBUtJEjBGEzdpPtAUHg7nrVUC/ugjFwQpVN/iwzR0QNWK6ieEvjdqVLJ1TrrQqjLrC0/LrOXcztN9xJNGQDlweadF7kWVtNK8L+f3k8wZSxwaph9Io8HwtzdgympHHLWSSAFspUqmWvAONrzCBcKJ1lu4efUf2h8z4J8wgC9eXt0fAFzSY0o2teLxVVrhHvi1RzghMyZkSBD9hksY3LzHppSovGHelWkz/Gerq7kChIP34CyBYCbBeKkQmUwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcBdc1CIZcJQwKKpPz9wSoQvN9M1A3vvYwhoYzbVhMo=;
 b=Dz+6wDk+d17mievbpY1FD8XbkjJ09Y436hdWyXnY78coa/BzvFt0ViEhJ1Lo8pIlT3EG6iX9QClGQ0kaH0+BhA/DLVCDFI34onXHFnbxdrIW9/EDi72UasZ4LMsbvagiHtI40z0qeypXHwyZyrhqx7yd+hWdQeR/yaDS9mndUyE9m+kHn8/JFl7gKIVh/ci4mvmWqmT7kadnnmLFtyU/RgQtJWA5Z4voRXUVGOCFpzdvyPKaPLMmPOjjam1FVjg1YaSkYL4/5slNChJFPg3By63jJwQzgCHBnzSpJ4gNrA5UpDjq9LamDTRqgDKFjDTrCxeYNUkbIw5H2mP90IRIdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH0PR12MB5074.namprd12.prod.outlook.com (2603:10b6:610:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:31:54 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:31:54 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 04/25] Documentation: document netlink ULP_DDP_GET/SET messages
Date:   Mon,  9 Jan 2023 15:30:55 +0200
Message-Id: <20230109133116.20801-5-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0126.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH0PR12MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c27b7a-9f41-4e7d-b4e7-08daf245df6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4MN9OwHUteXVpIEATpat3Wo0OoXHMUm+jZhnH1xJpNhZc0dfegXpJSNOK5HkHJ0v9pqpmebXE3R3Ika/6FJiOo0b9KxEyg/3uk9AMi1oZQFpN2sM5siSfvjhn4ZhdDS16PdJsIoxkhJ6MU5KJN79uWnty6BiUoNpXE/edWvt6jRty3dehNgcxSk1LNYIZHCdRuQ5OSyFXfgEuNyxfXgkBRo5vYG6wloD/CmJfbZWtk3QMv9lU4/jNY0x0pk0dqqDZGgvrsrEbZ+kNZeLUd5ZcCd+3WHLShpCu/YoFcTqXM/kYuji5QCekHbBf4nZAt2EZcJpcZMVms/kdQsK8sNuspW4YOyUvFmiyLAFEUA3sDDQDXfai4FP7nJgXJM47RRo3hsFKE+qkhzYEtm9gSM+OPV/Eeyq2W287QtlJyhDSijAgETsiiJ9kETK0LKTkYdwMHqEXxoTQ8HmV06zLydhWgubNpETeMI3AFS0t1z2M4OLDuZrn6iE5MF8r2Ld3vHOboXGUI2CmfoG2VBWgq2wHJs1b/j0XcHeLzUsgcVLR3L5vTrYsI3SCcn/tMa8dGO+WtcSBCs18EKJ1hKrglZayAD3OiXm6nlPjoZ5XnSDyUKtTgSRETdJbHSTBY20TsC4OKWIM7jax/ZYo/dzt+grw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(1076003)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(15650500001)(2616005)(41300700001)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(36756003)(107886003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZCZgnBE+plEXW7RCZ0yEkxnTrIaNglCHsuAqsaisDHtYTXzWyFwdiUdDPKs0?=
 =?us-ascii?Q?wIkjdFUoAE/MDTz2DR0UbdhBiKemHWIGrLEL3iqlJvOzkRIYpW9G5uK6Tequ?=
 =?us-ascii?Q?BOdWn0qjwJWq06BzzT/DPt6p/lEgtHLFZmUSi91QFYaFZ2GcYiw82BZb41L7?=
 =?us-ascii?Q?zZK4LjEoAIunG7pprqSWUuwy17Moz96GIOQYYhedCyZP9p2nNXaRCGlI7ezr?=
 =?us-ascii?Q?RCSY/VnhdNhhWqTVyG1TnJN0Oc1XX7YqlBHOFjc+8xWeoFC7RPk9Ok6Ljsvv?=
 =?us-ascii?Q?BhahDZHg+gKwogf4xwQQjEBaF3UC/3yNZnXgRX7XaQjDJ/5qUC4I1Ka/8g8A?=
 =?us-ascii?Q?rCZKBFQNxqV3hSceF43o49jSbgcwTbUnrQYfjrtB/SBxO5lk2Lk2kPSlKZum?=
 =?us-ascii?Q?PQSbxlTu9yRRIph/jDbxGsP/eExhdLNMTJCGI0z6j8Dd3jDW/vwxJXTWkD8l?=
 =?us-ascii?Q?KE8WcfqxDn9Mu+X+B6UfYFLQjtg/SA2LFxtgqh+vTHEouqJqlCxiR+4Kdyiy?=
 =?us-ascii?Q?v/KYZ9/RUd3Y9KuEokJENBBk02mFpl3Wj52KLwfjIvmRFIJQ/UsHqO4krk6Q?=
 =?us-ascii?Q?z+XTm+7AywBT3K63AScYQ4FzSpW1Xeh+nX2JJPn674S0iennAG01nNwmKLdo?=
 =?us-ascii?Q?a3kX5CoDodcIBed4jHC9x8R6YUKQzbDrQZDnVANSFC1kS8fAqLOLrWQ07dWL?=
 =?us-ascii?Q?tW/NuFEXfu++6yct4+INqU+uizgVEKDyUPVtUu5HOOIqPST837lH4U6GtfqX?=
 =?us-ascii?Q?apMJGVkuGSe2hUcOJ4hADaOzVDTDKhDXf9WbQpkPvq6NHcG8vHmqUha+XHWj?=
 =?us-ascii?Q?Lqsq3zbY3Vd9ySVXml+Eeo33r+k2MwzJNB7TO2/iRQKbj1iFhLq4Hu+zFHCY?=
 =?us-ascii?Q?5t5IV3RxqsyXfisNgLii8rijUpZFSWfegnePkAjpn1oOwWYd5W8yf4zWOsPy?=
 =?us-ascii?Q?6vhHsKrcqGTgPZEhxYj9gD60mjPG1V6lEuxMBr45aMTMfxc7Izra1QlTAzQF?=
 =?us-ascii?Q?yuOzINbekZfUNdxZULQeqBXDn7+gCpb2IANuof9sxmKwqC1HQXwjodptKpbO?=
 =?us-ascii?Q?ZD+LXV6+W+TLSwoU5fZJYVsnC9PDAi3tpW/A60b91Pg79BXNRIls47DrYBDE?=
 =?us-ascii?Q?4a99hFxmYX86csUyrSSn6y+4SVP3+XfQ5Ltuhl+9abRdYc3dVWnJl1xKK+2H?=
 =?us-ascii?Q?arAXaAYU6Rx+AOSp54kHDWV9k+IVdLE4xAb+GAsyIznNnHz5Va+LTEyXLNga?=
 =?us-ascii?Q?e0ll4K3Rq2Ij1A5IbU45JSZ709KcWPcYsrJtn15ee4EtnhabkslGkA7hKI+o?=
 =?us-ascii?Q?SOoClPnhSzB6wWKk9ZPCODDeyKn7nkNw1oLD/8K62guwt9J7EK2ohPXRk99H?=
 =?us-ascii?Q?ivleBGPl0SIc0LNpGRRKZjbvbJe8T17IviIwmqS6cnb//bzIQSb4KZDCSLDl?=
 =?us-ascii?Q?j4JF4sN2IdZbCcgvFYchQhy6kl1nO2S2b7hRn43FwjcQ0tIhCZrbRrgK8s+o?=
 =?us-ascii?Q?bVuvgbdXp6YctAK0ki67ddU/FT2YCafB12f5jguXj4gMqJFZvCPvAp2E6QXF?=
 =?us-ascii?Q?icciHt5uqDl75GoN8/UVHR9VzL3D3GivHBlX+0aD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c27b7a-9f41-4e7d-b4e7-08daf245df6c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:31:54.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkKcohWd40uNnhaExlTD1WuiA6MBhLC+98P61GiDw1he9R5aSJop7V5Lt7ccr2kW7ulZOcPyfh5VdW4XCsYh8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5074
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add detailed documentation about:
- ETHTOOL_MSG_ULP_DDP_GET and ETHTOOL_MSG_ULP_DDP_SET netlink messages
- ETH_SS_ULP_DDP and ETH_SS_ULP_DDP_STATS stringsets

ETHTOOL_MSG_ULP_DDP_GET/SET messages are used to configure ULP DDP
capabilities and retrieve ULP DDP statistics.

Both statistics and capabilities names can be retrieved dynamically
from the kernel via string sets (no need to hardcode them and keep
them in sync in ethtool).

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 106 +++++++++++++++++++
 Documentation/networking/statistics.rst      |   1 +
 2 files changed, 107 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f10f8eb44255..146c6b474913 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -223,6 +223,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
+  ``ETHTOOL_MSG_ULP_DDP_GET``           get ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET``           set ULP DDP capabilities
   ===================================== =================================
 
 Kernel to userspace:
@@ -265,6 +267,8 @@ Kernel to userspace:
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
+  ``ETHTOOL_MSG_ULP_DDP_GET_REPLY``        ULP DDP capabilities and stats
+  ``ETHTOOL_MSG_ULP_DDP_SET_REPLY``        optional reply to ULP_DDP_SET
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1716,6 +1720,108 @@ being used. Current supported options are toeplitz, xor or crc32.
 ETHTOOL_A_RSS_INDIR attribute returns RSS indrection table where each byte
 indicates queue number.
 
+ULP_DDP_GET
+===========
+
+Get ULP DDP capabilities for the interface and optional driver-defined stats.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  reply header
+  ``ETHTOOL_A_ULP_DDP_HW``              bitset  dev->ulp_ddp_caps.hw
+  ``ETHTOOL_A_ULP_DDP_ACTIVE``          bitset  dev->ulp_ddp_caps.active
+  ``ETHTOOL_A_ULP_DDP_STATS``           nested  ULP DDP statistics
+  ====================================  ======  ==========================
+
+
+* If ``ETHTOOL_FLAG_COMPACT_BITSETS`` was set in
+  ``ETHTOOL_A_HEADER_FLAG``, the bitsets of the reply are in compact
+  form. In that form, the names for the individual bits can be retried
+  via the ``ETH_SS_ULP_DDP`` string set.
+* ``ETHTOOL_A_ULP_DDP_STATS`` contains driver-defined statistics which
+  are only reported if ``ETHTOOL_FLAG_STATS`` was set in
+  ``ETHTOOL_A_HEADER_FLAGS``.
+
+Similar to the bitsets, statistics can be reported in a verbose or
+compact form. This is controlled by the same header flag
+``ETHTOOL_FLAG_STATS``).
+
+Verbose statistics contents:
+
+ +-----------------------------------------------+--------+---------------------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COUNT``             | u32    | number of statistics            |
+ +-----------------------------------------------+--------+---------------------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_MAP``               | nested | nest containing a list of stats |
+ +-+---------------------------------------------+--------+---------------------------------+
+ | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM``        | nested | nest containing one statistic   |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+ | | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME`` | string | statistic name                  |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+ | | | ``ETHTOOL_A_ULP_DDP_STATS_MAP_ITEM_NAME`` | u64    | statistic value                 |
+ +-+-+-------------------------------------------+--------+---------------------------------+
+
+Compact statistics content:
+
+ +-----------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COUNT``             | u32    | number of statistics  |
+ +-----------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES``    | u64[]  | stats values          |
+ +-----------------------------------------------+--------+-----------------------+
+
+In compact form, ``ETHTOOL_A_ULP_DDP_STATS_COMPACT_VALUES`` contains
+an array of unsigned 64 bits integer of *count* elements, as a binary
+blob.
+
+The names of each statistics are not global but per-device. They can
+be retried via the ``ETH_SS_ULP_DDP_STATS`` string set.
+
+ULP_DDP_SET
+===========
+
+Request to set ULP DDP capabilities for the interface.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  request header
+  ``ETHTOOL_A_ULP_DDP_WANTED``          bitset  requested capabilities
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_ULP_DDP_HEADER``          nested  reply header
+  ``ETHTOOL_A_ULP_DDP_WANTED``          bitset  diff wanted vs. results
+  ``ETHTOOL_A_ULP_DDP_ACTIVE``          bitset  diff old vs. new active
+  ====================================  ======  ==========================
+
+Request contains only one bitset which can be either value/mask pair
+(request to change specific capabilities and leave the rest) or only a
+value (request to set the complete capabilities provided literally).
+
+Requests are subject to sanity checks by drivers so an optional kernel
+reply (can be suppressed by ``ETHTOOL_FLAG_OMIT_REPLY`` flag in
+request header) informs client about the actual
+results.
+
+* ``ETHTOOL_A_ULP_DDP_WANTED`` reports the difference between client
+  request and actual result: mask consists of bits which differ between
+  requested capability and result (dev->ulp_ddp_caps.active after the
+  operation), value consists of values of these bits in the request
+  (i.e. negated values from resulting capabilities).
+* ``ETHTOOL_A_ULP_DDP_ACTIVE`` reports the difference between old and
+  new dev->ulp_ddp_caps.active: mask consists of bits which have
+  changed, values are their values in new dev->ulp_ddp_caps.active
+  (after the operation).
+
+
 Request translation
 ===================
 
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index c9aeb70dafa2..518bf0cbeffc 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -171,6 +171,7 @@ statistics are supported in the following commands:
 
   - `ETHTOOL_MSG_PAUSE_GET`
   - `ETHTOOL_MSG_FEC_GET`
+  - `ETHTOOL_MSG_ULP_DDP_GET`
 
 debugfs
 -------
-- 
2.31.1

