Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5324242A
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgHLC7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:59:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgHLC7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:59:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07C2qrEc004361
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:59:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nveDaz9ZPnstwHr5avUANBycGpXuyGFPpnu3efd6xbc=;
 b=S5ZH2osG/ZO2UxRjLeMyTaMM/vYBpyP5p7WNrwQ9ns/t6n7Vq0d6SlAV+0vXAog2x+r+
 Q57uUnr5Z89SbYVd2x0+Nr2NoqD/gFagOD4D6eGLR7IqWb+9TjshLPdlyZnyHEF2ftKY
 rHr0uHhWMs9eXWzRKss24vcTPwleM0wwrRk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32v0kjt02t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:59:12 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 11 Aug 2020 19:59:12 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C87402EC5953; Tue, 11 Aug 2020 19:59:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] tools/bpftool: make skeleton code C++17-friendly by dropping typeof()
Date:   Tue, 11 Aug 2020 19:59:07 -0700
Message-ID: <20200812025907.1371956-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_19:2020-08-11,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=868 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seems like C++17 standard mode doesn't recognize typeof() anymore. This c=
an
be tested by compiling test_cpp test with -std=3Dc++17 or -std=3Dc++1z op=
tions.
The use of typeof in skeleton generated code is unnecessary, all types ar=
e
well-known at the time of code generation, so remove all typeof()'s to ma=
ke
skeleton code more future-proof when interacting with C++ compilers.

Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8a4c2b3b0cd6..db80e836816e 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -397,7 +397,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct %1$s *obj;				    \n\
 									    \n\
-			obj =3D (typeof(obj))calloc(1, sizeof(*obj));	    \n\
+			obj =3D (struct %1$s *)calloc(1, sizeof(*obj));	    \n\
 			if (!obj)					    \n\
 				return NULL;				    \n\
 			if (%1$s__create_skeleton(obj))			    \n\
@@ -461,7 +461,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct bpf_object_skeleton *s;			    \n\
 									    \n\
-			s =3D (typeof(s))calloc(1, sizeof(*s));		    \n\
+			s =3D (struct bpf_object_skeleton *)calloc(1, sizeof(*s));\n\
 			if (!s)						    \n\
 				return -1;				    \n\
 			obj->skeleton =3D s;				    \n\
@@ -479,7 +479,7 @@ static int do_skeleton(int argc, char **argv)
 				/* maps */				    \n\
 				s->map_cnt =3D %zu;			    \n\
 				s->map_skel_sz =3D sizeof(*s->maps);	    \n\
-				s->maps =3D (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);\n\
+				s->maps =3D (struct bpf_map_skeleton *)calloc(s->map_cnt, s->map_ske=
l_sz);\n\
 				if (!s->maps)				    \n\
 					goto err;			    \n\
 			",
@@ -515,7 +515,7 @@ static int do_skeleton(int argc, char **argv)
 				/* programs */				    \n\
 				s->prog_cnt =3D %zu;			    \n\
 				s->prog_skel_sz =3D sizeof(*s->progs);	    \n\
-				s->progs =3D (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);=
\n\
+				s->progs =3D (struct bpf_prog_skeleton *)calloc(s->prog_cnt, s->prog=
_skel_sz);\n\
 				if (!s->progs)				    \n\
 					goto err;			    \n\
 			",
--=20
2.24.1

