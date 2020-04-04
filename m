Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3039E19E1CA
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgDDAKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgDDAKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:09 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03406Wle004887
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UT/obDySBoQsL2tkF9oxX6ywxrLbf6iN6ZMyVCAnpVA=;
 b=NKunSJI6ethAfhMFODpXgG3pNVVyALkkVhj5MoibZkkWIE4lGtTBpQZH7XYsneUlDfEG
 tLkckSurx9n6DrWubJLbhHaXVeryi1hnlnMSOs68TtNkcESioqMUsk/x5iHcyx7phosP
 zFZsV/ruo52ad3F1OyBx7r7H3vJPfV+r+zo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3067152kg6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:07 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:04 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F369B2EC2885; Fri,  3 Apr 2020 17:10:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 1/8] bpf: refactor bpf_link update handling
Date:   Fri, 3 Apr 2020 17:09:40 -0700
Message-ID: <20200404000948.3980903-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=928
 spamscore=0 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=8 malwarescore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make bpf_link update support more generic by making it into another
bpf_link_ops methods. This allows generic syscall handling code to be agn=
ostic
to various conditionally compiled features (e.g., the case of
CONFIG_CGROUP_BPF). This also allows to keep link type-specific code to r=
emain
static within respective code base. Refactor existing bpf_cgroup_link cod=
e and
take advantage of this.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf-cgroup.h | 12 ------------
 include/linux/bpf.h        |  3 ++-
 kernel/bpf/cgroup.c        | 30 ++++++++++++++++++++++++++++--
 kernel/bpf/syscall.c       | 11 ++++-------
 kernel/cgroup/cgroup.c     | 27 ---------------------------
 5 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index c11b413d5b1a..d2d969669564 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -100,8 +100,6 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			struct bpf_cgroup_link *link,
 			enum bpf_attach_type type);
-int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *li=
nk,
-			 struct bpf_prog *new_prog);
 int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
=20
@@ -112,8 +110,6 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
 		      u32 flags);
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		      enum bpf_attach_type type);
-int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *old_prog,
-		       struct bpf_prog *new_prog);
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr);
=20
@@ -354,7 +350,6 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
 #else
=20
 struct bpf_prog;
-struct bpf_link;
 struct cgroup_bpf {};
 static inline int cgroup_bpf_inherit(struct cgroup *cgrp) { return 0; }
 static inline void cgroup_bpf_offline(struct cgroup *cgrp) {}
@@ -378,13 +373,6 @@ static inline int cgroup_bpf_link_attach(const union=
 bpf_attr *attr,
 	return -EINVAL;
 }
=20
-static inline int cgroup_bpf_replace(struct bpf_link *link,
-				     struct bpf_prog *old_prog,
-				     struct bpf_prog *new_prog)
-{
-	return -EINVAL;
-}
-
 static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
 					union bpf_attr __user *uattr)
 {
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..ea65c3165e4c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1093,7 +1093,8 @@ struct bpf_link {
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
-
+	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
+			   struct bpf_prog *old_prog);
 };
=20
 void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops=
,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index cb305e71e7de..54eacc44d1e4 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -557,8 +557,9 @@ static void replace_effective_prog(struct cgroup *cgr=
p,
  *
  * Must be called with cgroup_mutex held.
  */
-int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *li=
nk,
-			 struct bpf_prog *new_prog)
+static int __cgroup_bpf_replace(struct cgroup *cgrp,
+				struct bpf_cgroup_link *link,
+				struct bpf_prog *new_prog)
 {
 	struct list_head *progs =3D &cgrp->bpf.progs[link->type];
 	struct bpf_prog *old_prog;
@@ -583,6 +584,30 @@ int __cgroup_bpf_replace(struct cgroup *cgrp, struct=
 bpf_cgroup_link *link,
 	return 0;
 }
=20
+static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *ne=
w_prog,
+			      struct bpf_prog *old_prog)
+{
+	struct bpf_cgroup_link *cg_link;
+	int ret;
+
+	cg_link =3D container_of(link, struct bpf_cgroup_link, link);
+
+	mutex_lock(&cgroup_mutex);
+	/* link might have been auto-released by dying cgroup, so fail */
+	if (!cg_link->cgroup) {
+		ret =3D -EINVAL;
+		goto out_unlock;
+	}
+	if (old_prog && link->prog !=3D old_prog) {
+		ret =3D -EPERM;
+		goto out_unlock;
+	}
+	ret =3D __cgroup_bpf_replace(cg_link->cgroup, cg_link, new_prog);
+out_unlock:
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
 static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
@@ -811,6 +836,7 @@ static void bpf_cgroup_link_dealloc(struct bpf_link *=
link)
 const struct bpf_link_ops bpf_cgroup_link_lops =3D {
 	.release =3D bpf_cgroup_link_release,
 	.dealloc =3D bpf_cgroup_link_dealloc,
+	.update_prog =3D cgroup_bpf_replace,
 };
=20
 int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *=
prog)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da34202..40993d8c936e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3642,13 +3642,10 @@ static int link_update(union bpf_attr *attr)
 		}
 	}
=20
-#ifdef CONFIG_CGROUP_BPF
-	if (link->ops =3D=3D &bpf_cgroup_link_lops) {
-		ret =3D cgroup_bpf_replace(link, old_prog, new_prog);
-		goto out_put_progs;
-	}
-#endif
-	ret =3D -EINVAL;
+	if (link->ops->update_prog)
+		ret =3D link->ops->update_prog(link, new_prog, old_prog);
+	else
+		ret =3D EINVAL;
=20
 out_put_progs:
 	if (old_prog)
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 915dda3f7f19..219624fba9ba 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6317,33 +6317,6 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
 	return ret;
 }
=20
-int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *old_prog,
-		       struct bpf_prog *new_prog)
-{
-	struct bpf_cgroup_link *cg_link;
-	int ret;
-
-	if (link->ops !=3D &bpf_cgroup_link_lops)
-		return -EINVAL;
-
-	cg_link =3D container_of(link, struct bpf_cgroup_link, link);
-
-	mutex_lock(&cgroup_mutex);
-	/* link might have been auto-released by dying cgroup, so fail */
-	if (!cg_link->cgroup) {
-		ret =3D -EINVAL;
-		goto out_unlock;
-	}
-	if (old_prog && link->prog !=3D old_prog) {
-		ret =3D -EPERM;
-		goto out_unlock;
-	}
-	ret =3D __cgroup_bpf_replace(cg_link->cgroup, cg_link, new_prog);
-out_unlock:
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		      enum bpf_attach_type type)
 {
--=20
2.24.1

