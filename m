Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CBF3D80CF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhG0VHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbhG0VHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:07:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259A6C061389
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:07:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f13so43121plj.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCr6M9WVbBxoz5xSZDTLYQZUaixoNhvM1z4ft4/JiWU=;
        b=CkfvuUYgjXUdgM1i87D/akGLRkQBlDepGvReTODAXjxv3JZLUxpr2SeqRCtggSb1NQ
         0eO++6VjfUhMdNdLL9RotuOnb/CQ5ydWv+gSz7/hzqH6ipBx2LTuhN83Pi+6+jPneDFl
         4XWuDGX42ek2Bg7lAzXWOFRnumRXJltjgh5Ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCr6M9WVbBxoz5xSZDTLYQZUaixoNhvM1z4ft4/JiWU=;
        b=OAI0bD1kTYjW94ChRnD7TDOXOaiboWYYDfp+VIYoJlryUjuJyZBBvL2VGXSXP6IQLM
         avqLcdzW196cz3E3epRBUNLPP14o3g8ih/7L2AVNaG9kvoBXtQgJbHvdlTtycWpV1RkJ
         TjQJuYbbw5fVW54WX0GB/n5rIMSIMQiSSnW6E7fiFREElo2D+N5jj8FhqXthJZxr4S5p
         jjk1APAgK8MjwaH6LR4H70nXkXkiEq1SLq+PFCq7wR6qg4DM+dqlrad/BBU3QWfq7+GL
         gSCNTFF3mT+v17y6cdVi3Y96r+DAGXFGO1jUu65TNyry6P7br9lRIdWrMsNrJ59cu4bC
         lR8g==
X-Gm-Message-State: AOAM531OzZyqyM00odNuBb4NmJnlfYzFku/Gj7/Jsj6BkmKArkMbLdy1
        dPzDlMbM6ySBN0SIQ0dWkipGoA==
X-Google-Smtp-Source: ABdhPJxSxBiTE9j5dpguWlnBff2W6XOxanMIjLBz3KD/2jrAfNakkqqBYOlfrkNXGZusO3mgNbH5WQ==
X-Received: by 2002:a17:902:b711:b029:11e:6480:258a with SMTP id d17-20020a170902b711b029011e6480258amr20741066pls.41.1627420022747;
        Tue, 27 Jul 2021 14:07:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i24sm3255991pfr.207.2021.07.27.14.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:07:01 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 54/64] ipv6: Use struct_group() to zero rt6_info
Date:   Tue, 27 Jul 2021 13:58:45 -0700
Message-Id: <20210727205855.411487-55-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2014; h=from:subject; bh=9FxEXENVJNuB45fHUbaxMj4hb424u+KXBOvcDXadQUU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOMr1s7rjBnwnV0YvEmCppP2KjiI7qwbNhC0tnR LR54sH2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjAAKCRCJcvTf3G3AJvB1D/ 9HyBVTCMQFZVnce4Q7z9RSSZaLEhmwSMwOLxk45KjDsJAOP3HcDjbkcb2t+AmQxHosaQzMYzJBsPLM fI6MGo8d7iglJul2X+wgatbPcEehYNvmi9N2hSNViixrkSMFXRYD9gNgZxmurHn3poTaQBFJeH/CMt i0K0Mf9xJLh09ZTUaBEMkeBp92msj4wB0UzT2YgQVbRBg/2h2H9tSdBS7ou3xC8W1K4gsOB+p8y9Z9 E6xK8yOM9010RaqlQJ7Xwiw/qBjEzM4v6/BvFKOfF7nbprnDsEcm1n3uqkj3PJ0XdUXpvHAc5ObsoB KO/0wpq+dvC4caLYvsafIZqOaz3hLgcDlRNbqQtK2sC08guGWc1MHoTfZoyOpPcsvKpv6Ez1ugjb2i pyJ0WkxY6xI4NtO334xyOlpSXADvHv+yqhiucaHger+9V1z3cVGZWQJMnpNFHTjqetSkyOaPhGCfT6 eygtBdkni37ipeLcPOAVtXgZH4iuKxdilblIEAG1YqFqpciOhCgtYiCt3itR4hpyhJp61nLn2XSysU lMIbYdUyBQlmwsWY79F0ezh83tePY6wggdyAujypUrGKiYTgTpH817kU7KBH2AB7YhuYQevj9FEHhD B/H1yY45d73/j38Hw4+briFVcL4khdU1nni0efnXIAMBNb0nJPEsOcf21O/g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct rt6_info that should be
initialized to zero.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/ip6_fib.h | 30 ++++++++++++++++--------------
 net/ipv6/route.c      |  4 +---
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 15b7fbe6b15c..9816e7444918 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -205,20 +205,22 @@ struct fib6_info {
 
 struct rt6_info {
 	struct dst_entry		dst;
-	struct fib6_info __rcu		*from;
-	int				sernum;
-
-	struct rt6key			rt6i_dst;
-	struct rt6key			rt6i_src;
-	struct in6_addr			rt6i_gateway;
-	struct inet6_dev		*rt6i_idev;
-	u32				rt6i_flags;
-
-	struct list_head		rt6i_uncached;
-	struct uncached_list		*rt6i_uncached_list;
-
-	/* more non-fragment space at head required */
-	unsigned short			rt6i_nfheader_len;
+	struct_group(init,
+		struct fib6_info __rcu		*from;
+		int				sernum;
+
+		struct rt6key			rt6i_dst;
+		struct rt6key			rt6i_src;
+		struct in6_addr			rt6i_gateway;
+		struct inet6_dev		*rt6i_idev;
+		u32				rt6i_flags;
+
+		struct list_head		rt6i_uncached;
+		struct uncached_list		*rt6i_uncached_list;
+
+		/* more non-fragment space at head required */
+		unsigned short			rt6i_nfheader_len;
+	);
 };
 
 struct fib6_result {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 6b8051106aba..bbcc605bab57 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -327,9 +327,7 @@ static const struct rt6_info ip6_blk_hole_entry_template = {
 
 static void rt6_info_init(struct rt6_info *rt)
 {
-	struct dst_entry *dst = &rt->dst;
-
-	memset(dst + 1, 0, sizeof(*rt) - sizeof(*dst));
+	memset(&rt->init, 0, sizeof(rt->init));
 	INIT_LIST_HEAD(&rt->rt6i_uncached);
 }
 
-- 
2.30.2

