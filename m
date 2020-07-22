Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FCD229133
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 08:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgGVGq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 02:46:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30580 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730346AbgGVGq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 02:46:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06M6fDT4005865
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8G5ZzRIh4TIY1Klkng0c1LlD0FKQ6B+G9c8Z4IzrSE0=;
 b=ogTivmLgXWvuSJ6Z1qvt8jDUpuM1eqM9+aLCrzveHuzUbWgjBrBpgV+NBLQNAoMj5z0x
 8LXgsmCz2VqsUj03BKodWLyw1ZLzJZncYLpB4mIHuuR0PytPcnJogBEyCX7jGVtJPWSg
 YeDHpMWyFdhuovBE4/1se2H0dLtg3a4h/no= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32bxu0qh11-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 23:46:24 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 23:46:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id F37842EC494E; Tue, 21 Jul 2020 23:46:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 7/9] libbpf: add support for BPF XDP link
Date:   Tue, 21 Jul 2020 23:46:00 -0700
Message-ID: <20200722064603.3350758-8-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
References: <20200722064603.3350758-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_03:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 phishscore=0 adultscore=0 suspectscore=8 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync UAPI header and add support for using bpf_link-based XDP attachment.
Make xdp/ prog type set expected attach type. Kernel didn't enforce
attach_type for XDP programs before, so there is no backwards compatiblit=
y
issues there.

Also fix section_names selftest to recognize that xdp prog types now have
expected attach type.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h                         | 10 +++++++++-
 tools/lib/bpf/libbpf.c                                 |  9 ++++++++-
 tools/lib/bpf/libbpf.h                                 |  2 ++
 tools/lib/bpf/libbpf.map                               |  1 +
 tools/testing/selftests/bpf/prog_tests/section_names.c |  2 +-
 5 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 54d0c886e3ba..27bd1c8b0041 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -230,6 +230,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET_SOCK_RELEASE,
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
+	BPF_XDP,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
@@ -242,6 +243,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_CGROUP =3D 3,
 	BPF_LINK_TYPE_ITER =3D 4,
 	BPF_LINK_TYPE_NETNS =3D 5,
+	BPF_LINK_TYPE_XDP =3D 6,
=20
 	MAX_BPF_LINK_TYPE,
 };
@@ -607,7 +609,10 @@ union bpf_attr {
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
@@ -4057,6 +4062,9 @@ struct bpf_link_info {
 			__u32 netns_ino;
 			__u32 attach_type;
 		} netns;
+		struct {
+			__u32 ifindex;
+		} xdp;
 	};
 } __attribute__((aligned(8)));
=20
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 846164c79df1..ce41ddec6229 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6915,7 +6915,8 @@ static const struct bpf_sec_def section_defs[] =3D =
{
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_CPUMAP),
-	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
+	BPF_EAPROG_SEC("xdp",			BPF_PROG_TYPE_XDP,
+						BPF_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
 	BPF_PROG_SEC("lwt_out",			BPF_PROG_TYPE_LWT_OUT),
@@ -8278,6 +8279,12 @@ bpf_program__attach_netns(struct bpf_program *prog=
, int netns_fd)
 	return bpf_program__attach_fd(prog, netns_fd, "netns");
 }
=20
+struct bpf_link *bpf_program__attach_xdp(struct bpf_program *prog, int i=
findex)
+{
+	/* target_fd/target_ifindex use the same field in LINK_CREATE */
+	return bpf_program__attach_fd(prog, ifindex, "xdp");
+}
+
 struct bpf_link *
 bpf_program__attach_iter(struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c2272132e929..daf33b79f760 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -257,6 +257,8 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_xdp(struct bpf_program *prog, int ifindex);
=20
 struct bpf_map;
=20
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 6f0856abe299..ca49a6a7e5b2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -286,6 +286,7 @@ LIBBPF_0.1.0 {
 		bpf_map__set_value_size;
 		bpf_map__type;
 		bpf_map__value_size;
+		bpf_program__attach_xdp;
 		bpf_program__autoload;
 		bpf_program__is_sk_lookup;
 		bpf_program__set_autoload;
diff --git a/tools/testing/selftests/bpf/prog_tests/section_names.c b/too=
ls/testing/selftests/bpf/prog_tests/section_names.c
index 713167449c98..8b571890c57e 100644
--- a/tools/testing/selftests/bpf/prog_tests/section_names.c
+++ b/tools/testing/selftests/bpf/prog_tests/section_names.c
@@ -35,7 +35,7 @@ static struct sec_name_test tests[] =3D {
 		{-EINVAL, 0},
 	},
 	{"raw_tp/", {0, BPF_PROG_TYPE_RAW_TRACEPOINT, 0}, {-EINVAL, 0} },
-	{"xdp", {0, BPF_PROG_TYPE_XDP, 0}, {-EINVAL, 0} },
+	{"xdp", {0, BPF_PROG_TYPE_XDP, BPF_XDP}, {0, BPF_XDP} },
 	{"perf_event", {0, BPF_PROG_TYPE_PERF_EVENT, 0}, {-EINVAL, 0} },
 	{"lwt_in", {0, BPF_PROG_TYPE_LWT_IN, 0}, {-EINVAL, 0} },
 	{"lwt_out", {0, BPF_PROG_TYPE_LWT_OUT, 0}, {-EINVAL, 0} },
--=20
2.24.1

