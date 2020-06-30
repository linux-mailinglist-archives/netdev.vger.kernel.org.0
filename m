Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3499720EA7B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgF3AsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:48:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57156 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgF3AsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:48:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U0fgiL009168
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:48:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=wJknqwqYXRSE1Pr2C/jpMeiiLRFWsPl+mXUJxchPZ04=;
 b=TH50JquVuzF39SA9QtjLrFma14p1l8pB9UEYJ6gBeFm1DVfFTenrWiYPrS5H1nXZ7VL4
 FGO+9QiXk8Hn9X/t2XzqjdwqcM4pbCvonsv0hjulEkrMxDrFDTF+ySRjlhQOwEuGow/S
 BmXVyYFXGatbq1E7OXyrb1e0ILcuhDwnrKE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3mmhywy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:48:13 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 17:48:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C00982EC3BFA; Mon, 29 Jun 2020 17:48:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] tools/bpftool: allow substituting custom vmlinux.h for the build
Date:   Mon, 29 Jun 2020 17:47:58 -0700
Message-ID: <20200630004759.521530-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 cotscore=-2147483648 spamscore=0
 mlxlogscore=733 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=8
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006300002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some build contexts (e.g., Travis CI build for outdated kernel), vmlin=
ux.h,
generated from available kernel, doesn't contain all the types necessary =
for
BPF program compilation. For such set up, the most maintainable way to de=
al
with this problem is to keep pre-generated (almost up-to-date) vmlinux.h
checked in and use it for compilation purposes. bpftool after that can de=
al
with kernel missing some of the features in runtime with no problems.

To that effect, allow to specify path to custom vmlinux.h to bpftool's
Makefile with VMLINUX_H variable.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 8c6563e56ffc..273da1615503 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -122,20 +122,24 @@ BPFTOOL_BOOTSTRAP :=3D $(if $(OUTPUT),$(OUTPUT)bpft=
ool-bootstrap,./bpftool-bootstr
 BOOTSTRAP_OBJS =3D $(addprefix $(OUTPUT),main.o common.o json_writer.o g=
en.o btf.o)
 OBJS =3D $(patsubst %.c,$(OUTPUT)%.o,$(SRCS)) $(OUTPUT)disasm.o
=20
-VMLINUX_BTF_PATHS :=3D $(if $(O),$(O)/vmlinux)				\
+VMLINUX_BTF_PATHS ?=3D $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
 		     ../../../vmlinux					\
 		     /sys/kernel/btf/vmlinux				\
 		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF :=3D $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))=
)
+VMLINUX_BTF ?=3D $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))=
)
=20
-ifneq ($(VMLINUX_BTF),)
+ifneq ($(VMLINUX_BTF)$(VMLINUX_H),)
 ifeq ($(feature-clang-bpf-co-re),1)
=20
 BUILD_BPF_SKELS :=3D 1
=20
 $(OUTPUT)vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL_BOOTSTRAP)
+ifeq ($(VMLINUX_H),)
 	$(QUIET_GEN)$(BPFTOOL_BOOTSTRAP) btf dump file $< format c > $@
+else
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
=20
 $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF)
 	$(QUIET_CLANG)$(CLANG) \
--=20
2.24.1

