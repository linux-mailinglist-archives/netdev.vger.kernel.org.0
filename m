Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4332A1918B0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgCXSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:13:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51808 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbgCXSNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585073581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfiTCpcsPC45Hnq6DJIEu035E/7yp/pZx+JmbCf++lM=;
        b=DpjuL1SkDeyG2opxVyqcDeDUGWV3OfcUDvKgOyMuA4EQuPMImGvcQhaISCeNxJt77zQIv4
        8jUFhKT5ITQmTmstj+POgfLOjBKMCNdiNLbX7VkGUAe5DtxcL7Jmta9SYQC7/QlpgTplyz
        pax+4PfiuFRHB5PZJs5twK/MShszERg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-bwTnlTrLPNW_215Y-9gcSg-1; Tue, 24 Mar 2020 14:12:57 -0400
X-MC-Unique: bwTnlTrLPNW_215Y-9gcSg-1
Received: by mail-wr1-f69.google.com with SMTP id b11so9574073wru.21
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 11:12:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EfiTCpcsPC45Hnq6DJIEu035E/7yp/pZx+JmbCf++lM=;
        b=i1KLRXwr+3buWPbwjRrnR4j+uXi14XBIXAkMM+/E0I3hDUrbIUD2wAH5CXRIItEqLz
         xW6ePviQc5FFdsAO0zRcs/UuqX0p1JsEXK6xZUKh8IhdA3i8WiI6noDmonAaJOf85yd6
         k6pOnZP0jX40zgamxvC/GRLbkXgCzYVOJL1DwBo1g/lQnYbhipZVsCOruAZeK+x/7EVA
         T+UH63DJWeLj7Kr5vvLR5sv4AqLFiI3BLi7meOiPrXpWC3R6uCFX25DXWinZaQUVPncz
         gxBLq9tjbncDLuFEMEJO7ToVY7YsR4y+KmNtnfjn8od3PXxmfwXsr/7yhK2B7BMkqdZT
         xp5g==
X-Gm-Message-State: ANhLgQ2KL4bq9lioeackX5eEsbZerXXmq35xmy4LkvHPImhD2f2v/hAK
        mBCJYYan2cvwdwDEQGdlSrPTC5dHqMs6rot2trc3IZi4e4MPLWOGwEZxnDAz3IxdA82nLoWhgAM
        culbFk7iCItKGbQLt
X-Received: by 2002:a7b:c308:: with SMTP id k8mr7304366wmj.40.1585073576557;
        Tue, 24 Mar 2020 11:12:56 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvTDjjEHP3nI0RtMl0aOZuDaemDUl+6ctS0MQF8WLGVx5hAhqxHHRRry/p7cre4LRmISV2EMg==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr7304329wmj.40.1585073576309;
        Tue, 24 Mar 2020 11:12:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f12sm5284669wmf.24.2020.03.24.11.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:12:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4E0EC18158C; Tue, 24 Mar 2020 19:12:55 +0100 (CET)
Subject: [PATCH bpf-next v3 3/4] libbpf: Add function to set link XDP fd while
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
Date:   Tue, 24 Mar 2020 19:12:55 +0100
Message-ID: <158507357526.6925.6217863214278001637.stgit@toke.dk>
In-Reply-To: <158507357205.6925.17804771242752938867.stgit@toke.dk>
References: <158507357205.6925.17804771242752938867.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new function to set the XDP fd while specifying the ID of the
program to replace, using the newly added IFLA_XDP_EXPECTED_ID netlink
parameter. The new function uses the opts struct mechanism to be extendable
in the future.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |    8 ++++++++
 tools/lib/bpf/libbpf.map |    1 +
 tools/lib/bpf/netlink.c  |   34 +++++++++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d38d7a629417..2d77bc28b518 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -444,7 +444,15 @@ struct xdp_link_info {
 	__u8 attach_mode;
 };
 
+struct bpf_xdp_set_link_opts {
+	size_t sz;
+	__u32 old_id;
+};
+#define bpf_xdp_set_link_opts__last_field old_id
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
index 431bd25c6cdb..2ae0cf1956f2 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -132,7 +132,8 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
-int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, __u32 old_id,
+					 __u32 flags)
 {
 	int sock, seq = 0, ret;
 	struct nlattr *nla, *nla_xdp;
@@ -178,6 +179,14 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 		nla->nla_len += nla_xdp->nla_len;
 	}
 
+	if (flags & XDP_FLAGS_EXPECT_ID) {
+		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+		nla_xdp->nla_type = IFLA_XDP_EXPECTED_ID;
+		nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_id);
+		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_id, sizeof(old_id));
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
+	__u32 old_id;
+
+	if (!OPTS_VALID(opts, bpf_xdp_set_link_opts))
+		return -EINVAL;
+
+	old_id = OPTS_GET(opts, old_id, 0);
+
+	if (old_id)
+		flags |=  XDP_FLAGS_EXPECT_ID;
+
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd,
+					     old_id,
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

