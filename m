Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35109CB3A2
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 06:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfJDECQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 00:02:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726927AbfJDECQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 00:02:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x943xDDf008542
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 21:02:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=uiWlMUun3z+/618F0BG3ibExNxzozlX1tH5Lf6CBv1c=;
 b=HLPmDuqDiJsDCUa/sk0ypbPIBvqhfsdFMZ/4XLxQlNYzefDP4/CKC4JWG3+9KldARMOb
 XFzDWCUdEJvlTDmaffGP/Nji+jngsJC9MfJEhl5a+3XzTdVOSoIEizZxOdqw0qW/G2gp
 gp8Y6V/lJkb5fTNV6F/aJpPS1Qkgfbr3yTk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vcy1gfvyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 21:02:15 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Oct 2019 21:02:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id E48F986186C; Thu,  3 Oct 2019 21:02:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: fix BTF-defined map's __type macro handling of arrays
Date:   Thu, 3 Oct 2019 21:02:11 -0700
Message-ID: <20191004040211.2434033-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_02:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 suspectscore=8 clxscore=1015 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040031
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to a quirky C syntax of declaring pointers to array or function
prototype, existing __type() macro doesn't work with map key/value types
that are array or function prototype. One has to create a typedef first
and use it to specify key/value type for a BPF map.  By using typeof(),
pointer to type is now handled uniformly for all kinds of types. Convert
one of self-tests as a demonstration.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---

N.B. This patch depends on patch set that moves bpf_helpers.h into libbpf to
avoid conflicts.

 tools/lib/bpf/bpf_helpers.h                              | 2 +-
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 2d3d1f51cdd0..6f68e4d3aff7 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -3,7 +3,7 @@
 #define __BPF_HELPERS__
 
 #define __uint(name, val) int (*name)[val]
-#define __type(name, val) val *name
+#define __type(name, val) typeof(val) *name
 
 /* Helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index f8ffa3f3d44b..6cc4479ac9df 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -47,12 +47,11 @@ struct {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
-typedef __u64 raw_stack_trace_t[2 * MAX_STACK_RAWTP];
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, __u32);
-	__type(value, raw_stack_trace_t);
+	__type(value, __u64[2 * MAX_STACK_RAWTP]);
 } rawdata_map SEC(".maps");
 
 SEC("raw_tracepoint/sys_enter")
-- 
2.17.1

