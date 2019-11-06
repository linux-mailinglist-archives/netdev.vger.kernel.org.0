Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C01DF1F99
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 21:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731934AbfKFUPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 15:15:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbfKFUPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 15:15:11 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA6KEZSE012638
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 12:15:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=cvjTvcBY8zEpr7JQsGkSfP+z1MdxbLmV+tUKAj6ciZs=;
 b=AJNMxx7PBCp1FHgR1WDo7qut9UOaQPaY3wI6F9Bdqc9z6IPrb23xNi3nxXHa9WWJdgMt
 otzRhW2/+SwaLFbqNANHtjBGuCQqnyXw+lW9ixca+SYYIIQoNB8oxaIY03iLEfMKPTzi
 C1H110GCnleCeDIpCmNIKezzM2lLBT/pRlc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w41w1h30t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 12:15:10 -0800
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 12:15:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 46ACE2EC1854; Wed,  6 Nov 2019 12:15:06 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED usage
Date:   Wed, 6 Nov 2019 12:15:00 -0800
Message-ID: <20191106201500.2582438-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_07:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911060199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Streamline BPF_CORE_READ_BITFIELD_PROBED interface to follow
BPF_CORE_READ_BITFIELD (direct) and BPF_CORE_READ, in general, i.e., just
return read result or 0, if underlying bpf_probe_read() failed.

In practice, real applications rarely check bpf_probe_read() result, because
it has to always work or otherwise it's a bug. So propagating internal
bpf_probe_read() error from this macro hurts usability without providing real
benefits in practice. This patch fixes the issue and simplifies usage,
noticeable even in selftest itself.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h                 | 27 ++++++++-----------
 .../progs/test_core_reloc_bitfields_probed.c  | 19 +++++--------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 11461b2623b0..7009dc90e012 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -39,32 +39,27 @@ enum bpf_field_info_kind {
 #endif
 
 /*
- * Extract bitfield, identified by src->field, and put its value into u64
- * *res. All this is done in relocatable manner, so bitfield changes such as
+ * Extract bitfield, identified by s->field, and return its value as u64.
+ * All this is done in relocatable manner, so bitfield changes such as
  * signedness, bit size, offset changes, this will be handled automatically.
  * This version of macro is using bpf_probe_read() to read underlying integer
  * storage. Macro functions as an expression and its return type is
  * bpf_probe_read()'s return value: 0, on success, <0 on error.
  */
-#define BPF_CORE_READ_BITFIELD_PROBED(src, field, res) ({		      \
-	unsigned long long val;						      \
+#define BPF_CORE_READ_BITFIELD_PROBED(s, field) ({			      \
+	unsigned long long val = 0;					      \
 									      \
-	*res = 0;							      \
-	val = __CORE_BITFIELD_PROBE_READ(res, src, field);		      \
-	if (!val) {							      \
-		*res <<= __CORE_RELO(src, field, LSHIFT_U64);		      \
-		val = __CORE_RELO(src, field, RSHIFT_U64);		      \
-		if (__CORE_RELO(src, field, SIGNED))			      \
-			*res = ((long long)*res) >> val;		      \
-		else							      \
-			*res = ((unsigned long long)*res) >> val;	      \
-		val = 0;						      \
-	}								      \
+	__CORE_BITFIELD_PROBE_READ(&val, s, field);			      \
+	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
+	if (__CORE_RELO(s, field, SIGNED))				      \
+		val = ((long long)val) >> __CORE_RELO(s, field, RSHIFT_U64);  \
+	else								      \
+		val = val >> __CORE_RELO(s, field, RSHIFT_U64);		      \
 	val;								      \
 })
 
 /*
- * Extract bitfield, identified by src->field, and return its value as u64.
+ * Extract bitfield, identified by s->field, and return its value as u64.
  * This version of macro is using direct memory reads and should be used from
  * BPF program types that support such functionality (e.g., typed raw
  * tracepoints).
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
index a381f8ac2419..e466e3ab7de4 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
@@ -37,11 +37,6 @@ struct core_reloc_bitfields_output {
 	int64_t		s32;
 };
 
-#define TRANSFER_BITFIELD(in, out, field)				\
-	if (BPF_CORE_READ_BITFIELD_PROBED(in, field, &res))		\
-		return 1;						\
-	out->field = res
-
 SEC("raw_tracepoint/sys_enter")
 int test_core_bitfields(void *ctx)
 {
@@ -49,13 +44,13 @@ int test_core_bitfields(void *ctx)
 	struct core_reloc_bitfields_output *out = (void *)&data.out;
 	uint64_t res;
 
-	TRANSFER_BITFIELD(in, out, ub1);
-	TRANSFER_BITFIELD(in, out, ub2);
-	TRANSFER_BITFIELD(in, out, ub7);
-	TRANSFER_BITFIELD(in, out, sb4);
-	TRANSFER_BITFIELD(in, out, sb20);
-	TRANSFER_BITFIELD(in, out, u32);
-	TRANSFER_BITFIELD(in, out, s32);
+	out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);
+	out->ub2 = BPF_CORE_READ_BITFIELD_PROBED(in, ub2);
+	out->ub7 = BPF_CORE_READ_BITFIELD_PROBED(in, ub7);
+	out->sb4 = BPF_CORE_READ_BITFIELD_PROBED(in, sb4);
+	out->sb20 = BPF_CORE_READ_BITFIELD_PROBED(in, sb20);
+	out->u32 = BPF_CORE_READ_BITFIELD_PROBED(in, u32);
+	out->s32 = BPF_CORE_READ_BITFIELD_PROBED(in, s32);
 
 	return 0;
 }
-- 
2.17.1

