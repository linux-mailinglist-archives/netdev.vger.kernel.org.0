Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2859234B05
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbgGaS2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:28:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25884 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387680AbgGaS2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:28:46 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VIEuSU011634
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RbqjZz1RbiD1vk1eFaYRuMWQv+nRg8Nl+ovezWuEEe0=;
 b=SUDG22wUDGeWWFkLsDcR4ETh2PHKoeaXzlDqL8Ew/qQpSIkLgAnWYs4SLh1FvsC7JExn
 Hyw02MGw/p7APQPieDPAA31wJzl/4p+Ryq4d71e/Iiiuzt6Gg40nzdgwm4rAtTrGi84F
 OjiQsHEHG8q5Gou82hRhFi+KyCz8BghsorM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32m8dybyj8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:45 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 11:28:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AE2A82EC4E02; Fri, 31 Jul 2020 11:28:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/5] tools/bpftool: add `link detach` subcommand
Date:   Fri, 31 Jul 2020 11:28:29 -0700
Message-ID: <20200731182830.286260-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200731182830.286260-1-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=857 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=8 spamscore=0 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to force-detach BPF link. Also add missing error message, if
specified link ID is wrong.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/link.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 326b8fdf0243..1b793759170e 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -22,6 +22,8 @@ static const char * const link_type_name[] =3D {
=20
 static int link_parse_fd(int *argc, char ***argv)
 {
+	int fd;
+
 	if (is_prefix(**argv, "id")) {
 		unsigned int id;
 		char *endptr;
@@ -35,7 +37,10 @@ static int link_parse_fd(int *argc, char ***argv)
 		}
 		NEXT_ARGP();
=20
-		return bpf_link_get_fd_by_id(id);
+		fd =3D bpf_link_get_fd_by_id(id);
+		if (fd < 0)
+			p_err("failed to get link with ID %d: %s", id, strerror(errno));
+		return fd;
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
=20
@@ -316,6 +321,34 @@ static int do_pin(int argc, char **argv)
 	return err;
 }
=20
+static int do_detach(int argc, char **argv)
+{
+	int err, fd;
+
+	if (argc !=3D 2) {
+		p_err("link specifier is invalid or missing\n");
+		return 1;
+	}
+
+	fd =3D link_parse_fd(&argc, &argv);
+	if (fd < 0)
+		return 1;
+
+	err =3D bpf_link_detach(fd);
+	if (err)
+		err =3D -errno;
+	close(fd);
+	if (err) {
+		p_err("failed link detach: %s", strerror(-err));
+		return 1;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -326,6 +359,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s { show | list }   [LINK]\n"
 		"       %1$s %2$s pin        LINK  FILE\n"
+		"       %1$s %2$s detach     LINK\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_LINK "\n"
@@ -341,6 +375,7 @@ static const struct cmd cmds[] =3D {
 	{ "list",	do_show },
 	{ "help",	do_help },
 	{ "pin",	do_pin },
+	{ "detach",	do_detach },
 	{ 0 }
 };
=20
--=20
2.24.1

