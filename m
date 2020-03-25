Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B014192F18
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCYRXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:23:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:38783 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727574AbgCYRXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:23:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585157013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDMd/O5PBic7ScwKqsNYeSm5DDRpZ5R5RdB8Gtorr4U=;
        b=ckRPF3rT4mSskdqvZU5uClk/XZOWmeq6LehPQUGOAljF9q2BueG1OEQrRwQnozUBeKr7oU
        6a++1hufeefMfX9QD0H+QCw2UtdtidesBN3U+rceSrt4s1kNJlEZs8U4v01THIwON8FUMj
        k1BRJdsnXSjb23VKCBM821tWh4TEcnI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-JrbHgkPIN1WnOv2eGJ14RA-1; Wed, 25 Mar 2020 13:23:32 -0400
X-MC-Unique: JrbHgkPIN1WnOv2eGJ14RA-1
Received: by mail-lf1-f71.google.com with SMTP id b25so1093979lfi.21
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 10:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NDMd/O5PBic7ScwKqsNYeSm5DDRpZ5R5RdB8Gtorr4U=;
        b=BjgXoUe5MQKJRz+gi47bDrZMey9D7Tm/aFkAEVYHwg7tqCebPs5NwzWcAOx9Q6BaPH
         9x7tJF+h25PJFaYzN1vwhM7YHwYEFSArSM3EESzUOc7Wc9i62ct6tOmgexgwFYW1Y3bG
         VWqBFRSyHPfGlOUyM5BCd/LQo3szch3o3oKxKX1x8NNBdv/D/RsLb2eeDOaRDrdHijak
         h81BU7Ww5RojI97E3OVHOzaytT8WyVIrolROSZTgfWPCMf6Uv0Oz4tf6CK883UMDywJr
         4LepOPUs05W+C5lD255fO/v12JFfqYkS7SENkKd8uRO96M3aw6aaEsBEbn65k0uLRTBW
         CHEw==
X-Gm-Message-State: ANhLgQ117Z0mIMRy11ctPklmene/78DaNkQ4418YcBxQjv4fnojb21NC
        rpVNU3//wO8A+NBRmS6568Oj4z2m0EaN1Xy7P3PC6Ih6QsxQ4KdoX0scaRlIgKHoDSd9QVxLS1l
        +vzVq61Wo/2SKkSXh
X-Received: by 2002:ac2:4110:: with SMTP id b16mr3000199lfi.211.1585157010496;
        Wed, 25 Mar 2020 10:23:30 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsI4ZwpZvLe1BczzDPdX2U8bgqkoW2Rlp0IxzLY/XYR7NnqnDW+rzbbj7Jd8j0pYX2duWIENw==
X-Received: by 2002:ac2:4110:: with SMTP id b16mr3000175lfi.211.1585157010253;
        Wed, 25 Mar 2020 10:23:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b13sm5145733lfp.14.2020.03.25.10.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:23:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A4AE018158D; Wed, 25 Mar 2020 18:23:28 +0100 (CET)
Subject: [PATCH bpf-next v4 3/4] libbpf: Add function to set link XDP fd while
 specifying old program
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Date:   Wed, 25 Mar 2020 18:23:28 +0100
Message-ID: <158515700857.92963.7052131201257841700.stgit@toke.dk>
In-Reply-To: <158515700529.92963.17609642163080084530.stgit@toke.dk>
References: <158515700529.92963.17609642163080084530.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new function to set the XDP fd while specifying the FD of the
program to replace, using the newly added IFLA_XDP_EXPECTED_FD netlink
parameter. The new function uses the opts struct mechanism to be extendable
in the future.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |    8 ++++++++
 tools/lib/bpf/libbpf.map |    1 +
 tools/lib/bpf/netlink.c  |   34 +++++++++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d38d7a629417..bf7a35a9556d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -444,7 +444,15 @@ struct xdp_link_info {
 	__u8 attach_mode;
 };
 
+struct bpf_xdp_set_link_opts {
+	size_t sz;
+	__u32 old_fd;
+};
+#define bpf_xdp_set_link_opts__last_field old_fd
+
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
+LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
+					const struct bpf_xdp_set_link_opts *opts);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5129283c0284..dcc87db3ca8a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -244,4 +244,5 @@ LIBBPF_0.0.8 {
 		bpf_link__pin_path;
 		bpf_link__unpin;
 		bpf_program__set_attach_target;
+		bpf_set_link_xdp_fd_opts;
 } LIBBPF_0.0.7;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 431bd25c6cdb..18b5319025e1 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -132,7 +132,8 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
+					 __u32 flags)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -178,6 +179,14 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 		nla->nla_len += nla_xdp->nla_len;
 	}
 
+	if (flags & XDP_FLAGS_REPLACE) {
+		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+		nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
+		nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_fd);
+		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
+		nla->nla_len += nla_xdp->nla_len;
+	}
+
 	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
 
 	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
@@ -191,6 +200,29 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
+			     const struct bpf_xdp_set_link_opts *opts)
+{
+	int old_fd = -1;
+
+	if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
+		return -EINVAL;
+
+	if (OPTS_HAS(opts, old_fd)) {
+		old_fd = OPTS_GET(opts, old_fd, -1);
+		flags |= XDP_FLAGS_REPLACE;
+	}
+
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd,
+					     old_fd,
+					     flags);
+}
+
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd, 0, flags);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {

