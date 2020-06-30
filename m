Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D56B20EE28
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgF3GPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:15:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729847AbgF3GPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:15:06 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05U6B4vV009843
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:15:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=UZMasnxIjOWUOzx5eBE8KLjBYXaOcvUkxXTjBcCSOJA=;
 b=dGsaR6ne2t9Kn3U/j96NY9YfeM6hlLLp4HdZCR26J+6u1kHXjPmlrhGMpfuvIQqSHF4S
 OIY5V3qPCt9I292QN5rJTQli3GqLu5F6rFDPVZuR3I2kXRPSPRT4Ly1PjdkMZewbCkWN
 MkmrvfmXt67sJBMB2iLX0NEkGXj6RI6Gpwo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3mmjycs-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:15:04 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 23:15:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CA6192EC2E95; Mon, 29 Jun 2020 23:15:01 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf] bpf: enforce BPF ringbuf size to be the power of 2
Date:   Mon, 29 Jun 2020 23:15:00 -0700
Message-ID: <20200630061500.1804799-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_01:2020-06-30,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 cotscore=-2147483648 spamscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=8
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006300047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF ringbuf assumes the size to be a multiple of page size and the power =
of
2 value. The latter is important to avoid division while calculating posi=
tion
inside the ring buffer and using (N-1) mask instead. This patch fixes omi=
ssion
to enforce power-of-2 size rule.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support=
 for it")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/ringbuf.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 180414bb0d3e..0af88bbc1c15 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -132,15 +132,6 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t =
data_sz, int numa_node)
 {
 	struct bpf_ringbuf *rb;
=20
-	if (!data_sz || !PAGE_ALIGNED(data_sz))
-		return ERR_PTR(-EINVAL);
-
-#ifdef CONFIG_64BIT
-	/* on 32-bit arch, it's impossible to overflow record's hdr->pgoff */
-	if (data_sz > RINGBUF_MAX_DATA_SZ)
-		return ERR_PTR(-E2BIG);
-#endif
-
 	rb =3D bpf_ringbuf_area_alloc(data_sz, numa_node);
 	if (!rb)
 		return ERR_PTR(-ENOMEM);
@@ -166,9 +157,16 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_a=
ttr *attr)
 		return ERR_PTR(-EINVAL);
=20
 	if (attr->key_size || attr->value_size ||
-	    attr->max_entries =3D=3D 0 || !PAGE_ALIGNED(attr->max_entries))
+	    !is_power_of_2(attr->max_entries) ||
+	    !PAGE_ALIGNED(attr->max_entries))
 		return ERR_PTR(-EINVAL);
=20
+#ifdef CONFIG_64BIT
+	/* on 32-bit arch, it's impossible to overflow record's hdr->pgoff */
+	if (attr->max_entries > RINGBUF_MAX_DATA_SZ)
+		return ERR_PTR(-E2BIG);
+#endif
+
 	rb_map =3D kzalloc(sizeof(*rb_map), GFP_USER);
 	if (!rb_map)
 		return ERR_PTR(-ENOMEM);
--=20
2.24.1

