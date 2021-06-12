Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996FE3A4C45
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 04:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhFLCjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 22:39:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42948 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLCjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 22:39:44 -0400
Received: by mail-pf1-f194.google.com with SMTP id s14so5912837pfd.9;
        Fri, 11 Jun 2021 19:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KZhwqlVWb26zxwCCNtqaurUNNLuqzC0/navdJuJBpj4=;
        b=a/j89gTigdP6TRfSlSikoY2kybjZpZCqz6hBbyThlfxAMy5hGGXsFDtL09tMXYLLsg
         1vEG3Og7MytuHTJ9ji1R1Nsbxhn5rWlLPdfZ5di+399MpFuhnlSVRVLsiad3YNbm5sYp
         bGEt3rGHNIuY6mVXWtHjaCiAxYeDepty7b7+T369BEwjt85Z3UntNNY4hdLgm1V2i8or
         rmwRfkBJ+c+G7fhMeB+iJPRBL5folfFDi2Tchqn4PR1ivI8EAu/LdNfvpXukxXp1MyO/
         K55xONVxWgkTw3ltAhoD4jjRZK63UrTMBcnNe8TbqiJJ02ctNRNkGdiBiFW3i3qFBzSd
         at6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZhwqlVWb26zxwCCNtqaurUNNLuqzC0/navdJuJBpj4=;
        b=iNRUfAYfXhAcxWHMV7HuiY3RUeKwIjXbVtJq4sxmjpoXk5ObPkFAZqG5dTU2HoTlie
         4hcYp/MWGpRyfLaxEH5vSyA38/44XeMA8kWFkzUNRExbHLRbuyreNQ6Dp5U/gFgI/53D
         1XpCHRN9AYe4P8tC8h0NDCeQhsEWZtwEdhx4vQk/oYqmpyimu6NAOaD4gXPOl/2XItj+
         ugUm/EGQpXSJuHZ2QoClWwp5sYsE36/tdIh8T5bqSUAHtG3X1kMAtOc/Ul8sVCEhaGPR
         7WcCXFODsZrCrgIdlvURrr7rimDpE/haIRvY/b0JbrNra1Ws9PaKu4QNUOxyQV3yqGe0
         LM+A==
X-Gm-Message-State: AOAM5307n1NAl3uzh2San7mg0afK7awRBEKIEeY+H03xKQEBrjUPIBbR
        fWnbo4QOWwJWmaEBwQstb8mVyFVeXAA=
X-Google-Smtp-Source: ABdhPJwdV99xdvePCmmuKu6bH+0e8lh4lSN2kYogNPxKBXwO90K3As31S2qQKxlGnm0+jwRHkRtR5Q==
X-Received: by 2002:a63:fc06:: with SMTP id j6mr6480474pgi.226.1623465392118;
        Fri, 11 Jun 2021 19:36:32 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id f12sm6079261pfn.161.2021.06.11.19.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 19:36:31 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 3/3] libbpf: add request buffer type for netlink messages
Date:   Sat, 12 Jun 2021 08:05:02 +0530
Message-Id: <20210612023502.1283837-4-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210612023502.1283837-1-memxor@gmail.com>
References: <20210612023502.1283837-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
write to the trailing buffer, but static analyzers and compilers may
rightfully be confused as the nlmsghdr pointer has subobject provenance
(and hence subobject bounds).

Remedy this by using an explicit request structure, but we also need to
start the buffer in case of ifinfomsg without any padding. The alignment
on netlink wire protocol is 4 byte boundary, so we just insert explicit
4 byte buffer to avoid compilers throwing off on read and write from/to
padding.

Also switch nh_tail (renamed to req_tail) to cast req * to char * so
that it can be understood as arithmetic on pointer to the representation
array (hence having same bound as request structure), which should
further appease analyzers.

As a bonus, callers don't have to pass sizeof(req) all the time now, as
size is implicitly obtained using the pointer. While at it, also reduce
the size of attribute buffer to 128 bytes (132 for ifinfomsg using
functions due to the need to align buffer after it).

More info/discussion on why this was a problem in these links:
http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2294.htm#provenance-and-subobjects-container-of-casts-1
https://twitter.com/rep_stosq_void/status/1298581367442333696

CID: 322807
CID: 322806
CID: 141815
Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
 tools/lib/bpf/nlattr.h  |  37 +++++++++-----
 2 files changed, 65 insertions(+), 79 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index cf9381f03b16..e62b188503fa 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -154,7 +154,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-static int libbpf_netlink_send_recv(struct nlmsghdr *nh,
+static int libbpf_netlink_send_recv(struct netlink_request *req,
 				    __dump_nlmsg_t parse_msg,
 				    libbpf_dump_nlmsg_t parse_attr,
 				    void *cookie)
@@ -166,15 +166,15 @@ static int libbpf_netlink_send_recv(struct nlmsghdr *nh,
 	if (sock < 0)
 		return sock;
 
-	nh->nlmsg_pid = 0;
-	nh->nlmsg_seq = time(NULL);
+	req->nh.nlmsg_pid = 0;
+	req->nh.nlmsg_seq = time(NULL);
 
-	if (send(sock, nh, nh->nlmsg_len, 0) < 0) {
+	if (send(sock, req, req->nh.nlmsg_len, 0) < 0) {
 		ret = -errno;
 		goto out;
 	}
 
-	ret = libbpf_netlink_recv(sock, nl_pid, nh->nlmsg_seq,
+	ret = libbpf_netlink_recv(sock, nl_pid, req->nh.nlmsg_seq,
 				  parse_msg, parse_attr, cookie);
 out:
 	libbpf_netlink_close(sock);
@@ -186,11 +186,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 {
 	struct nlattr *nla;
 	int ret;
-	struct {
-		struct nlmsghdr  nh;
-		struct ifinfomsg ifinfo;
-		char             attrbuf[64];
-	} req;
+	struct netlink_request req;
 
 	memset(&req, 0, sizeof(req));
 	req.nh.nlmsg_len      = NLMSG_LENGTH(sizeof(struct ifinfomsg));
@@ -199,27 +195,26 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	req.ifinfo.ifi_family = AF_UNSPEC;
 	req.ifinfo.ifi_index  = ifindex;
 
-	nla = nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
+	nla = nlattr_begin_nested(&req, IFLA_XDP);
 	if (!nla)
 		return -EMSGSIZE;
-	ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof(fd));
+	ret = nlattr_add(&req, IFLA_XDP_FD, &fd, sizeof(fd));
 	if (ret < 0)
 		return ret;
 	if (flags) {
-		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLAGS, &flags,
-				 sizeof(flags));
+		ret = nlattr_add(&req, IFLA_XDP_FLAGS, &flags, sizeof(flags));
 		if (ret < 0)
 			return ret;
 	}
 	if (flags & XDP_FLAGS_REPLACE) {
-		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXPECTED_FD,
-				 &old_fd, sizeof(old_fd));
+		ret = nlattr_add(&req, IFLA_XDP_EXPECTED_FD, &old_fd,
+				 sizeof(old_fd));
 		if (ret < 0)
 			return ret;
 	}
-	nlattr_end_nested(&req.nh, nla);
+	nlattr_end_nested(&req, nla);
 
-	return libbpf_netlink_send_recv(&req.nh, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
 }
 
 int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
@@ -314,14 +309,11 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	struct xdp_id_md xdp_id = {};
 	__u32 mask;
 	int ret;
-	struct {
-		struct nlmsghdr  nh;
-		struct ifinfomsg ifm;
-	} req = {
+	struct netlink_request req = {
 		.nh.nlmsg_len   = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
 		.nh.nlmsg_type  = RTM_GETLINK,
 		.nh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
-		.ifm.ifi_family = AF_PACKET,
+		.ifinfo.ifi_family = AF_PACKET,
 	};
 
 	if (flags & ~XDP_FLAGS_MASK || !info_size)
@@ -336,7 +328,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
 
-	ret = libbpf_netlink_send_recv(&req.nh, __dump_link_nlmsg,
+	ret = libbpf_netlink_send_recv(&req, __dump_link_nlmsg,
 				       get_xdp_info, &xdp_id);
 	if (!ret) {
 		size_t sz = min(info_size, sizeof(xdp_id.info));
@@ -376,15 +368,14 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return libbpf_err(ret);
 }
 
-typedef int (*qdisc_config_t)(struct nlmsghdr *nh, struct tcmsg *t,
-			      size_t maxsz);
+typedef int (*qdisc_config_t)(struct netlink_request *req);
 
-static int clsact_config(struct nlmsghdr *nh, struct tcmsg *t, size_t maxsz)
+static int clsact_config(struct netlink_request *req)
 {
-	t->tcm_parent = TC_H_CLSACT;
-	t->tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
+	req->tc.tcm_parent = TC_H_CLSACT;
+	req->tc.tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
 
-	return nlattr_add(nh, maxsz, TCA_KIND, "clsact", sizeof("clsact"));
+	return nlattr_add(req, TCA_KIND, "clsact", sizeof("clsact"));
 }
 
 static int attach_point_to_config(struct bpf_tc_hook *hook,
@@ -431,11 +422,7 @@ static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
 {
 	qdisc_config_t config;
 	int ret;
-	struct {
-		struct nlmsghdr nh;
-		struct tcmsg tc;
-		char buf[256];
-	} req;
+	struct netlink_request req;
 
 	ret = attach_point_to_config(hook, &config);
 	if (ret < 0)
@@ -448,11 +435,11 @@ static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
 	req.tc.tcm_family  = AF_UNSPEC;
 	req.tc.tcm_ifindex = OPTS_GET(hook, ifindex, 0);
 
-	ret = config(&req.nh, &req.tc, sizeof(req));
+	ret = config(&req);
 	if (ret < 0)
 		return ret;
 
-	return libbpf_netlink_send_recv(&req.nh, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
 }
 
 static int tc_qdisc_create_excl(struct bpf_tc_hook *hook)
@@ -544,7 +531,7 @@ static int get_tc_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
 	return __get_tc_info(cookie, tc, tb, nh->nlmsg_flags & NLM_F_ECHO);
 }
 
-static int tc_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
+static int tc_add_fd_and_name(struct netlink_request *req, int fd)
 {
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
@@ -555,7 +542,7 @@ static int tc_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
 	if (ret < 0)
 		return ret;
 
-	ret = nlattr_add(nh, maxsz, TCA_BPF_FD, &fd, sizeof(fd));
+	ret = nlattr_add(req, TCA_BPF_FD, &fd, sizeof(fd));
 	if (ret < 0)
 		return ret;
 	len = snprintf(name, sizeof(name), "%s:[%u]", info.name, info.id);
@@ -563,7 +550,7 @@ static int tc_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
 		return -errno;
 	if (len >= sizeof(name))
 		return -ENAMETOOLONG;
-	return nlattr_add(nh, maxsz, TCA_BPF_NAME, name, len + 1);
+	return nlattr_add(req, TCA_BPF_NAME, name, len + 1);
 }
 
 int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
@@ -571,12 +558,8 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 	__u32 protocol, bpf_flags, handle, priority, parent, prog_id, flags;
 	int ret, ifindex, attach_point, prog_fd;
 	struct bpf_cb_ctx info = {};
+	struct netlink_request req;
 	struct nlattr *nla;
-	struct {
-		struct nlmsghdr nh;
-		struct tcmsg tc;
-		char buf[256];
-	} req;
 
 	if (!hook || !opts ||
 	    !OPTS_VALID(hook, bpf_tc_hook) ||
@@ -618,25 +601,24 @@ int bpf_tc_attach(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 		return libbpf_err(ret);
 	req.tc.tcm_parent = parent;
 
-	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	ret = nlattr_add(&req, TCA_KIND, "bpf", sizeof("bpf"));
 	if (ret < 0)
 		return libbpf_err(ret);
-	nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
+	nla = nlattr_begin_nested(&req, TCA_OPTIONS);
 	if (!nla)
 		return libbpf_err(-EMSGSIZE);
-	ret = tc_add_fd_and_name(&req.nh, sizeof(req), prog_fd);
+	ret = tc_add_fd_and_name(&req, prog_fd);
 	if (ret < 0)
 		return libbpf_err(ret);
 	bpf_flags = TCA_BPF_FLAG_ACT_DIRECT;
-	ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS, &bpf_flags,
-			 sizeof(bpf_flags));
+	ret = nlattr_add(&req, TCA_BPF_FLAGS, &bpf_flags, sizeof(bpf_flags));
 	if (ret < 0)
 		return libbpf_err(ret);
-	nlattr_end_nested(&req.nh, nla);
+	nlattr_end_nested(&req, nla);
 
 	info.opts = opts;
 
-	ret = libbpf_netlink_send_recv(&req.nh, get_tc_info, NULL, &info);
+	ret = libbpf_netlink_send_recv(&req, get_tc_info, NULL, &info);
 	if (ret < 0)
 		return libbpf_err(ret);
 	if (!info.processed)
@@ -650,11 +632,7 @@ static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
 {
 	__u32 protocol = 0, handle, priority, parent, prog_id, flags;
 	int ret, ifindex, attach_point, prog_fd;
-	struct {
-		struct nlmsghdr nh;
-		struct tcmsg tc;
-		char buf[256];
-	} req;
+	struct netlink_request req;
 
 	if (!hook ||
 	    !OPTS_VALID(hook, bpf_tc_hook) ||
@@ -701,13 +679,12 @@ static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
 	req.tc.tcm_parent = parent;
 
 	if (!flush) {
-		ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND,
-				 "bpf", sizeof("bpf"));
+		ret = nlattr_add(&req, TCA_KIND, "bpf", sizeof("bpf"));
 		if (ret < 0)
 			return ret;
 	}
 
-	return libbpf_netlink_send_recv(&req.nh, NULL, NULL, NULL);
+	return libbpf_netlink_send_recv(&req, NULL, NULL, NULL);
 }
 
 int bpf_tc_detach(const struct bpf_tc_hook *hook,
@@ -727,11 +704,7 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 	__u32 protocol, handle, priority, parent, prog_id, flags;
 	int ret, ifindex, attach_point, prog_fd;
 	struct bpf_cb_ctx info = {};
-	struct {
-		struct nlmsghdr nh;
-		struct tcmsg tc;
-		char buf[256];
-	} req;
+	struct netlink_request req;
 
 	if (!hook || !opts ||
 	    !OPTS_VALID(hook, bpf_tc_hook) ||
@@ -770,13 +743,13 @@ int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts)
 		return libbpf_err(ret);
 	req.tc.tcm_parent = parent;
 
-	ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
+	ret = nlattr_add(&req, TCA_KIND, "bpf", sizeof("bpf"));
 	if (ret < 0)
 		return libbpf_err(ret);
 
 	info.opts = opts;
 
-	ret = libbpf_netlink_send_recv(&req.nh, get_tc_info, NULL, &info);
+	ret = libbpf_netlink_send_recv(&req, get_tc_info, NULL, &info);
 	if (ret < 0)
 		return libbpf_err(ret);
 	if (!info.processed)
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 3c780ab6d022..cc59f9c02d88 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <errno.h>
 #include <linux/netlink.h>
+#include <linux/rtnetlink.h>
 
 /* avoid multiple definition of netlink features */
 #define __LINUX_NETLINK_H
@@ -52,6 +53,18 @@ struct libbpf_nla_policy {
 	uint16_t	maxlen;
 };
 
+struct netlink_request {
+	struct nlmsghdr nh;
+	union {
+		struct {
+			struct ifinfomsg ifinfo;
+			char _pad[4];
+		};
+		struct tcmsg tc;
+	};
+	char buf[128];
+};
+
 /**
  * @ingroup attr
  * Iterate over a stream of attributes
@@ -111,44 +124,44 @@ static inline struct nlattr *nla_data(struct nlattr *nla)
 	return (struct nlattr *)((char *)nla + NLA_HDRLEN);
 }
 
-static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
+static inline struct nlattr *req_tail(struct netlink_request *req)
 {
-	return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
+	return (struct nlattr *)((char *)req + NLMSG_ALIGN(req->nh.nlmsg_len));
 }
 
-static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int type,
+static inline int nlattr_add(struct netlink_request *req, int type,
 			     const void *data, int len)
 {
 	struct nlattr *nla;
 
-	if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > maxsz)
+	if (NLMSG_ALIGN(req->nh.nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > sizeof(*req))
 		return -EMSGSIZE;
 	if (!!data != !!len)
 		return -EINVAL;
 
-	nla = nh_tail(nh);
+	nla = req_tail(req);
 	nla->nla_type = type;
 	nla->nla_len = NLA_HDRLEN + len;
 	if (data)
 		memcpy(nla_data(nla), data, len);
-	nh->nlmsg_len = NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla_len);
+	req->nh.nlmsg_len = NLMSG_ALIGN(req->nh.nlmsg_len) + NLA_ALIGN(nla->nla_len);
 	return 0;
 }
 
-static inline struct nlattr *nlattr_begin_nested(struct nlmsghdr *nh,
-						 size_t maxsz, int type)
+static inline struct nlattr *nlattr_begin_nested(struct netlink_request *req, int type)
 {
 	struct nlattr *tail;
 
-	tail = nh_tail(nh);
-	if (nlattr_add(nh, maxsz, type | NLA_F_NESTED, NULL, 0))
+	tail = req_tail(req);
+	if (nlattr_add(req, type | NLA_F_NESTED, NULL, 0))
 		return NULL;
 	return tail;
 }
 
-static inline void nlattr_end_nested(struct nlmsghdr *nh, struct nlattr *tail)
+static inline void nlattr_end_nested(struct netlink_request *req,
+				     struct nlattr *tail)
 {
-	tail->nla_len = (char *)nh_tail(nh) - (char *)tail;
+	tail->nla_len = (char *)req_tail(req) - (char *)tail;
 }
 
 #endif /* __LIBBPF_NLATTR_H */
-- 
2.31.1

