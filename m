Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB6FF1FA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfKPPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbfKPPrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:03 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8392208C0;
        Sat, 16 Nov 2019 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919222;
        bh=kpwFn9Sc0MqKe83RqXYHAMb6fci+1VqMYohUynAsflo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a29uFegIVK4un+F882O4vXwR1DsN6Z6JqKYw2CHrj6n1ycMY3npVDTzYYhRnKDIil
         fRvaqCTE2YN6N8SnPBTXpJ+ocd7oeVb8iOKsLNTSWy2SFMj0ieLDsBzYdc8YER+1Zi
         U11Xc/9Ly4nELU6xyj0aveASfQOynZqSzcBMBjaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 225/237] tools: bpftool: pass an argument to silence open_obj_pinned()
Date:   Sat, 16 Nov 2019 10:41:00 -0500
Message-Id: <20191116154113.7417-225-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Monnet <quentin.monnet@netronome.com>

[ Upstream commit f120919f9905a2cad9dea792a28a11fb623f72c1 ]

Function open_obj_pinned() prints error messages when it fails to open a
link in the BPF virtual file system. However, in some occasions it is
not desirable to print an error, for example when we parse all links
under the bpffs root, and the error is due to some paths actually being
symbolic links.

Example output:

    # ls -l /sys/fs/bpf/
    lrwxrwxrwx 1 root root 0 Oct 18 19:00 ip -> /sys/fs/bpf/tc/
    drwx------ 3 root root 0 Oct 18 19:00 tc
    lrwxrwxrwx 1 root root 0 Oct 18 19:00 xdp -> /sys/fs/bpf/tc/

    # bpftool --bpffs prog show
    Error: bpf obj get (/sys/fs/bpf): Permission denied
    Error: bpf obj get (/sys/fs/bpf): Permission denied

    # strace -e bpf bpftool --bpffs prog show
    bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/ip", bpf_fd=0}, 72) = -1 EACCES (Permission denied)
    Error: bpf obj get (/sys/fs/bpf): Permission denied
    bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/xdp", bpf_fd=0}, 72) = -1 EACCES (Permission denied)
    Error: bpf obj get (/sys/fs/bpf): Permission denied
    ...

To fix it, pass a bool as a second argument to the function, and prevent
it from printing an error when the argument is set to true.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 15 ++++++++-------
 tools/bpf/bpftool/main.h   |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index be7aebff0c1e5..158469f57461d 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -130,16 +130,17 @@ static int mnt_bpffs(const char *target, char *buff, size_t bufflen)
 	return 0;
 }
 
-int open_obj_pinned(char *path)
+int open_obj_pinned(char *path, bool quiet)
 {
 	int fd;
 
 	fd = bpf_obj_get(path);
 	if (fd < 0) {
-		p_err("bpf obj get (%s): %s", path,
-		      errno == EACCES && !is_bpffs(dirname(path)) ?
-		    "directory not in bpf file system (bpffs)" :
-		    strerror(errno));
+		if (!quiet)
+			p_err("bpf obj get (%s): %s", path,
+			      errno == EACCES && !is_bpffs(dirname(path)) ?
+			    "directory not in bpf file system (bpffs)" :
+			    strerror(errno));
 		return -1;
 	}
 
@@ -151,7 +152,7 @@ int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type)
 	enum bpf_obj_type type;
 	int fd;
 
-	fd = open_obj_pinned(path);
+	fd = open_obj_pinned(path, false);
 	if (fd < 0)
 		return -1;
 
@@ -384,7 +385,7 @@ int build_pinned_obj_table(struct pinned_obj_table *tab,
 		while ((ftse = fts_read(fts))) {
 			if (!(ftse->fts_info & FTS_F))
 				continue;
-			fd = open_obj_pinned(ftse->fts_path);
+			fd = open_obj_pinned(ftse->fts_path, true);
 			if (fd < 0)
 				continue;
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 238e734d75b3e..057a227bdb9f9 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -126,7 +126,7 @@ int cmd_select(const struct cmd *cmds, int argc, char **argv,
 int get_fd_type(int fd);
 const char *get_fd_type_name(enum bpf_obj_type type);
 char *get_fdinfo(int fd, const char *key);
-int open_obj_pinned(char *path);
+int open_obj_pinned(char *path, bool quiet);
 int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type);
 int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32));
 int do_pin_fd(int fd, const char *name);
-- 
2.20.1

