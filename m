Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE43021E6AD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 06:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNEHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 00:07:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgGNEHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 00:07:03 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06E45pJ9007575
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 21:07:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9RhgKtPkTMWr8Ob6gFNZnAzNBN5VqkTL2v4oTT63kGg=;
 b=q5ishNeO66CpepvMsz7378aj+oP/piwHrYmV+rUWPYqGg6pIHHq4hiaEiDQgdFQFdtEL
 0+1jl71vDvTh2AlGOMo2gsgHcIkHha8Ja0aDbBXjPwUN2madNv31XliD0tDzaqxkndGa
 FBI1lynUp5SoRS9XiLDNYa/qVCqTTF0o//M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3278x0bjh3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 21:07:02 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 21:07:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 43DB22EC402C; Mon, 13 Jul 2020 21:06:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 5/8] bpf: implement BPF XDP link-specific introspection APIs
Date:   Mon, 13 Jul 2020 21:06:40 -0700
Message-ID: <20200714040643.1135876-6-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200714040643.1135876-1-andriin@fb.com>
References: <20200714040643.1135876-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_17:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=908 priorityscore=1501
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140030
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
index 41eba148217b..533eb4fe4e03 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3985,6 +3985,9 @@ struct bpf_link_info {
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
index 7c2935d567c4..e5b3cdfacdbf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8989,6 +8989,35 @@ static void bpf_xdp_link_dealloc(struct bpf_link *=
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
@@ -9034,6 +9063,8 @@ static int bpf_xdp_link_update(struct bpf_link *lin=
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

