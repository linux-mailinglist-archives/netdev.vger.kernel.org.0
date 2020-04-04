Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC319E1D9
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgDDAKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgDDAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03405BMH014124
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vIqrDk2RyBoqsFvbBiveTww9qfBkfbTT/SwQnu1bTbg=;
 b=YZnZDSOY1PwAuL+KU1qt87ObPkG0eT6cIngN1AipXVdVoAbXDdRwhkLSVM4Vy+Fi8aMo
 hViJfzpKW6FR3fmsyAHCdl9WTmaSUT/7JXYKAhCnzY45lTua5YHr4+LHgB9mrUN8VP5l
 W+FDYwH24kC790q8MLBhtuV6DQ73KdJDbc8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 305upkd6ky-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:19 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:16 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 599502EC2885; Fri,  3 Apr 2020 17:10:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 7/8] bpftool: expose attach_type-to-string array to non-cgroup code
Date:   Fri, 3 Apr 2020 17:09:46 -0700
Message-ID: <20200404000948.3980903-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404000948.3980903-1-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 suspectscore=8 mlxlogscore=999 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move attach_type_strings into main.h for access in non-cgroup code.
bpf_attach_type is used for non-cgroup attach types quite widely now. So =
also
complete missing string translations for non-cgroup attach types.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/cgroup.c | 28 +++-------------------------
 tools/bpf/bpftool/main.h   | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 62c6a1d7cd18..d1fd9c9f2690 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -31,35 +31,13 @@
=20
 static unsigned int query_flags;
=20
-static const char * const attach_type_strings[] =3D {
-	[BPF_CGROUP_INET_INGRESS] =3D "ingress",
-	[BPF_CGROUP_INET_EGRESS] =3D "egress",
-	[BPF_CGROUP_INET_SOCK_CREATE] =3D "sock_create",
-	[BPF_CGROUP_SOCK_OPS] =3D "sock_ops",
-	[BPF_CGROUP_DEVICE] =3D "device",
-	[BPF_CGROUP_INET4_BIND] =3D "bind4",
-	[BPF_CGROUP_INET6_BIND] =3D "bind6",
-	[BPF_CGROUP_INET4_CONNECT] =3D "connect4",
-	[BPF_CGROUP_INET6_CONNECT] =3D "connect6",
-	[BPF_CGROUP_INET4_POST_BIND] =3D "post_bind4",
-	[BPF_CGROUP_INET6_POST_BIND] =3D "post_bind6",
-	[BPF_CGROUP_UDP4_SENDMSG] =3D "sendmsg4",
-	[BPF_CGROUP_UDP6_SENDMSG] =3D "sendmsg6",
-	[BPF_CGROUP_SYSCTL] =3D "sysctl",
-	[BPF_CGROUP_UDP4_RECVMSG] =3D "recvmsg4",
-	[BPF_CGROUP_UDP6_RECVMSG] =3D "recvmsg6",
-	[BPF_CGROUP_GETSOCKOPT] =3D "getsockopt",
-	[BPF_CGROUP_SETSOCKOPT] =3D "setsockopt",
-	[__MAX_BPF_ATTACH_TYPE] =3D NULL,
-};
-
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
 	enum bpf_attach_type type;
=20
 	for (type =3D 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		if (attach_type_strings[type] &&
-		    is_prefix(str, attach_type_strings[type]))
+		if (attach_type_name[type] &&
+		    is_prefix(str, attach_type_name[type]))
 			return type;
 	}
=20
@@ -171,7 +149,7 @@ static int show_attached_bpf_progs(int cgroup_fd, enu=
m bpf_attach_type type,
 	}
=20
 	for (iter =3D 0; iter < prog_cnt; iter++)
-		show_bpf_prog(prog_ids[iter], attach_type_strings[type],
+		show_bpf_prog(prog_ids[iter], attach_type_name[type],
 			      attach_flags_str, level);
=20
 	return 0;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 86f14ce26fd7..dd212d2af923 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -83,6 +83,38 @@ static const char * const prog_type_name[] =3D {
 	[BPF_PROG_TYPE_EXT]			=3D "ext",
 };
=20
+static const char * const attach_type_name[] =3D {
+	[BPF_CGROUP_INET_INGRESS] =3D "ingress",
+	[BPF_CGROUP_INET_EGRESS] =3D "egress",
+	[BPF_CGROUP_INET_SOCK_CREATE] =3D "sock_create",
+	[BPF_CGROUP_SOCK_OPS] =3D "sock_ops",
+	[BPF_CGROUP_DEVICE] =3D "device",
+	[BPF_CGROUP_INET4_BIND] =3D "bind4",
+	[BPF_CGROUP_INET6_BIND] =3D "bind6",
+	[BPF_CGROUP_INET4_CONNECT] =3D "connect4",
+	[BPF_CGROUP_INET6_CONNECT] =3D "connect6",
+	[BPF_CGROUP_INET4_POST_BIND] =3D "post_bind4",
+	[BPF_CGROUP_INET6_POST_BIND] =3D "post_bind6",
+	[BPF_CGROUP_UDP4_SENDMSG] =3D "sendmsg4",
+	[BPF_CGROUP_UDP6_SENDMSG] =3D "sendmsg6",
+	[BPF_CGROUP_SYSCTL] =3D "sysctl",
+	[BPF_CGROUP_UDP4_RECVMSG] =3D "recvmsg4",
+	[BPF_CGROUP_UDP6_RECVMSG] =3D "recvmsg6",
+	[BPF_CGROUP_GETSOCKOPT] =3D "getsockopt",
+	[BPF_CGROUP_SETSOCKOPT] =3D "setsockopt",
+
+	[BPF_SK_SKB_STREAM_PARSER] =3D "sk_skb_stream_parser",
+	[BPF_SK_SKB_STREAM_VERDICT] =3D "sk_skb_stream_verdict",
+	[BPF_SK_MSG_VERDICT] =3D "sk_msg_verdict",
+	[BPF_LIRC_MODE2] =3D "lirc_mode2",
+	[BPF_FLOW_DISSECTOR] =3D "flow_dissector",
+	[BPF_TRACE_RAW_TP] =3D "raw_tp",
+	[BPF_TRACE_FENTRY] =3D "fentry",
+	[BPF_TRACE_FEXIT] =3D "fexit",
+	[BPF_MODIFY_RETURN] =3D "mod_ret",
+	[BPF_LSM_MAC] =3D "lsm_mac",
+};
+
 extern const char * const map_type_name[];
 extern const size_t map_type_name_size;
=20
--=20
2.24.1

