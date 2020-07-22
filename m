Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD8A228F42
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 06:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgGVEiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 00:38:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726447AbgGVEiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 00:38:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06M4cFWP026563
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 21:38:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Lo3yWTTfeJ4VsHTNA8e6aoYA5wqC6eToHIgzHHm5WIE=;
 b=V4TzX+vgcr0+x1zwGXxhUjKKp0twcIrv8BVq2Br0y3+K41vBO8sIPc7QUauvPfpR+9KN
 TGxyCDJ6gW+1fON5KQfR1kp6mBccRjCFZ/tX52JgMz1To99Dmz+4izPqJNFU6D9kIo01
 N3u3jH/VhGfQPKPffQhMkhurFoSM1bA+Ugw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32bvrnqq0d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 21:38:15 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 21:38:11 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6E9972EC4825; Tue, 21 Jul 2020 21:38:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/bpftool: strip BPF .o files before skeleton generation
Date:   Tue, 21 Jul 2020 21:38:04 -0700
Message-ID: <20200722043804.2373298-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_02:2020-07-21,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 mlxlogscore=482 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Strip away DWARF info from .bpf.o files, before generating BPF skeletons.
This reduces bpftool binary size from 3.43MB to 2.58MB.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 51bd520ed437..8462690a039b 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -59,6 +59,7 @@ endif
 INSTALL ?=3D install
 RM ?=3D rm -f
 CLANG ?=3D clang
+LLVM_STRIP ?=3D llvm-strip
=20
 FEATURE_USER =3D .bpftool
 FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib libcap=
 \
@@ -147,7 +148,7 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h=
 $(LIBBPF)
 		-I$(srctree)/tools/include/uapi/ \
 		-I$(LIBBPF_PATH) \
 		-I$(srctree)/tools/lib \
-		-g -O2 -target bpf -c $< -o $@
+		-g -O2 -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
=20
 $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
 	$(QUIET_GEN)$(BPFTOOL_BOOTSTRAP) gen skeleton $< > $@
--=20
2.24.1

