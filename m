Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9292E1D0480
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgEMBq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732097AbgEMBqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:46:18 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23CF32492C;
        Wed, 13 May 2020 01:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589334377;
        bh=06hekma2Y+FUxTbYVja9RUDu/KKq2ZJVX+3fqheaWzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrokJwTH4R556l4NlmBh5x9r36eTDxuoXOhYTRoxt117WpD68c7RO7y/rqWKmrVuj
         fwk5HIsFnIGOyTBAYUB/s8sXbaDUsSUT6j7B79Fah8bwLTFywZDpmTkWzVbKm287RS
         M0FFnhiR1kaSl7uNd0jSx49XxFztOjgW8MHVK500=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v5 bpf-next 08/11] libbpf: Add egress XDP support
Date:   Tue, 12 May 2020 19:46:04 -0600
Message-Id: <20200513014607.40418-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200513014607.40418-1-dsahern@kernel.org>
References: <20200513014607.40418-1-dsahern@kernel.org>
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
index 3da66540b54b..5d1d513d9958 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6635,6 +6635,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_ITER,
 		.is_attach_btf = true,
 		.attach_fn = attach_iter),
+	BPF_EAPROG_SEC("xdp_egress",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_EGRESS),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 8ea69558f0a8..d3ded4b2da02 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -463,6 +463,7 @@ struct xdp_link_info {
 	__u32 hw_prog_id;
 	__u32 skb_prog_id;
 	__u8 attach_mode;
+	__u32 egress_prog_id;
 };
 
 struct bpf_xdp_set_link_opts {
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 312f887570b2..da0b383dbd5d 100644
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
 
@@ -331,6 +335,8 @@ static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 		return info->hw_prog_id;
 	if (flags & XDP_FLAGS_SKB_MODE)
 		return info->skb_prog_id;
+	if (flags & XDP_FLAGS_EGRESS_MODE)
+		return info->egress_prog_id;
 
 	return 0;
 }
-- 
2.21.1 (Apple Git-122.3)

