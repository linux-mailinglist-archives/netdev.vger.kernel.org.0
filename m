Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1516885EC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBBSBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBBSBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:18 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FAC6E43C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:01:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kvr+WmcIiA5D3E4RygKwteMoTi5UqIPrlLGjzM4RXKBxk2bV0iLPLbtMvVqMZIZREHo496NDvX/c8BC8FrDaWujUMPvofulqy2mWOgLZq2zdc+ahVJxHaLhFdLMkMT5njSGXa4r5rpvmdPUcEYnsXpcaFHBC5r0xPfYxDG7jmVRkp819vvgWxG/qbwu8DUJizQR7TRbAibDLAdiuWSorGsxEJ+Tt8Jzioy7jnCgXLoJifoGK9paoyCI5l3QjHTfhBgb+Y1NErPF1X2zgLipMPAUZyjvEF7lmdj69ySC0+huznNOZj1oH+63GHdzGH/FkmAOxrTu4/ivUHiNDTh5iEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MROtKWGbipv4CDcfkKeuKVdzrhFbE3TSfqwMPue0fXY=;
 b=U3eAmFCwmVhz5miNEwXPMzmyOLYGLInHSuYgJhyxQ9NxjZS1oIUG/vTT6UKsOJcI2bBgwbHHZjkqJe1HsLyBZ0X55FOMkr73DAnxXOYPooerAJ65DrH3UNW7pzihp+AU/729IMdzaw12jZ1eM/UwSBZrIZ3m+0ktZ6OFSpp05ML1vPTlx/vBCQIhVY/jUZtyBURrshcqlNF+RZer1K+NzDK+tidCGRR0fSUW09sV3tZ2Vatijy8WHvh8L42NkNwX5KB5hLHSOMOVqHliOSry6tR9S4qRuEXbuLdA+/7cPGzrsz7TC7smFZvkF8or+UILhikZzE9UMmbax91TRJCqnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MROtKWGbipv4CDcfkKeuKVdzrhFbE3TSfqwMPue0fXY=;
 b=QFZfcRpPINr29Eeb/btvqQnVs7Yc84RTmIxlKzj48W4CL6hok1Tb2VTrjoTzu1KkD8Zq7FYkoRyo4TP2Qt4kCVqyokv1flMOS5an18J+rqzI7oDS1sMw3cEWUftVTaSz8J7xlMok24s42HUyDxHCSz6YbU7fSxTogWASWpXFk6U9BqUjvcQKnWuUV5XBUpJSd2xA5U/rT4uraZ1E0TLToLHG4zBCQMlWAjNMkjB99nq5OXXVuMzYU7vBgLBMqxbTfyeJTQOPZPfZ6usu7Eprrg2kJpZKN+YTU/qvkw6JgXRGC/XzTooHfOwa7fXLDigCPuisrkDhSYxQzuS0EKVQUA==
Received: from MW3PR06CA0010.namprd06.prod.outlook.com (2603:10b6:303:2a::15)
 by PH7PR12MB8037.namprd12.prod.outlook.com (2603:10b6:510:27d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 18:01:02 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::29) by MW3PR06CA0010.outlook.office365.com
 (2603:10b6:303:2a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Thu, 2 Feb 2023 18:01:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:01:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:48 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:45 -0800
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
Subject: [PATCH net-next v3 12/16] selftests: forwarding: lib: Add helpers for checksum handling
Date:   Thu, 2 Feb 2023 18:59:30 +0100
Message-ID: <3a152b0cf376dc1defd99d7aa78da1b409e31f4d.1675359453.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT031:EE_|PH7PR12MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: 83887f5a-7bb2-4b74-9adf-08db05477245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGaj41D5YqheZ2w4MRnwSkA8quCL7rltciX9vEtB2dEjk6re1fEew98Z850GkuhV0Js+CcjfXA0j26UXJx5kaKLQSSY47NG78jsHlggYCKQAXBQIsjRVJad1C2RSK/rtSBUMUQZisGfZBwYHVLRM/MdX1JaltUFOSdfb1Ojxp/wAfmgPE0S4JLKXRjn2DihZwQlSbBFHbbtm+WnLT6w7IgX1MToXmv+uqmb5VrG3B9TMzPapUS2vuAV2vXrJP5CfsbOVp8b22MKr58jeuvswJmoqpJEdeY7v6LkNk6OXRg3+E2ExwdWl3V7S1CZBnaqjk5CZspigDe75AGzDek7rdq7AeG2wcTQB4WShtGi6mJTShHEsN8iEyWx7FN9V19wuaIymSOcgHFlt97dp/26mL+O59hX0MzaiaatG1fuS9iRNJ0RHGGi/3YGm76MAnimhO7ceprGrasDeN46jo3+u8tIXO/sEWoAL2QTtihYtOz1JW5CRpAw+mltY5eVXpxnrLL+5uMkIUnpwgb33Xa7tYe3OCFyZmhdLalDtze0uHBuu3aCKe6a8l9/s6StSxeFEHcopV6A36B0WR0To0tzo2gL1sHv/XtLNIYurJn3ACT3idaHJ0f4tACyXzIOeKPg72wC6zRLwEb/L792+dY+Rf01DtBLcesCHUCcRXGiceHTlGTWeLb//CHAJDEnXO+989WuKbJ14Cw2i+yRu3hmnaw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(16526019)(7636003)(36860700001)(107886003)(186003)(82740400003)(26005)(40460700003)(2906002)(356005)(2616005)(6666004)(70586007)(426003)(70206006)(8676002)(47076005)(54906003)(4326008)(110136005)(478600001)(316002)(336012)(41300700001)(5660300002)(86362001)(8936002)(82310400005)(83380400001)(40480700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:01:01.9475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83887f5a-7bb2-4b74-9adf-08db05477245
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8037
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

