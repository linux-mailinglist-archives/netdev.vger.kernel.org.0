Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE432327D6
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgG2XFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:05:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1500 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbgG2XFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:05:37 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06TMvg5Z019029
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hW2GsZhaVnFLAMaOZu51zc1X8BWjOVBr9L5q1fDjBhs=;
 b=JlLHyzrpH+FdwlRUgh540U7SNBOSsmsm7+Aj89ZMgAzTf7XBWq0QxnobARBWcqYsW0yK
 Zs64ImtyD5djMtb0NQzz2LoyKvumNkMlpq0yhz6o5gDQ+lfMhFhMdwq1uRY2HfLgdwSR
 DSx9y2Ky7ej29j3zAHArXZGKvrApkjjfD1c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32ggdmvdqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:36 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:05:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 727D42EC4E37; Wed, 29 Jul 2020 16:05:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/5] tools/bpftool: add `link detach` subcommand
Date:   Wed, 29 Jul 2020 16:05:19 -0700
Message-ID: <20200729230520.693207-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200729230520.693207-1-andriin@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_17:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=835
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 suspectscore=8
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to force-detach BPF link. Also add missing error message, if
specified link ID is wrong.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/link.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 326b8fdf0243..278befa34ed6 100644
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
+			p_err("failed to get link with ID %d: %d", id, -errno);
+		return fd;
 	} else if (is_prefix(**argv, "pinned")) {
 		char *path;
=20
@@ -316,6 +321,32 @@ static int do_pin(int argc, char **argv)
 	return err;
 }
=20
+static int do_detach(int argc, char **argv)
+{
+	int err, fd;
+
+	if (argc !=3D 2)
+		return BAD_ARG();
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
+		p_err("failed link detach: %d", err);
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
@@ -326,6 +357,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s { show | list }   [LINK]\n"
 		"       %1$s %2$s pin        LINK  FILE\n"
+		"       %1$s %2$s detach     LINK\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_LINK "\n"
@@ -341,6 +373,7 @@ static const struct cmd cmds[] =3D {
 	{ "list",	do_show },
 	{ "help",	do_help },
 	{ "pin",	do_pin },
+	{ "detach",	do_detach },
 	{ 0 }
 };
=20
--=20
2.24.1

