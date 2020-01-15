Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0138613D074
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgAOXAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:00:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731041AbgAOXAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:00:42 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FN0Vpw008819
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:00:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Au1NW+TCBZHnyU0owvpPHDXCAXIBOkyFDZYaM//dsB4=;
 b=GXjwIND6SP6hnu4+OpgXcVfFqXnU7V/PK5YLzfvrLmvbqAwZ2Ch/N2OrkkO4PL9wuhjZ
 uJ7UUpBkrnzAz4ol3wf6ZFyjIvQzH8NZF6fcQlw/NiLolXXS3qs9NxY9/l0Fpf4sbPEE
 harv2VKSUu4LPfSBbvb6VGMFv9diwomd9Tc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhwp4bvrv-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 15:00:41 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 15:00:20 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3C8442941680; Wed, 15 Jan 2020 15:00:19 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Paul Chaignon <paul.chaignon@orange.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/5] bpftool: Fix a leak of btf object
Date:   Wed, 15 Jan 2020 15:00:19 -0800
Message-ID: <20200115230019.1101352-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200115230012.1100525-1-kafai@fb.com>
References: <20200115230012.1100525-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=38
 clxscore=1015 mlxscore=0 mlxlogscore=922 malwarescore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing a map has btf or not, maps_have_btf() tests it by actually
getting a btf_fd from sys_bpf(BPF_BTF_GET_FD_BY_ID). However, it
forgot to btf__free() it.

In maps_have_btf() stage, there is no need to test it by really
calling sys_bpf(BPF_BTF_GET_FD_BY_ID). Testing non zero
info.btf_id is good enough.

Also, the err_close case is unnecessary, and also causes double
close() because the calling func do_dump() will close() all fds again.

Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
Cc: Paul Chaignon <paul.chaignon@orange.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/bpf/bpftool/map.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index c01f76fa6876..e00e9e19d6b7 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -915,32 +915,20 @@ static int maps_have_btf(int *fds, int nb_fds)
 {
 	struct bpf_map_info info = {};
 	__u32 len = sizeof(info);
-	struct btf *btf = NULL;
 	int err, i;
 
 	for (i = 0; i < nb_fds; i++) {
 		err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
 		if (err) {
 			p_err("can't get map info: %s", strerror(errno));
-			goto err_close;
-		}
-
-		err = btf__get_from_id(info.btf_id, &btf);
-		if (err) {
-			p_err("failed to get btf");
-			goto err_close;
+			return -1;
 		}
 
-		if (!btf)
+		if (!info.btf_id)
 			return 0;
 	}
 
 	return 1;
-
-err_close:
-	for (; i < nb_fds; i++)
-		close(fds[i]);
-	return -1;
 }
 
 static int
-- 
2.17.1

