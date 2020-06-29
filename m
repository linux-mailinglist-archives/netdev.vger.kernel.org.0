Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1120E8A5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgF2WRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 18:17:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49406 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbgF2WRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 18:17:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05TMGpha005367
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 15:17:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=//dAw8OLW7wKWC7xyY9Jkx6utz5nCmZdiOWVC7Xn2oE=;
 b=P7tfMNhI9Ux9wW8fkzxUSAfZ/dCid2c2pQ81rRH0HQMPwpQTV6s6die0eGu8HBO99rKs
 DhOoU72XDS5A79g2FtM7i4RBd/J3r6MEMIoxRUG5mhWNQeHCzxMSI1Ge7NXxOEztLb89
 5AAiMQKHKRdtAXtBRdu1EXEaIA7wUV/mNjo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31xny26vky-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 15:17:51 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 15:17:50 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 840112EC3BDC; Mon, 29 Jun 2020 15:17:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: enforce BPF ringbuf size to be the power of 2
Date:   Mon, 29 Jun 2020 15:17:46 -0700
Message-ID: <20200629221746.4033122-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-29_21:2020-06-29,2020-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 suspectscore=8
 bulkscore=0 impostorscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290141
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
 kernel/bpf/ringbuf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index 180414bb0d3e..dcc8e8b9df10 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -132,7 +132,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t d=
ata_sz, int numa_node)
 {
 	struct bpf_ringbuf *rb;
=20
-	if (!data_sz || !PAGE_ALIGNED(data_sz))
+	if (!is_power_of_2(data_sz) || !PAGE_ALIGNED(data_sz))
 		return ERR_PTR(-EINVAL);
=20
 #ifdef CONFIG_64BIT
@@ -166,7 +166,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_at=
tr *attr)
 		return ERR_PTR(-EINVAL);
=20
 	if (attr->key_size || attr->value_size ||
-	    attr->max_entries =3D=3D 0 || !PAGE_ALIGNED(attr->max_entries))
+	    !is_power_of_2(attr->max_entries) ||
+	    !PAGE_ALIGNED(attr->max_entries))
 		return ERR_PTR(-EINVAL);
=20
 	rb_map =3D kzalloc(sizeof(*rb_map), GFP_USER);
--=20
2.24.1

