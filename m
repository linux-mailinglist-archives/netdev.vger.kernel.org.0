Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C999D445D7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404187AbfFMQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:47:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730249AbfFMFFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 01:05:04 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D552jG024802
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 22:05:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=SI24W5Z8EyLLOK4C9Z6ksLNPnCBwReaLrAALT/kmwL0=;
 b=HPVyuC10xIfBTonIEfOTQy1g8y2wlBHvj3fiktyUStuBkiGb/9axaNkffAzPGv0nk9Jd
 ITodZwkSJi71rvt+mreWGxuRx5xhJ6+zE76A0xAhRbTkIg6rS9Jkg34j9EL4ca7EUPia
 yaeftHx0mwOJhTLTHA9rVes6b+1k+6C00+4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t38w718fd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 22:05:02 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 22:05:01 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 70D1B861777; Wed, 12 Jun 2019 22:04:59 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <dan.carpenter@oracle.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: fix check for presence of associated BTF for map creation
Date:   Wed, 12 Jun 2019 22:04:57 -0700
Message-ID: <20190613050457.290884-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel internally checks that either key or value type ID is specified,
before using btf_fd. Do the same in libbpf's map creation code for
determining when to retry map creation w/o BTF.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: fba01a0689a9 ("libbpf: use negative fd to specify missing BTF")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index dd8b2cd5d3a7..e725fa86b189 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1736,7 +1736,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 		create_attr.key_size = def->key_size;
 		create_attr.value_size = def->value_size;
 		create_attr.max_entries = def->max_entries;
-		create_attr.btf_fd = -1;
+		create_attr.btf_fd = 0;
 		create_attr.btf_key_type_id = 0;
 		create_attr.btf_value_type_id = 0;
 		if (bpf_map_type__is_map_in_map(def->type) &&
@@ -1750,11 +1750,12 @@ bpf_object__create_maps(struct bpf_object *obj)
 		}
 
 		*pfd = bpf_create_map_xattr(&create_attr);
-		if (*pfd < 0 && create_attr.btf_fd >= 0) {
+		if (*pfd < 0 && (create_attr.btf_key_type_id ||
+				 create_attr.btf_value_type_id)) {
 			cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 			pr_warning("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
 				   map->name, cp, errno);
-			create_attr.btf_fd = -1;
+			create_attr.btf_fd = 0;
 			create_attr.btf_key_type_id = 0;
 			create_attr.btf_value_type_id = 0;
 			map->btf_key_type_id = 0;
@@ -2045,7 +2046,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	load_attr.prog_btf_fd = prog->btf_fd;
+	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
 	load_attr.func_info_cnt = prog->func_info_cnt;
-- 
2.17.1

