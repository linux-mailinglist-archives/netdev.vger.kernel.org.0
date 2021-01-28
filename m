Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57E630689B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhA1AXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:23:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229682AbhA1AVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:21:24 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10S0DuGe003037
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:20:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xw7lWCeLzzObrvYrpYTfD77frYhsCS+HfiI62osPAeI=;
 b=lGwmEdrIWiMPysTX4aiqk1LN5fGCZ1Rf2E7vMNpIATXvxYqohuleDqOpqxsLhfwo/2x+
 TG+/PAlDIbDOfoB+er1/A5H0ObAZvqyRv7/qWskc0tSDYjT9+LsbM2yVgChf1tpiJx2c
 quN/Ns4FvzKE5yb8VTTaH8MSXBguFcPTNZM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36awcpp7k8-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 16:20:42 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 16:20:41 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 385C262E0B6C; Wed, 27 Jan 2021 16:20:40 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <daniel@iogearbox.net>,
        <kpsingh@chromium.org>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 bpf-next 3/4] bpf: runqslower: prefer using local vmlimux to generate vmlinux.h
Date:   Wed, 27 Jan 2021 16:19:47 -0800
Message-ID: <20210128001948.1637901-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210128001948.1637901-1-songliubraving@fb.com>
References: <20210128001948.1637901-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_10:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=551 priorityscore=1501 spamscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the Makefile to prefer using $(O)/mvlinux, $(KBUILD_OUTPUT)/vmlinu=
x
(for selftests) or ../../../vmlinux. These two files should have latest
definitions for vmlinux.h.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/bpf/runqslower/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
index 4d5ca54fcd4c8..e6d1f85a3871f 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -19,7 +19,10 @@ CFLAGS :=3D -g -Wall
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

