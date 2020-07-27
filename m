Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CFE22ECA4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgG0M5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:57:13 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23091 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgG0M5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595854633; x=1627390633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nekOskjM5McvCMtwT/xqn9yFpyIMpbLDFbYFaHBTtEE=;
  b=up5ikt2wfmeSY7Y7EbYDcVO+0k9EOEYpIg3o8vrFu6LxE7ZIkGgAAbLG
   /mG30auVPiJ/2QMdmTgbZUCx0euxkLsfHhlSNjyV8PjCG7xhUgwTYba8S
   KkjCYn+7o06KCNRto2AwWbqgvSvNlPeQko3+7z0ebYMdM6Pet2f0527Fp
   g=;
IronPort-SDR: hCmWth9LPuZiCfw4VwA9C8i3KWA6TGtxn/g5BzItt15cuy0/IXZgRhqFRa4PI9l9/PtEKrpUbS
 0qiTdfVeP17g==
X-IronPort-AV: E=Sophos;i="5.75,402,1589241600"; 
   d="scan'208";a="44265253"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 27 Jul 2020 12:57:09 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 85900A252B;
        Mon, 27 Jul 2020 12:57:07 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 27 Jul 2020 12:56:55 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 234CC81C55; Mon, 27 Jul 2020 12:56:55 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kuba@kernel.org>, <hawk@kernel.org>, <shayagr@amazon.com>,
        <lorenzo@kernel.org>
Subject: [PATCH RFC net-next 1/2] xdp: helpers: add multibuffer support
Date:   Mon, 27 Jul 2020 12:56:52 +0000
Message-ID: <20200727125653.31238-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200727125653.31238-1-sameehj@amazon.com>
References: <20200727125653.31238-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The implementation is based on this [0] draft by Jesper D. Brouer.

Provided two helpers:

* bpf_xdp_get_frag()
* bpf_xdp_get_frag_count()

[0] xdp mb design - https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 include/uapi/linux/bpf.h       | 13 +++++++++
 net/core/filter.c              | 60 ++++++++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++++++
 3 files changed, 86 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5e3863899..3484e481a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3320,6 +3320,17 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * int bpf_xdp_get_frag(struct xdp_buff *xdp_md, u32 frag_index, u32 *size, u32 *offset)
+ * 	Description
+ *		Get the offset from containing page and size of a given frag.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ * 	Description
+ *		Get the total number of frags for a given packet.
+ * 	Return
+ * 		The number of frags
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3464,6 +3475,8 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(xdp_get_frag),		\
+	FN(xdp_get_frag_count),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/net/core/filter.c b/net/core/filter.c
index bdd2382e6..93e790d7b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3452,6 +3452,62 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+static inline bool __bpf_xdp_has_frags(struct  xdp_buff *xdp)
+{
+	return xdp->mb != 0;
+}
+
+BPF_CALL_1(bpf_xdp_get_frag_count, struct  xdp_buff*, xdp)
+{
+	return __bpf_xdp_has_frags(xdp) ?
+		((struct skb_shared_info *)xdp->data_end)->nr_frags : 0;
+}
+
+const struct bpf_func_proto bpf_xdp_get_frag_count_proto = {
+	.func		= bpf_xdp_get_frag_count,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
+BPF_CALL_4(bpf_xdp_get_frag, struct  xdp_buff*, xdp, u32, frag_index,
+	   u32*, size, u32*, offset)
+{
+	skb_frag_t *frags;
+	u32 frag_size;
+	u16 nr_frags;
+	struct skb_shared_info *skb_info;
+
+	if (!__bpf_xdp_has_frags(xdp))
+		return -EINVAL;
+
+	skb_info = xdp_data_hard_end(xdp);
+	frags = skb_info->frags;
+	nr_frags = skb_info->nr_frags;
+
+	if (frag_index >= nr_frags)
+		return -EINVAL;
+
+	frag_size = frags[frag_index].bv_len;
+
+	if (size)
+		memcpy(size, &frag_size, sizeof(frag_size));
+	if (offset)
+		memcpy(offset, &frags[frag_index].bv_offset, sizeof(frags[frag_index].bv_offset));
+
+	return 0;
+}
+
+const struct bpf_func_proto bpf_xdp_get_frag_proto = {
+	.func		= bpf_xdp_get_frag,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_PTR_TO_INT,
+	.arg4_type	= ARG_PTR_TO_INT,
+};
+
 BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 {
 	void *data_hard_end = xdp_data_hard_end(xdp); /* use xdp->frame_sz */
@@ -6475,6 +6531,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_redirect_map_proto;
 	case BPF_FUNC_xdp_adjust_tail:
 		return &bpf_xdp_adjust_tail_proto;
+	case BPF_FUNC_xdp_get_frag_count:
+		return &bpf_xdp_get_frag_count_proto;
+	case BPF_FUNC_xdp_get_frag:
+		return &bpf_xdp_get_frag_proto;
 	case BPF_FUNC_fib_lookup:
 		return &bpf_xdp_fib_lookup_proto;
 #ifdef CONFIG_INET
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5e3863899..3484e481a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3320,6 +3320,17 @@ union bpf_attr {
  *		A non-negative value equal to or less than *size* on success,
  *		or a negative error in case of failure.
  *
+ * int bpf_xdp_get_frag(struct xdp_buff *xdp_md, u32 frag_index, u32 *size, u32 *offset)
+ * 	Description
+ *		Get the offset from containing page and size of a given frag.
+ * 	Return
+ * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
+ * 	Description
+ *		Get the total number of frags for a given packet.
+ * 	Return
+ * 		The number of frags
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3464,6 +3475,8 @@ union bpf_attr {
 	FN(skc_to_tcp_request_sock),	\
 	FN(skc_to_udp6_sock),		\
 	FN(get_task_stack),		\
+	FN(xdp_get_frag),		\
+	FN(xdp_get_frag_count),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.16.6

