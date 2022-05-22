Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC90C53022B
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 11:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbiEVJvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 05:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiEVJvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 05:51:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF785F97
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 02:50:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gX9MAGYhGHBnePDBfx/9HZLR3Ul1KWfij09HFf2BGud2I4jn6miDTHU10WUORtcdElKL+oP+9ba3wJ4MBXZOa/sWzmXhk2fjCB6H7cXclGFIOdAgWQFdwNmRYC9cTbwV2917ZRflbSnFuQDnqOdR/WxEjwhz2pYVc5Y1hEX7qZIikauhOFckyQ4I5kd7/eh/qe2ePY2QMpdvizrGmxJd3caYXdczToaW78d34pDMse/oM/O6YLGIPDL4qQEWEhR3YMIncSE5O7ek9f0ChMW2r1nsO3ArBDDwR4y2U1xC0XXHbu9MhEjR+eg5gO6Sr0TnTa0N7jmUc5/NIUPIbdYuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9Xe9isSENctN3inaZXB202/rF9QFaMH2RucExYuTzg=;
 b=RsHtItByZ/DaNS3Y9ggJUEUtxZroho+GAluJl7yzJdptSzUsNalhY1+11JmaJ4LnIW2ilLZNejOH2TNPbFlAVNaWR+dQQc7nN9uBIVWIFLvSI2RJYbSPpCXJ3iEWi9iwTYR/yeNxUJ6iK2X9AefwUdBubrKFQUbJDECQHz3D4X4Ng0byemZCul7xnsdP6XdpbhQqmqzU3byljLFLeGywYNaxgk7bTf+ynHBXeFk4Cm6h5OnRa09znfib1Qq0DpUOja3eLbacBJLgyb/KJ1b6tCnPLH2AF9Gmh3hMoPv8r7q5RcYIO0dac8rY+KbTxHz/dyzL0acmPsIVLPKYN2Yj2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9Xe9isSENctN3inaZXB202/rF9QFaMH2RucExYuTzg=;
 b=pdmHb8CY/BFFqpQcYsEb8rE3aBpEX3W73xepH82UFpQe75YX2+XkCjrp7Ev5KCgh6BlbruGsyJ62IkZD8Eo7riTVgj3GrhfKNaOR7nY/W+19Gdsuy18XLnBkm5CGh+XDZdvtOrXQTLTuhQH2sU0Kkh3lUCR0QHqb9dN3aCvVTOs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5306.eurprd04.prod.outlook.com (2603:10a6:10:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 09:50:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 09:50:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/3] selftests: ocelot: tc_flower_chains: use conventional interface names
Date:   Sun, 22 May 2022 12:50:39 +0300
Message-Id: <20220522095040.3002363-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
References: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5cb644e-1017-48c7-f049-08da3bd89026
X-MS-TrafficTypeDiagnostic: DB7PR04MB5306:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB53061D135E0AE8B3D1D79E88E0D59@DB7PR04MB5306.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbDtOM5Cgu+A2NYoW7UBh2zgaxm71fFsr5MZqrDoYcP7PjO+/pYK4lTo7llQW4ueVB1RQFLlIULD4VFY9z6NsnEZfpG49wXvLoX+f1j/B8qvWw/cdA6EW3ws02P/vRA/zJKFrneo6DCy3xHoa51sp/Bvr6oSiFIEM+1sRF03tAuPGf8t0Gf3jFeialb9thuDmOIcevYv5kjmGr42nkNRIAWKuc4IfmZr4PWtuKYsjfFUqWkWYYTGZhL/u94l4S5uT36OEgBi6DgDB70PZ6RWI4zZB2uPBxd7C2uSDyDiKA15jztwCazxwe6Tv5B2IMm19UEU4AIlQ6+D6f5r8FiF4r9BqsEAg4uyJdtKSLttiLM2LnnLLft3sqLlnBXGgfx2zC1zkvj5sLkdmJFLlOfL/lK6BsmtN0rz/VHWN0z3uhrFZNWfPzBSCrhG+b/lH0xSq+yqkslpw9A+IjMeCttUEb79ACYoMrJ6j3A4B9wJIkXsjxQ/0NiDeTbxeI9O5nslNrHfTpdqFX317FqT1ntTbVXjwaVw/h/WJzaCUkROLWUP7akGAT2N7P/5xx+qdTbs0To+vhGEXFIGQUQI4GBIghXaT6QF/Zyr8G32opXEX6AMQwV1wbPefVF4Kf+RoShr3Z9IXBo6s4XpRhMsyPjHDMyILXINXNjpEr8+RFrVyapApC4XWKhBz1gaXN5MGEcl7o4GJBHKfThp8a8gcg6VViSfePjB0HLQGxPnJcx0uBeRICf8whu//EU3sn83sEJ+jw5JMZpr6ek0sasFOFeGVHyk2uo8edCHesVECxef/hk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(4326008)(66946007)(38350700002)(66476007)(66556008)(83380400001)(36756003)(52116002)(316002)(6916009)(54906003)(6666004)(186003)(6512007)(2616005)(6506007)(26005)(1076003)(8676002)(86362001)(508600001)(2906002)(6486002)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JHE8D7rLHE5lq7hqhYg+PUbgz0nNCx6euDpIciKqOl0auq/HIOqT0riuUpl7?=
 =?us-ascii?Q?Uo42tspE+r9Kq26Hydh9N4EW5qmNQBHx9fdTVAkkx+ZbSQI/T+m3ycqTtSmy?=
 =?us-ascii?Q?48g1UqDVtE2WXA60rrklW60HLggnJfKlt83OBlh4oLM80VvrjFjKwPOswyhe?=
 =?us-ascii?Q?k+sgDu5TbEfdZLNWkvjFq/hPFF44ojRFXdB2Xfvhknn8wcYnVqSPNSj2gJPb?=
 =?us-ascii?Q?qTb8ZDxMw1wGEHWcQKi8egiZRhXYW6dcfoM4qzdFCYbSz//3Li/uXwgTGFDk?=
 =?us-ascii?Q?vrjKIsdtDMCg0Xpiok3c6yY/udAa0tLSwWo8gl5FoH0N64/DTcjCpZFjBRnz?=
 =?us-ascii?Q?/2hrWFnToAtzj+2E0XN9ZQjQfBbL3SUUlituQD+6MYAbPmGat2pGamZWeSte?=
 =?us-ascii?Q?lRGXSmimtGy5Bv2q6/L/y8UihXmcLxwTuiMVzKoksweiZ5koIOfSn1veGT2C?=
 =?us-ascii?Q?5d2bpkcdxV2xVJa8B7A2JUxsqv+hat4jMsjgW81hATzeYc3LWQiebCWz/NCR?=
 =?us-ascii?Q?FpHKfrAQ1RHKWzn64/IwoyGvoA8z2ekmjDFp4WwIjbxpLy1WnT1xKT/KEiun?=
 =?us-ascii?Q?CiXcJmJ8wLofhbIQp4RBzZBxGZMdEZscJKrGvQN3WIWtG7I2qEVu5+jefpGP?=
 =?us-ascii?Q?TRdjN2Gf29FTgpwcq1hBz0BamjB8Lx38R8XiqzE9nBpfTO3vDRDDtqhDDM8F?=
 =?us-ascii?Q?HTHUrNegd6QlhmWnTs1+rzAC+P+JLTQv+4+LqLI6N4AVYhHe3Obp+QtDcBdK?=
 =?us-ascii?Q?RzjcP9s8DFEDByQ5M2z0nfIgOG9vK9FQpUXNgaTP8b0JzLd+/0TbyDW4X7VB?=
 =?us-ascii?Q?+Qy7ugsfwEw+bk3eYz4N1gaWatCVMArgJjen1ZLVuUMqORGMAMkVnXoVSZxI?=
 =?us-ascii?Q?y+U/5MIDEZB3ooJyjynIh7kOpspCw5E72vCcW17pNg+oHyC0ohHZXNbSzHbm?=
 =?us-ascii?Q?G6SMEKfOtcrOGkusPVnURzY14OuDArIJpdi6jXK84XuKwGz75Mla+3+ov/Pz?=
 =?us-ascii?Q?MP09cd4wv5J7ZLu10Bbq51Klnd1tp9A9OzjS437VLxK4UlaKASoPOyCRgDMu?=
 =?us-ascii?Q?1TNCxSMW00m0gCWlOiM/q3lkfsoih0bsMmq8bb/0O7EP5LVmpXeEuZpbnJb0?=
 =?us-ascii?Q?FMu9JstTmjxV7H7Olw0F1c7021MRuc0zPoMad3FUi5NB+ZTwiDbQt4O6jD5t?=
 =?us-ascii?Q?bHI3z3kuoX3SfRKHvEv0D0Pw8E5DrBRynyVWM0VxC31HQdK6TWG7HvtoWsxd?=
 =?us-ascii?Q?ujO8i63yusDZH5dH1JSE0RP5wNKSNzMeut4HPnenkz6zUrdjj6pHP/4ARyDr?=
 =?us-ascii?Q?XFEZH4GvlPNa4zyvcusfsVLPQW2/Vgh5AK1wy02UGTJ5O65X7v4JTxSTuHKu?=
 =?us-ascii?Q?3RxxhxNv2uNqe5QfuWQU5yV3SFANbb1JHbjZHSlAJtSByIZL731dlCbGtE+l?=
 =?us-ascii?Q?sIemtflP92bZ09IjK7FSJJQ53zZYZR/GC0+eGMmaIYUD4zLV7I8DHO3Qtyix?=
 =?us-ascii?Q?IAW12X4wMXo0+GpQGcs+CTlDc0iu2bR0opwPkQiGnhgpqdtbEOpWsvJo/fy5?=
 =?us-ascii?Q?btY5GKQDL5WHDIn3nIueMLX84GHTLKtyg6S2WXB26wn8JIx4ItOcxK6P6Yv7?=
 =?us-ascii?Q?lJPlNQ+5YHsnluKx7Qo+PZYL+4ATjPjG9jNX+iNlhd/2i4hC8+us8UFOvygo?=
 =?us-ascii?Q?lAUQricuHgmH7+1NU161aCmLRmIQGLAacSc6KbuiHZvD1rLBV4rYaQMdX4Up?=
 =?us-ascii?Q?iCQSQ8cON1AFdnPapYkZfLIgTte5rMk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5cb644e-1017-48c7-f049-08da3bd89026
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:50:54.5823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDbBqDLUL9uJNJ53vnzMiiVmxlPjYU7dIGpNPidRndxb4FhubQjPGUd685XvUjY5ewMEEAgbE85O70uYYDXTZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5306
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a robotic rename as follows:

eth0 -> swp1
eth1 -> swp2
eth2 -> h2
eth3 -> h1

This brings the selftest more in line with the other forwarding
selftests, where h1 is connected to swp1, and h2 to swp2.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 134 +++++++++---------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index a27f24a6aa07..ecaeae7197b8 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -15,7 +15,7 @@ require_command tcpdump
 #   |       DUT ports         Generator ports     |
 #   | +--------+ +--------+ +--------+ +--------+ |
 #   | |        | |        | |        | |        | |
-#   | |  eth0  | |  eth1  | |  eth2  | |  eth3  | |
+#   | |  swp1  | |  swp2  | |   h2   | |    h1  | |
 #   | |        | |        | |        | |        | |
 #   +-+--------+-+--------+-+--------+-+--------+-+
 #          |         |           |          |
@@ -24,15 +24,15 @@ require_command tcpdump
 #          |                                |
 #          +--------------------------------+
 
-eth0=${NETIFS[p1]}
-eth1=${NETIFS[p2]}
-eth2=${NETIFS[p3]}
-eth3=${NETIFS[p4]}
+swp1=${NETIFS[p1]}
+swp2=${NETIFS[p2]}
+h2=${NETIFS[p3]}
+h1=${NETIFS[p4]}
 
-eth0_mac="de:ad:be:ef:00:00"
-eth1_mac="de:ad:be:ef:00:01"
-eth2_mac="de:ad:be:ef:00:02"
-eth3_mac="de:ad:be:ef:00:03"
+swp1_mac="de:ad:be:ef:00:00"
+swp2_mac="de:ad:be:ef:00:01"
+h2_mac="de:ad:be:ef:00:02"
+h1_mac="de:ad:be:ef:00:03"
 
 # Helpers to map a VCAP IS1 and VCAP IS2 lookup and policy to a chain number
 # used by the kernel driver. The numbers are:
@@ -156,39 +156,39 @@ create_tcam_skeleton()
 
 setup_prepare()
 {
-	ip link set $eth0 up
-	ip link set $eth1 up
-	ip link set $eth2 up
-	ip link set $eth3 up
+	ip link set $swp1 up
+	ip link set $swp2 up
+	ip link set $h2 up
+	ip link set $h1 up
 
-	create_tcam_skeleton $eth0
+	create_tcam_skeleton $swp1
 
 	ip link add br0 type bridge
-	ip link set $eth0 master br0
-	ip link set $eth1 master br0
+	ip link set $swp1 master br0
+	ip link set $swp2 master br0
 	ip link set br0 up
 
-	ip link add link $eth3 name $eth3.100 type vlan id 100
-	ip link set $eth3.100 up
+	ip link add link $h1 name $h1.100 type vlan id 100
+	ip link set $h1.100 up
 
-	ip link add link $eth3 name $eth3.200 type vlan id 200
-	ip link set $eth3.200 up
+	ip link add link $h1 name $h1.200 type vlan id 200
+	ip link set $h1.200 up
 
-	tc filter add dev $eth0 ingress chain $(IS1 1) pref 1 \
+	tc filter add dev $swp1 ingress chain $(IS1 1) pref 1 \
 		protocol 802.1Q flower skip_sw vlan_id 100 \
 		action vlan pop \
 		action goto chain $(IS1 2)
 
-	tc filter add dev $eth0 egress chain $(ES0) pref 1 \
-		flower skip_sw indev $eth1 \
+	tc filter add dev $swp1 egress chain $(ES0) pref 1 \
+		flower skip_sw indev $swp2 \
 		action vlan push protocol 802.1Q id 100
 
-	tc filter add dev $eth0 ingress chain $(IS1 0) pref 2 \
+	tc filter add dev $swp1 ingress chain $(IS1 0) pref 2 \
 		protocol ipv4 flower skip_sw src_ip 10.1.1.2 \
 		action skbedit priority 7 \
 		action goto chain $(IS1 1)
 
-	tc filter add dev $eth0 ingress chain $(IS2 0 0) pref 1 \
+	tc filter add dev $swp1 ingress chain $(IS2 0 0) pref 1 \
 		protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
 		action police rate 50mbit burst 64k conform-exceed drop/pipe \
 		action goto chain $(IS2 1 0)
@@ -196,9 +196,9 @@ setup_prepare()
 
 cleanup()
 {
-	ip link del $eth3.200
-	ip link del $eth3.100
-	tc qdisc del dev $eth0 clsact
+	ip link del $h1.200
+	ip link del $h1.100
+	tc qdisc del dev $swp1 clsact
 	ip link del br0
 }
 
@@ -206,21 +206,21 @@ test_vlan_pop()
 {
 	RET=0
 
-	tcpdump_start $eth2
+	tcpdump_start $h2
 
 	# Work around Mausezahn VLAN builder bug
 	# (https://github.com/netsniff-ng/netsniff-ng/issues/225) by using
 	# an 8021q upper
-	$MZ $eth3.100 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h1.100 -q -c 1 -p 64 -a $h1_mac -b $h2_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h2
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"
+	tcpdump_show $h2 | grep -q "$h1_mac > $h2_mac, ethertype IPv4"
 	check_err "$?" "untagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h2
 
 	log_test "VLAN pop"
 }
@@ -229,18 +229,18 @@ test_vlan_push()
 {
 	RET=0
 
-	tcpdump_start $eth3.100
+	tcpdump_start $h1.100
 
-	$MZ $eth2 -q -c 1 -p 64 -a $eth2_mac -b $eth3_mac -t ip
+	$MZ $h2 -q -c 1 -p 64 -a $h2_mac -b $h1_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth3.100
+	tcpdump_stop $h1.100
 
-	tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"
+	tcpdump_show $h1.100 | grep -q "$h2_mac > $h1_mac"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth3.100
+	tcpdump_cleanup $h1.100
 
 	log_test "VLAN push"
 }
@@ -250,33 +250,33 @@ test_vlan_ingress_modify()
 	RET=0
 
 	ip link set br0 type bridge vlan_filtering 1
-	bridge vlan add dev $eth0 vid 200
-	bridge vlan add dev $eth0 vid 300
-	bridge vlan add dev $eth1 vid 300
+	bridge vlan add dev $swp1 vid 200
+	bridge vlan add dev $swp1 vid 300
+	bridge vlan add dev $swp2 vid 300
 
-	tc filter add dev $eth0 ingress chain $(IS1 2) pref 3 \
+	tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
 		protocol 802.1Q flower skip_sw vlan_id 200 \
 		action vlan modify id 300 \
 		action goto chain $(IS2 0 0)
 
-	tcpdump_start $eth2
+	tcpdump_start $h2
 
-	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h1.200 -q -c 1 -p 64 -a $h1_mac -b $h2_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h2
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	tcpdump_show $h2 | grep -q "$h1_mac > $h2_mac, .* vlan 300"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h2
 
-	tc filter del dev $eth0 ingress chain $(IS1 2) pref 3
+	tc filter del dev $swp1 ingress chain $(IS1 2) pref 3
 
-	bridge vlan del dev $eth0 vid 200
-	bridge vlan del dev $eth0 vid 300
-	bridge vlan del dev $eth1 vid 300
+	bridge vlan del dev $swp1 vid 200
+	bridge vlan del dev $swp1 vid 300
+	bridge vlan del dev $swp2 vid 300
 	ip link set br0 type bridge vlan_filtering 0
 
 	log_test "Ingress VLAN modification"
@@ -286,34 +286,34 @@ test_vlan_egress_modify()
 {
 	RET=0
 
-	tc qdisc add dev $eth1 clsact
+	tc qdisc add dev $swp2 clsact
 
 	ip link set br0 type bridge vlan_filtering 1
-	bridge vlan add dev $eth0 vid 200
-	bridge vlan add dev $eth1 vid 200
+	bridge vlan add dev $swp1 vid 200
+	bridge vlan add dev $swp2 vid 200
 
-	tc filter add dev $eth1 egress chain $(ES0) pref 3 \
+	tc filter add dev $swp2 egress chain $(ES0) pref 3 \
 		protocol 802.1Q flower skip_sw vlan_id 200 vlan_prio 0 \
 		action vlan modify id 300 priority 7
 
-	tcpdump_start $eth2
+	tcpdump_start $h2
 
-	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h1.200 -q -c 1 -p 64 -a $h1_mac -b $h2_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h2
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	tcpdump_show $h2 | grep -q "$h1_mac > $h2_mac, .* vlan 300"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h2
 
-	tc filter del dev $eth1 egress chain $(ES0) pref 3
-	tc qdisc del dev $eth1 clsact
+	tc filter del dev $swp2 egress chain $(ES0) pref 3
+	tc qdisc del dev $swp2 clsact
 
-	bridge vlan del dev $eth0 vid 200
-	bridge vlan del dev $eth1 vid 200
+	bridge vlan del dev $swp1 vid 200
+	bridge vlan del dev $swp2 vid 200
 	ip link set br0 type bridge vlan_filtering 0
 
 	log_test "Egress VLAN modification"
@@ -323,11 +323,11 @@ test_skbedit_priority()
 {
 	local num_pkts=100
 
-	before=$(ethtool_stats_get $eth0 'rx_green_prio_7')
+	before=$(ethtool_stats_get $swp1 'rx_green_prio_7')
 
-	$MZ $eth3 -q -c $num_pkts -p 64 -a $eth3_mac -b $eth2_mac -t ip -A 10.1.1.2
+	$MZ $h1 -q -c $num_pkts -p 64 -a $h1_mac -b $h2_mac -t ip -A 10.1.1.2
 
-	after=$(ethtool_stats_get $eth0 'rx_green_prio_7')
+	after=$(ethtool_stats_get $swp1 'rx_green_prio_7')
 
 	if [ $((after - before)) = $num_pkts ]; then
 		RET=0
-- 
2.25.1

