Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E039012A9CB
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLZCd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:29 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35104 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbfLZCd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:29 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so2855959pjc.0
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vJat+Km7JbIPjxaNWk6YxlLlEXUkWXomfGzNgtFcntw=;
        b=Ppv3MzyK1Yr4KLPRh/ksV/KtdrBpOu2e7vpDgeaVausQJ699qVv1aReqtXW1JhZRci
         xOMKsSwiUd+hGUGVIMDD9WEmAlojzUJWu5Od8BeTL/aqrqlkLEp928E+oRqJrh+zgZ0i
         HV9c+6Cfk0W4xhcDy2QgC/cXxI9eHAsUOymWeaIfYGdgcorx09oeqYsO2x8IJOJpUXHk
         mPVwxeypxkWeDCoTXHGSYaPpgSNg67iaJHI8dnIkuMc5/P5xT27zeDTyTEuBthl4Mc7w
         5sbJJM8MnEMZybIpQTcQDI+UFFcgQlxHiUwIm7AlefZ8fiSL8CBRaaOpHn25ocL7eF+S
         +FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vJat+Km7JbIPjxaNWk6YxlLlEXUkWXomfGzNgtFcntw=;
        b=XUEa/UwYNjDDK3Z65StFNp+V+AC54fbhcB6YkQ0lORqMfWw0SFq9gKiiMluYwXKIoi
         CZaJxlHdDb0Tf68gTr8uypz5njbsvrukyfkntPl9dW08xo/r9mIVjS9bApz02tIUy6aD
         DWVJPv9JJe1pFrdSBOzidvqvMcvIQS3AKN1GKAtmEwZl4cdB3UoaG/gLZwuzz1By6Xfu
         rDDoX6OGtqv3L4v0uu8gmoN1KvhuSrLS+uni66QD66kiVHUecEYwmJhQCZEdRxCCCtTn
         vdwrluBAsFBQoiVAUuAKfs6YFjAUU6/UK5R8V8vw54nD0IaVwrs5i8BfbGw8Gi4/+476
         F9bw==
X-Gm-Message-State: APjAAAU2wfzVbo4kfZzRexGAPKGyjbzJvPRdQ5R150hSYvRiT0jZVAqA
        V4fEWIkq3ZbdgpOkfisCNwptClVP
X-Google-Smtp-Source: APXvYqyjcL0M1CC+ELZ/piPxFJJ2E/JDcxUNe7ruJ689u6EGAiggn4Ndr2PbkhX9gDHQHYHYdXINig==
X-Received: by 2002:a17:902:8207:: with SMTP id x7mr19208221pln.286.1577327608087;
        Wed, 25 Dec 2019 18:33:28 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:27 -0800 (PST)
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
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC v2 net-next 04/12] libbpf: set xdp program in tx path
Date:   Thu, 26 Dec 2019 11:31:52 +0900
Message-Id: <20191226023200.21389-5-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing libbpf APIs to set/get XDP attributes of a link were
written for rx path. This patch extends the new APIs introduced
in last patch. We need to set the tx_path parameter in struct
bpf_link_xdp_opts to attach the program in tx path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/lib/bpf/libbpf.h  |  4 ++++
 tools/lib/bpf/netlink.c | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 8178fd5a1e8f..c073d0eb3bf5 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -449,6 +449,7 @@ struct bpf_link_xdp_opts {
 	__u32 flags;
 	__u32 prog_id;
 	int prog_fd;
+	bool tx_path;
 };
 
 /*
@@ -459,13 +460,16 @@ struct bpf_link_xdp_opts {
  *	- link_info
  *	- link_info_sz
  *	- flags
+ *	- tx_path
  *
  * BPF_LINK_SET_XDP_FD uses fields:
  *	- flags
+ *	- tx_path
  *
  * BPF_LINK_SET_XDP_FD uses fields:
  *	- prog_fd
  *	- flags
+ *	- tx_path
  */
 enum bpf_link_cmd {
 	BPF_LINK_GET_XDP_INFO,
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 1274b540a9ad..c839495e8f03 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -133,6 +133,7 @@ static int __bpf_set_link_xdp_fd(int ifindex, struct bpf_link_xdp_opts *opts)
 {
 	int fd = opts->prog_fd;
 	__u32 flags = opts->flags;
+	bool tx = opts->tx_path;
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
 	struct {
@@ -158,7 +159,8 @@ static int __bpf_set_link_xdp_fd(int ifindex, struct bpf_link_xdp_opts *opts)
 	/* started nested attribute for XDP */
 	nla = (struct nlattr *)(((char *)&req)
 				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
+	nla->nla_type = NLA_F_NESTED;
+	nla->nla_type |= tx ? IFLA_XDP_TX : IFLA_XDP;
 	nla->nla_len = NLA_HDRLEN;
 
 	/* add XDP fd */
@@ -196,6 +198,7 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 
 	opts.prog_fd = fd;
 	opts.flags = flags;
+	/* opts.tx_path is already 0 */
 
 	return bpf_set_link_opts(ifindex, &opts, BPF_LINK_SET_XDP_FD);
 }
@@ -215,20 +218,20 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
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
+	attr = tx ? tb[IFLA_XDP_TX] : tb[IFLA_XDP];
 
-	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, tb[IFLA_XDP], NULL);
+	ret = libbpf_nla_parse_nested(xdp_tb, IFLA_XDP_MAX, attr, NULL);
 	if (ret)
 		return ret;
 
@@ -260,12 +263,27 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
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
 static int __bpf_get_link_xdp_info(int ifindex, struct bpf_link_xdp_opts *opts)
 {
 	struct xdp_link_info *info = opts->link_info;
 	size_t info_size = opts->link_info_sz;
 	struct xdp_id_md xdp_id = {};
 	__u32 flags = opts->flags;
+	int tx = opts->tx_path;
 	int sock, ret;
 	__u32 nl_pid;
 	__u32 mask;
@@ -286,7 +304,11 @@ static int __bpf_get_link_xdp_info(int ifindex, struct bpf_link_xdp_opts *opts)
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
 
@@ -306,6 +328,7 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	opts.link_info = info;
 	opts.link_info_sz = info_size;
 	opts.flags = flags;
+	/* opts.tx_path is already 0 */
 
 	return bpf_get_link_opts(ifindex, &opts, BPF_LINK_GET_XDP_INFO);
 }
@@ -502,6 +525,7 @@ int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
 		int ret;
 
 		tmp_opts.flags = opts->flags;
+		tmp_opts.tx_path = opts->tx_path;
 		tmp_opts.link_info = &link_info;
 		tmp_opts.link_info_sz = sizeof(link_info);
 		ret = __bpf_get_link_xdp_info(ifindex, &tmp_opts);
-- 
2.21.0

