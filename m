Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E62567D274
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjAZRDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjAZRDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7476813A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIuFBmtPohFMut3TW9+OskvLnN1oJYjeCwyrvM0+XL18dl4yiBcOyzz7qrZ+3jPiRY04gvrHHB6NKAI4hc2zuXG3t3dTbvUxbgMVO8mdcEO6WFuaztCc56+k1QQvjYgOUTWmq7lcKISTO0c9OqKhNUnutT5l7/lvVLNrsYfeyn4guhGHfi3mBCwf/BP3tQdm7kAGCmHQokbqmVPkAgjwaYuuECrEaVcGFmRg5RljE5ZYHpqpP5VfSMi/IPQ7Loeb6ucqRqhKxD/oBG8mJTVjzKGuwsVkYMLjmVvIu3+C5lTnF6PzY5hOeBlDHVlsV4mj2l5pm4VZXSd/KIGt7TLCFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEmIO7uxrQsYrcorJVreuzMKZo4Grzx8cK37H/rcF50=;
 b=EjtdSiPHqpobdQ/WvdgfMNYjioP39/Oz/0NOZEEgGLKSVpe3tVppBG/xaArAHvEFHYIxDNdns5wNOsB91xMbEZXk7YnpSXcbr0nsKVuN5vJ/doUUBOMJiQvDGawHaLRRapwjE3F7ozBNhfBKMqZm7sMsKTN1rRbCeJYfhHTgwNVRYelY5oDyedzOHzW3kRXssqUg2/wBFQSgcOuBKgLZl/9wGO/stLKBKAnK4yZZdd3PFgflP2X03G5V9UfH/XSaG8SqIF1g/bhPOdY0TKNVzNgbqetvnJsE9QHUW97MxbSu1cwkWtM8wfaqVCVLZotPx6uZHQ7Vhr4xrrrLVTidXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEmIO7uxrQsYrcorJVreuzMKZo4Grzx8cK37H/rcF50=;
 b=tR5qBPXRJFJYBglwnePnczI1sE0BFcCuWQgspXvKU3qMOe0Ef0A8spzf9OC8g/SAgjA0ySsxNdiGq67oaRwqFRxm7EBdGUN2gjR/D5E4V4Ah9sW+L1Qo1TqMS5ovyTtzOp0lQxzOZMUkqyeWVl8/1rz2Ohk490ewYMTX/c4ks2jadHWk1MAW/WjS7hBsRbyYtodCXgAI1EiQR+8OcqWiY0VDu9Cm9MjcKGtxEafOu1Gu3K//53/J0THDNQ1hjc0TIjgQXoF3PV55JHE+JYerphuUljYtBinEC+CXo+kCrkz5gUUSi/j3HhV9CNAhL3yVTAjFNjyIw4i0k0W0/tZyIw==
Received: from MW4PR03CA0292.namprd03.prod.outlook.com (2603:10b6:303:b5::27)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 17:02:31 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::b2) by MW4PR03CA0292.outlook.office365.com
 (2603:10b6:303:b5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Thu, 26 Jan 2023 17:02:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:21 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:18 -0800
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
Subject: [PATCH net-next 11/16] selftests: forwarding: lib: Add helpers for IP address handling
Date:   Thu, 26 Jan 2023 18:01:19 +0100
Message-ID: <cc8762f78b2468f9b48288235470bd606fddbd96.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a71c787-2c58-4a8e-9889-08daffbf1ceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAxOM9yU0Ewz9IplivBuU4yE3vxf77xfpGmjFKp8aQKzY5JqBHTbpM+mdh9m3b/ej3jMMK8vd/9y9P3xw5uEC5zMXuBvPy59NexDHao/Ircb9VNLqNcMixB1XmVY5zkQr392HIJtYgNNe6XFAdiiO96iARWv/6KlhIXXCFRJ9gALMSlCLe3FD01mEpqpUoCnHZo5BbBphtE4orBqTSuX+7xbixrLpgSdO492e+H0i4DD6RK5x7tmkIS2egB1arp9XW62dEQvZDpeqxvT/8T9hIkqzWH/LlCVSfHa7f047mjmG950e7SvePFYRajjIlSb1w5aqGQNn9MDDke+8U1Et2W0pAIuOlWV+vVW82l9w1LQba0ec6tzvXbCrR+e920bBaRMN/P45180/s7Zc7fmGU9UBwdPTdp68BokIT6BgeUmTHAlOBToeGvowVqqhwNYUXLLM9eYCjrbA2lNcCWlUnZZG8w0ejFkRj3jqgaxSMls+MrJs5iQ6DYyCqALv/fVGasKLfNEhL62vQhFepDp/WG8FvUV6y6iJAP4uYhu6Sx8a6f99LyhM0FInLMy+Aqq0eKIV0RqR0P23vUC18tZFFGEGZ9fCZeFCpo9ApI7/CIBYI9BAvG7Bu0gE8pbeNC7r2JSBXYaEETh2dvLvcuI0PJHan+tnIH/eZaEtLg9yCIvCnurj7FlgaKBZ4Hkg+PwbvaENPCAso4PLzXPnhFkKg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199018)(46966006)(36840700001)(40470700004)(2616005)(54906003)(70586007)(47076005)(70206006)(336012)(110136005)(26005)(86362001)(40480700001)(82310400005)(426003)(356005)(7636003)(40460700003)(107886003)(186003)(41300700001)(478600001)(36756003)(36860700001)(82740400003)(8676002)(83380400001)(5660300002)(16526019)(4326008)(8936002)(316002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:31.4291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a71c787-2c58-4a8e-9889-08daffbf1ceb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to generate IGMPv3 and MLDv2 packets on the fly, we will need
helpers to expand IPv4 and IPv6 addresses given as parameters in
mausezahn payload notation. Add helpers that do it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index db2534f7e49b..8f7e2cc8b779 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1693,6 +1693,43 @@ hw_stats_monitor_test()
 	log_test "${type}_stats notifications"
 }
 
+ipv4_to_bytes()
+{
+	local IP=$1; shift
+
+	printf '%02x:' ${IP//./ } |
+	    sed 's/:$//'
+}
+
+# Convert a given IPv6 address, `IP' such that the :: token, if present, is
+# expanded, and each 16-bit group is padded with zeroes to be 4 hexadecimal
+# digits. An optional `BYTESEP' parameter can be given to further separate
+# individual bytes of each 16-bit group.
+expand_ipv6()
+{
+	local IP=$1; shift
+	local bytesep=$1; shift
+
+	local cvt_ip=${IP/::/_}
+	local colons=${cvt_ip//[^:]/}
+	local allcol=:::::::
+	# IP where :: -> the appropriate number of colons:
+	local allcol_ip=${cvt_ip/_/${allcol:${#colons}}}
+
+	echo $allcol_ip | tr : '\n' |
+	    sed s/^/0000/ |
+	    sed 's/.*\(..\)\(..\)/\1'"$bytesep"'\2/' |
+	    tr '\n' : |
+	    sed 's/:$//'
+}
+
+ipv6_to_bytes()
+{
+	local IP=$1; shift
+
+	expand_ipv6 "$IP" :
+}
+
 igmpv3_is_in_get()
 {
 	local igmpv3
-- 
2.39.0

