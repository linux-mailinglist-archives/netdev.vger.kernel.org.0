Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B332C89AD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfJBNaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbfJBNai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:38 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B1A95117D
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:37 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id q185so4862097ljb.20
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9HOtLr1nND6QqUI8Q8VdibuQQQmxuKzuYOHS9mRlR1E=;
        b=TVZq4ZB6D1/j316fuwRFLGWMjHOjVPrvlg9zH4Kfsu2fQ3ZL744MWWAAQs8Da2Wj1e
         6x+KtryUP1IBlhcmVkY92xwJgNU+gtAuCO0br6ueJdTiUtAZiv0z9qrmOHHgazKgaT/g
         cok2ar0ZGCkXPz4/TSMRwz6QqeUPQ8sNQhF4dVtjcpy5SKzyRtj5SwV+AjmpvqQomWpD
         6MkyI2YYHug9g7m59RqaWC/6xsvuEf+YoJm/5XH1h3p8iP1OvIVplXIIDTqIbmER81tz
         vx7ay3srnVNT5pv1UZyp3cSXNx42+hgrSQuGkh+fp7t8QW2PAnJzHcFdXVMjVJNX4g+k
         ppQA==
X-Gm-Message-State: APjAAAV83b4gKuGVudmnkvwxwh5D2tTYKidRj17lcuWvHXj7INznDhll
        qO+/5KPAZq2Y5i71O8Us5ql2WT6txP85jVHR+PltJk8iUhVUbllzaXv/zuBcv3PCFnhElMgwdt4
        HTEEZrYH+J3cN0zXm
X-Received: by 2002:a19:f111:: with SMTP id p17mr2355940lfh.187.1570023036089;
        Wed, 02 Oct 2019 06:30:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy9kGDVLmWBlBvzv2M3kxJrEQfwC6ZwPk5RsZde6tZUzWzlKrvuyJvNTEy7zCPgqiLgNzPocA==
X-Received: by 2002:a19:f111:: with SMTP id p17mr2355926lfh.187.1570023035866;
        Wed, 02 Oct 2019 06:30:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id s6sm145355ljg.43.2019.10.02.06.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5B94F180640; Wed,  2 Oct 2019 15:30:33 +0200 (CEST)
Subject: [PATCH bpf-next 8/9] libbpf: Add support for setting and getting XDP
 chain maps
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:33 +0200
Message-ID: <157002303329.1302756.18388939731361871849.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds two new API functions for setting and getting XDP programs with
associated chain map IDs. Programs are expected to pair them, so that if a
program uses the chain map-aware setter, it should also use the associated
getter.

Programs using the old non-chain aware variants of the functions will not
set the XDP chain map attribute on the netlink message, resulting in the
kernel rejecting the command if a chain map has already been loaded.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |    4 ++++
 tools/lib/bpf/libbpf.map |    2 ++
 tools/lib/bpf/netlink.c  |   49 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..0a459840e32c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -357,7 +357,11 @@ LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
 			     struct bpf_object **pobj, int *prog_fd);
 
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
+LIBBPF_API int bpf_set_link_xdp_chain(int ifindex, int prog_fd, int chain_map_fd,
+				      __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_chain(int ifindex, __u32 *prog_id, __u32 *chain_map_id,
+				      __u32 flags);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8d10ca03d78d..59f412680292 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -192,4 +192,6 @@ LIBBPF_0.0.5 {
 } LIBBPF_0.0.4;
 
 LIBBPF_0.0.6 {
+		bpf_set_link_xdp_chain;
+		bpf_get_link_xdp_chain;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index ce3ec81b71c0..c6f63bdab2e6 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -25,6 +25,7 @@ struct xdp_id_md {
 	int ifindex;
 	__u32 flags;
 	__u32 id;
+	__u32 chain_map_id;
 };
 
 int libbpf_netlink_open(__u32 *nl_pid)
@@ -128,7 +129,8 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd(int ifindex, int *prog_fd, int *chain_map_fd,
+				 __u32 flags)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -162,9 +164,19 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
 	nla_xdp->nla_type = IFLA_XDP_FD;
 	nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
-	memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
+	memcpy((char *)nla_xdp + NLA_HDRLEN, prog_fd, sizeof(*prog_fd));
 	nla->nla_len += nla_xdp->nla_len;
 
+	if (chain_map_fd) {
+		/* add XDP chain map */
+		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+		nla_xdp->nla_type = IFLA_XDP_CHAIN_MAP_FD;
+		nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
+		memcpy((char *)nla_xdp + NLA_HDRLEN, chain_map_fd,
+		       sizeof(*chain_map_fd));
+		nla->nla_len += nla_xdp->nla_len;
+	}
+
 	/* if user passed in any flags, add those too */
 	if (flags) {
 		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
@@ -187,6 +199,17 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_chain(int ifindex, int prog_fd, int chain_map_fd,
+			   __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, &prog_fd, &chain_map_fd, flags);
+}
+
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd(ifindex, &fd, NULL, flags);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {
@@ -247,10 +270,13 @@ static int get_xdp_id(void *cookie, void *msg, struct nlattr **tb)
 
 	xdp_id->id = libbpf_nla_getattr_u32(xdp_tb[xdp_attr]);
 
+	if (xdp_tb[IFLA_XDP_CHAIN_MAP_ID])
+		xdp_id->chain_map_id = libbpf_nla_getattr_u32(xdp_tb[IFLA_XDP_CHAIN_MAP_ID]);
+
 	return 0;
 }
 
-int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+static int __bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 *chain_map_id, __u32 flags)
 {
 	struct xdp_id_md xdp_id = {};
 	int sock, ret;
@@ -274,13 +300,28 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	xdp_id.flags = flags;
 
 	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_id, &xdp_id);
-	if (!ret)
+	if (!ret) {
 		*prog_id = xdp_id.id;
 
+		if (chain_map_id)
+			*chain_map_id = xdp_id.chain_map_id;
+	}
+
 	close(sock);
 	return ret;
 }
 
+int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+	return __bpf_get_link_xdp_id(ifindex, prog_id, NULL, flags);
+}
+
+int bpf_get_link_xdp_chain(int ifindex, __u32 *prog_id, __u32 *chain_map_id,
+			   __u32 flags)
+{
+	return __bpf_get_link_xdp_id(ifindex, prog_id, chain_map_id, flags);
+}
+
 int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {

