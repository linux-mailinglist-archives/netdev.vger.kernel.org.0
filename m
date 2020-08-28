Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76B22553FC
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 07:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgH1FTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 01:19:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbgH1FTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 01:19:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07S5JjAQ008604
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 22:19:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=h8yPN4wnII9g309UM/PHVphReHEqEGJQbTrnYP/IugQ=;
 b=ULCENbENEwOprgrjp/fPiH2zqQPKZ4wXhnVkRdiGHd6X6hMvNJOniUHGLGBLqJBRbd1m
 9XJmRpUUsCU4OpQVWfwGbMZzmk9hShljdXu/DPXmTMZMfMg0OrsOQMkHO9aQZddfTpMv
 Bq6nDuu2IW4QsCb7nA4rmbDgAyHUKljh9io= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 335up719pm-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 22:19:47 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 22:19:27 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 347B337052D7; Thu, 27 Aug 2020 22:19:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: make bpf_link_info.iter similar to bpf_iter_link_info
Date:   Thu, 27 Aug 2020 22:19:22 -0700
Message-ID: <20200828051922.758950-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_03:2020-08-27,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=626 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_link_info.iter is used by link_query to return
bpf_iter_link_info to user space. Fields may be different
,e.g., map_fd vs. map_id, so we cannot reuse
the exact structure. But make them similar, e.g.,
  struct bpf_link_info {
     /* common fields */
     union {
	struct { ... } raw_tracepoint;
	struct { ... } tracing;
	...
	struct {
	    /* common fields for iter */
	    union {
		struct {
		    __u32 map_id;
		} map;
		/* other structs for other targets */
	    };
	};
    };
 };
so the structure is extensible the same way as
bpf_iter_link_info.

Fixes: 6b0a249a301e ("bpf: Implement link_query for bpf iterators")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       | 6 ++++--
 tools/include/uapi/linux/bpf.h | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

This patch was the first patch in
  https://lore.kernel.org/bpf/20200827000618.2711826-1-yhs@fb.com/
I now sent this separately as it is largely independent and my
immediate follow-ups does not depend on this any more.

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0388bc0200b0..ef7af384f5ee 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4251,8 +4251,10 @@ struct bpf_link_info {
 			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
 			__u32 target_name_len;	   /* in/out: target_name buffer len */
 			union {
-				__u32 map_id;
-			} map;
+				struct {
+					__u32 map_id;
+				} map;
+			};
 		} iter;
 		struct  {
 			__u32 netns_ino;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 0388bc0200b0..ef7af384f5ee 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4251,8 +4251,10 @@ struct bpf_link_info {
 			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
 			__u32 target_name_len;	   /* in/out: target_name buffer len */
 			union {
-				__u32 map_id;
-			} map;
+				struct {
+					__u32 map_id;
+				} map;
+			};
 		} iter;
 		struct  {
 			__u32 netns_ino;
--=20
2.24.1

