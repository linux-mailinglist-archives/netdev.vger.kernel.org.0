Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121F62327D5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgG2XFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:05:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33222 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgG2XFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:05:33 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TMsNTw003778
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=saW7INnX4zPaNEwOyDO0i9vldF/kQoPqORYPJnYQ0nE=;
 b=QVJByBcZutzVMYtQHYN7MzPLNQfVerbYLO4D07YV1Zl3ZNZWB5ROByFKYh+yOVey5Hqp
 1fC9rrqpowXfAL9gJ/rUySjiPnEiD6e9BgBEisfGeLbTHyNA/MNBPrqqC3DsP5WR4wKV
 +CGQ33RsPV3hRR4xQcv+L7bup2BOwM70k+c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kd86hk6x-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:32 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:05:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E90B02EC4E37; Wed, 29 Jul 2020 16:05:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/5] libbpf: add bpf_link detach APIs
Date:   Wed, 29 Jul 2020 16:05:17 -0700
Message-ID: <20200729230520.693207-3-andriin@fb.com>
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
 mlxlogscore=782 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add low-level bpf_link_detach() API. Also add higher-level bpf_link__deta=
ch()
one.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h |  5 +++++
 tools/lib/bpf/bpf.c            | 10 ++++++++++
 tools/lib/bpf/bpf.h            |  2 ++
 tools/lib/bpf/libbpf.c         |  5 +++++
 tools/lib/bpf/libbpf.h         |  1 +
 tools/lib/bpf/libbpf.map       |  2 ++
 6 files changed, 25 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index eb5e0c38eb2c..b134e679e9db 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
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
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index e1bdf214f75f..eab14c97c15d 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -603,6 +603,16 @@ int bpf_link_create(int prog_fd, int target_fd,
 	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
 }
=20
+int bpf_link_detach(int link_fd)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.link_detach.link_fd =3D link_fd;
+
+	return sys_bpf(BPF_LINK_DETACH, &attr, sizeof(attr));
+}
+
 int bpf_link_update(int link_fd, int new_prog_fd,
 		    const struct bpf_link_update_opts *opts)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 6d367e01d05e..28855fd5b5f4 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -178,6 +178,8 @@ LIBBPF_API int bpf_link_create(int prog_fd, int targe=
t_fd,
 			       enum bpf_attach_type attach_type,
 			       const struct bpf_link_create_opts *opts);
=20
+LIBBPF_API int bpf_link_detach(int link_fd);
+
 struct bpf_link_update_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
 	__u32 flags;	   /* extra flags */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 54830d603fee..6c5c14f639e8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7748,6 +7748,11 @@ struct bpf_link *bpf_link__open(const char *path)
 	return link;
 }
=20
+int bpf_link__detach(struct bpf_link *link)
+{
+	return bpf_link_detach(link->fd) ? -errno : 0;
+}
+
 int bpf_link__pin(struct bpf_link *link, const char *path)
 {
 	int err;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 9924385462ab..3ed1399bfbbc 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -229,6 +229,7 @@ LIBBPF_API int bpf_link__unpin(struct bpf_link *link)=
;
 LIBBPF_API int bpf_link__update_program(struct bpf_link *link,
 					struct bpf_program *prog);
 LIBBPF_API void bpf_link__disconnect(struct bpf_link *link);
+LIBBPF_API int bpf_link__detach(struct bpf_link *link);
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
=20
 LIBBPF_API struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index ca49a6a7e5b2..099863411f7d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -273,6 +273,8 @@ LIBBPF_0.0.9 {
=20
 LIBBPF_0.1.0 {
 	global:
+		bpf_link__detach;
+		bpf_link_detach;
 		bpf_map__ifindex;
 		bpf_map__key_size;
 		bpf_map__map_flags;
--=20
2.24.1

