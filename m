Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6481C179D76
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCEBfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:35:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727002AbgCEBf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 20:35:28 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0251XegN005310
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 17:35:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/OcLgUDfVCjhMlPip7eEcYSu0MtNsit6nT8dHqk9X9g=;
 b=piDLHCTikVfkBn4gMVpW3bsBllsvDq64JV1lTi+BEcXaZwB1KZQEPnlVorlPlUCJ9dod
 SLU80fAkkR9uzrNc65lV1cl8WwxqL9dfaTi7MfnRzKCWKEKTwtpVIrlQHcCw9wSUsQ3F
 1s7XelUd7BPNLizXlxqQiAvj1vn9yXUGt/8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yhwxxqufc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 17:35:27 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 4 Mar 2020 17:34:54 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 14CB329425EB; Wed,  4 Mar 2020 17:34:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: Return better error value in delete_elem for struct_ops map
Date:   Wed, 4 Mar 2020 17:34:47 -0800
Message-ID: <20200305013447.535326-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305013437.534961-1-kafai@fb.com>
References: <20200305013437.534961-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_10:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=980 impostorscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 suspectscore=15 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current always succeed behavior in bpf_struct_ops_map_delete_elem()
is not ideal for userspace tool.  It can be improved to return proper
error value.

If it is in TOBEFREE, it means unregistration has been already done
before but it is in progress and waiting for the subsystem to clear
the refcnt to zero, so -EINPROGRESS.

If it is INIT, it means the struct_ops has not been registered yet,
so -ENOENT.

Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/bpf_struct_ops.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 042f95534f86..68a89a9f7ccd 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -482,13 +482,21 @@ static int bpf_struct_ops_map_delete_elem(struct bpf_map *map, void *key)
 	prev_state = cmpxchg(&st_map->kvalue.state,
 			     BPF_STRUCT_OPS_STATE_INUSE,
 			     BPF_STRUCT_OPS_STATE_TOBEFREE);
-	if (prev_state == BPF_STRUCT_OPS_STATE_INUSE) {
+	switch (prev_state) {
+	case BPF_STRUCT_OPS_STATE_INUSE:
 		st_map->st_ops->unreg(&st_map->kvalue.data);
 		if (refcount_dec_and_test(&st_map->kvalue.refcnt))
 			bpf_map_put(map);
+		return 0;
+	case BPF_STRUCT_OPS_STATE_TOBEFREE:
+		return -EINPROGRESS;
+	case BPF_STRUCT_OPS_STATE_INIT:
+		return -ENOENT;
+	default:
+		WARN_ON_ONCE(1);
+		/* Should never happen.  Treat it as not found. */
+		return -ENOENT;
 	}
-
-	return 0;
 }
 
 static void bpf_struct_ops_map_seq_show_elem(struct bpf_map *map, void *key,
-- 
2.17.1

