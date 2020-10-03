Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD16028207B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgJCCTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:19:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgJCCTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:19:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0932CDmI000965
        for <netdev@vger.kernel.org>; Fri, 2 Oct 2020 19:19:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=NOWjPhkMde+qKCxOunFWPTDpqcuSgcVCE4Bvgmb1gyQ=;
 b=BKglzgrihw3J/m1e63Of/eI3fxFOqXaK1xU5mFBEg6fnEdwQSWzr8GNK/g/OSKoVf3uv
 uE5pOqMEBfBAr/fxfbLChG3YlveL/mAUalkamOBebWGJL1IAi+vAAtTo7oQVIGrCt8LB
 Z5GHTGhRO+Xy8bCkC88ff5ol8Qn6z/iA5ws= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33w05ndq04-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 19:19:06 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 19:19:05 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BD76E3705C29; Fri,  2 Oct 2020 19:19:04 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/2] samples/bpf: change Makefile to cope with latest llvm
Date:   Fri, 2 Oct 2020 19:19:04 -0700
Message-ID: <20201003021904.1468678-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030019
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

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 samples/bpf/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f1ed0e3cf9f..79c5fdea63d2 100644
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
@@ -314,7 +316,9 @@ $(obj)/%.o: $(src)/%.c
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

