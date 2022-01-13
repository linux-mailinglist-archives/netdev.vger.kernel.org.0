Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5148D019
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 02:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiAMBXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 20:23:50 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:11420 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiAMBXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 20:23:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1642037030; x=1673573030;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6ph6n4YQZDHx2uUf66SpdKnhLzjJC98Lh1CfAy4+v3s=;
  b=lUI+9M+btFym1I7vMYXMO+5IdDYZLLhL4gRLCBLJCrZyVboAX4jDrv08
   wbMGX80OeICAsKMR6SRgjg3R7UY/mbU0PF2i+BoW7+6z6LzPmkFpykqTE
   Aw0jYMjsR8jte5f9P4fOgLBEyImd9bBWdexUO2NGUwL+8Z7uYuT2wPN2S
   4=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 12 Jan 2022 17:23:49 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-sd-u20-a-1.qualcomm.com) ([10.47.235.107])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 12 Jan 2022 17:23:49 -0800
Received: by hu-devc-sd-u20-a-1.qualcomm.com (Postfix, from userid 202676)
        id 5BEF45DA; Wed, 12 Jan 2022 17:23:49 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        daniel@iogearbox.net, song@kernel.org,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH bpf-next v7 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Date:   Wed, 12 Jan 2022 17:23:33 -0800
Message-Id: <20220113012334.558689-1-quic_twear@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
Instead of adding generic function for just modifying the ds field,
add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
This allows other fields in the network and transport header to be
modified in the future.

Checksum API's also need to be added for completeness.

It is not possible to use CGROUP_(SET|GET)SOCKOPT since
the policy may change during runtime and would result
in a large number of entries with wildcards.

The existing check for bpf_try_make_writable() should mean that
skb_share_check() is not needed.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 net/core/filter.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..f30d939cb4cf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7299,6 +7299,18 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_delete_proto;
 	case BPF_FUNC_perf_event_output:
 		return &bpf_skb_event_output_proto;
+	case BPF_FUNC_skb_store_bytes:
+		return &bpf_skb_store_bytes_proto;
+	case BPF_FUNC_csum_update:
+		return &bpf_csum_update_proto;
+	case BPF_FUNC_csum_level:
+		return &bpf_csum_level_proto;
+	case BPF_FUNC_l3_csum_replace:
+		return &bpf_l3_csum_replace_proto;
+	case BPF_FUNC_l4_csum_replace:
+		return &bpf_l4_csum_replace_proto;
+	case BPF_FUNC_csum_diff:
+		return &bpf_csum_diff_proto;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
-- 
2.25.1

