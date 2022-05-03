Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04B518485
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiECMr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbiECMrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:47:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2758E1F630
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:43:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zp/gsGVwQqdEAOkPEIJyNhukTDMnlvjEqEUKdtq3el9IxsY2cvaGsD57XgkWhVQ3UdnZqmCEHFMNg26Hr0sQs95JFuUgxMvJyIGgsxCc+r65mbuHFci4zAi0dy3ietP9OPIQcnVdgiK8vqWKh8tQ6m81Txc+6TisiXC9n7XNUt1tERzmIoa9r2W/O9CE//FDxwrQAnsWvea+m025nXQ5SmY6BW6ix/1jN2wSrrqVXeOHZ0WpfmKrGWRAPr7XovXZJ44Q/Hgxo1+FszHTxxh3EjHah+pJtVXBIgLLd9NtssdO8A79TdQFU15rc1y3E8DtRVt7+CPnNaeCGwvZqDQEng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8pIWOhYAhpdQ/Ookp5T7dL2jlwYRaZmQNEwHOgXK2E=;
 b=nazRb3cSBmgiTbMrLkJv3oLIyowso7Df4H3LieRUEQO+SJKxi2000lW7T5k0S9gwL5hp/jvsOS+CJWKXvFBB/cNbd8/fcfB4Vf1RpidC6GLdCPlNlPeAjZbLW57/yeXY032DIb5xCmroyPHp2/BpkUMyAESK1baTtQgFRTAOcjHd+LCorC7mse6DFJkIDJ1J/vEEb+Ru/PjYmFHMe6i19HwttaLPy+8fIKWa4hNwZxOeC8mIjQjZYBuxnLtVXsULA56W+3r5bGrmCDo/ZPfo6sAsSrHI198j0UrDvzBCMuiV/dTjDgk2HHLMHEfAvOP7Ks/6SE5F8Tmw9NgWR/vx0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8pIWOhYAhpdQ/Ookp5T7dL2jlwYRaZmQNEwHOgXK2E=;
 b=bTi0waYOSPIQ8YaaNKMz2q8PfZ8Xg0YaAXVbFyLsJb+e1EjdyOP6IMiqTKoGyPHNqKxKw/MqdrI8/1PQrFIVWiFv49d3vV3BoRdn0WTirx00ZZYzgV4hqHVfQrh3ZcrnDauOsahMQRuJkng70hrw2ir7dRKTgLNGUYU/V+RDr3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 12:43:48 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:43:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 2/3] selftests: ocelot: tc_flower_chains: use conventional interface names
Date:   Tue,  3 May 2022 15:43:31 +0300
Message-Id: <20220503124332.857499-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503124332.857499-1-vladimir.oltean@nxp.com>
References: <20220503124332.857499-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::49) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fafcacda-782a-451f-6bc6-08da2d02917d
X-MS-TrafficTypeDiagnostic: DBBPR04MB7675:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7675364A10F0F7936B647EF1E0C09@DBBPR04MB7675.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BGNVPGfL8WWzK+lbZYZk8C+znX83PfaBQZQzFfsdUWTJK92TlHwdxQMr5OdZ1Z7wn1lZsFsCn+CCKSEF8hD98gL7CzkcNCCdlf9xEayyjE53+bVqF0kbmnLb1zZ+JcN4E1kxfL4Q09R6wo9QIlRNG/YJwy1Bp4ikA6p4f7K5IafvtjdVcAAtSYWPFmSpUGUP2gkcClv/gE5uu5zVLDgQ184dYFLPly+PlcbgyyoS7QFv0O3KuWtDP0WaF58URKILls9zsXelhLnCuBLcZx/IVoQkZ9q4fTMJ0OvNTstxOr/3WC6nTmgerJvgDgJB62nJAWaZjh0o9TZO3BBdLpfnRHvQIYSt+wS+CszREySdtlL+maJG8bkrb4ZbUvlw41z91zdvbGE0gYFP7otTe2GPwPIfQrFFYzOaQTFwOWbmsEF98DcPmSc2+kWQrn40oCQfBK/OjVxYsMf5nzqV4ey+lLOW2lf2zWYtfNwuqgGsVbFYdPBdXyGa6YpmCI2xUSXwXOeisAfvzKD3l6qLhPgjKwwKtQR+fFPCdO8eWPPQGFkz/A0wwfhtWFN2KUA4DNi8mCs/FOVczyQu6mENoyur3D+RnbdOpw/6kQDPFbC8KJ+dpHiP8ylwIedIBvRZ4HJy3EThmGrKFOCtuZ4/prGfXMHD03GURUYLJBsaJ+fo52WifuMR2955iBoMTy3p8XgylYpGAjg4NQGAgfHzGr3L5fBEmTUsSwf4yCU85xJmkU2L+GLAIvq3AvXUI5CrzRH3pQ8Cazud1Y9Ny0bruksGspbQRcHvrZw2NyapnpLGG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(52116002)(83380400001)(6506007)(5660300002)(26005)(6512007)(316002)(86362001)(7416002)(186003)(44832011)(2616005)(36756003)(8936002)(1076003)(4326008)(6666004)(8676002)(6916009)(54906003)(66556008)(66476007)(2906002)(508600001)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Y5guWMJx1N/ZU6iMof94p1uQn1s/jJZ2zJt+kGDshs/HvsEBCEz7VLZZyc4?=
 =?us-ascii?Q?3x8t75X+OkAh9QjZT+XlvkWeyH7hr7VntH3g1hlRmElwIlCjOtfZubwwINZw?=
 =?us-ascii?Q?NAEok8HR/Y6yLr0oKpO1oyDw7WFiT+yw2bvd9cr8ZeB568bWfwgKrSO9jDLt?=
 =?us-ascii?Q?zjFoySnk128dB/MpO3mlqs4vKYkO+mpA5Oh6odV7w68tpRfvm2Ma6zY189aO?=
 =?us-ascii?Q?QUJ28lAijccvmCPRwp+3joWAvxh99CJBwMDQuo15rwysoO/G+CTysd1RwZtP?=
 =?us-ascii?Q?XoMlXr2B+IYapVHXtym2vICblYhHyVj788KA1ik0sh+t0CWYPFMfIf0ngqQv?=
 =?us-ascii?Q?405GG5Q2EGVebHKr6u4exfyGIFhfck6/oZkBKRIVBfMW3CwYqTbuzDs6N6Ip?=
 =?us-ascii?Q?k59qhFbm8gqO1mi0g4iVTTAcHmQEQ0vLRcd5mtatxO6JOtY0CIoZt5c0x0Q+?=
 =?us-ascii?Q?dImSFWS08RzlkTuhCD5y/WQZVIZoPvnlkpTLYMvz3rjDbWuppNAQ4CcrCDQe?=
 =?us-ascii?Q?n9b36uV12VjeY4kXNyrMlomx8XOczdiBIvVLv5tRDI67fMRwLRvEpTY/29+b?=
 =?us-ascii?Q?W78XwlIqbvAhZEpoUn+PSRaEVVISEYzSkDZP3Dwm1ZsamFmxlv6J5QkQFE/y?=
 =?us-ascii?Q?DBDwyAewsAvX1WrbObeCL+j04rRoBzkikTIJiExA8LFUE02lrOJLvumPojTg?=
 =?us-ascii?Q?Ke53NR++DA+Q5I70TiOlrL7vhcSepO5wbcLSiSnkmzKvLXiyjD50IIoaHnU5?=
 =?us-ascii?Q?f4tDZ5Fafjq1q/9cP5Rlv/GBRYRR8sq1oiwrnkfKWCxcloBDmYvjq/zH5mKR?=
 =?us-ascii?Q?vaJ1NWrGW6mxb4qC6icO8aKN5wgH2JlncRleLOjlSSBqfxNN9j6BObruTqwl?=
 =?us-ascii?Q?79/0CuF8MfP79rIUc+e9v+tZjs4GfOlIP/yf8RtkroQfHw8IxIeEKHGex/ty?=
 =?us-ascii?Q?PoWiv6iulJ1a7m01WJNF8Aprw83ZbjVIzKb4Pm0c6ilm48s++E3qfPo5c02J?=
 =?us-ascii?Q?q7PK1VM3Do0oBaQX6wBdmszTXuRh4uD/fuVGjWXONcRH4qveJ+46JXJvpSzq?=
 =?us-ascii?Q?pfJG/oUdSebNDnGHY4tXrFvvKGpEq7wsgjv2Q518pbk3fDPQ7pnRNaUEswXa?=
 =?us-ascii?Q?8kYPXmVaLl5CYVoKEpIRxHRpAWJpxwMEPEKQq8Moa5WLmpcAtiI0D3R5VyAX?=
 =?us-ascii?Q?Cd7e024ZWgTwyOLdI3ma3OjcPFvhLqncpBq2WphUuQo5Jw0jR2d3hZgUeVYv?=
 =?us-ascii?Q?CWNZ9bpNtzl9EV0Pp4DoEtwrh5FIxO5JEJg+Gce0geKw6jn12yXzzAKtzmdC?=
 =?us-ascii?Q?yLrDzVmJjur/pyoIoL5+NzSe/8vHC4CNExJ0SgFhRj9xvV/Yz27BFgh6oPQ1?=
 =?us-ascii?Q?X97u26mEwbi5wBba9fLy6AvefvXvTjXQuUxaL8UZnOWTN2+tvULyMJnscBl0?=
 =?us-ascii?Q?e4KFgQyCEaimBg6Ml9OTYgX4vQYHjbCe3ok+4hOdf0VqFj9LGMDtuqZg8j6r?=
 =?us-ascii?Q?/XK3yDdf5bsGBsu5HPWuKqBNiMYEIZCFRJOt4vA9x1SVa+n5pgYpsDv09Xey?=
 =?us-ascii?Q?P/efLkIQefbJxqzPY5vjN3gkzkpJvIGqIr0ONfMY00XlnJJiqylMnyZy/nSW?=
 =?us-ascii?Q?G0XsIZHKDTUM71Zxv0OaNyLzBNrSsKMa2jLx7gy03puvWkn5eDWLSqC+bOf0?=
 =?us-ascii?Q?5tzT28qt/HcvVzhA8VnckTOZgfluABHSCBDZ8p72OYJoKVRG4c232AoAGrqa?=
 =?us-ascii?Q?DzRg98SB//ukXDoaIszd/roXA4akDPQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fafcacda-782a-451f-6bc6-08da2d02917d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:43:48.2321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lU4EWUCK1epqye8c/g19Kb0iiRUatiJFACilMU4BUa4XLYAhzoBFMYEp4xkxIgKeYgdPVJ6RpqjnezuK5Defcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
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

eth0 -> swp2
eth1 -> swp1
eth2 -> h1
eth3 -> h2

This brings the selftest more in line with the other forwarding
selftests, where h1 is connected to swp1, and h2 to swp2.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 134 +++++++++---------
 1 file changed, 67 insertions(+), 67 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index a27f24a6aa07..e67a722b2013 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -15,7 +15,7 @@ require_command tcpdump
 #   |       DUT ports         Generator ports     |
 #   | +--------+ +--------+ +--------+ +--------+ |
 #   | |        | |        | |        | |        | |
-#   | |  eth0  | |  eth1  | |  eth2  | |  eth3  | |
+#   | |  swp2  | |  swp1  | |   h1   | |    h2  | |
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
+swp2=${NETIFS[p1]}
+swp1=${NETIFS[p2]}
+h1=${NETIFS[p3]}
+h2=${NETIFS[p4]}
 
-eth0_mac="de:ad:be:ef:00:00"
-eth1_mac="de:ad:be:ef:00:01"
-eth2_mac="de:ad:be:ef:00:02"
-eth3_mac="de:ad:be:ef:00:03"
+swp2_mac="de:ad:be:ef:00:00"
+swp1_mac="de:ad:be:ef:00:01"
+h1_mac="de:ad:be:ef:00:02"
+h2_mac="de:ad:be:ef:00:03"
 
 # Helpers to map a VCAP IS1 and VCAP IS2 lookup and policy to a chain number
 # used by the kernel driver. The numbers are:
@@ -156,39 +156,39 @@ create_tcam_skeleton()
 
 setup_prepare()
 {
-	ip link set $eth0 up
-	ip link set $eth1 up
-	ip link set $eth2 up
-	ip link set $eth3 up
+	ip link set $swp2 up
+	ip link set $swp1 up
+	ip link set $h1 up
+	ip link set $h2 up
 
-	create_tcam_skeleton $eth0
+	create_tcam_skeleton $swp2
 
 	ip link add br0 type bridge
-	ip link set $eth0 master br0
-	ip link set $eth1 master br0
+	ip link set $swp2 master br0
+	ip link set $swp1 master br0
 	ip link set br0 up
 
-	ip link add link $eth3 name $eth3.100 type vlan id 100
-	ip link set $eth3.100 up
+	ip link add link $h2 name $h2.100 type vlan id 100
+	ip link set $h2.100 up
 
-	ip link add link $eth3 name $eth3.200 type vlan id 200
-	ip link set $eth3.200 up
+	ip link add link $h2 name $h2.200 type vlan id 200
+	ip link set $h2.200 up
 
-	tc filter add dev $eth0 ingress chain $(IS1 1) pref 1 \
+	tc filter add dev $swp2 ingress chain $(IS1 1) pref 1 \
 		protocol 802.1Q flower skip_sw vlan_id 100 \
 		action vlan pop \
 		action goto chain $(IS1 2)
 
-	tc filter add dev $eth0 egress chain $(ES0) pref 1 \
-		flower skip_sw indev $eth1 \
+	tc filter add dev $swp2 egress chain $(ES0) pref 1 \
+		flower skip_sw indev $swp1 \
 		action vlan push protocol 802.1Q id 100
 
-	tc filter add dev $eth0 ingress chain $(IS1 0) pref 2 \
+	tc filter add dev $swp2 ingress chain $(IS1 0) pref 2 \
 		protocol ipv4 flower skip_sw src_ip 10.1.1.2 \
 		action skbedit priority 7 \
 		action goto chain $(IS1 1)
 
-	tc filter add dev $eth0 ingress chain $(IS2 0 0) pref 1 \
+	tc filter add dev $swp2 ingress chain $(IS2 0 0) pref 1 \
 		protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
 		action police rate 50mbit burst 64k conform-exceed drop/pipe \
 		action goto chain $(IS2 1 0)
@@ -196,9 +196,9 @@ setup_prepare()
 
 cleanup()
 {
-	ip link del $eth3.200
-	ip link del $eth3.100
-	tc qdisc del dev $eth0 clsact
+	ip link del $h2.200
+	ip link del $h2.100
+	tc qdisc del dev $swp2 clsact
 	ip link del br0
 }
 
@@ -206,21 +206,21 @@ test_vlan_pop()
 {
 	RET=0
 
-	tcpdump_start $eth2
+	tcpdump_start $h1
 
 	# Work around Mausezahn VLAN builder bug
 	# (https://github.com/netsniff-ng/netsniff-ng/issues/225) by using
 	# an 8021q upper
-	$MZ $eth3.100 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h2.100 -q -c 1 -p 64 -a $h2_mac -b $h1_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h1
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"
+	tcpdump_show $h1 | grep -q "$h2_mac > $h1_mac, ethertype IPv4"
 	check_err "$?" "untagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h1
 
 	log_test "VLAN pop"
 }
@@ -229,18 +229,18 @@ test_vlan_push()
 {
 	RET=0
 
-	tcpdump_start $eth3.100
+	tcpdump_start $h2.100
 
-	$MZ $eth2 -q -c 1 -p 64 -a $eth2_mac -b $eth3_mac -t ip
+	$MZ $h1 -q -c 1 -p 64 -a $h1_mac -b $h2_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth3.100
+	tcpdump_stop $h2.100
 
-	tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"
+	tcpdump_show $h2.100 | grep -q "$h1_mac > $h2_mac"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth3.100
+	tcpdump_cleanup $h2.100
 
 	log_test "VLAN push"
 }
@@ -250,33 +250,33 @@ test_vlan_ingress_modify()
 	RET=0
 
 	ip link set br0 type bridge vlan_filtering 1
-	bridge vlan add dev $eth0 vid 200
-	bridge vlan add dev $eth0 vid 300
-	bridge vlan add dev $eth1 vid 300
+	bridge vlan add dev $swp2 vid 200
+	bridge vlan add dev $swp2 vid 300
+	bridge vlan add dev $swp1 vid 300
 
-	tc filter add dev $eth0 ingress chain $(IS1 2) pref 3 \
+	tc filter add dev $swp2 ingress chain $(IS1 2) pref 3 \
 		protocol 802.1Q flower skip_sw vlan_id 200 \
 		action vlan modify id 300 \
 		action goto chain $(IS2 0 0)
 
-	tcpdump_start $eth2
+	tcpdump_start $h1
 
-	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h2.200 -q -c 1 -p 64 -a $h2_mac -b $h1_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h1
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	tcpdump_show $h1 | grep -q "$h2_mac > $h1_mac, .* vlan 300"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h1
 
-	tc filter del dev $eth0 ingress chain $(IS1 2) pref 3
+	tc filter del dev $swp2 ingress chain $(IS1 2) pref 3
 
-	bridge vlan del dev $eth0 vid 200
-	bridge vlan del dev $eth0 vid 300
-	bridge vlan del dev $eth1 vid 300
+	bridge vlan del dev $swp2 vid 200
+	bridge vlan del dev $swp2 vid 300
+	bridge vlan del dev $swp1 vid 300
 	ip link set br0 type bridge vlan_filtering 0
 
 	log_test "Ingress VLAN modification"
@@ -286,34 +286,34 @@ test_vlan_egress_modify()
 {
 	RET=0
 
-	tc qdisc add dev $eth1 clsact
+	tc qdisc add dev $swp1 clsact
 
 	ip link set br0 type bridge vlan_filtering 1
-	bridge vlan add dev $eth0 vid 200
-	bridge vlan add dev $eth1 vid 200
+	bridge vlan add dev $swp2 vid 200
+	bridge vlan add dev $swp1 vid 200
 
-	tc filter add dev $eth1 egress chain $(ES0) pref 3 \
+	tc filter add dev $swp1 egress chain $(ES0) pref 3 \
 		protocol 802.1Q flower skip_sw vlan_id 200 vlan_prio 0 \
 		action vlan modify id 300 priority 7
 
-	tcpdump_start $eth2
+	tcpdump_start $h1
 
-	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+	$MZ $h2.200 -q -c 1 -p 64 -a $h2_mac -b $h1_mac -t ip
 
 	sleep 1
 
-	tcpdump_stop $eth2
+	tcpdump_stop $h1
 
-	tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"
+	tcpdump_show $h1 | grep -q "$h2_mac > $h1_mac, .* vlan 300"
 	check_err "$?" "tagged reception"
 
-	tcpdump_cleanup $eth2
+	tcpdump_cleanup $h1
 
-	tc filter del dev $eth1 egress chain $(ES0) pref 3
-	tc qdisc del dev $eth1 clsact
+	tc filter del dev $swp1 egress chain $(ES0) pref 3
+	tc qdisc del dev $swp1 clsact
 
-	bridge vlan del dev $eth0 vid 200
-	bridge vlan del dev $eth1 vid 200
+	bridge vlan del dev $swp2 vid 200
+	bridge vlan del dev $swp1 vid 200
 	ip link set br0 type bridge vlan_filtering 0
 
 	log_test "Egress VLAN modification"
@@ -323,11 +323,11 @@ test_skbedit_priority()
 {
 	local num_pkts=100
 
-	before=$(ethtool_stats_get $eth0 'rx_green_prio_7')
+	before=$(ethtool_stats_get $swp2 'rx_green_prio_7')
 
-	$MZ $eth3 -q -c $num_pkts -p 64 -a $eth3_mac -b $eth2_mac -t ip -A 10.1.1.2
+	$MZ $h2 -q -c $num_pkts -p 64 -a $h2_mac -b $h1_mac -t ip -A 10.1.1.2
 
-	after=$(ethtool_stats_get $eth0 'rx_green_prio_7')
+	after=$(ethtool_stats_get $swp2 'rx_green_prio_7')
 
 	if [ $((after - before)) = $num_pkts ]; then
 		RET=0
-- 
2.25.1

