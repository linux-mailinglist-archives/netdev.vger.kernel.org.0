Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0E02B31BD
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 02:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgKOBK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 20:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKOBK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 20:10:59 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FDFC0613D1;
        Sat, 14 Nov 2020 17:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=tEaWy3QKl0oOSKo9Oc+odJQW1EHuIGVfalnV1XqoB4c=; b=FFO907eoSDZV8LFTxtIApN8EgK
        lmBP2m7KZR2zKv+2JHy5aoH9ucVIoiGs8XTKwxlsRVttOLR+8huI8bAgnvtbFhDayfXJ6JoGjkB0y
        smcI0cTA/hIrgOSXLDGNp7T9SS6D2wCImHs+Jf6/Y4Q1RY/2amcNiTKwr0uYUfTTlX7Az5FNCXISw
        yhJ3FE6oUJvL1zP+gt03u1aSA2j6YWxUrjx2TCFj3MuSbmLG7zSBahCGaszJ0x+tZG7rNat4VoiOI
        TeCiB0M6XuLp/tcb3fPo4TQNz9uXDpTMmVcLa0Sb0lbsiqukbBfh0Hzi/DQ1eQulQ61s67MoqQnR8
        OxCZ90mw==;
Received: from [2601:1c0:6280:3f0::f32] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ke6Z7-0003aI-An; Sun, 15 Nov 2020 01:10:49 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next v3] net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
Date:   Sat, 14 Nov 2020 17:10:43 -0800
Message-Id: <20201115011043.8159-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
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
v3: (as suggested by Jakub Kicinski <kuba@kernel.org>)
  add stubs for skb_ext_add() and skb_ext_find() to reduce the ifdef-ery
v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
  drop an extraneous space in a comment;
  use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;

 include/linux/skbuff.h |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-next-20201113.orig/include/linux/skbuff.h
+++ linux-next-20201113/include/linux/skbuff.h
@@ -4137,7 +4137,6 @@ static inline void skb_set_nfct(struct s
 #endif
 }
 
-#ifdef CONFIG_SKB_EXTENSIONS
 enum skb_ext_id {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	SKB_EXT_BRIDGE_NF,
@@ -4157,6 +4156,7 @@ enum skb_ext_id {
 	SKB_EXT_NUM, /* must be last */
 };
 
+#ifdef CONFIG_SKB_EXTENSIONS
 /**
  *	struct skb_ext - sk_buff extensions
  *	@refcnt: 1 on allocation, deallocated on 0
@@ -4252,6 +4252,10 @@ static inline void skb_ext_del(struct sk
 static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
 static inline bool skb_has_extensions(struct sk_buff *skb) { return false; }
+static inline void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id)
+{ return NULL; }
+static inline void *skb_ext_find(const struct sk_buff *skb, enum skb_ext_id id)
+{ return NULL; }
 #endif /* CONFIG_SKB_EXTENSIONS */
 
 static inline void nf_reset_ct(struct sk_buff *skb)
@@ -4608,7 +4612,6 @@ static inline void skb_reset_redirect(st
 #endif
 }
 
-#ifdef CONFIG_KCOV
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
@@ -4632,11 +4635,6 @@ static inline u64 skb_get_kcov_handle(st
 
 	return kcov_handle ? *kcov_handle : 0;
 }
-#else
-static inline void skb_set_kcov_handle(struct sk_buff *skb,
-				       const u64 kcov_handle) { }
-static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
-#endif /* CONFIG_KCOV */
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
