Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544E8109525
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfKYV3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:29:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23160 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfKYV3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:29:53 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPLS3XZ016242
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:29:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=yushD8z+ebHuwYYdAk8+lPwfKALS1XVbLw9s3XZz/Gc=;
 b=buObwRLneU4oRgCaNp6YFAXY02cePSayZ14xMsXDxf3HSY/DwgxfmOY2MvbYcnbBxsW/
 j6Mvmft7qV/gHs9XpvW0smbW6H4Q7Pt5fe8SJ/nfpct20XixxVZNZ34lU4rLkrFf60ls
 wd9st3o9Ym1TN8yIYtPnecIPe6+5LR+xPsg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wfny683fq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:29:52 -0800
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 25 Nov 2019 13:29:51 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9AB332EC1958; Mon, 25 Nov 2019 13:29:50 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix usage of u32 in userspace code
Date:   Mon, 25 Nov 2019 13:29:48 -0800
Message-ID: <20191125212948.1163343-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_05:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=608
 suspectscore=8 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911250172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

u32 is not defined for libbpf when compiled outside of kernel sources (e.g.,
in Github projection). Use __u32 instead.

Fixes: b8c54ea455dc ("libbpf: Add support to attach to fentry/fexit tracing progs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e1698461c6b3..b20f82e58989 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5128,7 +5128,7 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 	char *dst = raw_tp_btf + sizeof(BTF_PREFIX) - 1;
 	const char *btf_name;
 	int err = -EINVAL;
-	u32 kind;
+	__u32 kind;
 
 	if (IS_ERR(btf)) {
 		pr_warn("vmlinux BTF is not found\n");
-- 
2.17.1

