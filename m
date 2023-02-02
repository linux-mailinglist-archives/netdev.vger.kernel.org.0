Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF206885E8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjBBSBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjBBSBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CCF6D5C1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTqHm0vjUYFuykC+7WtJqX6joyxRbFPcSYl+10kv59V4nu/TKMwB+1Lbfm+w+lEiCWEE+Ff5JFS2J15z1aoaPargrn1B0RQY78YdTRvnfvCv2SjWaH1ZQpvlXjWf6Mu/QBeJbd5kU3pwDeXuGXjAu8OqrqerkajZVxA/0bMjmo2D1YUSzlQUW9d/yVZGkwyRLhdR0nBvTsoD1fMjlQVJKmYdyGUORGLtOU2RQSFzZWkeH3fgcEXxnYYuZD3VIXbNhzRJhvvrvQ1QxrTZ1BU+cOky5P+N7gKZPzx56jJmwxHozeVSvDGWzIDl/+lGoCIUc1Yjn3j8S6dbNWdVm5VMkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifoIliBKd48Gdlg8BlM2Lvhk5jUlMyh5LYVNvRpDVWA=;
 b=Hcdyv7JzeYe1acTx9sMdLo+n5yXJWq3ZtQ1FP1p2VoPgI2MHUba9ZrAWj1q19ajOhXjEQvbcEszlsAuE4FnmnntOrAitPhFoOOxJOBjovhkcBKw9Lg6DIVbAm5p/C4hTR17ArOGRDxgr3UB2JdLGazCJkbuLdRRIfJsX1QgcsjmwftgTw9bi9UFYBCpTnovRIx/D6gkblaxE312nAlo9Uy9rKwOoPLmyPc8xdbPhXG5uOAv/26gzQDyuaLgHD08oEn+qIv24niT8MHX5PuehglAIJAxvxUYb4XE3MGdgFD0t2Dmm5hGe89fy8J5IE8/hQG+uTmym9XuwgV2qW5xASQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifoIliBKd48Gdlg8BlM2Lvhk5jUlMyh5LYVNvRpDVWA=;
 b=jcZ8hNDHLkB+i1KyFCTRpAkfG3g488FVmPnEGqIecxlXyMtplRcz6N08Qz3xERxxKPYrqjKsuWK6C/rLvLMVEC9djQJ8do8cBhfAMZ20UfvzuoBi2goU0rH6/xF6jYWQESDoyYxbQ93nmIbGaIx+yr5F2Nhpnty/dQafzlv5KFF8/9LFLo6reeirIvhdpXN/jIbGuBKqZhZih1xEJPS1TzcElNfTAAJVEuXQEDsdyym0qsgyGLXNmKx9K6CQ+cdLlkC91m0Q3YUnBQdwdC6mHPxP8UEFIlODh8vLBxgiY+5xz3atEK637AnXjC/qSVMAjstDyRDa8O9NvD/PwjMyeA==
Received: from MW4PR03CA0137.namprd03.prod.outlook.com (2603:10b6:303:8c::22)
 by IA1PR12MB6067.namprd12.prod.outlook.com (2603:10b6:208:3ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 18:00:55 +0000
Received: from CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::e4) by MW4PR03CA0137.outlook.office365.com
 (2603:10b6:303:8c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT081.mail.protection.outlook.com (10.13.174.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:00:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:39 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:37 -0800
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
Subject: [PATCH net-next v3 09/16] selftests: forwarding: Move IGMP- and MLD-related functions to lib
Date:   Thu, 2 Feb 2023 18:59:27 +0100
Message-ID: <b55106c4525a101f85431ad6accc03e83b0727f9.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT081:EE_|IA1PR12MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a8de9c2-5d33-429b-ce6b-08db05476e26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6zHbmqfW1LgGbKkxGdIvayOmve5O/4TveUB2IBE6xu2P4/fBe8i71gqAcaGb62+6rA9bi0/5MDjraGj9lVzcBmPIGHryHpdv4F+/F/V5TkOYn4jmHoLMiNXc39slvl7Aw2OC/CJaqseyfqekGVxR2F9dng5cD57e4c15L62zYKRkpiNtVoiYscn9UC64wWtitiAKf6nYaI/m+DyAD6lX1o2UvuZAY9yPonNiMdsM+5CVzf9C3uIl+9oTohdhPiU36ZsQoJ7Z1g4H/JKJ6wQt7OzDQucFHa218I2/JLpUrnqaJaDNmBZagcVVMMpD+rT9lJmOW3eFJUnyDog5RXDKAqNjQci6tsdxVGNPxvNhZLsBWkfzkj0pSJkyU6pEhb7xlQl+rczxM31BzN4JaNhcxUIUAe/9TLnNr1tW2MO8/LLx5kKOdk/y6chQ0D/3xqG/7qKJO3pzyJ8c0WjOKOaUKCxLMasuA023i4yUUW6I5XTKRN8MW8SBEu3DMw0gsPfJF1/TsqSkrjg5GsF0fXp7HGA/O0S1DOcI/S+2TLQk+XTnS6839t2EjTUkBhEl7QAShiGBBIsODnIfU8Cvq+Gq50V4lYGWAiTKnO/BhYqc6pIYcKpy0frQdg7CM7KfbL8FGB0ON3IE6QkRvv65YfkBZu8bark0qMjeBEJM+egCNqow8sseNJWQWGHX2qiBNne36q+WSBQRsWzkJDw5sKb0g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(36840700001)(46966006)(40470700004)(82740400003)(316002)(41300700001)(478600001)(40460700003)(6666004)(107886003)(83380400001)(86362001)(8676002)(2616005)(47076005)(82310400005)(40480700001)(26005)(186003)(16526019)(70206006)(70586007)(426003)(4326008)(2906002)(36860700001)(110136005)(36756003)(54906003)(7636003)(336012)(356005)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:55.0973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a8de9c2-5d33-429b-ce6b-08db05476e26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT081.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6067
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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
index ded967d204d3..0cfa0b699803 100755
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

