Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1887127C205
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgI2KLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:00 -0400
Received: from mail-am6eur05on2072.outbound.protection.outlook.com ([40.107.22.72]:5125
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728033AbgI2KK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:10:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJl3Lgl2sx+l9AyxK/8h4QOkI57NarhpCPsKU1KcafJw93Fl5lNlkU7+eHWs1IV2v5dfBh/+Kgdlsq6yAwzCmVhUBCfbS/a1WMAyGZcOmuw/v/WQ1/wtkRj+t9nHDM0CepedcVVl5BppLvY9E90COwZ9v4gofdFDMXAk3JARrVT6MiNQc0vDYsPtW8wzFoEitcrZK43xAhaNnnaHvZR7rhvENR8vBoTasw50tpl1Op9uHjjYVuQsaUvlGhC06J3PVJNJi5YZMaGJiomMA4P5xC79fhap7mPLSHzZJhpEvSOWiYYieLMmLlmehRGSK2DqoWUwehoFOp/9WWF4gu2d1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ts5azIms4rRdqm72sxfWLfNH050PsuB01TOs379JkhY=;
 b=WxZ1thjuNTqxM5cIf2wZNU7OP8dk5KcvsnWpOO3Qqz6rM7LS7Ol54de/t2J/F1r9RiSFNwGgPcUWBbjGorXDOVttcvpvs/vQUPV+tDuC1edsg7uqTjOuhQeIuJMOHYjNtrb4+f7u0fcmcjWQ3TxdoN7bEe9fJZKZ8l+090ahozVFRtwIbLtJsu1/IVEGUYNr1UYv5YB7nrZMZrisQyPHcJMt/M8R+r1KTMT2mpmQ1oWUlfJ2SlBm7Mxq2OzGTh5+h/YioT0zciGS67ycsdhE/gi3AvHXX9Q5VnYkbeodc5JGHu1kSv2b9zjpAg89hm1EDMbheb4ZoKgue9EzY8FsZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ts5azIms4rRdqm72sxfWLfNH050PsuB01TOs379JkhY=;
 b=mR4DgRRqO9nGUbRRqJv5gK0Og1lRQzwTteG6VpeAny7OWWmQiNneCYJF686wZ9rfVGrXmnsih88C8lCsZNV8FGsT8GyGX7tLiH4ZPUrs2/FNzrq7ADChRqRHi2sG+Q3lqSrqmabhDnxK0gCltL5i7qkIpPh5ORGKNav+xSsTiF4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 21/21] selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads
Date:   Tue, 29 Sep 2020 13:10:16 +0300
Message-Id: <20200929101016.3743530-22-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b6bc167c-a225-46d7-44ab-08d8645ff238
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB62718CAD88CA540C806AF2C4E0320@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pDYSQjFLAhjApz2RxMURyHb8WZMmiUNwQ/hEwHs4e/3h6lxhfUTs60V6cXx8qXyzCniisKSqSEE+6vxm06MEaGBN+bRS1bx1bh7dnV/NroTqQz3EyigOPMPETuVuHy8VDOat6JubS8Xhph5TOaF6xmh1S4AkH39cf2mRHCnyfFYG7h0mcom0ZyGNneZE8KfWehM+i5HKGFUq2sCdmKoGxNjbZhl6bTf5yVZr1+4tXWd/DundwE1EGBCcrLT057icq6lk7hoNTl36guOnOdKE+hYPwUxMbmbU1J5TNQlaJ96WfpIgID89b2Dk0QvytWn/T1VSKYTmV+CRq8Ws7ToPUEiCzL5uTYipKbG0vlUcsixUyB1zrMC3FNJt6W4g9/u9hqec7+Rr+znnLiGVGN59X9NgpkiHPW84G23IzmFV57F897yJLbAjxPYITfmLW5X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(956004)(2906002)(2616005)(83380400001)(4326008)(8676002)(8936002)(478600001)(5660300002)(69590400008)(36756003)(1076003)(86362001)(6666004)(16526019)(316002)(66476007)(66556008)(66946007)(186003)(6486002)(52116002)(7416002)(6916009)(6512007)(26005)(44832011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aRVJ0xAIN5lOiCPkg8LK8qq8Al9qiYNES2vplcPFBalOT97D4+6DTOEr7mWmsVKPXDGkJfwSFP6g4PFJD7vaS8bHvJsEvuxB+e1h7CU3ibqNLKqR0DezWHvbzwlhr279dLQHghjah/SX3LYZ0UC/c+cG+c3dd2kpoCvagR7K/yc086JNFdZqKLQXB3Fq4C1lCJEGUKryFtD4UF9kXSkCBklbQcBUvGOyFe6rJHQ81dwIhXlVrHPXJkKNbllq06x2+/7tEXv6QFmxCrgaEP69cPF3LDXjcBgPSk5TLmQPCqm8CUI8Xsd+UxTVuAijoKaomZnZtGARl/Hbrw1xSqeu3UbMUybpOvn417zrpEKJNYSgBgvKSKDTt6mhpKnV7d2Tcv/wYEupGUlZnCq9iRY1P08VDl2A0fov1/3WcXJbddQBG7AV+RP4hYhwcwl/s9TaQwL07dPvxLFOLOWjec0elF58ws1jZUAYw6vUphS/u3mUbZHEeIahHzPE7iQscOflD+fIWaKPe2x949KYW+jrayVtFdpM24Ou/RQTheL+0htG9L40Php2bL8pCjD3wm81/c66sPQNK97cRNChtVH5wU77fapSh8+JrO9x0D2FeoJ4tRmhbz4KuQraqNgE7NdaPIvReOIXEpDB7jUCcuFKMQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bc167c-a225-46d7-44ab-08d8645ff238
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:52.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pHupiCJ3ouAD0Rfa5/+snJkZmeQ46KN+rfhr38XCf6GxC5NxX5v+jQ7kc5dtNLOaBj/2KLxCqR5AwwJGKDoQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an example script which can be used as a skeleton for offloading
TCAM rules in the Ocelot switches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 MAINTAINERS                                   |   1 +
 .../drivers/net/ocelot/test_tc_chains.sh      | 179 ++++++++++++++++++
 2 files changed, 180 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 42c69d2eeece..bcd6852f1c65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12542,6 +12542,7 @@ F:	drivers/net/dsa/ocelot/*
 F:	drivers/net/ethernet/mscc/
 F:	include/soc/mscc/ocelot*
 F:	net/dsa/tag_ocelot.c
+F:	tools/testing/selftests/drivers/net/ocelot/*
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
 M:	Frederic Barrat <fbarrat@linux.ibm.com>
diff --git a/tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh b/tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh
new file mode 100755
index 000000000000..89274a3e9874
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/ocelot/test_tc_chains.sh
@@ -0,0 +1,179 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2020 NXP Semiconductors
+
+# Helpers to map a VCAP IS1 and VCAP IS2 lookup and policy to a chain number
+# used by the kernel driver. The numbers are:
+# VCAP IS1 lookup 0:            10000
+# VCAP IS1 lookup 1:            11000
+# VCAP IS1 lookup 2:            12000
+# VCAP IS2 lookup 0 policy 0:   20000
+# VCAP IS2 lookup 0 policy 1:   20001
+# VCAP IS2 lookup 0 policy 255: 20255
+# VCAP IS2 lookup 1 policy 0:   21000
+# VCAP IS2 lookup 1 policy 1:   21001
+# VCAP IS2 lookup 1 policy 255: 21255
+IS1() {
+	local lookup=$1
+
+	echo $((10000 + 1000 * lookup))
+}
+
+IS2() {
+	local lookup=$1
+	local pag=$2
+
+	echo $((20000 + 1000 * lookup + pag))
+}
+
+show_pretty_filters() {
+	local eth=$1
+	local output=
+
+	output=$(tc filter show dev $eth ingress)
+	output="${output//chain $(IS1 0)/VCAP IS1 lookup 0}"
+	output="${output//chain $(IS1 1)/VCAP IS1 lookup 1}"
+	output="${output//chain $(IS1 2)/VCAP IS1 lookup 2}"
+
+	for pag in {0..255}; do
+		output="${output//chain $(IS2 0 $pag)/VCAP IS2 lookup 0 policy $pag}"
+		output="${output//chain $(IS2 1 $pag)/VCAP IS2 lookup 1 policy $pag}"
+	done
+
+	echo "$output"
+}
+
+eth=swp2
+
+tc qdisc add dev $eth clsact
+
+# Set up the TCAM skeleton.
+# The Ocelot switches have a fixed ingress pipeline composed of:
+#
+# +----------------------------------------------+      +-----------------------------------------+
+# |                   VCAP IS1                   |      |                  VCAP IS2               |
+# |                                              |      |                                         |
+# | +----------+    +----------+    +----------+ |      |            +----------+    +----------+ |
+# | | Lookup 0 |    | Lookup 1 |    | Lookup 2 | | --+------> PAG 0: | Lookup 0 | -> | Lookup 1 | |
+# | +----------+ -> +----------+ -> +----------+ |   |  |            +----------+    +----------+ |
+# | |key&action|    |key&action|    |key&action| |   |  |            |key&action|    |key&action| |
+# | |key&action|    |key&action|    |key&action| |   |  |            |    ..    |    |    ..    | |
+# | |    ..    |    |    ..    |    |    ..    | |   |  |            +----------+    +----------+ |
+# | +----------+    +----------+    +----------+ |   |  |                                         |
+# |                                 selects PAG  |   |  |            +----------+    +----------+ |
+# +----------------------------------------------+   +------> PAG 1: | Lookup 0 | -> | Lookup 1 | |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    |  |            |key&action|    |key&action| |
+#                                                    |  |            |    ..    |    |    ..    | |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    |  |      ...                                |
+#                                                    |  |                                         |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    +----> PAG 254: | Lookup 0 | -> | Lookup 1 | |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    |  |            |key&action|    |key&action| |
+#                                                    |  |            |    ..    |    |    ..    | |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    |  |                                         |
+#                                                    |  |            +----------+    +----------+ |
+#                                                    +----> PAG 255: | Lookup 0 | -> | Lookup 1 | |
+#                                                       |            +----------+    +----------+ |
+#                                                       |            |key&action|    |key&action| |
+#                                                       |            |    ..    |    |    ..    | |
+#                                                       |            +----------+    +----------+ |
+#                                                       +-----------------------------------------+
+#
+# Both the VCAP IS1 (Ingress Stage 1) and IS2 (Ingress Stage 2) are indexed
+# (looked up) multiple times: IS1 3 times, and IS2 2 times. Each filter
+# (key and action pair) can be configured to only match during the first, or
+# second, etc, lookup.
+#
+# During one TCAM lookup, the filter processing stops at the first entry that
+# matches, then the pipeline jumps to the next lookup.
+# The driver maps each individual lookup of each individual ingress TCAM to a
+# separate chain number. For correct rule offloading, it is mandatory that each
+# filter installed in one TCAM is terminated by a non-optional GOTO action to
+# the next lookup from the fixed pipeline.
+#
+# A chain can only be used if there is a GOTO action correctly set up from the
+# prior lookup in the processing pipeline. Setting up all chains is not
+# mandatory.
+
+# VCAP IS1 is the Ingress Classification TCAM and can offload the following
+# actions:
+# - skbedit priority
+# - vlan pop
+# - vlan modify
+# - goto (only in lookup 2, the last IS1 lookup)
+#
+# VSC7514 documentation says:
+# Each lookup returns an action vector if there is a match. The potentially
+# three IS1 action vectors are applied in three steps. First, the action vector
+# from the first lookup is applied, then the action vector from the second
+# lookup is applied to the result from the first action vector, and finally,
+# the action vector from the third lookup is applied to the result from the
+# second action vector. This implies that if two or more lookups return an
+# action of DP_ENA = 1; for example, the DP_VAL from the last lookup is used.
+
+tc filter add dev $eth ingress chain 0 flower skip_sw action goto chain $(IS1 0)
+
+#######
+# VCAP IS1 entries in lookup 0
+#######
+tc filter add dev $eth ingress chain $(IS1 0) \
+	protocol ipv4 flower skip_sw src_ip 10.1.1.2 \
+	action skbedit priority 7 \
+	action goto chain $(IS1 1)
+# Last filter must be a catch-all GOTO to the next lookup
+tc filter add dev $eth ingress chain $(IS1 0) flower skip_sw action goto chain $(IS1 1)
+
+# VCAP IS1 entries in lookup 1
+tc filter add dev $eth ingress chain $(IS1 1) \
+	protocol 802.1Q flower skip_sw vlan_id 100 \
+	action vlan modify id 10 \
+	action goto chain $(IS1 2)
+# Last filter must be a catch-all GOTO to the next lookup
+tc filter add dev $eth ingress chain $(IS1 1) flower skip_sw action goto chain $(IS1 2)
+
+#######
+# VCAP IS1 entries in lookup 2. Policies, if used, can only be applied here
+# (as the second parameter to the IS2 helper).
+#######
+# ...
+# Last filter must be a catch-all GOTO to the next lookup
+tc filter add dev $eth ingress chain $(IS1 2) flower skip_sw action goto chain $(IS2 0 0)
+
+# VCAP IS2 is the Security Enforcement ingress TCAM and can offload the
+# following actions:
+# - trap
+# - drop
+# - police
+# The two VCAP IS2 lookups can be segmented into up to 256 groups of rules,
+# called Policies. A Policy is selected through the Policy Association Group
+# (PAG) action of VCAP IS1 (which is the GOTO offload).
+
+#######
+# VCAP IS2 entries in lookup 0. The default policy (0) is used.
+#######
+tc filter add dev $eth ingress chain $(IS2 0 0) \
+	protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
+	action police rate 50mbit burst 64k \
+	action goto chain $(IS2 1 0)
+# ...
+# Last filter must be a catch-all GOTO to the next lookup
+tc filter add dev $eth ingress chain $(IS2 0 0) flower skip_sw action goto chain $(IS2 1 0)
+
+#######
+# VCAP IS2 lookup 1, the last pipeline stage, does not need a final GOTO.
+#######
+tc filter add dev $eth ingress chain $(IS2 1 0) \
+	flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
+	action mirred egress redirect dev swp3
+
+#######
+# VCAP ES0
+#######
+tc filter add dev $eth egress protocol 802.1Q flower skip_sw indev swp0 \
+	vlan_id 1 vlan_prio 1 action vlan push protocol 802.1ad id 2 priority 2
+
+show_pretty_filters $eth
-- 
2.25.1

