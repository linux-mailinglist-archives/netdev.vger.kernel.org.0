Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC721B1680
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgDTUBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgDTUBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:01:11 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A1021744;
        Mon, 20 Apr 2020 20:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587412870;
        bh=yWUrXROe2ZcmclGcw758B2FtOvJBcIuVu88FOfSf6XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZosnMBlr2xNYi3VWtGubnj3F3XmhLVsh/iQi3NROTSH47ct3MBdXwiQzyTQVcdCOM
         hcBhEVu2qdS+RTMBw+ItEqHHirbQZOP1+RpEpQquMyMJy4l1MaDfAzOYLsuKWFj8O3
         xcjb3vnubeAg4NkTpZmwSMsYtAUA0EnJgHmxDhNA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
Date:   Mon, 20 Apr 2020 14:00:51 -0600
Message-Id: <20200420200055.49033-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200420200055.49033-1-dsahern@kernel.org>
References: <20200420200055.49033-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Patch adds egress XDP support in libbpf.

New section name hint, xdp_egress, is added to set expected attach
type at program load. Programs can use xdp_egress as the prefix in
the SEC statement to load the program with the BPF_XDP_EGRESS
attach type set.

egress is added to bpf_xdp_set_link_opts to specify egress type for
use with bpf_set_link_xdp_fd_opts. Update library side to check
for flag and set nla_type to IFLA_XDP_EGRESS.

Add egress version of bpf_get_link_xdp* info and id apis with core
code refactored to handle both rx and tx paths.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Co-developed-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/lib/bpf/libbpf.c   |  2 ++
 tools/lib/bpf/libbpf.h   |  9 +++++-
 tools/lib/bpf/libbpf.map |  2 ++
 tools/lib/bpf/netlink.c  | 63 +++++++++++++++++++++++++++++++++++-----
 4 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..32fc970495d9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6366,6 +6366,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.is_attach_btf = true,
 		.expected_attach_type = BPF_LSM_MAC,
 		.attach_fn = attach_lsm),
+	BPF_EAPROG_SEC("xdp_egress",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_EGRESS),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f1dacecb1619..3feb1242f78e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -453,14 +453,16 @@ struct xdp_link_info {
 	__u32 drv_prog_id;
 	__u32 hw_prog_id;
 	__u32 skb_prog_id;
+	__u32 egress_core_prog_id;
 	__u8 attach_mode;
 };
 
 struct bpf_xdp_set_link_opts {
 	size_t sz;
 	int old_fd;
+	__u8  egress;
 };
-#define bpf_xdp_set_link_opts__last_field old_fd
+#define bpf_xdp_set_link_opts__last_field egress
 
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
@@ -468,6 +470,11 @@ LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id,
+					  __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_egress_info(int ifindex,
+					    struct xdp_link_info *info,
+					    size_t info_size, __u32 flags);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bb8831605b25..51576c8a02fe 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -253,4 +253,6 @@ LIBBPF_0.0.8 {
 		bpf_program__set_attach_target;
 		bpf_program__set_lsm;
 		bpf_set_link_xdp_fd_opts;
+		bpf_get_link_xdp_egress_id;
+		bpf_get_link_xdp_egress_info;
 } LIBBPF_0.0.7;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 0b709fd10bba..342acacf7cda 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -28,6 +28,7 @@ typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, libbpf_dump_nlmsg_t,
 struct xdp_id_md {
 	int ifindex;
 	__u32 flags;
+	__u16 nla_type;
 	struct xdp_link_info info;
 };
 
@@ -133,7 +134,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 }
 
 static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
-					 __u32 flags)
+					 __u32 flags, __u16 nla_type)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -160,7 +161,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	/* started nested attribute for XDP */
 	nla = (struct nlattr *)(((char *)&req)
 				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
+	nla->nla_type = NLA_F_NESTED | nla_type;
 	nla->nla_len = NLA_HDRLEN;
 
 	/* add XDP fd */
@@ -203,6 +204,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 			     const struct bpf_xdp_set_link_opts *opts)
 {
+	__u16 nla_type = IFLA_XDP;
 	int old_fd = -1;
 
 	if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
@@ -213,14 +215,22 @@ int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
 		flags |= XDP_FLAGS_REPLACE;
 	}
 
+	if (OPTS_HAS(opts, egress)) {
+		__u8 egress = OPTS_GET(opts, egress, 0);
+
+		if (egress)
+			nla_type = IFLA_XDP_EGRESS;
+	}
+
 	return __bpf_set_link_xdp_fd_replace(ifindex, fd,
 					     old_fd,
-					     flags);
+					     flags,
+					     nla_type);
 }
 
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 {
-	return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags, IFLA_XDP);
 }
 
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
@@ -243,15 +253,16 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
 	struct xdp_id_md *xdp_id = cookie;
 	struct ifinfomsg *ifinfo = msg;
+	__u16 atype = xdp_id->nla_type;
 	int ret;
 
 	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
 		return 0;
 
-	if (!tb[IFLA_XDP])
+	if (!tb[atype])
 		return 0;
 
-	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[IFLA_XDP], NULL);
+	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[atype], NULL);
 	if (ret)
 		return ret;
 
@@ -280,11 +291,16 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 		xdp_id->info.hw_prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_HW_PROG_ID]);
 
+	if (xdp_tb[IFLA_XDP_EGRESS_CORE_PROG_ID])
+		xdp_id->info.egress_core_prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_EGRESS_CORE_PROG_ID]);
+
 	return 0;
 }
 
-int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
-			  size_t info_size, __u32 flags)
+static int __bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+				   size_t info_size, __u32 flags,
+				   __u16 nla_type)
 {
 	struct xdp_id_md xdp_id = {};
 	int sock, ret;
@@ -306,6 +322,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
+	xdp_id.nla_type = nla_type;
 
 	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
 	if (!ret) {
@@ -319,6 +336,20 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	return ret;
 }
 
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
+				       IFLA_XDP);
+}
+
+int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
+				 size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags,
+				       IFLA_XDP_EGRESS);
+}
+
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
 	if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
@@ -345,6 +376,22 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return ret;
 }
 
+int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+	struct xdp_link_info info;
+	int ret;
+
+	/* egress path does not support SKB, DRV or HW mode */
+	if (flags & XDP_FLAGS_MODES)
+		return -EINVAL;
+
+	ret = bpf_get_link_xdp_egress_info(ifindex, &info, sizeof(info), flags);
+	if (!ret)
+		*prog_id = get_xdp_id(&info, flags);
+
+	return ret;
+}
+
 int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
-- 
2.21.1 (Apple Git-122.3)

