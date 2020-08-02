Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8B23550F
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 06:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgHBEVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 00:21:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22578 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbgHBEVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 00:21:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0724IcRX005848
        for <netdev@vger.kernel.org>; Sat, 1 Aug 2020 21:21:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=5jyxmjs4it642tyA2MpjIrzA4VjBVwaWiUueuy1Qk6c=;
 b=EuSnaOvTXd7DTU6ao9cAQnOIgzSjWFX9jw29/T+4XN1NN353bHtwFm9Nfyq1BPn5Wusi
 2uma3tFppMFSvJXApsnh94Fl/9dg/0bQkZSwhKqqMz03ICMeDMR8rFHB2R49ErSJnF2b
 16hfGdcmyzhRuCOmGVyBvnMCecy1zSvcHJ8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32n80t241e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 21:21:30 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 1 Aug 2020 21:21:28 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id A0D853705190; Sat,  1 Aug 2020 21:21:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] libbpf: support new uapi for map element bpf iterator
Date:   Sat, 1 Aug 2020 21:21:27 -0700
Message-ID: <20200802042127.2119901-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200802042126.2119783-1-yhs@fb.com>
References: <20200802042126.2119783-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_01:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=870 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous commit adjusted kernel uapi for map
element bpf iterator. This patch adjusted libbpf API
due to uapi change.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c    | 4 +++-
 tools/lib/bpf/bpf.h    | 5 +++--
 tools/lib/bpf/libbpf.c | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index eab14c97c15d..c75a84398d51 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -598,7 +598,9 @@ int bpf_link_create(int prog_fd, int target_fd,
 	attr.link_create.prog_fd =3D prog_fd;
 	attr.link_create.target_fd =3D target_fd;
 	attr.link_create.attach_type =3D attach_type;
-	attr.link_create.flags =3D OPTS_GET(opts, flags, 0);
+	attr.link_create.iter_info =3D
+		ptr_to_u64(OPTS_GET(opts, iter_info, (void *)0));
+	attr.link_create.iter_info_len =3D OPTS_GET(opts, iter_info_len, 0);
=20
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 28855fd5b5f4..c9895f191305 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -170,9 +170,10 @@ LIBBPF_API int bpf_prog_detach2(int prog_fd, int att=
achable_fd,
=20
 struct bpf_link_create_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
-	__u32 flags;
+	union bpf_iter_link_info *iter_info;
+	__u32 iter_info_len;
 };
-#define bpf_link_create_opts__last_field flags
+#define bpf_link_create_opts__last_field iter_info_len
=20
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7be04e45d29c..dc8fabf9d30d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8298,6 +8298,7 @@ bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts)
 {
 	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
+	union bpf_iter_link_info linfo;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
 	int prog_fd, link_fd;
@@ -8307,8 +8308,10 @@ bpf_program__attach_iter(struct bpf_program *prog,
 		return ERR_PTR(-EINVAL);
=20
 	if (OPTS_HAS(opts, map_fd)) {
-		target_fd =3D opts->map_fd;
-		link_create_opts.flags =3D BPF_ITER_LINK_MAP_FD;
+		memset(&linfo, 0, sizeof(linfo));
+		linfo.map.map_fd =3D opts->map_fd;
+		link_create_opts.iter_info =3D &linfo;
+		link_create_opts.iter_info_len =3D sizeof(linfo);
 	}
=20
 	prog_fd =3D bpf_program__fd(prog);
--=20
2.24.1

