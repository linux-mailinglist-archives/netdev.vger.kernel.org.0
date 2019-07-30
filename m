Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED357B294
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388288AbfG3Ssf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:48:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42419 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387746AbfG3Sse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:48:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so30289818pff.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rVKMHJ626yUJPyeYSG07+3W2EM0mfMZDfApvCRsg+Js=;
        b=GIT7HHa4JZ9KrB1wsATpaS+WD2IQqW8Tv0BJXNfRFm9N9S+SmVirRe7K9ZlZYNadO4
         thb6ywluhUiFcKL/UFmoZhDGYIQjOzNnwdVZLgQUBqG7/8TTzD1EwnbtejFdXuaS5zoO
         JIEAzT7CuadzCUMT8xjlUhRkgC3yYyywDg/Y+z+cwC04/1GkoKmHm3+wky77yEuytOob
         9Xw4DYsirtMuRLk9f64dPoPzog1DlXbwqevqnIn+NwmwOv+7S6x2VE9ywEUoZgypSaiP
         QHmNxSsy1CwVba228mX6aTdSS6tnpCQPXoyOjso6RZxGY9DZAo0OJ5NP7tY15nXTtWyk
         S7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rVKMHJ626yUJPyeYSG07+3W2EM0mfMZDfApvCRsg+Js=;
        b=WT/nHnYSZF27Yk9Lhb5DAzvJOWJ9qk6qOewY+9DipN9ElNC3gUA8uJRuVhmhKB3jSu
         UpIb1qb9q3VoC/NtVf8xiE5PK23pLZlUPLOB53yVh10FdOu8wNueL64Z4xEqyH7LxNPH
         ujYX2EbizcIfiJc51SJScIe27CCXORp9JDjG1vxFt8T5dkR8m+6xC6KQoAVY5tMJ4W1b
         0BwR11cUvhxKRPUmeZdyIOrQBU9QDGwFhX88OuyHQZQF75r3qMNwZdpvceKjk0DiJK4K
         ysA70tUhd0AlamMCsmcmJMBsgg5WNioCWXiz4u/r2qPildLeKx9OoM8OET2nHgYcjqBk
         2cjQ==
X-Gm-Message-State: APjAAAVSD/Ng5FujzltxKtmbLHvscEmZmPt8nMYFqRisc8yl3vaxTTz4
        lxx/4BYifEQ0siOtMWQjyW4uJPk=
X-Google-Smtp-Source: APXvYqxkZHwawLRnM+vnaRBanp0j1HaeyN/X67+HwJnikCzdvqnv7plKmwOfJDftxXDZHM8yCem5VA==
X-Received: by 2002:a63:e20a:: with SMTP id q10mr108139253pgh.24.1564512513775;
        Tue, 30 Jul 2019 11:48:33 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id 143sm102878183pgc.6.2019.07.30.11.48.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 11:48:33 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 2/2] tools: bpftool: add net unload command to unload XDP on interface
Date:   Wed, 31 Jul 2019 03:48:21 +0900
Message-Id: <20190730184821.10833-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190730184821.10833-1-danieltimlee@gmail.com>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net unload`, the loaded XDP prog can
be unloaded. Unloading the BPF prog will be done through libbpf
'bpf_set_link_xdp_fd' with the progfd set to -1.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index d3a4f18b5b95..9d353b6e7d6d 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -281,6 +281,31 @@ static int parse_load_args(int argc, char **argv, int *progfd,
 	return 0;
 }
 
+static int parse_unload_args(int argc, char **argv,
+			     enum net_load_type *load_type, int *ifindex)
+{
+	if (!REQ_ARGS(2))
+		return -EINVAL;
+
+	*load_type = parse_load_type(*argv);
+	if (*load_type == __MAX_NET_LOAD_TYPE) {
+		p_err("invalid net load/unload type");
+		return -EINVAL;
+	}
+
+	NEXT_ARG();
+	if (!REQ_ARGS(1))
+		return -EINVAL;
+
+	*ifindex = if_nametoindex(*argv);
+	if (!*ifindex) {
+		p_err("Invalid ifname");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int do_load_unload_xdp(int *progfd, enum net_load_type *load_type,
 			      int *ifindex)
 {
@@ -323,6 +348,31 @@ static int do_load(int argc, char **argv)
 	return 0;
 }
 
+static int do_unload(int argc, char **argv)
+{
+	enum net_load_type load_type;
+	int err, progfd, ifindex;
+
+	err = parse_unload_args(argc, argv, &load_type, &ifindex);
+	if (err)
+		return err;
+
+	/* to unload xdp prog */
+	progfd = -1;
+	if (is_prefix("xdp", load_type_strings[load_type]))
+		err = do_load_unload_xdp(&progfd, &load_type, &ifindex);
+
+	if (err < 0) {
+		p_err("link set %s failed", load_type_strings[load_type]);
+		return -1;
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
@@ -406,6 +456,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
 		"       %s %s load PROG LOAD_TYPE <devname>\n"
+		"       %s %s unload LOAD_TYPE <devname>\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -415,7 +466,8 @@ static int do_help(int argc, char **argv)
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -424,6 +476,7 @@ static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
 	{ "load",	do_load },
+	{ "unload",	do_unload },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

