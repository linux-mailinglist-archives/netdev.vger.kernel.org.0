Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19C2B53B7
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgKPVVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgKPVVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:21:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5587AC0613CF;
        Mon, 16 Nov 2020 13:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=7IpcXVHeTBYT8USOupPyxcNDdXDsKJn0Vc/g3Vsna2E=; b=lvAlyYhuPS8XuPLKcwEqw4h/Lk
        W2jM4Ibq8zLDIg1kBci01EjnwBvAi6aaYHcAtVcd8PalVcAJjqT+KkMi/umRu8Euk1rrs7iqGTWf+
        CYJTPyjEJ3bhyvUkPSwSW79J9DzLLW/HHzNGqMwdI2Yx/kAf92g4jkvmvKmlBhgul333UwymFA1oJ
        3CZROhxHLqiQCH5GLAKceOdJyOyLBlvZ1fa3pr/yr8TDENaDGtSpJFCK1T7M8hcJ1C+DaQH2BdcpG
        lO+gj/BGTg2c6kBQHz2YUPSKAXOy+JrKW8i0rB0q1CWAoZ1zp1bVhHQP00GpB2b/2fiuCjd5gacXN
        qwdtuELA==;
Received: from [2601:1c0:6280:3f0::f32] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kelw0-0007T2-Ve; Mon, 16 Nov 2020 21:21:13 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v5] net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
Date:   Mon, 16 Nov 2020 13:21:08 -0800
Message-Id: <20201116212108.32465-1-rdunlap@infradead.org>
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
Cc: Florian Westphal <fw@strlen.de>
---
v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
  drop an extraneous space in a comment;
  use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;
v3, v4: dropped
v5: drop a redundant IS_ENABLED(CONFIG_SKB_EXTENSIONS) in an enum;

 include/linux/skbuff.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20201113.orig/include/linux/skbuff.h
+++ linux-next-20201113/include/linux/skbuff.h
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
