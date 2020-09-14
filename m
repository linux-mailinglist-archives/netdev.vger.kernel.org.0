Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CC2694E1
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgINSbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:31:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725992AbgINSbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:31:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08EISOe9002747
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:31:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=wJxk2ZgSwZN0QrQ5yNxEMzrATwxN7jXIocWXRUrYDfU=;
 b=TN51a8hUcON+NiO56t2IBUxEv56fNEkc9vaJPEfhCIpEXUy0t1XrYrmpR0VF11IbcgsX
 JMx3H4YH4i2RSP+h2MiZalftnvJdRE1wwdWJhks+Dir2cwuRwocNZz2llXvhaR8z1dVw
 08o9bT/wq22ED3fge4h/gffn+sTZOFSqPuY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33gt0mtm3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:31:13 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 11:31:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6205B3705720; Mon, 14 Sep 2020 11:31:10 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v3] bpftool: fix build failure
Date:   Mon, 14 Sep 2020 11:31:10 -0700
Message-ID: <20200914183110.999906-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 suspectscore=8 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building bpf selftests like
  make -C tools/testing/selftests/bpf -j20
I hit the following errors:
  ...
  GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Docu=
mentation/bpftool-gen.8
  <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpect=
ed unindent.
  <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
  <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
  <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpect=
ed unindent.
  <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
  <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexp=
ected unindent.
  <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexp=
ected unindent.
  <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexp=
ected unindent.
  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool=
/Documentation/bpftool-perf.8] Error 12
  make[1]: *** Waiting for unfinished jobs....
  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool=
/Documentation/bpftool-iter.8] Error 12
  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool=
/Documentation/bpftool-struct_ops.8] Error 12
  ...

I am using:
  -bash-4.4$ rst2man --version
  rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
  -bash-4.4$

The Makefile generated final .rst file (e.g., bpftool-cgroup.rst) looks l=
ike
  ...
      ID       AttachType      AttachFlags     Name
  \n SEE ALSO\n=3D=3D=3D=3D=3D=3D=3D=3D\n\t**bpf**\ (2),\n\t**bpf-helpers=
**\
  (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
  (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
  (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
  (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
  (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
  (8),\n\t**bpftool-struct_ops**\ (8)\n

The rst2man generated .8 file looks like
Literal block ends without a blank line; unexpected unindent.
 .sp
 n SEEALSOn=3D=3D=3D=3D=3D=3D=3D=3Dnt**bpf**(2),nt**bpf\-helpers**(7),nt*=
*bpftool**(8),nt**bpftool\-btf**(8),nt**
 bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**b=
pftool\-link**(8),nt**
 bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpfto=
ol\-prog**(8),nt**
 bpftool\-struct_ops**(8)n

Looks like that particular version of rst2man prefers to have actual new =
line
instead of \n.

Since `echo -e` may not be available in some environment, let us use `pri=
ntf`.
Format string "%b" is used for `printf` to ensure all escape characters a=
re
interpretted properly.

Cc: Quentin Monnet <quentin@isovalent.com>
Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" =
sections in man pages")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/Documentation/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool=
/Documentation/Makefile
index 4c9dd1e45244..f33cb02de95c 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -44,7 +44,7 @@ $(OUTPUT)%.8: %.rst
 ifndef RST2MAN_DEP
 	$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man $(RST2MA=
N_OPTS) > $@
+	$(QUIET_GEN)( cat $< ; printf "%b" $(call see_also,$<) ) | rst2man $(RS=
T2MAN_OPTS) > $@
=20
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
--=20
2.24.1

