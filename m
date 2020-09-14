Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A3E269481
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgINSKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:10:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgINSKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:10:34 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EI9RqC007720
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=QVZfykeII0yU8eMcGJj1P3591UuDP6NVwbIA/p0s0Zo=;
 b=fFHj08vYA2UjqCa//2FZTsXSE5Prnzj5zByGyGFl19UL/MV0c9CJAWWhwC224XVgAxkp
 NAPxr4hWDKxRcVAm2MAMpC+JJUefwg9MomRFePywY44l/svQawgPPc6zJ5axZ5vdWOLC
 l0Sh5b846DQR3cQH5JX8+bpyCzJU5MDJcqk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33hekmxc4d-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 11:10:30 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 11:10:26 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 718E737056EB; Mon, 14 Sep 2020 11:10:22 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH bpf-next v2] bpftool: fix build failure
Date:   Mon, 14 Sep 2020 11:10:22 -0700
Message-ID: <20200914181022.925575-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_07:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=8 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140145
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
Some comments are added in Makefile to warn that '%' is not allowed in bp=
ftool
man page names.

Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" =
sections in man pages")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/Documentation/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool=
/Documentation/Makefile
index 4c9dd1e45244..5dd68d79671e 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -40,11 +40,13 @@ see_also =3D $(subst " ",, \
 	$(foreach page,$(call list_pages,$(1)),",\n\t**$(page)**\\ (8)") \
 	"\n")
=20
+# using printf for portability as `echo -e` does not work in some
+# environments. Note that bpftool man page names should not include '%'.
 $(OUTPUT)%.8: %.rst
 ifndef RST2MAN_DEP
 	$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man $(RST2MA=
N_OPTS) > $@
+	$(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man $(RST2MAN=
_OPTS) > $@
=20
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
--=20
2.24.1

