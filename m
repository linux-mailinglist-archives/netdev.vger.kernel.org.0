Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26F31B4ADA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDVQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:49:15 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:29032
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbgDVQtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:49:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtbbbieGr861d1c/pG0SV18squ73gz1pdJhK7BuB/z7HoorA4CjtK+WwvoWAKXSTz+Mid/EV5sl1Jqi/7vqqiG0BED3PDdLelQ1m9yKq9lThuMFUwfllAKF88YdlUx0LcmWwLTEliciln/nBT9SKbHqxgGperLKhe6Uup5lLZ/4j6y/rLh7etMS0gBmze76Dn2HjTHfv+aXPXJcME5STMQr6V+ktyzZ+A0ojxhkDbRraSaadTOw1yE5fz8zm4OQFRgsnYmgHXgtqZNn2qKhBwy+3qGH0lU/ib7VANhON72JIp3Zv+tJ8LoQW0FT/NNe//aDqwkN2B1fjD58Z5QiEbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HlYU5qaRDoMCegZGYOo7qS4iq8U4T+T7FXvYSvOb7k=;
 b=YorECHdzuFse02Q/kViRoYhwWV2cSmZj5fmVZzT2wHSCDPrQkawxNm1X5CfMaLMnTZrwFyBN4JTSEfAKSy7gJ2hZD/zxeBzyQfHd/Vhm/Hd4qcyJjtYSLyBkyb6JQfjM83LQ3XW1QxBuJq9wg7j78hgZQApo6+uwurpj7KBOXoRcT7RBWGgZkko66JRKoaqJVj60Wqq+Je4EDf3DrQJBYEupiOuzkpvkhRkMMb8ysHpqcUmwQeqmiZdK3oUv25CO8pOKxYKrBKkCapBKvqCHIINNcbzt0Gl458cjsq74LQgV9dQWgMya7dNanlcw58v6q7Pw4yYE24CBPYc4yLfkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HlYU5qaRDoMCegZGYOo7qS4iq8U4T+T7FXvYSvOb7k=;
 b=DiNi8zd+e8L7i81WvE8bxrxzKu51Lcc2LF8PIALsV6LqNCnGaNnsiqLiwTh8hMB/TNd3A559Vxhr3fTESjWfDoRLeLtDbqwzFm7xdcp5e1GsCi3asEs8qYdTxzJmkVYd+FyLLn10JaWsyR4PCTvREin/O0/Gi8x5z46vV1PnlQo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3498.eurprd05.prod.outlook.com (2603:10a6:7:33::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Wed, 22 Apr 2020 16:49:07 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 16:49:07 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, davem@davemloft.net,
        kuba@kernel.org, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/2] selftests: forwarding: pedit_dsfield: Add pedit munge ip6 dsfield
Date:   Wed, 22 Apr 2020 19:48:29 +0300
Message-Id: <20200422164830.19339-2-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422164830.19339-1-petrm@mellanox.com>
References: <20200422164830.19339-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::23) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0203.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 16:49:05 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e30b466-6e7b-4bfc-094b-08d7e6dd125d
X-MS-TrafficTypeDiagnostic: HE1PR05MB3498:|HE1PR05MB3498:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3498E03963421D0A93E6AE74DBD20@HE1PR05MB3498.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(8936002)(66476007)(6512007)(6486002)(52116002)(54906003)(498600001)(36756003)(1076003)(6506007)(8676002)(81156014)(6916009)(66946007)(86362001)(956004)(2616005)(26005)(66556008)(5660300002)(6666004)(4326008)(186003)(16526019)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgLnopLpxt5L9OWBslm9TVujt9kZMuuYoTlNn4Ml3Ml74NxAYn6S44YuCPfx9sD3Wasn5L0MEbTB0fheuqSM6vja2Wr7OZHG3yFOzbhQtJhrhgNtDvUKacDP/ghBz6XUl+kZCK0GJQJr3aakworask5/CTK/pRacZEsclaBKtqcIXN2VIU/733V4NqF2dvQO+8tVQOmi9ANq185YDC0MN3o2OlrdDUu+3NMBZeEJOTcJ6fTDHIsJrzhQ3mL8jmQ64EIWXMXwOcDnVwhZT3BpsWyg8j66FZcFKimVMk2R9iJ5fmfBk1ll2DT7Qhn4u+xJlvOTeg9ZtPDpTMLL/T5sq08FrCagUKF/+CdBKe1ooBPb1zFTrABRoIr0MuoXKdE0t1ehjwXUROV2n9ypQ/B2nShMW/HMItUGBFXGsWdn5wjGwxVudiwGECNllINKh6FE
X-MS-Exchange-AntiSpam-MessageData: 0LK0bXy9Plp+jLSaK/LDrPAbzzowTp+6XDtBImShTcvTH+7nmqOI8juCo66pedp2bIgUuoG0DxwP/By3pnCFhCgcm17IDJgHzvdJN0mW0GMHKbx+QrD09nRlXq3Gyfxbkc+EaYkuSbIpyJu1LQpvlA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e30b466-6e7b-4bfc-094b-08d7e6dd125d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 16:49:06.8701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM7YSZgsdoQWGRmVQqKPFyQ7WgwabGmS7BZ8Gg3nepMv7ZnAb5gjF5F9SIzZJPPw1lnV8mZeDfdZVAIl0b9Utw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3498
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the pedit_dsfield forwarding selftest with coverage of "pedit ex
munge ip6 dsfield set".

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../selftests/net/forwarding/pedit_dsfield.sh | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index b50081855913..1181d647f6a7 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -20,10 +20,14 @@
 
 ALL_TESTS="
 	ping_ipv4
+	ping_ipv6
 	test_ip_dsfield
 	test_ip_dscp
 	test_ip_ecn
 	test_ip_dscp_ecn
+	test_ip6_dsfield
+	test_ip6_dscp
+	test_ip6_ecn
 "
 
 NUM_NETIFS=4
@@ -107,6 +111,11 @@ ping_ipv4()
 	ping_test $h1 192.0.2.2
 }
 
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:1::2
+}
+
 do_test_pedit_dsfield_common()
 {
 	local pedit_locus=$1; shift
@@ -228,6 +237,63 @@ test_ip_dscp_ecn()
 	do_test_ip_dscp_ecn "dev $swp2 egress"
 }
 
+do_test_ip6_dsfield()
+{
+	local locus=$1; shift
+	local dsfield
+
+	for dsfield in 0 1 2 3 128 252 253 254 255; do
+		do_test_pedit_dsfield "$locus"				\
+				  "ip6 traffic_class set $dsfield"	\
+				  ipv6 "ip_tos $dsfield"		\
+				  "-6 -A 2001:db8:1::1 -B 2001:db8:1::2"
+	done
+}
+
+test_ip6_dsfield()
+{
+	do_test_ip6_dsfield "dev $swp1 ingress"
+	do_test_ip6_dsfield "dev $swp2 egress"
+}
+
+do_test_ip6_dscp()
+{
+	local locus=$1; shift
+	local dscp
+
+	for dscp in 0 1 2 3 32 61 62 63; do
+		do_test_pedit_dsfield "$locus"				       \
+			    "ip6 traffic_class set $((dscp << 2)) retain 0xfc" \
+			    ipv6 "ip_tos $(((dscp << 2) | 1))"		       \
+			    "-6 -A 2001:db8:1::1 -B 2001:db8:1::2"
+	done
+}
+
+test_ip6_dscp()
+{
+	do_test_ip6_dscp "dev $swp1 ingress"
+	do_test_ip6_dscp "dev $swp2 egress"
+}
+
+do_test_ip6_ecn()
+{
+	local locus=$1; shift
+	local ecn
+
+	for ecn in 0 1 2 3; do
+		do_test_pedit_dsfield "$locus"				\
+				"ip6 traffic_class set $ecn retain 0x3"	\
+				ipv6 "ip_tos $((124 | $ecn))"		\
+				"-6 -A 2001:db8:1::1 -B 2001:db8:1::2"
+	done
+}
+
+test_ip6_ecn()
+{
+	do_test_ip6_ecn "dev $swp1 ingress"
+	do_test_ip6_ecn "dev $swp2 egress"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.20.1

