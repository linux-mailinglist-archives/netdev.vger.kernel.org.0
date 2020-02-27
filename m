Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94657170EFA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgB0DUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbgB0DUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:33 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B735A2467F;
        Thu, 27 Feb 2020 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773631;
        bh=bWUIt0Y0qiawoUkuDWq7R7xaJuQP8uAqD+wd6XdF8z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX1FEMdhRL9jTLcovsXP2qh5AxVHXLvDoqXXS6w3z2BekoCu7hQCizfXu6UgQT2Xa
         6yLGSP0EGYYNm8aVLU7gZq53q2ToVRzL4Uz+pMt2YorymilK6/DbpY/oReWxseELst
         kCuszHNFuRVuutIKF/zoL4SUK2JWMk05kZSEXZVQ=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 10/11] libbpf: Add egress XDP support
Date:   Wed, 26 Feb 2020 20:20:12 -0700
Message-Id: <20200227032013.12385-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Patch adds egress XDP support in libbpf.

First, new section name hint, xdp_egress, is added to set expected attach
type at program load. Programs can use xdp_egress as the prefix in
the SEC statement to load the program with the BPF_XDP_EGRESS
attach type set.

Second, new APIs are added that parallel the existing xdp ones which
can be changed:
        bpf_set_link_xdp_egress_fd - attach program at fd to device as
                                     xdp egress
        bpf_get_link_xdp_egress_id - get id for xdp egress program
        bpf_get_link_xdp_egress_info - get info for xdp egress program

Internally, the libbpf code is re-factored to be common for both
XDP use cases with a new egress argument to specify which netlink
attribute to use.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Co-developed-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/lib/bpf/libbpf.c   |  2 ++
 tools/lib/bpf/libbpf.h   |  6 +++++
 tools/lib/bpf/libbpf.map |  3 +++
 tools/lib/bpf/netlink.c  | 52 ++++++++++++++++++++++++++++++++++------
 4 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 996162801f7a..d90f7f034aad 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6295,6 +6295,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("freplace/", EXT,
 		.is_attach_btf = true,
 		.attach_fn = attach_trace),
+	BPF_EAPROG_SEC("xdp_egress",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_EGRESS),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 02fc58a21a7f..6d4071215b06 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -443,6 +443,12 @@ LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
+LIBBPF_API int bpf_set_link_xdp_egress_fd(int ifindex, int fd, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id,
+					  __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_egress_info(int ifindex,
+					    struct xdp_link_info *info,
+					    size_t info_size, __u32 flags);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7b014c8cdece..7441b2bd267a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -239,4 +239,7 @@ LIBBPF_0.0.7 {
 LIBBPF_0.0.8 {
 	global:
 		bpf_program__set_attach_target;
+		bpf_set_link_xdp_egress_fd;
+		bpf_get_link_xdp_egress_id;
+		bpf_get_link_xdp_egress_info;
 } LIBBPF_0.0.7;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 431bd25c6cdb..3c53c5dff122 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -28,6 +28,7 @@ typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, libbpf_dump_nlmsg_t,
 struct xdp_id_md {
 	int ifindex;
 	__u32 flags;
+	bool egress;
 	struct xdp_link_info info;
 };
 
@@ -132,7 +133,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags, bool egress)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -159,7 +160,7 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	/* started nested attribute for XDP */
 	nla = (struct nlattr *)(((char *)&req)
 				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
+	nla->nla_type = NLA_F_NESTED | (egress ? IFLA_XDP_EGRESS : IFLA_XDP);
 	nla->nla_len = NLA_HDRLEN;
 
 	/* add XDP fd */
@@ -191,6 +192,16 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, fd, flags, false);
+}
+
+int bpf_set_link_xdp_egress_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, fd, flags, true);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
@@ -211,15 +222,17 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
 	struct xdp_id_md *xdp_id = cookie;
 	struct ifinfomsg *ifinfo = msg;
+	unsigned int atype;
 	int ret;
 
 	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
 		return 0;
 
-	if (!tb[IFLA_XDP])
+	atype = xdp_id->egress ? IFLA_XDP_EGRESS : IFLA_XDP;
+	if (!tb[atype])
 		return 0;
 
-	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[IFLA_XDP], NULL);
+	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[atype], NULL);
 	if (ret)
 		return ret;
 
@@ -251,10 +264,10 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
-int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
-			  size_t info_size, __u32 flags)
+static int __bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+				   size_t info_size, __u32 flags, bool egress)
 {
-	struct xdp_id_md xdp_id = {};
+	struct xdp_id_md xdp_id;
 	int sock, ret;
 	__u32 nl_pid;
 	__u32 mask;
@@ -274,6 +287,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
+	xdp_id.egress = egress;
 
 	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
 	if (!ret) {
@@ -287,6 +301,18 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	return ret;
 }
 
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags, false);
+}
+
+int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
+				 size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags, true);
+}
+
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
 	if (info->attach_mode != XDP_ATTACHED_MULTI)
@@ -313,6 +339,18 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return ret;
 }
 
+int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+	struct xdp_link_info info;
+	int ret;
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

