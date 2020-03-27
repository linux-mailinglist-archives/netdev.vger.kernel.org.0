Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38406195D37
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgC0R4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:56:02 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:40096
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbgC0R4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:56:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReRltED2POprwCqXmM9iQryMXT8udb4xLx/DswaHHDzZac+3LW85Flf/vabPYqcfhKNmc205CYIewfe1APUepUYQMKrFFs/s9/Oqpe3KNW2LWJ3myOTWQTOpi7LIvayZbkKk52yK62gTM8zcJRN3wmR23NJx0RdXMImgD7Dmn+Yq3B3pyrxo8TPmaf9svh7+bvOXmARWyuieQ2krrmI4kMGhlNspDgnMgDcsvhSKKaR4kWiGjhLO/K7Hs2fyiIfyOwmSbZ/juFK/i7wikVNSAPZ0V2QAFH7dTVGZwS8uktUSyywoWB4YrOo1tSu7335nFhhbKgM78Z85X1ImmRCd2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCBfYHPnT/xIhsNGGAmW4YpwIBF5vCgBpsAO1lKdHg0=;
 b=hJ38BQkg2Kq2bqIzRzEvzqa/25DoN0CKENM8/MZu7snADML4IsGUfoZLNYOqA3l6wFCYHNhg9vgKwn2RAx9cDDNLw/0+hielfrRnXbNHj2YWPvIvEcKvze4pOekQ6kycTJuYCBgUHmngt4iPhxgL1K0mf97T9s1UMcl1qJ5TcxTx2JXZt3oTdO6YZS+veezHGoglM2u+4RJJPGfEiVXU/FcJdu70JDfTLcCmQt0BfSdLSoQMhS2LXO/i4QwtpSCYHQ0NsjxXpmE/SKscsPHcGLGTfo67nDvLcaOTml9W3TJvncz2IiDzi6WAMvSXstYhueeZ6zx8glLvbxcDif8YZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCBfYHPnT/xIhsNGGAmW4YpwIBF5vCgBpsAO1lKdHg0=;
 b=F9ZwykGSCspKmuh55ZdDol02fy+mmCofhjgaFjImazMt4kVvMVD5jryIoq21d5pGwhpbKu1AGLVsQcISlywo0Uwbni7j42xloG+RE6LwYqcQql4MD37eF4AcWZbUqD9yluc9JBXc8NW8XMzfF0h4rcRS01s3ERuQhhdlUj9Ks9A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3402.eurprd05.prod.outlook.com (10.170.244.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 17:55:56 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 17:55:56 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 1/3] tc: p_ip6: Support pedit of IPv6 dsfield
Date:   Fri, 27 Mar 2020 20:55:08 +0300
Message-Id: <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585331173.git.petrm@mellanox.com>
References: <cover.1585331173.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::24) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 17:55:55 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c73360c2-c6ba-462b-5bc6-08d7d278197b
X-MS-TrafficTypeDiagnostic: HE1PR05MB3402:|HE1PR05MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34022141D32A65807A2354ADDBCC0@HE1PR05MB3402.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(6916009)(26005)(2906002)(66476007)(66946007)(6506007)(8936002)(36756003)(86362001)(5660300002)(81156014)(6666004)(6512007)(66556008)(8676002)(81166006)(316002)(186003)(16526019)(2616005)(956004)(52116002)(54906003)(478600001)(4326008)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOSqilePsnYNbkNu1HGVVKbQPF1Ss+E/nwTu0WV4XP5QPS2trWVqN3WUHJJPbgcvtcpjE859PjO90VlKWKVzt9O81dB06KsRaBFmY6jPk2oPWfcAWZndHfNLtvP5vuxLfLsmYS+za/PXmsHtbfMAE/8DzD0god5/J/TNkDENAENWP0cGWyWHNMzmDqCXuLqIi0PHP7ZrPH6+ZTcz3h4ZPU2Qu0CK1hd0G50ilGWRM0/z948Tiu4c1i1zQBvQS06tHQHhLx2FDmZMPlLsrw3eZwr6Y9Jdkfzx895Bo9dFawZmwGuqHsCpA7AfD6hYA6Vw61ZFreA1gfUkvO2l3tLtzhYee21t+K073pU7V6HmxUSeSKvkVtri363H6jFiA7+MiyVp42wbvpY3PXlk77P3y6KRPRVeyGuCQJfZwvurlN9OPIcSiKQBqlvWpQYkavCg
X-MS-Exchange-AntiSpam-MessageData: 5g5DzerSliXfyH1luanDAZdi0JV9Hw7FdHOLupl+jCtSdgxLoFML92HnWZxZ0v8D4ZdvxVbDco5u4/QqwG4+b/7F4WIE8sBSjWHyE43RrICJxEjyWzBk7K+tQgM/1Zqd5jj9Mq0eur2HkD1Hz8T4Sg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73360c2-c6ba-462b-5bc6-08d7d278197b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 17:55:56.4336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlDYBvAFNFbn5GXfzX15SFOK81O2Pj6UtZUJO7mw1ZJv7q9NmXNhRZbNAbBxY9pLk4+KNeDkhiE2ejf3/VzDoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support keywords dsfield, traffic_class and tos in the IPv6 context.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-pedit.8 | 14 ++++++++++++--
 tc/p_ip6.c          | 16 ++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index bbd725c4..b44b0263 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -60,8 +60,8 @@ pedit - generic packet editor action
 
 .ti -8
 .IR IP6HDR_FIELD " := { "
-.BR src " | " dst " | " flow_lbl " | " payload_len " | " nexthdr " |"
-.BR hoplimit " }"
+.BR src " | " dst " | " tos " | " dsfield " | " traffic_class " | "
+.BR flow_lbl " | " payload_len " | " nexthdr " |" hoplimit " }"
 
 .ti -8
 .IR TCPHDR_FIELD " := { "
@@ -228,6 +228,16 @@ are:
 .B src
 .TQ
 .B dst
+.TP
+.B tos
+.TQ
+.B dsfield
+.TQ
+.B traffic_class
+Traffic Class, an 8-bit quantity. Because the field is shifted by 4 bits,
+it is necessary to specify the full 16-bit halfword, with the actual
+dsfield value sandwiched between 4-bit zeroes.
+.TP
 .TQ
 .B flow_lbl
 .TQ
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 7cc7997b..b6fe81f5 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -56,6 +56,22 @@ parse_ip6(int *argc_p, char ***argv_p,
 		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
 		goto done;
 	}
+	if (strcmp(*argv, "traffic_class") == 0 ||
+	    strcmp(*argv, "tos") == 0 ||
+	    strcmp(*argv, "dsfield") == 0) {
+		NEXT_ARG();
+		tkey->off = 1;
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+
+		/* Shift the field by 4 bits on success. */
+		if (!res) {
+			int nkeys = sel->sel.nkeys;
+			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
+			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
+			key->val = htonl(ntohl(key->val) << 4);
+		}
+		goto done;
+	}
 	if (strcmp(*argv, "payload_len") == 0) {
 		NEXT_ARG();
 		tkey->off = 4;
-- 
2.20.1

