Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF47C201E7B
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 01:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgFSXEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 19:04:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729996AbgFSXEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 19:04:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05JN00Hq030497
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 16:04:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=6SMGNHMqEiT5yoSqQAHsmmbC2B1tn3KLG/YugBRYHdQ=;
 b=aYSIysx6fIY6cGLPfkhYBi29HifmSo7hcqGJdCdSdM0kBYnvHtnpRgNUV0YTfWnCMEUQ
 WbeUOtOajJwx0eKWAXPWo9gW1XxcuxZJa4p35vxmGCQHGRzhAvR1NWZY34/Zue1Ew34t
 OK90khNaLUzNL7OapJy/qEMphf1/Vn0EtLk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31s2rcs79d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 16:04:52 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Jun 2020 16:04:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C22C02EC3619; Fri, 19 Jun 2020 16:04:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: fix CO-RE relocs against .text section
Date:   Fri, 19 Jun 2020 16:04:22 -0700
Message-ID: <20200619230423.691274-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 clxscore=1015 adultscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_object__find_program_by_title(), used by CO-RE relocation code, doesn=
't
return .text "BPF program", if it is a function storage for sub-programs.
Because of that, any CO-RE relocation in helper non-inlined functions wil=
l
fail. Fix this by searching for .text-corresponding BPF program manually.

Adjust one of bpf_iter selftest to exhibit this pattern.

Reported-by: Yonghong Song <yhs@fb.com>
Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algor=
ithm")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                               | 8 +++++++-
 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 477c679ed945..f17151d866e6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4818,7 +4818,13 @@ bpf_core_reloc_fields(struct bpf_object *obj, cons=
t char *targ_btf_path)
 			err =3D -EINVAL;
 			goto out;
 		}
-		prog =3D bpf_object__find_program_by_title(obj, sec_name);
+		prog =3D NULL;
+		for (i =3D 0; i < obj->nr_programs; i++) {
+			if (!strcmp(obj->programs[i].section_name, sec_name)) {
+				prog =3D &obj->programs[i];
+				break;
+			}
+		}
 		if (!prog) {
 			pr_warn("failed to find program '%s' for CO-RE offset relocation\n",
 				sec_name);
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c b/tools=
/testing/selftests/bpf/progs/bpf_iter_netlink.c
index e7b8753eac0b..75ecf956a2df 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
@@ -25,7 +25,7 @@ struct bpf_iter__netlink {
 	struct netlink_sock *sk;
 } __attribute__((preserve_access_index));
=20
-static inline struct inode *SOCK_INODE(struct socket *socket)
+static __attribute__((noinline)) struct inode *SOCK_INODE(struct socket =
*socket)
 {
 	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
 }
--=20
2.24.1

