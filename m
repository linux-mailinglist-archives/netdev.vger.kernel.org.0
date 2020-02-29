Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C291749FC
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 00:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbgB2XL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 18:11:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64092 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727588AbgB2XL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 18:11:29 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01TN6APF029975
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=HdaF6E/tdqPzKasSL6Qg5A5AezuavKE377fn6ynbpXg=;
 b=Gd/7qOYVbdbzbvtyDA/u4zC3xlAmfp7QkwgWM1alndiiNXV64qKl205wvpYVcsP34YWF
 K8dd0/bHhMaKxjblZUL2buylwlDYTKJ2UlcT0wP3a4MP3jyeBcvr9ZJMIoNwSLQ5bY6Y
 76HmctWH8nxOaIf2t2F/5oz5Xy874GzbBMw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfmvgt5qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:28 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 15:11:27 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D58082EC2C66; Sat, 29 Feb 2020 15:11:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/4] bpftool: add header guards to generated vmlinux.h
Date:   Sat, 29 Feb 2020 15:11:09 -0800
Message-ID: <20200229231112.1240137-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229231112.1240137-1-andriin@fb.com>
References: <20200229231112.1240137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=25
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add canonical #ifndef/#define/#endif guard for generated vmlinux.h header with
__VMLINUX_H__ symbol. __VMLINUX_H__ is also going to play double role of
identifying whether vmlinux.h is being used, versus, say, BCC or non-CO-RE
libbpf modes with dependency on kernel headers. This will make it possible to
write helper macro/functions, agnostic to exact BPF program set up.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index b3745ed711ba..bcaf55b59498 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -389,6 +389,9 @@ static int dump_btf_c(const struct btf *btf,
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
+	printf("#ifndef __VMLINUX_H__\n");
+	printf("#define __VMLINUX_H__\n");
+	printf("\n");
 	printf("#ifndef BPF_NO_PRESERVE_ACCESS_INDEX\n");
 	printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
 	printf("#endif\n\n");
@@ -412,6 +415,8 @@ static int dump_btf_c(const struct btf *btf,
 	printf("#ifndef BPF_NO_PRESERVE_ACCESS_INDEX\n");
 	printf("#pragma clang attribute pop\n");
 	printf("#endif\n");
+	printf("\n");
+	printf("#endif /* __VMLINUX_H__ */\n");
 
 done:
 	btf_dump__free(d);
-- 
2.17.1

