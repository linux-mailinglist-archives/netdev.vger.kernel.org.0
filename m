Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29B3AA215
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhFPRGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhFPRGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 13:06:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2745CC061768;
        Wed, 16 Jun 2021 10:04:02 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x10so1441823plg.3;
        Wed, 16 Jun 2021 10:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZQBdvi4WvCwhdSByzyu/id5SNc4SjGQzwDalRqCKfw=;
        b=XeNzbxAqEJczJOLBeEUjaSl6ZKARNMLNNhccmgR6TO6zJmd0D3S2nXfaJZuiX+nsml
         SqR5oBBB6HWDqcB7cnNcFFsYGwcrM0F3ZFZsFzHAoNo/xJGx1rZ9dc+ibPJumqn1AXZa
         QpWtAj4G14bZCT1y2izIFdEALvqSGERxIwHs2Nv5IwAD+2UjlwkwttcQMYb1UNH9ZTfe
         OLMhC69UWolx8WxJNb9562kVmUSt9e/PTksTrdX8viv/h+e6/IozmUwq1U7SPyNKNZyT
         1vLUkeu/p+uw8IEYCAl8wTrnlBNW8HAWdvhKAjRe/mmc8+4Kiv1vtT8ncX018f5rebPp
         On4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZQBdvi4WvCwhdSByzyu/id5SNc4SjGQzwDalRqCKfw=;
        b=fUm8rX1MiWsz2rSIJ551nc4s4mFtbkbGfxfsu+JMbcsxrgMVz9vAUuF7megiIsqcN7
         xOXW+uc8cKH2WnyLWen0xdv7v7/zv9qPtZQhycAC2Ew5VXOLfY+nConwOkbN53j8k1If
         V6uf3K1o2yA98k/JvQtETNnfuuPOOjDgCZyPNPqcLlVGUP0v7pgmUEquB9macd6Remfk
         Omo+EB2N0mIPAhjlOSmq62NvFBmgG1dodkNTsckhLsNoxzPsXzol0U1aqZv2Pi3wqktH
         IenXrvowAw+lWtZm9CVqJASNC2p9SXDjXcmN0DN6Q8DjCslhI9DRiomx2TqCzoECJEke
         JHcA==
X-Gm-Message-State: AOAM532WO6avJ65Pj48KX7ezGqh4xcNegcEjML9WP7EGlv2Ea5n90KlX
        pub/mPlAaFG2RJVg50tV3qPNjV5eD/k=
X-Google-Smtp-Source: ABdhPJw7BaodzL2oj1TC75th1Lx4YBk0Jybtlhf/gEZ9f24kvSsB2lWQA/R2+NPPrT49QNDE1SFAnw==
X-Received: by 2002:a17:902:b609:b029:118:8a66:6963 with SMTP id b9-20020a170902b609b02901188a666963mr513925pls.65.1623863041361;
        Wed, 16 Jun 2021 10:04:01 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:39d5:aefe:1e71:33ef:30fb])
        by smtp.gmail.com with ESMTPSA id t136sm2890915pfc.70.2021.06.16.10.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 10:04:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2] libbpf: add request buffer type for netlink messages
Date:   Wed, 16 Jun 2021 22:32:31 +0530
Message-Id: <20210616170231.2194285-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Summary of problem:
  Even though C standard allows interconveritility of pointer to first
  member and pointer to struct, for the purposes of alias analysis it
  would still consider the first as having pointer value "pointer to T"
  where T is type of first member hence having subobject bounds,
  allowing analyzers within reason to complain when object is accessed
  beyond the size of pointed to object.

  The only exception to this rule may be when a char * is formed to a
  member subobject. It is not possible for the compiler to be able to
  tell the intent of the programmer that it is a pointer to member
  object or the underlying representation array of the containing
  object, so such diagnosis is supressed.

Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
Changelog:
v1 -> v2:
 * Add short summary instead of links about the underlying issue (Daniel)
---
 tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
 tools/lib/bpf/nlattr.h  |  37 +++++++++-----
 2 files changed, 65 insertions(+), 79 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index cf9381f03b16..a17470045455 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -154,7 +154,7 @@ static int libbpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }

-static int libbpf_netlink_send_recv(struct nlmsghdr *nh,
+static int libbpf_netlink_send_recv(struct libbpf_nla_req *req,
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
+	struct libbpf_nla_req req;

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
+	struct libbpf_nla_req req = {
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
+typedef int (*qdisc_config_t)(struct libbpf_nla_req *req);

-static int clsact_config(struct nlmsghdr *nh, struct tcmsg *t, size_t maxsz)
+static int clsact_config(struct libbpf_nla_req *req)
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
+	struct libbpf_nla_req req;

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
+static int tc_add_fd_and_name(struct libbpf_nla_req *req, int fd)
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
+	struct libbpf_nla_req req;
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
+	struct libbpf_nla_req req;

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
+	struct libbpf_nla_req req;

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
index 3c780ab6d022..219747e135f2 100644
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

+struct libbpf_nla_req {
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
+static inline struct nlattr *req_tail(struct libbpf_nla_req *req)
 {
-	return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
+	return (struct nlattr *)((char *)req + NLMSG_ALIGN(req->nh.nlmsg_len));
 }

-static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int type,
+static inline int nlattr_add(struct libbpf_nla_req *req, int type,
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
+static inline struct nlattr *nlattr_begin_nested(struct libbpf_nla_req *req, int type)
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
+static inline void nlattr_end_nested(struct libbpf_nla_req *req,
+				     struct nlattr *tail)
 {
-	tail->nla_len = (char *)nh_tail(nh) - (char *)tail;
+	tail->nla_len = (char *)req_tail(req) - (char *)tail;
 }

 #endif /* __LIBBPF_NLATTR_H */
--
2.31.1

