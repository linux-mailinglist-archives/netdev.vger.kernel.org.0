Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5784DAD7D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354886AbiCPJaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349506AbiCPJap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:30:45 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2111.outbound.protection.outlook.com [40.107.215.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353B76541D;
        Wed, 16 Mar 2022 02:29:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmEBU29bDGS6E7UYqyNz8B+EgbRNxvriExcD+90VMXwnKcMyEHRwNY8ePaIEwf4Rc162O+lUk8lgCedc78jrPHH0RzHwMC5DGW/oTRsM6HYpiPpAHElm8njws8LZBOAWBzq4hJQRLVc70OneVXBVswGLRBjeHEJ4raFijTKKtXiyP6uVYXeJs+0s+4gZF8+NfL5GiD2361GT1oGwoJ2WvZBSMN4GeaFw/NksIGbNqJIcAzz3r/bzDsPZsYBCAY0rt5H3zqjeoD14n3Ii5LECffxg1YxZVmBGksN506X71hsHFZQ+Xzc5oYceGIdapta2un/0opM60Gs+mr2095olLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2cqAJcJIp1kOdVc0FVmG5i2Ne6EPVa4cmPNPfj9I/4=;
 b=JtSrhavIxXDGdZUnab2y/8E4L4HpJi0jSJbB1zrJitNPNqXLLBHZbvS721GMQ9mj6TbiNYzQV4Ue2XgSt4UT1NkEQvQ5i4YzgxmMhrXL6UVcddC/+cuS36uOTmQCLi+LIGhlJjARmFv7lkouRQIii0uUT+mqo28MqRYaBZg4zUDnm4clMT/JUQ64v3+yu3riWTUsSVxNN8EUQ+a7MXc5p0QmzsZJK5hslWnTy3qCcFkvJrBzacwlZ/UYtce9p1dak4goYXGjxJLA2/uFVudgcsy818mHxihVHN/B23LNejru3g64+5V6RRnBkXoba64y3E5kLkkaZdyTnB8sMVs7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2cqAJcJIp1kOdVc0FVmG5i2Ne6EPVa4cmPNPfj9I/4=;
 b=Hd3tN96Goeiqe9954XuQOVjDqtEwpRUaAsZr3DiFoa2gn2nllXCkWZy+zXVeSjHlQhp2XCiDPWg2pYkhRndKXQfUptXSUom3M50vGHzd5zk5iJbU+e7YciLAKluyXAMgQTKSOk4bWeRSUIjY5VAzSEyHLFUKqf7iKSVQfDVmu+4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by TY0PR06MB4893.apcprd06.prod.outlook.com (2603:1096:400:149::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 09:29:27 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5061.029; Wed, 16 Mar 2022
 09:29:26 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools))
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] selftests: net: fix array_size.cocci warning
Date:   Wed, 16 Mar 2022 17:28:57 +0800
Message-Id: <20220316092858.9398-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b87213dd-d8eb-4c1d-6675-08da072f76bb
X-MS-TrafficTypeDiagnostic: TY0PR06MB4893:EE_
X-Microsoft-Antispam-PRVS: <TY0PR06MB48931F04E3FFE53C70A53F7EC7119@TY0PR06MB4893.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +reMUqvAMAKgCTpHxHts866b+mRJnzqh+j1MSm5jzXBTspyzuPwuT4XgI/hF+0wfR6JGpW1EbHdq0lmSR7RNgVdPcQzfuWO5y5lZKChQPakISJLCQV03HR22cxYRo0AuHcirzguw13swOuQvkkJiVIASwRGyCWEjZvbtbngEhNaJP3vmaZ/gRvhhu/PPMa9RATh6NEQ5NE86fB8XpASRnyJtlkqWhEJf7U+3Bwq/gEaL812/SRglICQ3+UI8t8jlLY5ER4xTOHkKD5ysc83h9QZmkRkDXREMZqbJ6/yJSemXTzUjiNkFcQ4rkIhRqIOvrdCUbcaHVGnvc2OTQxuL1s/Z9oj1lcb5K173zEedu8CKkO43XHkFzS8qbKEucafcja8SYqNnilFUirQdBnSRWUoRxK4c19+v4x1zdI1NiDBTvyPiJXMKzZrRzjD5t/l329344ji+N4xhlur/ZGh3ygf/Nb+dVoDczK6xRQtXgY00cpU6lxeiqC1XFX6I2SZ1kjXD8Xd1FU9QUSiRZeQr26W8QAKC4BciWqGC7GuQFn59ewFJ4ozVpgwcBaHHSaJvB/O4mHN1d55XJErDaARAoJIHfhpJCq3VyfBuNkvctWN2IV7GbaYd9cVi/xo3aghzR0vbXKIgsL3zwgLxToxNEX3gf4A7lyF4wUDkG89Pt4jgxOZ0UDFFT6OfWc1FkjL5V7INGLyGmwDqDLnjtzhwsEcf5Z6sY2g/J8k6Vdm/8Hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(8936002)(921005)(6486002)(38350700002)(38100700002)(66946007)(508600001)(66476007)(66556008)(86362001)(5660300002)(4326008)(110136005)(1076003)(186003)(26005)(6506007)(316002)(52116002)(2616005)(8676002)(7416002)(2906002)(36756003)(6666004)(6512007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vz1z+GMxlcUZeRw9YsWIEXFus+/oMTmFNu1MEXDZtoUgn0WIYx1dCDoM9h+p?=
 =?us-ascii?Q?+4A3zQiRZfM/rTLelkonoxq57QM1Pj2kW/aARHjG7NIN4h4hpYj93o5nsr3X?=
 =?us-ascii?Q?zerHPliPKJWHYC7Pdd7L6U0v5u19ttCw9IxZQus7qj57hrHVaEVNdwEpvVv2?=
 =?us-ascii?Q?08y5MMStYNlIZLOEtr5ILtnH57UHW7hQ1pJ6DP5qeST2cSJMRWNcZ+7ix0o1?=
 =?us-ascii?Q?juNmr8dBFwf6K6mN75A8KDfdnPlxsKIxGD/om97PZZmznWNssmLsK3XlsQFh?=
 =?us-ascii?Q?0sJvODhEJINSjgLjCA3rdnrgHVi2gEQvnzXGlwOf43KrumFh2DVGxzJEMpwz?=
 =?us-ascii?Q?OMfVuOKDlMl/5w9fJv4fbchw001a5GSFzKuoouNVf3Ohy0V0RsHV883xWEfn?=
 =?us-ascii?Q?gnJbgfDnTTjr9KnLx8BuFPtrbNrjH2bO8fShWYJF2W1NtzCTB3lCCxZxizg5?=
 =?us-ascii?Q?8XUd7Xofp764uOrM2xIqfCyfYJNv6x7gDJiF/XJOiJKUFcGNpRoJVLeV7S6o?=
 =?us-ascii?Q?kpNjmdN4MP7xX/3JEGAxa4AlYlLC40+RioyRLaW+ObGztjzKNEmrV2pwYdS7?=
 =?us-ascii?Q?vtZuEVZbHdqh7/b6gWmDOaAeyP8OZeC4JInjp0TnCTKSkg4hgzheEeejDHAQ?=
 =?us-ascii?Q?Y5y+u8a5ZqT/C++2prdcb3tpdBw/+e+xALnzYKi7Gxc+BLXlx/EU/y+pzX94?=
 =?us-ascii?Q?RmoHVRH0cStD3DmHwAaBHgAA3ghenQUhWGGOdnBK6VCUiurCDU27vSLmsel1?=
 =?us-ascii?Q?JU7EywHptbV+UpZWw8kqLay1DhOm8OycIiqA8nR+hz5djyOhi5b5glCrUu6r?=
 =?us-ascii?Q?ou7tL/OBDf3xak+tmUPBspnrcziPsGShRW/ibmhyo01tFJdzfSPQcsULw0Lf?=
 =?us-ascii?Q?x4rcmeiWjZiVliVA02P+kNlN97jgO44GACQOqWxaeqcDgqyZ+8AciR/rmfqF?=
 =?us-ascii?Q?NX2lSWmQdU7HzmXkyfYH4LprB9djBPDKeSRbVw2EMZZskFbpc5BQQi0WVlgO?=
 =?us-ascii?Q?Jbxt4mcuvPdu8TYGs0B5zRN0kXNThfHrSZmS32dfnQ9/8+RKUKq8e3/Mc8y3?=
 =?us-ascii?Q?0ZhouTbhe08SfH8bw6GfC07LtTeMVBEUwfimLBGrQsDvZc3JnM0xrADiEeLI?=
 =?us-ascii?Q?NhjX59fw73MnqU80NW06VtE15llnEZPyz7U+a3OE+jMPyUtrmJmu4b1veRAR?=
 =?us-ascii?Q?fYehvHpuHpXC04Bo4CPy1kCEb/BxBOHEynWjIyFF778RQDJ7KZuNBuCFb7V6?=
 =?us-ascii?Q?166L34pd6cwKXlQfg9gFY6sIrXP0M+qHtUjLeHKz2pkVJBDjEYFhxrS9cYAs?=
 =?us-ascii?Q?+nQB7Tv8g2goUNXkyO7p5yVg8wvNqthr77gQTz3HAqo105W6B9w6fjY55hfB?=
 =?us-ascii?Q?B7y+El74N696W2AwOBvZkZx/U7Hjw4ra+W2GQC7N7QnCeumDvBAp62bop2Iq?=
 =?us-ascii?Q?asbGX6hp+TC8dLeenH3tdScux7aIcNs6?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87213dd-d8eb-4c1d-6675-08da072f76bb
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 09:29:26.5384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3+j/y7O8Uo8+yLYKxhdvbbREpCGtg9hpWL6zAJGc0e9Dtm0E4MKONHNZ9mVjBeBW+hdvoi6fdgWkLCC/RD5ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB4893
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix array_size.cocci warning in tools/testing/selftests/net.

Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.

It has been tested with gcc (Debian 8.3.0-6) 8.3.0.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/testing/selftests/net/cmsg_sender.c  | 4 +++-
 tools/testing/selftests/net/psock_fanout.c | 5 +++--
 tools/testing/selftests/net/toeplitz.c     | 6 ++++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index aed7845c08a8..bc2162909a1a 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -16,6 +16,8 @@
 #include <linux/udp.h>
 #include <sys/socket.h>
 
+#include "../kselftest.h"
+
 enum {
 	ERN_SUCCESS = 0,
 	/* Well defined errors, callers may depend on these */
@@ -318,7 +320,7 @@ static const char *cs_ts_info2str(unsigned int info)
 		[SCM_TSTAMP_ACK]	= "ACK",
 	};
 
-	if (info < sizeof(names) / sizeof(names[0]))
+	if (info < ARRAY_SIZE(names))
 		return names[info];
 	return "unknown";
 }
diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 3653d6468c67..1a736f700be4 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -53,6 +53,7 @@
 #include <unistd.h>
 
 #include "psock_lib.h"
+#include "../kselftest.h"
 
 #define RING_NUM_FRAMES			20
 
@@ -117,7 +118,7 @@ static void sock_fanout_set_cbpf(int fd)
 	struct sock_fprog bpf_prog;
 
 	bpf_prog.filter = bpf_filter;
-	bpf_prog.len = sizeof(bpf_filter) / sizeof(struct sock_filter);
+	bpf_prog.len = ARRAY_SIZE(bpf_filter);
 
 	if (setsockopt(fd, SOL_PACKET, PACKET_FANOUT_DATA, &bpf_prog,
 		       sizeof(bpf_prog))) {
@@ -162,7 +163,7 @@ static void sock_fanout_set_ebpf(int fd)
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
 	attr.insns = (unsigned long) prog;
-	attr.insn_cnt = sizeof(prog) / sizeof(prog[0]);
+	attr.insn_cnt = ARRAY_SIZE(prog);
 	attr.license = (unsigned long) "GPL";
 	attr.log_buf = (unsigned long) log_buf,
 	attr.log_size = sizeof(log_buf),
diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index c5489341cfb8..90026a27eac0 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -52,6 +52,8 @@
 #include <sys/types.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #define TOEPLITZ_KEY_MIN_LEN	40
 #define TOEPLITZ_KEY_MAX_LEN	60
 
@@ -295,7 +297,7 @@ static void __set_filter(int fd, int off_proto, uint8_t proto, int off_dport)
 	struct sock_fprog prog = {};
 
 	prog.filter = filter;
-	prog.len = sizeof(filter) / sizeof(struct sock_filter);
+	prog.len = ARRAY_SIZE(filter);
 	if (setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &prog, sizeof(prog)))
 		error(1, errno, "setsockopt filter");
 }
@@ -324,7 +326,7 @@ static void set_filter_null(int fd)
 	struct sock_fprog prog = {};
 
 	prog.filter = filter;
-	prog.len = sizeof(filter) / sizeof(struct sock_filter);
+	prog.len = ARRAY_SIZE(filter);
 	if (setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &prog, sizeof(prog)))
 		error(1, errno, "setsockopt filter");
 }
-- 
2.20.1

