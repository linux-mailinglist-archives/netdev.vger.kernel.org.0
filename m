Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D586929E0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjBJWNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjBJWNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:13:04 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41EC68AD7;
        Fri, 10 Feb 2023 14:13:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtlOG+dnxYZxoxxS3I88bywJn0wP5CfqAtFBJNhjm7Akf5eyX0oHXlOzs2tLtfGcWuuwF0e/D968T7c4VElr1MMT4B1wTVsk3F2vDvA016/Br8xPQrCEtL3tdCy4c6DG4i9lHAoHpQv5yEeUCQiVCs9s2bftFi3A0zCayXS5VqAPcOAtcGQ7PqNywyIQM5XA22+UJ0KilJVxbd29LY/Hx2CsNDhZIsbrO6BYBBiFJFCGHbOm2gTy9RHWE4lLDBxvOIc33tl4NIPpT9DkK7EcHg0tzEwinafcKSPhHwVWBnOtUOCe6xI9ikw+hxB4U+AwGSlhvZbehqxIQ7Ry1Dcieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGRNLlTrE8tntyz+9V72q3u/cX6EgpJhRGLlnbnMObg=;
 b=HEhXwzTbqrfB7U/W5wisRTCZJUYIGbJNhyN7QB7LeQPcpPJ8ANCvk4/uzaTDnoeWY2xL9Au+VrSUNKgalE5+POY44SIPTnAqQPj9e6nS7W9vhJoA3PuPMl5PBJQO2ryruu05vn6iIvmiiZ0pE1hbKPawPWrVfL2tua9gMj1WjUldCZQgl3wAR7UDo2PiD79ldgCXzXV3Rrv+zHkc1epVFecPpC5kdNmH5dDcXpfabSQmW4x8azYQgMqjw7OEQNhVIaSP2VqsE7cdy8bohzKo/6cQUYxCi4nXJyeOxCuzBhjk+3iePpNKZWqVSn2+ItoN9tyw4sS6cmKCdADBm4Fp5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGRNLlTrE8tntyz+9V72q3u/cX6EgpJhRGLlnbnMObg=;
 b=PKLDmfbdOHskYhLisNtK08RcYQ0QVOXkf+tmWWYODWha4FWnIO8sP3eYkp56pdmo74/9TaMogRj5B0WODaL+O2mDbRcyE8ijoakArWwdAKvAQff2UhT9h50D1g4wdKRtg00RNOaFTBWP4BCcPx6tYKZDHPXjixbMCpfvHYVPDs0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8840.eurprd04.prod.outlook.com (2603:10a6:10:2e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 22:12:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Fri, 10 Feb 2023
 22:12:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        UNGLinuxDriver@microchip.com, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [RFC PATCH net-next] selftests: forwarding: add a test for MAC Merge layer
Date:   Sat, 11 Feb 2023 00:12:43 +0200
Message-Id: <20230210221243.228932-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8840:EE_
X-MS-Office365-Filtering-Correlation-Id: 12991387-62ca-4130-34db-08db0bb3f75f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ci2WCMsAYoIf1e6bALEvd5sEThUPzrNfBH9MVnLCqakJijq+8TdBPLXKhbDoscVZN4+PpZQWAtskJ4VV8e3ls8MDpJoYgFmacCba8d4/Pq9USfxuu3dnn/7v3b/71Fsj8BGv53iB+l9QM/BtIC7b0R/u5ubDRKe9J+nKj0+cTJgcnON9fFbtSv+HubootzUkvdZ6A2+7UyYTAg1tThkLPUTpwtoesyhiWfP5njeBL2cXl/8k/pOHl4XRNccK2MYQ9Mi+/tDF5YSZFHJMjnd7/FspWPrEFhaZQOWuhlOxay9wDe+XbhEtwhycervuuD4iViTAc5KMSdlAhEnnEM3VAiA/IryBp8uu89W1+Lwdv55pKfzfWIL+wwG74jaGV67DqcGmS9F3YNdUGDOV3HLmXR7JIY1RUs1tc++KuqSvCTfRnxnl8+hpTuXQE0sIt5n9ir+44R2sXOQBT5Ny7uYNSJYzxDCmnqCa9OlKcJ3fdrzP63HtknmA2K5aqyeMZW0G6ZhvY8GX7RkAw948T1NanKm/hP5+hAu5df4TIocR6n6uzw4z9SaQLCESLcRdo+2Lk2lx5Otrjcs4WZkavB0trnFGaTD/jFvlHGivnQMuC0IfXwXIFWPV036qEzUO7L6fqhMX19qX1yRBU51ECycD+jKMgH+gWV8xQuvA8Dp6ur+MCuNzddlFCqVlcC0K0u+3BFwz0gQWQMfT9AryfWhT7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(5660300002)(66556008)(66946007)(7416002)(316002)(8936002)(6916009)(8676002)(41300700001)(86362001)(38350700002)(38100700002)(36756003)(54906003)(6506007)(186003)(66476007)(52116002)(6666004)(6512007)(26005)(1076003)(44832011)(4326008)(2906002)(2616005)(6486002)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjBI7erZ17vDCEIOSXD0PIEkSVtMqi3wGNM+ZS0/C6RFQ5WURq+IOTVLHFWS?=
 =?us-ascii?Q?oAc26SskjUkXc2XoCfheYxlW7s3Psg9shUY+Zvd9Wa5WRTyQquwOwRsBZ1mk?=
 =?us-ascii?Q?xebe6bhoBSCjFdCzvhCEF3gdJ3HNup0cDFPDr4v4+t2pgFprGl+UDzee9qCA?=
 =?us-ascii?Q?LZH7wnnoISIOfE+31rQZ8UOU5iWmsk7w0UJr9OAvzTbRGY12aeLooahNm0oV?=
 =?us-ascii?Q?/29PcEJQbPYmsYaLK3UNVo11cr9oCEfS1PBo54vm/FdYmVDvl0qkArUIhr0C?=
 =?us-ascii?Q?FwP3M7wAP2C8v0VXLfacnWIaLAY0BTBFfKLN8poy5y+XcUbTXjBdcOr0lxsj?=
 =?us-ascii?Q?IR/OvCuvF49FO8zif7ba+8u6BPhQ4DrH8aiywlnlfkAPvxNsMtPkN9Xk0pGO?=
 =?us-ascii?Q?FCtCzNcSW+Zg64BWkjytIaUqkGPugEJ99imyJA7MxxtPR820SlLqssd/YXZG?=
 =?us-ascii?Q?imZ7JFpDoeQjkbGGAFjJFdAg86U7ELZ5rgcLE+Gv3gfSaqSZ+16DAuayCLTF?=
 =?us-ascii?Q?4lPbbrpS4gj2H/q+mgQrwau3EfwDLG+J0Oa/ooF+DWLa3nXdbwNjNICMLlsi?=
 =?us-ascii?Q?2g4AGQYFyYqMKptwPlfHDWKGvsTD7qwGnYE6Vy1aspmmUURSdaSGfSjNN5SW?=
 =?us-ascii?Q?dQM5yc6RKjNpVcobjb6FukNH2X4xLnRcpz0hlXt2sFwB2HSBwad9bCBsjUx6?=
 =?us-ascii?Q?WVOVKWqvA1Vp7jIrXBG4JrdYC+wWKb72FJiGMnUCBDsxbnIgHm1/k0iQTfCW?=
 =?us-ascii?Q?CzwpfVIfEciyVaZw4LC7IdGSmIbJp4ndEFaRrJlEcePZnKImJjcEfdm6cF6P?=
 =?us-ascii?Q?5i/X4rwOKE3Mti7RPETQ9gl9SMzivMDwDSg/4uWsB+cdi2s9fYBX3MK84gKr?=
 =?us-ascii?Q?g0B4AY0XbN1eUO8thOvHSEFDRQZbn49ifgGNSflajAdKOA0hQzG/ucW2zk2S?=
 =?us-ascii?Q?n7YvVjydBtZuxQnNGyjnlQJQf/TQ0IsQYCKYRdkwm4gCT2Hq36N2XvojQ1CY?=
 =?us-ascii?Q?3iWeryNiUv65paBcp28gU/hjxDhHCme1cBQW13dfs/Ob9wNcF0bxA3r03nr5?=
 =?us-ascii?Q?EkYpwKX2b9T72XP7vsYjeOAEuoJv1cWKQbu9ZXfofiz29NZU4Uaa3nCup0MZ?=
 =?us-ascii?Q?reEFfCLttmZnT36mCCU7hfIaissOlcifZId3s3HHdAhhGrFHTYdamzy39N3a?=
 =?us-ascii?Q?27louHhb2snAj+IFKzj/DBlYDiSUDxkIH/NJ1UzFIv9gS3uGL/KZepC5GbXm?=
 =?us-ascii?Q?pZl0dYa1WANXIInNhBsD4dl9tKtTduZgjjRKU+xxdADYKoeVXtr7SjrXcNrF?=
 =?us-ascii?Q?oOtFEVx12Zvzm0koq56TPU3EbGKzt9rudVvBmIFh+gvUiFCY2C5X2xECgIB3?=
 =?us-ascii?Q?cbY76fRKrk5ITGdjvSFBvkOj6c8IXKTLIwbBkIPTYQa6RqV9Fr+5NcXipq4m?=
 =?us-ascii?Q?15qfKqXGxUFChFsBsBlIqIjTPMaP7MErM5pc3TsmH8Z0J6i5VswoGkAucqYK?=
 =?us-ascii?Q?hKV1p9F4gRx4moJ2qxAr0ZOYzM0Cic62cyLbKNP/1EOfArTZGItzld2jeUXL?=
 =?us-ascii?Q?QWMjDmUQxQshtha+H2TrZQEpItpjvkze+Lbdi/jd8Jlff7WRJiG28NVQVk2/?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12991387-62ca-4130-34db-08db0bb3f75f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 22:12:58.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKX2ofNTTj3wK+9USrO5VtqJ3XqWYu3gwQ1DZytuArHklybmHKKTITA8YsgcX3Az2+vilDXltynjDG1UPQuk9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC Merge layer (IEEE 802.3-2018 clause 99) does all the heavy
lifting for Frame Preemption (IEEE 802.1Q-2018 clause 6.7.2), a TSN
feature for minimizing latency.

Preemptible traffic is different on the wire from normal traffic in
incompatible ways. If we send a preemptible packet and the link partner
doesn't support preemption, it will drop it as an error frame and we
will never know. The MAC Merge layer has a control plane of its own,
which can be manipulated (using ethtool) in order to negotiate this
capability with the link partner (through LLDP).

Actually the TLV format for LLDP solves this problem only partly,
because both partners only advertise:
- if they support preemption (RX and TX)
- if they have enabled preemption (TX)
so we cannot tell the link partner what to do - we cannot force it to
enable reception of our preemptible packets.

That is fully solved by the verification feature, where the local device
generates some small probe frames which look like preemptible frames
with no useful content, and the link partner is obliged to respond to
them if it supports the standard. If the verification times out, we know
that preemption isn't active in our TX direction on the link.

Having clarified the definition, this selftest exercises the manual
(ethtool) configuration path of 2 link partners (with and without
verification), and the LLDP code path, using the openlldp project.

This is not really a "forwarding" selftest, but I put it near the other
"ethtool" selftests.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
This is more for the sake of the discussion, because neither the ethtool
nor the openlldp changes for MM were accepted yet.

Not sure if this is the best way to integrate lldpad into a kselftest,
given the fact that systemd starts it with a persistent configuration
file.

 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/ethtool_mm.sh    | 174 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   9 +
 3 files changed, 184 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_mm.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 91201ab3c4fc..7d95990e18ce 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -15,6 +15,7 @@ TEST_PROGS = bridge_igmp.sh \
 	custom_multipath_hash.sh \
 	dual_vxlan_bridge.sh \
 	ethtool_extended_state.sh \
+	ethtool_mm.sh \
 	ethtool.sh \
 	gre_custom_multipath_hash.sh \
 	gre_inner_v4_multipath.sh \
diff --git a/tools/testing/selftests/net/forwarding/ethtool_mm.sh b/tools/testing/selftests/net/forwarding/ethtool_mm.sh
new file mode 100755
index 000000000000..b66db9419a27
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_mm.sh
@@ -0,0 +1,174 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	manual_with_verification
+	manual_without_verification
+	lldp
+"
+
+NUM_NETIFS=2
+REQUIRE_MZ=no
+source lib.sh
+
+# Borrowed from mlxsw/qos_lib.sh, message adapted.
+bail_on_lldpad()
+{
+	if systemctl is-active --quiet lldpad; then
+		cat >/dev/stderr <<-EOF
+		WARNING: lldpad is running
+
+			lldpad will likely autoconfigure the MAC Merge layer,
+			while this test will configure it manually. One of them
+			is arbitrarily going to overwrite the other. That will
+			cause spurious failures (or, unlikely, passes) of this
+			test.
+		EOF
+		exit 1
+	fi
+}
+
+manual_with_verification()
+{
+	check_ethtool_mm_support
+	bail_on_lldpad
+
+	ethtool --set-mm $h1 verify-enabled on tx-enabled on
+
+	# Wait for verification to finish
+	sleep 1
+
+	ethtool --json --show-mm $h1 | jq -r '.[]."verify-status"' | \
+		grep -q 'SUCCEEDED'
+	check_err "$?" "Verification did not succeed"
+
+	ethtool --json --show-mm $h1 | jq -r '.[]."tx-active"' | grep -q 'true'
+	check_err "$?" "pMAC TX is not active"
+
+	log_test "Manual configuration with verification"
+}
+
+manual_without_verification()
+{
+	check_ethtool_mm_support
+	bail_on_lldpad
+
+	ethtool --set-mm $h2 verify-enabled off tx-enabled on
+
+	ethtool --json --show-mm $h2 | jq -r '.[]."verify-status"' | \
+		grep -q 'DISABLED'
+	check_err "$?" "Verification is not disabled"
+
+	ethtool --json --show-mm $h2 | jq -r '.[]."tx-active"' | grep -q 'true'
+	check_err "$?" "pMAC TX is not active"
+
+	log_test "Manual configuration without verification"
+}
+
+lldp_change_add_frag_size()
+{
+	local add_frag_size=$1
+
+	lldptool -T -i $h1 -V addEthCaps addFragSize=$add_frag_size >/dev/null
+	# Wait for TLVs to be received
+	sleep 1
+	lldptool -i $h2 -t -n -V addEthCaps | \
+		grep -q "Additional fragment size: $add_frag_size"
+}
+
+lldp()
+{
+	require_command lldptool
+	bail_on_lldpad
+
+	systemctl start lldpad
+
+	# Configure the interfaces to receive and transmit LLDPDUs
+	lldptool -L -i $h1 adminStatus=rxtx >/dev/null
+	lldptool -L -i $h2 adminStatus=rxtx >/dev/null
+
+	# Enable the transmission of Additional Ethernet Capabilities TLV
+	lldptool -T -i $h1 -V addEthCaps enableTx=yes >/dev/null
+	lldptool -T -i $h2 -V addEthCaps enableTx=yes >/dev/null
+
+	# Wait for TLVs to be received
+	sleep 1
+
+	lldptool -i $h1 -t -n -V addEthCaps | \
+		grep -q "Preemption capability active"
+	check_err "$?" "$h1 pMAC TX is not active"
+
+	lldptool -i $h2 -t -n -V addEthCaps | \
+		grep -q "Preemption capability active"
+	check_err "$?" "$h2 pMAC TX is not active"
+
+	lldp_change_add_frag_size 0
+	check_err "$?" "addFragSize 0"
+
+	lldp_change_add_frag_size 1
+	check_err "$?" "addFragSize 1"
+
+	lldp_change_add_frag_size 2
+	check_err "$?" "addFragSize 2"
+
+	lldp_change_add_frag_size 3
+	check_err "$?" "addFragSize 3"
+
+	systemctl stop lldpad
+
+	log_test "LLDP"
+}
+
+h1_create()
+{
+	ip link set dev $h1 up
+
+	ethtool --set-mm $h1 pmac-enabled on tx-enabled off verify-enabled off
+}
+
+h2_create()
+{
+	ip link set dev $h2 up
+
+	ethtool --set-mm $h2 pmac-enabled on tx-enabled off verify-enabled off
+}
+
+h1_destroy()
+{
+	ethtool --set-mm $h1 pmac-enabled off tx-enabled off verify-enabled off
+
+	ip link set dev $h1 down
+}
+
+h2_destroy()
+{
+	ethtool --set-mm $h2 pmac-enabled off tx-enabled off verify-enabled off
+
+	ip link set dev $h2 down
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index d47499ba81c7..30311214f39f 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -129,6 +129,15 @@ check_ethtool_lanes_support()
 	fi
 }
 
+check_ethtool_mm_support()
+{
+	ethtool --help 2>&1| grep -- '--show-mm' &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: ethtool too old; it is missing MAC Merge layer support"
+		exit $ksft_skip
+	fi
+}
+
 check_locked_port_support()
 {
 	if ! bridge -d link show | grep -q " locked"; then
-- 
2.34.1

