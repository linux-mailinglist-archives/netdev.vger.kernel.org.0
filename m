Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8CD77B5B
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388198AbfG0TCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:02:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61646 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388037AbfG0TCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:02:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIwtpn025313
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=9x7A3T3WKDCwVuu2HKqmp+GWtlJ1b/JlojeE+ECPYMY=;
 b=Fe+h86tQHbDqXMzhExu2SBkcFqJC+i6VI0Apm/lhVm6FACyRaGmNN6t0Etq2+DosOUA/
 Rg7NnkHeQasXW5UC4qXn+M7Ac6ZlyWepd+zePWLiM8CwDxBuFrlXSX5FQvcPKVJBqTzf
 ubV88DbFFXdqqXq4vtsVrNo3XrWuudYEB1k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0me8s4eh-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:02:11 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 12:02:06 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E3C3F861672; Sat, 27 Jul 2019 12:02:01 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 4/9] libbpf: return previous print callback from libbpf_set_print
Date:   Sat, 27 Jul 2019 12:01:45 -0700
Message-ID: <20190727190150.649137-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190727190150.649137-1-andriin@fb.com>
References: <20190727190150.649137-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=751 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By returning previously set print callback from libbpf_set_print, it's
possible to restore it, eventually. This is useful when running many
independent test with one default print function, but overriding log
verbosity for particular subset of tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 tools/lib/bpf/libbpf.h | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8741c39adb1c..ead915aec349 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -74,9 +74,12 @@ static int __base_pr(enum libbpf_print_level level, const char *format,
 
 static libbpf_print_fn_t __libbpf_pr = __base_pr;
 
-void libbpf_set_print(libbpf_print_fn_t fn)
+libbpf_print_fn_t libbpf_set_print(libbpf_print_fn_t fn)
 {
+	libbpf_print_fn_t old_print_fn = __libbpf_pr;
+
 	__libbpf_pr = fn;
+	return old_print_fn;
 }
 
 __printf(2, 3)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5cbf459ece0b..8a9d462a6f6d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -57,7 +57,7 @@ enum libbpf_print_level {
 typedef int (*libbpf_print_fn_t)(enum libbpf_print_level level,
 				 const char *, va_list ap);
 
-LIBBPF_API void libbpf_set_print(libbpf_print_fn_t fn);
+LIBBPF_API libbpf_print_fn_t libbpf_set_print(libbpf_print_fn_t fn);
 
 /* Hide internal to user */
 struct bpf_object;
-- 
2.17.1

