Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122BC253ADF
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgH0AG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbgH0AG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R05YuX032208
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PoctbjKW2PqcwUYfWkP0gtzAdd17ljuE+ugTmwzAGbI=;
 b=XfObal2+nvUMOQ1b71lZ9DHb6y1ltHC5E8Nu6xjcmgVVokcNm2iTz+2Hy0aAWbxX3moo
 kb6EmhBwJWC+oYRMYL+Y+RXuFOvDdXje63peTtZiWzZdKyBOooqWHQ5es3J3KudU1IRV
 IV9EPp4mvVj+UDhV3CrMdBFHykYVrlKhua4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8jbxp-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:26 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:22 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 103843705306; Wed, 26 Aug 2020 17:06:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/5] bpf: make bpf_link_info.iter similar to bpf_iter_link_info
Date:   Wed, 26 Aug 2020 17:06:19 -0700
Message-ID: <20200827000619.2711883-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200827000618.2711826-1-yhs@fb.com>
References: <20200827000618.2711826-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=827 clxscore=1015 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
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
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       | 6 ++++--
 tools/include/uapi/linux/bpf.h | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

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

