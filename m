Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05375A1201
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfH2GpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbfH2GpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:15 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T6j0WR027828
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=4JBmkh9SSbqk+8UUiDxddbk+iHWXMHRR/OLzX6xyxcs=;
 b=otKnqnsDbDTRCgZgoPbb9GbR8wassySvGOeDEeMzmADiQtL5cHcT8U383P1mooln1tcg
 8e0vec2wmLLYbfayGBnlkxW1lz263lu3kVWSQhPmtbMfWQ11x/gCfLwRapgMO2uWmzoV
 KQzMMKtf0hQL3litAuc6SwaDnrOelB3GRHA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2unvnk3bk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:14 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 23:45:08 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9D1883702BA3; Wed, 28 Aug 2019 23:45:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 04/13] bpf: refactor map_get_next_key()
Date:   Wed, 28 Aug 2019 23:45:06 -0700
Message-ID: <20190829064506.2750717-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=25 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=640
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor function map_get_next_key() with a new helper
bpf_map_get_next_key(), which will be used later
for batched map lookup/lookup_and_delete/delete operations.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b8bba499df11..06308f0206e5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1048,6 +1048,20 @@ static int map_delete_elem(union bpf_attr *attr)
 	return err;
 }
 
+static int bpf_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	int err;
+
+	if (bpf_map_is_dev_bound(map))
+		return bpf_map_offload_get_next_key(map, key, next_key);
+
+	rcu_read_lock();
+	err = map->ops->map_get_next_key(map, key, next_key);
+	rcu_read_unlock();
+
+	return err;
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define BPF_MAP_GET_NEXT_KEY_LAST_FIELD next_key
 
@@ -1088,15 +1102,7 @@ static int map_get_next_key(union bpf_attr *attr)
 	if (!next_key)
 		goto free_key;
 
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_get_next_key(map, key, next_key);
-		goto out;
-	}
-
-	rcu_read_lock();
-	err = map->ops->map_get_next_key(map, key, next_key);
-	rcu_read_unlock();
-out:
+	err = bpf_map_get_next_key(map, key, next_key);
 	if (err)
 		goto free_next_key;
 
-- 
2.17.1

