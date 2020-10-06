Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEA02844F7
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 06:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgJFEec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 00:34:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbgJFEec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 00:34:32 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0964RE1X008854
        for <netdev@vger.kernel.org>; Mon, 5 Oct 2020 21:34:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=+Jxh2aCHlm4Rf2r8UH2sMjx+sIPGm6035WiJKee7mAc=;
 b=XF3TZ1dRMJw9r29KEwbg8hdxthYcNmaAds3y2BYyAilR4W8Gs431F6PicFwiWQHk5iAr
 trTDUQD9rUkU4qRmHzFq7OtQEV+wS0daWorxOUiQE3K0qKIoiIgkjm60qOOg/meWfjzL
 RQE91DIJjWOhpai2c3iQKmfctkVAy/2dt4U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33y8t9rdr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 21:34:31 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 21:34:30 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1947137057D8; Mon,  5 Oct 2020 21:34:27 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 1/2] samples/bpf: change Makefile to cope with latest llvm
Date:   Mon, 5 Oct 2020 21:34:26 -0700
Message-ID: <20201006043427.1891742-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-06_01:2020-10-05,2020-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With latest llvm trunk, bpf programs under samples/bpf
directory, if using CORE, may experience the following
errors:

LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.index
PLEASE submit a bug report to https://bugs.llvm.org/ and include the cras=
h backtrace.
Stack dump:
0.      Program arguments: llc -march=3Dbpf -filetype=3Dobj -o samples/bp=
f/test_probe_write_user_kern.o
1.      Running pass 'Function Pass Manager' on module '<stdin>'.
2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on func=
tion '@bpf_prog1'
 #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&, int=
)
    (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x1=
83c26c)
...
 #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.cur/=
install/bin/llc+0x17c375e)
 #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::SDNo=
de*)
    (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x1=
6a75c5)
 #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm::SDN=
ode*, unsigned char const*,
    unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/insta=
ll/bin/llc+0x16ab4f8)
...
Aborted (core dumped) | llc -march=3Dbpf -filetype=3Dobj -o samples/bpf/t=
est_probe_write_user_kern.o

The reason is due to llvm change https://reviews.llvm.org/D87153
where the CORE relocation global generation is moved from the beginning
of target dependent optimization (llc) to the beginning
of target independent optimization (opt).

Since samples/bpf programs did not use vmlinux.h and its clang compilatio=
n
uses native architecture, we need to adjust arch triple at opt level
to do CORE relocation global generation properly. Otherwise, the above
error will appear.

This patch fixed the issue by introduce opt and llvm-dis to compilation c=
hain,
which will do proper CORE relocation global generation as well as O2 leve=
l
optimization. Tested with llvm10, llvm11 and trunk/llvm12.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/Makefile | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Changelog:
  v1 -> v2:
    - add comments to explain the change (Andrii)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f1ed0e3cf9f..e29b1e89dd3e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -211,6 +211,8 @@ TPROGLDLIBS_xsk_fwd		+=3D -pthread
 #  make M=3Dsamples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/ll=
vm/build/bin/clang
 LLC ?=3D llc
 CLANG ?=3D clang
+OPT ?=3D opt
+LLVM_DIS ?=3D llvm-dis
 LLVM_OBJCOPY ?=3D llvm-objcopy
 BTF_PAHOLE ?=3D pahole
=20
@@ -303,6 +305,11 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.=
h
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
+# below we use long chain of commands, clang | opt | llvm-dis | llc,
+# to generate final object file. 'clang' compiles the source into IR
+# with native target, e.g., x64, arm64, etc. 'opt' does bpf CORE IR buil=
tin
+# processing (llvm12) and IR optimizations. 'llvm-dis' converts
+# 'opt' output to IR, and finally 'llc' generates bpf byte code.
 $(obj)/%.o: $(src)/%.c
 	@echo "  CLANG-bpf " $@
 	$(Q)$(CLANG) $(NOSTDINC_FLAGS) $(LINUXINCLUDE) $(BPF_EXTRA_CFLAGS) \
@@ -314,7 +321,9 @@ $(obj)/%.o: $(src)/%.c
 		-Wno-address-of-packed-member -Wno-tautological-compare \
 		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
 		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
-		-O2 -emit-llvm -c $< -o -| $(LLC) -march=3Dbpf $(LLC_FLAGS) -filetype=3D=
obj -o $@
+		-O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
+		$(OPT) -O2 -mtriple=3Dbpf-pc-linux | $(LLVM_DIS) | \
+		$(LLC) -march=3Dbpf $(LLC_FLAGS) -filetype=3Dobj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
 endif
--=20
2.24.1

