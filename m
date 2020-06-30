Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC920EA79
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgF3AsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:48:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgF3AsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:48:11 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U0jrjX012119
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:48:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+P2JGEwyVtIs5pjj2XqteeK6ETp3ZCALVo1itEn0MzU=;
 b=pIMjerEw6Qs+mfQrdIBZtNvu7hypHEkRTzW3t1fah/eLTiSO5vA3Dcg2fbXTIqTXeVFO
 ox+9qvBUuPbgwSQaE48987zOqvOmqOdfY01HB1R21tEH8vbOgVuEyOIHbAbT3QPVFuEE
 wVX4Uf3PlfLSXW6ownuEq0CaDDx+x1slcpU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbqhc6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:48:10 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 17:48:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E6E3C2EC3BFA; Mon, 29 Jun 2020 17:48:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] selftests/bpf: allow substituting custom vmlinux.h for selftests build
Date:   Mon, 29 Jun 2020 17:47:59 -0700
Message-ID: <20200630004759.521530-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200630004759.521530-1-andriin@fb.com>
References: <20200630004759.521530-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=8 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=540 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to bpftool Makefile, allow to specify custom location of vmlinu=
x.h
to be used during the build. This allows simpler testing setups with
checked-in pre-generated vmlinux.h.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 22aaec74ea0a..1f9c696b3edf 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -134,12 +134,12 @@ $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
=20
-VMLINUX_BTF_PATHS :=3D $(if $(O),$(O)/vmlinux)				\
+VMLINUX_BTF_PATHS ?=3D $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
 		     ../../../../vmlinux				\
 		     /sys/kernel/btf/vmlinux				\
 		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF :=3D $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))=
)
+VMLINUX_BTF ?=3D $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))=
)
=20
 $(OUTPUT)/runqslower: $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
@@ -182,8 +182,13 @@ $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_D=
IR):
 	mkdir -p $@
=20
 $(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
 	$(call msg,GEN,,$@)
 	$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(call msg,CP,,$@)
+	cp "$(VMLINUX_H)" $@
+endif
=20
 # Get Clang's default includes on this system, as opposed to those seen =
by
 # '-target bpf'. This fixes "missing" files on some architectures/distro=
s,
--=20
2.24.1

