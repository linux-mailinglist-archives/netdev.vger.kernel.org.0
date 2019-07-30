Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8557B293
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbfG3Ssd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:48:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37904 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388035AbfG3Ssc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:48:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id az7so29225553plb.5
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0lPmfXsxS4tY6xbEsjc/X9PBFBzjPSDj4azoSddf84=;
        b=c+gjYxgA2VayOMx4rGYb2BIhs/Gwx+JDfMPxnyWTy7zsbhNumXiTyvP6e1uNraVDxM
         Hi41z1LPDNHUQfGJuT/ja3PXdZ35jywOjPePsGdjHqUl2FZeF3O9XXKZjlHZhJRLIHuG
         zlNJb8lANCT302Y7vnAvkE4HVbjBLJLolU/W6GdUyQoRPgHadesJj5zY9+SI7WIJD9oV
         kIHMxHQKFyXIfsuIpONk0f814a87QvU3UqhtQtzU9n9GH3TYBHym9Zr4rAKF5jLreNB3
         zM0R7HprlQSS94R8ycZ/6iNtKed9djyxEYO448Xqp5FRpMZNocihUtVAUJ7jsKK1nuMR
         uhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0lPmfXsxS4tY6xbEsjc/X9PBFBzjPSDj4azoSddf84=;
        b=rFbR7qHFengavJoS9rseBRmB8qJQ8xG/SN0wSHsoI0jhRmh+fJ1ElHmv6MJA47OjvO
         PBduBLr8XaBixQt8/W0mxHLpKTeKwcGCaLhO59/qkp415YkycjxSUlZypgyYtmYzdTT/
         0+kO3OSD452PthnIwaXehDBUturfRHC9hAsscIdr5gpqciLizutX8wJVYmT0BOJWKnwA
         nMNx62RAzEU1z/1pz15YxFR+jGP9JKCDceEQhQEvnaSHw0g8pjF94mFa0vMix+0E8nu+
         mlxQDRny/wFMWPeC1uLhLqjdvT5Ia30XnykKHKLiP+Cr/A9Ump8uatQFw8bzVyRfshEj
         i5ng==
X-Gm-Message-State: APjAAAXUsLA7hlawnfY9d5Veld0VMEply8bCUv6VfNudjpi+QsScog0D
        OpsV/ouXpwtHc3dxY1uWVQ==
X-Google-Smtp-Source: APXvYqxTCm053bLIWy9yxDjRxCNikqxXKwpDN4bXqcbvrgYScQv2i9qJD1RIYXtQ/iYuz6ewHlcccQ==
X-Received: by 2002:a17:902:aa41:: with SMTP id c1mr115747987plr.201.1564512511860;
        Tue, 30 Jul 2019 11:48:31 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id 143sm102878183pgc.6.2019.07.30.11.48.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 11:48:31 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 1/2] tools: bpftool: add net load command to load XDP on interface
Date:   Wed, 31 Jul 2019 03:48:20 +0900
Message-Id: <20190730184821.10833-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190730184821.10833-1-danieltimlee@gmail.com>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net load`, user can load XDP prog on
interface. New type of enum 'net_load_type' has been made, as stated at
cover-letter, the meaning of 'load' is, prog will be loaded on interface.

BPF prog will be loaded through libbpf 'bpf_set_link_xdp_fd'.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..d3a4f18b5b95 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -55,6 +55,35 @@ struct bpf_attach_info {
 	__u32 flow_dissector_id;
 };
 
+enum net_load_type {
+	NET_LOAD_TYPE_XDP,
+	NET_LOAD_TYPE_XDP_GENERIC,
+	NET_LOAD_TYPE_XDP_DRIVE,
+	NET_LOAD_TYPE_XDP_OFFLOAD,
+	__MAX_NET_LOAD_TYPE
+};
+
+static const char * const load_type_strings[] = {
+	[NET_LOAD_TYPE_XDP] = "xdp",
+	[NET_LOAD_TYPE_XDP_GENERIC] = "xdpgeneric",
+	[NET_LOAD_TYPE_XDP_DRIVE] = "xdpdrv",
+	[NET_LOAD_TYPE_XDP_OFFLOAD] = "xdpoffload",
+	[__MAX_NET_LOAD_TYPE] = NULL,
+};
+
+static enum net_load_type parse_load_type(const char *str)
+{
+	enum net_load_type type;
+
+	for (type = 0; type < __MAX_NET_LOAD_TYPE; type++) {
+		if (load_type_strings[type] &&
+		   is_prefix(str, load_type_strings[type]))
+			return type;
+	}
+
+	return __MAX_NET_LOAD_TYPE;
+}
+
 static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_netdev_t *netinfo = cookie;
@@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
 	return 0;
 }
 
+static int parse_load_args(int argc, char **argv, int *progfd,
+			   enum net_load_type *load_type, int *ifindex)
+{
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	*progfd = prog_parse_fd(&argc, &argv);
+	if (*progfd < 0)
+		return *progfd;
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
+static int do_load_unload_xdp(int *progfd, enum net_load_type *load_type,
+			      int *ifindex)
+{
+	__u32 flags;
+	int err;
+
+	flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	if (*load_type == NET_LOAD_TYPE_XDP_GENERIC)
+		flags |= XDP_FLAGS_SKB_MODE;
+	if (*load_type == NET_LOAD_TYPE_XDP_DRIVE)
+		flags |= XDP_FLAGS_DRV_MODE;
+	if (*load_type == NET_LOAD_TYPE_XDP_OFFLOAD)
+		flags |= XDP_FLAGS_HW_MODE;
+
+	err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
+
+	return err;
+}
+
+static int do_load(int argc, char **argv)
+{
+	enum net_load_type load_type;
+	int err, progfd, ifindex;
+
+	err = parse_load_args(argc, argv, &progfd, &load_type, &ifindex);
+	if (err)
+		return err;
+
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
@@ -305,13 +405,17 @@ static int do_help(int argc, char **argv)
 
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
+		"       %s %s load PROG LOAD_TYPE <devname>\n"
 		"       %s %s help\n"
+		"\n"
+		"       " HELP_SPEC_PROGRAM "\n"
+		"       LOAD_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
 		"Note: Only xdp and tc attachments are supported now.\n"
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
 
 	return 0;
 }
@@ -319,6 +423,7 @@ static int do_help(int argc, char **argv)
 static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
+	{ "load",	do_load },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

