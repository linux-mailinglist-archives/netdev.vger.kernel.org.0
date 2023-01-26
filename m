Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C067D276
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjAZRDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjAZRDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:03:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286FB6A719
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGrDCEdKOFeUK/OvYK5fvZkuVkQVOMutJp0QQ4jLDYldVCfGyvMIibnu4UIiqe4vyzjmcXr5QK4GEPVY7pLzFUkrPS09bAQKQmbUoMTJcZxsaLgMe+AVFDey+x3h+20ne6Gynij0BOdF0FyUslYWVQCGVWVgFylOIgycbA0UfyxktM392Wi8CLKevdjouHJF6LItYre+U/MbzkM/CfGEBs8RRwDrNPE2Grd7tfCrm2rWG55EHpzJ4H/rnfreRaMhWsscnq7bu6i5Ty8P3c9c50bhy/nYQz6WiBBOsy/GSYou5Y6TF1FykZ2r5Q7Q7t8PncfRGDmTIFp7DILmaQoidA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIM+3otTgFugyx6C+vl7QLSRnv9AVtN6G5jeT39O2xs=;
 b=VuQ2m6iTv/t7d4/G4WqQ5x+U+uvaSPX1WjFiU1cmf8RVrydlQju4cwP3bP1qbKj0Hx71iJoIZbMVOIswq/838vcRyy1EBdJxu/y/XZFkljhdqHoIeI9RtkQTnwNxTonFDVX8Cz1XbUwbwC9iugEgcqRTgwwVFE+dP4MqLDRUtgmxX1T8wZSufOMhPoNgDz46vrToHsQpuDXMl8UdaM1+KVWbM3cnk5VlNcLy/H0l6HeCh5ekdEErrCMSOG6UtAIC1xu8iH+REYiYADiwIPlqo6YMlfD6tQbAEUEb2nFm9dRi7IksM6qMhnImGl1w0KndSrOtuD2VMvCU8elDlw6lGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIM+3otTgFugyx6C+vl7QLSRnv9AVtN6G5jeT39O2xs=;
 b=oNecpv/WnQVjxz06uR0AhaUf8TcW4KhRiJnJva3fYTptslJD30M3JKVbAAev1Uyf3f8R3PbBkbqQeaoXy+LMQ2a+mLcNr6/OkCTIVJd3PdE5Ew2i7jnuYpFeMlDbsPgzCTaqKcBIbO/sg89n9GRowAEYgipww1BmSZeIOPFLHfpf91BwNGOHidikgup+fg+N6zckYm9+la15D5hJoJECApZgbL+VagE2Kvdn0FiZTcbxNU01PWUppJ6lRGXxqptXmSVrTQyrnKXJRESePau0yEVptwy2QzQOm/00ByjD++O3Z+usIiQYOI08m0AZgMqgQaCP1AXmHWDb/Erg/RS2Kg==
Received: from DS7PR03CA0323.namprd03.prod.outlook.com (2603:10b6:8:2b::12) by
 CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22; Thu, 26 Jan 2023 17:02:35 +0000
Received: from CY4PEPF0000B8EB.namprd05.prod.outlook.com
 (2603:10b6:8:2b:cafe::3c) by DS7PR03CA0323.outlook.office365.com
 (2603:10b6:8:2b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EB.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Thu, 26 Jan 2023 17:02:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:23 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:21 -0800
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
Subject: [PATCH net-next 12/16] selftests: forwarding: lib: Add helpers for checksum handling
Date:   Thu, 26 Jan 2023 18:01:20 +0100
Message-ID: <3ca0fe4de1f701befbc874e4b672c90aee602199.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EB:EE_|CH2PR12MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: ea39db20-e513-4205-c197-08daffbf1f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 271H1ZY6/9rePf9l1LfBJiKAVKkeXsx+V1pCNuZeduzfr9UB6vv5dMxjfsscIn9W8t8rK1N04sIA/QFqUU9hR6EGrgvdFVvpjBira7WJk56xgCxwcZnbGnRwby5AmE+HQSNSbDe/M/OueE6wdmtslzyDZpw8zS9j3IOYt6t9+J7PG1qNV7Qs32MbLwuA+yepCWGZPRjNskkXswrtD7nqa64IkOENDkkYiVQfnlK0LO+d7ntaV8mCY4aUa5wC+QO6Wc95CxwIl9b4PEDlqqt5skOeO2V7zQpGllN2Jb62X4IesGYW2FwzZ2qq+jFtEFBedAi0HOjtYZphOu6jOFqRvV7NOWMUKECn9QlubWBM9UujZXP0EFYqnhpxIx/D3xzAPWujii7/ZD/BUcTDvZh+tdaF0e5kCZiQ0UETFRhJafPH4Qny9Zvrd8XW8XvhODn87pgTWtiQON3fl0KCVyj1gIxv/DrLFNClhWCvIidMDoBwBAi44N5C1r9cxUClGu4FDjA6sbbt3caHOvQ6bz8OaSZE2lDhMZGixWl8n1vrMSkUNf56MPS2gs914poXkOEpEuyA6OSwf/H9aYdw7TpFx/vofWZUnPCmpl+0B1fUzgKzUDpzXjqJc6nJ7Vx4Z8Y4YQlA0QR8FmPshv062AjWnPgDqqOcqbBlluTtuE1Su4yIX+Pfh7GtPIX4Kp1fhL16DjWQRavOWTX0cqTt7uHvKA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(5660300002)(356005)(83380400001)(336012)(426003)(86362001)(40480700001)(40460700003)(107886003)(82310400005)(70206006)(70586007)(478600001)(36860700001)(2616005)(186003)(26005)(16526019)(47076005)(7636003)(36756003)(316002)(54906003)(110136005)(41300700001)(8936002)(4326008)(8676002)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:35.0860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea39db20-e513-4205-c197-08daffbf1f20
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070
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
---
 tools/testing/selftests/net/forwarding/lib.sh | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 8f7e2cc8b779..1c5ca7552881 100755
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
+# Given a mausezahn-formatted payload (colon-separated bytes given as %#02x),
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

