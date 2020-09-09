Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843CB26274A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 08:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIIGjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 02:39:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgIIGjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 02:39:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0896bQVS021672
        for <netdev@vger.kernel.org>; Tue, 8 Sep 2020 23:39:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Twtp805V2qOM4MF4pd73mJn2zK8AIezgWIjkBe5maXQ=;
 b=SPVPhBybJRU6SeishsFIQ33c9B84rLjkIY+QBpVVHuFg2IKhpaQm7uOzyoiDSvN+Gxdw
 3xZWxR5fLvTVlv4emA0rs3qLM3sgYoRgSvJCm6ir/vB/8Eltclg9y6DyDNhyIRmD2Dsy
 EMZ92h/m+OkwJImB1domMHC4xfz4xCz0BBY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33c91hgh2s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 23:39:47 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 23:39:45 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 2FE6137052B7; Tue,  8 Sep 2020 23:39:43 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2] selftests/bpf: fix test_sysctl_loop{1,2} failure due to clang change
Date:   Tue, 8 Sep 2020 23:39:43 -0700
Message-ID: <20200909063943.1653670-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_03:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii reported that with latest clang, when building selftests, we have
error likes:
  error: progs/test_sysctl_loop1.c:23:16: in function sysctl_tcp_mem i32 =
(%struct.bpf_sysctl*):
  Looks like the BPF stack limit of 512 bytes is exceeded.
  Please move large on stack variables into BPF per-cpu array map.

The error is triggered by the following LLVM patch:
  https://reviews.llvm.org/D87134

For example, the following code is from test_sysctl_loop1.c:
  static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
  {
    volatile char tcp_mem_name[] =3D "net/ipv4/tcp_mem/very_very_very_ver=
y_long_pointless_string";
    ...
  }
Without the above LLVM patch, the compiler did optimization to load the s=
tring
(59 bytes long) with 7 64bit loads, 1 8bit load and 1 16bit load,
occupying 64 byte stack size.

With the above LLVM patch, the compiler only uses 8bit loads, but subregi=
ster is 32bit.
So stack requirements become 4 * 59 =3D 236 bytes. Together with other st=
uff on
the stack, total stack size exceeds 512 bytes, hence compiler complains a=
nd quits.

To fix the issue, removing "volatile" key word or changing "volatile" to
"const"/"static const" does not work, the string is put in .rodata.str1.1=
 section,
which libbpf did not process it and errors out with
  libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
  libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_m=
em.tcp_mem_name'
          in section '.rodata.str1.1'

Defining the string const as global variable can fix the issue as it puts=
 the string constant
in '.rodata' section which is recognized by libbpf. In the future, when l=
ibbpf can process
'.rodata.str*.*' properly, the global definition can be changed back to l=
ocal definition.

Defining tcp_mem_name as a global, however, triggered a verifier failure.
   ./test_progs -n 7/21
  libbpf: load bpf program failed: Permission denied
  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  invalid stack off=3D0 size=3D1
  verification time 6975 usec
  stack depth 160+64
  processed 889 insns (limit 1000000) max_states_per_insn 4 total_states
  14 peak_states 14 mark_read 10

  libbpf: -- END LOG --
  libbpf: failed to load program 'sysctl_tcp_mem'
  libbpf: failed to load object 'test_sysctl_loop2.o'
  test_bpf_verif_scale:FAIL:114
  #7/21 test_sysctl_loop2.o:FAIL
This actually exposed a bpf program bug. In test_sysctl_loop{1,2}, we hav=
e code
like
  const char tcp_mem_name[] =3D "<...long string...>";
  ...
  char name[64];
  ...
  for (i =3D 0; i < sizeof(tcp_mem_name); ++i)
      if (name[i] !=3D tcp_mem_name[i])
          return 0;
In the above code, if sizeof(tcp_mem_name) > 64, name[i] access may be
out of bound. The sizeof(tcp_mem_name) is 59 for test_sysctl_loop1.c and
79 for test_sysctl_loop2.c.

Without promotion-to-global change, old compiler generates code where
the overflowed stack access is actually filled with valid value, so hidin=
g
the bpf program bug. With promotion-to-global change, the code is differe=
nt,
more specifically, the previous loading constants to stack is gone, and
"name" occupies stack[-64:0] and overflow access triggers a verifier erro=
r.
To fix the issue, adjust "name" buffer size properly.

Reported-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 2 +-
 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Changelog:
  v1 -> v2:
    . The tcp_mem_name change actually triggers a verifier failure due to
      a bpf program bug. Fixing the bpf program bug can make test pass
      with both old and latest llvm. (Alexei)

diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tool=
s/testing/selftests/bpf/progs/test_sysctl_loop1.c
index 458b0d69133e..4b600b1f522f 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
@@ -18,9 +18,9 @@
 #define MAX_ULONG_STR_LEN 7
 #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
=20
+const char tcp_mem_name[] =3D "net/ipv4/tcp_mem/very_very_very_very_long=
_pointless_string";
 static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
 {
-	volatile char tcp_mem_name[] =3D "net/ipv4/tcp_mem/very_very_very_very_=
long_pointless_string";
 	unsigned char i;
 	char name[64];
 	int ret;
diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tool=
s/testing/selftests/bpf/progs/test_sysctl_loop2.c
index b2e6f9b0894d..d01056142520 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
@@ -18,11 +18,12 @@
 #define MAX_ULONG_STR_LEN 7
 #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
=20
+const char tcp_mem_name[] =3D "net/ipv4/tcp_mem/very_very_very_very_long=
_pointless_string_to_stress_byte_loop";
 static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
 {
-	volatile char tcp_mem_name[] =3D "net/ipv4/tcp_mem/very_very_very_very_=
long_pointless_string_to_stress_byte_loop";
 	unsigned char i;
-	char name[64];
+	/* the above tcp_mem_name length is 79, make name buffer length 80 */
+	char name[80];
 	int ret;
=20
 	memset(name, 0, sizeof(name));
--=20
2.24.1

