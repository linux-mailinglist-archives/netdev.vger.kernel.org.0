Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59F3686CFC
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjBARaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbjBARaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:30:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B743376428
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:29:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftIM9EQ33al12xyyrCsQUzBIfPJRDUf++28rRw2HJ1FOggiUk2mIjJwVLzg/9gnrt4exaf7XB/K70dtYvvEpHy9ykMJ5rjtHzjEwnCoCTKKEznvao77J1IRsA5cS0zHU//R9ADkSZZTVJikf/UDHRYC6dxZMQAMnsSKkgYLYBMuiWNynhX4RIrKdAOjgcuS6rE37haUJDUA2+fXPslIKU6jqPw4aP1ORXr9yZymusXljA77AwUG1BAoUZJgtNSXB+ZC1PBKY0Y0lruKMFkVKdozlURUz9sdBz4ODmwCZatEqj3Bg8JTOLgMkqmDO+GAn5lXW5DI1AYLfBfAWXwvShQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MROtKWGbipv4CDcfkKeuKVdzrhFbE3TSfqwMPue0fXY=;
 b=cI11Zgcox9MsS4fel8TZtvruddhs51l0QgrxfEG/P7BI+Co3nH9Ism2yVIC7sYy7jtQeeksVGkHENnTYRpEqhHE21EeurWpmxz/DQma/18cz5FCygfolMtV7Dt2IYDQWNzsVNCcMu6zJCNF71xKfST3wjgOO6veTW5qh2HxjfirQDiibIr+HIa+K1NKfNjmqtqCgEKnNCuAqjhOCpWWpkX6NHiS0alUg9hQHuKUSXC2viaWH6eLvDtLE76wxXseEZLj+0aylCiPawH9/TbgSu/GNGYLavbNVj67jXDbKaxMaH7jXgubllNG5/Vp1L4VlS5WxY9mp8ABLTvet2pppbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MROtKWGbipv4CDcfkKeuKVdzrhFbE3TSfqwMPue0fXY=;
 b=oN679fAheF7mMyStbKjIKDD1vgyEON03dKri/Osgo6TvMkHLSU+rV8GeXzatqy4FVGcihI9IAmpBP31JVfKG6q45Nkd0Kb41w51LUcDvH/0OAOHf32n8Ui8SMX5r1ySrNE5A94prgSztHw82hJ5kGakFPzt8mclnMwy0cTgR6h+s3k4ZkPnuJcw+8UuLmIpX1VD4djs7SGXfEI4bPxYYvujtlBEY8uHkbi7627WmtZ4nSKerRzmFVAPBuoz//grMuozR/Q6kVGZNZgTZu7UUJA3FjQKTEcAeNCMShuz+NyQCKr10RSP1Lt8N+6NzAkGYE2QqkxEbu1LIQvWWpH5YMg==
Received: from MN2PR12CA0032.namprd12.prod.outlook.com (2603:10b6:208:a8::45)
 by DS0PR12MB7928.namprd12.prod.outlook.com (2603:10b6:8:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 17:29:55 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:208:a8:cafe::3b) by MN2PR12CA0032.outlook.office365.com
 (2603:10b6:208:a8::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 17:29:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 17:29:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:42 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 09:29:39 -0800
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
Subject: [PATCH net-next mlxsw v2 12/16] selftests: forwarding: lib: Add helpers for checksum handling
Date:   Wed, 1 Feb 2023 18:28:45 +0100
Message-ID: <8a872e0265d27f24a65167924db9cc99b1c7ea51.1675271084.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675271084.git.petrm@nvidia.com>
References: <cover.1675271084.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|DS0PR12MB7928:EE_
X-MS-Office365-Filtering-Correlation-Id: a60373f2-1b21-43c6-74cb-08db0479eed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w79VMD2pngdsruxpmZpH+w4NtEtVzEbc4tQUIyfyDcCJp6oVsW87iqFUG06m9svyLs+O8TAf4YrbheUXp/nj2dGVRH5o/XbICby9E2pjirPIw9OFSYxjgUvibH0qWjEmdKKqjLQFWhHHXFnIYZcTNx134u4SwFKHpRMqkEYygxLv0JKIcIc5WnvDKMMXrQvCgXjXCg8Y0leIJISj0vy3/RmVIh6rkNcY8EdWTgTYlI0CSDgPgo9BMTAy8YIUs11+Rw5o80q9LlJDxTrfqBDBOQ5Iahtk5hx+91bZ9KKdwgs6WvfMWLrXNKcNtuU9rzkEAiFi/J6n9Q8ko27jc8B8PSeeODTAl888Ia1ub5nNCAjnJzCYy98ayaN5NfkNZpqPcXnPMszULwiraT4Nrywf4kdxIAMQwYtoqD9cAfxi70vFZkZ6z/mW2gbdUmGhypw7EavNNOAkz5K5b9L2pvHS7PSLTuZxedspl1gx93SxH5SOCdHB7drj4gkdfQORAfM6MWSOtRUqLBN7Hlezmu7/FeG9H12D0mtLEfMDxL4shzHoOGjuUd4rs98+Zuh6MFlC8wI3ICDZ/RO8Tmd1RlALfuz5RQY1/GSqYxwzGEuGoAHSN2Fb4Js9T/ZiZJI1d2St6YuxgauID7qJ3b5AbvEdGZYibhsAA1lFmChqETC0PFq8y3uIEvz0W9i7WFFmBtoJm2JRsRZbTIMnH0I+QIazeQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(6666004)(83380400001)(36756003)(426003)(336012)(2616005)(47076005)(82740400003)(356005)(7636003)(82310400005)(86362001)(36860700001)(26005)(40460700003)(186003)(2906002)(478600001)(16526019)(107886003)(4326008)(8936002)(70206006)(70586007)(41300700001)(40480700001)(8676002)(5660300002)(54906003)(316002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:29:54.5349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a60373f2-1b21-43c6-74cb-08db0479eed2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7928
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
helpers to calculate the packet checksum.

The approach presented in this patch revolves around payload templates
for mausezahn. These are mausezahn-like payload strings (01:23:45:...)
with possibly one 2-byte sequence replaced with the word PAYLOAD. The
main function is payload_template_calc_checksum(), which calculates
RFC 1071 checksum of the message. There are further helpers to then
convert the checksum to the payload format, and to expand it.

For IPv6, MLDv2 message checksum is computed using a pseudoheader that
differs from the header used in the payload itself. The fact that the
two messages are different means that the checksum needs to be
returned as a separate quantity, instead of being expanded in-place in
the payload itself. Furthermore, the pseudoheader includes a length of
the message. Much like the checksum, this needs to be expanded in
mausezahn format. And likewise for number of addresses for (S,G)
entries. Thus we have several places where a computed quantity needs
to be presented in the payload format. Add a helper u16_to_bytes(),
which will be used in all these cases.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v2:
    - In the comment at payload_template_calc_checksum(),
      s/%#02x/%02x/, that's the mausezahn payload format.

 tools/testing/selftests/net/forwarding/lib.sh | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 409ff3799b55..b10c903d9abd 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1730,6 +1730,62 @@ ipv6_to_bytes()
 	expand_ipv6 "$IP" :
 }
 
+u16_to_bytes()
+{
+	local u16=$1; shift
+
+	printf "%04x" $u16 | sed 's/^/000/;s/^.*\(..\)\(..\)$/\1:\2/'
+}
+
+# Given a mausezahn-formatted payload (colon-separated bytes given as %02x),
+# possibly with a keyword CHECKSUM stashed where a 16-bit checksum should be,
+# calculate checksum as per RFC 1071, assuming the CHECKSUM field (if any)
+# stands for 00:00.
+payload_template_calc_checksum()
+{
+	local payload=$1; shift
+
+	(
+	    # Set input radix.
+	    echo "16i"
+	    # Push zero for the initial checksum.
+	    echo 0
+
+	    # Pad the payload with a terminating 00: in case we get an odd
+	    # number of bytes.
+	    echo "${payload%:}:00:" |
+		sed 's/CHECKSUM/00:00/g' |
+		tr '[:lower:]' '[:upper:]' |
+		# Add the word to the checksum.
+		sed 's/\(..\):\(..\):/\1\2+\n/g' |
+		# Strip the extra odd byte we pushed if left unconverted.
+		sed 's/\(..\):$//'
+
+	    echo "10000 ~ +"	# Calculate and add carry.
+	    echo "FFFF r - p"	# Bit-flip and print.
+	) |
+	    dc |
+	    tr '[:upper:]' '[:lower:]'
+}
+
+payload_template_expand_checksum()
+{
+	local payload=$1; shift
+	local checksum=$1; shift
+
+	local ckbytes=$(u16_to_bytes $checksum)
+
+	echo "$payload" | sed "s/CHECKSUM/$ckbytes/g"
+}
+
+payload_template_nbytes()
+{
+	local payload=$1; shift
+
+	payload_template_expand_checksum "${payload%:}" 0 |
+		sed 's/:/\n/g' | wc -l
+}
+
 igmpv3_is_in_get()
 {
 	local igmpv3
-- 
2.39.0

