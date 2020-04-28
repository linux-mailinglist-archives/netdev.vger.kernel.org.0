Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE31BB57C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD1EvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:51:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2860 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgD1EvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:51:06 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S4nqZC014171
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:51:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Xbp+KLMoEE+vDnuothxmZKMQx5GFaCrAetqiLNdq2VU=;
 b=a1OEts/yYMchOPnWYmNeIb5DZp717dzCia+zKR4aq27EMw7DNiYS8AsUUNkISBgt3Cge
 22/i0RW0SkXl0v/wQFz8N3v0w676Qc7hEfra+0NprNeo6Q5tpuNk/Y/UmU73qMAxnql3
 prO3nvZQ1/fIcnZJHcx5Uf+L9vGifZjOLMs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1ggcs3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:51:04 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 21:51:02 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E53C22EC30DC; Mon, 27 Apr 2020 21:51:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] selftests/bpf: add test_progs-asan flavor with AddressSantizer
Date:   Mon, 27 Apr 2020 21:46:24 -0700
Message-ID: <20200428044628.3772114-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200428044628.3772114-1-andriin@fb.com>
References: <20200428044628.3772114-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_02:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=8 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add another flavor of test_progs that is compiled and run with
AddressSanitizer and LeakSanitizer. This allows to find potential memory
correction bugs and memory leaks. Due to sometimes not trivial requiremen=
ts on
the environment, this is (for now) done as a separate flavor, not by defa=
ult.
Eventually I hope to enable it by default.

To run ./test_progs-asan successfully, you need to have libasan installed=
 in
the system, where version of the package depends on GCC version you have.
E.g., GCC8 needs libasan5, while GCC7 uses libasan4.

For CentOS 7, to build everything successfully one would need to:
  $ sudo yum install devtoolset-8-gcc devtoolset-libasan-devel

For Arch Linux to run selftests, one would need to install gcc-libs packa=
ge to
get libasan.so.5:
  $ sudo pacman -S gcc-libs

Cc: Julia Kartseva <hex@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore |  1 +
 tools/testing/selftests/bpf/Makefile   | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index c30079c86998..69b545ca51b8 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -36,6 +36,7 @@ test_current_pid_tgid_new_ns
 xdping
 test_cpp
 *.skel.h
+/asan
 /no_alu32
 /bpf_gcc
 /tools
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index fd56e31a5b4f..e54d069b27a6 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -33,7 +33,7 @@ TEST_GEN_PROGS =3D test_verifier test_tag test_maps tes=
t_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashm=
ap \
-	test_progs-no_alu32 \
+	test_progs-no_alu32 test_progs-asan \
 	test_current_pid_tgid_new_ns
=20
 # Also test bpf-gcc, if present
@@ -344,7 +344,8 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
-	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$$(CC) $$(CFLAGS) $(TRUNNER_SAN_CFLAGS) $$(filter %.a %.o,$$^)	\
+	       $$(LDLIBS) -o $$@
=20
 endef
=20
@@ -358,11 +359,18 @@ TRUNNER_EXTRA_FILES :=3D $(OUTPUT)/urandom_read				=
\
 TRUNNER_BPF_BUILD_RULE :=3D CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS :=3D $(BPF_CFLAGS) $(CLANG_CFLAGS)
 TRUNNER_BPF_LDFLAGS :=3D -mattr=3D+alu32
+TRUNNER_SAN_CFLAGS :=3D
 $(eval $(call DEFINE_TEST_RUNNER,test_progs))
=20
+# Define test_progs-asan test runner.
+TRUNNER_BPF_BUILD_RULE :=3D CLANG_BPF_BUILD_RULE
+TRUNNER_SAN_CFLAGS :=3D -fsanitize=3Daddress
+$(eval $(call DEFINE_TEST_RUNNER,test_progs,asan))
+
 # Define test_progs-no_alu32 test runner.
 TRUNNER_BPF_BUILD_RULE :=3D CLANG_NOALU32_BPF_BUILD_RULE
 TRUNNER_BPF_LDFLAGS :=3D
+TRUNNER_SAN_CFLAGS :=3D
 $(eval $(call DEFINE_TEST_RUNNER,test_progs,no_alu32))
=20
 # Define test_progs BPF-GCC-flavored test runner.
@@ -370,6 +378,7 @@ ifneq ($(BPF_GCC),)
 TRUNNER_BPF_BUILD_RULE :=3D GCC_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS :=3D $(BPF_CFLAGS) $(call get_sys_includes,gcc)
 TRUNNER_BPF_LDFLAGS :=3D
+TRUNNER_SAN_CFLAGS :=3D
 $(eval $(call DEFINE_TEST_RUNNER,test_progs,bpf_gcc))
 endif
=20
@@ -381,6 +390,7 @@ TRUNNER_EXTRA_FILES :=3D
 TRUNNER_BPF_BUILD_RULE :=3D $$(error no BPF objects should be built)
 TRUNNER_BPF_CFLAGS :=3D
 TRUNNER_BPF_LDFLAGS :=3D
+TRUNNER_SAN_CFLAGS :=3D
 $(eval $(call DEFINE_TEST_RUNNER,test_maps))
=20
 # Define test_verifier test runner.
@@ -406,4 +416,4 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_=
extern.skel.h $(BPFOBJ)
 EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32 bpf_gcc)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h asan no_alu32 bpf_gcc)
--=20
2.24.1

