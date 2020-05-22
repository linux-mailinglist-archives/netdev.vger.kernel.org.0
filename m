Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E021DDD15
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 04:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgEVCYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 22:24:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727050AbgEVCYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 22:24:17 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M2LLZR003705
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:24:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=p9yZPdW2gni/uc5W3qY2pPfvdzlqbhy/hev0rUupsZU=;
 b=LAmLSMcBjxuwlZ6x52F8nFyD3HFhKLEreF9aW+KmVzVzjw7XzoguEC+rNYxiktMBDtKd
 cereCH3XaLFPmxyjxo97OkAoN+oRSeGCo1k9F/6CSCbg/G8Yst9vEG7QSP/tVPBkUppO
 bVCDuAcFW2FAbDtRr+PUHh1X9yhY2aqv0Fo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3152xu2nkv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 19:24:17 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 19:23:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3626D29455B1; Thu, 21 May 2020 19:23:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpf: Relax the max_entries check for inner map
Date:   Thu, 21 May 2020 19:23:49 -0700
Message-ID: <20200522022349.900034-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522022336.899416-1-kafai@fb.com>
References: <20200522022336.899416-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_16:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 cotscore=-2147483648 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 mlxlogscore=676 lowpriorityscore=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220017
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch relaxes the max_entries check for most of the inner map types
during an update to the outer map.  The max_entries of those map types
are only used in runtime.  By doing this, an inner map with different
size can be updated to the outer map in runtime.  People has a use
case that starts with a smaller inner map first and then replaces
it with a larger inner map later when it is needed.

The max_entries of arraymap and xskmap are used statically
in verification time to generate the inline code, so they
are excluded in this patch.

Cc: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h       | 12 ++++++++++++
 include/linux/bpf_types.h |  6 ++++--
 kernel/bpf/map_in_map.c   |  3 ++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f947d899aa46..1839ef9aca02 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -99,6 +99,18 @@ struct bpf_map_memory {
=20
 /* Cannot be used as an inner map */
 #define BPF_MAP_NO_INNER_MAP (1 << 0)
+/* When a prog has used map-in-map, the verifier requires
+ * an inner-map as a template to verify the access operations
+ * on the outer and inner map.  For some inner map-types,
+ * the verifier uses the inner_map's max_entries statically
+ * (e.g. to generate inline code).  If this verification
+ * time usage on max_entries applies to an inner map-type,
+ * during runtime, only the inner map with the same
+ * max_entries can be updated to this outer map.
+ *
+ * Please see bpf_map_meta_equal() for details.
+ */
+#define BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE (1 << 1)
=20
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 3f32702c9bf4..85861722b7f3 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -78,7 +78,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
=20
 #define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
=20
-BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_ARRAY, array_map_ops,
+		BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
 /* prog_array->aux->{type,jited} is a runtime binding.
  * Doing static check alone in the verifier is not enough,
@@ -116,7 +117,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
-BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
+BPF_MAP_TYPE_FL(BPF_MAP_TYPE_XSKMAP, xsk_map_ops,
+		BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE)
 #endif
 #ifdef CONFIG_INET
 BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index d965a1d328a9..b296fe8af1ad 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -77,7 +77,8 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 		meta0->key_size =3D=3D meta1->key_size &&
 		meta0->value_size =3D=3D meta1->value_size &&
 		meta0->map_flags =3D=3D meta1->map_flags &&
-		meta0->max_entries =3D=3D meta1->max_entries;
+		(meta0->max_entries =3D=3D meta1->max_entries ||
+		 !(meta0->properties & BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE));
 }
=20
 void *bpf_map_fd_get_ptr(struct bpf_map *map,
--=20
2.24.1

