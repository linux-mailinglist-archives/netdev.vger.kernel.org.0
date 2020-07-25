Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A7222D2C7
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGYAFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:05:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31846 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727823AbgGYAEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmbcB012886
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=spKGLxK3o4M7edg5m180h3ipHDO4sW7AlZIYk+WTamM=;
 b=fCv6kC2FyzR6g9Ljx4E7/gfGMz+oDthCh6pA+DHrDMF3Z4PEOG4UJUPIizDPkqrsM/jw
 REhjuRVGq353Bi1YtsmaD47HXhxQrFe+2WczoxDIhjLydqymr+6smu8QBxzYleyRGENn
 C/Q7sNR6R5mlugAY9b4/RkMGprdmf/AYr0c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegmm-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:41 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:35 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 009A51B35A8A; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 15/35] bpf: eliminate rlimit-based memory accounting for cpumap maps
Date:   Fri, 24 Jul 2020 17:03:50 -0700
Message-ID: <20200725000410.3566700-16-guro@fb.com>
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
 mlxlogscore=911 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=38
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for cpumap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/cpumap.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 74ae9fcbe82e..50f3444a3301 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -86,8 +86,6 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *at=
tr)
 	u32 value_size =3D attr->value_size;
 	struct bpf_cpu_map *cmap;
 	int err =3D -ENOMEM;
-	u64 cost;
-	int ret;
=20
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -111,26 +109,14 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr=
 *attr)
 		goto free_cmap;
 	}
=20
-	/* make sure page count doesn't overflow */
-	cost =3D (u64) cmap->map.max_entries * sizeof(struct bpf_cpu_map_entry =
*);
-
-	/* Notice returns -EPERM on if map size is larger than memlock limit */
-	ret =3D bpf_map_charge_init(&cmap->map.memory, cost);
-	if (ret) {
-		err =3D ret;
-		goto free_cmap;
-	}
-
 	/* Alloc array for possible remote "destination" CPUs */
 	cmap->cpu_map =3D bpf_map_area_alloc(cmap->map.max_entries *
 					   sizeof(struct bpf_cpu_map_entry *),
 					   cmap->map.numa_node);
 	if (!cmap->cpu_map)
-		goto free_charge;
+		goto free_cmap;
=20
 	return &cmap->map;
-free_charge:
-	bpf_map_charge_finish(&cmap->map.memory);
 free_cmap:
 	kfree(cmap);
 	return ERR_PTR(err);
--=20
2.26.2

