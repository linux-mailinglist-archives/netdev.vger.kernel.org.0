Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63039170EF1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgB0DUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgB0DUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:22 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4506B24680;
        Thu, 27 Feb 2020 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773622;
        bh=Kzb4/R2uuS+aboCN/KgRKav39A6N1pzSpU181g1pq4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxXVVSvrvtVsAqvMFuG+wTLmwfpQ/Hz5+ano3VqHdhrw0OsPPXTLZOiLLYH7gKvVH
         lm4mrkyh1Dyi4hwo4CaWyc4ju3yivalmlrIoZBIYO2qL71U+Eq0uPzozuOhYwbZ/bC
         PwuTpsnoXVUtOSMQxOi+MYKdKa9wajrCzFFtee6Q=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 02/11] net: Add BPF_XDP_EGRESS as a bpf_attach_type
Date:   Wed, 26 Feb 2020 20:20:04 -0700
Message-Id: <20200227032013.12385-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
at the XDP layer, but the egress path.

Since egress path does not have rx_queue_index set, update
xdp_is_valid_access to block access to this entry in the xdp
context when a program is attached to egress path.

The next patch adds support for the egress ifindex.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 7 +++++++
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 906e9f2752db..7850f8683b81 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -210,6 +210,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 925b23de218b..c7cc98c55621 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6795,6 +6795,13 @@ static bool xdp_is_valid_access(int off, int size,
 				const struct bpf_prog *prog,
 				struct bpf_insn_access_aux *info)
 {
+	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
+		switch (off) {
+		case offsetof(struct xdp_md, rx_queue_index):
+			return false;
+		}
+	}
+
 	if (type == BPF_WRITE) {
 		if (bpf_prog_is_dev_bound(prog->aux)) {
 			switch (off) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 906e9f2752db..7850f8683b81 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -210,6 +210,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.1 (Apple Git-122.3)

