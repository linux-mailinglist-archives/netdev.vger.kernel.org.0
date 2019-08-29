Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9051A11FE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfH2GpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727709AbfH2GpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7T6ik7m031718
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=RTUOo1BwqhnVUq35G8a1VqakW/Dum7lH+VerkCIZWBA=;
 b=BfO5Z7bwFVdAZ0dqqd3J4e8rgKfcn/VH4OmRBqUZ3VLa2Q9GEZNzfT9HRmNeQh/j+5u4
 DEAFlelcsO9m+wyZNDsLb+L8482QNDjxyAt8nUlA1VtQx1iXfcWB33dhQ5QtySimXSiY
 RbdPS66TFu8ykY+kaD/FvpZy8BNylX8WSiw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2up2dxsewy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:17 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:10 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6AAB33702BA3; Wed, 28 Aug 2019 23:45:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 03/13] bpf: refactor map_delete_elem()
Date:   Wed, 28 Aug 2019 23:45:05 -0700
Message-ID: <20190829064505.2750541-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829064502.2750303-1-yhs@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 phishscore=0 mlxlogscore=601 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1908290073
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor function map_delete_elem() with a new helper
bpf_map_delete_elem(), which will be used later
for batched lookup_and_delete and delete operations.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/syscall.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3caa0ab3d30d..b8bba499df11 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -992,6 +992,25 @@ static int map_update_elem(union bpf_attr *attr)
 	return err;
 }
 
+static int bpf_map_delete_elem(struct bpf_map *map, void *key)
+{
+	int err;
+
+	if (bpf_map_is_dev_bound(map))
+		return bpf_map_offload_delete_elem(map, key);
+
+	preempt_disable();
+	__this_cpu_inc(bpf_prog_active);
+	rcu_read_lock();
+	err = map->ops->map_delete_elem(map, key);
+	rcu_read_unlock();
+	__this_cpu_dec(bpf_prog_active);
+	preempt_enable();
+	maybe_wait_bpf_programs(map);
+
+	return err;
+}
+
 #define BPF_MAP_DELETE_ELEM_LAST_FIELD key
 
 static int map_delete_elem(union bpf_attr *attr)
@@ -1021,20 +1040,8 @@ static int map_delete_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	if (bpf_map_is_dev_bound(map)) {
-		err = bpf_map_offload_delete_elem(map, key);
-		goto out;
-	}
+	err = bpf_map_delete_elem(map, key);
 
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
-	rcu_read_lock();
-	err = map->ops->map_delete_elem(map, key);
-	rcu_read_unlock();
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
-	maybe_wait_bpf_programs(map);
-out:
 	kfree(key);
 err_put:
 	fdput(f);
-- 
2.17.1

