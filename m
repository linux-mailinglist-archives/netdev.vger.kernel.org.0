Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA961765C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 06:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiKCFxU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Nov 2022 01:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKCFxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 01:53:17 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4C7192A9
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 22:53:16 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A2NVtrp010932
        for <netdev@vger.kernel.org>; Wed, 2 Nov 2022 22:53:16 -0700
Received: from maileast.thefacebook.com ([163.114.130.8])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkhkvttfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 22:53:15 -0700
Received: from twshared17038.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 22:53:14 -0700
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id D7A032102ECDA; Wed,  2 Nov 2022 22:53:11 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 03/10] selftests/bpf: consolidate and improve file/prog filtering in veristat
Date:   Wed, 2 Nov 2022 22:52:57 -0700
Message-ID: <20221103055304.2904589-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103055304.2904589-1-andrii@kernel.org>
References: <20221103055304.2904589-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: GKAa9pR-rN3r_YstkUE0TYEO5GAg_WQm
X-Proofpoint-ORIG-GUID: GKAa9pR-rN3r_YstkUE0TYEO5GAg_WQm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-02_15,2022-11-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slightly change rules of specifying file/prog glob filters. In practice
it's quite often inconvenient to do `*/<prog-glob>` if that program glob
is unique enough and won't accidentally match any file names.

This patch changes the rules so that `-f <glob>` will apply specified
glob to both file and program names. User still has all the control by
doing '*/<prog-only-glob>' or '<file-only-glob/*'. We also now allow
'/<prog-glob>' and '<file-glob/' (all matching wildcard is assumed if
missing).

Also, internally unify file-only and file+prog checks
(should_process_file and should_process_prog are now
should_process_file_prog that can handle prog name as optional). This
makes maintaining and extending this code easier.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 127 +++++++++++++------------
 1 file changed, 65 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index d553f38a6cee..f6f6a2490489 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -55,6 +55,7 @@ enum resfmt {
 };
 
 struct filter {
+	char *any_glob;
 	char *file_glob;
 	char *prog_glob;
 };
@@ -231,28 +232,6 @@ static bool glob_matches(const char *str, const char *pat)
 	return !*str && !*pat;
 }
 
-static bool should_process_file(const char *filename)
-{
-	int i;
-
-	if (env.deny_filter_cnt > 0) {
-		for (i = 0; i < env.deny_filter_cnt; i++) {
-			if (glob_matches(filename, env.deny_filters[i].file_glob))
-				return false;
-		}
-	}
-
-	if (env.allow_filter_cnt == 0)
-		return true;
-
-	for (i = 0; i < env.allow_filter_cnt; i++) {
-		if (glob_matches(filename, env.allow_filters[i].file_glob))
-			return true;
-	}
-
-	return false;
-}
-
 static bool is_bpf_obj_file(const char *path) {
 	Elf64_Ehdr *ehdr;
 	int fd, err = -EINVAL;
@@ -285,38 +264,46 @@ static bool is_bpf_obj_file(const char *path) {
 	return err == 0;
 }
 
-static bool should_process_prog(const char *path, const char *prog_name)
+static bool should_process_file_prog(const char *filename, const char *prog_name)
 {
-	const char *filename = basename(path);
-	int i;
+	struct filter *f;
+	int i, allow_cnt = 0;
 
-	if (env.deny_filter_cnt > 0) {
-		for (i = 0; i < env.deny_filter_cnt; i++) {
-			if (glob_matches(filename, env.deny_filters[i].file_glob))
-				return false;
-			if (!env.deny_filters[i].prog_glob)
-				continue;
-			if (glob_matches(prog_name, env.deny_filters[i].prog_glob))
-				return false;
-		}
-	}
+	for (i = 0; i < env.deny_filter_cnt; i++) {
+		f = &env.deny_filters[i];
 
-	if (env.allow_filter_cnt == 0)
-		return true;
+		if (f->any_glob && glob_matches(filename, f->any_glob))
+			return false;
+		if (f->any_glob && prog_name && glob_matches(prog_name, f->any_glob))
+			return false;
+		if (f->file_glob && glob_matches(filename, f->file_glob))
+			return false;
+		if (f->prog_glob && prog_name && glob_matches(prog_name, f->prog_glob))
+			return false;
+	}
 
 	for (i = 0; i < env.allow_filter_cnt; i++) {
-		if (!glob_matches(filename, env.allow_filters[i].file_glob))
-			continue;
-		/* if filter specifies only filename glob part, it implicitly
-		 * allows all progs within that file
-		 */
-		if (!env.allow_filters[i].prog_glob)
-			return true;
-		if (glob_matches(prog_name, env.allow_filters[i].prog_glob))
+		f = &env.allow_filters[i];
+		allow_cnt++;
+
+		if (f->any_glob) {
+			if (glob_matches(filename, f->any_glob))
+				return true;
+			if (prog_name && glob_matches(prog_name, f->any_glob))
+				return true;
+		} else {
+			if (f->file_glob && !glob_matches(filename, f->file_glob))
+				continue;
+			if (f->prog_glob && prog_name && !glob_matches(prog_name, f->prog_glob))
+				continue;
 			return true;
+		}
 	}
 
-	return false;
+	/* if there are no file/prog name allow filters, allow all progs,
+	 * unless they are denied earlier explicitly
+	 */
+	return allow_cnt == 0;
 }
 
 static int append_filter(struct filter **filters, int *cnt, const char *str)
@@ -331,26 +318,40 @@ static int append_filter(struct filter **filters, int *cnt, const char *str)
 	*filters = tmp;
 
 	f = &(*filters)[*cnt];
-	f->file_glob = f->prog_glob = NULL;
-
-	/* filter can be specified either as "<obj-glob>" or "<obj-glob>/<prog-glob>" */
+	memset(f, 0, sizeof(*f));
+
+	/* File/prog filter can be specified either as '<glob>' or
+	 * '<file-glob>/<prog-glob>'. In the former case <glob> is applied to
+	 * both file and program names. This seems to be way more useful in
+	 * practice. If user needs full control, they can use '/<prog-glob>'
+	 * form to glob just program name, or '<file-glob>/' to glob only file
+	 * name. But usually common <glob> seems to be the most useful and
+	 * ergonomic way.
+	 */
 	p = strchr(str, '/');
 	if (!p) {
-		f->file_glob = strdup(str);
-		if (!f->file_glob)
+		f->any_glob = strdup(str);
+		if (!f->any_glob)
 			return -ENOMEM;
 	} else {
-		f->file_glob = strndup(str, p - str);
-		f->prog_glob = strdup(p + 1);
-		if (!f->file_glob || !f->prog_glob) {
-			free(f->file_glob);
-			free(f->prog_glob);
-			f->file_glob = f->prog_glob = NULL;
-			return -ENOMEM;
+		if (str != p) {
+			/* non-empty file glob */
+			f->file_glob = strndup(str, p - str);
+			if (!f->file_glob)
+				return -ENOMEM;
+		}
+		if (strlen(p + 1) > 0) {
+			/* non-empty prog glob */
+			f->prog_glob = strdup(p + 1);
+			if (!f->prog_glob) {
+				free(f->file_glob);
+				f->file_glob = NULL;
+				return -ENOMEM;
+			}
 		}
 	}
 
-	*cnt = *cnt + 1;
+	*cnt += 1;
 	return 0;
 }
 
@@ -546,7 +547,7 @@ static int process_prog(const char *filename, struct bpf_object *obj, struct bpf
 	int err = 0;
 	void *tmp;
 
-	if (!should_process_prog(filename, bpf_program__name(prog))) {
+	if (!should_process_file_prog(basename(filename), bpf_program__name(prog))) {
 		env.progs_skipped++;
 		return 0;
 	}
@@ -602,7 +603,7 @@ static int process_obj(const char *filename)
 	LIBBPF_OPTS(bpf_object_open_opts, opts);
 	int err = 0, prog_cnt = 0;
 
-	if (!should_process_file(basename(filename))) {
+	if (!should_process_file_prog(basename(filename), NULL)) {
 		if (env.verbose)
 			printf("Skipping '%s' due to filters...\n", filename);
 		env.files_skipped++;
@@ -980,7 +981,7 @@ static int parse_stats_csv(const char *filename, struct stat_specs *specs,
 		 * parsed entire line; if row should be ignored we pretend we
 		 * never parsed it
 		 */
-		if (!should_process_prog(st->file_name, st->prog_name)) {
+		if (!should_process_file_prog(st->file_name, st->prog_name)) {
 			free(st->file_name);
 			free(st->prog_name);
 			*stat_cntp -= 1;
@@ -1391,11 +1392,13 @@ int main(int argc, char **argv)
 		free(env.filenames[i]);
 	free(env.filenames);
 	for (i = 0; i < env.allow_filter_cnt; i++) {
+		free(env.allow_filters[i].any_glob);
 		free(env.allow_filters[i].file_glob);
 		free(env.allow_filters[i].prog_glob);
 	}
 	free(env.allow_filters);
 	for (i = 0; i < env.deny_filter_cnt; i++) {
+		free(env.deny_filters[i].any_glob);
 		free(env.deny_filters[i].file_glob);
 		free(env.deny_filters[i].prog_glob);
 	}
-- 
2.30.2

