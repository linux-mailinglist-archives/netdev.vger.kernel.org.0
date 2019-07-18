Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B91D26D2CC
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGRRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:30:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43914 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727685AbfGRRae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:30:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6IHMS3D001326
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:30:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=ZPBd+g7Zx9eBXLoyQzKxVCYsMTLR8Fvqw09oNcPZkLQ=;
 b=kVagLfBbd0fA/wfnxJuSp88pHkcFof9i3DOf/Gdt5YstCksTRz0EW4dKtBv+ReYx7F1P
 MBpQReUc/gZ4ZWQqdSESGrz+CzgEgtH3a8C6JIRQpnwPMLzlCxLnLFaRCK8mcct21ETQ
 VGEpc0y9ssHMbOhMA+7mk+i8Nn0GsAbOiKo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ttv4a89mt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:30:33 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 18 Jul 2019 10:30:31 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ED62586161E; Thu, 18 Jul 2019 10:30:29 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <acme@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf] libbpf: fix missing __WORDSIZE definition
Date:   Thu, 18 Jul 2019 10:30:21 -0700
Message-ID: <20190718173021.2418606-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=357 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hashmap.h depends on __WORDSIZE being defined. It is defined by
glibc/musl in different headers. It's an explicit goal for musl to be
"non-detectable" at compilation time, so instead include glibc header if
glibc is explicitly detected and fall back to musl header otherwise.

Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/hashmap.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index 03748a742146..bae8879cdf58 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -10,6 +10,11 @@
 
 #include <stdbool.h>
 #include <stddef.h>
+#ifdef __GLIBC__
+#include <bits/wordsize.h>
+#else
+#include <bits/reg.h>
+#endif
 #include "libbpf_internal.h"
 
 static inline size_t hash_bits(size_t h, int bits)
-- 
2.17.1

