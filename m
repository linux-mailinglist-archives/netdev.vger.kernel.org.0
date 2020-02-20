Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25817166ABB
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgBTXGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:06:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12904 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727135AbgBTXGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:06:11 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KN4iUX023886
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 15:06:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=MESG69cFfDUetraqyLOHK3/VfUguFDCaDZdCXKWqQRg=;
 b=fUspCS98Y2QUcN5Q5HXRf1doad22OoV5Klo98SHbcfrrq/970DynpQ6fhObx2hGVsaSp
 PbhuhMbcywJb9HERBcmvmHPJOdj+oa7h8Go2kA2W4qbmOz75xzzR+6tK0rxJdc61DR3h
 TVgWb1xpKBAIQegi4sPwSPr6Pq05eG+K268= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y9dm3652d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 15:06:09 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 20 Feb 2020 15:06:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8FF252EC2C3F; Thu, 20 Feb 2020 15:05:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up logic
Date:   Thu, 20 Feb 2020 15:05:46 -0800
Message-ID: <20200220230546.769250-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_18:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=8
 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=636 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200169
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
clean up is performed correctly.

Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 1f6ccdaed1ac..781c8d11604b 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -55,31 +55,40 @@ void test_trampoline_count(void)
 	/* attach 'allowed' 40 trampoline programs */
 	for (i = 0; i < MAX_TRAMP_PROGS; i++) {
 		obj = bpf_object__open_file(object, NULL);
-		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
+			obj = NULL;
 			goto cleanup;
+		}
 
 		err = bpf_object__load(obj);
 		if (CHECK(err, "obj_load", "err %d\n", err))
 			goto cleanup;
 		inst[i].obj = obj;
+		obj = NULL;
 
 		if (rand() % 2) {
-			link = load(obj, fentry_name);
-			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
+			link = load(inst[i].obj, fentry_name);
+			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
+				link = NULL;
 				goto cleanup;
+			}
 			inst[i].link_fentry = link;
 		} else {
-			link = load(obj, fexit_name);
-			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link)))
+			link = load(inst[i].obj, fexit_name);
+			if (CHECK(IS_ERR(link), "attach prog", "err %ld\n", PTR_ERR(link))) {
+				link = NULL;
 				goto cleanup;
+			}
 			inst[i].link_fexit = link;
 		}
 	}
 
 	/* and try 1 extra.. */
 	obj = bpf_object__open_file(object, NULL);
-	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
+		obj = NULL;
 		goto cleanup;
+	}
 
 	err = bpf_object__load(obj);
 	if (CHECK(err, "obj_load", "err %d\n", err))
@@ -104,7 +113,9 @@ void test_trampoline_count(void)
 cleanup_extra:
 	bpf_object__close(obj);
 cleanup:
-	while (--i) {
+	if (i >= MAX_TRAMP_PROGS)
+		i = MAX_TRAMP_PROGS - 1;
+	for (; i >= 0; i--) {
 		bpf_link__destroy(inst[i].link_fentry);
 		bpf_link__destroy(inst[i].link_fexit);
 		bpf_object__close(inst[i].obj);
-- 
2.17.1

