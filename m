Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6559E27F6F2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgJABCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:02:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45572 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732343AbgJABCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 21:02:32 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0910npRd003052
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 18:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qJrmEVxrxATTzkrduJ0xSQtCg4/DepbYX9s91eJ1Y88=;
 b=ZRPL6J5tSIBGZxtoTBGLnBQZ1QN4wvPELQw+yI8rQXLAzf8gkNq5CJlMLhtmujHcJa68
 FRU2KP1Rh6NTb7iu09oeoj7xsYrLo9YDsULQLoWG8MzCRbZQ8quTHwsMxEk2fynrh2GT
 mWIjekdHUPyd2NmjTCpPVcGZcJ1pKUvqcGk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vvgrk0xe-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 18:02:30 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 18:02:29 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4C253370571E; Wed, 30 Sep 2020 18:02:24 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH bpf v2] bpf: fix "unresolved symbol" build error with resolve_btfids
Date:   Wed, 30 Sep 2020 18:02:24 -0700
Message-ID: <20201001010224.1545722-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 suspectscore=8 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010010004
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

To fix the problem, for two timewait structures, if CONFIG_INET=3Dn,
use BTF_ID_UNUSED instead of BTF_ID to skip btf id generation
in resolve_btfids.

Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h | 20 +++++++++++++++++---
 net/core/filter.c       |  1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

Changelog:
  v1 -> v2:
    . For unsupported socket times, using BTF_ID_UNUSED to
      keep the id as 0. (Martin)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 4867d549e3c1..9c49bf89a9a7 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -102,23 +102,37 @@ asm(							\
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
+#ifdef CONFIG_INET
+#define __BTF_SOCK_TW_TYPE_xxx						\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
+	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
+#else
+#define __BTF_SOCK_TW_TYPE_xxx						\
+	BTF_SOCK_TYPE_UNUSED(BTF_SOCK_TYPE_INET_TW)			\
+	BTF_SOCK_TYPE_UNUSED(BTF_SOCK_TYPE_TCP_TW)
+#endif
+
+#define BTF_SOCK_TYPE_xxx						\
+	__BTF_SOCK_TYPE_xxx						\
+	__BTF_SOCK_TW_TYPE_xxx
+
 enum {
 #define BTF_SOCK_TYPE(name, str) name,
+#define BTF_SOCK_TYPE_UNUSED(name) name,
 BTF_SOCK_TYPE_xxx
 #undef BTF_SOCK_TYPE
 MAX_BTF_SOCK_TYPE,
diff --git a/net/core/filter.c b/net/core/filter.c
index 21eaf3b182f2..396fe928e202 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9500,6 +9500,7 @@ void bpf_prog_change_xdp(struct bpf_prog *prev_prog=
, struct bpf_prog *prog)
 #ifdef CONFIG_DEBUG_INFO_BTF
 BTF_ID_LIST_GLOBAL(btf_sock_ids)
 #define BTF_SOCK_TYPE(name, type) BTF_ID(struct, type)
+#define BTF_SOCK_TYPE_UNUSED(name) BTF_ID_UNUSED
 BTF_SOCK_TYPE_xxx
 #undef BTF_SOCK_TYPE
 #else
--=20
2.24.1

