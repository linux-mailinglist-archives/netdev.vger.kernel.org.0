Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF908ACD4
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfHMCqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:46:34 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37084 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMCqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:46:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so1630989plb.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Y3vntHotgac/YS9Lrfj+Qk3fz9SFxcSxpdCKbtrNU4=;
        b=Ew6Acd3YUc0kIrs1nm+6fzNx55O23ezLxU6dkoZlCCG5x3NQmZwEkXaP/omdTTNmSq
         qHaf4W7zoHZgnvFOrj4lvXtUaXzRDbpbqyRs8618mIhVvzuk3CTYGxq2VjhFLTL7ECxk
         jGr6V6nI0aWXMmmdMgl7U0LL/fs5YCTAbv0YNlWkS2yg5YVshkwrPukh+UfhoaxEKHlZ
         /1LWpzVdWd0p9lcyKsgPWz1a5z5xjG+FM/ZliGAqwalLmorwfp6dwPyqjfqQFr6pKsYc
         t3x06zULcNXt3dvh/vE7VeNSNYj54VPcmLemdlstXtJ8vUHyvHA/cM0w7XL5d8f20LA9
         kUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Y3vntHotgac/YS9Lrfj+Qk3fz9SFxcSxpdCKbtrNU4=;
        b=bXdxtUeJPdD9KkdERvzVGEP7Aq4+fnKmMDq//1ScRNO7JBsNAq3Z9ZFxGsr62IZJn+
         YRoIaUJ98qzYz8AzuVobO5uMIb2f8Ax726jjX8Xs1MefmZ2KSXg11Lyb5D9qdN4qHQbc
         D/OGvCwZkwbg57X9ez0Q0y58YtUO/oUt7BmTuUgj9t8VL4TB8JJdJvKP3tPPUJLzjzlJ
         nQ7rk3/nOLoXP/iCYZK2EJKPC8C2zrTG4XOtByZYdfJ+lmtKePtvGJyRKtFVLRFYxhy8
         GEBvzVFAewBMnM6GyeEqPZBkARQvk16yzgH8w4iJFo0tPjAj5wFZhJ65e4WD8mEAqoYH
         4enw==
X-Gm-Message-State: APjAAAU67d22r9bISEGEU21qL0XFglEp6mk1CZjDg7fC2+2iStk0ZS5F
        PnjKoZ0RJlWKKPCIXT/bog==
X-Google-Smtp-Source: APXvYqzDs6f1moNnLluUoFIu2ygDbc7o9QPj3nRKE4CstMS4LzwpuvsL0CmT1JAEhqiU29BdhYyq2g==
X-Received: by 2002:a17:902:7d82:: with SMTP id a2mr5202146plm.57.1565664393343;
        Mon, 12 Aug 2019 19:46:33 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h17sm6359826pfo.24.2019.08.12.19.46.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 19:46:32 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Yonghong Song <yhs@fb.com>
Subject: [v5,2/4] tools: bpftool: add net detach command to detach XDP on interface
Date:   Tue, 13 Aug 2019 11:46:19 +0900
Message-Id: <20190813024621.29886-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813024621.29886-1-danieltimlee@gmail.com>
References: <20190813024621.29886-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net detach`, the attached XDP prog can
be detached. Detaching the BPF prog will be done through libbpf
'bpf_set_link_xdp_fd' with the progfd set to -1.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 33222ca1060e..a213a9b7f69c 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
 	return 0;
 }
 
+static int do_detach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int progfd, ifindex, err = 0;
+
+	/* parse detach args */
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	attach_type = parse_attach_type(*argv);
+	if (attach_type == net_attach_type_size) {
+		p_err("invalid net attach/detach type: %s", *argv);
+		return -EINVAL;
+	}
+	NEXT_ARG();
+
+	ifindex = net_parse_dev(&argc, &argv);
+	if (ifindex < 1)
+		return -EINVAL;
+
+	/* detach xdp prog */
+	progfd = -1;
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
+
+	if (err < 0) {
+		p_err("interface %s detach failed: %s",
+		      attach_type_strings[attach_type], strerror(-err));
+		return err;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
 static int do_show(int argc, char **argv)
 {
 	struct bpf_attach_info attach_info = {};
@@ -422,6 +459,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
 		"       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
+		"       %s %s detach ATTACH_TYPE dev <devname>\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -432,7 +470,8 @@ static int do_help(int argc, char **argv)
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -441,6 +480,7 @@ static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
 	{ "attach",	do_attach },
+	{ "detach",	do_detach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

