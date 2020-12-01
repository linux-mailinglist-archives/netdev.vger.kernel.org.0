Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5314C2C962B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 04:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbgLAD5G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 22:57:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387402AbgLAD5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 22:57:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B13uLwf005658
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:56:24 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3547g8h5bn-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 19:56:24 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 19:56:09 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4D4FF2ECA628; Mon, 30 Nov 2020 19:56:02 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 7/8] selftests/bpf: make bpf_testmod's traceable function global
Date:   Mon, 30 Nov 2020 19:55:44 -0800
Message-ID: <20201201035545.3013177-8-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201035545.3013177-1-andrii@kernel.org>
References: <20201201035545.3013177-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1034
 spamscore=0 suspectscore=8 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=694 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pahole currently isn't able to generate BTF for static functions in kernel
modules, so make sure traced sidecar function is global.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 4ff0cf23607d..2df19d73ca49 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -10,7 +10,7 @@
 #define CREATE_TRACE_POINTS
 #include "bpf_testmod-events.h"
 
-static noinline ssize_t
+noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
 		      char *buf, loff_t off, size_t len)
@@ -25,6 +25,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 
 	return -EIO; /* always fail */
 }
+EXPORT_SYMBOL(bpf_testmod_test_read);
 ALLOW_ERROR_INJECTION(bpf_testmod_test_read, ERRNO);
 
 static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
-- 
2.24.1

