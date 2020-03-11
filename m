Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D056180EEC
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCKEaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:30:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60858 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgCKEaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:30:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02B4P8Rv020562
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 21:30:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=fyk35ybbUTbck/D89Ebng22+US4V3HKC8iBhknLnk/M=;
 b=XtiT4P3j88vfS1JEx5+nEOMT4FuKBQeKw6rgxnXVBckcPZB+v5RfNuRv+klzkRidZ4g7
 +GVhFsw4FfipyxKufYHG0cholt/IHL4wSQhr4gNaB+Ja0uN4UqL9FcsTjwfUYu3pqSkp
 x7sM0w/XeHWhPUJw9osjUXlVyf28na+X5Bo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yp25fpb8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 21:30:14 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 10 Mar 2020 21:30:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D9C472EC1A61; Tue, 10 Mar 2020 21:30:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/runqslower: add BPF_F_CURRENT_CPU for running selftest on older kernels
Date:   Tue, 10 Mar 2020 21:30:10 -0700
Message-ID: <20200311043010.530620-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_17:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110027
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf compiles and runs subset of selftests on each PR in its Github mirror
repository. To allow still building up-to-date selftests against outdated
kernel images, add back BPF_F_CURRENT_CPU definitions back.

N.B. BCC's runqslower version ([0]) doesn't need BPF_F_CURRENT_CPU due to use of
locally checked in vmlinux.h, generated against kernel with 1aae4bdd7879 ("bpf:
Switch BPF UAPI #define constants used from BPF program side to enums")
applied.

  [0] https://github.com/iovisor/bcc/pull/2809

Fixes: 367d82f17eff (" tools/runqslower: Drop copy/pasted BPF_F_CURRENT_CPU definiton")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/runqslower/runqslower.bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 0ba501305bad..1f18a409f044 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -5,6 +5,7 @@
 #include "runqslower.h"
 
 #define TASK_RUNNING 0
+#define BPF_F_CURRENT_CPU 0xffffffffULL
 
 const volatile __u64 min_us = 0;
 const volatile pid_t targ_pid = 0;
-- 
2.17.1

