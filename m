Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D724AE6E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHTF3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:29:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44910 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbgHTF27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 01:28:59 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K5AoXE006692
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 22:28:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=rwpWzKjmFqaruUF4571Q+tKjRQfEAl8lZq07kS6p5wo=;
 b=n6cL5UxPe0QusLutkW9DAHcufzl7Zqf0x3vVFnIUaxRC3yRXhnqala1sGirJkJQ+V5xg
 +Tp+LjDEaO5n9NQfjVQ8hpgvIw5360jePVWqJGdiRPXlOKYL0yCwpwcVIXCGHzWfSIG/
 uivqAqxqQrvdyLjAj3c9bkUV3+Kpa8PeS+Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3m9vj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 22:28:58 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 22:28:56 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BC3E52EC5E9A; Wed, 19 Aug 2020 22:28:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: xdp: fix XDP mode when no mode flags specified
Date:   Wed, 19 Aug 2020 22:28:41 -0700
Message-ID: <20200820052841.1559757-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=910
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in ne=
t_device")
inadvertently changed which XDP mode is assumed when no mode flags are
specified explicitly. Previously, driver mode was preferred, if driver
supported it. If not, generic SKB mode was chosen. That commit changed de=
fault
to SKB mode always. This patch fixes the issue and restores the original
logic.

Reported-by: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF program=
s in net_device")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 net/core/dev.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b5d1129d8310..d42c9ea0c3c0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8742,13 +8742,15 @@ struct bpf_xdp_link {
 	int flags;
 };
=20
-static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
+static enum bpf_xdp_mode dev_xdp_mode(struct net_device *dev, u32 flags)
 {
 	if (flags & XDP_FLAGS_HW_MODE)
 		return XDP_MODE_HW;
 	if (flags & XDP_FLAGS_DRV_MODE)
 		return XDP_MODE_DRV;
-	return XDP_MODE_SKB;
+	if (flags & XDP_FLAGS_SKB_MODE)
+		return XDP_MODE_SKB;
+	return dev->netdev_ops->ndo_bpf ? XDP_MODE_DRV : XDP_MODE_SKB;
 }
=20
 static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode=
 mode)
@@ -8896,7 +8898,7 @@ static int dev_xdp_attach(struct net_device *dev, s=
truct netlink_ext_ack *extack
 		return -EINVAL;
 	}
=20
-	mode =3D dev_xdp_mode(flags);
+	mode =3D dev_xdp_mode(dev, flags);
 	/* can't replace attached link */
 	if (dev_xdp_link(dev, mode)) {
 		NL_SET_ERR_MSG(extack, "Can't replace active BPF XDP link");
@@ -8984,7 +8986,7 @@ static int dev_xdp_detach_link(struct net_device *d=
ev,
=20
 	ASSERT_RTNL();
=20
-	mode =3D dev_xdp_mode(link->flags);
+	mode =3D dev_xdp_mode(dev, link->flags);
 	if (dev_xdp_link(dev, mode) !=3D link)
 		return -EINVAL;
=20
@@ -9080,7 +9082,7 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
k, struct bpf_prog *new_prog,
 		goto out_unlock;
 	}
=20
-	mode =3D dev_xdp_mode(xdp_link->flags);
+	mode =3D dev_xdp_mode(xdp_link->dev, xdp_link->flags);
 	bpf_op =3D dev_xdp_bpf_op(xdp_link->dev, mode);
 	err =3D dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
 			      xdp_link->flags, new_prog);
@@ -9164,7 +9166,7 @@ int bpf_xdp_link_attach(const union bpf_attr *attr,=
 struct bpf_prog *prog)
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
 		      int fd, int expected_fd, u32 flags)
 {
-	enum bpf_xdp_mode mode =3D dev_xdp_mode(flags);
+	enum bpf_xdp_mode mode =3D dev_xdp_mode(dev, flags);
 	struct bpf_prog *new_prog =3D NULL, *old_prog =3D NULL;
 	int err;
=20
--=20
2.24.1

