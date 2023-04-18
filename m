Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF47A6E5F9B
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjDRLQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjDRLP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:59 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E84DE43;
        Tue, 18 Apr 2023 04:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgnHWqreL1dEgpWtTe5gKjITeOlhFHTe1GEZAY8SIfaIeItHx4xEcXLbGTfZI387bov/aEOcc0tWzDtdQMzznNjvGK1joWg5EfDBjS+KZ8uUrFitYI3R6QHgVPGrSmEFqi2WPq+ZUEdwQQdQ0XfmYv8HBbV45BbCkodCzZNPnk6v5VKS8qd4BX560muZDv+KEZ1n+jv90gjW5lwhbQfuofHs2lfywBuSE52be3eUr7eJ48m4p/mCG3nz7B0oUwso7PvT0YklxDwrAy+LQZD6IO817LXwX7NZLumKDk7IrTHnrHS0jzLNJroizXOYzbA5J71os9C8IjZoSAUdGvw3dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlRtNdKCgMkztqQQH+sDeS5a03EnGoS1PxFt0sEugjc=;
 b=fMkzRcIdZ2iuom/YGppGsTRb8SYQDnNHGGF9QkafBwgRIs+FTnOZXH61Q4AW5EKa1Z9+TDoRWQYi/G3l3NhwfdWZwPWQJKuFRKmsy4Z4wJgdw3/idmoYDDTKBjLnO/ksLtbvLLt02BY7sv0RdqpIP316C+8jvBCRi31pOSDyyIFptwWG/H6HODG9elJMHygZoxBl8/DYb91Ng4O3niLIHIv5MihgnLvIh0a5O6sdS/qIazt7x2/ICUEPnf/TlqsY4ZpgQOYynvv3lVpOfy01bdiPqhbPQaxjkdw6eZH1z0PmsnDn8A1gi8BFsi0MyyLsNZfp+9ExVXerY12T7qT0ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlRtNdKCgMkztqQQH+sDeS5a03EnGoS1PxFt0sEugjc=;
 b=p7eYJGQr8u86q89KPmx6oUmH6/VZ+ibOm12eQYDOAy1CLRq09CSSIPKTeZ51woZ9ofarjb1MsUUwUPRyZ7Z+Uqw+9VYuYSAUWlu1s6vPXGvSavJgES/+giI2/QUs3ulqbCSxkm0HhQHZwCRnnWkDY/hsMfoCqZqHlw6oqdxKMCk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:27 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 9/9] selftests: forwarding: add a test for MAC Merge layer
Date:   Tue, 18 Apr 2023 14:14:59 +0300
Message-Id: <20230418111459.811553-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: e1ab4642-b249-4916-7a6e-08db3ffe36aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hio13WFva8Bc7w0sFEzvNMPJkJRFN+oCTCbcnGsL3UBXUXUcljYOLSjySLClRGfddjwexPZHop89SXlPRNwqq5KN69LCLhiVUtgq0bRjjQtUFRgUQHH0nZxM9vrbQ43ImBTqkD1rLsEGWt518DrRXUE2yFL1gSv9Ca3ybxXeLrDW0Bly2Z+UV+JMow6BZ/ZvQzCWGkpFGzFFMGAcC/V59RUMTHWirhI2+/G74V3+5n+xz8L8vHgUEnNRqPtsOuS739aM1iD1c+x73gh49nDxGWBNhZuRvw5kTV7EBVkKYRLjasTCnezibWvB7HN4Kt5KraZ1zO9ZjRFu3REvPsYLc0lD4+H5g/LzwHg7C+e+oUwn3sxnkLlvDcOvWDW1i/siLspKNS/YqZGqjHUyVhf1pMqaofcW3LbvJLJpwmVSG8ZUTUBNWZWnXTWuqhtCcu58YvLoQ+NETUjcV+BA81b2GHuefjC9DmAwQEUu+r+tkxHK5MeNLyvqzxT+2umqH0JDjx4KJv7hnmA1wssmBSiY7V8/UlubkWiwgyvbGESmoHeEJsqU2mIYYMVHyLJ4WkTlksmgB9X8sGWeNw9pUv4sRGk+8c7ClDLHZOJAbLe3X4fJXNludSorNrf3eWFjx+a1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(30864003)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oTLYvZD9l9EhjL26WNbgVBrquvXYfvonyWf+87tmz5k0ejbgzkTNYyDupGSg?=
 =?us-ascii?Q?JCo6FQK6OpOFZ4Ed6t4otUdaQgCtvK55+fsxRV5ZniU4TW8iAWdqAjjK1e9n?=
 =?us-ascii?Q?mhxBIPcidZXTmnhitbiWWZ2rnkTESKjG0mExegTNhUscqOQ7y+R9mHySipIL?=
 =?us-ascii?Q?0FkiArS0o+CSUVLtNdrgVo3ayS134EnkZbQe1L3ttc/7QI15AcoaZuu5jeQB?=
 =?us-ascii?Q?jL5bvSG0EgUzi31ICpMn/QBjEjc+8V0hyH/C+EVPoS87/E/vbzFDrXoRRhII?=
 =?us-ascii?Q?kat6i/KGcFz4Ijfon5xCgVJukhr7DDlirORFzAnpKbpniIFBMJgr7SbFlLTl?=
 =?us-ascii?Q?wzWLMJXQ+TITXUWS1e8aHGVyxTf3IgE/7xw+TuINis11Hct8KLh9uuGxbX2S?=
 =?us-ascii?Q?VfqFgqM2jH+hI3UokY1HS8Yy6itGwcdg9P5wcVhxstvOlCGnVq43u+aGcRpJ?=
 =?us-ascii?Q?ANWk7QUS9GMMkUeNs7EHdufqbRb0O7hD8915YFK53/0s7Y9Eb2W/8lFqsV5F?=
 =?us-ascii?Q?0CQidpHIsoEiVa7o4mUrSCinK0+TscY9Gztxx4i7TriNVPh0KfPf2WKo/xsw?=
 =?us-ascii?Q?sfeehoq52zhTJt/6Bt8VjKSbIzwZ76hZa9rtNeJ62ilYdwhKyKXzEm2dpRz5?=
 =?us-ascii?Q?qOGr62aV5W7fnKZKMpH59g7HLlyLKWOhbbn3rMEDGiRtcVHidTAW6NnB7M3o?=
 =?us-ascii?Q?1d0j6W21frdh31TDsoy1lBhAJmEy6FmV5/nZhbtKoNR1pMuWYhnuFuPiVnk1?=
 =?us-ascii?Q?JOFAJU/By/z2Zpd6kz5AuYwHMXKgpiZiyMi/2URFwXd3Hn4+xdf6QczRZQd1?=
 =?us-ascii?Q?jlhOM7nX4bWkbDFY67OzuYEMuq5BXqe1xsBiyKMC2shtdY5C/qSgIbDvY74L?=
 =?us-ascii?Q?tkmUAHE73Q7PoVALUks7vQKOJzuelLbZ9KqKd6ryuP+fZuS8RqclCgb/IRK6?=
 =?us-ascii?Q?qCvzQ0bDjATH7Lmhp5aBJlbC/AcGyIbt7eZ7LrRpNMNDMvwHBNKhn0shVUaE?=
 =?us-ascii?Q?Yt1coqyKa8ux2/10KGFXY163GQ8d67oJQPGdMnlJpjxsAPdO0WSIsNaMKFo/?=
 =?us-ascii?Q?4JTD4O/pwjSwRq6TpQw52oX1+Ir1oBUh083cdzvshefvSaHgDNrbiZ9O62Pa?=
 =?us-ascii?Q?cuLWW9ESuHjPSzakLElJA/jQacBInmHjeRBBlvHTh+y2keOg/Q+xHiJLwYS8?=
 =?us-ascii?Q?viwJRE4KtCTPPvUhkFlBm652F4R5cE3fODK0TsbvFvGCsjGcAsC5LJ5i+2vr?=
 =?us-ascii?Q?rO/WGjvVOMpWV2zpArfOZwtrpgjq5NIRgkseR6CzYZH72ctcn703yOcgXbNa?=
 =?us-ascii?Q?1Gm70fWp6B7q8EAYoK06EBWXdqFx7oXivhQO+btpE6n8IGxnLG9EFwCuc2jz?=
 =?us-ascii?Q?kwrW5BU7ZvJoHjI7UxcXQdpZ86JWNshZXQfirRSB/EkMhM3Q1UlEyIseyrYP?=
 =?us-ascii?Q?zkUUnZXFm9Kg6WL274b9fd4qNRouywzzckI6C4gvy/1C9vrSUyy9FrJlewSJ?=
 =?us-ascii?Q?rD1zp1owh/Wb0BcscJ2+aK/I/DZp90XS+MKw5vw93ZBEl6qfvhxjdoXC5dpf?=
 =?us-ascii?Q?y/HdY3rChgvGpHwvOMHqu12Dyh7ZmYAv4WkfsKX2zq5tEdf2+7M9KRBsP20O?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ab4642-b249-4916-7a6e-08db3ffe36aa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:27.6684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcKmdOgvX299eDxP0Pj4aruSC0IMjk1JEuVD3Q5D0CTN6nFj8LPZrAUECDxFCMBqyN2MB8YAuraFD4BfBNFXNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

The test also verifies the TX activity of the MAC Merge layer by
sending traffic through a traffic class configured as preemptible
(using mqprio). There isn't a good way to make this really portable
(user space cannot find out how many traffic classes there are for
a device), but I chose num_tc 4 here, that should work reasonably well.
I also know that some devices (stmmac) only permit TXQ0 to be
preemptible, so this is why PREEMPTIBLE_PRIO was strategically chosen
as 0. Even if other hardware is more configurable, this test should
cover the baseline.

This is not really a "forwarding" selftest, but I put it near the other
"ethtool" selftests.

$ ./ethtool_mm.sh eno0 swp0
TEST: Manual configuration with verification: eno0 to swp0          [ OK ]
TEST: Manual configuration with verification: swp0 to eno0          [ OK ]
TEST: Manual configuration without verification: eno0 to swp0       [ OK ]
TEST: Manual configuration without verification: swp0 to eno0       [ OK ]
TEST: Manual configuration with failed verification: eno0 to swp0   [ OK ]
TEST: Manual configuration with failed verification: swp0 to eno0   [ OK ]
TEST: LLDP                                                          [ OK ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- bail_on_lldpad is generic
- manual ethtool mm tests are bidirectional
- new "failed verification" test
- testing with traffic as well

 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/ethtool_mm.sh    | 288 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  18 ++
 3 files changed, 307 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_mm.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index 236f6b796a52..a474c60fe348 100644
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
index 000000000000..c580ad623848
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_mm.sh
@@ -0,0 +1,288 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	manual_with_verification_h1_to_h2
+	manual_with_verification_h2_to_h1
+	manual_without_verification_h1_to_h2
+	manual_without_verification_h2_to_h1
+	manual_failed_verification_h1_to_h2
+	manual_failed_verification_h2_to_h1
+	lldp
+"
+
+NUM_NETIFS=2
+REQUIRE_MZ=no
+PREEMPTIBLE_PRIO=0
+source lib.sh
+
+traffic_test()
+{
+	local if=$1; shift
+	local src=$1; shift
+	local num_pkts=10000
+	local before=
+	local after=
+	local delta=
+
+	before=$(ethtool_std_stats_get $if "eth-mac" "FramesTransmittedOK" $src)
+
+	$MZ $if -q -c $num_pkts -p 64 -b bcast -t ip -R $PREEMPTIBLE_PRIO
+
+	after=$(ethtool_std_stats_get $if "eth-mac" "FramesTransmittedOK" $src)
+
+	delta=$((after - before))
+
+	# Allow an extra 1% tolerance for random packets sent by the stack
+	[ $delta -ge $num_pkts ] && [ $delta -le $((num_pkts + 100)) ]
+}
+
+manual_with_verification()
+{
+	local tx=$1; shift
+	local rx=$1; shift
+
+	RET=0
+
+	# It isn't completely clear from IEEE 802.3-2018 Figure 99-5: Transmit
+	# Processing state diagram whether the "send_r" variable (send response
+	# to verification frame) should be taken into consideration while the
+	# MAC Merge TX direction is disabled. That being said, at least the
+	# NXP ENETC does not, and requires tx-enabled on in order to respond to
+	# the link partner's verification frames.
+	ethtool --set-mm $rx tx-enabled on
+	ethtool --set-mm $tx verify-enabled on tx-enabled on
+
+	# Wait for verification to finish
+	sleep 1
+
+	ethtool --json --show-mm $tx | jq -r '.[]."verify-status"' | \
+		grep -q 'SUCCEEDED'
+	check_err "$?" "Verification did not succeed"
+
+	ethtool --json --show-mm $tx | jq -r '.[]."tx-active"' | grep -q 'true'
+	check_err "$?" "pMAC TX is not active"
+
+	traffic_test $tx "pmac"
+	check_err "$?" "Traffic did not get sent through $tx's pMAC"
+
+	ethtool --set-mm $tx verify-enabled off tx-enabled off
+	ethtool --set-mm $rx tx-enabled off
+
+	log_test "Manual configuration with verification: $tx to $rx"
+}
+
+manual_with_verification_h1_to_h2()
+{
+	manual_with_verification $h1 $h2
+}
+
+manual_with_verification_h2_to_h1()
+{
+	manual_with_verification $h2 $h1
+}
+
+manual_without_verification()
+{
+	local tx=$1; shift
+	local rx=$1; shift
+
+	RET=0
+
+	ethtool --set-mm $tx verify-enabled off tx-enabled on
+
+	ethtool --json --show-mm $tx | jq -r '.[]."verify-status"' | \
+		grep -q 'DISABLED'
+	check_err "$?" "Verification is not disabled"
+
+	ethtool --json --show-mm $tx | jq -r '.[]."tx-active"' | grep -q 'true'
+	check_err "$?" "pMAC TX is not active"
+
+	traffic_test $tx "pmac"
+	check_err "$?" "Traffic did not get sent through $tx's pMAC"
+
+	ethtool --set-mm $tx verify-enabled off tx-enabled off
+
+	log_test "Manual configuration without verification: $tx to $rx"
+}
+
+manual_without_verification_h1_to_h2()
+{
+	manual_without_verification $h1 $h2
+}
+
+manual_without_verification_h2_to_h1()
+{
+	manual_without_verification $h2 $h1
+}
+
+manual_failed_verification()
+{
+	local tx=$1; shift
+	local rx=$1; shift
+
+	RET=0
+
+	ethtool --set-mm $rx pmac-enabled off
+	ethtool --set-mm $tx verify-enabled on tx-enabled on
+
+	# Wait for verification to time out
+	sleep 1
+
+	ethtool --json --show-mm $tx | jq -r '.[]."verify-status"' | \
+		grep -q 'SUCCEEDED'
+	check_fail "$?" "Verification succeeded when it shouldn't have"
+
+	ethtool --json --show-mm $tx | jq -r '.[]."tx-active"' | grep -q 'true'
+	check_fail "$?" "pMAC TX is active when it shouldn't have"
+
+	traffic_test $tx "emac"
+	check_err "$?" "Traffic did not get sent through $tx's eMAC"
+
+	ethtool --set-mm $tx verify-enabled off tx-enabled off
+	ethtool --set-mm $rx pmac-enabled on
+
+	log_test "Manual configuration with failed verification: $tx to $rx"
+}
+
+manual_failed_verification_h1_to_h2()
+{
+	manual_failed_verification $h1 $h2
+}
+
+manual_failed_verification_h2_to_h1()
+{
+	manual_failed_verification $h2 $h1
+}
+
+lldp_change_add_frag_size()
+{
+	local add_frag_size=$1
+
+	lldptool -T -i $h1 -V addEthCaps addFragSize=$add_frag_size >/dev/null
+	# Wait for TLVs to be received
+	sleep 2
+	lldptool -i $h2 -t -n -V addEthCaps | \
+		grep -q "Additional fragment size: $add_frag_size"
+}
+
+lldp()
+{
+	RET=0
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
+	sleep 2
+
+	lldptool -i $h1 -t -n -V addEthCaps | \
+		grep -q "Preemption capability active"
+	check_err "$?" "$h1 pMAC TX is not active"
+
+	lldptool -i $h2 -t -n -V addEthCaps | \
+		grep -q "Preemption capability active"
+	check_err "$?" "$h2 pMAC TX is not active"
+
+	lldp_change_add_frag_size 3
+	check_err "$?" "addFragSize 3"
+
+	lldp_change_add_frag_size 2
+	check_err "$?" "addFragSize 2"
+
+	lldp_change_add_frag_size 1
+	check_err "$?" "addFragSize 1"
+
+	lldp_change_add_frag_size 0
+	check_err "$?" "addFragSize 0"
+
+	traffic_test $h1 "pmac"
+	check_err "$?" "Traffic did not get sent through $h1's pMAC"
+
+	traffic_test $h2 "pmac"
+	check_err "$?" "Traffic did not get sent through $h2's pMAC"
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
+	tc qdisc add dev $h1 root mqprio num_tc 4 map 0 1 2 3 \
+		queues 1@0 1@1 1@2 1@3 \
+		fp P E E E \
+		hw 1
+
+	ethtool --set-mm $h1 pmac-enabled on tx-enabled off verify-enabled off
+}
+
+h2_create()
+{
+	ip link set dev $h2 up
+
+	ethtool --set-mm $h2 pmac-enabled on tx-enabled off verify-enabled off
+
+	tc qdisc add dev $h2 root mqprio num_tc 4 map 0 1 2 3 \
+		queues 1@0 1@1 1@2 1@3 \
+		fp P E E E \
+		hw 1
+}
+
+h1_destroy()
+{
+	ethtool --set-mm $h1 pmac-enabled off tx-enabled off verify-enabled off
+
+	tc qdisc del dev $h1 root
+
+	ip link set dev $h1 down
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 root
+
+	ethtool --set-mm $h2 pmac-enabled off tx-enabled off verify-enabled off
+
+	ip link set dev $h2 down
+}
+
+setup_prepare()
+{
+	check_ethtool_mm_support
+	check_tc_fp_support
+	require_command lldptool
+	bail_on_lldpad "autoconfigure the MAC Merge layer" "configure it manually"
+
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
index 36e47c9d7cca..057c3d0ad620 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -120,6 +120,15 @@ check_tc_action_hw_stats_support()
 	fi
 }
 
+check_tc_fp_support()
+{
+	tc qdisc add dev lo mqprio help 2>&1 | grep -q "fp "
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; tc is missing frame preemption support"
+		exit $ksft_skip
+	fi
+}
+
 check_ethtool_lanes_support()
 {
 	ethtool --help 2>&1| grep lanes &> /dev/null
@@ -129,6 +138,15 @@ check_ethtool_lanes_support()
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

