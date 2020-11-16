Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7242B3BCA
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 04:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKPDR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 22:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgKPDRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 22:17:25 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6658DC0613CF;
        Sun, 15 Nov 2020 19:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rLL9X6jjJCna5p7PH8EM+yh73syISaST57XUG2k8t6o=; b=dMjzwsf13RWSgZG0yQSp+ZfBIO
        hZJ8SP9NPiwlYkvjNTYTl6o4xmcFzVqZWY2JcWZVoS+SyXAgS96FDE67uF9ebaaFzyH6pYVbluNBo
        KWJiBwLmHOu9QViMXNZSH7vmF6+k9XyMUOrKr9K0/EH64Ofgy2JIvJuxwk35NRJFZUfcVtL2WAYyF
        aLKgiOePUojFUbT9xntuGNikS9/fEztKX8e20/wAu6E3R1nqQRJh3/BrYZPnL6BGX1mcyU7X8mNAR
        rAkXwUfTJQwgbV8r5//S5I+6Z4EGSxdwmVLrww52f4z04ohIqfQTVhJm619MmftxpFCg798Wvudef
        7uL286VQ==;
Received: from [2601:1c0:6280:3f0::f32] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keV17-0008Q3-J9; Mon, 16 Nov 2020 03:17:22 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next v4] net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
Date:   Sun, 15 Nov 2020 19:17:15 -0800
Message-Id: <20201116031715.7891-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous Kconfig patch led to some other build errors as
reported by the 0day bot and my own overnight build testing.

These are all in <linux/skbuff.h> when KCOV is enabled but
SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
in the header file.

Also, add stubs for skb_ext_add() and skb_ext_find() to reduce the
amount of ifdef-ery. (Jakub)

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
---
v4: The enum for SKB_EXT_KCOV_HANDLE needs to be exposed unconditionally
  because it is used in skb_get/set_kcov_handle(), which are always
  present since v3.
v3: (as suggested by Jakub Kicinski <kuba@kernel.org>)
  add stubs for skb_ext_add() and skb_ext_find() to reduce the ifdef-ery
v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
  drop an extraneous space in a comment;
  use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;

 include/linux/skbuff.h |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- linux-next-20201113.orig/include/linux/skbuff.h
+++ linux-next-20201113/include/linux/skbuff.h
@@ -4137,7 +4137,6 @@ static inline void skb_set_nfct(struct s
 #endif
 }
 
-#ifdef CONFIG_SKB_EXTENSIONS
 enum skb_ext_id {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	SKB_EXT_BRIDGE_NF,
@@ -4151,12 +4150,11 @@ enum skb_ext_id {
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
 #endif
-#if IS_ENABLED(CONFIG_KCOV)
 	SKB_EXT_KCOV_HANDLE,
-#endif
 	SKB_EXT_NUM, /* must be last */
 };
 
+#ifdef CONFIG_SKB_EXTENSIONS
 /**
  *	struct skb_ext - sk_buff extensions
  *	@refcnt: 1 on allocation, deallocated on 0
@@ -4252,6 +4250,10 @@ static inline void skb_ext_del(struct sk
 static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
 static inline bool skb_has_extensions(struct sk_buff *skb) { return false; }
+static inline void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
+{ return NULL; }
+static inline void *skb_ext_find(const struct sk_buff *skb, enum skb_ext_id id)
+{ return NULL; }
 #endif /* CONFIG_SKB_EXTENSIONS */
 
 static inline void nf_reset_ct(struct sk_buff *skb)
@@ -4608,7 +4610,6 @@ static inline void skb_reset_redirect(st
 #endif
 }
 
-#ifdef CONFIG_KCOV
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
@@ -4632,11 +4633,6 @@ static inline u64 skb_get_kcov_handle(st
 
 	return kcov_handle ? *kcov_handle : 0;
 }
-#else
-static inline void skb_set_kcov_handle(struct sk_buff *skb,
-				       const u64 kcov_handle) { }
-static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
-#endif /* CONFIG_KCOV */
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
