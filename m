Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B4287B2D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407060AbfHINdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:33:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38931 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406635AbfHINdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:33:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so42086692pfn.6
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OO4p1d39Y56rdVl98OosyKAH2e2H1rEPVwNZg6V+xd4=;
        b=XvMQ4yAxh5mP2/c/dJ9aEEhNA9PFosgx+OmuDKea7J6HrNG4cAlqQjaTWx0M3b9UCd
         BBMBuRC5XkI+yAZeaVujQDYjXM9A620Q2Yz1pTimDUdAPOcA1vQlGQoeSHjG0ME9+nm+
         EEw9q29XD0zCHZjzZIqwCq5aV9AFYspWXEng1+jiN9X9XKWNo6ruQHyqWC8RwM9FGU98
         ipxT5QkNFmmpaCZ825xa8K2gR7EnseBuZojFEbaFg5S2CCvNcayX3Y0PbL8gguQBcWXV
         +MWySsG81ygab3gkGawge1S2KMItM8yyErwZe1hcpCnvmK97MAzy1hURIUXNDACHn5Fl
         OMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OO4p1d39Y56rdVl98OosyKAH2e2H1rEPVwNZg6V+xd4=;
        b=lK7GmsktzZdlfSOfbocihaZiny+fXDaE4b3nSVNXhcikJ1jqyo9Wzsk1tg0bvLxaYB
         kzKmXjB9pElGFm5YgZJJBtybS2OmrRMkLJRQWA20s2VYR4ESqW3uCpNGS890utapc9Wr
         so2UhHGIOFvUlCWBw4uS95nkrvmfEMO1CnTRme8HtZVS2vjR+q7GVnDNSDy4uRQ0CsQl
         dR/AIDTxxGwJWMjZY657KjWTu8MlPiq5fcNKE/3cd9uRcChxp3WrfwhvmwOT0D913e2d
         h4XRqneZwFUohPlYTF6za0K8mSZ41migUwDuwTNsMzpZ+HsX8/uJCgqsyrvm7Ivifr9v
         s39g==
X-Gm-Message-State: APjAAAVyJ4tWxz2TD8eWUFONKafk45sO/3EKXE73D6etf8QUipG+BOEt
        pTFWQU9pAotaykDEOpOBVLcgJSV3QR1k
X-Google-Smtp-Source: APXvYqzaxjLgRwfdYrZ+DqTlr40KwK4aTyCFk0JHpC0aFZnii5alA1jT84fLPjhE+Dgj3kCpihhOFA==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr21316715pfi.154.1565357587049;
        Fri, 09 Aug 2019 06:33:07 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f15sm7242912pje.17.2019.08.09.06.33.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:33:04 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v4,1/4] tools: bpftool: add net attach command to attach XDP on interface
Date:   Fri,  9 Aug 2019 22:32:45 +0900
Message-Id: <20190809133248.19788-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133248.19788-1-danieltimlee@gmail.com>
References: <20190809133248.19788-1-danieltimlee@gmail.com>
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
 tools/bpf/bpftool/net.c | 136 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 129 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..74cc346c36cd 100644
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
+		      attach_type_strings[attach_type], strerror(errno));
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

