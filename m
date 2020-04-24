Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5BD1B6B1B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDXCL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgDXCL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:11:56 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74A821569;
        Fri, 24 Apr 2020 02:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694315;
        bh=N66dw5rWx2ocDQhlwX3qzZo9rpfap56N1ignuI/0FsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xeQ6pZnH/0WvKfJz11KKSM8u/ULFAzz6h+rd0OIa1/GxaU1Id5kIV56ZEN9rYJAbX
         9Htf10EJdKapg3Bx1Lh5N6G0tZwmpJQNE2wtw2ozV1HatiPpXweHU2p8Gyz4YicUwk
         E9J7iIntySUNCiqmJLitA3xl683rwcyZWXtUFemc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 04/17] net: Add BPF_XDP_EGRESS as a bpf_attach_type
Date:   Thu, 23 Apr 2020 20:11:35 -0600
Message-Id: <20200424021148.83015-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
at the XDP layer, but the egress path.

Since egress path will not have ingress_ifindex and rx_queue_index
set, update xdp_is_valid_access to block access to these entries in
the xdp context when a program is attached with expected_attach_type
set.

Update dev_change_xdp_fd to verify expected_attach_type for a program
is BPF_XDP_EGRESS if egress argument is set.

The next patch adds support for the egress ifindex.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/dev.c                 | 11 +++++++++++
 net/core/filter.c              | 11 +++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 4 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..a9d384998e8b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 1d0142c1bfb3..853a8209b00d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8732,6 +8732,17 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
+		if (egress && prog->expected_attach_type != BPF_XDP_EGRESS) {
+			NL_SET_ERR_MSG(extack, "XDP program in Tx path must use BPF_XDP_EGRESS attach type");
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+		if (!egress && prog->expected_attach_type == BPF_XDP_EGRESS) {
+			NL_SET_ERR_MSG(extack, "XDP program in Rx path can not use BPF_XDP_EGRESS attach type");
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+
 		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
 			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
 			bpf_prog_put(prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index a943df3ad8b0..b4d064c7fdec 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6935,6 +6935,17 @@ static bool xdp_is_valid_access(int off, int size,
 				const struct bpf_prog *prog,
 				struct bpf_insn_access_aux *info)
 {
+	/* Rx data is only accessible from original XDP where
+	 * expected_attach_type is not set
+	 */
+	if (prog->expected_attach_type) {
+		switch (off) {
+		case offsetof(struct xdp_md, ingress_ifindex):
+		case offsetof(struct xdp_md, rx_queue_index):
+			return false;
+		}
+	}
+
 	if (type == BPF_WRITE) {
 		if (bpf_prog_is_dev_bound(prog->aux)) {
 			switch (off) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2e29a671d67e..a9d384998e8b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.1 (Apple Git-122.3)

