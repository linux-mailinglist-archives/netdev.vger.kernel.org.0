Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BDA224352
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgGQSrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:47:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728175AbgGQSrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:47:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HIYaBE025407
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:47:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0ztTVug7x2t80UXoWNU42SxtICydLJeqvLLBtfZ/gFo=;
 b=ZH57aRgNwXUGjsDrOG46XZRwG4YkfTZblDAAgKXIoOF2FxdAOIW/6+7S32Asjvg7BRqx
 Gpm9T/f/6kK7kv4cZMwKqZp9mf27gBFfcVjN6W9y8RCT3lj4qjiAJBK/vaAeszimInZC
 DH1Tthv6AzvEbR4kAlC3an6i2wHy+P/t4l8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32au0anntc-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:47:12 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 11:47:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 65E193704CE3; Fri, 17 Jul 2020 11:47:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] bpf: change var type of BTF_ID_LIST to static
Date:   Fri, 17 Jul 2020 11:47:06 -0700
Message-ID: <20200717184706.3477154-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200717184706.3476992-1-yhs@fb.com>
References: <20200717184706.3476992-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=8 mlxlogscore=806 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007170130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BTF_ID_LIST macro definition in btf_ids.h:
   #define BTF_ID_LIST(name)                \
   __BTF_ID_LIST(name)                      \
   extern u32 name[];

The variable defined in __BTF_ID_LIST has
".local" directive, which means the variable
is only available in the current file.
So change the scope of "name" in the declaration
from "extern" to "static".

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/btf_ids.h       | 2 +-
 tools/include/linux/btf_ids.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 1cdb56950ffe..cebc9a655959 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -66,7 +66,7 @@ asm(							\
=20
 #define BTF_ID_LIST(name)				\
 __BTF_ID_LIST(name)					\
-extern u32 name[];
+static u32 name[];
=20
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.=
h
index fe019774f8a7..b870776201e5 100644
--- a/tools/include/linux/btf_ids.h
+++ b/tools/include/linux/btf_ids.h
@@ -64,7 +64,7 @@ asm(							\
=20
 #define BTF_ID_LIST(name)				\
 __BTF_ID_LIST(name)					\
-extern u32 name[];
+static u32 name[];
=20
 /*
  * The BTF_ID_UNUSED macro defines 4 zero bytes.
--=20
2.24.1

