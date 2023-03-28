Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D116CCB52
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjC1UQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjC1UQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43B83C05
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680034565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Btpaq0T95DzJARTIOQ/tKL2YaQOMLaE7wfp3COF2FTY=;
        b=bvHCRd0ftY17Vv6AsT6ZjmLaxkQYVFumNu6MFVx/SNru1gCUreYz4EZ9K8emetVq/6FBkf
        pnPglbw/DOL1rdiL+xGkARoOMRyyLo3t/cnwWEu6FMici2gy8GuEAtXB6ApvCh3Z35Ya//
        CVF61K9QAIX/JP6ZNXX9MpFUXpO0Y6A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-g5Rjh4JJNqSdboiLnOtOPQ-1; Tue, 28 Mar 2023 16:16:00 -0400
X-MC-Unique: g5Rjh4JJNqSdboiLnOtOPQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B3B4101A531;
        Tue, 28 Mar 2023 20:15:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16548492C3E;
        Tue, 28 Mar 2023 20:15:59 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3616E30736C72;
        Tue, 28 Mar 2023 22:15:58 +0200 (CEST)
Subject: [PATCH bpf RFC 1/4] xdp: rss hash types representation
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Date:   Tue, 28 Mar 2023 22:15:58 +0200
Message-ID: <168003455815.3027256.7575362149566382055.stgit@firesoul>
In-Reply-To: <168003451121.3027256.13000250073816770554.stgit@firesoul>
References: <168003451121.3027256.13000250073816770554.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RSS hash type specifies what portion of packet data NIC hardware used
when calculating RSS hash value. The RSS types are focused on Internet
traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
primarily TCP vs UDP, but some hardware supports SCTP.

Hardware RSS types are differently encoded for each hardware NIC. Most
hardware represent RSS hash type as a number. Determining L3 vs L4 often
requires a mapping table as there often isn't a pattern or sorting
according to ISO layer.

The patch introduce a XDP RSS hash type (xdp_rss_hash_type) that can both
be seen as a number that is ordered according by ISO layer, and can be bit
masked to separate IPv4 and IPv6 types for L4 protocols. Room is available
for extending later while keeping these properties. This maps and unifies
difference to hardware specific hashes.

This proposal change the kfunc API bpf_xdp_metadata_rx_hash() to return
this RSS hash type on success.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/xdp.c    |    4 +++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 5393b3ebe56e..63f462f5ea7f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -8,6 +8,7 @@
 
 #include <linux/skbuff.h> /* skb_shared_info */
 #include <uapi/linux/netdev.h>
+#include <linux/bitfield.h>
 
 /**
  * DOC: XDP RX-queue information
@@ -396,6 +397,56 @@ XDP_METADATA_KFUNC_xxx
 MAX_XDP_METADATA_KFUNC,
 };
 
+/* For partitioning of xdp_rss_hash_type */
+#define RSS_L3		GENMASK(2,0) /* 3-bits = values between 1-7 */
+#define L4_BIT		BIT(3)       /* 1-bit - L4 indication */
+#define RSS_L4_IPV4	GENMASK(6,4) /* 3-bits */
+#define RSS_L4_IPV6	GENMASK(9,7) /* 3-bits */
+#define RSS_L4		GENMASK(9,3) /* = 7-bits - covering L4 IPV4+IPV6 */
+#define L4_IPV6_EX_BIT	BIT(9)       /* 1-bit - L4 IPv6 with Extension hdr */
+				     /* 11-bits in total */
+
+/* The XDP RSS hash type (xdp_rss_hash_type) can both be seen as a number that
+ * is ordered according by ISO layer, and can be bit masked to separate IPv4 and
+ * IPv6 types for L4 protocols. Room is available for extending later while
+ * keeping above properties, as this need to cover NIC hardware RSS types.
+ */
+enum xdp_rss_hash_type {
+	XDP_RSS_TYPE_NONE            = 0,
+	XDP_RSS_TYPE_L2              = XDP_RSS_TYPE_NONE,
+
+	XDP_RSS_TYPE_L3_MASK         = RSS_L3,
+	XDP_RSS_TYPE_L3_IPV4         = FIELD_PREP_CONST(RSS_L3, 1),
+	XDP_RSS_TYPE_L3_IPV6         = FIELD_PREP_CONST(RSS_L3, 2),
+	XDP_RSS_TYPE_L3_IPV6_EX      = FIELD_PREP_CONST(RSS_L3, 4),
+
+	XDP_RSS_TYPE_L4_MASK         = RSS_L4,
+	XDP_RSS_TYPE_L4_SHIFT        = __bf_shf(RSS_L4),
+	XDP_RSS_TYPE_L4_MASK_EX      = RSS_L4 | L4_IPV6_EX_BIT,
+
+	XDP_RSS_TYPE_L4_IPV4_MASK    = RSS_L4_IPV4,
+	XDP_RSS_TYPE_L4_BIT          = L4_BIT,
+	XDP_RSS_TYPE_L4_IPV4_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 1),
+	XDP_RSS_TYPE_L4_IPV4_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 2),
+	XDP_RSS_TYPE_L4_IPV4_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV4, 3),
+
+	XDP_RSS_TYPE_L4_IPV6_MASK    = RSS_L4_IPV6,
+	XDP_RSS_TYPE_L4_IPV6_TCP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 1),
+	XDP_RSS_TYPE_L4_IPV6_UDP     = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 2),
+	XDP_RSS_TYPE_L4_IPV6_SCTP    = L4_BIT|FIELD_PREP_CONST(RSS_L4_IPV6, 3),
+
+	XDP_RSS_TYPE_L4_IPV6_EX_MASK = L4_IPV6_EX_BIT,
+	XDP_RSS_TYPE_L4_IPV6_TCP_EX  = XDP_RSS_TYPE_L4_IPV6_TCP |L4_IPV6_EX_BIT,
+	XDP_RSS_TYPE_L4_IPV6_UDP_EX  = XDP_RSS_TYPE_L4_IPV6_UDP |L4_IPV6_EX_BIT,
+	XDP_RSS_TYPE_L4_IPV6_SCTP_EX = XDP_RSS_TYPE_L4_IPV6_SCTP|L4_IPV6_EX_BIT,
+};
+#undef RSS_L3
+#undef L4_BIT
+#undef RSS_L4_IPV4
+#undef RSS_L4_IPV6
+#undef RSS_L4
+#undef L4_IPV6_EX_BIT
+
 #ifdef CONFIG_NET
 u32 bpf_xdp_metadata_kfunc_id(int id);
 bool bpf_dev_bound_kfunc_id(u32 btf_id);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 7133017bcd74..81d41df30695 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -721,12 +721,14 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
  * @hash: Return value pointer.
  *
  * Return:
- * * Returns 0 on success or ``-errno`` on error.
+ * * Returns (positive) RSS hash **type** on success or ``-errno`` on error.
+ * * ``enum xdp_rss_hash_type`` : RSS hash type
  * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
  * * ``-ENODATA``    : means no RX-hash available for this frame
  */
 __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
 {
+	BTF_TYPE_EMIT(enum xdp_rss_hash_type);
 	return -EOPNOTSUPP;
 }
 


