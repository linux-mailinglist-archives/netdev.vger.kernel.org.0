Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC41DD709
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgEUTS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:18:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32968 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730278AbgEUTSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:18:12 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04LJFKqf015913
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aIs8lqe9zJ86Sv2FVd5dDKmfHnfLpvW8bh1/PYtmJwo=;
 b=Q0wp3scXI1MaD0VTKf7xbMFVVrxJ3vScDQUGHjMcbKegzQ5S6/W17Fx/CRSDfs7jbS49
 GmgDMN5mnPDx38IJnDfgqJ3Lw5Mdmy9H0Ytq2RF2JHd8buwKJvguKNMYf1KjOK6jNVHX
 rH7+KmxyKi8K3PRez3mY3FMqp/T3zDuBJkM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 315qhhvbx4-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 12:18:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 12:18:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AB4452942F51; Thu, 21 May 2020 12:18:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] bpf: Relax the max_entries check for inner map
Date:   Thu, 21 May 2020 12:18:04 -0700
Message-ID: <20200521191804.3448912-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200521191752.3448223-1-kafai@fb.com>
References: <20200521191752.3448223-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_13:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=13 clxscore=1015 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=731 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch relaxes the max_entries check for most of the inner map types
during an update to the outer map.  The max_entries of those map types
are only used in runtime.  By doing this, an inner map with different
size can be updated to the outer map in runtime.

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
index 1e20b9911d48..1488d2aa41f2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -99,6 +99,18 @@ struct bpf_map_memory {
=20
 /* Cannot be used as an inner map */
 #define BPF_MAP_CAP_NO_INNER_MAP (1 << 0)
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
+#define BPF_MAP_CAP_NO_DYNAMIC_INNER_MAP_SIZE (1 << 1)
=20
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 652f17d646dd..4b350f9ad486 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -76,7 +76,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 #endif /* CONFIG_BPF_LSM */
 #endif
=20
-BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops,
+	     BPF_MAP_CAP_NO_DYNAMIC_INNER_MAP_SIZE)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops, 0)
 /* prog_array->aux->{type,jited} is a runtime binding.
  * Doing static check alone in the verifier is not enough,
@@ -114,7 +115,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops, 0)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops, 0)
 #if defined(CONFIG_XDP_SOCKETS)
-BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops, 0)
+BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops,
+	     BPF_MAP_CAP_NO_DYNAMIC_INNER_MAP_SIZE)
 #endif
 #ifdef CONFIG_INET
 BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops, 0)
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 6e1286ad7b76..bee1fcfd64f2 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -77,7 +77,8 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 		meta0->key_size =3D=3D meta1->key_size &&
 		meta0->value_size =3D=3D meta1->value_size &&
 		meta0->map_flags =3D=3D meta1->map_flags &&
-		meta0->max_entries =3D=3D meta1->max_entries;
+		(meta0->max_entries =3D=3D meta1->max_entries ||
+		 !(meta0->capability & BPF_MAP_CAP_NO_DYNAMIC_INNER_MAP_SIZE));
 }
=20
 void *bpf_map_fd_get_ptr(struct bpf_map *map,
--=20
2.24.1

