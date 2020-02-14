Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D2415ED31
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389718AbgBNRci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390495AbgBNQGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7B724650;
        Fri, 14 Feb 2020 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696403;
        bh=MMvYnTh/h4R2QL5OTCI5uAa2vYTgJROedZx4TjC11Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7lBbrHgGflIcezvfwpNwrOVNbtc//f/VQziEQo5xxKJ7+CuhcvRlUsKRB4iHCjAA
         gNcGnKbjv6UzvN6GR1IJzBc3VMiG5QUFpN2TerKuHR4TAsF6yV+11N7Ngm/Fl68H8o
         1RpkoE4bYQ+Lt2nO4oifn8SPiaItyLB5cCHFeRx4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hechao Li <hechaol@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 227/459] bpf: Print error message for bpftool cgroup show
Date:   Fri, 14 Feb 2020 10:57:57 -0500
Message-Id: <20200214160149.11681-227-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hechao Li <hechaol@fb.com>

[ Upstream commit 1162f844030ac1ac7321b5e8f6c9badc7a11428f ]

Currently, when bpftool cgroup show <path> has an error, no error
message is printed. This is confusing because the user may think the
result is empty.

Before the change:

$ bpftool cgroup show /sys/fs/cgroup
ID       AttachType      AttachFlags     Name
$ echo $?
255

After the change:
$ ./bpftool cgroup show /sys/fs/cgroup
Error: can't query bpf programs attached to /sys/fs/cgroup: Operation
not permitted

v2: Rename check_query_cgroup_progs to cgroup_has_attached_progs

Signed-off-by: Hechao Li <hechaol@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191224011742.3714301-1-hechaol@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 56 ++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 1ef45e55039e1..2f017caa678dc 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -117,6 +117,25 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	return prog_cnt;
 }
 
+static int cgroup_has_attached_progs(int cgroup_fd)
+{
+	enum bpf_attach_type type;
+	bool no_prog = true;
+
+	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
+		int count = count_attached_bpf_progs(cgroup_fd, type);
+
+		if (count < 0 && errno != EINVAL)
+			return -1;
+
+		if (count > 0) {
+			no_prog = false;
+			break;
+		}
+	}
+
+	return no_prog ? 0 : 1;
+}
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
@@ -161,6 +180,7 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
+	int has_attached_progs;
 	const char *path;
 	int cgroup_fd;
 	int ret = -1;
@@ -192,6 +212,16 @@ static int do_show(int argc, char **argv)
 		goto exit;
 	}
 
+	has_attached_progs = cgroup_has_attached_progs(cgroup_fd);
+	if (has_attached_progs < 0) {
+		p_err("can't query bpf programs attached to %s: %s",
+		      path, strerror(errno));
+		goto exit_cgroup;
+	} else if (!has_attached_progs) {
+		ret = 0;
+		goto exit_cgroup;
+	}
+
 	if (json_output)
 		jsonw_start_array(json_wtr);
 	else
@@ -212,6 +242,7 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+exit_cgroup:
 	close(cgroup_fd);
 exit:
 	return ret;
@@ -228,7 +259,7 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 			   int typeflag, struct FTW *ftw)
 {
 	enum bpf_attach_type type;
-	bool skip = true;
+	int has_attached_progs;
 	int cgroup_fd;
 
 	if (typeflag != FTW_D)
@@ -240,22 +271,13 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		return SHOW_TREE_FN_ERR;
 	}
 
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		int count = count_attached_bpf_progs(cgroup_fd, type);
-
-		if (count < 0 && errno != EINVAL) {
-			p_err("can't query bpf programs attached to %s: %s",
-			      fpath, strerror(errno));
-			close(cgroup_fd);
-			return SHOW_TREE_FN_ERR;
-		}
-		if (count > 0) {
-			skip = false;
-			break;
-		}
-	}
-
-	if (skip) {
+	has_attached_progs = cgroup_has_attached_progs(cgroup_fd);
+	if (has_attached_progs < 0) {
+		p_err("can't query bpf programs attached to %s: %s",
+		      fpath, strerror(errno));
+		close(cgroup_fd);
+		return SHOW_TREE_FN_ERR;
+	} else if (!has_attached_progs) {
 		close(cgroup_fd);
 		return 0;
 	}
-- 
2.20.1

