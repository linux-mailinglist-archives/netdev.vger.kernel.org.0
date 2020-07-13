Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4FB21CEAA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgGMFMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:12:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728617AbgGMFMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:12:53 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06D5Bw2C000308
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 22:12:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qBWFoM1JsJ015I5FXQ/P9WcbICD3OVxu3us4c9Q/xnI=;
 b=cuvWWXntaRfnMxFGjrbdX/cWbYzeb4+Um2+gUdW9V2F2iLzo9pfGkp5AN1K3JNPdNYcY
 PaALL77Fel3mRjPFCwXdczHSW27mKypd7/NBXG/5BhkChUMC3wljdYHmuZvD8aCR3m0y
 A0ybO/+pUB7viuyorFNIW5uwMibAdltw9YE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3288hks9hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 22:12:52 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 12 Jul 2020 22:12:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D697B2EC3F93; Sun, 12 Jul 2020 22:12:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/7] bpf, xdp: implement LINK_UPDATE for BPF XDP link
Date:   Sun, 12 Jul 2020 22:12:26 -0700
Message-ID: <20200713051230.3250515-4-andriin@fb.com>
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
 mlxlogscore=710 suspectscore=8 phishscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130038
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for LINK_UPDATE command for BPF XDP link to enable reliable
replacement of underlying BPF program.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 net/core/dev.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 84f755a1ec36..025687120442 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8973,9 +8973,52 @@ static void bpf_xdp_link_dealloc(struct bpf_link *=
link)
 	kfree(xdp_link);
 }
=20
+static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *n=
ew_prog,
+			       struct bpf_prog *old_prog)
+{
+	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
+	enum bpf_xdp_mode mode;
+	bpf_op_t bpf_op;
+	int err =3D 0;
+
+	rtnl_lock();
+
+	/* link might have been auto-released already, so fail */
+	if (!xdp_link->dev) {
+		err =3D -ENOLINK;
+		goto out_unlock;
+	}
+
+	if (old_prog && link->prog !=3D old_prog) {
+		err =3D -EPERM;
+		goto out_unlock;
+	}
+	old_prog =3D link->prog;
+	if (old_prog =3D=3D new_prog) {
+		/* no-op, don't disturb drivers */
+		bpf_prog_put(new_prog);
+		goto out_unlock;
+	}
+
+	mode =3D dev_xdp_mode(xdp_link->flags);
+	bpf_op =3D dev_xdp_bpf_op(xdp_link->dev, mode);
+	err =3D dev_xdp_install(xdp_link->dev, mode, bpf_op, NULL,
+			      xdp_link->flags, new_prog);
+	if (err)
+		goto out_unlock;
+
+	old_prog =3D xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	rtnl_unlock();
+	return err;
+}
+
 static const struct bpf_link_ops bpf_xdp_link_lops =3D {
 	.release =3D bpf_xdp_link_release,
 	.dealloc =3D bpf_xdp_link_dealloc,
+	.update_prog =3D bpf_xdp_link_update,
 };
=20
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *pro=
g)
--=20
2.24.1

