Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60410221BB1
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgGPE5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:57:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgGPE5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:57:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G4uIwj013474
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/zbODb/YH1jOdAZL55iyKGaFJ0W1VBwuoHDCNgwwrQ8=;
 b=hwbRcGrxYMradKuAzVsX/J62SCU7w1aCTQit6MJMx82UiNEm/tipk1zkacpIcYlcA8Zi
 8T4J1R22gVzHefB5Qmdrajty+QRP9isKZZ6ph/j/JfSsmivdr1q+VR0LSrTTbEXT1ddD
 UNNrW3mtNEuXMfPnJwN95BoD9ktfWu3WEf8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32a7fpt5tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:57:24 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 21:56:17 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CD9132EC422D; Wed, 15 Jul 2020 21:56:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 5/9] bpf, xdp: implement LINK_UPDATE for BPF XDP link
Date:   Wed, 15 Jul 2020 21:55:57 -0700
Message-ID: <20200716045602.3896926-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200716045602.3896926-1-andriin@fb.com>
References: <20200716045602.3896926-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=707 malwarescore=0 spamscore=0
 lowpriorityscore=0 suspectscore=8 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160037
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
index ba50f68a6121..8b085dbe3cf1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8990,9 +8990,52 @@ static void bpf_xdp_link_dealloc(struct bpf_link *=
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

