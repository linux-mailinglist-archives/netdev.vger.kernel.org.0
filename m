Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18657229129
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgGVGqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:46:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58974 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729868AbgGVGqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:46:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M6iFXc030678
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mnUWFvYznG9wK8cawsa8jNN7a+b37lwDfmulrDY5Ej8=;
 b=mK8LWSkAaxnnlzNVgGW5aALzXuf1NrX7lpg7lth65IGL5YwGmPWmkNrsIHVazqIIfIhn
 ZQicleA18CwLQhq95j1o4RYzTyF4JA9WNM8GVLUSFDFxUi+9vJhcKRgMSUgpA9SABkH+
 ai7EMC1Ns6pVMUE6b2ir1TR1sayvpmhm7lI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxwfypuu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:15 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 23:46:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 050282EC494E; Tue, 21 Jul 2020 23:46:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/9] bpf, xdp: extract common XDP program attachment logic
Date:   Tue, 21 Jul 2020 23:45:56 -0700
Message-ID: <20200722064603.3350758-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
References: <20200722064603.3350758-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Further refactor XDP attachment code. dev_change_xdp_fd() is split into t=
wo
parts: getting bpf_progs from FDs and attachment logic, working with
bpf_progs. This makes attachment  logic a bit more straightforward and
prepares code for bpf_xdp_link inclusion, which will share the common log=
ic.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 net/core/dev.c | 165 +++++++++++++++++++++++++++----------------------
 1 file changed, 91 insertions(+), 74 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7e753e248cef..abf573b2dcf4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8815,111 +8815,128 @@ static void dev_xdp_uninstall(struct net_device=
 *dev)
 	}
 }
=20
-/**
- *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
- *	@dev: device
- *	@extack: netlink extended ack
- *	@fd: new program fd or negative value to clear
- *	@expected_fd: old program fd that userspace expects to replace or cle=
ar
- *	@flags: xdp-related flags
- *
- *	Set or clear a bpf program for a device
- */
-int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
-		      int fd, int expected_fd, u32 flags)
+static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack=
 *extack,
+			  struct bpf_prog *new_prog, struct bpf_prog *old_prog,
+			  u32 flags)
 {
-	const struct net_device_ops *ops =3D dev->netdev_ops;
-	enum bpf_xdp_mode mode =3D dev_xdp_mode(flags);
-	bool offload =3D mode =3D=3D XDP_MODE_HW;
-	u32 prog_id, expected_id =3D 0;
-	struct bpf_prog *prog;
+	struct bpf_prog *cur_prog;
+	enum bpf_xdp_mode mode;
 	bpf_op_t bpf_op;
 	int err;
=20
 	ASSERT_RTNL();
=20
-	bpf_op =3D dev_xdp_bpf_op(dev, mode);
-	if (!bpf_op) {
-		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in nati=
ve mode");
-		return -EOPNOTSUPP;
+	/* just one XDP mode bit should be set, zero defaults to SKB mode */
+	if (hweight32(flags & XDP_FLAGS_MODES) > 1) {
+		NL_SET_ERR_MSG(extack, "Only one XDP mode flag can be set");
+		return -EINVAL;
+	}
+	/* old_prog !=3D NULL implies XDP_FLAGS_REPLACE is set */
+	if (old_prog && !(flags & XDP_FLAGS_REPLACE)) {
+		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
+		return -EINVAL;
 	}
=20
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
+	mode =3D dev_xdp_mode(flags);
+	cur_prog =3D dev_xdp_prog(dev, mode);
+	if ((flags & XDP_FLAGS_REPLACE) && cur_prog !=3D old_prog) {
+		NL_SET_ERR_MSG(extack, "Active program does not match expected");
+		return -EEXIST;
 	}
-	if (fd >=3D 0) {
+	if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
+		NL_SET_ERR_MSG(extack, "XDP program already attached");
+		return -EBUSY;
+	}
+
+	if (new_prog) {
+		bool offload =3D mode =3D=3D XDP_MODE_HW;
 		enum bpf_xdp_mode other_mode =3D mode =3D=3D XDP_MODE_SKB
 					       ? XDP_MODE_DRV : XDP_MODE_SKB;
=20
-		if (!offload && dev_xdp_prog_id(dev, other_mode)) {
+		if (!offload && dev_xdp_prog(dev, other_mode)) {
 			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the=
 same time");
 			return -EEXIST;
 		}
-
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
-			NL_SET_ERR_MSG(extack, "XDP program already attached");
-			return -EBUSY;
-		}
-
-		prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op =3D=3D ops->ndo_bpf);
-		if (IS_ERR(prog))
-			return PTR_ERR(prog);
-
-		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
+		if (!offload && bpf_prog_is_dev_bound(new_prog->aux)) {
 			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE fl=
ag is not supported");
-			bpf_prog_put(prog);
 			return -EINVAL;
 		}
-
-		if (prog->expected_attach_type =3D=3D BPF_XDP_DEVMAP) {
+		if (new_prog->expected_attach_type =3D=3D BPF_XDP_DEVMAP) {
 			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached t=
o a device");
-			bpf_prog_put(prog);
 			return -EINVAL;
 		}
-
-		if (prog->expected_attach_type =3D=3D BPF_XDP_CPUMAP) {
-			NL_SET_ERR_MSG(extack,
-				       "BPF_XDP_CPUMAP programs can not be attached to a device");
-			bpf_prog_put(prog);
+		if (new_prog->expected_attach_type =3D=3D BPF_XDP_CPUMAP) {
+			NL_SET_ERR_MSG(extack, "BPF_XDP_CPUMAP programs can not be attached t=
o a device");
 			return -EINVAL;
 		}
+	}
=20
-		/* prog->aux->id may be 0 for orphaned device-bound progs */
-		if (prog->aux->id && prog->aux->id =3D=3D prog_id) {
-			bpf_prog_put(prog);
-			return 0;
+	/* don't call drivers if the effective program didn't change */
+	if (new_prog !=3D cur_prog) {
+		bpf_op =3D dev_xdp_bpf_op(dev, mode);
+		if (!bpf_op) {
+			NL_SET_ERR_MSG(extack, "Underlying driver does not support XDP in nat=
ive mode");
+			return -EOPNOTSUPP;
 		}
-	} else {
-		if (!prog_id)
-			return 0;
-		prog =3D NULL;
-	}
=20
-	err =3D dev_xdp_install(dev, mode, bpf_op, extack, flags, prog);
-	if (err < 0 && prog) {
-		bpf_prog_put(prog);
-		return err;
+		err =3D dev_xdp_install(dev, mode, bpf_op, extack, flags, new_prog);
+		if (err)
+			return err;
 	}
-	dev_xdp_set_prog(dev, mode, prog);
+
+	dev_xdp_set_prog(dev, mode, new_prog);
+	if (cur_prog)
+		bpf_prog_put(cur_prog);
=20
 	return 0;
 }
=20
+/**
+ *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
+ *	@dev: device
+ *	@extack: netlink extended ack
+ *	@fd: new program fd or negative value to clear
+ *	@expected_fd: old program fd that userspace expects to replace or cle=
ar
+ *	@flags: xdp-related flags
+ *
+ *	Set or clear a bpf program for a device
+ */
+int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
+		      int fd, int expected_fd, u32 flags)
+{
+	enum bpf_xdp_mode mode =3D dev_xdp_mode(flags);
+	struct bpf_prog *new_prog =3D NULL, *old_prog =3D NULL;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (fd >=3D 0) {
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
+		}
+	}
+
+	err =3D dev_xdp_attach(dev, extack, new_prog, old_prog, flags);
+
+err_out:
+	if (err && new_prog)
+		bpf_prog_put(new_prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	return err;
+}
+
 /**
  *	dev_new_index	-	allocate an ifindex
  *	@net: the applicable net namespace
--=20
2.24.1

