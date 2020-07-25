Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5489622D2BF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgGYAFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:05:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8276 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727873AbgGYAEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:44 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmbcH012886
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8iaJhwNnoB5uasjOqvrPPlOgkwSra4CMjVclhQMQGRw=;
 b=Bsb9ao9+rgaAG3zOHBHCe1v6tOyIfcAOLCvp0yuslaxUtXhMSyc8UxvfHJz+/3S8/UIj
 AEQaPWbV2h+BLqvKjrMP83HzdkSjZ2b0dUFrZ050D7W2Vhk6tgbHY7hPT8RC+gkQu4rY
 ytIwinzuFjcXt3jUKGkdFLiqSDHWzZJzNWA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegmm-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:43 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:36 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 2607C1B35A9A; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 23/35] bpf: eliminate rlimit-based memory accounting for sock_map maps
Date:   Fri, 24 Jul 2020 17:03:58 -0700
Message-ID: <20200725000410.3566700-24-guro@fb.com>
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
 mlxlogscore=833 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=38
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for sock_map maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/core/sock_map.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index bc797adca44c..066aff088d20 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -26,8 +26,6 @@ struct bpf_stab {
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_stab *stab;
-	u64 cost;
-	int err;
=20
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -45,22 +43,15 @@ static struct bpf_map *sock_map_alloc(union bpf_attr =
*attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
=20
-	/* Make sure page count doesn't overflow. */
-	cost =3D (u64) stab->map.max_entries * sizeof(struct sock *);
-	err =3D bpf_map_charge_init(&stab->map.memory, cost);
-	if (err)
-		goto free_stab;
-
 	stab->sks =3D bpf_map_area_alloc(stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
-	if (stab->sks)
-		return &stab->map;
-	err =3D -ENOMEM;
-	bpf_map_charge_finish(&stab->map.memory);
-free_stab:
-	kfree(stab);
-	return ERR_PTR(err);
+	if (!stab->sks) {
+		kfree(stab);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return &stab->map;
 }
=20
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *pr=
og)
--=20
2.26.2

