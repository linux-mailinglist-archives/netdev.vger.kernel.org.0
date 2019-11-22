Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621F3105DC0
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVAfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:35:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfKVAfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:35:54 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM0Zkfo012170
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 16:35:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=8Ba2xBG5iaqJ5nVC6yegEqZt+ubrHmY0UvB+Rlm7aHE=;
 b=FFtptolbhNbKWICfy8V8+INfLeVYSiZKCB6A3UOiXnstWWgULFN5ktw/6iXGdE1Uo2em
 YoH7QqOXfTi2WynFvk4M00Kr7bL6oGxIx/r2bjomXgcYfxnlbCXL8ZlyLDRUKq44T/kJ
 gkX+i+ARISodLr2FJKHf9Ah+C5OcTepobeE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wd91hv7w5-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 16:35:53 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Nov 2019 16:35:34 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 31E802EC1D53; Thu, 21 Nov 2019 16:35:31 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix bpf_object name determination for bpf_object__open_file()
Date:   Thu, 21 Nov 2019 16:35:27 -0800
Message-ID: <20191122003527.551556-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=8 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxlogscore=973 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bpf_object__open_file() gets path like "some/dir/obj.o", it should derive
BPF object's name as "obj" (unless overriden through opts->object_name).
Instead, due to using `path` as a fallback value for opts->obj_name, path is
used as is for object name, so for above example BPF object's name will be
verbatim "some/dir/obj", which leads to all sorts of troubles, especially when
internal maps are concern (they are using up to 8 characters of object name).
Fix that by ensuring object_name stays NULL, unless overriden.

Fixes: 291ee02b5e40 ("libbpf: Refactor bpf_object__open APIs to use common opts")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a4e250a369c6..e1698461c6b3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3940,7 +3940,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	if (!OPTS_VALID(opts, bpf_object_open_opts))
 		return ERR_PTR(-EINVAL);
 
-	obj_name = OPTS_GET(opts, object_name, path);
+	obj_name = OPTS_GET(opts, object_name, NULL);
 	if (obj_buf) {
 		if (!obj_name) {
 			snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
-- 
2.17.1

