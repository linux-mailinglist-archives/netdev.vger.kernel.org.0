Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5730467D270
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAZRCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAZRCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8816A727
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJXEcGTO3M30n89EpE1gvq4MA3pGOE2nslx8YkbvI34LaGSBIu13Lp2PAlkUZLgsRD0cC/yDBg4nOnbCdF4f9Bs3wos1L3YJ2PD3tYlfDm8zT1W3EZ9OJCo9DzulUId08f2cn2IGJ7dZctPbE45XD1TVWlt7aw3fwRU4iPCoNRRAW5LI54eDiUBgdafMB+WEg54cXk+anMtaMOMsIl8vYkVafnSH/Mg1JCaGipNCVyrIx+lbpLEKMI6M5vhavmhXcbHoPaUmsAhWTsmEgONdiJE6Q/JFIKXQx7lwLqh+MVrNFVAtEwuxNX3pT4PezeEjXq3A5suMA2uqjTzHbWFmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6Ub1IDHkp1vyCA8S1IJRVS4Vnw1XARvo/25RQk2MsU=;
 b=KKdKMEFP7VoaVkoR50PI4xVATkpMlg+wkp18ntvcAvVsbsqPp+omuxQdf+8LHV74s2K3Gq/69YKnhN9XYGlvBz+ghIIX8pJPKK4RGQZxZ1bmvP7NENmFfcIjhqFOVS9rSAF2fRdQy/KFkuRAL66x5OReTDqHueq8BixdXCU5yjCIikQ/V3RsATdPlFgtVs7ul7UDoTt2n7zjtWQoEdClzWop8px0jQsbKf9QKg6VX40tckgZj9yotxUJIkUsaQ2A8GBY1Ml0i0NbJjuvO2j6LVsWPecunOLH7dneXz/4p4O7qjjrjMCVw0vzoBbda37OMw3Vu3/kQgLnQaJdA0gKkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6Ub1IDHkp1vyCA8S1IJRVS4Vnw1XARvo/25RQk2MsU=;
 b=gddW4HTt8bpseDdEaeZmcyWZiW6EKXXXk2BLdZkplxOMg44JRXVbd4vT5iIa/OjWeL7C5rEecOt9VzXA+GEaXbJWo4XosiMHhRpkaP1y+G66JwUgmk8HinPispFjyu3i8+X/OVnakPSD3+FlM1QEWNQywRRleGWsvNa1jYf1DaQNgGIJTxLqCQtDyRVx35DQj3krwO/+YeMaIlwRD99GJgaNbebJoE/IXJFkHnt/yKYz4iNzRaDZyjEAEuJtLCVtBUF953kYssn0nW+X2IwGQWJ5DNt5nJaeXNLIW/026AYnt+vYDCiNTKAS7o5ZhAQAHPBSlODVqUiFzQhZN56bSg==
Received: from DS7PR03CA0322.namprd03.prod.outlook.com (2603:10b6:8:2b::29) by
 CH0PR12MB5073.namprd12.prod.outlook.com (2603:10b6:610:e0::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22; Thu, 26 Jan 2023 17:02:28 +0000
Received: from CY4PEPF0000B8EB.namprd05.prod.outlook.com
 (2603:10b6:8:2b:cafe::65) by DS7PR03CA0322.outlook.office365.com
 (2603:10b6:8:2b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EB.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Thu, 26 Jan 2023 17:02:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:16 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:13 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 09/16] selftests: forwarding: Move IGMP- and MLD-related functions to lib
Date:   Thu, 26 Jan 2023 18:01:17 +0100
Message-ID: <c3f7ba006ca61292dba6d6389f30a38a70731a8e.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EB:EE_|CH0PR12MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: b80996a9-ef04-4c29-48a8-08daffbf1a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2pWGTjRJ9VVsyYKyMa3gIaCg/m56oQdn8edr0pZe17h1FAb6O5akU9vhbS6rxDUmJXnt+PcP4VH1re/ud7dsvI9Aj29TiEcaT/2EjNejBfMQxYV91diPphZZndcF2hDg0+nzoiZgcCgCNJxQEh0n7aIyPT1F9peohegM0WatOBGDgKraMQierh49LWY0QyWKNNwwVjm8kGsjRrQZai3JLlL0E/BFYLrEv7AL5TCPVtwmpugVUysGhsXMUpMgVIK2M/MlbaNr5gJhKlzy2VS+o2hnX5p+HQX5uCRM4Vuy/lCISMj2ibLvQgrFbuw82tG3pXadSwYmWHeJ61lIDboPhfXeLSu4enSv3c7MKTCrKKAxYJ1THGrHT/wSxbrAD3rrNfQRu/2st19ilRQYylB2leCM8WNp2nMmaO249DDs/1qgh6xSKhdfJxeEJVEgregmd6u5E+EV292GqwlQx1R03R8NkLC6iqpyHebY36KNdSxSwVxpnl8jDHsUUUShg1dMdGj8FZwlwsQVHnzdk40xkZwkrOioMbhTYqNrbFEPX0UMJ9jeIlv+aZSTJIlvjlhfQPefVRjlwGTHXHfqkPcCz9PVaXQU0pX/HWkzlt0Dx5JtzvRuwZj6VWreObYKoRjRxEAmFw9wK+Bwc8NxWt/ZPuBkgxGl+Ns8SoN9zkXLgiL0RpBTYyUzLc0//RQ7teGLfFLU7hATkOpC6GEfcHG6Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(36860700001)(8936002)(47076005)(426003)(336012)(41300700001)(40460700003)(83380400001)(40480700001)(356005)(86362001)(7636003)(82740400003)(82310400005)(110136005)(54906003)(36756003)(70206006)(70586007)(4326008)(8676002)(316002)(2616005)(16526019)(478600001)(107886003)(26005)(186003)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:27.4767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b80996a9-ef04-4c29-48a8-08daffbf1a95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions will be helpful for other testsuites as well. Extract them
to a common place.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh    | 49 -------------------
 tools/testing/selftests/net/forwarding/lib.sh | 49 +++++++++++++++++++
 2 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 2fa5973c0c28..51f2b0d77067 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1018,26 +1018,6 @@ fwd_test()
 	ip -6 address del fe80::1/64 dev br0
 }
 
-igmpv3_is_in_get()
-{
-	local igmpv3
-
-	igmpv3=$(:
-		)"22:"$(			: Type - Membership Report
-		)"00:"$(			: Reserved
-		)"2a:f8:"$(			: Checksum
-		)"00:00:"$(			: Reserved
-		)"00:01:"$(			: Number of Group Records
-		)"01:"$(			: Record Type - IS_IN
-		)"00:"$(			: Aux Data Len
-		)"00:01:"$(			: Number of Sources
-		)"ef:01:01:01:"$(		: Multicast Address - 239.1.1.1
-		)"c0:00:02:02"$(		: Source Address - 192.0.2.2
-		)
-
-	echo $igmpv3
-}
-
 ctrl_igmpv3_is_in_test()
 {
 	RET=0
@@ -1077,35 +1057,6 @@ ctrl_igmpv3_is_in_test()
 	log_test "IGMPv3 MODE_IS_INCLUE tests"
 }
 
-mldv2_is_in_get()
-{
-	local hbh
-	local icmpv6
-
-	hbh=$(:
-		)"3a:"$(			: Next Header - ICMPv6
-		)"00:"$(			: Hdr Ext Len
-		)"00:00:00:00:00:00:"$(		: Options and Padding
-		)
-
-	icmpv6=$(:
-		)"8f:"$(			: Type - MLDv2 Report
-		)"00:"$(			: Code
-		)"45:39:"$(			: Checksum
-		)"00:00:"$(			: Reserved
-		)"00:01:"$(			: Number of Group Records
-		)"01:"$(			: Record Type - IS_IN
-		)"00:"$(			: Aux Data Len
-		)"00:01:"$(			: Number of Sources
-		)"ff:0e:00:00:00:00:00:00:"$(	: Multicast address - ff0e::1
-		)"00:00:00:00:00:00:00:01:"$(	:
-		)"20:01:0d:b8:00:01:00:00:"$(	: Source Address - 2001:db8:1::2
-		)"00:00:00:00:00:00:00:02:"$(	:
-		)
-
-	echo ${hbh}${icmpv6}
-}
-
 ctrl_mldv2_is_in_test()
 {
 	RET=0
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 1c4f866de7d7..db2534f7e49b 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1692,3 +1692,52 @@ hw_stats_monitor_test()
 
 	log_test "${type}_stats notifications"
 }
+
+igmpv3_is_in_get()
+{
+	local igmpv3
+
+	igmpv3=$(:
+		)"22:"$(			: Type - Membership Report
+		)"00:"$(			: Reserved
+		)"2a:f8:"$(			: Checksum
+		)"00:00:"$(			: Reserved
+		)"00:01:"$(			: Number of Group Records
+		)"01:"$(			: Record Type - IS_IN
+		)"00:"$(			: Aux Data Len
+		)"00:01:"$(			: Number of Sources
+		)"ef:01:01:01:"$(		: Multicast Address - 239.1.1.1
+		)"c0:00:02:02"$(		: Source Address - 192.0.2.2
+		)
+
+	echo $igmpv3
+}
+
+mldv2_is_in_get()
+{
+	local hbh
+	local icmpv6
+
+	hbh=$(:
+		)"3a:"$(			: Next Header - ICMPv6
+		)"00:"$(			: Hdr Ext Len
+		)"00:00:00:00:00:00:"$(		: Options and Padding
+		)
+
+	icmpv6=$(:
+		)"8f:"$(			: Type - MLDv2 Report
+		)"00:"$(			: Code
+		)"45:39:"$(			: Checksum
+		)"00:00:"$(			: Reserved
+		)"00:01:"$(			: Number of Group Records
+		)"01:"$(			: Record Type - IS_IN
+		)"00:"$(			: Aux Data Len
+		)"00:01:"$(			: Number of Sources
+		)"ff:0e:00:00:00:00:00:00:"$(	: Multicast address - ff0e::1
+		)"00:00:00:00:00:00:00:01:"$(	:
+		)"20:01:0d:b8:00:01:00:00:"$(	: Source Address - 2001:db8:1::2
+		)"00:00:00:00:00:00:00:02:"$(	:
+		)
+
+	echo ${hbh}${icmpv6}
+}
-- 
2.39.0

