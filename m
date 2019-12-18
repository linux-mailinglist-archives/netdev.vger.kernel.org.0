Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821DD124125
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLRIMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:25 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35163 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:25 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so523586pjc.0
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmyR+bNI6iy6Eifp+yv/OUSo0X5yjxzdJXgAWzraQZE=;
        b=Dj+5wEZdHbZJSDyAzZXPREUvo0kFZiIWLnbE15SWLWqKQXqrG+N4uTGXoVxWj1v88a
         xL1k8AlJETynT3YzK4nLAQwnd16YK9Iu2bNEwVZaFaFWXGenmqReDycCcqmifIzd9xnq
         +SrGAbDg0v6f6kKVYNYzl4v+tFD+IwKP+6y9X3vMkOvGmU3VYQMUP2pMs7aTda6PmytY
         vyX4sPHbqQoAEGuaC4WETIQ8RDA3eiZ45O4ZOGRexJjLAEXYsJP12SysEQl8OPZODPjQ
         RKW5Y4A9HZl2xn81FJw6V/Cur7GrtgIM39M8FEU3StTwfrsWgQfFA5XSyRNSmP6jPxmc
         sGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmyR+bNI6iy6Eifp+yv/OUSo0X5yjxzdJXgAWzraQZE=;
        b=pbM+2Pu3Z1r6zfdPMGNFc0PuUgHZzi4rAOFO4u+O/JIl+AfyL3Kn0wkD8crdEweWQ9
         E8sD9YMALJK13kCgL4IVfoViicE4rdSoHZIZAnjOnrNA25c2TBHBTCTFHmtgcS6/8ubQ
         7oYYD+mal/zo8ebKZgloTj9r9I6RuVepkpHsJynyJytuPX/zdLMFx+HuFtHYvaeKMwxW
         fYr69A7100ONbpYW/bbjDUEsGmMQzDk/ij+9YKp5IleK7R8Mm200TPp2Zy5Sa4V8X43M
         nDQ56Wpivw1O1O5o70T+gqjXrw8g2Cw/RvouM4G3c8nWCkwbWowgHffxQfc+sYP3RoEG
         fhGg==
X-Gm-Message-State: APjAAAXgcdqFku2nke0Q0+5I/vd3h//CvJ8PoSU0HbRq+E9hAxW/Kfse
        eyD3lS6fwAchr5THl3CjSl0UfIsw
X-Google-Smtp-Source: APXvYqzhGrtCOGpvSTZQvj+538kGsiKNU8CTC3ediFkab04Q7FEDHxnazAQfUFVBfMj+XNcVJlJ0Xw==
X-Received: by 2002:a17:902:b08d:: with SMTP id p13mr1353686plr.109.1576656744235;
        Wed, 18 Dec 2019 00:12:24 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:23 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: [RFC net-next 03/14] libbpf: API for tx path XDP support
Date:   Wed, 18 Dec 2019 17:10:39 +0900
Message-Id: <20191218081050.10170-4-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds new APIs for tx path XDP:
 - bpf_set_link_xdp_tx_fd
 - bpf_get_link_xdp_tx_id
 - bpf_get_link_xdp_tx_info

Co-developed-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/lib/bpf/libbpf.h   |  4 +++
 tools/lib/bpf/libbpf.map |  3 ++
 tools/lib/bpf/netlink.c  | 77 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..741e5fee61f6 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -447,6 +447,10 @@ LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
+LIBBPF_API int bpf_set_link_xdp_tx_fd(int ifindex, int fd, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_tx_id(int ifindex, __u32 *prog_id, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_tx_info(int ifindex, struct xdp_link_info *info,
+				     size_t info_size, __u32 flags);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8ddc2c40e482..28597c2a24c4 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -207,4 +207,7 @@ LIBBPF_0.0.6 {
 		bpf_program__size;
 		btf__find_by_name_kind;
 		libbpf_find_vmlinux_btf_id;
+		bpf_set_link_xdp_tx_fd;
+		bpf_get_link_xdp_tx_id;
+		bpf_get_link_xdp_tx_info;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 5065c1aa1061..eca6e80df697 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -129,7 +129,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags, bool tx)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -156,7 +156,11 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	/* started nested attribute for XDP */
 	nla = (struct nlattr *)(((char *)&req)
 				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
+	nla->nla_type = NLA_F_NESTED;
+	if (tx)
+		nla->nla_type |= IFLA_XDP_TX;
+	else
+		nla->nla_type |= IFLA_XDP;
 	nla->nla_len = NLA_HDRLEN;
 
 	/* add XDP fd */
@@ -188,6 +192,16 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, fd, flags, false);
+}
+
+int bpf_set_link_xdp_tx_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, fd, flags, true);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
@@ -203,20 +217,23 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 	return dump_link_nlmsg(cookie, ifi, tb);
 }
 
-static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
+static int __get_xdp_info(void *cookie, void *msg, struct nlattr **tb, bool tx)
 {
 	struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
 	struct xdp_id_md *xdp_id = cookie;
 	struct ifinfomsg *ifinfo = msg;
+	struct nlattr *attr;
 	int ret;
 
 	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
 		return 0;
 
-	if (!tb[IFLA_XDP])
-		return 0;
+	if (tx)
+		attr = tb[IFLA_XDP_TX];
+	else
+		attr = tb[IFLA_XDP];
 
-	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[IFLA_XDP], NULL);
+	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, attr, NULL);
 	if (ret)
 		return ret;
 
@@ -248,8 +265,22 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
-int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
-			  size_t info_size, __u32 flags)
+static int get_xdp_tx_info(void *cookie, void *msg, struct nlattr **tb)
+{
+	if (!tb[IFLA_XDP_TX])
+		return 0;
+	return __get_xdp_info(cookie, msg, tb, true);
+}
+
+static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
+{
+	if (!tb[IFLA_XDP])
+		return 0;
+	return __get_xdp_info(cookie, msg, tb, false);
+}
+
+static int __bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags, bool tx)
 {
 	struct xdp_id_md xdp_id = {};
 	int sock, ret;
@@ -272,7 +303,11 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
 
-	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
+	if (tx)
+		ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_tx_info,
+					 &xdp_id);
+	else
+		ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
 	if (!ret) {
 		size_t sz = min(info_size, sizeof(xdp_id.info));
 
@@ -284,6 +319,18 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	return ret;
 }
 
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags, false);
+}
+
+int bpf_get_link_xdp_tx_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
+{
+	return __bpf_get_link_xdp_info(ifindex, info, info_size, flags, true);
+}
+
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
 	if (info->attach_mode != XDP_ATTACHED_MULTI)
@@ -310,6 +357,18 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return ret;
 }
 
+int bpf_get_link_xdp_tx_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+	struct xdp_link_info info;
+	int ret;
+
+	ret = bpf_get_link_xdp_tx_info(ifindex, &info, sizeof(info), flags);
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
2.21.0

