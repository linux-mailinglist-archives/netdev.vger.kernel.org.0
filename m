Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDB18426C
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfHGCZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:25:22 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42040 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfHGCZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:25:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so42549937pff.9
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jWe1p0HpQ2w993QCWM/s9R+wL7e57Rsvp2r+FY9yLeY=;
        b=YjccSq4YTb2Sqt33RuGHNYV3XcAKlwwzKKfizxUsLAU38+WNWH6GhS5bnKMbRqfpqo
         UamOjDfF5SbzHoBKO9CRBARDK8BJ+li7QwSkjv+N0r7Ow5w9T25mEhvSWjC09bRu1JyS
         858prLHEKLyO/bDNu5dOttjwlsoQo4YZsScrG2jbhgxEiJ8nnbGaSFuZuiV3KYGdJ2Vs
         6aOvNVcTPKzTkT5K1yiaXD/B1jsktZu/h6K8qXzP7EQ3Hi08PoBIkuyO8p3f9LFAPuPk
         n4uP2eCp4p3YHq0beCbBQANn0+ZWUHyPovJi1GG/ZwgNLTDgR3OceVTsJ9/cBRPGnm/I
         D+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWe1p0HpQ2w993QCWM/s9R+wL7e57Rsvp2r+FY9yLeY=;
        b=gCk0YlojatmWNYuLvcYfUgYGJ5xWBWoB7KXVKJuU5ARydjfg9Cd8FyTAXsjijJ3bQP
         bhsTt+7uABBRNW0NTNOD0d/puPeXi+r0soRpBWYjZuUnJBhWTjV56rtwII0jYLBriYop
         g1ULKlPhj/9NuBDpVUYNJTRVDDAoeKh2Tzd2p3rSMZ86WjY1n9JYdN5tYJ7DIXRCQCtt
         xtI1SmzkTPzwbAd98eNOAg3tS+UbNTvAmlP+bFAn6YxIsatMg8roEUa8rdFEtbE/MOi8
         Ram18+H1K8qMFsXO0pC9852PJWNrTIpiALyfqwyNX6CI2n/2oWJZP7lucWiQremJPYq2
         8QpQ==
X-Gm-Message-State: APjAAAUay9vn569P0lDrYl7pjo02nn7Rb/cDmACMIl/TpLHOaOHni7HM
        7PWN1/T9tBePeoOPfI4aKw==
X-Google-Smtp-Source: APXvYqzqFgGmVBRhA2uSd18MlcZT8te98InukKn2vWESII3qdS52pliC1vPuNaK7qL45o/O1NhLdGQ==
X-Received: by 2002:a65:528d:: with SMTP id y13mr5868584pgp.120.1565144720983;
        Tue, 06 Aug 2019 19:25:20 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id b126sm129275991pfa.126.2019.08.06.19.25.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 19:25:20 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v3,1/4] tools: bpftool: add net attach command to attach XDP on interface
Date:   Wed,  7 Aug 2019 11:25:06 +0900
Message-Id: <20190807022509.4214-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807022509.4214-1-danieltimlee@gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net attach`, user can attach XDP prog on
interface. New type of enum 'net_attach_type' has been made, as stated at
cover-letter, the meaning of 'attach' is, prog will be attached on interface.

With 'overwrite' option at argument, attached XDP program could be replaced.
Added new helper 'net_parse_dev' to parse the network device at argument.

BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 141 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..c05a3fac5cac 100644
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
+const size_t max_net_attach_type = ARRAY_SIZE(attach_type_strings);
+
+static enum net_attach_type parse_attach_type(const char *str)
+{
+	enum net_attach_type type;
+
+	for (type = 0; type < max_net_attach_type; type++) {
+		if (attach_type_strings[type] &&
+		   is_prefix(str, attach_type_strings[type]))
+			return type;
+	}
+
+	return max_net_attach_type;
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
+	if (attach_type == max_net_attach_type) {
+		p_err("invalid net attach/detach type");
+		return -EINVAL;
+	}
+
+	NEXT_ARG();
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
+		p_err("interface %s attach failed",
+		      attach_type_strings[attach_type]);
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
@@ -231,17 +351,10 @@ static int do_show(int argc, char **argv)
 	unsigned int nl_pid;
 	char err_buf[256];
 
-	if (argc == 2) {
-		if (strcmp(argv[0], "dev") != 0)
-			usage();
-		filter_idx = if_nametoindex(argv[1]);
-		if (filter_idx == 0) {
-			fprintf(stderr, "invalid dev name %s\n", argv[1]);
-			return -1;
-		}
-	} else if (argc != 0) {
+	if (argc == 2)
+		filter_idx = net_parse_dev(&argc, &argv);
+	else if (argc != 0)
 		usage();
-	}
 
 	ret = query_flow_dissector(&attach_info);
 	if (ret)
@@ -305,13 +418,18 @@ static int do_help(int argc, char **argv)
 
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
@@ -319,6 +437,7 @@ static int do_help(int argc, char **argv)
 static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
+	{ "attach",	do_attach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

