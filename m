Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A548A41F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 01:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbiAKAA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 19:00:56 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41703 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbiAKAA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 19:00:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1641859256; x=1673395256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gICdaEAh4p+MyAVLOSCLytohV2Gir8+TaSIfK8vCy6o=;
  b=CjIMv03pFQqdxB+Fuw9O5spS4ttTF5jvQXgaf1hRDuhPCWvUJJAPcYA9
   9fqt/WN7nN7lfjyNLv4c89wmvc9RdK2DjletN/cSMeCZ5WwQiOMMJoshS
   YZLKjIzajRuHjiUkA6Ypfu0osluBHRSY5KIIqhXfHPruKB09w60ckZRPs
   g=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 10 Jan 2022 16:00:56 -0800
X-QCInternal: smtphost
Received: from hu-twear-lv.qualcomm.com (HELO hu-devc-sd-u20-a-1.qualcomm.com) ([10.47.235.107])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 10 Jan 2022 16:00:55 -0800
Received: by hu-devc-sd-u20-a-1.qualcomm.com (Postfix, from userid 202676)
        id 623DD5DB; Mon, 10 Jan 2022 16:00:15 -0800 (PST)
From:   Tyler Wear <quic_twear@quicinc.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     maze@google.com, yhs@fb.com, kafai@fb.com, toke@redhat.com,
        daniel@iogearbox.net, song@kernel.org,
        Tyler Wear <quic_twear@quicinc.com>
Subject: [PATCH bpf-next v5 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Date:   Mon, 10 Jan 2022 16:00:00 -0800
Message-Id: <20220111000001.3118189-1-quic_twear@quicinc.com>
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

V4 patch fixes warnings and errors from checkpatch.

The existing check for bpf_try_make_writable() should mean that
skb_share_check() is not needed.

Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
---
 net/core/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6102f093d59a..ce01a8036361 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7299,6 +7299,16 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case BPF_FUNC_skb_cgroup_id:
 		return &bpf_skb_cgroup_id_proto;
-- 
2.25.1

