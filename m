Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765574E5BF1
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 00:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbiCWXj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 19:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347118AbiCWXiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 19:38:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C747C70047;
        Wed, 23 Mar 2022 16:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EF15B82193;
        Wed, 23 Mar 2022 23:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6A4C36AE5;
        Wed, 23 Mar 2022 23:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648078641;
        bh=kp9wBHfO3xrp/n2wy0BWH5V9WBDsoE4TGYw2mV0g3b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwqaHHKPuF7zLNMFmrXy7aMVcLY3rUgmrWAd8GDhT7QJZ6OY5l6kVRQAtl7+daicn
         /LgjEgHZT28cy4HhBQAIEakaqsmPuvCT02b7k5vxgWWLf06+f7Y5se0nrIxLpQjWZF
         3D0kKRaLS0KB4soOUvGJlVs7ueto5SUZrkemumB4ji7gOvZ/d9h84i26OTKoxB/mIq
         iCOhRcuNE7wT68l8a0BPYsapfZs/Fh0ketOuLBDj6Qbl5qTjRjtZsEUMYKzQVPG1RN
         gE4Dvll2C9MMXAIzefsEBQDsZ2epevQKt8Q1P0qV3EqlRIiKbEqCJzVqM2yEC29B2K
         CuKB+yU25nh3g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 1/3] skbuff: add a basic intro doc
Date:   Wed, 23 Mar 2022 16:37:13 -0700
Message-Id: <20220323233715.2104106-2-kuba@kernel.org>
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

Add basic skb documentation. It's mostly an intro to the subsequent
patches - it would looks strange if we documented advanced topics
without covering the basics in any way.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/skbuff.rst | 25 ++++++++++++++++++
 include/linux/skbuff.h              | 40 +++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/networking/skbuff.rst

diff --git a/Documentation/networking/skbuff.rst b/Documentation/networking/skbuff.rst
new file mode 100644
index 000000000000..7c6be64f486a
--- /dev/null
+++ b/Documentation/networking/skbuff.rst
@@ -0,0 +1,25 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+struct sk_buff
+==============
+
+:c:type:`struct sk_buff` is the main networking structure representing
+a packet.
+
+Basic sk_buff geometry
+----------------------
+
+.. kernel-doc:: include/linux/skbuff.h
+   :doc: Basic sk_buff geometry
+
+Shared skbs and skb clones
+--------------------------
+
+:c:member:`sk_buff.users` is a simple refcount allowing multiple entities
+to keep a struct sk_buff alive. skbs with a ``sk_buff.users != 1`` are referred
+to as shared skbs (see skb_shared()).
+
+skb_clone() allows for fast duplication of skbs. None of the data buffers
+get copied, but caller gets a new metadata struct (struct sk_buff).
+&skb_shared_info.refcount indicates the number of skbs pointing at the same
+packet data (i.e. clones).
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a30cae8b0a5..5431be4aa309 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -764,6 +764,46 @@ typedef unsigned int sk_buff_data_t;
 typedef unsigned char *sk_buff_data_t;
 #endif
 
+/**
+ * DOC: Basic sk_buff geometry
+ *
+ * struct sk_buff itself is a metadata structure and does not hold any packet
+ * data. All the data is held in associated buffers.
+ *
+ * &sk_buff.head points to the main "head" buffer. The head buffer is divided
+ * into two parts:
+ *
+ *  - data buffer, containing headers and sometimes payload data;
+ *    this is the part of the skb operated on by the common helpers
+ *    such as skb_put() or skb_pull();
+ *  - shared info (struct skb_shared_info) which holds an array of pointers
+ *    to read-only payload data in the (page, offset, length) format.
+ *
+ * Optionally &skb_shared_info.frag_list may point to another skb.
+ *
+ * Basic diagram may look like this::
+ *
+ *                                  ---------------
+ *                                 | sk_buff       |
+ *                                  ---------------
+ *     ,---------------------------  + head
+ *    /          ,-----------------  + data
+ *   /          /      ,-----------  + tail
+ *  |          |      |            , + end
+ *  |          |      |           |
+ *  v          v      v           v
+ *   -----------------------------------------------
+ *  | headroom | data |  tailroom | skb_shared_info |
+ *   -----------------------------------------------
+ *                                 + [page frag]
+ *                                 + [page frag]
+ *                                 + [page frag]
+ *                                 + [page frag]       ---------
+ *                                 + frag_list    --> | sk_buff |
+ *                                                     ---------
+ *
+ */
+
 /**
  *	struct sk_buff - socket buffer
  *	@next: Next buffer in list
-- 
2.34.1

