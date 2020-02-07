Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7D1553A1
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 09:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGIS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 03:18:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46056 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgBGISZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 03:18:25 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0178ILAt005106
        for <netdev@vger.kernel.org>; Fri, 7 Feb 2020 00:18:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4Bi3KKebGuwnCE2Wg3lcOsgdfWSKZzYEtvmsq2RBMGk=;
 b=Uogcjo4LvDnIiF0T3bNBBnVG5Ojx68QW8/h2BsrlIJj1ybBXC0oWTTqKvTTJ8ha8WsFj
 i5LcK9+FIqicTsBGBXaiTaxHrAAXXJ20lEbOkDmEOQR8eKJYQ9oAs+ayNpoKfB7cWxPI
 jVOyZdfrpaoWXOrmzezPlxDgO2+HuxRXWxs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2y0exsdtts-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 00:18:24 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 7 Feb 2020 00:18:19 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id E8B982944F9C; Fri,  7 Feb 2020 00:18:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        <netdev@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: Improve bucket_log calculation logic
Date:   Fri, 7 Feb 2020 00:18:10 -0800
Message-ID: <20200207081810.3918919-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=719
 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=13 phishscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that the max_t, ilog2, and roundup_pow_of_two macros have
exponential effects on the number of states in the sparse checker.

This patch breaks them up by calculating the "nbuckets" first so
that the "bucket_log" only needs to take ilog2().

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/bpf_sk_storage.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 458be6b3eda9..3ab23f698221 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -643,9 +643,10 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
 
+	nbuckets = roundup_pow_of_two(num_possible_cpus());
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
-	smap->bucket_log = max_t(u32, 1, ilog2(roundup_pow_of_two(num_possible_cpus())));
-	nbuckets = 1U << smap->bucket_log;
+	nbuckets = max_t(u32, 2, nbuckets);
+	smap->bucket_log = ilog2(nbuckets);
 	cost = sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
 
 	ret = bpf_map_charge_init(&smap->map.memory, cost);
-- 
2.17.1

