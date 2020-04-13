Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66321A6B42
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgDMRTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732668AbgDMRSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:40 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF5D20768;
        Mon, 13 Apr 2020 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798319;
        bh=MJepgGG7F9lzscMMv+O4dmFphkyBr0BMiKv3bqsKPLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=di7HlLIpcgtj28qTUU+NXlxbgSRFO/RxqSlJy/NTFu8zkaxAck2ElxXbnIJ3pQ253
         C1O1CY0tRKzW2ppFsL/N0YYolg1lB9pSyhzAWwPtUBmdfo4FxxvcS1R6HU1KkWSFPE
         wxOlYSiqYnheDxwbGafGL7Wjf3l7v4RWnE6GevEw=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC-v5 bpf-next 11/12] bpftool: Add support for XDP egress
Date:   Mon, 13 Apr 2020 11:18:00 -0600
Message-Id: <20200413171801.54406-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200413171801.54406-1-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add NET_ATTACH_TYPE_XDP_EGRESS and update attach_type_strings to
allow a user to specify 'xdp_egress' as the attach or detach point.

libbpf handles egress config via bpf_set_link_xdp_fd_opts, so
update do_attach_detach_xdp to use it. Specifically, the new API
requires old_fd to be set based on any currently loaded program,
so use bpf_get_link_xdp_id and bpf_get_link_xdp_egress_id to get
an fd to any existing program.

Update 'net show' command to dump egress programs.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/bpf/bpftool/main.h           |  2 +-
 tools/bpf/bpftool/net.c            | 49 +++++++++++++++++++++++++++---
 tools/bpf/bpftool/netlink_dumper.c | 12 ++++++--
 3 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 86f14ce26fd7..cbc0cc2257eb 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -230,7 +230,7 @@ void btf_dump_linfo_json(const struct btf *btf,
 struct nlattr;
 struct ifinfomsg;
 struct tcmsg;
-int do_xdp_dump(struct ifinfomsg *ifinfo, struct nlattr **tb);
+int do_xdp_dump(struct ifinfomsg *ifinfo, struct nlattr **tb, bool egress);
 int do_filter_dump(struct tcmsg *ifinfo, struct nlattr **tb, const char *kind,
 		   const char *devname, int ifindex);
 
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c5e3895b7c8b..1789dcd33d4e 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -32,6 +32,7 @@ struct bpf_netdev_t {
 	int	used_len;
 	int	array_len;
 	int	filter_idx;
+	bool	egress;
 };
 
 struct tc_kind_handle {
@@ -61,6 +62,7 @@ enum net_attach_type {
 	NET_ATTACH_TYPE_XDP_GENERIC,
 	NET_ATTACH_TYPE_XDP_DRIVER,
 	NET_ATTACH_TYPE_XDP_OFFLOAD,
+	NET_ATTACH_TYPE_XDP_EGRESS,
 };
 
 static const char * const attach_type_strings[] = {
@@ -68,6 +70,7 @@ static const char * const attach_type_strings[] = {
 	[NET_ATTACH_TYPE_XDP_GENERIC]	= "xdpgeneric",
 	[NET_ATTACH_TYPE_XDP_DRIVER]	= "xdpdrv",
 	[NET_ATTACH_TYPE_XDP_OFFLOAD]	= "xdpoffload",
+	[NET_ATTACH_TYPE_XDP_EGRESS]	= "xdp_egress",
 };
 
 const size_t net_attach_type_size = ARRAY_SIZE(attach_type_strings);
@@ -111,7 +114,7 @@ static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 			 : "");
 	netinfo->used_len++;
 
-	return do_xdp_dump(ifinfo, tb);
+	return do_xdp_dump(ifinfo, tb, netinfo->egress);
 }
 
 static int dump_class_qdisc_nlmsg(void *cookie, void *msg, struct nlattr **tb)
@@ -276,10 +279,19 @@ static int net_parse_dev(int *argc, char ***argv)
 static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
 				int ifindex, bool overwrite)
 {
-	__u32 flags = 0;
+	struct bpf_xdp_set_link_opts opts;
+	__u32 flags = 0, id = 0;
+	int rc, old_fd = -1;
+
+	memset(&opts, 0, sizeof(opts));
+	opts.sz = sizeof(opts);
 
 	if (!overwrite)
 		flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+	if (attach_type == NET_ATTACH_TYPE_XDP_EGRESS)
+		opts.egress = 1;
+
 	if (attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
 		flags |= XDP_FLAGS_SKB_MODE;
 	if (attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
@@ -287,7 +299,27 @@ static int do_attach_detach_xdp(int progfd, enum net_attach_type attach_type,
 	if (attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
 		flags |= XDP_FLAGS_HW_MODE;
 
-	return bpf_set_link_xdp_fd(ifindex, progfd, flags);
+	if (opts.egress)
+		rc = bpf_get_link_xdp_egress_id(ifindex, &id, flags);
+	else
+		rc = bpf_get_link_xdp_id(ifindex, &id, flags);
+
+	if (rc) {
+		p_err("Failed to get existing prog id for device");
+		return rc;
+	}
+
+	if (id)
+		old_fd = bpf_prog_get_fd_by_id(id);
+
+	opts.old_fd = old_fd;
+
+	rc = bpf_set_link_xdp_fd_opts(ifindex, progfd, flags, &opts);
+
+	if (old_fd != -1)
+		close(old_fd);
+
+	return rc;
 }
 
 static int do_attach(int argc, char **argv)
@@ -411,6 +443,7 @@ static int do_show(int argc, char **argv)
 	dev_array.used_len = 0;
 	dev_array.array_len = 0;
 	dev_array.filter_idx = filter_idx;
+	dev_array.egress = 0;
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
@@ -419,6 +452,14 @@ static int do_show(int argc, char **argv)
 	ret = libbpf_nl_get_link(sock, nl_pid, dump_link_nlmsg, &dev_array);
 	NET_END_ARRAY("\n");
 
+	if (!ret) {
+		dev_array.egress = true;
+		NET_START_ARRAY("xdp_egress", "%s:\n");
+		ret = libbpf_nl_get_link(sock, nl_pid, dump_link_nlmsg,
+					 &dev_array);
+		NET_END_ARRAY("\n");
+	}
+
 	if (!ret) {
 		NET_START_ARRAY("tc", "%s:\n");
 		for (i = 0; i < dev_array.used_len; i++) {
@@ -464,7 +505,7 @@ static int do_help(int argc, char **argv)
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
-		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
+		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload | xdp_egress}\n"
 		"\n"
 		"Note: Only xdp and tc attachments are supported now.\n"
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
diff --git a/tools/bpf/bpftool/netlink_dumper.c b/tools/bpf/bpftool/netlink_dumper.c
index 5f65140b003b..e4a2b6f8e50b 100644
--- a/tools/bpf/bpftool/netlink_dumper.c
+++ b/tools/bpf/bpftool/netlink_dumper.c
@@ -55,6 +55,7 @@ static int do_xdp_dump_one(struct nlattr *attr, unsigned int ifindex,
 		xdp_dump_prog_id(tb, IFLA_XDP_SKB_PROG_ID, "generic", true);
 		xdp_dump_prog_id(tb, IFLA_XDP_DRV_PROG_ID, "driver", true);
 		xdp_dump_prog_id(tb, IFLA_XDP_HW_PROG_ID, "offload", true);
+		xdp_dump_prog_id(tb, IFLA_XDP_EGRESS_CORE_PROG_ID, "core", true);
 		if (json_output)
 			jsonw_end_array(json_wtr);
 	} else if (mode == XDP_ATTACHED_DRV) {
@@ -63,18 +64,23 @@ static int do_xdp_dump_one(struct nlattr *attr, unsigned int ifindex,
 		xdp_dump_prog_id(tb, IFLA_XDP_PROG_ID, "generic", false);
 	} else if (mode == XDP_ATTACHED_HW) {
 		xdp_dump_prog_id(tb, IFLA_XDP_PROG_ID, "offload", false);
+	} else if (mode == XDP_ATTACHED_EGRESS_CORE) {
+		xdp_dump_prog_id(tb, IFLA_XDP_EGRESS_CORE_PROG_ID, "core",
+				 false);
 	}
 
 	NET_END_OBJECT_FINAL;
 	return 0;
 }
 
-int do_xdp_dump(struct ifinfomsg *ifinfo, struct nlattr **tb)
+int do_xdp_dump(struct ifinfomsg *ifinfo, struct nlattr **tb, bool egress)
 {
-	if (!tb[IFLA_XDP])
+	__u16 atype = egress ? IFLA_XDP_EGRESS : IFLA_XDP;
+
+	if (!tb[atype])
 		return 0;
 
-	return do_xdp_dump_one(tb[IFLA_XDP], ifinfo->ifi_index,
+	return do_xdp_dump_one(tb[atype], ifinfo->ifi_index,
 			       libbpf_nla_getattr_str(tb[IFLA_IFNAME]));
 }
 
-- 
2.21.1 (Apple Git-122.3)

