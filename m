Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78A82B2F36
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgKNRq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgKNRq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:46:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAF7C0613D1;
        Sat, 14 Nov 2020 09:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=zFmbG7lUGEssA2TGxTf3U7GjLMkFXLzG9VOoFN4dDxg=; b=NaUnrjYu1zoWsuyoRbah1k4MUm
        +wtvix9eB59O0WyyPG4u6xAhJVkbEbfJPTzc/PgbzC58UeCZ194ShmokVJLiTSYYeqHugsS6IfuCX
        0+94Us5i0XxrJ+45YsWl5Rd5Ebf0vm1ykzpdIzK7Tl4Ra48DhhP55rqtLBkTdhJcaBLlGTBqylXUh
        dMygVWZNT2joP8QU+WgMTXUMOP8Kx/Wht0GcDW//w3Tu8Cko0g5jZqzaiJYfgtjUFxGnUVAWk2Wuc
        UkratnAyV2uZQOaaHsq8WQa3vGuP3/+8yHQapANjkKZmnQZ4SdaEMq+1yCi/76G+NrTRLu7uSXd8l
        Ye7AFfCw==;
Received: from [2601:1c0:6280:3f0::f32] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdzd0-0000Ys-IA; Sat, 14 Nov 2020 17:46:23 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
Date:   Sat, 14 Nov 2020 09:46:18 -0800
Message-Id: <20201114174618.24471-1-rdunlap@infradead.org>
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

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org
---
v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
  drop an extraneous space in a comment;
  use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;

 include/linux/skbuff.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20201113.orig/include/linux/skbuff.h
+++ linux-next-20201113/include/linux/skbuff.h
@@ -4151,7 +4151,7 @@ enum skb_ext_id {
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
 #endif
-#if IS_ENABLED(CONFIG_KCOV)
+#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
 	SKB_EXT_KCOV_HANDLE,
 #endif
 	SKB_EXT_NUM, /* must be last */
@@ -4608,7 +4608,7 @@ static inline void skb_reset_redirect(st
 #endif
 }
 
-#ifdef CONFIG_KCOV
+#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
@@ -4636,7 +4636,7 @@ static inline u64 skb_get_kcov_handle(st
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle) { }
 static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
-#endif /* CONFIG_KCOV */
+#endif /* CONFIG_KCOV && CONFIG_SKB_EXTENSIONS */
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
