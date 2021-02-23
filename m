Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBBF3233D3
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 23:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhBWWgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 17:36:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19480 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232365AbhBWW3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 17:29:53 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NMOUvu001776
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 14:29:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+q9icw4w72ZW+9dnDuoTVCwteqypUS3djmQoNnUrw1Q=;
 b=Uwh+FOqTkGX8pTc8Py2iB8C+PKuoUmwYoU2fppokFXv1ZuKzyTRB5lTtFEjRpoWNgQ4/
 +tV4JOamnfX0q/Oyo8KwNO1m/9DtBymiQ7Tuf/NLLYqp20x4sqNawxUeEJG0oeLuWFi5
 0cwPWf5P/xzoL3UHROM0KUOXawrpSw1D3tE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36v9gna8ny-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 14:29:11 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 14:29:09 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B7CA962E093E; Tue, 23 Feb 2021 14:29:07 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v5 bpf-next 5/6] bpf: runqslower: prefer using local vmlimux to generate vmlinux.h
Date:   Tue, 23 Feb 2021 14:28:44 -0800
Message-ID: <20210223222845.2866124-6-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210223222845.2866124-1-songliubraving@fb.com>
References: <20210223222845.2866124-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_11:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=539
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230189
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the Makefile to prefer using $(O)/vmlinux, $(KBUILD_OUTPUT)/vmlinu=
x
(for selftests) or ../../../vmlinux. These two files should have latest
definitions for vmlinux.h.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/runqslower/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
index 9d9fb6209be1b..c96ba90c6f018 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -16,7 +16,10 @@ CFLAGS :=3D -g -Wall
=20
 # Try to detect best kernel BTF source
 KERNEL_REL :=3D $(shell uname -r)
-VMLINUX_BTF_PATHS :=3D /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_RE=
L)
+VMLINUX_BTF_PATHS :=3D $(if $(O),$(O)/vmlinux)		\
+	$(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux) \
+	../../../vmlinux /sys/kernel/btf/vmlinux	\
+	/boot/vmlinux-$(KERNEL_REL)
 VMLINUX_BTF_PATH :=3D $(or $(VMLINUX_BTF),$(firstword			       \
 					  $(wildcard $(VMLINUX_BTF_PATHS))))
=20
--=20
2.24.1

