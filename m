Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012961E8DCC
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgE3E1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:08 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgE3E1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2pLI3xbtjcYxjndQDVCKvpzgLGc602VJUdYtTacNNbM0D0dKs7B21va7TWxuY/k+8Wd8ebXEECY44z0vVlTYV/38Ev878/haLviFeU1lqg+MIrRIp4ZxHciSqRaYjo78jKixFvb7V0+7dkh71p06abt4EWTqa0xkEYN1fwSxekkGf/F8qUu0LTSkcF1CkmtXSlkq2m7yEt+qn9zW280vxJR4wTQJ3LDXLSytPYAPTNWvZDc9oNbCx3nXriVzONAekxMP/+nimTRW2DxPkcPjjzLGBsUBft+nFPTQP3XTWnX/yZ8x39tlsQwXHVnAmto7zwuJyyGCuv+ovOsmUQ2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nCzvAleViq4OoMfg11dzbMyV0VV941Pc7rK/1Y7guw=;
 b=jjHP0H7rqFfol+2cGJrqZai06qdZBut4w8bjni+p63MjRVzj3+hsgEf+Ozf1oGJygRZm6+co3dFvRjM+oNs0uNynMW3ByCxSZFlPjORK4z+K/fSOzcbVwNnasdqFkJ8fQ2Q3f+E6/Y9lfKHOkWGNENqOK8EMCgAWeGssCrCZ1pExH3DDm2gqG6MgH1oHzlOwT8Lsf/wWfeJmwJzasHeYejuPuobNs9Q3dTlEOWu28yHwJs4N0YcVM+fDt28jkbjcvAGwgL3J4ZvFIcSCw7SFQ5fZ4VgcbvFVJ7kNZZjghJiVusEXKoo/Yk17jK2XmJSESvEdoqdyNdO5Dgj7B5CC1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nCzvAleViq4OoMfg11dzbMyV0VV941Pc7rK/1Y7guw=;
 b=eHiHa7FiT02WJ99Kvr4YDdmCzlRfMn8j/seGrvFvjJi70vasSHW4VuhNxuBhvwT6uolSVhCkieB0q1RHaJO+EzARiFPw+qkDwWyi0hXHSkmbzWhDHBOb/UaCPL/KI9BVZVqQqyd3Mz4O8Y7+Ak/bpqo8HaFyeXo7/JPD6jL4YRg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net: Make mpls_entry_encode() available for generic users
Date:   Fri, 29 May 2020 21:26:16 -0700
Message-Id: <20200530042626.15837-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 14bd5d52-5ddd-4757-b4f2-08d80451b114
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408207A0DED6EB4AC1E04B5BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MiKIG2p8vMtqQgaaZ6fxbTFW+Y2W02d/dvtv8d5dglzb8EHi/ywZVs1hEatamEwtzj38UHLzpQxf1fOcgR1eiY8i4X1t7JbzkX5ByjPfTxpygbR/xxtd2I6gMomIyQFmOGmlfP3OilYOIRagpSv0ITnuxpucpU6Pf8VmQFhhpjzboRNN7tL5s5KKP3IIn0J6vZvGracwexh1QcVhdUdyFZt6r2u5O/n3ELjhPxsIbkonJ/zmmhIArjbE3mz1uDg9yT1gA+c92EoIbOrLaFJuMspjsnB1gd9OZYHfct1QAx1qEmXDNlraepJQ2V0OLe+8wLi9lHhf6/DOHsjnm99L7GFkq3x1UpQn5eg/J4E2Vn2olUjoVFpXG7DgiesBdIdOMq/OUMvHLmd7YnjI+ddAYu8HCGFeMeFyiHIz/efqukPcEO3SzMMGB60cApBO8ITRMlKR67iKXEeDTHRWk3+jGR7p3DXJzG0Mmw6WKpMN3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(26730200005)(41533002)(54420400002)(19860200003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LBwEWhPwtHUl8DBhXn3oyxUfaQd6Pdb7jaqad90se4jxsgjjfFFQj4uRwx42o/Xyo50uJOzbibaNNQbQtqGZ2NBaaxpStvJuQH96IDIipCX9Fm9WK/qZsYGehfH1v38BXIZrpxzLmBdvYgbuJjFrhNPccxPEylth3LAd+N35kowGt2sX7cznWhVQ0xbJZDsOr09BQlyheLMPENUl4dWBJeswJ8aEWHbmFkJzGeNRh1mjp3KNf/D4ewi+4XU1plJbDBLCSi2p1qod4rS8fADoLfBTCtaYLv9NZmz4pas1KNhspD0oD7E+M451TXTfYG/Vekr2Fe9uOUtw134MDU7kiJx74qO9ROZNj0Q2B8nhw5mbNcptFsY79y5sOmtRSKGf2RS7sM8Y8VvgUX4lD7jnXanWpyS3ntWHQFQUotdVMxf8mYDth6A77jC4xCayLfz/YzmQ7wTwsmFyKxXfdhUgEo0OUxy0lDkDehcUWNk+c3w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14bd5d52-5ddd-4757-b4f2-08d80451b114
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:58.4970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pqhz7ngqumtKZ21iC6ZI/Dwk0Mqkg2dS4Rd7e977Knj5D3jmZUOaTsUSGBIu5iqGLaqp+ZPqWtv7zfKjtQ8Bsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Move mpls_entry_encode() from net/mpls/internal.h to include/net/mpls.h
and make it available for other users. Specifically, hardware driver that
offload MPLS can benefit from that.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/mpls.h  | 17 +++++++++++++++++
 net/mpls/internal.h | 11 -----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/net/mpls.h b/include/net/mpls.h
index ccaf238e8ea70..0bb7944e7b083 100644
--- a/include/net/mpls.h
+++ b/include/net/mpls.h
@@ -8,6 +8,7 @@
 
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/mpls.h>
 
 #define MPLS_HLEN 4
 
@@ -25,4 +26,20 @@ static inline struct mpls_shim_hdr *mpls_hdr(const struct sk_buff *skb)
 {
 	return (struct mpls_shim_hdr *)skb_network_header(skb);
 }
+
+static inline struct mpls_shim_hdr mpls_entry_encode(u32 label,
+						     unsigned int ttl,
+						     unsigned int tc,
+						     bool bos)
+{
+	struct mpls_shim_hdr result;
+
+	result.label_stack_entry =
+		cpu_to_be32((label << MPLS_LS_LABEL_SHIFT) |
+			    (tc << MPLS_LS_TC_SHIFT) |
+			    (bos ? (1 << MPLS_LS_S_SHIFT) : 0) |
+			    (ttl << MPLS_LS_TTL_SHIFT));
+	return result;
+}
+
 #endif
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 0e9aa94adc07f..838cdfc10e47d 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -172,17 +172,6 @@ struct mpls_route { /* next hop label forwarding entry */
 
 #define endfor_nexthops(rt) }
 
-static inline struct mpls_shim_hdr mpls_entry_encode(u32 label, unsigned ttl, unsigned tc, bool bos)
-{
-	struct mpls_shim_hdr result;
-	result.label_stack_entry =
-		cpu_to_be32((label << MPLS_LS_LABEL_SHIFT) |
-			    (tc << MPLS_LS_TC_SHIFT) |
-			    (bos ? (1 << MPLS_LS_S_SHIFT) : 0) |
-			    (ttl << MPLS_LS_TTL_SHIFT));
-	return result;
-}
-
 static inline struct mpls_entry_decoded mpls_entry_decode(struct mpls_shim_hdr *hdr)
 {
 	struct mpls_entry_decoded result;
-- 
2.26.2

