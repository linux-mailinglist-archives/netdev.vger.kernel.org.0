Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF582786F2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgIYMT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:58 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:63262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728159AbgIYMTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFLBMcYULRuXJ1bSnMMgCd2f1a17wiNurYHSVrqwY7reu5+WBAmBye2AOt8TZ5fn7oRl7CJrKkRXzKuZ3eauNSyNn+5kBH9CodbbarcMUZym2iXdYN4N6391KIVFMBQu7vXdN9jIVaF4+fKQTTI4DhFYpekpOGOZvFA+p5YkeW7Eqdx6w/FPqBNJ7/a02PJd59odrh4LU5B+XL2fv8Ac4BGyigKm21bPwd/pwz3DUxZrAitqCK6noJeUJ7pUvS3yizKdM6Depfrfp6A9WPM59vin5IWiEx4o1D6Tg+Q7C65rlbzjGRfMiLnkk8r2+xSli6296YVQcQv+QSrgSEPZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYWaNUw/BkVz7+FIFBIcWhFTp9LtGoaiKh6oj2cSEGc=;
 b=ROO0vxxXzDSyGfjg2yuSEEgmTaabb1ZBpmVas+rgtPMpbGTaIcx5rA1YelYXeChphByEL5YjP0Et+aomt5dUKX4dA35khAO21ZlTzST/DA1Nkk5RBaconZ9mpTbnC5baHkTD+dNb1CUiz+XBqS4dBtyL0iPPIkMY8/53JdI9OgDbxH1zkNNpJkN8MfBLmkQ+/aKFSaqjJB8HW02mv1rB5aYDne4ynaCDzxupPGcQjAWTQNP/On4JD2GNFvP4TTHMdB6YviBZ3Xn/thosDsZf+mc/1r5VuJE8HUkZtU7VYUVGUnj2qZfCC7JcwJQaAU3jZ9X2R8aY2cDkHFdFzvTQTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYWaNUw/BkVz7+FIFBIcWhFTp9LtGoaiKh6oj2cSEGc=;
 b=lVHG/4ca4xjiRMEWTteidudWPdE2dsYJeP7gF9blxtbc+TZIxgJ8wgU6MLy1AqHuGfVprFUkDmlJWy/QT87GbVmeUfJqtOOP2Lyjzq5NZqngN1HXzc8BqNco8HaP6NtieGLilyTOU29K8Hm7QkRsyelv/n6MUWWDcNejuaDldRA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 14/14] selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads
Date:   Fri, 25 Sep 2020 15:18:55 +0300
Message-Id: <20200925121855.370863-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:31 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26981cf5-f547-4c94-8151-08d8614d41b4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35500C3195842C4ACA3686C1E0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: te3qdPJ8+XCfF0lddohxXYqCyDUVk+LaNuhvenIIs7X0JK1DAUZ+GAwRFdunGA7pPZT696cr+a2YRbrj4Q3mN5NNizNTKJ4MQZ8mpBeMrCfO7rOnG/w0HbxeD+nTU/JvhzsJsn4/EggjeBO6pXlO0TCKjoGkimAKAp+Fl087UNP42vM1inB87fequdYPi2kbi8e6U2t6XcIk3XXgVZnchOPvvgEpmwSCY/b3RPMklNopo0OFgyW7OnpAK+GZ//tqqJrKPHSUyBpAGVDceRkEjcYSQSZ8BluufSquk5pXAmVM4dhMpNQclFrV1rmaTlXbHVcWkJqPdFX52kBAQHHjM2OZUGgDj1sNax++UJ6egYCJZBCSE04UX5GugS0HcNJW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QkEX1ksIkxiWJQQGkiJzBBOdFBKPuUDFGESPoe0/2sayEWtHYd7brs19F7PMeJlR6XCrgp3qI2ZIienap7cbi0VeFmFpW5gvYkZ0LeYG0wMVv6EWXdX93ik8eoOgXPIQbtVvAmVZuRvZMPQ73yytVvDVRK52F0xOGsS0OsJSqWN5NnyHS+Z0WFOKtMwQ9GDY39SdU4KAcjXvuJC8VdjPuEC1ivAuRW7YRPidKMF7P0kRVGhwwO5rwevjt5+amem7bJ4kqDpJIbUr4JvHh2NfH6Tq0UiCf80HJ2d3QIX/txBgsdsTYEjfX3+azSuqgutbCJDBfj+AYnkxtgK1uFeb1U0cexNtPj0GAr0ZhjDkBv9SRy/T8gL/x1++bJmFP8VxL7k30sgAOHlw9CDoRsWE31Tjfrwd3BTqPO/+Ok+wzwUyZHDpcMOFGG2SrBl2MHtO3r2U5s6hGG1XAXspTDHe1ilVF89aKyap/ogzvWj4MsuzP3udMH4xyr9NbbLclBm/VXyBHNjlqREQMao4agLb3H5b2Vpkkk+iGu3ihHFxUAZnyTz8cStajVOWMqH9ZXyxSncD04v6VGUdM5vQvejWsY1ZxsiUobHUgcoFk0yU2k3rZiXJ9I7Ctsd9czkQ7QtMeOtKZ+ewzFFx8qVczi4SiQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26981cf5-f547-4c94-8151-08d8614d41b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:31.7698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ruc91sPBG9z6k/juGBDV1WJNo0vaU/3CGIXCOBhT+x8rWBblKDiIsvRywDRCDZ/4Ua3hbOMFmyZTENUzBHTt7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an example script which can be used as a skeleton for offloading
TCAM rules in the Ocelot switches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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
index 000000000000..d66793452932
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
+# called Policies. A Policy is selected through the Policy Action Group (PAG)
+# action of VCAP IS1 (which is the GOTO offload).
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

