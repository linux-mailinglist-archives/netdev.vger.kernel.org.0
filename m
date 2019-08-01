Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585197D6FF
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 10:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfHAILo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 04:11:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41877 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbfHAILn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 04:11:43 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so23372644pgg.8
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vEtmXeighSIVM7ic4S/tG/PqsVIb5LKbs2vS934whlk=;
        b=T2ioY61qnRM7UWbjNKIaZc5rbJsDvFJG0zk6LpJeEV4HfrgD6E7GoPcpYlpx/WpEF3
         wpR4UKvtLsU1I5gejwdHwJeoH4isrk4LYJ+TT7/DyLB79KN7b0W3g4ciBWOt6Qup8BWx
         RLq8rwdZDWxdt3xXat3XQPlLaU8Q/bdFJt2c4lJnUhdLj9kWNc1TyBTTrfV5lGchuUFN
         LgiFKcKZWLPGgkJRuFlCewz9ILR16q05WpzZv2wo5DMvYtW3P4G3HFnBA9J4k2AZmyl0
         Q+bmfTqaGocgAIAvCHm8O3IHUIG3YMQNBWuVCZq/tDwnR7WMNImGet8twvs36T5He9zT
         CzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEtmXeighSIVM7ic4S/tG/PqsVIb5LKbs2vS934whlk=;
        b=UpvRJarNEPeZxW3E91gocQFNR1ySDpfMKRVJTVJAq9HRbFmNmFzqkvmOfxkm+YoFSn
         HAcErqy/fzs7blj/UFmg2DutC2QOcmmy1N6u05nAEg8MCaXezZx1LwvyAoJ0L29lFlMB
         7ZTSG7XkS1aRjv8kvDUoWoi/OCAdMcQ9uTi1xVRFLeQ23VX95ZvgKNG1fMRccogqleIn
         lXCYaGS7IdHR0jKnkTqCZQOvm1MoelmNMqzb026SfChiE6opA8iMypy9jrblFt9RqAl1
         yK1uYB1i2zSBGsU0nOz+qW1ouuBvLNKetXhuXcPWeZYrPlg962vgm86W8DCwck4DkuJv
         1I3Q==
X-Gm-Message-State: APjAAAWrRyMxGrsgWkbTUMzMN0oE6d3KRSN8EL/3jOp9ZDxqdEQjohjP
        KICJA6JhR0VBuIo2AJhlKg==
X-Google-Smtp-Source: APXvYqwKyNPohaM1Egm8wuyHPQxm0JzlTCn3uOVpfsb1PYRfJBDZGWfWKmgq47juJoV+ZBpz6VDTug==
X-Received: by 2002:aa7:90d8:: with SMTP id k24mr51526471pfk.115.1564647102766;
        Thu, 01 Aug 2019 01:11:42 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id br18sm3917286pjb.20.2019.08.01.01.11.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 01:11:42 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v2,1/2] tools: bpftool: add net attach command to attach XDP on interface
Date:   Thu,  1 Aug 2019 17:11:32 +0900
Message-Id: <20190801081133.13200-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801081133.13200-1-danieltimlee@gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net attach`, user can attach XDP prog on
interface. New type of enum 'net_attach_type' has been made, as stated at
cover-letter, the meaning of 'attach' is, prog will be attached on interface.

BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes in v2:
  - command 'load' changed to 'attach' for the consistency
  - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'

 tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..f3b57660b303 100644
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
+	__MAX_NET_ATTACH_TYPE
+};
+
+static const char * const attach_type_strings[] = {
+	[NET_ATTACH_TYPE_XDP] = "xdp",
+	[NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
+	[NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
+	[NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
+	[__MAX_NET_ATTACH_TYPE] = NULL,
+};
+
+static enum net_attach_type parse_attach_type(const char *str)
+{
+	enum net_attach_type type;
+
+	for (type = 0; type < __MAX_NET_ATTACH_TYPE; type++) {
+		if (attach_type_strings[type] &&
+		   is_prefix(str, attach_type_strings[type]))
+			return type;
+	}
+
+	return __MAX_NET_ATTACH_TYPE;
+}
+
 static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_netdev_t *netinfo = cookie;
@@ -223,6 +252,77 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
 	return 0;
 }
 
+static int parse_attach_args(int argc, char **argv, int *progfd,
+			     enum net_attach_type *attach_type, int *ifindex)
+{
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	*progfd = prog_parse_fd(&argc, &argv);
+	if (*progfd < 0)
+		return *progfd;
+
+	*attach_type = parse_attach_type(*argv);
+	if (*attach_type == __MAX_NET_ATTACH_TYPE) {
+		p_err("invalid net attach/detach type");
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
+static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
+				int *ifindex)
+{
+	__u32 flags;
+	int err;
+
+	flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
+		flags |= XDP_FLAGS_SKB_MODE;
+	if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
+		flags |= XDP_FLAGS_DRV_MODE;
+	if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
+		flags |= XDP_FLAGS_HW_MODE;
+
+	err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
+
+	return err;
+}
+
+static int do_attach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int err, progfd, ifindex;
+
+	err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
+	if (err)
+		return err;
+
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
+
+	if (err < 0) {
+		p_err("link set %s failed", attach_type_strings[attach_type]);
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
+		"       %s %s attach PROG LOAD_TYPE <devname>\n"
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
+	{ "attach",	do_attach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

