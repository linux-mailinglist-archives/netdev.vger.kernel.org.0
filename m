Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7340325A61
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBYXqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:46:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232806AbhBYXoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 18:44:34 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 11PNdcga010649
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+q9icw4w72ZW+9dnDuoTVCwteqypUS3djmQoNnUrw1Q=;
 b=FgJ2HeWM1gbH6nBphvy8XnOGyjuVKkkbkNjI+cKQVSAM9L5c6G576cPQ07qhxqSx5KC8
 +RsVkmRE+tt0UtMxnuWoexly4xtU1zlHFjKT2VraEpEsh3P8QS7NXsDtZO4afiNj4qkz
 HpjBzNFybqLBTpd6ubiYQeltU46meEsbTNk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 36wncftwdr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 15:43:52 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 15:43:51 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0B16762E1BF5; Thu, 25 Feb 2021 15:43:47 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v6 bpf-next 5/6] bpf: runqslower: prefer using local vmlimux to generate vmlinux.h
Date:   Thu, 25 Feb 2021 15:43:18 -0800
Message-ID: <20210225234319.336131-6-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210225234319.336131-1-songliubraving@fb.com>
References: <20210225234319.336131-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_15:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 mlxlogscore=548 priorityscore=1501 spamscore=0 phishscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250179
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

