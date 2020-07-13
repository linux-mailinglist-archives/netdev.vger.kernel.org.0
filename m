Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D39D21DB7E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgGMQSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:18:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730217AbgGMQR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:17:59 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DFxx2c031280
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=U3CrST1Kc1acq9tEZf5HNB+d+i5ZGE/bQTix3dbJCFc=;
 b=Lw8zX7rwGRlbG+OH1BFgHe+249VrwuJdMAZFctQI54Rmak1iRK0eOX4Av9n0XvKTfokv
 KsfFfC7tGH2x6u+RESFvqGTjpnya0hSkuZbmPiBJbI4GF0zoBOWAAQoTvPvQkVZtOoF+
 zw8jDvC1DzOblW95w+uB6LEv/mKLJOJEpeo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 327wdrdch2-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:17:59 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 09:17:53 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B670E3702065; Mon, 13 Jul 2020 09:17:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 08/13] tools/libbpf: add support for bpf map element iterator
Date:   Mon, 13 Jul 2020 09:17:48 -0700
Message-ID: <20200713161748.3077454-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713161739.3076283-1-yhs@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_15:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=25
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=720 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add map_fd to bpf_iter_attach_opts and flags to
bpf_link_create_opts. Later on, bpftool or selftest
will be able to create a bpf map element iterator
by passing map_fd to the kernel during link
creation time.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c    |  1 +
 tools/lib/bpf/bpf.h    |  3 ++-
 tools/lib/bpf/libbpf.c | 10 +++++++++-
 tools/lib/bpf/libbpf.h |  3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index a7329b671c41..e1bdf214f75f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -598,6 +598,7 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.prog_fd =3D prog_fd;
 	attr.link_create.target_fd =3D target_fd;
 	attr.link_create.attach_type =3D attach_type;
+	attr.link_create.flags =3D OPTS_GET(opts, flags, 0);
=20
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 1b6015b21ba8..329a8db5526b 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -170,8 +170,9 @@ LIBBPF_API int bpf_prog_detach2(int prog_fd, int atta=
chable_fd,
=20
 struct bpf_link_create_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;
 };
-#define bpf_link_create_opts__last_field sz
+#define bpf_link_create_opts__last_field flags
=20
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 25e4f77be8d7..35ed8fbe6502 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8271,13 +8271,20 @@ struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts)
 {
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
 	int prog_fd, link_fd;
+	__u32 target_fd =3D 0;
=20
 	if (!OPTS_VALID(opts, bpf_iter_attach_opts))
 		return ERR_PTR(-EINVAL);
=20
+	if (OPTS_HAS(opts, map_fd)) {
+		target_fd =3D opts->map_fd;
+		link_create_opts.flags =3D BPF_ITER_LINK_MAP_FD;
+	}
+
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		pr_warn("program '%s': can't attach before loaded\n",
@@ -8290,7 +8297,8 @@ bpf_program__attach_iter(struct bpf_program *prog,
 		return ERR_PTR(-ENOMEM);
 	link->detach =3D &bpf_link__detach_fd;
=20
-	link_fd =3D bpf_link_create(prog_fd, 0, BPF_TRACE_ITER, NULL);
+	link_fd =3D bpf_link_create(prog_fd, target_fd, BPF_TRACE_ITER,
+				  &link_create_opts);
 	if (link_fd < 0) {
 		link_fd =3D -errno;
 		free(link);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2335971ed0bd..9b883fa7724a 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -264,8 +264,9 @@ LIBBPF_API struct bpf_link *bpf_map__attach_struct_op=
s(struct bpf_map *map);
=20
 struct bpf_iter_attach_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 map_fd;
 };
-#define bpf_iter_attach_opts__last_field sz
+#define bpf_iter_attach_opts__last_field map_fd
=20
 LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
--=20
2.24.1

