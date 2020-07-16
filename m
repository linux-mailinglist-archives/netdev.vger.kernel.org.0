Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF53221BA9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgGPE4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:56:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgGPE4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:56:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06G4oDb8007928
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ViZWkiXAmH0bzzCdB66mB27cfYuZHxh08hT+TY28jBM=;
 b=LgroQIH7pNIVsJPL8lkSIJ3n4mkWJhXrGDpbrz2+a6LLAZLoWa/wLF3TyxlesDO62wc8
 qge5QStSc76ky3IfPu3sm2rfrrGt4Fka8ig0iN3Q3aihueKRLr8hRX0QNypeJN3vVWvh
 xyH19LToG6HesTI6sSy5Eq2iyoOs0+Sdmn4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32afft85y4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:21 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 21:56:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9ED1A2EC422D; Wed, 15 Jul 2020 21:56:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 4/9] bpf, xdp: add bpf_link-based XDP attachment API
Date:   Wed, 15 Jul 2020 21:55:56 -0700
Message-ID: <20200716045602.3896926-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200716045602.3896926-1-andriin@fb.com>
References: <20200716045602.3896926-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 spamscore=0 suspectscore=8 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160036
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
bpf_xdp_link attachment (for a given XDP mode). Once BPF link is attached=
, it
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
 include/linux/netdevice.h |   4 +
 include/uapi/linux/bpf.h  |   7 +-
 kernel/bpf/syscall.c      |   5 ++
 net/core/dev.c            | 169 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 178 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index cad44b40c776..7d3c412fcfe5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -888,6 +888,7 @@ struct bpf_prog_offload_ops;
 struct netlink_ext_ack;
 struct xdp_umem;
 struct xdp_dev_bulk_queue;
+struct bpf_xdp_link;
=20
 enum bpf_xdp_mode {
 	XDP_MODE_SKB =3D 0,
@@ -898,6 +899,7 @@ enum bpf_xdp_mode {
=20
 struct bpf_xdp_entity {
 	struct bpf_prog *prog;
+	struct bpf_xdp_link *link;
 };
=20
 struct netdev_bpf {
@@ -3831,7 +3833,9 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff =
*skb, struct net_device *dev,
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
 		      int fd, int expected_fd, u32 flags);
+int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *pro=
g);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
+
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
=20
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5e386389913a..b4385e516aeb 100644
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
index 7ea9dfbebd8c..23e9c5807274 100644
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
@@ -3893,6 +3895,9 @@ static int link_create(union bpf_attr *attr)
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
index 6c315af8f588..ba50f68a6121 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8714,6 +8714,12 @@ int dev_change_proto_down_generic(struct net_devic=
e *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
=20
+struct bpf_xdp_link {
+	struct bpf_link link;
+	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
+	int flags;
+};
+
 static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
 {
 	if (flags & XDP_FLAGS_HW_MODE)
@@ -8736,9 +8742,19 @@ static bpf_op_t dev_xdp_bpf_op(struct net_device *=
dev, enum bpf_xdp_mode mode)
 	};
 }
=20
+static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
+					 enum bpf_xdp_mode mode)
+{
+	return dev->xdp_state[mode].link;
+}
+
 static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
 				     enum bpf_xdp_mode mode)
 {
+	struct bpf_xdp_link *link =3D dev_xdp_link(dev, mode);
+
+	if (link)
+		return link->link.prog;
 	return dev->xdp_state[mode].prog;
 }
=20
@@ -8749,9 +8765,17 @@ u32 dev_xdp_prog_id(struct net_device *dev, enum b=
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
@@ -8791,6 +8815,7 @@ static int dev_xdp_install(struct net_device *dev, =
enum bpf_xdp_mode mode,
=20
 static void dev_xdp_uninstall(struct net_device *dev)
 {
+	struct bpf_xdp_link *link;
 	struct bpf_prog *prog;
 	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
@@ -8808,14 +8833,20 @@ static void dev_xdp_uninstall(struct net_device *=
dev)
=20
 		WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
=20
-		bpf_prog_put(prog);
-		dev_xdp_set_prog(dev, mode, NULL);
+		/* auto-detach link from net device */
+		link =3D dev_xdp_link(dev, mode);
+		if (link)
+			link->dev =3D NULL;
+		else
+			bpf_prog_put(prog);
+
+		dev_xdp_set_link(dev, mode, NULL);
 	}
 }
=20
 static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack=
 *extack,
-			  struct bpf_prog *new_prog, struct bpf_prog *old_prog,
-			  u32 flags)
+			  struct bpf_xdp_link *link, struct bpf_prog *new_prog,
+			  struct bpf_prog *old_prog, u32 flags)
 {
 	struct bpf_prog *cur_prog;
 	enum bpf_xdp_mode mode;
@@ -8824,6 +8855,14 @@ static int dev_xdp_attach(struct net_device *dev, =
struct netlink_ext_ack *extack
=20
 	ASSERT_RTNL();
=20
+	/* either link or prog attachment, never both */
+	if (link && (new_prog || old_prog))
+		return -EINVAL;
+	/* link supports only XDP mode flags */
+	if (link && (flags & ~XDP_FLAGS_MODES)) {
+		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
+		return -EINVAL;
+	}
 	/* just one XDP mode bit should be set, zero defaults to SKB mode */
 	if (hweight32(flags & XDP_FLAGS_MODES) > 1) {
 		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
@@ -8836,7 +8875,18 @@ static int dev_xdp_attach(struct net_device *dev, =
struct netlink_ext_ack *extack
 	}
=20
 	mode =3D dev_xdp_mode(flags);
+	/* can't replace attached link */
+	if (dev_xdp_link(dev, mode)) {
+		NL_SET_ERR_MSG(extack, "Can't replace active BPF XDP link");
+		return -EBUSY;
+	}
+
 	cur_prog =3D dev_xdp_prog(dev, mode);
+	/* can't replace attached prog with link */
+	if (link && cur_prog) {
+		NL_SET_ERR_MSG(extack, "Can't replace active XDP program with BPF link=
");
+		return -EBUSY;
+	}
 	if ((flags & XDP_FLAGS_REPLACE) && cur_prog !=3D old_prog) {
 		NL_SET_ERR_MSG(extack, "Active program does not match expected");
 		return -EEXIST;
@@ -8846,6 +8896,10 @@ static int dev_xdp_attach(struct net_device *dev, =
struct netlink_ext_ack *extack
 		return -EBUSY;
 	}
=20
+	/* put effective new program into new_prog */
+	if (link)
+		new_prog =3D link->link.prog;
+
 	if (new_prog) {
 		bool offload =3D mode =3D=3D XDP_MODE_HW;
 		enum bpf_xdp_mode other_mode =3D mode =3D=3D XDP_MODE_SKB
@@ -8878,13 +8932,116 @@ static int dev_xdp_attach(struct net_device *dev=
, struct netlink_ext_ack *extack
 			return err;
 	}
=20
-	dev_xdp_set_prog(dev, mode, new_prog);
+	if (link)
+		dev_xdp_set_link(dev, mode, link);
+	else
+		dev_xdp_set_prog(dev, mode, new_prog);
 	if (cur_prog)
 		bpf_prog_put(cur_prog);
=20
 	return 0;
 }
=20
+static int dev_xdp_attach_link(struct net_device *dev,
+			       struct netlink_ext_ack *extack,
+			       struct bpf_xdp_link *link)
+{
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
+}
+
 /**
  *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
  *	@dev: device
@@ -8921,7 +9078,7 @@ int dev_change_xdp_fd(struct net_device *dev, struc=
t netlink_ext_ack *extack,
 		}
 	}
=20
-	err =3D dev_xdp_attach(dev, extack, new_prog, old_prog, flags);
+	err =3D dev_xdp_attach(dev, extack, NULL, new_prog, old_prog, flags);
=20
 err_out:
 	if (err && new_prog)
--=20
2.24.1

