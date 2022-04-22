Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3511750B4CC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446482AbiDVKSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446461AbiDVKSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:21 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F7D30575
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBgr6druz9dEsgyVCpKGRGDuYhCYmzIsgV/6csBGACw3m8fgfPfGKxjjnbLfJCSK0RkmI5bnXhMUt9WaArzdPzeJWgOk90YQbqQyu7dhXGZMcun3wIHocrThXFZwlt3+b/CN1OAa9xBuvXyfYNfXVdkCtd4Q2T1DOa+pgsy4DLlTOarVPSF1UA0VMIp4cr+z5DV7uPIiv8OjSpG8TfKXQFQgT61qbBPW8faHJhM3mgdK9HOQocEQSUV54DANTiiDg/zVlNtJIXvfuqK52MZUoy0iVfl73d9YB0u4/CACHYRwgkj9Yk9CglxxWOeqLelPSYER59Fh4s0JQ5auKAeFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ib98eBa/kXSZ+4wGAadKiwRY68HlBLMEEtTt1hg51Tc=;
 b=GZUzqOq7ZIfjvqOy3h8Dy4CiUH3y2oo9Uqg/UHCcWUnnjuTSmztqp297rVqyAykRTPGbkJw5oqn+myIQSOuoEUPG/KSdGC2mQTZI7ICyASlytFgD4V6SYkwJfFBg5j8S1EIAzbQVE4ENWvhOIwXQOjPaFcXFj+ie7JoGINQCK0jS2QsxSaFQwd7C3+g3xYGWAndyc+aaQCzjucRm1k3eFsYGK59sOrE7ReOkmjYMuW65BPcFnbGdoPXeXC2cmYBeNdNe8LZEsCcgbZDq9vvRT9KzXpdeCOS6lW5UwnXBz9afCrz+uvAvRumTZ+eiCLNAuM5l1GGxkmevV/D1aN2cgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ib98eBa/kXSZ+4wGAadKiwRY68HlBLMEEtTt1hg51Tc=;
 b=BToNIG/bGo122rpMH+618SUpo3LUGsQ66IoqirJo4X9qwvNGdokQWnQUzRp9MnBMrgLCLP5wkhdmlQLhJPN6ArX26Ef/LMjDEUx84cKiuLczaSPjrDA1AJFVHHB6V8XUi81OmE7NQuPnD5p2iyPXFjhz6QDx/Q66hPvRnXxA7Uk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 4/8] selftests: forwarding: add helpers for IP multicast group joins/leaves
Date:   Fri, 22 Apr 2022 13:15:00 +0300
Message-Id: <20220422101504.3729309-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
References: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3317623d-f82c-4639-6b0d-08da24490308
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB68366CF388BBFA909795F1BBE0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iswJwbObb9SHneMEkrYh49F+2SOXSpz5Y9FH9g8ZhX3KIVWTIw9bQRpcjusjPaNZ+AimwRkczqfKxibw9eHQIzFOPTTw3jzfE0j37aI9XQM36JCTiXNGOZlJApJXt7pu/MYE6omsKEJ/j//dkdMhvsNUAqAPnfNCgVboYjgXTqEhVadnEIcRjDrRBUYh90BOZxjIT1p/+lb1yJQJGaewXePP7UNIBK0CfH6m9GLcDLEWVpECyEIt1S+JPf3FtVHaoR+QQ/CKbQYKzZhCCF63dHBazTl28Wl1mYYr4mvb0h4aEV3PLn2YpCUB2vMZupyFo93SmbVzoBZfY18oU/bqQkc8rHncNFsLgsF766IJlPH0DObSHlhbeJoD6bgdcelrsJg+d0VeAWNdiSqm0uzPPkuiRa7Mqc5fWRUNIOaQeNlPMpDNbcDEsFJ0cIqsqcTnheLGlFbEAjkmHLOlVTMBwdn1spCfyDUQIH0wV5vW/v3qVAi5QixFjslieCTmJG8PDDQhRpwp5usJgiCTDepq0Oy869fvFQDNyY+PanarMKQ2TH0QWMUVOXNnGwt6r6iO3M6yTwdfbZUwd4Tt5mZjG5NSdXzZcGRVT9ANCvvxNjaiZP4MeZ+MExH5wpu6YKnM2/zaFyUhMeJeGS+AHhSqIAeWCgsu/Gb+3KuTDQdPqUiGXdcDEF/DhqexvNZJyrRAebPDPLSbgSx8xef2iO7++dGdVii1VDL/4Z9U9vcdDSPlbkKoTLEaRWyN02Zdi2NwmMWcl3/5tslIhgeOL2D4+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(2616005)(52116002)(44832011)(966005)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EOjq6okWYhol0EWL18oNB+g8lsBM8Tsrm5a2bI5k9D3udo9qQ8vWWA6ELPrI?=
 =?us-ascii?Q?myoeh/CGSRQbUP45baF814tWLUGUc/Cq7MJM80oNqQeNyoieT0ZsQffhIhxU?=
 =?us-ascii?Q?kOI9BEb1Zz20OvQrV/73+rGPI1yDT/xFZWCUtyuO1Oy1dXyOYvS6AEkmdwlk?=
 =?us-ascii?Q?wOECOqvgzG7tU4A1OTTleus7mgFXiqMGKgFMY/hdrfr+kdDmEBkioeLFVIw1?=
 =?us-ascii?Q?4guZnWbT6/mgK2DbqoSy7TVja4Pnx+K0rnVukLd7uTZ8fxx3ukBTbHwXwnQf?=
 =?us-ascii?Q?Gcxv+Mu2oFnKQ31RCIc52dF7hQJ72OW0cmzSF5sgYK88jIYLWwnzUDdTz9ef?=
 =?us-ascii?Q?S3ePxkV81mHn++6boznrrElJ+tt5t1ZSxD5R4e3km3AN1xORCp95MTIC/sDx?=
 =?us-ascii?Q?X1zf0qH0GEeBDZ1yA/LZxrIWYr8BV7wLBiIwaPCTJjKvTyI2GmHp8HYPwomM?=
 =?us-ascii?Q?Tk2B49PLQ/HELH5GHSkn3zAXhkDvsh2bf1IhU+3y/vDGzRtWrakqSQuSwRq+?=
 =?us-ascii?Q?wYHBAvnD3JvCCXrVucDQC+cj1Wod8bLfMnZubVFcbXvj3bgcsRCx3O9UDPVp?=
 =?us-ascii?Q?q8FF4pAnVs0jkGYJD8uBispMSyg7H2EVEEgKaUNMlmyyslTYkbzwN9eMxf9l?=
 =?us-ascii?Q?Hw6PlRTzEQxL5EDxo5ogGuZ8xIvGVE4YQqAX5c4kgVZ37hI3Us7ojXdv/qvC?=
 =?us-ascii?Q?/QnhfmctpqK/vatVI02RBcrFILfQakPnUxD3Jr82YJcNP2svHPMtOEWSxToi?=
 =?us-ascii?Q?N4A1RRW+CghUQHMkKtdXygprmhJyIyJ+N5cEPuecMhKc88GAIiM6cdDvoP9p?=
 =?us-ascii?Q?dgJGKe2OTxfI8T/xt/p7WDBv2hmJGJxbbFRsyImhtzqTFEbNj6zwnPF1sCwW?=
 =?us-ascii?Q?+SdbDd9GYWDcjLnzXKfUAEJcxmM4mbr/JmljrNog9cAMC4ceeMTaJ44Lm1M+?=
 =?us-ascii?Q?rVppBTl8p9Bo0wkB2yatH5xAc7V2gNXbnUSe5ZhX/oeTiaqDLHql6huZmaLj?=
 =?us-ascii?Q?jNXdLm9d5ZhpQgBqCnqr7eftoRw47jntaP3kqRaHaAuZOqRxIFbzEQmew0AC?=
 =?us-ascii?Q?V8v2yPt50QStt00iKhqMpHk7lecGFsUHpQnrx8FIkcRNrUG5ygtGBr6ZwhvF?=
 =?us-ascii?Q?8GJm46yNVe0rsi9gVSlk0yU6J8+JWXkG4C+QEiwf+pMse4aixtt9hBp9fXQO?=
 =?us-ascii?Q?FQS2UImWsusAuI1hp1tghMHHK3VSgqXu+cigm+sWMyz5rroCPZmustdcxlPB?=
 =?us-ascii?Q?GVvnkWb8rC6BYvBqONPEH9rjqjHf7y4wU5CX/Gc9T7Wh7xW5K2Teo7ZfvEy6?=
 =?us-ascii?Q?/dC4k0/hS0ussskXy2LnnsrtBu2TrcJBoVjvp+4Y+OYcwmwS2T4JHp+0lnKh?=
 =?us-ascii?Q?J7AFz5Fh0zS/z14+A8Q+Qup09mfGJzQF35IRrXIhuxGohnz/yU9eBOwYkUHs?=
 =?us-ascii?Q?aFqJmQq8zz8AmSgi5TK0u9mJwd6QgKNLQ3v3ja1bwii2O5QSsZxntq1epeSL?=
 =?us-ascii?Q?5yoNktw8FZajvyTH8GhkQumJzVmFsPJxG4zc/fyzMixFTaQ0E+6rFs6+PO35?=
 =?us-ascii?Q?8pAJLcdfqZE7TcJpQQDr4QXYbGFHtYwk6TV+HoA6Cll4XQIXbMn1G68v/Jji?=
 =?us-ascii?Q?1bU7ZWGjWoVW4O17OLYXzZmnr7ZQaewY2yhvArjGZctsD+1TeSpQbEULbwvJ?=
 =?us-ascii?Q?vDN4d3/FA9BUuRj26363qY3shkWc9ldhYJeachfQql6LNmJV9BMn/shXI32G?=
 =?us-ascii?Q?a/ARM2QuGRflOsdxmVcM/oLtzK/Wmm0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3317623d-f82c-4639-6b0d-08da24490308
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:23.0317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtsG+khEuPL98fd6YAd02Vi6AiqQpIzWZXaseWVIf5RkdbS3aj83QPjxifQyi1e0FRvmhS1FTJJUEW0JiuqthQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the forwarding library with calls to some small C programs which
join an IP multicast group and send some packets to it. Both IPv4 and
IPv6 groups are supported. Use cases range from testing IGMP/MLD
snooping, to RX filtering, to multicast routing.

Testing multicast traffic using msend/mreceive is intended to be done
using tcpdump.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 7eff5ecf7565..15fb46b39fe8 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -27,6 +27,7 @@ INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
 LOW_AGEING_TIME=${LOW_AGEING_TIME:=1000}
 REQUIRE_JQ=${REQUIRE_JQ:=yes}
 REQUIRE_MZ=${REQUIRE_MZ:=yes}
+REQUIRE_MTOOLS=${REQUIRE_MTOOLS:=no}
 STABLE_MAC_ADDRS=${STABLE_MAC_ADDRS:=no}
 TCPDUMP_EXTRA_FLAGS=${TCPDUMP_EXTRA_FLAGS:=}
 
@@ -161,6 +162,12 @@ fi
 if [[ "$REQUIRE_MZ" = "yes" ]]; then
 	require_command $MZ
 fi
+if [[ "$REQUIRE_MTOOLS" = "yes" ]]; then
+	# https://github.com/vladimiroltean/mtools/
+	# patched for IPv6 support
+	require_command msend
+	require_command mreceive
+fi
 
 if [[ ! -v NUM_NETIFS ]]; then
 	echo "SKIP: importer does not define \"NUM_NETIFS\""
@@ -1548,6 +1555,37 @@ brmcast_check_sg_state()
 	done
 }
 
+mc_join()
+{
+	local if_name=$1
+	local group=$2
+	local vrf_name=$(master_name_get $if_name)
+
+	# We don't care about actual reception, just about joining the
+	# IP multicast group and adding the L2 address to the device's
+	# MAC filtering table
+	ip vrf exec $vrf_name \
+		mreceive -g $group -I $if_name > /dev/null 2>&1 &
+	mreceive_pid=$!
+
+	sleep 1
+}
+
+mc_leave()
+{
+	kill "$mreceive_pid" && wait "$mreceive_pid"
+}
+
+mc_send()
+{
+	local if_name=$1
+	local groups=$2
+	local vrf_name=$(master_name_get $if_name)
+
+	ip vrf exec $vrf_name \
+		msend -g $groups -I $if_name -c 1 > /dev/null 2>&1
+}
+
 start_ip_monitor()
 {
 	local mtype=$1; shift
-- 
2.25.1

