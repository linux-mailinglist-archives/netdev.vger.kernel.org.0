Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B8812A9CA
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfLZCdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:25 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53796 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:25 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so2759477pjc.3
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YySDDXNNcuRvRsmkiqMA4jjknQnrxQ7tDsGiPBtlWkE=;
        b=QpUXAgqq/E5btgrhLDmPhdydzG+HMTX7FBLJBw/JyFL4+SiaWEmaY/a54+1Wh5H1za
         KnA82bCKNR1dqNWNLM81uFiL/inm51m9uQdt1txJdKGqo7cbIpPWhO1j7NdjWURh9PmP
         4osYjijj459ayVuEXpHEc9gvCiH63zQioL8YDrSN4BMwXZXb23eRZ5Z9+zKssTcotHue
         3iNzv54kQtweiWSawt6n9GvE8WUBcNtWxNAd9VD9pUICHkWAZjtqlGvY7+5FZSwAabED
         l4WM/62hmJU5PfoXQWXCkI+l4GSeH3+nkkG41PcW9A2+UH1jf7kIqjSJlgqkyVR98HLy
         BaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YySDDXNNcuRvRsmkiqMA4jjknQnrxQ7tDsGiPBtlWkE=;
        b=QSeHrdHDjVvNwOxlhyh0NSUwa4rMg3ONDkRD+C1URyyanpD6lnSNAVjzWfW9l/HNgr
         qb1t56QyYsH1Vbr9WZywYSxX9d4TYX5GkJOoBW6vl/Ik8/HtSwP/m+xSJ0O5Cldc/2Om
         ZIwaEiW3Mpuq8xf3pgJwc1zsYZ0UpJGs/LoXUWd72W7Hs1sHloni7V5g+nTmccJKGQnD
         He2samWBbgdIehayS9nAWgWI8HpKiOAHqmpFNgQmw5xUdAKb6RQbirorKXZYcAmbBviT
         yekOkqOckb24Sbh7jDl/SskoWyQAfEO5/2PGt7LL78X/NUN80VUKnHnzzKztS+A69kl1
         eNEA==
X-Gm-Message-State: APjAAAWUgVGEO5sWklMCW8gkIYN/LUSdn7azLAf4OHInriFG5G27LmN2
        HmOrF7THxa1rzk2OGxk3etlPOZgA
X-Google-Smtp-Source: APXvYqxrfUfFJuRAyMqG+ItQ4kIBIOfgE9qafy4DcwVx370R4QKG10yYXv8f8j2AGvPgiJ/yX/zBNw==
X-Received: by 2002:a17:902:8bc5:: with SMTP id r5mr45325936plo.189.1577327604339;
        Wed, 25 Dec 2019 18:33:24 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:23 -0800 (PST)
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
Subject: [RFC v2 net-next 03/12] libbpf: api for getting/setting link xdp options
Date:   Thu, 26 Dec 2019 11:31:51 +0900
Message-Id: <20191226023200.21389-4-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces and uses new APIs:

struct bpf_link_xdp_opts {
        struct xdp_link_info *link_info;
        size_t link_info_sz;
        __u32 flags;
        __u32 prog_id;
        int prog_fd;
};

enum bpf_link_cmd {
	BPF_LINK_GET_XDP_INFO,
	BPF_LINK_GET_XDP_ID,
	BPF_LINK_SET_XDP_FD,
};

int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
		      enum bpf_link_cmd cmd);
int bpf_set_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
		      enum bpf_link_cmd cmd);

The operations performed by these two functions are equivalent to
existing APIs.

BPF_LINK_GET_XDP_ID equivalent to bpf_get_link_xdp_id()
BPF_LINK_SET_XDP_FD equivalent to bpf_set_link_xdp_fd()
BPF_LINK_GET_XDP_INFO equivalent to bpf_get_link_xdp_info()

It will be easy to extend this API by adding members in struct
bpf_link_xdp_opts and adding different operations. Next patch
will extend this API to set XDP program in the tx path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 tools/lib/bpf/libbpf.h   | 36 +++++++++++++++++++
 tools/lib/bpf/libbpf.map |  2 ++
 tools/lib/bpf/netlink.c  | 77 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 109 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..8178fd5a1e8f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -443,10 +443,46 @@ struct xdp_link_info {
 	__u8 attach_mode;
 };
 
+struct bpf_link_xdp_opts {
+	struct xdp_link_info *link_info;
+	size_t link_info_sz;
+	__u32 flags;
+	__u32 prog_id;
+	int prog_fd;
+};
+
+/*
+ * enum values below are set of commands to get and set/get XDP related
+ * attributes to a link. These are used along with struct bpf_link_xdp_opts.
+ *
+ * BPF_LINK_GET_XDP_INFO uses fields:
+ *	- link_info
+ *	- link_info_sz
+ *	- flags
+ *
+ * BPF_LINK_SET_XDP_FD uses fields:
+ *	- flags
+ *
+ * BPF_LINK_SET_XDP_FD uses fields:
+ *	- prog_fd
+ *	- flags
+ */
+enum bpf_link_cmd {
+	BPF_LINK_GET_XDP_INFO,
+	BPF_LINK_GET_XDP_ID,
+	BPF_LINK_SET_XDP_FD,
+};
+
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
+LIBBPF_API __u32 bpf_get_link_xdp_info_id(struct xdp_link_info *info,
+					  __u32 flags);
+LIBBPF_API int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
+				 enum bpf_link_cmd cmd);
+LIBBPF_API int bpf_set_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
+				 enum bpf_link_cmd cmd);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8ddc2c40e482..332522fb5853 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -207,4 +207,6 @@ LIBBPF_0.0.6 {
 		bpf_program__size;
 		btf__find_by_name_kind;
 		libbpf_find_vmlinux_btf_id;
+		bpf_set_link_opts;
+		bpf_get_link_opts;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 5065c1aa1061..1274b540a9ad 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -129,8 +129,10 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd(int ifindex, struct bpf_link_xdp_opts *opts)
 {
+	int fd = opts->prog_fd;
+	__u32 flags = opts->flags;
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
 	struct {
@@ -188,6 +190,16 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	struct bpf_link_xdp_opts opts = {};
+
+	opts.prog_fd = fd;
+	opts.flags = flags;
+
+	return bpf_set_link_opts(ifindex, &opts, BPF_LINK_SET_XDP_FD);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
@@ -248,10 +260,12 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
-int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
-			  size_t info_size, __u32 flags)
+static int __bpf_get_link_xdp_info(int ifindex, struct bpf_link_xdp_opts *opts)
 {
+	struct xdp_link_info *info = opts->link_info;
+	size_t info_size = opts->link_info_sz;
 	struct xdp_id_md xdp_id = {};
+	__u32 flags = opts->flags;
 	int sock, ret;
 	__u32 nl_pid;
 	__u32 mask;
@@ -284,6 +298,18 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	return ret;
 }
 
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
+{
+	struct bpf_link_xdp_opts opts = {};
+
+	opts.link_info = info;
+	opts.link_info_sz = info_size;
+	opts.flags = flags;
+
+	return bpf_get_link_opts(ifindex, &opts, BPF_LINK_GET_XDP_INFO);
+}
+
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
 	if (info->attach_mode != XDP_ATTACHED_MULTI)
@@ -300,12 +326,13 @@ static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 
 int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 {
-	struct xdp_link_info info;
+	struct bpf_link_xdp_opts opts = {};
 	int ret;
 
-	ret = bpf_get_link_xdp_info(ifindex, &info, sizeof(info), flags);
+	opts.flags = flags;
+	ret =  bpf_get_link_opts(ifindex, &opts, BPF_LINK_GET_XDP_ID);
 	if (!ret)
-		*prog_id = get_xdp_id(&info, flags);
+		*prog_id = opts.prog_id;
 
 	return ret;
 }
@@ -449,3 +476,41 @@ int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int handle,
 	return bpf_netlink_recv(sock, nl_pid, seq, __dump_filter_nlmsg,
 				dump_filter_nlmsg, cookie);
 }
+
+int bpf_set_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
+		      enum bpf_link_cmd cmd)
+{
+	switch (cmd) {
+	case BPF_LINK_SET_XDP_FD:
+		return __bpf_set_link_xdp_fd(ifindex, opts);
+	case BPF_LINK_GET_XDP_INFO:
+	case BPF_LINK_GET_XDP_ID:
+	default:
+		return -EINVAL;
+	}
+}
+
+int bpf_get_link_opts(int ifindex, struct bpf_link_xdp_opts *opts,
+		      enum bpf_link_cmd cmd)
+{
+	switch (cmd) {
+	case BPF_LINK_GET_XDP_INFO:
+		return __bpf_get_link_xdp_info(ifindex, opts);
+	case BPF_LINK_GET_XDP_ID: {
+		struct bpf_link_xdp_opts tmp_opts = {};
+		struct xdp_link_info link_info = {};
+		int ret;
+
+		tmp_opts.flags = opts->flags;
+		tmp_opts.link_info = &link_info;
+		tmp_opts.link_info_sz = sizeof(link_info);
+		ret = __bpf_get_link_xdp_info(ifindex, &tmp_opts);
+		if (!ret)
+			opts->prog_id = get_xdp_id(&link_info, opts->flags);
+		return ret;
+	}
+	case BPF_LINK_SET_XDP_FD:
+	default:
+		return -EINVAL;
+	}
+}
-- 
2.21.0

