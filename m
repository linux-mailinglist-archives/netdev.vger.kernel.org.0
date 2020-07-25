Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC7022D2F3
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgGYAHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:07:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13912 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgGYAEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:34 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmcVO012914
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=17orusyypan1KZmM80SiA8fbOfmJg8G/0LrmIpYnCe0=;
 b=JZSRprSokDSYLro59LFzubOC3HwsXUn7KEwLtE3+pcVqyW0ybzik3SvcDPsEPTPkO/UK
 hl4MPf6nKfwodkyUJO80e4963q2zoulkHIRxRcl0113PgRayoEJFXazPQJK9hxDApjr8
 OOB+weBErvSPRjYMLWyefqd5JCR7Jeiy0T8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegmb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:33 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:31 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id B906A1B35A72; Fri, 24 Jul 2020 17:04:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 03/35] bpf: refine memcg-based memory accounting for arraymap maps
Date:   Fri, 24 Jul 2020 17:03:38 -0700
Message-ID: <20200725000410.3566700-4-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=888 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=38
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include percpu arrays and auxiliary data into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/arraymap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 8ff419b632a6..9597fecff8da 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -28,12 +28,12 @@ static void bpf_array_free_percpu(struct bpf_array *a=
rray)
=20
 static int bpf_array_alloc_percpu(struct bpf_array *array)
 {
+	const gfp_t gfp =3D GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT;
 	void __percpu *ptr;
 	int i;
=20
 	for (i =3D 0; i < array->map.max_entries; i++) {
-		ptr =3D __alloc_percpu_gfp(array->elem_size, 8,
-					 GFP_USER | __GFP_NOWARN);
+		ptr =3D __alloc_percpu_gfp(array->elem_size, 8, gfp);
 		if (!ptr) {
 			bpf_array_free_percpu(array);
 			return -ENOMEM;
@@ -969,7 +969,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf=
_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
=20
-	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL);
+	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
 	if (!aux)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

