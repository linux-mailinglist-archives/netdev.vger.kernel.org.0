Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061A9221BA6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgGPE4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:56:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgGPE4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:56:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G4sZW8001738
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fxl9Q/jibi9OE9yhTPTPNC+CT4j9PkuJ0A84B5E7ytc=;
 b=pkOisfKV08W8UPGb9oIKM5qo7xHIKXEY3U8LxiOjRvyNNPTnG+ZVvLEF67x3AyZwpsFi
 Hfenpj1oyIOrTyo262M3qGx2dLZPNI3AICseDkKkmIi8gxwedr0zTMUTo0Ln/9Dv24bj
 6WBKWzaLvKVjJLDc57KH3nkhRAfdAWeffx4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327wdrud3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:19 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 21:56:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 022E52EC422D; Wed, 15 Jul 2020 21:56:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 6/9] bpf: implement BPF XDP link-specific introspection APIs
Date:   Wed, 15 Jul 2020 21:55:58 -0700
Message-ID: <20200716045602.3896926-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200716045602.3896926-1-andriin@fb.com>
References: <20200716045602.3896926-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 clxscore=1015 impostorscore=0 suspectscore=8
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=905 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160036
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
index b4385e516aeb..441cd5044835 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3986,6 +3986,9 @@ struct bpf_link_info {
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
index 8b085dbe3cf1..662e62c8c267 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8990,6 +8990,35 @@ static void bpf_xdp_link_dealloc(struct bpf_link *=
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
@@ -9035,6 +9064,8 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
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

