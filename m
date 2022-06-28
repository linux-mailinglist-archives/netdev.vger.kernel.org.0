Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DF955EE88
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiF1Tvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiF1Tux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C80381B2;
        Tue, 28 Jun 2022 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445768; x=1687981768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZoktIBH2DcbAQq3Yb1c6s52MpIMxZuvptyzwO9VbH6M=;
  b=KDWxERp5hZjnzyL92jLmpa3tHJ/Mbdxukb39r9VL6V4jyQwgzzQMMghj
   6yjEMKa/twYYIiE/DLNY+AwHM9eJvOgHykwvmb9zu68rPc5p/n4kNBZtx
   EAE2ze6DML/eNjnh5jtcPsjS0yXLKelHhT3z6Bk5fjM0ztpALcJsF2Bh6
   qR6X93EHtNYA7y+Qqken7ALmII3/VUh/RfjXOd+DbeEVdFKE7uQbdGASw
   Ql9GWQ98EvK65v/u5O906ftTlHYe3DKsVvhJ8JYxW6cwx8+iEJR0KxwIu
   Ty+0NW9oFdnsWBIOJfUC0yFxXplpbtJzq8tFqDHA+QgwV/tsB1Zyz2LvY
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869586"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869586"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="767288101"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 12:49:23 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9L022013;
        Tue, 28 Jun 2022 20:49:22 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 21/52] net, xdp: allow metadata > 32
Date:   Tue, 28 Jun 2022 21:47:41 +0200
Message-Id: <20220628194812.1453059-22-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hardware/driver-prepended XDP metadata might be much bigger than 32
bytes, especially if it includes a piece of a descriptor.
Relax the restriction and allow metadata larger than 32 bytes and
make __skb_metadata_differs() work with bigger lengths. The new
restriction is pretty much mechanical -- skb_shared_info::meta_len
is a u8 and XDP_PACKET_HEADROOM is 256 (minus
`sizeof(struct xdp_frame)`).
The requirement of having its length aligned to 4 bytes is still
valid.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/skbuff.h | 13 ++++++++-----
 include/net/xdp_meta.h | 21 ++++++++++++++++++++-
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82edf0359ab3..a825ea7f375d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4096,10 +4096,13 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
 {
 	const void *a = skb_metadata_end(skb_a);
 	const void *b = skb_metadata_end(skb_b);
-	/* Using more efficient varaiant than plain call to memcmp(). */
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 diffs = 0;
 
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    BITS_PER_LONG != 64)
+		goto slow;
+
+	/* Using more efficient variant than plain call to memcmp(). */
 	switch (meta_len) {
 #define __it(x, op) (x -= sizeof(u##op))
 #define __it_diff(a, b, op) (*(u##op *)__it(a, op)) ^ (*(u##op *)__it(b, op))
@@ -4119,11 +4122,11 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
 		fallthrough;
 	case  4: diffs |= __it_diff(a, b, 32);
 		break;
+	default:
+slow:
+		return memcmp(a - meta_len, b - meta_len, meta_len);
 	}
 	return diffs;
-#else
-	return memcmp(a - meta_len, b - meta_len, meta_len);
-#endif
 }
 
 static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
diff --git a/include/net/xdp_meta.h b/include/net/xdp_meta.h
index e1f3df9ceb93..3a40189d71c6 100644
--- a/include/net/xdp_meta.h
+++ b/include/net/xdp_meta.h
@@ -5,6 +5,7 @@
 #define __LINUX_NET_XDP_META_H__
 
 #include <net/xdp.h>
+#include <uapi/linux/bpf.h>
 
 /* Drivers not supporting XDP metadata can use this helper, which
  * rejects any room expansion for metadata as a result.
@@ -21,9 +22,27 @@ xdp_data_meta_unsupported(const struct xdp_buff *xdp)
 	return unlikely(xdp->data_meta > xdp->data);
 }
 
+/**
+ * xdp_metalen_invalid -- check if the length of a frame's metadata is valid
+ * @metalen: the length of the frame's metadata
+ *
+ * skb_shared_info::meta_len is of 1 byte long, thus it can't be longer than
+ * 255, but this always can change. XDP_PACKET_HEADROOM is 256, and this is a
+ * UAPI. sizeof(struct xdp_frame) is reserved since xdp_frame is being placed
+ * at xdp_buff::data_hard_start whilst being constructed on XDP_REDIRECT.
+ * The 32-bit alignment requirement is arbitrary, kept for simplicity and,
+ * sometimes, speed.
+ */
 static inline bool xdp_metalen_invalid(unsigned long metalen)
 {
-	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
+	typeof(metalen) max;
+
+	max = min_t(typeof(max),
+		    (typeof_member(struct skb_shared_info, meta_len))~0UL,
+		    XDP_PACKET_HEADROOM - sizeof(struct xdp_frame));
+	BUILD_BUG_ON(!__builtin_constant_p(max));
+
+	return (metalen & (sizeof(u32) - 1)) || metalen > max;
 }
 
 #endif /* __LINUX_NET_XDP_META_H__ */
-- 
2.36.1

