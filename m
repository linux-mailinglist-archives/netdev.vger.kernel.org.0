Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7E1DDBCA
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgEVAKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:10:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:54219 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgEVAKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:10:36 -0400
IronPort-SDR: VJ/ESev0mWJK2J+Dp6UKTII36cCYJZRQE9fXAl+4GHd257TM/2uNRiJEruWMGo/FJ3p1dEzHnA
 RifXEnVTvuuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 17:10:35 -0700
IronPort-SDR: DhJkam1UYAoLfLaMigEUy27JiX3KFDzR8gHtcFHDiFLT86Cu/hdzjm0udKZxQBWkbDEBebQoMn
 3SIaClF9zZvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="467114804"
Received: from anambiarhost.jf.intel.com ([10.166.225.93])
  by fmsmga006.fm.intel.com with ESMTP; 21 May 2020 17:10:35 -0700
Subject: [bpf-next PATCH] bpf: Add rx_queue_mapping to bpf_sock
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        ast@kernel.org
Cc:     kafai@fb.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Date:   Thu, 21 May 2020 17:11:12 -0700
Message-ID: <159010627201.102245.10081199944256681345.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "rx_queue_mapping" to bpf_sock. This gives read access for the
existing field (sk_rx_queue_mapping) of struct sock from bpf_sock.
Semantics for the bpf_sock rx_queue_mapping access are similar to
sk_rx_queue_get(), i.e the value NO_QUEUE_MAPPING is not allowed
and -1 is returned in that case.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/uapi/linux/bpf.h |    1 +
 net/core/filter.c        |   13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 97e1fd19ff58..d2acd5aeae8d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3530,6 +3530,7 @@ struct bpf_sock {
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
+	__u32 rx_queue_mapping;
 };
 
 struct bpf_tcp_sock {
diff --git a/net/core/filter.c b/net/core/filter.c
index bd2853d23b50..ae58957854de 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6829,6 +6829,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, protocol):
 	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
+	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
 	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
 	case bpf_ctx_range(struct bpf_sock, dst_ip4):
@@ -7872,6 +7873,18 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 						    skc_state),
 				       target_size));
 		break;
+	case offsetof(struct bpf_sock, rx_queue_mapping):
+		*insn++ = BPF_LDX_MEM(
+			BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
+			si->dst_reg, si->src_reg,
+			bpf_target_off(struct sock, sk_rx_queue_mapping,
+				       sizeof_field(struct sock,
+						    sk_rx_queue_mapping),
+				       target_size));
+		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
+				      1);
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
+		break;
 	}
 
 	return insn - insn_buf;

