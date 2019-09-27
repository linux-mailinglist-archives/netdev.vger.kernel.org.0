Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2159BC09D5
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfI0Qwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:52:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbfI0Qwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:52:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8RGe894000663
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:52:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Ih1aOj4sWxSL2hNxjqXRnOy5s6MhWA/QoCRk88X4s1Y=;
 b=UCy3/s2/42KU5f6N9Ohoyk7xb7e/OJoSleTWziV3aowF6hSNCnAQxQlB0LuZCMbnIpm0
 9du18ulrXAsgh21VRq7Bj2Nbygl3U5Py8XkW6PqtpCCO3SF31VlXYAjI8e8I1I+Kxl+N
 LV97OpycveAHIZodzBG0xOnPMQ0DQtl52Kk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v9mqsghca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 09:52:28 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Sep 2019 09:52:23 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 4461329412CD; Fri, 27 Sep 2019 09:52:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
Date:   Fri, 27 Sep 2019 09:52:21 -0700
Message-ID: <20190927165221.2391541-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_08:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=25 clxscore=1015
 mlxscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In reuseport_array_free(), the rcu_read_lock() cannot ensure sk is still
valid.  It is because bpf_sk_reuseport_detach() can be called from
__sk_destruct() which is invoked through call_rcu(..., __sk_destruct).

This patch takes the reuseport_lock in reuseport_array_free() which
is not the fast path.  The lock is taken inside the loop in case
that the bpf map is big.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/reuseport_array.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 50c083ba978c..9e593ac31ad7 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -103,29 +103,11 @@ static void reuseport_array_free(struct bpf_map *map)
 	 * array now. Hence, this function only races with
 	 * bpf_sk_reuseport_detach() which was triggerred by
 	 * close() or disconnect().
-	 *
-	 * This function and bpf_sk_reuseport_detach() are
-	 * both removing sk from "array".  Who removes it
-	 * first does not matter.
-	 *
-	 * The only concern here is bpf_sk_reuseport_detach()
-	 * may access "array" which is being freed here.
-	 * bpf_sk_reuseport_detach() access this "array"
-	 * through sk->sk_user_data _and_ with sk->sk_callback_lock
-	 * held which is enough because this "array" is not freed
-	 * until all sk->sk_user_data has stopped referencing this "array".
-	 *
-	 * Hence, due to the above, taking "reuseport_lock" is not
-	 * needed here.
 	 */
-
-	/*
-	 * Since reuseport_lock is not taken, sk is accessed under
-	 * rcu_read_lock()
-	 */
-	rcu_read_lock();
 	for (i = 0; i < map->max_entries; i++) {
-		sk = rcu_dereference(array->ptrs[i]);
+		spin_lock_bh(&reuseport_lock);
+		sk = rcu_dereference_protected(array->ptrs[i],
+					lockdep_is_held(&reuseport_lock));
 		if (sk) {
 			write_lock_bh(&sk->sk_callback_lock);
 			/*
@@ -137,8 +119,9 @@ static void reuseport_array_free(struct bpf_map *map)
 			write_unlock_bh(&sk->sk_callback_lock);
 			RCU_INIT_POINTER(array->ptrs[i], NULL);
 		}
+		spin_unlock_bh(&reuseport_lock);
+		cond_resched();
 	}
-	rcu_read_unlock();
 
 	/*
 	 * Once reaching here, all sk->sk_user_data is not
-- 
2.17.1

