Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099E5772D9
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGZUiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:38:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33754 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727239AbfGZUiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:38:07 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QKT1gU006342
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jYf9mMZ2CZMmUNiPASsPDHujg5g+F96KnNbgXKU7W3A=;
 b=ih2pWnqABvAzvL2G2UdyRut9jAGFgtMJ2ZifqWtr7q7jlCVSRnqdhJVRPtEJAnfNoeZK
 Muf8++WCRZoK79FUo2mZYwVMD5H2OnKRuDlKoH110fTA0EtW3qHBQsKW/SlYVJexeFTf
 UasOCgERdPpxD//saF6GYNMNYRjt12reocU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u08d182f3-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:38:06 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 13:38:04 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id F1B6E861663; Fri, 26 Jul 2019 13:38:00 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/9] libbpf: add libbpf_swap_print to get previous print func
Date:   Fri, 26 Jul 2019 13:37:42 -0700
Message-ID: <20190726203747.1124677-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190726203747.1124677-1-andriin@fb.com>
References: <20190726203747.1124677-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=884 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260234
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf_swap_print allows to restore previously set print function.
This is useful when running many independent test with one default print
function, but overriding log verbosity for particular subset of tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 8 ++++++++
 tools/lib/bpf/libbpf.h   | 1 +
 tools/lib/bpf/libbpf.map | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8741c39adb1c..0c254b6c9685 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -79,6 +79,14 @@ void libbpf_set_print(libbpf_print_fn_t fn)
 	__libbpf_pr = fn;
 }
 
+libbpf_print_fn_t libbpf_swap_print(libbpf_print_fn_t fn)
+{
+	libbpf_print_fn_t old_print_fn = __libbpf_pr;
+
+	__libbpf_pr = fn;
+	return old_print_fn;
+}
+
 __printf(2, 3)
 void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 5cbf459ece0b..4e0aa893571f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -58,6 +58,7 @@ typedef int (*libbpf_print_fn_t)(enum libbpf_print_level level,
 				 const char *, va_list ap);
 
 LIBBPF_API void libbpf_set_print(libbpf_print_fn_t fn);
+LIBBPF_API libbpf_print_fn_t libbpf_swap_print(libbpf_print_fn_t fn);
 
 /* Hide internal to user */
 struct bpf_object;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f9d316e873d8..e211c38ddc43 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -184,3 +184,8 @@ LIBBPF_0.0.4 {
 		perf_buffer__new_raw;
 		perf_buffer__poll;
 } LIBBPF_0.0.3;
+
+LIBBPF_0.0.5 {
+	global:
+		libbpf_swap_print;
+} LIBBPF_0.0.4;
-- 
2.17.1

