Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02027DB81
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgI2WPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:15:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728494AbgI2WPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:15:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08TM9rLd025082
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:15:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nX4DgKhZlsmRQG6G3SdybO15278MocScCpyRMiW8x1w=;
 b=rWMWU7V0D5OVe5lPVH/RAbMrIU9yzZvLeo/e4ZNN/GJXpzqZyAvsOxpBi2OdJ3RRc4gz
 oWQ11ZZqgQZYpR1P4x7fPY9PEx80aOmsk0+ju/r4rmOCtn8CrOARgljQl1UM73S+G7Y7
 pA4l+iGBf26nDwHuEk6IUftK/1fLcU7ImCI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33t14yg4h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:15:29 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 15:15:28 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E45CB2EC77D4; Tue, 29 Sep 2020 15:15:27 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 3/3] libbpf: compile in PIC mode only for shared library case
Date:   Tue, 29 Sep 2020 15:06:04 -0700
Message-ID: <20200929220604.833631-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929220604.833631-1-andriin@fb.com>
References: <20200929220604.833631-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=822 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290191
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf compiles .o's for static and shared library modes separately, so n=
o
need to specify -fPIC for both. Keep it only for shared library mode.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 70cb44efe8cb..5f9abed3e226 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -104,13 +104,12 @@ endif
 # Append required CFLAGS
 override CFLAGS +=3D $(EXTRA_WARNINGS) -Wno-switch-enum
 override CFLAGS +=3D -Werror -Wall
-override CFLAGS +=3D -fPIC
 override CFLAGS +=3D $(INCLUDES)
 override CFLAGS +=3D -fvisibility=3Dhidden
 override CFLAGS +=3D -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64
=20
 # flags specific for shared library
-SHLIB_FLAGS :=3D -DSHARED
+SHLIB_FLAGS :=3D -DSHARED -fPIC
=20
 ifeq ($(VERBOSE),1)
   Q =3D
--=20
2.24.1

