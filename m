Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6BC6C30EE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCULxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjCULxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:53:35 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289EB4BEA2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:53:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wr/T3lSvqnvuWaTwzJmvu5XBeEPcdP9wdjPS/H1PuwWQXMCLx1QY4ei2ssQd7RsplaT+4xKAF2u5B9kXxKhNBwfKHQQbzP+gwTuYg6Q84AGkDtpL/T4Ru97w10Rq0vKuBQXQgMqWpXZUAn7KTonJ/2ufRm5gGShBXkPq0ljvGOZOI8MA2eu6lKbRmczw57gvjY1kMguJmqMjNgcoYD6VCqPI8pnGFQWa87xBgD3eDDtk2WL+ei+RnVM0UOSMDmhWXRsokBRWYPgiaosRXnNqBx70YVC+pY7DChSD9evYT3Pimp1psNDoqp+2VQGC4bXLDhStiYwAKoVXKwXlCEqjkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqUyGLPjjrcTzKqJa+bF4ItUAyI2ilCDEFKFU5P/Zcc=;
 b=XDAbZ3HpXHw+6Sp3kApDZZ0nBRDRIvf1aTxzloHIIor1y5Cql+NjqrL0q1v+ANjnB0CZsBvvR742xO/TGarC/DWqSGmynGrIkOgVrW+RUnX0a5bvwBzQjkaKKXP+0TGGJLz0fP8duBSOAv9xEcCkqUwWmKmXKASmVKhrepS4Owu97TQbwPTEe6ZkuZOPtvse/g9EVGsZz+KhgNfcvFDOgxEUip6eGkEd/QLdaFXVkX8tar8swpEIVPD+3amRJXrOm9rmU27rgAFAYYvmmU6uWk+AzNAT2v95dDUGcCK+E+SUvKe/+KkQLxcvz/3RrS5YHmNWsUMmL4/rJi0bFv8pew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqUyGLPjjrcTzKqJa+bF4ItUAyI2ilCDEFKFU5P/Zcc=;
 b=Ty/PiQBBtN52pgvYSnKZW+w8Zspxhj5zmJIA5CKzCDEQMxJgZxb+zSwb9E7cMqXdYc7zaC9bPWEz698QuyM91J4iSho5z9KbAkwoNUAiJGYhe5f0cSz5f7WqrLlFGRiFvY9IqI6iCBzNlQKBSZR37GKvEQcks35oEBrITtTZFiUgIKHfE9mKQlUIW1fy5+mWMUgaTBSF97KIi8PfRSxY/X7PgIiiMC8gQp1BOSmIcdeOobHOSJRZVGZXVAhGL3qf9tu0av+wGvcHDFS9NZydCuKkwAYAw53WdxNlHpdnIITB4wjMqmhusfDl1gdcf9D/651wUSrhHgIVzqgUhzYHDg==
Received: from BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::21)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:53:21 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:2c5:cafe::ef) by BL1P221CA0030.outlook.office365.com
 (2603:10b6:208:2c5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 11:53:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Tue, 21 Mar 2023 11:53:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 04:53:02 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 04:53:00 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/3] selftests: rtnetlink: Add an address proto test
Date:   Tue, 21 Mar 2023 12:52:01 +0100
Message-ID: <1d62c94b5fe3c03ee08242667304732d68bad000.1679399108.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679399108.git.petrm@nvidia.com>
References: <cover.1679399108.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|DM4PR12MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d43e06-c715-4b6c-3e44-08db2a02de39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1Vjgfr/TLF8OSHVufC786QHcbP9yHi50E1oByoHcjV1c/20B3vF+4p+RKaLJjuzpyEuABo63KStWGCxogEvxNj5QC5iDVPrSGbFnDLOkQv8nSgu0LJUUA6xI6n19p363NBiEDxQwYD8T81cBXzzHYDEjl6edxgz5pZZ/UFiAcUpuMZLPaUSQdgR64BbYNYZZdUKKNjrer+2WPGMm+nhOLE227iUpQ73flhIakKLWVTr4a8q6uU4DQnVOchglq/XRDAxQA5O3gmC84cNjzRyqZ4uFIv1jD8Boqfk8sldnUz1/fdC9EqIZlSWOqjao1WKSkxE76BfmxHAXzHUp9lhH8rwyWs8Oy8ZEpSN+lE/TJLQIRKGZu5bgKV1df34xd8zqZkFk0vImZc0jFt7QdYq6TRdSuJ21986D92zpOGDFMQCKpXduATUCps5d+76c08yftYTE8QiPDBROd/pF968ewuSRnvXInH/2cEL5QKslmUT/hDXFc27+wcWHwoI1bznZrJKIxLazU9Nf3aX17DMQTwY1CI0HN/io4fFtmN8ZuYJoFG2eTn1j6sy53XLhZlpxNd7OLjbUKaSuFGgrJtQC7gE5TkSTacYWWGSMcp9FJO0umlXRdp/bJkrjG7LA1TM2qWvqjd8aM7Xl88TJA0Iu5UeD5NgujDf0EyBCc7O+XWTFeZezJSrYJgmdLZHAM8QWUoLpcv1XgH9Kcx6/eozcJHPIL0mDJPK6ffxdMAmFv+uxReH5EbHXGfL4DRqyA7i
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(8936002)(5660300002)(36860700001)(82310400005)(356005)(40480700001)(86362001)(40460700003)(82740400003)(41300700001)(7636003)(2906002)(36756003)(4326008)(47076005)(426003)(336012)(107886003)(478600001)(2616005)(186003)(16526019)(26005)(54906003)(110136005)(316002)(70206006)(8676002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:20.7464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d43e06-c715-4b6c-3e44-08db2a02de39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add coverage of "ip address {add,replace} ... proto" support.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 91 ++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 12caf9602353..3b15c686c03f 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -26,6 +26,7 @@ ALL_TESTS="
 	kci_test_fdb_get
 	kci_test_neigh_get
 	kci_test_bridge_parent_id
+	kci_test_address_proto
 "
 
 devdummy="test-dummy0"
@@ -1249,6 +1250,96 @@ kci_test_bridge_parent_id()
 	echo "PASS: bridge_parent_id"
 }
 
+address_get_proto()
+{
+	local addr=$1; shift
+
+	ip -N -j address show dev "$devdummy" |
+	    jq -e -r --arg addr "${addr%/*}" \
+	       '.[].addr_info[] | select(.local == $addr) | .protocol'
+}
+
+address_count()
+{
+	ip -N -j address show dev "$devdummy" "$@" |
+	    jq -e -r '[.[].addr_info[] | .local | select(. != null)] | length'
+}
+
+do_test_address_proto()
+{
+	local what=$1; shift
+	local addr=$1; shift
+	local addr2=${addr%/*}2/${addr#*/}
+	local addr3=${addr%/*}3/${addr#*/}
+	local proto
+	local count
+	local ret=0
+	local err
+
+	ip address add dev "$devdummy" "$addr3"
+	check_err $?
+	proto=$(address_get_proto "$addr3")
+	[[ "$proto" == null ]]
+	check_err $?
+
+	ip address add dev "$devdummy" "$addr2" proto 0x99
+	check_err $?
+	proto=$(address_get_proto "$addr2")
+	[[ "$proto" == 0x99 ]]
+	check_err $?
+
+	ip address add dev "$devdummy" "$addr" proto 0xab
+	check_err $?
+	proto=$(address_get_proto "$addr")
+	[[ "$proto" == 0xab ]]
+	check_err $?
+
+	ip address replace dev "$devdummy" "$addr" proto 0x11
+	proto=$(address_get_proto "$addr")
+	check_err $?
+	[[ "$proto" == 0x11 ]]
+	check_err $?
+
+	count=$(address_count)
+	check_err $?
+	(( count == 3 )) # $addr, $addr2 and $addr3
+
+	count=$(address_count proto 0)
+	check_err $?
+	(( count == 1 )) # just $addr2
+
+	count=$(address_count proto 0x11)
+	check_err $?
+	(( count == 2 )) # $addr and $addr2
+
+	count=$(address_count proto 0xab)
+	check_err $?
+	(( count == 1 )) # just $addr2
+
+	ip address del dev "$devdummy" "$addr"
+	ip address del dev "$devdummy" "$addr2"
+	ip address del dev "$devdummy" "$addr3"
+
+	if [ $ret -ne 0 ]; then
+		echo "FAIL: address proto $what"
+		return 1
+	fi
+	echo "PASS: address proto $what"
+}
+
+kci_test_address_proto()
+{
+	local ret=0
+
+	do_test_address_proto IPv4 192.0.2.1/28
+	check_err $?
+
+	do_test_address_proto IPv6 2001:db8:1::1/64
+	check_err $?
+
+	return $ret
+}
+
 kci_test_rtnl()
 {
 	local current_test
-- 
2.39.0

