Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C04E1BB199
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgD0Wql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbgD0Wql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:41 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78265218AC;
        Mon, 27 Apr 2020 22:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027600;
        bh=BFuXlfxMZa9azkbkOEohg1/CeTg2faDSoGAWTRw1z4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qc277ur7MSsY8u/k1cKWAGR7sJiSBxbsryKxabGLvAcm6mXdX1uR7DrZGZDUwZBAJ
         +qfr4IzJq/oKa5gtUHtt8361hQmCe7TsuF948M/tYzG9dHFKuuXXQk05wCwGwNcWdR
         hk5G2d3eaCHF03uPaDfHeUykZ8yhlwjr6HOlmJlg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 04/15] net: Add BPF_XDP_EGRESS as a bpf_attach_type
Date:   Mon, 27 Apr 2020 16:46:22 -0600
Message-Id: <20200427224633.15627-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200427224633.15627-1-dsahern@kernel.org>
References: <20200427224633.15627-1-dsahern@kernel.org>
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
Co-developed-by: David Ahern <dahern@digitalocean.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/uapi/linux/bpf.h       |  1 +
 net/core/dev.c                 | 11 +++++++++++
 net/core/filter.c              | 11 +++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 4 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a6c47f3febe..c89da2c2b1f2 100644
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
index c0455e764f97..88672ea4fc80 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8737,6 +8737,17 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
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
index da3b7a72c37c..00e1941137ab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6861,6 +6861,17 @@ static bool xdp_is_valid_access(int off, int size,
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
index 4a6c47f3febe..c89da2c2b1f2 100644
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

