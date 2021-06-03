Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26BE399709
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 02:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFCAmV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Jun 2021 20:42:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23154 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhFCAmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 20:42:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1530dlQh025496
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 17:40:36 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38xedh2fn2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 17:40:36 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 17:40:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E548E2EDE105; Wed,  2 Jun 2021 17:40:32 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/4] libbpf: refactor header installation portions of Makefile
Date:   Wed, 2 Jun 2021 17:40:24 -0700
Message-ID: <20210603004026.2698513-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603004026.2698513-1-andrii@kernel.org>
References: <20210603004026.2698513-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qYzox5RUZH2U7HVPwPucd8uHZ8GQsr2X
X-Proofpoint-ORIG-GUID: qYzox5RUZH2U7HVPwPucd8uHZ8GQsr2X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_11:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1034
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we gradually get more headers that have to be installed, it's quite
annoying to copy/paste long $(call) commands. So extract that logic and do
a simple $(foreach) over the list of headers.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/Makefile | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 15420303cf06..d1b909e005dc 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -223,19 +223,14 @@ install_lib: all_cmd
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_FILE) $(DESTDIR)$(libdir_SQ)
 
+INSTALL_HEADERS = bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h \
+		  bpf_helpers.h $(BPF_HELPER_DEFS) bpf_tracing.h	     \
+		  bpf_endian.h bpf_core_read.h
+
 install_headers: $(BPF_HELPER_DEFS)
-	$(call QUIET_INSTALL, headers) \
-		$(call do_install,bpf.h,$(prefix)/include/bpf,644); \
-		$(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
-		$(call do_install,btf.h,$(prefix)/include/bpf,644); \
-		$(call do_install,libbpf_common.h,$(prefix)/include/bpf,644); \
-		$(call do_install,libbpf_legacy.h,$(prefix)/include/bpf,644); \
-		$(call do_install,xsk.h,$(prefix)/include/bpf,644); \
-		$(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
-		$(call do_install,$(BPF_HELPER_DEFS),$(prefix)/include/bpf,644); \
-		$(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
-		$(call do_install,bpf_endian.h,$(prefix)/include/bpf,644); \
-		$(call do_install,bpf_core_read.h,$(prefix)/include/bpf,644);
+	$(call QUIET_INSTALL, headers)					     \
+		$(foreach hdr,$(INSTALL_HEADERS),			     \
+			$(call do_install,$(hdr),$(prefix)/include/bpf,644);)
 
 install_pkgconfig: $(PC_FILE)
 	$(call QUIET_INSTALL, $(PC_FILE)) \
-- 
2.30.2

