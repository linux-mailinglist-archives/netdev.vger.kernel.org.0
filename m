Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C61A2873AA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgJHL53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:57:29 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:40513
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbgJHL52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:57:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kELifvcQvLhqzmfzvZGabF+q5IVpJ8kvzF6EzlVnuVj4fHjEZa2dXE3MIHiWvQsbWqAAR4V2SDBeAvH6To/49lJrwDzbQ8SMw4/JYrklXuxD6k90NZ3vP8xXCmPN6pZV4tm9o1nwNe6FZmquX6PUrqc8Mqn6W8I6g8EYcsT2X322Z8xw8PgJzI5qhpmHglw5eKymmYI903OI9iSpPkVOd68luM3GLwageSgc/RRJ2cIG/acREHQj0DSS1dloinI6568axUAMx2SvLSkGi2SAN9UTFLLDc7rRf12tijRsRLVy3rv2rKYSPs6loSOBB7isiM102XKPUBltajufhnZLqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMH3dmq/xgXbLuREutw0bHkV83Pc9YpLfYSQZjhDXl4=;
 b=WcRQn52bNkO+mXUkVjaWfx0LRLsWhtMTcdsaUQrrkUZkaEv3q94UFkSTEAE2zDZUnE3NF/6neK1XyCPSecTWI7hkEN35TeNpq9bS/7dgiuUujvpLT5t8Ne0ar2X8ATiaHsjTur0YADkaXps5bpMabaTR0c3OOxasbeKJl1CXQJ3YjzeRmD1GE5etjmxPpYW9Tq28WN2hkRWKz98NJwu9bcqz549qaO3YgElNSEIIRLu7AEWXyyfhoV5eMAiYq/aHNlLjDBe6eWrvNKVoBZJFWj+JY6r1+J0y1vbQlTYPpV47xLwrE+W74mJ3pdusY7Y98phxr1Dvr45tbWlmPBl/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMH3dmq/xgXbLuREutw0bHkV83Pc9YpLfYSQZjhDXl4=;
 b=fy45+LX+vQZgJpSEvQqNKgd9AMuKjc3eslHDaxqjqqWTr9f+pZZj+yIxCD44XFcyyedN1pY6QtHHP4a60h4TWnWkfRE+H0UlimN8Ra6x7CZ0Tl4IIPlRnAnBELkpkLtg/uurroM5zxSRgyC2K7IHYyGFFBvq2dwGOh5y+QmdXMs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 11:57:15 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 11:57:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/3] selftests: net: mscc: ocelot: add test for VLAN modify action
Date:   Thu,  8 Oct 2020 14:57:00 +0300
Message-Id: <20201008115700.255648-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201008115700.255648-1-vladimir.oltean@nxp.com>
References: <20201008115700.255648-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Thu, 8 Oct 2020 11:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f90728a-86fd-4a94-f350-08d86b814c7e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3709BD4710AC6F6EAC4267A3E00B0@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLWRG39u5KX/zGrLEAsOalrUqFTozn9E3ogedDDQBWBStNKFcl6czbihaPAm0PJHJPINmkJ+nGaTLyJDCc2hJf/4OHPaiYUCDnrZKrT2lAQfAHSYb36HaXb+Y2GSPz/8FSVEgo5xKU8H4yOShHPR2oZ+slOCluDymCR7if/m8v1+5sL5JtMqtslKCj9Ite8+C8+Ccnz61zJOX7L8tc85/D+W+7LlWmgTKmWkKsv7/j/Y1BVYiSw71gtQBzEzXGGvEQj6Sh91rJbs2yDoMzjrmsQAQp40GYPwRkUeLLu3UIt+h/zK/YLbRBa2z+/LJYpiq4Rh5EPfYlwt2kGLkkOZbQjaHn0Ta9Z14pvru0MJaMNX0WA1IUPvyRsmyU2FLUC1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(4326008)(6916009)(66946007)(6486002)(8936002)(83380400001)(86362001)(26005)(36756003)(6506007)(16526019)(2906002)(478600001)(44832011)(66476007)(186003)(66556008)(8676002)(6666004)(956004)(1076003)(52116002)(5660300002)(316002)(69590400008)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XbXBsSSrNLm3pi1hmbmY35NtCh+HBg1+gHZjdhyXCExbyarNVY/hRN26izwoHRzZ9RFy45B1ZwBer7/pu2F9x3hRZ4qihSAvHtsgB1XrOldYnVAJqeSe8AyacQlO9EgvCd8SGbk92Tgl+pPC5XA9sCDE9xiPeSrAhZl9vzVhAMc53xaWieejkcDC0UgN4E2eF+hlzTuWA/7PczHa8dT263kZAjrd5GgZuNvqxnMy80ild2Lu/EqDuNFZFgKouopOIGkl/00p/hfLLfbn7+q2L7vYLPMee+NegZvwU1tolMPJEd8lsNzCmwsFJBy7z0n8rQ4CrfBredFVJKzYHRX0WDja0lZMBICBqNgBcgYsqVAaZfCnGMHvIF1YKLsEMeEsGtjvNvgepocOMjnbfbSOrD6fV8ORNjRkSk3eG3VnH3GQ92lFSM+M5eGR/tyUS5oB+gxyw4LJsU2IPvfCS4y14rkJWuoR5mnmMBzz4ZQSp9INyeVFNbX0dLCT2fNVqDXqVJ7Idq1Cxfk6bJ+DqOD/u1bwbp6am2GspgkEnBv4rc6Mt7vroK0lFv+4wU5GCGsx96ru1UCPwnm3e0SBbvrd7fcBWXFiIKzQqmcMVoLKMsJY9UmCnSD/l6xWLE7e1tIjOzVtNVwcnogk7FYfJsicAA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f90728a-86fd-4a94-f350-08d86b814c7e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2020 11:57:15.3695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RuEbf3w23PFTTlUCE3KWpce7Sjh6lyOFlDZXtTa5/Dzpe17tR3EboqSzWqzzCP7soOvCP5L5IMRE8tXqCOHO1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a test that changes a VLAN ID from 200 to 300.

We also need to modify the preferences of the filters installed for the
other rules so that they are unique, because we now install the "tc-vlan
modify" filter in VCAP IS1 only temporarily, and we need to perform the
deletion by filter preference number.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 47 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 71a538add08a..beee0d5646a6 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -166,6 +166,9 @@ setup_prepare()
 	ip link add link $eth3 name $eth3.100 type vlan id 100
 	ip link set $eth3.100 up
 
+	ip link add link $eth3 name $eth3.200 type vlan id 200
+	ip link set $eth3.200 up
+
 	tc filter add dev $eth0 ingress chain $(IS1 1) pref 1 \
 		protocol 802.1Q flower skip_sw vlan_id 100 \
 		action vlan pop \
@@ -175,12 +178,12 @@ setup_prepare()
 		flower skip_sw indev $eth1 \
 		action vlan push protocol 802.1Q id 100
 
-	tc filter add dev $eth0 ingress chain $(IS1 0) \
+	tc filter add dev $eth0 ingress chain $(IS1 0) pref 2 \
 		protocol ipv4 flower skip_sw src_ip 10.1.1.2 \
 		action skbedit priority 7 \
 		action goto chain $(IS1 1)
 
-	tc filter add dev $eth0 ingress chain $(IS2 0 0) \
+	tc filter add dev $eth0 ingress chain $(IS2 0 0) pref 1 \
 		protocol ipv4 flower skip_sw ip_proto udp dst_port 5201 \
 		action police rate 50mbit burst 64k \
 		action goto chain $(IS2 1 0)
@@ -188,6 +191,7 @@ setup_prepare()
 
 cleanup()
 {
+	ip link del $eth3.200
 	ip link del $eth3.100
 	tc qdisc del dev $eth0 clsact
 	ip link del br0
@@ -238,6 +242,44 @@ test_vlan_push()
 	tcpdump_cleanup
 }
 
+test_vlan_modify()
+{
+	printf "Testing VLAN modification..		"
+
+	ip link set br0 type bridge vlan_filtering 1
+	bridge vlan add dev $eth0 vid 200
+	bridge vlan add dev $eth0 vid 300
+	bridge vlan add dev $eth1 vid 300
+
+	tc filter add dev $eth0 ingress chain $(IS1 2) pref 3 \
+		protocol 802.1Q flower skip_sw vlan_id 200 \
+		action vlan modify id 300 \
+		action goto chain $(IS2 0 0)
+
+	tcpdump_start $eth2
+
+	$MZ $eth3.200 -q -c 1 -p 64 -a $eth3_mac -b $eth2_mac -t ip
+
+	sleep 1
+
+	tcpdump_stop
+
+	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+		echo "OK"
+	else
+		echo "FAIL"
+	fi
+
+	tcpdump_cleanup
+
+	tc filter del dev $eth0 ingress chain $(IS1 2) pref 3
+
+	bridge vlan del dev $eth0 vid 200
+	bridge vlan del dev $eth0 vid 300
+	bridge vlan del dev $eth1 vid 300
+	ip link set br0 type bridge vlan_filtering 0
+}
+
 test_skbedit_priority()
 {
 	local num_pkts=100
@@ -262,6 +304,7 @@ trap cleanup EXIT
 ALL_TESTS="
 	test_vlan_pop
 	test_vlan_push
+	test_vlan_modify
 	test_skbedit_priority
 "
 
-- 
2.25.1

