Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20E24E5BF4
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 00:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbiCWXj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 19:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347120AbiCWXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 19:38:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5608F78071;
        Wed, 23 Mar 2022 16:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18146B82199;
        Wed, 23 Mar 2022 23:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE67C36AE2;
        Wed, 23 Mar 2022 23:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648078641;
        bh=B3RWqzz/ptsmVjfvKfKwBqksGQ4Ftru0F8kv1MbiSuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4Jqv6Bxd8Cy+O5//GIbNpeLvvk6c/KTklmSEkJ+UU2ggtRPxrmpTjl0RAgXdvMwV
         zimbLLzMpvOr3J1HzZeyPPr0RZMl1iRjCYJ6dbYvS81iT+kGGCudPWvmnsVEqO/WaN
         0Jq643F7oRjdIBQh2uXKYqe/uA7S1X8azFgKq3zAuUe2Q607xl3FLO5PEa616QNMk2
         4AIGSCylD1UVX2RkfTk6bbou+NkDskTn5GpH/3oCZ69YubB7GejGNUfrJ/NZmQvmba
         BFQAXsZGWRnaRRuMwLj12nnD2QTWI9uDLOh5Cooaxk+RqDb4mFK2MmzsM/3udaanC3
         Zl8PvVKzzdidQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 2/3] skbuff: rewrite the doc for data-only skbs
Date:   Wed, 23 Mar 2022 16:37:14 -0700
Message-Id: <20220323233715.2104106-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323233715.2104106-1-kuba@kernel.org>
References: <20220323233715.2104106-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment about shinfo->dataref split is really unhelpful,
at least to me. Rewrite it and render it to skb documentation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/index.rst  |  1 +
 Documentation/networking/skbuff.rst |  6 ++++++
 include/linux/skbuff.h              | 33 +++++++++++++++++++----------
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index ce017136ab05..1b3c45add20d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -96,6 +96,7 @@ Linux Networking Documentation
    sctp
    secid
    seg6-sysctl
+   skbuff
    smc-sysctl
    statistics
    strparser
diff --git a/Documentation/networking/skbuff.rst b/Documentation/networking/skbuff.rst
index 7c6be64f486a..581e5561c362 100644
--- a/Documentation/networking/skbuff.rst
+++ b/Documentation/networking/skbuff.rst
@@ -23,3 +23,9 @@ skb_clone() allows for fast duplication of skbs. None of the data buffers
 get copied, but caller gets a new metadata struct (struct sk_buff).
 &skb_shared_info.refcount indicates the number of skbs pointing at the same
 packet data (i.e. clones).
+
+dataref and headerless skbs
+---------------------------
+
+.. kernel-doc:: include/linux/skbuff.h
+   :doc: dataref and headerless skbs
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5431be4aa309..5b838350931c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -691,16 +691,25 @@ struct skb_shared_info {
 	skb_frag_t	frags[MAX_SKB_FRAGS];
 };
 
-/* We divide dataref into two halves.  The higher 16 bits hold references
- * to the payload part of skb->data.  The lower 16 bits hold references to
- * the entire skb->data.  A clone of a headerless skb holds the length of
- * the header in skb->hdr_len.
+/**
+ * DOC: dataref and headerless skbs
+ *
+ * Transport layers send out clones of data skbs they hold for retransmissions.
+ * To allow lower layers of the stack to prepend their headers
+ * we split &skb_shared_info.dataref into two halves.
+ * The lower 16 bits count the overall number of references.
+ * The higher 16 bits indicate number of data-only references.
+ * skb_header_cloned() checks if skb is allowed to add / write the headers.
  *
- * All users must obey the rule that the skb->data reference count must be
- * greater than or equal to the payload reference count.
+ * The creator of the skb (e.g. TCP) marks its data-only skb as &sk_buff.nohdr
+ * (via __skb_header_release()). Any clone created from marked skb will get
+ * &sk_buff.hdr_len populated with the available headroom.
+ * If it's the only clone in existence it's able to modify the headroom at will.
  *
- * Holding a reference to the payload part means that the user does not
- * care about modifications to the header part of skb->data.
+ * This is not a very generic construct and it depends on the transport layers
+ * doing the right thing. In practice there's usually only one data-only skb.
+ * Having multiple data-only skbs with different lengths of hdr_len is not
+ * possible. The data-only skbs should never leave their owner.
  */
 #define SKB_DATAREF_SHIFT 16
 #define SKB_DATAREF_MASK ((1 << SKB_DATAREF_SHIFT) - 1)
@@ -833,7 +842,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@ignore_df: allow local fragmentation
  *	@cloned: Head may be cloned (check refcnt to be sure)
  *	@ip_summed: Driver fed us an IP checksum
- *	@nohdr: Payload reference only, must not modify header
+ *	@nohdr: Data-only skb, must not modify header
  *	@pkt_type: Packet class
  *	@fclone: skbuff clone status
  *	@ipvs_property: skbuff is owned by ipvs
@@ -1962,8 +1971,10 @@ static inline int skb_header_unclone(struct sk_buff *skb, gfp_t pri)
 }
 
 /**
- *	__skb_header_release - release reference to header
- *	@skb: buffer to operate on
+ * __skb_header_release() - allow clones to use the headroom
+ * @skb: buffer to operate on
+ *
+ * See "DOC: dataref and headerless skbs".
  */
 static inline void __skb_header_release(struct sk_buff *skb)
 {
-- 
2.34.1

