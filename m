Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8702632B3DE
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840242AbhCCEHn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Mar 2021 23:07:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240174AbhCCAlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 19:41:02 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1230VClE023531
        for <netdev@vger.kernel.org>; Tue, 2 Mar 2021 16:40:21 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3706sv74nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 16:40:21 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 16:40:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F1E1A2ED12D0; Tue,  2 Mar 2021 16:40:14 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next] tools/runqslower: allow substituting custom vmlinux.h for the build
Date:   Tue, 2 Mar 2021 16:40:10 -0800
Message-ID: <20210303004010.653954-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 clxscore=1011 spamscore=0 mlxscore=0 mlxlogscore=769
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103030001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just like was done for bpftool and selftests in ec23eb705620 ("tools/bpftool:
Allow substituting custom vmlinux.h for the build") and ca4db6389d61
("selftests/bpf: Allow substituting custom vmlinux.h for selftests build"),
allow to provide pre-generated vmlinux.h for runqslower build.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/runqslower/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index c96ba90c6f01..3818ec511fd2 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -69,12 +69,16 @@ $(OUTPUT) $(BPFOBJ_OUTPUT) $(BPFTOOL_OUTPUT):
 	$(QUIET_MKDIR)mkdir -p $@
 
 $(OUTPUT)/vmlinux.h: $(VMLINUX_BTF_PATH) | $(OUTPUT) $(BPFTOOL)
+ifeq ($(VMLINUX_H),)
 	$(Q)if [ ! -e "$(VMLINUX_BTF_PATH)" ] ; then \
 		echo "Couldn't find kernel BTF; set VMLINUX_BTF to"	       \
 			"specify its location." >&2;			       \
 		exit 1;\
 	fi
 	$(QUIET_GEN)$(BPFTOOL) btf dump file $(VMLINUX_BTF_PATH) format c > $@
+else
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
 
 $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(BPFOBJ_OUTPUT)
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC) OUTPUT=$(BPFOBJ_OUTPUT) $@
-- 
2.24.1

