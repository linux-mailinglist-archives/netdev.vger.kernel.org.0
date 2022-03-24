Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765294E6B11
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355669AbiCXXPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355655AbiCXXO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B6D26ACC;
        Thu, 24 Mar 2022 16:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BD0B826B9;
        Thu, 24 Mar 2022 23:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0728EC340F3;
        Thu, 24 Mar 2022 23:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648163598;
        bh=Mm4K2OYNHpzME4ObNQRUClnurfdFbADbhAeMxMvP5z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ34x94+AjRhAkLhvrRajWg/kXRFLPPAopBIBssaxHKn4s4WpiZt0bGVQcitcaaCr
         i1EaXOZu1YJKhK1G2M8XsQptt+hyjUw3sD4hMIQ3f1wEc9XtROiDg5WTBa5vdMYVTD
         5OnruQH677uYS8j/F53cguWcROuowLBtmusHHz5L1Vq27TmOtcUcF5bZl3ZhuhHhL0
         ebD4ZyE/tQs3hfV0jLn+e57wQPTbZDw4GS1lOSWkOk0ZzTbap0+8rn018KXrDV9prm
         tri+/U350JtGH9qZxqSw+ljQDOzkGfCNKJWrCLsuOzMWYQxvf2I7rDDklV+FNTvGR5
         f8ek34TuMk3JQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC v2 2/3] skbuff: rewrite the doc for data-only skbs
Date:   Thu, 24 Mar 2022 16:13:11 -0700
Message-Id: <20220324231312.2241166-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220324231312.2241166-1-kuba@kernel.org>
References: <20220324231312.2241166-1-kuba@kernel.org>
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
 Documentation/networking/skbuff.rst |  6 +++++
 include/linux/skbuff.h              | 42 ++++++++++++++++++++---------
 3 files changed, 37 insertions(+), 12 deletions(-)

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
index b4a008feceb4..94681523e345 100644
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
index 3951071f2bb4..45a48f57d488 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -691,16 +691,32 @@ struct skb_shared_info {
 	skb_frag_t	frags[MAX_SKB_FRAGS];
 };
 
-/* We divide dataref into two halves.  The higher 16 bits hold references
- * to the payload part of skb->data.  The lower 16 bits hold references to
- * the entire skb->data.  A clone of a headerless skb holds the length of
- * the header in skb->hdr_len.
- *
- * All users must obey the rule that the skb->data reference count must be
- * greater than or equal to the payload reference count.
- *
- * Holding a reference to the payload part means that the user does not
- * care about modifications to the header part of skb->data.
+/**
+ * DOC: dataref and headerless skbs
+ *
+ * Transport layers send out clones of payload skbs they hold for
+ * retransmissions. To allow lower layers of the stack to prepend their headers
+ * we split &skb_shared_info.dataref into two halves.
+ * The lower 16 bits count the overall number of references.
+ * The higher 16 bits indicate how many of the references are payload-only.
+ * skb_header_cloned() checks if skb is allowed to add / write the headers.
+ *
+ * The creator of the skb (e.g. TCP) marks its skb as &sk_buff.nohdr
+ * (via __skb_header_release()). Any clone created from marked skb will get
+ * &sk_buff.hdr_len populated with the available headroom.
+ * If there's the only clone in existence it's able to modify the headroom
+ * at will. The sequence of calls inside the transport layer is::
+ *
+ *  <alloc skb>
+ *  skb_reserve()
+ *  __skb_header_release()
+ *  skb_clone()
+ *  // send the clone down the stack
+ *
+ * This is not a very generic construct and it depends on the transport layers
+ * doing the right thing. In practice there's usually only one payload-only skb.
+ * Having multiple payload-only skbs with different lengths of hdr_len is not
+ * possible. The payload-only skbs should never leave their owner.
  */
 #define SKB_DATAREF_SHIFT 16
 #define SKB_DATAREF_MASK ((1 << SKB_DATAREF_SHIFT) - 1)
@@ -1962,8 +1978,10 @@ static inline int skb_header_unclone(struct sk_buff *skb, gfp_t pri)
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

