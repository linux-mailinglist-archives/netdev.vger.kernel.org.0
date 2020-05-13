Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7165E1D1CE0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390080AbgEMSC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:02:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60840 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390060AbgEMSC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:02:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04DI04Nw017187
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:02:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GMCfbwkC3sOJneyzRZWEnlNJO0CzQm0cjdTHknOJAh4=;
 b=nIOVygSmzvGO9nQ8AeAxhDQ60DBjXzjObkbio/nQDe0/K52dOtmXt6aUCmpyTVFvo2Yn
 wdDkRcAlZ6+Hjd2pEzyUzj8m3XQev2CARugFeHEewZ0r0+8mayzRYEdpd2lQRGQvAhq9
 XQihaTG64n5IFgHHvshXeDg/kFfZZuCaJ1o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3100xh6e4s-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:02:56 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 11:02:24 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A439B37009B0; Wed, 13 May 2020 11:02:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 5/7] bpf: change func bpf_iter_unreg_target() signature
Date:   Wed, 13 May 2020 11:02:20 -0700
Message-ID: <20200513180220.2949737-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513180215.2949164-1-yhs@fb.com>
References: <20200513180215.2949164-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 malwarescore=0
 spamscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change func bpf_iter_unreg_target() parameter from target
name to target reg_info, similar to bpf_iter_reg_target().

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h   | 2 +-
 kernel/bpf/bpf_iter.c | 4 ++--
 net/ipv6/route.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6fa773e2d1bf..534174eca86b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1154,7 +1154,7 @@ struct bpf_iter_meta {
 };
=20
 int bpf_iter_reg_target(const struct bpf_iter_reg *reg_info);
-void bpf_iter_unreg_target(const char *target);
+void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info);
 bool bpf_iter_prog_supported(struct bpf_prog *prog);
 int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *pr=
og);
 int bpf_iter_new_fd(struct bpf_link *link);
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 051fb8cab62a..644f8626b2c0 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -257,14 +257,14 @@ int bpf_iter_reg_target(const struct bpf_iter_reg *=
reg_info)
 	return 0;
 }
=20
-void bpf_iter_unreg_target(const char *target)
+void bpf_iter_unreg_target(const struct bpf_iter_reg *reg_info)
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
index 6ad2fa51a23a..22bf4e36c093 100644
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

