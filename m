Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956FC1CF9C9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgELPwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52322 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730892AbgELPwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFma5D019304
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NwsWRpT1p4pDiec3E+ybrTNxRSOH/oJN0e2JP9eEuA4=;
 b=NGH1zNKPylDuacNs0CC+N8bgaxPJorPgDOPG6s3h7q662jMfpr7uTXKcNoshyzR/6l77
 qy7f2VV0Iqje/ZA0y6zZIUmYKpaiDxxix8iB1fc5wvp7S8AqOO/pbkwmegyb9sADkl65
 2MG343+evMKrxNfnz6elEw7QXtmrAn0KeXM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgsd773-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:41 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7D7103700839; Tue, 12 May 2020 08:52:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/8] bpf: change func bpf_iter_unreg_target() signature
Date:   Tue, 12 May 2020 08:52:38 -0700
Message-ID: <20200512155238.1080615-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200512155232.1080167-1-yhs@fb.com>
References: <20200512155232.1080167-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005120120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change func bpf_iter_unreg_target() parameter from target
name to target reg_info, similar to bpf_iter_reg_target().

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   | 2 +-
 kernel/bpf/bpf_iter.c | 4 ++--
 net/ipv6/route.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ab94dfd8826f..ad1bd13cd34c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1154,7 +1154,7 @@ struct bpf_iter_meta {
 };
=20
 int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
-void bpf_iter_unreg_target(const char *target);
+void bpf_iter_unreg_target(struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_new_fd(struct bpf_link *link);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 1d203dc7afe2..041f97dcec39 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -254,14 +254,14 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_in=
fo)
 	return 0;
 }
=20
-void bpf_iter_unreg_target(const char *target)
+void bpf_iter_unreg_target(struct bpf_iter_reg *reg_info)
 {
 	struct bpf_iter_target_info *tinfo;
 	bool found =3D false;
=20
 	mutex_lock(&targets_mutex);
 	list_for_each_entry(tinfo, &targets, list) {
-		if (!strcmp(target, tinfo->reg_info->target)) {
+		if (reg_info =3D=3D tinfo->reg_info) {
 			list_del(&tinfo->list);
 			kfree(tinfo);
 			found =3D true;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 48e8752d9ad9..bb8581f9b448 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6412,7 +6412,7 @@ static int __init bpf_iter_register(void)
=20
 static void bpf_iter_unregister(void)
 {
-	bpf_iter_unreg_target("ipv6_route");
+	bpf_iter_unreg_target(&ipv6_route_reg_info);
 }
 #endif
 #endif
--=20
2.24.1

