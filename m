Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A681D3791
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 04:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJKCiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 22:38:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726273AbfJKCiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 22:38:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9B2ZR2V018244
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 19:38:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Muny1FACAYX4BHXA1s/zjPaf7hs8/V8KuSy0nyMnTLU=;
 b=jpAFG9E1iJ9K/hoMFmKSn9NAn7f9Tl3uu8RrEKSddDzAckNXA2cw8K3+0n6nFg8wYfUQ
 uNLTamSw50YeMqS9mJjuDmVpVMipwB77EhRXoTXYMFcRfg9gmKPVdH9X2lAaKXs3Od1g
 tmQMmfqV7yOeteEzVjveHJZgGJj+Ye6sgEU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vj8jfth93-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 19:38:53 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 10 Oct 2019 19:38:52 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3897D861909; Thu, 10 Oct 2019 19:38:52 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: generate more efficient BPF_CORE_READ code
Date:   Thu, 10 Oct 2019 19:38:47 -0700
Message-ID: <20191011023847.275936-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_01:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=8 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing BPF_CORE_READ() macro generates slightly suboptimal code. If
there are intermediate pointers to be read, initial source pointer is
going to be assigned into a temporary variable and then temporary
variable is going to be uniformly used as a "source" pointer for all
intermediate pointer reads. Schematically (ignoring all the type casts),
BPF_CORE_READ(s, a, b, c) is expanded into:
({
	const void *__t = src;
	bpf_probe_read(&__t, sizeof(*__t), &__t->a);
	bpf_probe_read(&__t, sizeof(*__t), &__t->b);

	typeof(s->a->b->c) __r;
	bpf_probe_read(&__r, sizeof(*__r), &__t->c);
})

This initial `__t = src` makes calls more uniform, but causes slightly
less optimal register usage sometimes when compiled with Clang. This can
cascase into, e.g., more register spills.

This patch fixes this issue by generating more optimal sequence:
({
	const void *__t;
	bpf_probe_read(&__t, sizeof(*__t), &src->a); /* <-- src here */
	bpf_probe_read(&__t, sizeof(*__t), &__t->b);

	typeof(s->a->b->c) __r;
	bpf_probe_read(&__r, sizeof(*__r), &__t->c);
})

Fixes: 7db3822ab991 ("libbpf: Add BPF_CORE_READ/BPF_CORE_READ_INTO helpers")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index ae877e3ffb51..4daf04c25493 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -88,11 +88,11 @@
 	read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
 
 /* "recursively" read a sequence of inner pointers using local __t var */
+#define ___rd_first(src, a) ___read(bpf_core_read, &__t, ___type(src), src, a);
 #define ___rd_last(...)							    \
 	___read(bpf_core_read, &__t,					    \
 		___type(___nolast(__VA_ARGS__)), __t, ___last(__VA_ARGS__));
-#define ___rd_p0(src) const void *__t = src;
-#define ___rd_p1(...) ___rd_p0(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
+#define ___rd_p1(...) const void *__t; ___rd_first(__VA_ARGS__)
 #define ___rd_p2(...) ___rd_p1(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
 #define ___rd_p3(...) ___rd_p2(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
 #define ___rd_p4(...) ___rd_p3(___nolast(__VA_ARGS__)) ___rd_last(__VA_ARGS__)
-- 
2.17.1

