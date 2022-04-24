Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F6650CFC5
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 07:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiDXFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 01:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbiDXFNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 01:13:55 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35FE5F96;
        Sat, 23 Apr 2022 22:10:49 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id A6871C01A; Sun, 24 Apr 2022 07:10:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777048; bh=CStdIA73LibAElNfhkI3XlBob8QVrmyzne2SWxpRvv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pdq0kV5cghzVIWCiiJL8t25DcJflly+3Ev32VcptGtkHgpaUI2Y+0YUuu/9jlD8xA
         /fC3/kWuc4Q/wrXui1Xo6/emOXSSOzW8jGSP7siqh6XPoHIX8HM1e/weKgXGs8jtM0
         EbgsaP4hTKP3SxXXv5ywrtxIscbjJ+tVRIRJ89UOZ5HYJMyxRVs1SBmf5uIuCCTgfl
         BgFQfYVhlGFKAKDApohmDTsC3hNjItTqwcjjM4yTgxmCtT1GRswuUF4uFoNgXVLVIT
         x+3wV7C+bdQfBiDobSNJX1NW+0wfPgKH6MGff21k8CPue1UgbrxZYep84bJPzt8SWe
         8KQ5cDmWrgLCw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 65E7CC01B;
        Sun, 24 Apr 2022 07:10:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777047; bh=CStdIA73LibAElNfhkI3XlBob8QVrmyzne2SWxpRvv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUX94Y9hKyJ+Z1JQlZq122jwh7L8oU6s7ReVpBZ3OInyWt9FpGiClIS2yRF+qVKtz
         /6lS9GnoW1e9MxSOj2BAullP38sKZ2tbpcf8Eg9XLE7cHPkj9ivLUXPMqGKprPMdc1
         k13pqpVggksFKXZD5gBlBhuF9rkbMuxDW9pbfczsvriCFWq4MPIqbAJ+qqiD3oc6g7
         avfTfl8Q/ei40yYb8tKtM5lPK8YH3BJOrTBvd0+2bLObkvawCMQPhvtHBefZJkMD0N
         f2GAGF1BmHT1P+0chHugqjnLb89lkfh/rWn6vGdF3fH1GICvvYac1rRdQzWeKCla+B
         N8HISy+HqOoqA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1de1c1c9;
        Sun, 24 Apr 2022 05:10:26 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 3/4] tools/bpf: musl compat: replace nftw with FTW_ACTIONRETVAL
Date:   Sun, 24 Apr 2022 14:10:21 +0900
Message-Id: <20220424051022.2619648-4-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220424051022.2619648-1-asmadeus@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

musl nftw implementation does not support FTW_ACTIONRETVAL.

There have been multiple attempts at pushing the feature in musl
upstream but it has been refused or ignored all the times:
https://www.openwall.com/lists/musl/2021/03/26/1
https://www.openwall.com/lists/musl/2022/01/22/1

In this case we only care about /proc/<pid>/fd/<fd>, so it's not
too difficult to reimplement directly instead, and the new
implementation makes 'bpftool perf' slightly faster because it doesn't
needlessly stat/readdir unneeded directories (54ms -> 13ms on my machine)

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---

Alternatively alpine has one package where they reimplemented nftw with
FTW_ACTIONRETVAL support locally, so if reaaallly needed we could do the
same here.. But honestly doing two readdirs is probably just as simple
for this particular case.

 tools/bpf/bpftool/perf.c | 116 ++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 57 deletions(-)

diff --git a/tools/bpf/bpftool/perf.c b/tools/bpf/bpftool/perf.c
index 50de087b0db7..de793872544e 100644
--- a/tools/bpf/bpftool/perf.c
+++ b/tools/bpf/bpftool/perf.c
@@ -11,7 +11,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
-#include <ftw.h>
+#include <dirent.h>
 
 #include <bpf/bpf.h>
 
@@ -147,81 +147,83 @@ static void print_perf_plain(int pid, int fd, __u32 prog_id, __u32 fd_type,
 	}
 }
 
-static int show_proc(const char *fpath, const struct stat *sb,
-		     int tflag, struct FTW *ftwbuf)
+static int show_proc(void)
 {
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
-	int err, pid = 0, fd = 0;
+	int err, pid, fd;
+	DIR *proc, *pid_fd;
+	struct dirent *proc_de, *pid_fd_de;
 	const char *pch;
 	char buf[4096];
 
-	/* prefix always /proc */
-	pch = fpath + 5;
-	if (*pch == '\0')
-		return 0;
+	proc = opendir("/proc");
+	if (!proc)
+		return -1;
+	while ((proc_de = readdir(proc))) {
+		pid = 0;
+		pch = proc_de->d_name;
 
-	/* pid should be all numbers */
-	pch++;
-	while (isdigit(*pch)) {
-		pid = pid * 10 + *pch - '0';
-		pch++;
+		/* pid should be all numbers */
+		while (isdigit(*pch)) {
+			pid = pid * 10 + *pch - '0';
+			pch++;
+		}
+		if (*pch != '\0')
+			continue;
+
+		err = snprintf(buf, sizeof(buf), "/proc/%s/fd", proc_de->d_name);
+		if (err < 0 || err >= (int)sizeof(buf))
+			continue;
+
+		pid_fd = opendir(buf);
+		if (!pid_fd)
+			continue;
+
+		while ((pid_fd_de = readdir(pid_fd))) {
+			fd = 0;
+			pch = pid_fd_de->d_name;
+
+			/* fd should be all numbers */
+			while (isdigit(*pch)) {
+				fd = fd * 10 + *pch - '0';
+				pch++;
+			}
+			if (*pch != '\0')
+				continue;
+
+			/* query (pid, fd) for potential perf events */
+			len = sizeof(buf);
+			err = bpf_task_fd_query(pid, fd, 0, buf, &len, &prog_id, &fd_type,
+						&probe_offset, &probe_addr);
+			if (err < 0)
+				continue;
+
+			if (json_output)
+				print_perf_json(pid, fd, prog_id, fd_type, buf, probe_offset,
+						probe_addr);
+			else
+				print_perf_plain(pid, fd, prog_id, fd_type, buf, probe_offset,
+						 probe_addr);
+		}
+		closedir(pid_fd);
 	}
-	if (*pch == '\0')
-		return 0;
-	if (*pch != '/')
-		return FTW_SKIP_SUBTREE;
-
-	/* check /proc/<pid>/fd directory */
-	pch++;
-	if (strncmp(pch, "fd", 2))
-		return FTW_SKIP_SUBTREE;
-	pch += 2;
-	if (*pch == '\0')
-		return 0;
-	if (*pch != '/')
-		return FTW_SKIP_SUBTREE;
-
-	/* check /proc/<pid>/fd/<fd_num> */
-	pch++;
-	while (isdigit(*pch)) {
-		fd = fd * 10 + *pch - '0';
-		pch++;
-	}
-	if (*pch != '\0')
-		return FTW_SKIP_SUBTREE;
-
-	/* query (pid, fd) for potential perf events */
-	len = sizeof(buf);
-	err = bpf_task_fd_query(pid, fd, 0, buf, &len, &prog_id, &fd_type,
-				&probe_offset, &probe_addr);
-	if (err < 0)
-		return 0;
-
-	if (json_output)
-		print_perf_json(pid, fd, prog_id, fd_type, buf, probe_offset,
-				probe_addr);
-	else
-		print_perf_plain(pid, fd, prog_id, fd_type, buf, probe_offset,
-				 probe_addr);
-
+	closedir(proc);
 	return 0;
 }
 
 static int do_show(int argc, char **argv)
 {
-	int flags = FTW_ACTIONRETVAL | FTW_PHYS;
-	int err = 0, nopenfd = 16;
+	int err;
 
 	if (!has_perf_query_support())
 		return -1;
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
-	if (nftw("/proc", show_proc, nopenfd, flags) == -1) {
-		p_err("%s", strerror(errno));
-		err = -1;
-	}
+
+	err = show_proc();
+
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-- 
2.35.1

