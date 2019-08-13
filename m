Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A688ACD3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfHMCqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:46:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37083 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMCqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:46:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so1630952plb.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sguX+7vjIkiuti5RfiXOePVZArwxphK85KfR5a1bh+8=;
        b=Ed1O6Zo23N06/5v3p52l6xReLUSDJa5xjKXd/UlkbALa9zZv0v7aEIVNGwSUd2OlDG
         E0x9EpRYeAbxVnLNqim6N6qBU4W658OdN1cS8oIYB/Jy/C6ez7YA14Pqd0mCRaZVQNUI
         FRNWHJezOZAbGDLGaeagaUIsOzcXBq7+oTfjsJBRnH0dtTCM6SxdwqGbVHboNtn9rdlu
         EpV+nb2QbjlgDgBxEyPpWpLj2OBbxoFAlNGSGIvNHJP5xme7JJXEGNWNaQ7hKG2h29sv
         k82EBMjr6fC7yTG22OkK8fyF0Z8FFd57NEEL8kbpx+Za0thEbhAsYGhp8H0+Zgl9ZY4X
         vpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sguX+7vjIkiuti5RfiXOePVZArwxphK85KfR5a1bh+8=;
        b=sSedxxVQNHC115Mb/zgC0tDxCOyZpJHSEI40pfDBWSDsTZ+CEkfTyACX5PFXVonm7m
         sw+JCtfhrFbWZiyQDqyWs0yoCnj1yRdItvBNjgNbpbb6K1jIL/RMQuzwpfVeyh1ZByQX
         QGFI4qe4Thuf9E6ySijIHVtC9IYj2lE+irn8dsVz+KUaJeLeufRKx/jmMfOJTDYAmqa5
         CAr85D6ZPc+k6uybGNvxL4ZB9EO0lMW74EjWEz7NqWI84dHbJebMnLn8pAdwZIo2FsLY
         sGpRxr2UUecJA7C04Cqt9cgZZe0lQD6rMk+S7ll8rIGF5fxKHk/8gitZwYDy+KL0gF7V
         qFmQ==
X-Gm-Message-State: APjAAAVfwRNb8qpD5XpjdV79cC6sjzy3GJKGrVTzX4T6CLN6NYxbStbS
        6DOcvZx9cYWsTcE4qMQsdqo8gVgshTry
X-Google-Smtp-Source: APXvYqxm6omNjTKyWNM/ClZeHn8asKAYd8XZE5v9PBP3NIAZgbfDbeVOwuH1Xl4VfuZsyz7YpYAsEQ==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr36222804ple.192.1565664391136;
        Mon, 12 Aug 2019 19:46:31 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h17sm6359826pfo.24.2019.08.12.19.46.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 19:46:30 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Yonghong Song <yhs@fb.com>
Subject: [v5,1/4] tools: bpftool: add net attach command to attach XDP on interface
Date:   Tue, 13 Aug 2019 11:46:18 +0900
Message-Id: <20190813024621.29886-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813024621.29886-1-danieltimlee@gmail.com>
References: <20190813024621.29886-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net attach`, user can attach XDP prog on
interface. New type of enum 'net_attach_type' has been made, as stat ted at
cover-letter, the meaning of 'attach' is, prog will be attached on interface.

With 'overwrite' option at argument, attached XDP program could be replaced.
Added new helper 'net_parse_dev' to parse the network device at argument.

BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 136 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 129 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..33222ca1060e 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -55,6 +55,35 @@ struct bpf_attach_info {
 	__u32 flow_dissector_id;
 };
 
+enum net_attach_type {
+	NET_ATTACH_TYPE_XDP,
+	NET_ATTACH_TYPE_XDP_GENERIC,
+	NET_ATTACH_TYPE_XDP_DRIVER,
+	NET_ATTACH_TYPE_XDP_OFFLOAD,
+};
+
+static const char * const attach_type_strings[] = {
+	[NET_ATTACH_TYPE_XDP]		= "xdp",
+	[NET_ATTACH_TYPE_XDP_GENERIC]	= "xdpgeneric",
+	[NET_ATTACH_TYPE_XDP_DRIVER]	= "xdpdrv",
+	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
+};
+
+const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
+
+static enum net_attach_type parse_attach_type(const char *str)
+{
+	enum net_attach_type type;
+
+	for (type = 0; type < net_attach_type_size; type++) {
+		if (attach_type_strings[type] &&
+		    is_prefix(str, attach_type_strings[type]))
+			return type;
+	}
+
+	return net_attach_type_size;
+}
+
 static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_netdev_t *netinfo = cookie;
@@ -223,6 +252,97 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
 	return 0;
 }
 
+static int net_parse_dev(int *argc, char ***argv)
+{
+	int ifindex;
+
+	if (is_prefix(**argv, "dev")) {
+		NEXT_ARGP();
+
+		ifindex = if_nametoindex(**argv);
+		if (!ifindex)
+			p_err("invalid devname %s", **argv);
+
+		NEXT_ARGP();
+	} else {
+		p_err("expected 'dev', got: '%s'?", **argv);
+		return -1;
+	}
+
+	return ifindex;
+}
+
+static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
+				int ifindex, bool overwrite)
+{
+	__u32 flags = 0;
+
+	if (!overwrite)
+		flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
+		flags |= XDP_FLAGS_SKB_MODE;
+	if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
+		flags |= XDP_FLAGS_DRV_MODE;
+	if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
+		flags |= XDP_FLAGS_HW_MODE;
+
+	return bpf_set_link_xdp_fd(ifindex, progfd, flags);
+}
+
+static int do_attach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int progfd, ifindex, err = 0;
+	bool overwrite = false;
+
+	/* parse attach args */
+	if (!REQ_ARGS(5))
+		return -EINVAL;
+
+	attach_type = parse_attach_type(*argv);
+	if (attach_type == net_attach_type_size) {
+		p_err("invalid net attach/detach type: %s", *argv);
+		return -EINVAL;
+	}
+	NEXT_ARG();
+
+	progfd = prog_parse_fd(&argc, &argv);
+	if (progfd < 0)
+		return -EINVAL;
+
+	ifindex = net_parse_dev(&argc, &argv);
+	if (ifindex < 1) {
+		close(progfd);
+		return -EINVAL;
+	}
+
+	if (argc) {
+		if (is_prefix(*argv, "overwrite")) {
+			overwrite = true;
+		} else {
+			p_err("expected 'overwrite', got: '%s'?", *argv);
+			close(progfd);
+			return -EINVAL;
+		}
+	}
+
+	/* attach xdp prog */
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(progfd, attach_type, ifindex,
+					   overwrite);
+
+	if (err < 0) {
+		p_err("interface %s attach failed: %s",
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
@@ -232,13 +352,9 @@ static int do_show(int argc, char **argv)
 	char err_buf[256];
 
 	if (argc == 2) {
-		if (strcmp(argv[0], "dev") != 0)
-			usage();
-		filter_idx = if_nametoindex(argv[1]);
-		if (filter_idx == 0) {
-			fprintf(stderr, "invalid dev name %s\n", argv[1]);
+		filter_idx = net_parse_dev(&argc, &argv);
+		if (filter_idx < 1)
 			return -1;
-		}
 	} else if (argc != 0) {
 		usage();
 	}
@@ -305,13 +421,18 @@ static int do_help(int argc, char **argv)
 
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
+		"       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
 		"       %s %s help\n"
+		"\n"
+		"       " HELP_SPEC_PROGRAM "\n"
+		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
+		"\n"
 		"Note: Only xdp and tc attachments are supported now.\n"
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
 
 	return 0;
 }
@@ -319,6 +440,7 @@ static int do_help(int argc, char **argv)
 static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
+	{ "attach",	do_attach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

