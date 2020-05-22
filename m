Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20231DEF25
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgEVS2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:28:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:5234 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgEVS2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 14:28:14 -0400
IronPort-SDR: NafhwkL0cCOaCqfEgYXGI/11Zeuzh4QQ/Rct9KY9JOqYZ/s58Pa1Rs4QOMScuYQSWH9CS8YEuz
 wslB+nmAWPsQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 11:28:14 -0700
IronPort-SDR: iiC+6OAvZj5sbxzKl/sTk22Tak/OHgOjv+XOJZQO8xoZD4ihQ5tvRGiu6NCbQupfvfdwgty3Y7
 Xc1ttQpf73FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="300750389"
Received: from anambiarhost.jf.intel.com ([10.166.225.93])
  by fmsmga002.fm.intel.com with ESMTP; 22 May 2020 11:28:13 -0700
Subject: [bpf-next PATCH v2] bpf: Add rx_queue_mapping to bpf_sock
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        ast@kernel.org
Cc:     kafai@fb.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Date:   Fri, 22 May 2020 11:28:28 -0700
Message-ID: <159017210823.76267.780907394437543496.stgit@anambiarhost.jf.intel.com>
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

v2: fixed build error for CONFIG_XPS wrapping, reported by
    kbuild test robot <lkp@intel.com>

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/uapi/linux/bpf.h |    1 +
 net/core/filter.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

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
index bd2853d23b50..c4ba92204b73 100644
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
@@ -7872,6 +7873,23 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
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
+		*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);
+		*target_size = 2;
+#endif
+		break;
 	}
 
 	return insn - insn_buf;

