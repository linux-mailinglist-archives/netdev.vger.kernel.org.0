Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EC73FF6F9
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhIBWRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:17:17 -0400
Received: from novek.ru ([213.148.174.62]:60350 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhIBWRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 18:17:15 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id DDE09504080;
        Fri,  3 Sep 2021 01:13:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru DDE09504080
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1630620787; bh=htM0bYVvpwMhmEKqwtiX3u6zhNVDYeI3Ra0nrYVVTdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDxTmyBK8yvpX9BlsHpUSFzOKczFvySlS9592lCToBOI3YUGVRlvPraNlTEY6ne3t
         wR4kJr8NpJlsnxTOc/2r4PNutToIj/8Bj1zPMa12YM69HGIOBo8kWb76m1LQ7pjJNR
         tXIFQ8J3ccUoTPDSSmkYx53ZoHK2g9MJpdO5h1jw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: add hardware timestamp field to __sk_buff
Date:   Fri,  3 Sep 2021 01:15:50 +0300
Message-Id: <20210902221551.15566-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210902221551.15566-1-vfedorenko@novek.ru>
References: <20210902221551.15566-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF programs may want to know hardware timestamps if NIC supports
such timestamping.

Expose this data as hwtstamp field of __sk_buff the same way as
gso_segs/gso_size.

Also update BPF_PROG_TEST_RUN tests of the feature.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/uapi/linux/bpf.h       |  2 ++
 net/core/filter.c              | 11 +++++++++++
 tools/include/uapi/linux/bpf.h |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 791f31dd0abe..c7d05b49f557 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5284,6 +5284,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u32 padding;		/* Padding, future use. */
+	__u64 hwtstamp;
 };
 
 struct bpf_tunnel_key {
diff --git a/net/core/filter.c b/net/core/filter.c
index 2e32cee2c469..1d8f8494d325 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8884,6 +8884,17 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
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
index 791f31dd0abe..c7d05b49f557 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5284,6 +5284,8 @@ struct __sk_buff {
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
 	__u32 gso_size;
+	__u32 padding;		/* Padding, future use. */
+	__u64 hwtstamp;
 };
 
 struct bpf_tunnel_key {
-- 
2.18.4

