Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8D418D517
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCTQ4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:56:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51768 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727636AbgCTQ4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584723375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/kUFoLbkDwJxBHQR60+eXJpgtbwabFaqSxr61HTPqBQ=;
        b=OnG56IueNrkGCOhcs4pnMKU3/VcYZrShM/H9Qj1PkINm8Q8wPPrP8541F1H1Fpi/VQtC3l
        Jkh01pSRORY9WnV4Whk/rH7Mj2jdKa2XHO+NDZD5Cpcv/Sb6AhLBTRI/WWjXmzAHhauPLR
        ByCGSfihvWD7JArw8QaW7jjKptCjasE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-JfQmE8B3PN2iZF6WsQXsHA-1; Fri, 20 Mar 2020 12:56:14 -0400
X-MC-Unique: JfQmE8B3PN2iZF6WsQXsHA-1
Received: by mail-wr1-f69.google.com with SMTP id d1so1760831wru.15
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/kUFoLbkDwJxBHQR60+eXJpgtbwabFaqSxr61HTPqBQ=;
        b=tuI2gkHnTGk48urIjJvHxoYX5oTVznPEo/dHLMHdyNv53GDTtE7Q9n45k0T+7ppEIw
         IPx7uKPXgwbpP3JNYkVX6Mo0CSrMHQJB6XTw1Z6CXmVXrLlwd4ZnnsqKGkff7yKdvVv4
         ko2D2g4VpKfVAmpDcM+wipEUcU5Flty1ZT82YHVRdXzbUJHlkHlsxjv7JB/OMf9jh1eZ
         sKRcveAkZgRFZoxNVthdi37/arxVTD+KEHj5tVy+pJ6TEKQp8jIpbYVcIck3aT/yY0/h
         LMsF5fkNB5ZTfD0lZ9UYVk+7VOfsRGCNZ8Dp7mejffs2i4ES1OxP09Z0H8t36Id0F52b
         6Vww==
X-Gm-Message-State: ANhLgQ25tASssXYuQnCcA7ajN1NRMBW37mWsocAKmpx80dvpOsRFo9Dw
        ZztCZF2xwtiB2sSwLbccU3T2Tms8fjBHi2iFvWOJH3k7ge5wOpvLomx5+qK1S2206VSW4vB0Anu
        svI9y5wsPV3VJHAgG
X-Received: by 2002:a1c:a950:: with SMTP id s77mr11146310wme.176.1584723373328;
        Fri, 20 Mar 2020 09:56:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvMik0iRmwMBQj7DF+lo8d9S6Cpw8oix9vIJUrN9OJKTqhA7yQP5oBoFaedtovYEOzOwWkxaw==
X-Received: by 2002:a1c:a950:: with SMTP id s77mr11146273wme.176.1584723373070;
        Fri, 20 Mar 2020 09:56:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x24sm8328196wmc.36.2020.03.20.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:56:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D3A0218038E; Fri, 20 Mar 2020 17:56:10 +0100 (CET)
Subject: [PATCH bpf-next v2 3/4] libbpf: Add function to set link XDP fd while
 specifying old fd
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 20 Mar 2020 17:56:10 +0100
Message-ID: <158472337077.296548.4666186362987360141.stgit@toke.dk>
In-Reply-To: <158472336748.296548.5028326196275429565.stgit@toke.dk>
References: <158472336748.296548.5028326196275429565.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a new function to set the XDP fd while specifying the old fd to
replace, using the newly added IFLA_XDP_EXPECTED_FD netlink parameter.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |    2 ++
 tools/lib/bpf/libbpf.map |    1 +
 tools/lib/bpf/netlink.c  |   22 +++++++++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d38d7a629417..b5ca4f741e28 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -445,6 +445,8 @@ struct xdp_link_info {
 };
 
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
+LIBBPF_API int bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
+					   __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 				     size_t info_size, __u32 flags);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5129283c0284..154f1d94fa63 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -244,4 +244,5 @@ LIBBPF_0.0.8 {
 		bpf_link__pin_path;
 		bpf_link__unpin;
 		bpf_program__set_attach_target;
+		bpf_set_link_xdp_fd_replace;
 } LIBBPF_0.0.7;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 431bd25c6cdb..39bd0ead1546 100644
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
 
+	if (flags & XDP_FLAGS_EXPECT_FD) {
+		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
+		nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
+		nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
+		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
+		nla->nla_len += nla_xdp->nla_len;
+	}
+
 	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
 
 	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
@@ -191,6 +200,17 @@ int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 	return ret;
 }
 
+int bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd, old_fd,
+					     flags | XDP_FLAGS_EXPECT_FD);
+}
+
+int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
+{
+	return __bpf_set_link_xdp_fd_replace(ifindex, fd, -1, flags);
+}
+
 static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 			     libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {

