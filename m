Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8648314607D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAWBmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgAWBmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:18 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6152467F;
        Thu, 23 Jan 2020 01:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743738;
        bh=p73DLG0DeVVyfWLxj2RW8Jn5z71wtaOMvfyRMlj49IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INNc/oHdmATyDhPOymPKu6HlOzQUeHW0tCLLXXR0Y0SlTJqHfoIRNP7gRdyLObzjs
         1zB+iBuFVcXpfeMBj7rIu5HQWFE45mmVFh+2uyly/c7miQbHondlnUwif6TAnwJR2a
         +3A61rXRIHc/IRag/ANX1CchFa/BNjvsZi0DeeG0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a bpf_attach_type
Date:   Wed, 22 Jan 2020 18:42:00 -0700
Message-Id: <20200123014210.38412-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
at the XDP layer, but the egress path.

Since egress path does not have rx_queue_index and ingress_ifindex set,
update xdp_is_valid_access to block access to these entries in the xdp
context when a program is attached to egress path.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 8 ++++++++
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 033d90a2282d..72f2a9a4621e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -209,6 +209,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 17de6747d9e3..a903f3a15d74 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6803,6 +6803,14 @@ static bool xdp_is_valid_access(int off, int size,
 		return false;
 	}
 
+	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
+		switch (off) {
+		case offsetof(struct xdp_md, rx_queue_index):
+		case offsetof(struct xdp_md, ingress_ifindex):
+			return false;
+		}
+	}
+
 	switch (off) {
 	case offsetof(struct xdp_md, data):
 		info->reg_type = PTR_TO_PACKET;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 033d90a2282d..72f2a9a4621e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -209,6 +209,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.1 (Apple Git-122.3)

