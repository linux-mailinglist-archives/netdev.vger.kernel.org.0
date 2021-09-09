Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B202405F36
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 00:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbhIIWFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 18:05:46 -0400
Received: from novek.ru ([213.148.174.62]:36534 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343758AbhIIWFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 18:05:45 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 69D8550408C;
        Fri, 10 Sep 2021 01:01:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 69D8550408C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1631224880; bh=ke3RGdGe1SB7wmL/INAR3Bz0BQEsf0ZOyV2eB/RGMmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPuP57APZIZFtVfFuXW0eweTgSIgcqPN31d2xuJrPuBMIa47Hp6RhlpNpQSQKQvm1
         S6TyKAh5qsoPGYdCiHcO00a6uni6VcJla9H7ypHSMVX2Gvjjt6LFkkBwLEgwPn5E74
         0uMhiJ9UvhDe+tWrPdtNY//tGI9EwxOgRV/jqe8o=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 1/2] bpf: add hardware timestamp field to __sk_buff
Date:   Fri, 10 Sep 2021 01:04:08 +0300
Message-Id: <20210909220409.8804-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210909220409.8804-1-vfedorenko@novek.ru>
References: <20210909220409.8804-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF programs may want to know hardware timestamps if NIC supports
such timestamping.

Expose this data as hwtstamp field of __sk_buff the same way as
gso_segs/gso_size. This field could be accessed from the same
programs as tstamp field, but it's read-only field. Explicit test
to deny access to padding data is added to bpf_skb_is_valid_access.

Also update BPF_PROG_TEST_RUN tests of the feature.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h       |  2 ++
 net/core/filter.c              | 21 +++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 791f31dd0abe..51cfd91cc387 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5284,6 +5284,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u32 :32;		/* Padding, future use. */
+	__u64 hwtstamp;
 };
 
 struct bpf_tunnel_key {
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..4bace37a6a44 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7765,6 +7765,10 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 		break;
 	case bpf_ctx_range_ptr(struct __sk_buff, flow_keys):
 		return false;
+	case bpf_ctx_range(struct __sk_buff, hwtstamp):
+		if (type == BPF_WRITE || size != sizeof(__u64))
+			return false;
+		break;
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 		if (size != sizeof(__u64))
 			return false;
@@ -7774,6 +7778,9 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
 			return false;
 		info->reg_type = PTR_TO_SOCK_COMMON_OR_NULL;
 		break;
+	case offsetofend(struct __sk_buff, gso_size) ... offsetof(struct __sk_buff, hwtstamp) - 1:
+		/* Explicitly prohibit access to padding in __sk_buff. */
+		return false;
 	default:
 		/* Only narrow read access allowed for now. */
 		if (type == BPF_WRITE) {
@@ -7802,6 +7809,7 @@ static bool sk_filter_is_valid_access(int off, int size,
 	case bpf_ctx_range_till(struct __sk_buff, family, local_port):
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
+	case bpf_ctx_range(struct __sk_buff, hwtstamp):
 		return false;
 	}
 
@@ -7872,6 +7880,7 @@ static bool lwt_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct __sk_buff, data_meta):
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
+	case bpf_ctx_range(struct __sk_buff, hwtstamp):
 		return false;
 	}
 
@@ -8373,6 +8382,7 @@ static bool sk_skb_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct __sk_buff, data_meta):
 	case bpf_ctx_range(struct __sk_buff, tstamp):
 	case bpf_ctx_range(struct __sk_buff, wire_len):
+	case bpf_ctx_range(struct __sk_buff, hwtstamp):
 		return false;
 	}
 
@@ -8884,6 +8894,17 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->src_reg,
 				      offsetof(struct sk_buff, sk));
 		break;
+	case offsetof(struct __sk_buff, hwtstamp):
+		BUILD_BUG_ON(sizeof_field(struct skb_shared_hwtstamps, hwtstamp) != 8);
+		BUILD_BUG_ON(offsetof(struct skb_shared_hwtstamps, hwtstamp) != 0);
+
+		insn = bpf_convert_shinfo_access(si, insn);
+		*insn++ = BPF_LDX_MEM(BPF_DW,
+				      si->dst_reg, si->dst_reg,
+				      bpf_target_off(struct skb_shared_info,
+						     hwtstamps, 8,
+						     target_size));
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 791f31dd0abe..51cfd91cc387 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5284,6 +5284,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u32 :32;		/* Padding, future use. */
+	__u64 hwtstamp;
 };
 
 struct bpf_tunnel_key {
-- 
2.18.4

