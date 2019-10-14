Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176EED6C33
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfJNXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:49:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbfJNXtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 19:49:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ENmPwh015138
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=8Qm9AG7B11wh31UeWkOgJuyEAYvtoIIzoyHMpQfea1g=;
 b=AX5fA5DmZhQ5F1T5jkgNxdUAEZG/USTzYUdGQi/EaBxWheUyNE7hsodUUlbGyRvVjf2k
 kCIFb+FXgTTwScz40kYgAauvJGpFCK2w/OeGE+3oP2K/obLOdTFojlXZtJFH9mGODyru
 4fzU/lT7ueb/Kyn37hkZcZgObDS2Nfhcwr0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vky52f158-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:39 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 14 Oct 2019 16:49:39 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 9FB9A8618F6; Mon, 14 Oct 2019 16:49:38 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/5] libbpf: add BPF-side definitions of supported field relocation kinds
Date:   Mon, 14 Oct 2019 16:49:27 -0700
Message-ID: <20191014234928.561043-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191014234928.561043-1-andriin@fb.com>
References: <20191014234928.561043-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_11:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 mlxlogscore=783 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enum definition for Clang's __builtin_preserve_field_info()
second argument (info_kind). Currently only byte offset and existence
are supported. Corresponding Clang changes introducing this built-in can
be found at [0]

  [0] https://reviews.llvm.org/D67980

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 4daf04c25493..5a5cc88621a9 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -2,6 +2,18 @@
 #ifndef __BPF_CORE_READ_H__
 #define __BPF_CORE_READ_H__
 
+/* enum bpf_field_info_kind is passed as a second argument into
+ * __builtin_preserve_field_info() built-in to get a specific aspect of
+ * a field, captured as a first argument. __builtin_preserve_field_info(field,
+ * info_kind) returns __u32 integer and produces BTF field relocation, which
+ * is understood and processed by libbpf during BPF object loading. See
+ * selftests/bpf for examples.
+ */
+enum bpf_field_info_kind {
+	BPF_FI_BYTE_OFFSET = 0,	  /* field byte offset */
+	BPF_FI_EXISTS = 2,	  /* whether field exists in target kernel */
+};
+
 /*
  * bpf_core_read() abstracts away bpf_probe_read() call and captures offset
  * relocation for source address using __builtin_preserve_access_index()
-- 
2.17.1

