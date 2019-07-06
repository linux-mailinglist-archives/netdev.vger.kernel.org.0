Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40A560EFB
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 06:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfGFEod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 00:44:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfGFEod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 00:44:33 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x664iQpj007497
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 21:44:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=y6RFf2MmSqQgHdTR2FhUUSY94fG/HwrHdOgrLsZcfS0=;
 b=PHfaYfCpbi/HspykN/EfX4noTpErrSHAXQx6TiMf52wAq4Gw5lwytA8HmZQZqWt9gJX/
 LpVzlHQNYjjNX/XaMzx3M9PnsAh1cxweiyKjjatTYwK7yyGTQBeMXaxfo2O6NBDLhdvn
 Dg1hhqnbYhoV74mZnQ7NTon7GdAxKP1cJws= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2thtd94ut9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 21:44:32 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jul 2019 21:44:30 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 9B9D886163F; Fri,  5 Jul 2019 21:44:29 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: fix test_attach_probe map definition
Date:   Fri, 5 Jul 2019 21:44:20 -0700
Message-ID: <20190706044420.1582763-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=828 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ef99b02b23ef ("libbpf: capture value in BTF type info for BTF-defined map
defs") changed BTF-defined maps syntax, while independently merged
1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests") added new
test using outdated syntax of maps. This patch fixes this test after
corresponding patch sets were merged.

Fixes: ef99b02b23ef ("libbpf: capture value in BTF type info for BTF-defined map defs")
Fixes: 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../testing/selftests/bpf/progs/test_attach_probe.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 7a7c5cd728c8..63a8dfef893b 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -6,14 +6,11 @@
 #include "bpf_helpers.h"
 
 struct {
-	int type;
-	int max_entries;
-	int *key;
-	int *value;
-} results_map SEC(".maps") = {
-	.type = BPF_MAP_TYPE_ARRAY,
-	.max_entries = 4,
-};
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 4);
+	__type(key, int);
+	__type(value, int);
+} results_map SEC(".maps");
 
 SEC("kprobe/sys_nanosleep")
 int handle_sys_nanosleep_entry(struct pt_regs *ctx)
-- 
2.17.1

