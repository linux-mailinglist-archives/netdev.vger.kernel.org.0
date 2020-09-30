Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622E127EF78
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgI3QlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:41:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgI3QlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 12:41:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08UGe2ub012922
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:41:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=p56H8tghV3X85ae/sR/7qYhH2tvH7PBI7nOCpK+zcy4=;
 b=LY0o0LhXJ+Xh04QzEwwEKfBYSGsxxyC8RF+ydAZf7AXgWL/Q3GnmBJM8AhF5ohp9rcFt
 iUgEuyXKKM6KKhTrFpUg4zIrQaK+QVW5pneKMiHWIuQh783xR2bgyS796z0JveGtiCgi
 perV/1BhpMkPZYrS5xJ7hx02Mn+dBg0/3is= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33t14ymk3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 09:41:21 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 09:41:17 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 294313704D00; Wed, 30 Sep 2020 09:41:09 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH bpf] bpf: fix "unresolved symbol" build error with resolve_btfids
Date:   Wed, 30 Sep 2020 09:41:09 -0700
Message-ID: <20200930164109.2922412-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009300130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal reported a build failure likes below:
   BTFIDS  vmlinux
   FAILED unresolved symbol tcp_timewait_sock
   make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255

This error can be triggered when config has CONFIG_NET enabled
but CONFIG_INET disabled. In this case, there is no user of
structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
types are not generated for these two structures.

To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
macro if CONFIG_INET is not defined.

Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 4867d549e3c1..d9a1e18d0921 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -102,24 +102,36 @@ asm(							\
  * skc_to_*_sock() helpers. All these sockets should have
  * sock_common as the first argument in its memory layout.
  */
-#define BTF_SOCK_TYPE_xxx \
+
+#define __BTF_SOCK_TYPE_xxx \
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
-	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
 	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
=20
+#define __BTF_SOCK_TW_TYPE_xxx \
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
+
+#ifdef CONFIG_INET
+#define BTF_SOCK_TYPE_xxx						\
+	__BTF_SOCK_TYPE_xxx						\
+	__BTF_SOCK_TW_TYPE_xxx
+#else
+#define BTF_SOCK_TYPE_xxx	__BTF_SOCK_TYPE_xxx
+#endif
+
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
-BTF_SOCK_TYPE_xxx
+__BTF_SOCK_TYPE_xxx
+__BTF_SOCK_TW_TYPE_xxx
 #undef BTF_SOCK_TYPE
 MAX_BTF_SOCK_TYPE,
 };
--=20
2.24.1

