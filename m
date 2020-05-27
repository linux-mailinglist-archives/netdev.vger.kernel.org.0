Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36FE1E3413
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgE0AeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:34:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:52628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgE0AeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 20:34:13 -0400
IronPort-SDR: hvcz7cBo4pbsJAq8P82uBDJkmgHAEWizofTSMdHXDzVpl4bzpfDte4csk69N7r8vCjAbB8Zo6E
 8N5CdkBzLNfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 17:34:12 -0700
IronPort-SDR: om6wyg0L9T4F+CWuTgo9j8SkUiok+xpxagdRHtQfFkoDytmqpIpMn1PECfFdLpAFJAGJiS9S8B
 mV2oPYe5N6iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="414008666"
Received: from anambiarhost.jf.intel.com ([10.166.224.176])
  by orsmga004.jf.intel.com with ESMTP; 26 May 2020 17:34:12 -0700
Subject: [bpf-next PATCH v3] bpf: Add rx_queue_mapping to bpf_sock
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        ast@kernel.org
Cc:     kafai@fb.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Date:   Tue, 26 May 2020 17:34:36 -0700
Message-ID: <159053967673.36091.13796251125796306358.stgit@anambiarhost.jf.intel.com>
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
and -1 is returned in that case. This is useful for transmit queue
selection based on the received queue index which is cached in the
socket in the receive path.

v3: Addressed review comments to add usecase in patch description,
    and fixed default value for rx_queue_mapping.
v2: fixed build error for CONFIG_XPS wrapping, reported by
    kbuild test robot <lkp@intel.com>

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/uapi/linux/bpf.h |    1 +
 net/core/filter.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54b93f8b49b8..2a833f23c09f 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3530,6 +3530,7 @@ struct bpf_sock {
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
+	__s32 rx_queue_mapping;
 };
 
 struct bpf_tcp_sock {
diff --git a/net/core/filter.c b/net/core/filter.c
index a6fc23447f12..0008b029d644 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6849,6 +6849,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, protocol):
 	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
+	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
 	case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
 	case bpf_ctx_range(struct bpf_sock, dst_ip4):
@@ -7897,6 +7898,23 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 						    skc_state),
 				       target_size));
 		break;
+	case offsetof(struct bpf_sock, rx_queue_mapping):
+#ifdef CONFIG_XPS
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
+#else
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
+		*target_size = 2;
+#endif
+		break;
 	}
 
 	return insn - insn_buf;

