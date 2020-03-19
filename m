Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7F218B779
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgCSNdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:33:42 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54111 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgCSNNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:13:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/kUFoLbkDwJxBHQR60+eXJpgtbwabFaqSxr61HTPqBQ=;
        b=WATt6LsoHCb6JnwPC4FugBPcf34oV0T4HaPAGQEXex7ZyO1g9nxOhIsV1HK9+VrBUnLzop
        lJDUSxJ7gOuIMaWS9UlEgk5X2ECgaH7sPXpjACwiTy2bKTmg6FU8Vv/vaDeoYr6wHx2v66
        EJoq/9ZTf4JFmcgIrtVXkuZ6wszdEAw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61--mtAwPDKOD6iirygXAW4sA-1; Thu, 19 Mar 2020 09:13:19 -0400
X-MC-Unique: -mtAwPDKOD6iirygXAW4sA-1
Received: by mail-wr1-f69.google.com with SMTP id q18so990565wrw.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/kUFoLbkDwJxBHQR60+eXJpgtbwabFaqSxr61HTPqBQ=;
        b=FrBe+zsXPUVyif3aJctTTMCfxK2m/MT9sPEItmxlYs+AxFJ/K+cuWDHRjlXNIFSu/V
         eRG2KGKZQG1Sf3DL9tQsEUhXW/2YTttTADXJtj2eUBEZO2crwV0c8B2jJaoAKt+YfWEa
         7yTTm9UDjkX7Ia2UzrJDkxw7MbriohcvIPO9IWUiM0DKnOyt94SCraTwpdJ0mVYm/5MJ
         V6dIrClqdyfWtf1OPcVo64WvmbLQ+7YZXsPBA9QngkKhl+yZJEb16yNVaq91K4P2xzxW
         yH7Jqw4mysA0NAY1/WDYYMCr8tYSNqK9WKCt+tHCZW+d4Sq6/jXfMRYuYyT2Nr9/GWcn
         yFjA==
X-Gm-Message-State: ANhLgQ3cMGbQlYRDC4jpSxApd8ZMz3SXjJvjdiXcrOz7jCjETxsE+8HW
        2iBi5dAWjsPrb8FVaAMD7bnTF58cV6PnK3Q4l2l7HrL4QhYcVPu8DxKvEi0tb/XYxhtEKCYqu+z
        +86i3fIyfk95K1G91
X-Received: by 2002:a1c:b144:: with SMTP id a65mr3924152wmf.54.1584623598213;
        Thu, 19 Mar 2020 06:13:18 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtb4AFemoXjuxCguui6x5/tVwN8upTBqzpFjs8i3B/Neo6gumRxsaU0uvtR50TUfxR1z1K9zw==
X-Received: by 2002:a1c:b144:: with SMTP id a65mr3924119wmf.54.1584623598017;
        Thu, 19 Mar 2020 06:13:18 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f15sm3429776wru.83.2020.03.19.06.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 06:13:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 621DE18038E; Thu, 19 Mar 2020 14:13:15 +0100 (CET)
Subject: [PATCH bpf-next 3/4] libbpf: Add function to set link XDP fd while
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
Date:   Thu, 19 Mar 2020 14:13:15 +0100
Message-ID: <158462359530.164779.12468969809718921559.stgit@toke.dk>
In-Reply-To: <158462359206.164779.15902346296781033076.stgit@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
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

