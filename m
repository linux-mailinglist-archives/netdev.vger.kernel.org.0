Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBE71B6C1A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 05:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDXDuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 23:50:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgDXDut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 23:50:49 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O3jA4g001586
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 20:50:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=H7J4YB8zRiIn+6Qwl8+W/lRxPsR21nnhgkmf7I6X4V0=;
 b=LMS8YAB/98OzqC75Dg0IwJW6Oo1L8W+6VeQyBkCGmU3xgc2UOlIhsSC2n+UfcftivCe9
 EeQQ9AmPc5HoyhwVz2hCZWszGpFT0WElb8l9gCugJ4146lkIXSemvJ7IA69Qm4/bzkPi
 OpWdiLUuHPoOaJO4AfhQP6TJeoxq0kuvCNs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30kkpe1p76-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 20:50:49 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 20:50:48 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2520D2EC2B09; Thu, 23 Apr 2020 20:50:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix leak in LINK_UPDATE and enforce empty old_prog_fd
Date:   Thu, 23 Apr 2020 20:50:39 -0700
Message-ID: <20200424035039.3534080-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_19:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=8 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 mlxlogscore=895
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240025
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bug of not putting bpf_link in LINK_UPDATE command.
Also enforce zeroed old_prog_fd if no BPF_F_REPLACE flag is specified.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d85f37239540..087cf27218c9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3608,7 +3608,7 @@ static int link_create(union bpf_attr *attr)
=20
 static int link_update(union bpf_attr *attr)
 {
-	struct bpf_prog *old_prog =3D NULL, *new_prog;
+	struct bpf_prog *old_prog =3D NULL, *new_prog =3D NULL;
 	struct bpf_link *link;
 	u32 flags;
 	int ret;
@@ -3628,31 +3628,38 @@ static int link_update(union bpf_attr *attr)
 		return PTR_ERR(link);
=20
 	new_prog =3D bpf_prog_get(attr->link_update.new_prog_fd);
-	if (IS_ERR(new_prog))
-		return PTR_ERR(new_prog);
+	if (IS_ERR(new_prog)) {
+		ret =3D PTR_ERR(new_prog);
+		new_prog =3D NULL;
+		goto out_put;
+	}
=20
 	if (flags & BPF_F_REPLACE) {
 		old_prog =3D bpf_prog_get(attr->link_update.old_prog_fd);
 		if (IS_ERR(old_prog)) {
 			ret =3D PTR_ERR(old_prog);
 			old_prog =3D NULL;
-			goto out_put_progs;
+			goto out_put;
 		}
+	} else if (attr->link_update.old_prog_fd) {
+		ret =3D -EINVAL;
+		goto out_put;
 	}
=20
 #ifdef CONFIG_CGROUP_BPF
 	if (link->ops =3D=3D &bpf_cgroup_link_lops) {
 		ret =3D cgroup_bpf_replace(link, old_prog, new_prog);
-		goto out_put_progs;
+		goto out_put;
 	}
 #endif
 	ret =3D -EINVAL;
=20
-out_put_progs:
+out_put:
 	if (old_prog)
 		bpf_prog_put(old_prog);
-	if (ret)
+	if (ret && new_prog)
 		bpf_prog_put(new_prog);
+	bpf_link_put(link);
 	return ret;
 }
=20
--=20
2.24.1

