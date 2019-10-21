Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2093DE29E
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfJUDjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4926 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727021AbfJUDjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:19 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L3P7je005278
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3AlcYDhKSlJzJACnynprN6D5nfhI9GTdS/lbQcdT/kY=;
 b=MNqeKg+t5eWebl/GaiStJweVlZqETX/sOOwp2JmACtwkkqevz30SqvA0zwUh74A1XHif
 K7AMp9ZUCNrfTs4ZAKXVSGaZBPbgCYt8VdeuWiC74m6nPIQ3suCiTQqPxqD3syoxhdjq
 8nf5rHjy109D6tOiJvaedvnaxXh1+1vYv+A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vr07pmv2h-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:18 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 20 Oct 2019 20:39:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 12B1B861976; Sun, 20 Oct 2019 20:39:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/7] libbpf: teach bpf_object__open to guess program types
Date:   Sun, 20 Oct 2019 20:38:59 -0700
Message-ID: <20191021033902.3856966-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
References: <20191021033902.3856966-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=25 phishscore=0
 mlxscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach bpf_object__open how to guess program type and expected attach
type from section names, similar to what bpf_prog_load() does. This
seems like a really useful features and an oversight to not have this
done during bpf_object_open(). To preserver backwards compatible
behavior of bpf_prog_load(), its attr->prog_type is treated as an
override of bpf_object__open() decisions, if attr->prog_type is not
UNSPECIFIED.

There is a slight difference in behavior for bpf_prog_load().
Previously, if bpf_prog_load() was loading BPF object with more than one
program, first program's guessed program type and expected attach type
would determine corresponding attributes of all the subsequent program
types, even if their sections names suggest otherwise. That seems like
a rather dubious behavior and with this change it will behave more
sanely: each program's type is determined individually, unless they are
forced to uniformity through attr->prog_type.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 65 +++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bf0c94fe74ca..51c867c85bf4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3616,6 +3616,7 @@ static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
 {
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	const char *obj_name;
 	char tmp_name[64];
@@ -3655,8 +3656,24 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	CHECK_ERR(bpf_object__probe_caps(obj), err, out);
 	CHECK_ERR(bpf_object__elf_collect(obj, relaxed_maps), err, out);
 	CHECK_ERR(bpf_object__collect_reloc(obj), err, out);
-
 	bpf_object__elf_finish(obj);
+
+	bpf_object__for_each_program(prog, obj) {
+		enum bpf_prog_type prog_type;
+		enum bpf_attach_type attach_type;
+
+		err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
+					       &attach_type);
+		if (err == -ESRCH)
+			/* couldn't guess, but user might manually specify */
+			continue;
+		if (err)
+			goto out;
+
+		bpf_program__set_type(prog, prog_type);
+		bpf_program__set_expected_attach_type(prog, attach_type);
+	}
+
 	return obj;
 out:
 	bpf_object__close(obj);
@@ -4696,7 +4713,7 @@ int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 		free(type_names);
 	}
 
-	return -EINVAL;
+	return -ESRCH;
 }
 
 int libbpf_attach_type_by_name(const char *name,
@@ -4726,15 +4743,6 @@ int libbpf_attach_type_by_name(const char *name,
 	return -EINVAL;
 }
 
-static int
-bpf_program__identify_section(struct bpf_program *prog,
-			      enum bpf_prog_type *prog_type,
-			      enum bpf_attach_type *expected_attach_type)
-{
-	return libbpf_prog_type_by_name(prog->section_name, prog_type,
-					expected_attach_type);
-}
-
 int bpf_map__fd(const struct bpf_map *map)
 {
 	return map ? map->fd : -EINVAL;
@@ -4902,8 +4910,6 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 {
 	struct bpf_object_open_attr open_attr = {};
 	struct bpf_program *prog, *first_prog = NULL;
-	enum bpf_attach_type expected_attach_type;
-	enum bpf_prog_type prog_type;
 	struct bpf_object *obj;
 	struct bpf_map *map;
 	int err;
@@ -4921,26 +4927,27 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 		return -ENOENT;
 
 	bpf_object__for_each_program(prog, obj) {
+		enum bpf_attach_type attach_type = attr->expected_attach_type;
 		/*
-		 * If type is not specified, try to guess it based on
-		 * section name.
+		 * to preserve backwards compatibility, bpf_prog_load treats
+		 * attr->prog_type, if specified, as an override to whatever
+		 * bpf_object__open guessed
 		 */
-		prog_type = attr->prog_type;
-		prog->prog_ifindex = attr->ifindex;
-		expected_attach_type = attr->expected_attach_type;
-		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
-			err = bpf_program__identify_section(prog, &prog_type,
-							    &expected_attach_type);
-			if (err < 0) {
-				bpf_object__close(obj);
-				return -EINVAL;
-			}
+		if (attr->prog_type != BPF_PROG_TYPE_UNSPEC) {
+			bpf_program__set_type(prog, attr->prog_type);
+			bpf_program__set_expected_attach_type(prog,
+							      attach_type);
+		}
+		if (bpf_program__get_type(prog) == BPF_PROG_TYPE_UNSPEC) {
+			/*
+			 * we haven't guessed from section name and user
+			 * didn't provide a fallback type, too bad...
+			 */
+			bpf_object__close(obj);
+			return -EINVAL;
 		}
 
-		bpf_program__set_type(prog, prog_type);
-		bpf_program__set_expected_attach_type(prog,
-						      expected_attach_type);
-
+		prog->prog_ifindex = attr->ifindex;
 		prog->log_level = attr->log_level;
 		prog->prog_flags = attr->prog_flags;
 		if (!first_prog)
-- 
2.17.1

