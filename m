Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCA6229132
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730527AbgGVGqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:46:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730433AbgGVGq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:46:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M6iFoJ007562
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Hngij7Ty79RemBoJjD8m2n1QQaB9XP0siYNatp9GzQw=;
 b=OZWNVzM92cuNOBS5Zv35l/cTm7ycojFJhsXaKiYofpfZVsBmxu3LxYbXCFXtKT0jqpaj
 29OQDA9OPgYcEt+A/8dPTBSYS+ggLVgJwFWf592B7WnahuR83FNPFlt7cIuQKtEXXQWw
 xhPtXLdbPc6Vbkx8KMIzIZ59MQUfKFNKUYQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32ch29d79f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:27 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 23:46:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A081D2EC494E; Tue, 21 Jul 2020 23:46:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 6/9] bpf: implement BPF XDP link-specific introspection APIs
Date:   Tue, 21 Jul 2020 23:45:59 -0700
Message-ID: <20200722064603.3350758-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
References: <20200722064603.3350758-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=902 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=8 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement XDP link-specific show_fdinfo and link_info to emit ifindex.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h |  3 +++
 net/core/dev.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1da0c2984e7f..27bd1c8b0041 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4062,6 +4062,9 @@ struct bpf_link_info {
 			__u32 netns_ino;
 			__u32 attach_type;
 		} netns;
+		struct {
+			__u32 ifindex;
+		} xdp;
 	};
 } __attribute__((aligned(8)));
=20
diff --git a/net/core/dev.c b/net/core/dev.c
index 44264eff7f1c..9859dae7d4dc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8996,6 +8996,35 @@ static void bpf_xdp_link_dealloc(struct bpf_link *=
link)
 	kfree(xdp_link);
 }
=20
+static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
+				     struct seq_file *seq)
+{
+	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
+	u32 ifindex =3D 0;
+
+	rtnl_lock();
+	if (xdp_link->dev)
+		ifindex =3D xdp_link->dev->ifindex;
+	rtnl_unlock();
+
+	seq_printf(seq, "ifindex:\t%u\n", ifindex);
+}
+
+static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
+				       struct bpf_link_info *info)
+{
+	struct bpf_xdp_link *xdp_link =3D container_of(link, struct bpf_xdp_lin=
k, link);
+	u32 ifindex =3D 0;
+
+	rtnl_lock();
+	if (xdp_link->dev)
+		ifindex =3D xdp_link->dev->ifindex;
+	rtnl_unlock();
+
+	info->xdp.ifindex =3D ifindex;
+	return 0;
+}
+
 static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *n=
ew_prog,
 			       struct bpf_prog *old_prog)
 {
@@ -9041,6 +9070,8 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
k, struct bpf_prog *new_prog,
 static const struct bpf_link_ops bpf_xdp_link_lops =3D {
 	.release =3D bpf_xdp_link_release,
 	.dealloc =3D bpf_xdp_link_dealloc,
+	.show_fdinfo =3D bpf_xdp_link_show_fdinfo,
+	.fill_link_info =3D bpf_xdp_link_fill_link_info,
 	.update_prog =3D bpf_xdp_link_update,
 };
=20
--=20
2.24.1

