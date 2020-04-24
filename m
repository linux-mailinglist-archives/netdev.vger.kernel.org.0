Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66F81B804E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 22:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgDXUO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 16:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgDXUOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 16:14:42 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81830214AF;
        Fri, 24 Apr 2020 20:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587759282;
        bh=RAfY3yvO7eaBb7Pp+Mv9Vaaz4e3kAJvkE+lk4Adppyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iflG14Bp24xRw3pKp52vaCEBgd4XXzKpEvDWWhWzo0ddZb6oqbb3rzL10KFkQ0zBf
         Xekl0VjmjPQmT0oO2JOWf1FahJnypEcdSxYJrswuQNcHggW7WrCigEaPkk0cPYe4Y8
         +ducc/rV3VZFHsSoumaNe7sLfD8pO5nPb3kzKOsM=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v3 bpf-next 11/15] libbpf: Add egress XDP support
Date:   Fri, 24 Apr 2020 14:14:24 -0600
Message-Id: <20200424201428.89514-12-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

New section name hint, xdp_egress, is added to set expected attach
type at program load. Programs can use xdp_egress as the prefix in
the SEC statement to load the program with the BPF_XDP_EGRESS
attach type set.

egress_prog_id is added to xdp_link_info to report the program
id.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/lib/bpf/libbpf.c  | 2 ++
 tools/lib/bpf/libbpf.h  | 1 +
 tools/lib/bpf/netlink.c | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..32fc970495d9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6366,6 +6366,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.is_attach_btf = true,
 		.expected_attach_type = BPF_LSM_MAC,
 		.attach_fn = attach_lsm),
+	BPF_EAPROG_SEC("xdp_egress",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_EGRESS),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f1dacecb1619..445c3789faa4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -454,6 +454,7 @@ struct xdp_link_info {
 	__u32 hw_prog_id;
 	__u32 skb_prog_id;
 	__u8 attach_mode;
+	__u32 egress_prog_id;
 };
 
 struct bpf_xdp_set_link_opts {
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 0b709fd10bba..072d3552248b 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -280,6 +280,10 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 		xdp_id->info.hw_prog_id = libbpf_nla_getattr_u32(
 			xdp_tb[IFLA_XDP_HW_PROG_ID]);
 
+	if (xdp_tb[IFLA_XDP_EGRESS_PROG_ID])
+		xdp_id->info.egress_prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_EGRESS_PROG_ID]);
+
 	return 0;
 }
 
@@ -329,6 +333,8 @@ static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 		return info->hw_prog_id;
 	if (flags & XDP_FLAGS_SKB_MODE)
 		return info->skb_prog_id;
+	if (flags & XDP_FLAGS_EGRESS_MODE)
+		return info->egress_prog_id;
 
 	return 0;
 }
-- 
2.21.1 (Apple Git-122.3)

