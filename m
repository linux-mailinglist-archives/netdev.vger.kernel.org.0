Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8EC21CEB4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgGMFMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:12:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgGMFMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:12:51 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06D5BgqD032696
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 22:12:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=T4U3uvylfgu/+pgH0vIYhJtXEHjyZvE0WazrIin8PX0=;
 b=Baf9M5QIDJTQrCygyxe0IcYWcPNmV5YxLPlWwu/JDMO3nUBT0UcFnM4u22CxrJpD71cZ
 BqVFsGUWmr7ZoRgLtubEMJu++ovFUEOXOHOrgn4bfchVHJ1UfduniNp1/vCIL17oEhjw
 NI1PBcYDV2edVY0vW6i4UuTTmTrqWemiA18= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3288hks9h9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 22:12:50 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 22:12:50 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ABDD42EC3F93; Sun, 12 Jul 2020 22:12:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/7] bpf, xdp: add bpf_link-based XDP attachment API
Date:   Sun, 12 Jul 2020 22:12:25 -0700
Message-ID: <20200713051230.3250515-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713051230.3250515-1-andriin@fb.com>
References: <20200713051230.3250515-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_03:2020-07-10,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 suspectscore=8 phishscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_link-based API (bpf_xdp_link) to attach BPF XDP program through
BPF_LINK_CREATE command.

bpf_xdp_link is mutually exclusive with direct BPF program attachment,
previous BPF program should be detached prior to attempting to create a n=
ew
bpf_xdp_link attachment (for a given XDP mode). Once link is attached, it
can't be replaced by other BPF program attachment or link attachment. It =
will
be detached only when the last BPF link FD is closed.

bpf_xdp_link will be auto-detached when net_device is shutdown, similarly=
 to
how other BPF links behave (cgroup, flow_dissector). At that point bpf_li=
nk
will become defunct, but won't be destroyed until last FD is closed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/netdevice.h |   6 +
 include/uapi/linux/bpf.h  |   7 +-
 kernel/bpf/syscall.c      |   5 +
 net/core/dev.c            | 385 ++++++++++++++++++++++++++++----------
 4 files changed, 301 insertions(+), 102 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d5630e535836..93bcd81d645d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -886,6 +886,7 @@ struct bpf_prog_offload_ops;
 struct netlink_ext_ack;
 struct xdp_umem;
 struct xdp_dev_bulk_queue;
+struct bpf_xdp_link;
=20
 enum bpf_xdp_mode {
 	XDP_MODE_SKB =3D 0,
@@ -896,6 +897,7 @@ enum bpf_xdp_mode {
=20
 struct bpf_xdp_entity {
 	struct bpf_prog *prog;
+	struct bpf_xdp_link *link;
 };
=20
 struct netdev_bpf {
@@ -3824,6 +3826,10 @@ typedef int (*bpf_op_t)(struct net_device *dev, st=
ruct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
 		      int fd, int expected_fd, u32 flags);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
+
+struct bpf_xdp_link;
+int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *pro=
g);
+
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
=20
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 548a749aebb3..41eba148217b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -227,6 +227,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
 	BPF_CGROUP_INET_SOCK_RELEASE,
+	BPF_XDP,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
@@ -239,6 +240,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_CGROUP =3D 3,
 	BPF_LINK_TYPE_ITER =3D 4,
 	BPF_LINK_TYPE_NETNS =3D 5,
+	BPF_LINK_TYPE_XDP =3D 6,
=20
 	MAX_BPF_LINK_TYPE,
 };
@@ -604,7 +606,10 @@ union bpf_attr {
=20
 	struct { /* struct used by BPF_LINK_CREATE command */
 		__u32		prog_fd;	/* eBPF program to attach */
-		__u32		target_fd;	/* object to attach to */
+		union {
+			__u32		target_fd;	/* object to attach to */
+			__u32		target_ifindex; /* target ifindex */
+		};
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
 	} link_create;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 156f51ffada2..eb4ed4b29418 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2817,6 +2817,8 @@ attach_type_to_prog_type(enum bpf_attach_type attac=
h_type)
 		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	case BPF_TRACE_ITER:
 		return BPF_PROG_TYPE_TRACING;
+	case BPF_XDP:
+		return BPF_PROG_TYPE_XDP;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3890,6 +3892,9 @@ static int link_create(union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret =3D netns_bpf_link_create(attr, prog);
 		break;
+	case BPF_PROG_TYPE_XDP:
+		ret =3D bpf_xdp_link_attach(attr, prog);
+		break;
 	default:
 		ret =3D -EINVAL;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index d3b82b664e2d..84f755a1ec36 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8713,8 +8713,47 @@ int dev_change_proto_down_generic(struct net_devic=
e *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
=20
-static struct bpf_prog *dev_xdp_prog(struct net_device *dev, enum bpf_xd=
p_mode mode)
+struct bpf_xdp_link {
+	struct bpf_link link;
+	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
+	int flags;
+};
+
+static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
+{
+	if (flags & XDP_FLAGS_HW_MODE)
+		return XDP_MODE_HW;
+	if (flags & XDP_FLAGS_DRV_MODE)
+		return XDP_MODE_DRV;
+	return XDP_MODE_SKB;
+}
+
+static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode=
 mode)
 {
+	switch (mode) {
+	case XDP_MODE_SKB:
+		return generic_xdp_install;
+	case XDP_MODE_DRV:
+	case XDP_MODE_HW:
+		return dev->netdev_ops->ndo_bpf;
+	default:
+		return NULL;
+	};
+}
+
+static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
+					 enum bpf_xdp_mode mode)
+{
+	return dev->xdp_state[mode].link;
+}
+
+static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
+				     enum bpf_xdp_mode mode)
+{
+	struct bpf_xdp_link *link =3D dev_xdp_link(dev, mode);
+
+	if (link)
+		return link->link.prog;
 	return dev->xdp_state[mode].prog;
 }
=20
@@ -8725,9 +8764,17 @@ u32 dev_xdp_prog_id(struct net_device *dev, enum b=
pf_xdp_mode mode)
 	return prog ? prog->aux->id : 0;
 }
=20
+static void dev_xdp_set_link(struct net_device *dev, enum bpf_xdp_mode m=
ode,
+			     struct bpf_xdp_link *link)
+{
+	dev->xdp_state[mode].link =3D link;
+	dev->xdp_state[mode].prog =3D NULL;
+}
+
 static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode m=
ode,
 			     struct bpf_prog *prog)
 {
+	dev->xdp_state[mode].link =3D NULL;
 	dev->xdp_state[mode].prog =3D prog;
 }
=20
@@ -8744,6 +8791,14 @@ static int dev_xdp_install(struct net_device *dev,=
 enum bpf_xdp_mode mode,
 	xdp.flags =3D flags;
 	xdp.prog =3D prog;
=20
+	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
+	 * "moved" into driver), so they don't increment it on their own, but
+	 * they do decrement refcnt when program is detached or replaced.
+	 * Given net_device also owns link/prog, we need to bump refcnt here
+	 * to prevent drivers from underflowing it.
+	 */
+	if (prog)
+		bpf_prog_inc(prog);
 	err =3D bpf_op(dev, &xdp);
 	if (err)
 		return err;
@@ -8756,39 +8811,221 @@ static int dev_xdp_install(struct net_device *de=
v, enum bpf_xdp_mode mode,
=20
 static void dev_xdp_uninstall(struct net_device *dev)
 {
-	bpf_op_t ndo_bpf;
+	struct bpf_xdp_link *link;
+	struct bpf_prog *prog;
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
=20
-	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, XDP_MODE_SKB, generic_xdp_install,
-				NULL, 0, NULL));
-	dev_xdp_set_prog(dev, XDP_MODE_SKB, NULL);
+	ASSERT_RTNL();
=20
-	/* Remove from the driver */
-	ndo_bpf =3D dev->netdev_ops->ndo_bpf;
-	if (!ndo_bpf)
-		return;
+	for (mode =3D XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
+		prog =3D dev_xdp_prog(dev, mode);
+		if (!prog)
+			continue;
+
+		bpf_op =3D dev_xdp_bpf_op(dev, mode);
+		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+
+		/* auto-detach link from net device */
+		link =3D dev_xdp_link(dev, mode);
+		if (link)
+			link->dev =3D NULL;
+		else
+			bpf_prog_put(prog);
+
+		dev_xdp_set_link(dev, mode, NULL);
+	}
+}
+
+static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack=
 *extack,
+			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
+			  struct bpf_prog *old_prog, u32 flags)
+{
+	struct bpf_prog *cur_prog;
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+	int err;
+
+	ASSERT_RTNL();
=20
-	if (dev_xdp_prog_id(dev, XDP_MODE_DRV)) {
-		WARN_ON(dev_xdp_install(dev, XDP_MODE_DRV, ndo_bpf,
-					NULL, 0, NULL));
-		dev_xdp_set_prog(dev, XDP_MODE_DRV, NULL);
+	/* link supports only XDP mode flags */
+	if (link && (flags & ~XDP_FLAGS_MODES))
+		return -EINVAL;
+	/* just one XDP mode bit should be set, zero defaults to SKB mode */
+	if (hweight32(flags & XDP_FLAGS_MODES) > 1)
+		return -EINVAL;
+	/* old_prog !=3D NULL implies XDP_FLAGS_REPLACE is set */
+	if (old_prog && !(flags & XDP_FLAGS_REPLACE))
+		return -EINVAL;
+	/* either link or prog attachment, never both */
+	if (link && (new_prog || old_prog))
+		return -EINVAL;
+
+	mode =3D dev_xdp_mode(flags);
+	/* can't replace attached link */
+	if (dev_xdp_link(dev, mode))
+		return -EBUSY;
+
+	cur_prog =3D dev_xdp_prog(dev, mode);
+	/* can't replace attached prog with link */
+	if (link && cur_prog)
+		return -EBUSY;
+	if ((flags & XDP_FLAGS_REPLACE) && cur_prog !=3D old_prog) {
+		NL_SET_ERR_MSG(extack, "Active program does not match expected");
+		return -EEXIST;
+	}
+	if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
+		NL_SET_ERR_MSG(extack, "XDP program already attached");
+		return -EBUSY;
+	}
+
+	/* put effective new program into new_prog */
+	if (link)
+		new_prog =3D link->link.prog;
+
+	if (link || new_prog) {
+		bool offload =3D mode =3D=3D XDP_MODE_HW;
+		enum bpf_xdp_mode other_mode =3D mode =3D=3D XDP_MODE_SKB
+					       ? XDP_MODE_DRV : XDP_MODE_SKB;
+
+		if (!offload && dev_xdp_prog(dev, other_mode)) {
+			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the=
 same time");
+			return -EEXIST;
+		}
+		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
+			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE fl=
ag is not supported");
+			return -EINVAL;
+		}
+		if (new_prog->expected_attach_type =3D=3D BPF_XDP_DEVMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached t=
o a device");
+			return -EINVAL;
+		}
 	}
=20
-	/* Remove HW offload */
-	if (dev_xdp_prog_id(dev, XDP_MODE_HW)) {
-		WARN_ON(dev_xdp_install(dev, XDP_MODE_HW, ndo_bpf,
-					NULL, 0, NULL));
-		dev_xdp_set_prog(dev, XDP_MODE_HW, NULL);
+	/* don't call drivers if the effective program didn't change */
+	if (new_prog !=3D cur_prog) {
+		bpf_op =3D dev_xdp_bpf_op(dev, mode);
+		if (!bpf_op) {
+			NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in nat=
ive mode");
+			return -EOPNOTSUPP;
+		}
+
+		err =3D dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
+		if (err)
+			return err;
 	}
+
+	if (link)
+		dev_xdp_set_link(dev, mode, link);
+	else
+		dev_xdp_set_prog(dev, mode, new_prog);
+	if (cur_prog)
+		bpf_prog_put(cur_prog);
+
+	return 0;
 }
=20
-static enum bpf_xdp_mode xdp_flags_to_mode(u32 flags)
+static int dev_xdp_attach_link(struct net_device *dev,
+			       struct netlink_ext_ack *extack,
+			       struct bpf_xdp_link *link)
 {
-	if (flags & XDP_FLAGS_HW_MODE)
-		return XDP_MODE_HW;
-	if (flags & XDP_FLAGS_DRV_MODE)
-		return XDP_MODE_DRV;
-	return XDP_MODE_SKB;
+	return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
+}
+
+static int dev_xdp_detach_link(struct net_device *dev,
+			       struct netlink_ext_ack *extack,
+			       struct bpf_xdp_link *link)
+{
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+
+	ASSERT_RTNL();
+
+	mode =3D dev_xdp_mode(link->flags);
+	if (dev_xdp_link(dev, mode) !=3D link)
+		return -EINVAL;
+
+	bpf_op =3D dev_xdp_bpf_op(dev, mode);
+	WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
+	dev_xdp_set_link(dev, mode, NULL);
+	return 0;
+}
+
+static void bpf_xdp_link_release(struct bpf_link *link)
+{
+	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
+
+	rtnl_lock();
+
+	/* if racing with net_device's tear down, xdp_link->dev might be
+	 * already NULL, in which case link was already auto-detached
+	 */
+	if (xdp_link->dev)
+		WARN_ON(dev_xdp_detach_link(xdp_link->dev, NULL, xdp_link));
+
+	rtnl_unlock();
+}
+
+static void bpf_xdp_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
+
+	kfree(xdp_link);
+}
+
+static const struct bpf_link_ops bpf_xdp_link_lops =3D {
+	.release =3D bpf_xdp_link_release,
+	.dealloc =3D bpf_xdp_link_dealloc,
+};
+
+int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *pro=
g)
+{
+	struct net *net =3D current->nsproxy->net_ns;
+	struct bpf_link_primer link_primer;
+	struct bpf_xdp_link *link;
+	struct net_device *dev;
+	int err, fd;
+
+	if (attr->link_create.flags & ~XDP_FLAGS_MODES)
+		return -EINVAL;
+
+	dev =3D dev_get_by_index(net, attr->link_create.target_ifindex);
+	if (!dev)
+		return -EINVAL;
+
+	link =3D kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
+		err =3D -ENOMEM;
+		goto out_put_dev;
+	}
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_XDP, &bpf_xdp_link_lops, prog)=
;
+	link->dev =3D dev;
+	link->flags =3D attr->link_create.flags;
+
+	err =3D bpf_link_prime(&link->link, &link_primer);
+	if (err) {
+		kfree(link);
+		goto out_put_dev;
+	}
+
+	rtnl_lock();
+	err =3D dev_xdp_attach_link(dev, NULL, link);
+	rtnl_unlock();
+
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		goto out_put_dev;
+	}
+
+	fd =3D bpf_link_settle(&link_primer);
+	/* link itself doesn't hold dev's refcnt to not complicate shutdown */
+	dev_put(dev);
+	return fd;
+
+out_put_dev:
+	dev_put(dev);
+	return err;
 }
=20
 /**
@@ -8804,91 +9041,37 @@ static enum bpf_xdp_mode xdp_flags_to_mode(u32 fl=
ags)
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
 		      int fd, int expected_fd, u32 flags)
 {
-	const struct net_device_ops *ops =3D dev->netdev_ops;
-	enum bpf_xdp_mode mode =3D xdp_flags_to_mode(flags);
-	bool offload =3D mode =3D=3D XDP_MODE_HW;
-	u32 prog_id, expected_id =3D 0;
-	bpf_op_t bpf_op, bpf_chk;
-	struct bpf_prog *prog;
+	enum bpf_xdp_mode mode =3D dev_xdp_mode(flags);
+	struct bpf_prog *new_prog =3D NULL, *old_prog =3D NULL;
 	int err;
=20
 	ASSERT_RTNL();
=20
-	bpf_op =3D bpf_chk =3D ops->ndo_bpf;
-	if (!bpf_op && (mode =3D=3D XDP_MODE_DRV || mode =3D=3D XDP_MODE_HW)) {
-		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in nati=
ve mode");
-		return -EOPNOTSUPP;
-	}
-	if (!bpf_op || mode =3D=3D XDP_MODE_SKB)
-		bpf_op =3D generic_xdp_install;
-	if (bpf_op =3D=3D bpf_chk)
-		bpf_chk =3D generic_xdp_install;
-
-	prog_id =3D dev_xdp_prog_id(dev, mode);
-	if (flags & XDP_FLAGS_REPLACE) {
-		if (expected_fd >=3D 0) {
-			prog =3D bpf_prog_get_type_dev(expected_fd,
-						     BPF_PROG_TYPE_XDP,
-						     bpf_op =3D=3D ops->ndo_bpf);
-			if (IS_ERR(prog))
-				return PTR_ERR(prog);
-			expected_id =3D prog->aux->id;
-			bpf_prog_put(prog);
-		}
-
-		if (prog_id !=3D expected_id) {
-			NL_SET_ERR_MSG(extack, "Active program does not match expected");
-			return -EEXIST;
-		}
-	}
 	if (fd >=3D 0) {
-		/* XDP_MODE_SKB =3D=3D 1 - XDP_MODE_DRV */
-		if (!offload && dev_xdp_prog_id(dev, 1 - mode)) {
-			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the=
 same time");
-			return -EEXIST;
-		}
-
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
-			NL_SET_ERR_MSG(extack, "XDP program already attached");
-			return -EBUSY;
+		new_prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
+						 mode !=3D XDP_MODE_SKB);
+		if (IS_ERR(new_prog))
+			return PTR_ERR(new_prog);
+	}
+
+	if (expected_fd >=3D 0) {
+		old_prog =3D bpf_prog_get_type_dev(expected_fd, BPF_PROG_TYPE_XDP,
+						 mode !=3D XDP_MODE_SKB);
+		if (IS_ERR(old_prog)) {
+			err =3D PTR_ERR(old_prog);
+			old_prog =3D NULL;
+			goto err_out;
 		}
-
-		prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op =3D=3D ops->ndo_bpf);
-		if (IS_ERR(prog))
-			return PTR_ERR(prog);
-
-		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
-			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE fl=
ag is not supported");
-			bpf_prog_put(prog);
-			return -EINVAL;
-		}
-
-		if (prog->expected_attach_type =3D=3D BPF_XDP_DEVMAP) {
-			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached t=
o a device");
-			bpf_prog_put(prog);
-			return -EINVAL;
-		}
-
-		/* prog->aux->id may be 0 for orphaned device-bound progs */
-		if (prog->aux->id && prog->aux->id =3D=3D prog_id) {
-			bpf_prog_put(prog);
-			return 0;
-		}
-	} else {
-		if (!prog_id)
-			return 0;
-		prog =3D NULL;
 	}
=20
-	err =3D dev_xdp_install(dev, mode, bpf_op, extack, flags, prog);
-	if (err < 0 && prog) {
-		bpf_prog_put(prog);
-		return err;
-	}
-	dev_xdp_set_prog(dev, mode, prog);
+	err =3D dev_xdp_attach(dev, extack, NULL, new_prog, old_prog, flags);
=20
-	return 0;
+err_out:
+	if (err && new_prog)
+		bpf_prog_put(new_prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	return err;
 }
=20
 /**
--=20
2.24.1

