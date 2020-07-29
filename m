Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539702327D3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgG2XFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:05:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgG2XFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:05:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TMsNHg003793
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=H2AGvMjS+2rx1OjgwGThpqCJWVnHnmLjwn8Acv5MDV4=;
 b=QFPoMh8Ct63hUZ9qu2Y987UHu0lKjeK7CZEsvQxRglVLF5A148q5DXaaz6+uGjmEu0P0
 hDg0H4FLG++9tlCITpxvhhSTqIldKS/ukNbPTtyEoC0v8MpkhrizGaMngPITS2nh2VKn
 nG9X03RBu1N0kgVJuo+gfqoryNcUdItkG0M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32kd86hk6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:29 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:05:28 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ABB882EC4E37; Wed, 29 Jul 2020 16:05:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/5] bpf: add support for forced LINK_DETACH command
Date:   Wed, 29 Jul 2020 16:05:16 -0700
Message-ID: <20200729230520.693207-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200729230520.693207-1-andriin@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_17:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=992 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=25 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LINK_DETACH command to force-detach bpf_link without destroying it. I=
t has
the same behavior as auto-detaching of bpf_link due to cgroup dying for
bpf_cgroup_link or net_device being destroyed for bpf_xdp_link. In such c=
ase,
bpf_link is still a valid kernel object, but is defuncts and doesn't hold=
 BPF
program attached to corresponding BPF hook. This functionality allows use=
rs
with enough access rights to manually force-detach attached bpf_link with=
out
killing respective owner process.

This patch implements LINK_DETACH for cgroup, xdp, and netns links, mostl=
y
re-using existing link release handling code.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h        |  1 +
 include/uapi/linux/bpf.h   |  5 +++++
 kernel/bpf/cgroup.c        | 15 ++++++++++++++-
 kernel/bpf/net_namespace.c |  8 ++++++++
 kernel/bpf/syscall.c       | 26 ++++++++++++++++++++++++++
 net/core/dev.c             | 11 ++++++++++-
 6 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 40c5e206ecf2..cef4ef0d2b4e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -793,6 +793,7 @@ struct bpf_link {
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
+	int (*detach)(struct bpf_link *link);
 	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
 			   struct bpf_prog *old_prog);
 	void (*show_fdinfo)(const struct bpf_link *link, struct seq_file *seq);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index eb5e0c38eb2c..b134e679e9db 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -117,6 +117,7 @@ enum bpf_cmd {
 	BPF_LINK_GET_NEXT_ID,
 	BPF_ENABLE_STATS,
 	BPF_ITER_CREATE,
+	BPF_LINK_DETACH,
 };
=20
 enum bpf_map_type {
@@ -634,6 +635,10 @@ union bpf_attr {
 		__u32		old_prog_fd;
 	} link_update;
=20
+	struct {
+		__u32		link_fd;
+	} link_detach;
+
 	struct { /* struct used by BPF_ENABLE_STATS command */
 		__u32		type;
 	} enable_stats;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 957cce1d5168..83ff127ef7ae 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -814,6 +814,7 @@ static void bpf_cgroup_link_release(struct bpf_link *=
link)
 {
 	struct bpf_cgroup_link *cg_link =3D
 		container_of(link, struct bpf_cgroup_link, link);
+	struct cgroup *cg;
=20
 	/* link might have been auto-detached by dying cgroup already,
 	 * in that case our work is done here
@@ -832,8 +833,12 @@ static void bpf_cgroup_link_release(struct bpf_link =
*link)
 	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
 				    cg_link->type));
=20
+	cg =3D cg_link->cgroup;
+	cg_link->cgroup =3D NULL;
+
 	mutex_unlock(&cgroup_mutex);
-	cgroup_put(cg_link->cgroup);
+
+	cgroup_put(cg);
 }
=20
 static void bpf_cgroup_link_dealloc(struct bpf_link *link)
@@ -844,6 +849,13 @@ static void bpf_cgroup_link_dealloc(struct bpf_link =
*link)
 	kfree(cg_link);
 }
=20
+static int bpf_cgroup_link_detach(struct bpf_link *link)
+{
+	bpf_cgroup_link_release(link);
+
+	return 0;
+}
+
 static void bpf_cgroup_link_show_fdinfo(const struct bpf_link *link,
 					struct seq_file *seq)
 {
@@ -883,6 +895,7 @@ static int bpf_cgroup_link_fill_link_info(const struc=
t bpf_link *link,
 static const struct bpf_link_ops bpf_cgroup_link_lops =3D {
 	.release =3D bpf_cgroup_link_release,
 	.dealloc =3D bpf_cgroup_link_dealloc,
+	.detach =3D bpf_cgroup_link_detach,
 	.update_prog =3D cgroup_bpf_replace,
 	.show_fdinfo =3D bpf_cgroup_link_show_fdinfo,
 	.fill_link_info =3D bpf_cgroup_link_fill_link_info,
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 71405edd667c..542f275bf252 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -142,9 +142,16 @@ static void bpf_netns_link_release(struct bpf_link *=
link)
 	bpf_prog_array_free(old_array);
=20
 out_unlock:
+	net_link->net =3D NULL;
 	mutex_unlock(&netns_bpf_mutex);
 }
=20
+static int bpf_netns_link_detach(struct bpf_link *link)
+{
+	bpf_netns_link_release(link);
+	return 0;
+}
+
 static void bpf_netns_link_dealloc(struct bpf_link *link)
 {
 	struct bpf_netns_link *net_link =3D
@@ -228,6 +235,7 @@ static void bpf_netns_link_show_fdinfo(const struct b=
pf_link *link,
 static const struct bpf_link_ops bpf_netns_link_ops =3D {
 	.release =3D bpf_netns_link_release,
 	.dealloc =3D bpf_netns_link_dealloc,
+	.detach =3D bpf_netns_link_detach,
 	.update_prog =3D bpf_netns_link_update_prog,
 	.fill_link_info =3D bpf_netns_link_fill_info,
 	.show_fdinfo =3D bpf_netns_link_show_fdinfo,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cd3d599e9e90..2f343ce15747 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3991,6 +3991,29 @@ static int link_update(union bpf_attr *attr)
 	return ret;
 }
=20
+#define BPF_LINK_DETACH_LAST_FIELD link_detach.link_fd
+
+static int link_detach(union bpf_attr *attr)
+{
+	struct bpf_link *link;
+	int ret;
+
+	if (CHECK_ATTR(BPF_LINK_DETACH))
+		return -EINVAL;
+
+	link =3D bpf_link_get_from_fd(attr->link_detach.link_fd);
+	if (IS_ERR(link))
+		return PTR_ERR(link);
+
+	if (link->ops->detach)
+		ret =3D link->ops->detach(link);
+	else
+		ret =3D -EOPNOTSUPP;
+
+	bpf_link_put(link);
+	return ret;
+}
+
 static int bpf_link_inc_not_zero(struct bpf_link *link)
 {
 	return atomic64_fetch_add_unless(&link->refcnt, 1, 0) ? 0 : -ENOENT;
@@ -4240,6 +4263,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __use=
r *, uattr, unsigned int, siz
 	case BPF_ITER_CREATE:
 		err =3D bpf_iter_create(&attr);
 		break;
+	case BPF_LINK_DETACH:
+		err =3D link_detach(&attr);
+		break;
 	default:
 		err =3D -EINVAL;
 		break;
diff --git a/net/core/dev.c b/net/core/dev.c
index a2a57988880a..c8b911b10187 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8979,12 +8979,20 @@ static void bpf_xdp_link_release(struct bpf_link =
*link)
 	/* if racing with net_device's tear down, xdp_link->dev might be
 	 * already NULL, in which case link was already auto-detached
 	 */
-	if (xdp_link->dev)
+	if (xdp_link->dev) {
 		WARN_ON(dev_xdp_detach_link(xdp_link->dev, NULL, xdp_link));
+		xdp_link->dev =3D NULL;
+	}
=20
 	rtnl_unlock();
 }
=20
+static int bpf_xdp_link_detach(struct bpf_link *link)
+{
+	bpf_xdp_link_release(link);
+	return 0;
+}
+
 static void bpf_xdp_link_dealloc(struct bpf_link *link)
 {
 	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
@@ -9066,6 +9074,7 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
k, struct bpf_prog *new_prog,
 static const struct bpf_link_ops bpf_xdp_link_lops =3D {
 	.release =3D bpf_xdp_link_release,
 	.dealloc =3D bpf_xdp_link_dealloc,
+	.detach =3D bpf_xdp_link_detach,
 	.show_fdinfo =3D bpf_xdp_link_show_fdinfo,
 	.fill_link_info =3D bpf_xdp_link_fill_link_info,
 	.update_prog =3D bpf_xdp_link_update,
--=20
2.24.1

