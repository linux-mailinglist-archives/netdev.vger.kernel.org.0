Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6815822D2B0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgGYAEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:04:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727935AbgGYAEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:49 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONlaFI032723
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pVPR7Cu3xYhrx38YFyxPm1H8m1+ErWwPVI25d5Vz8oY=;
 b=I+Af238NfBVhqzHLNWrjxtCMctDQst4/SfN2LzEi8cQNFVZScqmfxsS4jDWsI9piuTr6
 FAtyPrMJdaaFZDZtDhvEIhs7PYoGR3xy5JrcORHfGSir7WeQxDaQVoEzI92LY407alXF
 eRYZvUdTgKf5TNcV5dPhrpE830Xixs2ATzc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etmwm9es-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:48 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:43 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 4949B1B35AA8; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 30/35] bpf: bpftool: do not touch RLIMIT_MEMLOCK
Date:   Fri, 24 Jul 2020 17:04:05 -0700
Message-ID: <20200725000410.3566700-31-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=13 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bpf stopped using memlock rlimit to limit the memory usage,
there is no more reason for bpftool to alter its own limits.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/bpf/bpftool/common.c     | 7 -------
 tools/bpf/bpftool/feature.c    | 2 --
 tools/bpf/bpftool/main.h       | 2 --
 tools/bpf/bpftool/map.c        | 2 --
 tools/bpf/bpftool/pids.c       | 1 -
 tools/bpf/bpftool/prog.c       | 3 ---
 tools/bpf/bpftool/struct_ops.c | 2 --
 7 files changed, 19 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 65303664417e..01b87e8c3040 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -109,13 +109,6 @@ static bool is_bpffs(char *path)
 	return (unsigned long)st_fs.f_type =3D=3D BPF_FS_MAGIC;
 }
=20
-void set_max_rlimit(void)
-{
-	struct rlimit rinf =3D { RLIM_INFINITY, RLIM_INFINITY };
-
-	setrlimit(RLIMIT_MEMLOCK, &rinf);
-}
-
 static int
 mnt_fs(const char *target, const char *type, char *buff, size_t bufflen)
 {
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 1cd75807673e..2d6c6bff934e 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -885,8 +885,6 @@ static int do_probe(int argc, char **argv)
 	__u32 ifindex =3D 0;
 	char *ifname;
=20
-	set_max_rlimit();
-
 	while (argc) {
 		if (is_prefix(*argv, "kernel")) {
 			if (target !=3D COMPONENT_UNSPEC) {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index e3a79b5a9960..0a3bd1ff14da 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -95,8 +95,6 @@ int detect_common_prefix(const char *arg, ...);
 void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
 void usage(void) __noreturn;
=20
-void set_max_rlimit(void);
-
 int mount_tracefs(const char *target);
=20
 struct pinned_obj_table {
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 3a27d31a1856..f08b9e707511 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1315,8 +1315,6 @@ static int do_create(int argc, char **argv)
 		return -1;
 	}
=20
-	set_max_rlimit();
-
 	fd =3D bpf_create_map_xattr(&attr);
 	if (fd < 0) {
 		p_err("map create failed: %s", strerror(errno));
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index e3b116325403..4c559a8ae4e8 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -96,7 +96,6 @@ int build_obj_refs_table(struct obj_refs_table *table, =
enum bpf_obj_type type)
 	libbpf_print_fn_t default_print;
=20
 	hash_init(table->table);
-	set_max_rlimit();
=20
 	skel =3D pid_iter_bpf__open();
 	if (!skel) {
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 3e6ecc6332e2..40e50db60332 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1291,8 +1291,6 @@ static int load_with_options(int argc, char **argv,=
 bool first_prog_only)
 		}
 	}
=20
-	set_max_rlimit();
-
 	obj =3D bpf_object__open_file(file, &open_opts);
 	if (IS_ERR_OR_NULL(obj)) {
 		p_err("failed to open object file");
@@ -1833,7 +1831,6 @@ static int do_profile(int argc, char **argv)
 		}
 	}
=20
-	set_max_rlimit();
 	err =3D profiler_bpf__load(profile_obj);
 	if (err) {
 		p_err("failed to load profile_obj");
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_op=
s.c
index b58b91f62ffb..0915e1e9b7c0 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -498,8 +498,6 @@ static int do_register(int argc, char **argv)
 	if (IS_ERR_OR_NULL(obj))
 		return -1;
=20
-	set_max_rlimit();
-
 	load_attr.obj =3D obj;
 	if (verifier_logs)
 		/* log_level1 + log_level2 + stats, but not stable UAPI */
--=20
2.26.2

