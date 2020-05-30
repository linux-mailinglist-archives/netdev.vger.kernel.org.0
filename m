Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB94C1E93E3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgE3VKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:10:08 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:2551
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729350AbgE3VKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDlaKCBQZNVWIZkJLwu+iKUKIJlRvaob93x67LZyg5FOUsDM4um8GjGXbTUgvgelogI+IwUPUN5/bYCzrbvO9xlrj78Y6iz1ZxPFYNPOJbVEMiySuBTt2642ZgIB002hKG88wvgGKicAgLdVuy6sBEon4tVmvB3GkdN4ILv9QgEW7GXZxz/jQd7qqBWdND3St+xoqA4dPt4TOR9gmWpWfOvuh81liIZoyQg8H1bzxkw7bn3JcnGwx1xnAxZGobHp59lX5XKkSqpSigmiQaDlynfjmxt1FOaceAQBcjYk6lzYs3EVnHVjvSeEoNQWsTBMFMD5TssdeplSLXcRYaPJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAacTTIAVE1iRs8T+/NR6u36+J9GkX8l3jSEGqTfOz0=;
 b=OMFpYdff+055A6wR5h6md0M5cV1ci4N9m0Ww9J2xSUiCFPCJjcYnCjvsPEZiwDqhMojJvgev85AXXuhIyW9wb1axC5vQcA1thXuuP0lxcokuO8Ebcmoc5SH7Hd8vdfTaPWiFZDLG4CyymJBk5vcGN/b4CxNZmtIwRBHtFWdq/vRJdQBasHRMBb1jpUTofw+AY8wpw07lT1MGOgrDbAtUzvrq94xwSdRXPNkz6fE8Mqe7b2zZjTu9SasLgjbQQgiunatw0BzcxRrECeL99j38ZDyE0DAEPpidj/JtXz6rN6Z8hTZtqdfG8wmOFSzvNvm2a4wL4eVokW7XGvXSE2p4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAacTTIAVE1iRs8T+/NR6u36+J9GkX8l3jSEGqTfOz0=;
 b=sgabmGT9lEfIlP5w9Ln4y8O1AU1KNRzkfZ7I+YHLU+3P5bLtBGQ2WIhWN1tdugejGY54LPdoYqOITT15c/C2dVUfHN2kBKwNDzB+qxMoXZ8z5f7bn8xEaz8c8v9fWYdk78kRy6rJioQ4yLVce+F4PBzrliH9f+deEY1X5PzJMds=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 21:09:19 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 21:09:19 +0000
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v2 net-next  3/3] selftests/bpf: Add test for SO_BINDTODEVICE opt of bpf_setsockopt
Date:   Sat, 30 May 2020 23:09:02 +0200
Message-Id: <3f055b8e45c65639c5c73d0b4b6c589e60b86f15.1590871065.git.fejes@inf.elte.hu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1590871065.git.fejes@inf.elte.hu>
References: <cover.1590871065.git.fejes@inf.elte.hu>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:803:14::29) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.133.95.17) by VI1PR0202CA0016.eurprd02.prod.outlook.com (2603:10a6:803:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Sat, 30 May 2020 21:09:17 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [89.133.95.17]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ab494c7-995e-480e-e6b7-08d804ddb708
X-MS-TrafficTypeDiagnostic: DB8PR10MB3034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR10MB3034848581D0EB1DBA7CE94AE18C0@DB8PR10MB3034.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVmTdlu5D+rWnNBqq9xVovk8MaIEHJTHV9Dm9q/ch7Y5W1qVWjozJvnuLT5n/KlzoaRKAsfnHjcSqo+xIgLSsPe+bDjoUIpHdDLku1xRLrFYxzHGDqHyhrjuiyVX6oWbXDkuTgwlEp7FpXilzOAbVRyB7jXENyhcDypCr1qpfy5etx11ujEP9h0JsdoJZC2RwYst/gjBprG3rDvpiwUNy6DrMgvNs7KV5m6A42bcM6/f0beh+7BpnQqybuRPKJghu+Wf4PHof7oc+sWcoztdUprj5YZCo9C0M58tQXnQz0v9iSJ68Z8hhNWXm7yccXnlggf6TiJVwrRqHDSPBG+SEEsqUCwZpBPeoGL/1hz8OZ1N2MJ8fxUDJGWHbTEK7EB+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(66556008)(6486002)(69590400007)(66946007)(66476007)(478600001)(83380400001)(107886003)(8936002)(6506007)(8676002)(52116002)(6666004)(5660300002)(26005)(2616005)(6916009)(316002)(956004)(786003)(86362001)(4326008)(2906002)(6512007)(16526019)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XQygPbk2buR3hfCUIs3ZG6gP3hYPmImqr2DcKOAvsMBl2IzbnzrSwwkuinzj32c89l25YSQ6aELWOkPdZ9byjKS6kN4y7N0um/epCVQBwhZIUjluRgcONImVMmwrCb0M0mgnimqmIS7HKaDzU/bYpKEJHZEctNLh0tNLltZdwiaJpra9J8zGEJocdHZTB0c85VNd8x/kJkXELON/wgqebK4ycTkX8e3EsZ1LvjNpPPXaWPvE3Bu93Jh2iVTj14g/1nVWlq8iexT/L6U5Fue4sWO9/84pkoiaP1yRwpCx0vW7HQPAbG/LRc1QQY5Pl/kuFYAzgoaMrr3vPfibVLuQTW48h1FGVp9PE1Hn18T0HduqREOMMGRgG5BjelOf+cvkGcsQ3quleuDmUunW4JSsZG3uRFM/Fza5Yhr7H78mYnbgM0hv4bja3ZgNtpYm2oGfTRNacQJGVP7JP4Lzo0z3hhMjTq1ZvfHHTcyvPeURBY4=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab494c7-995e-480e-e6b7-08d804ddb708
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 21:09:17.9191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHKHwX3q+gh7j2GD5poG3Kw3mXaQK1lMhlZ41Idsqw+/pebXDSY0/TYolXApklzl1ytyggUwEV+Hs9yoVAsSgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test intended to verify if SO_BINDTODEVICE option works in
bpf_setsockopt. Because we already in the SOL_SOCKET level in this
connect bpf prog its safe to verify the sanity in the beginning of
the connect_v4_prog by calling the bind_to_device test helper.

The testing environment already created by the test_sock_addr.sh
script so this test assume that two netdevices already existing in
the system: veth pair with names test_sock_addr1 and test_sock_addr2.
The test will try to bind the socket to those devices first.
Then the test assume there are no netdevice with "nonexistent_dev"
name so the bpf_setsockopt will give use ENODEV error.
At the end the test remove the device binding from the socket
by binding it to an empty name.

Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
---
 .../selftests/bpf/progs/connect4_prog.c       | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/connect4_prog.c b/tools/testing/selftests/bpf/progs/connect4_prog.c
index c2c85c31cffd..1ab2c5eba86c 100644
--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -9,6 +9,8 @@
 #include <linux/in6.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
+#include <linux/if.h>
+#include <errno.h>
 
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
@@ -21,6 +23,10 @@
 #define TCP_CA_NAME_MAX 16
 #endif
 
+#ifndef IFNAMSIZ
+#define IFNAMSIZ 16
+#endif
+
 int _version SEC("version") = 1;
 
 __attribute__ ((noinline))
@@ -75,6 +81,29 @@ static __inline int set_cc(struct bpf_sock_addr *ctx)
 	return 0;
 }
 
+static __inline int bind_to_device(struct bpf_sock_addr *ctx)
+{
+	char veth1[IFNAMSIZ] = "test_sock_addr1";
+	char veth2[IFNAMSIZ] = "test_sock_addr2";
+	char missing[IFNAMSIZ] = "nonexistent_dev";
+	char del_bind[IFNAMSIZ] = "";
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+				&veth1, sizeof(veth1)))
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+				&veth2, sizeof(veth2)))
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+				&missing, sizeof(missing)) != -ENODEV)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
+				&del_bind, sizeof(del_bind)))
+		return 1;
+
+	return 0;
+}
+
 SEC("cgroup/connect4")
 int connect_v4_prog(struct bpf_sock_addr *ctx)
 {
@@ -88,6 +117,10 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
 	tuple.ipv4.daddr = bpf_htonl(DST_REWRITE_IP4);
 	tuple.ipv4.dport = bpf_htons(DST_REWRITE_PORT4);
 
+	/* Bind to device and unbind it. */
+	if (bind_to_device(ctx))
+		return 0;
+
 	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
 		return 0;
 	else if (ctx->type == SOCK_STREAM)
-- 
2.17.1

