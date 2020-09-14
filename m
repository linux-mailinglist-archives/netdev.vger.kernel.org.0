Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421A326848D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgINGML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:12:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63452 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgINGMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:12:09 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E66Qxp018655
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 23:12:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=e4JsQYe43g5R9QwY4puTrD2PMM3cIlekM8vmc67I+4w=;
 b=mocxLq9+Grj68IRwC51zq5mgzezEoMAL2zlOJAVYVfOU8MKDojeu/CzN4qFZvZ65p0hY
 SMnIg0DkUNp2UNXtqEL5HIRbnIyiROfvVx7eXnwPc12FNflbp26pZbOuleSWGAMqc5bT
 GU9e0nvAfOUcdr+QSKg0YxMmOXtnpz8244A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hed3udxm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 23:12:08 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 13 Sep 2020 23:12:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BCA5D3704C64; Sun, 13 Sep 2020 23:12:06 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: fix build failure
Date:   Sun, 13 Sep 2020 23:12:06 -0700
Message-ID: <20200914061206.2625395-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 suspectscore=8 mlxscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=846
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009140055
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

Looks like that particular version of rst2man prefers to have a blank lin=
e
after literal blocks. This patch added block lines in related .rst files
and compilation can then pass.

Cc: Quentin Monnet <quentin@isovalent.com>
Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" =
sections in man pages")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst     | 1 +
 tools/bpf/bpftool/Documentation/bpftool-feature.rst    | 1 +
 tools/bpf/bpftool/Documentation/bpftool-iter.rst       | 1 +
 tools/bpf/bpftool/Documentation/bpftool-link.rst       | 1 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst        | 1 +
 tools/bpf/bpftool/Documentation/bpftool-net.rst        | 1 +
 tools/bpf/bpftool/Documentation/bpftool-perf.rst       | 1 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst       | 1 +
 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst | 1 +
 tools/bpf/bpftool/Documentation/bpftool.rst            | 1 +
 10 files changed, 10 insertions(+)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/b=
pf/bpftool/Documentation/bpftool-cgroup.rst
index 790944c35602..5d01a74b7c57 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -143,3 +143,4 @@ EXAMPLES
 ::
=20
     ID       AttachType      AttachFlags     Name
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/=
bpf/bpftool/Documentation/bpftool-feature.rst
index dd3771bdbc57..e6b4b9efc6f7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -72,3 +72,4 @@ DESCRIPTION
 OPTIONS
 =3D=3D=3D=3D=3D=3D=3D
 	.. include:: common_options.rst
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf=
/bpftool/Documentation/bpftool-iter.rst
index 51f49bead619..30bfe3b1f529 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -68,3 +68,4 @@ EXAMPLES
=20
    Create a file-based bpf iterator from bpf_iter_hashmap.o and map with
    id 20, and pin it to /sys/fs/bpf/my_hashmap
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf=
/bpftool/Documentation/bpftool-link.rst
index 5f7db2a837cc..6d1ff68c5d6f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -106,3 +106,4 @@ EXAMPLES
 ::
=20
     -rw------- 1 root root 0 Apr 23 21:39 link
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/=
bpftool/Documentation/bpftool-map.rst
index dade10cdf295..6500612f4723 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -270,3 +270,4 @@ would be lost as soon as bpftool exits).
=20
   key: 00 00 00 00  value: 22 02 00 00
   Found 1 element
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/=
bpftool/Documentation/bpftool-net.rst
index d8165d530937..8450f7b9a10d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -172,3 +172,4 @@ EXAMPLES
 ::
=20
       xdp:
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf=
/bpftool/Documentation/bpftool-perf.rst
index e958ce91de72..1b5202d3d9ac 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -63,3 +63,4 @@ EXAMPLES
      {"pid":21765,"fd":5,"prog_id":7,"fd_type":"kretprobe","func":"__x64=
_sys_nanosleep","offset":0}, \
      {"pid":21767,"fd":5,"prog_id":8,"fd_type":"tracepoint","tracepoint"=
:"sys_enter_nanosleep"}, \
      {"pid":21800,"fd":5,"prog_id":9,"fd_type":"uprobe","filename":"/hom=
e/yhs/a.out","offset":1159}]
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf=
/bpftool/Documentation/bpftool-prog.rst
index 358c7309d419..3c7a90915d45 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -326,3 +326,4 @@ EXAMPLES
       40176203 cycles                                                 (8=
3.05%)
       42518139 instructions    #   1.06 insns per cycle               (8=
3.39%)
            123 llc_misses      #   2.89 LLC misses per million insns  (8=
3.15%)
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/too=
ls/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index 506e70ee78e9..ccfd215b17a0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -82,3 +82,4 @@ EXAMPLES
 ::
=20
    Registered tcp_congestion_ops cubic id 110
+
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpft=
ool/Documentation/bpftool.rst
index e7d949334961..1026f15b5c64 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -54,3 +54,4 @@ OPTIONS
 	-n, --nomount
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
+
--=20
2.24.1

