Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9829F1ED929
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 01:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgFCXcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 19:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgFCXcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 19:32:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39ABC08C5CB
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 16:32:14 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m2so267361pjv.2
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 16:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hMUFWqcrC1VZxvWDwrZSg4KS9BvtvLd2CEEYtAT+tik=;
        b=NPDoMZL+zfsatoKLllUEr8wu4PDByFvpOx0tUIG0zh+F9kNU3lZAIs4/72VWZHO62B
         wJNDmXTEzDkwVDFm5ZmRQQz2JzgS9VFCuCWR/c1ERdo1M9u6NFUkJjq4MdvlAxFdWiuA
         qZfnse2pv1GkiYqRcfQiacr45rwEs75PqerkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hMUFWqcrC1VZxvWDwrZSg4KS9BvtvLd2CEEYtAT+tik=;
        b=pBCno6ma6LEkfc6552m/gHUEKlX4VxRmC9tYsevEUoqZ/Tg3/F4v844Kf7VGdraCNp
         uAPbvCBa4JHTfGB6nBB8juc7DkcQOmYWaHF2nvYiSCRsSYb3n95ZDeHaWL84Rd77ub2f
         zZ8AidFFE2UcF+Zv8Kl5tJKT6XQmEuJpKLz79GMu3oSkFWvmCr3kJuoSmoTu5iPSQC1/
         8Zw7ypbWlDwrehxXG2QG77rHPXlfIlXZLsELOx/hu5WbDT4Qok+zkuam9gRd+kYBFw7B
         blaez7PpmnZm9iDg/U2Nb2wPtPG3sCEJizz+IpqrOzdXuXKad8CoxOqIZfV1UFkWlngL
         O8bg==
X-Gm-Message-State: AOAM531HIVNNO0p5Ez562h41X9r81rTpIqDn4yuNymmsiK/PrZhzf5eM
        yezvmup/wgbQcjmMe1Ch/xM0ng==
X-Google-Smtp-Source: ABdhPJwEforJlQ6Hw2sLXD7jNMrxzqXBv5BlsWVfup5BJSe8mp612gIHwefIBt6eEGH3vm6zOlawSw==
X-Received: by 2002:a17:90b:3448:: with SMTP id lj8mr2505301pjb.163.1591227134470;
        Wed, 03 Jun 2020 16:32:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b1sm3836777pjc.33.2020.06.03.16.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 16:32:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
Date:   Wed,  3 Jun 2020 16:31:54 -0700
Message-Id: <20200603233203.1695403-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603233203.1695403-1-keescook@chromium.org>
References: <20200603233203.1695403-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using uninitialized_var() is dangerous as it papers over real bugs[1]
(or can in the future), and suppresses unrelated compiler warnings (e.g.
"unused variable"). If the compiler thinks it is uninitialized, either
simply initialize the variable or make compiler changes. As a precursor
to removing[2] this[3] macro[4], refactor code to avoid its need.

The original reason for its use here was to work around the #ifdef
being the only place the variable was used. This is better expressed
using IS_ENABLED() and a new code block where the variable can be used
unconditionally.

[1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
[2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
[3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
[4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/mm/numa.c                | 18 +++++++++---------
 include/linux/page-flags-layout.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 59ba008504dc..38eeb15f3b07 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -541,7 +541,6 @@ static void __init numa_clear_kernel_node_hotplug(void)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	unsigned long uninitialized_var(pfn_align);
 	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
@@ -569,15 +568,16 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	 * If sections array is gonna be used for pfn -> nid mapping, check
 	 * whether its granularity is fine enough.
 	 */
-#ifdef NODE_NOT_IN_PAGE_FLAGS
-	pfn_align = node_map_pfn_alignment();
-	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
-		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
-		       PFN_PHYS(pfn_align) >> 20,
-		       PFN_PHYS(PAGES_PER_SECTION) >> 20);
-		return -EINVAL;
+	if (IS_ENABLED(NODE_NOT_IN_PAGE_FLAGS)) {
+		unsigned long pfn_align = node_map_pfn_alignment();
+
+		if (pfn_align && pfn_align < PAGES_PER_SECTION) {
+			pr_warn("Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
+				PFN_PHYS(pfn_align) >> 20,
+				PFN_PHYS(PAGES_PER_SECTION) >> 20);
+			return -EINVAL;
+		}
 	}
-#endif
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 71283739ffd2..1a4cdec2bd29 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -100,7 +100,7 @@
  * there.  This includes the case where there is no node, so it is implicit.
  */
 #if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
-#define NODE_NOT_IN_PAGE_FLAGS
+#define NODE_NOT_IN_PAGE_FLAGS 1
 #endif
 
 #if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
-- 
2.25.1

