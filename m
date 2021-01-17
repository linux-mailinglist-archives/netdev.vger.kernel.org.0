Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF08D2F95DE
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbhAQWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:21:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54944 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbhAQWVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:21:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMKbVc075239;
        Sun, 17 Jan 2021 22:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=bRmwOY57xXtZW86mDxjYm8OH2EnZFkmiALdzHfMFHjI=;
 b=KGmfN8luvrVnLnk3tD8o13tEX7oW3oqP4jV2VsJINhiWz31/KoxQXi3cbJzvSfTItE8o
 bgLOULuili2BI1F1zHuCubWQ0jtU+pUw7H92vndudrqF2s0k5gMpPlhvfagHAlhkJGFj
 KmJMPg45W/c4qPVT6fc4dTQFebdZEUbPDx05n970/zaNpkyAx+d1pFUpA8VGjnvrTW6m
 ozXFvOHy04obYPuGLteBK3zTBUoHsh+8vBDSIy7zMxpTzWkFO6TECHzgvfYEQRCxaqOt
 OaehiTDNFJvEJijwAunjbjm82TKTO39rLFcOG74Uq54Ulok0/v2qAHwyOqHjAeLHCHCn rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 363r3kjvrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMBJIW092448;
        Sun, 17 Jan 2021 22:20:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 364a2u5yu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:36 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10HMKZ2u014917;
        Sun, 17 Jan 2021 22:20:35 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Jan 2021 14:20:34 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/4] libbpf: make skip_mods_and_typedefs available internally in libbpf
Date:   Sun, 17 Jan 2021 22:16:02 +0000
Message-Id: <1610921764-7526-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_dump.c will need it for type-based data display.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c          | 4 +---
 tools/lib/bpf/libbpf_internal.h | 2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2abbc38..4ef84e1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -73,8 +73,6 @@
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
-static const struct btf_type *
-skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
 
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
@@ -1885,7 +1883,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static const struct btf_type *
+const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
 {
 	const struct btf_type *t = btf__type_by_id(btf, id);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 969d0ac..c25d2df 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -108,6 +108,8 @@ static inline void *libbpf_reallocarray(void *ptr, size_t nmemb, size_t size)
 void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
 int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
+const struct btf_type *skip_mods_and_typedefs(const struct btf *btf, __u32 id,
+					      __u32 *res_id);
 
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
-- 
1.8.3.1

