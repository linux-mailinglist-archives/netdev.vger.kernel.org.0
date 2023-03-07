Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0736AD6BF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 06:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCGFXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 00:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCGFXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 00:23:07 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DDB17143
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:23:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l24-20020a25b318000000b007eba3f8e3baso12779255ybj.4
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 21:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678166579;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5c2qBcJ04eV7YVtQK+t3Nhusvz3yml0SyLi5SuWLvlg=;
        b=FZ2J4HbnA/QOgWewiOjHj1n8me9whff+Kbrxh3GLKvbvOYK4gj8heFoAWHda8twlbY
         Zc3tUDOfFKAnN/NlQlBnpe6lRnM7zYnXBo3Smy/LZ5IFBR6cBe9YDBo7z3ViwtCsXn0a
         E2ReUmuTYj9oG1VXLKLRSbybo5aP59UGUghu2ZrRPKLUMpuIxbv5LcFLEwCOFZSwLZqp
         VUIHCYl3K8KX28SDrfk2BvQUWSS/Dz1GGSvZLLjOans+RyWmu3Dut+iqLTy3l4GGLdVK
         BTsJ7ERONlhnOyZEFmT3f/gkLtXTdnRXHMzF8ilTeCSKK0v4llL0LNjes7hZS7aYMZjh
         tQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678166579;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5c2qBcJ04eV7YVtQK+t3Nhusvz3yml0SyLi5SuWLvlg=;
        b=79CS1sb7nakGhXMmRFCT2sugGeLtqVFZ7dAif8w6wWVS44GupK6jfD77kP8NKo15Ba
         Jw+j4KJzGDg1xzCFH6iD0Ew4w5WD0jlABRvLg+Pa1nAKqIOqNiRe+Snj8nLe01fRtMAi
         VQk9u/VsAPRZ5T4Ns8mJ0gXjxc9Dk/S5mHxL9tg8TVEskH+jFSRjDi8p9FISCdRphDUL
         I9+yaM7krkguHOG5SdBoNuPxfsletIM4gHHiLoPm9JM+4hMcMVQ1IaZj/gI+HZEVW74T
         YTtN3EGio5KINZdfvxsjMo9T95peNwmMeHgLvZDfe7l1uEyPs9R2qLVKfih/tymq0a3X
         2TCA==
X-Gm-Message-State: AO0yUKXKiTIzC1pZYNTECF2PH0zxQYmwTHLRc12THzptl8/zg++YkKHC
        C+8y3FN91IY1k3bhcJKmcY0oZ6PzXyK1PA==
X-Google-Smtp-Source: AK7set8goaU2HYVUe77wQjsPKU46e24ElljGtVwOGVjpWSQm0DcIrUnIUZZBgAT5tz/3np9XVOC2zR8K8nL5/Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4c3:b0:a6a:3356:6561 with SMTP
 id v3-20020a05690204c300b00a6a33566561mr6270870ybs.1.1678166579357; Mon, 06
 Mar 2023 21:22:59 -0800 (PST)
Date:   Tue,  7 Mar 2023 05:22:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307052254.198305-1-edumazet@google.com>
Subject: [PATCH net] netfilter: conntrack:
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Customers using GKE 1.25 and 1.26 are facing conntrack issues
root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
max chain length random").

Even if we assume Uniform Hashing, a bucket often reachs 8 chained
items while the load factor of the hash table is smaller than 0.5

With a limit of 16, we reach load factors of 3.
With a limit of 32, we reach load factors of 11.
With a limit of 40, we reach load factors of 15.
With a limit of 50, we reach load factors of 24.

This patch changes MIN_CHAINLEN to 50, to minimize risks.

Ideally, we could in the future add a cushion based on expected
load factor (2 * nf_conntrack_max / nf_conntrack_buckets),
because some setups might expect unusual values.

Fixes: c9c3b6811f74 ("netfilter: conntrack: make max chain length random")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7250082e7de56c77298b0d3b62c4f0dff95b77cc..c6a6a6099b4e2200951367ccd90c12c0ac800a6a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -96,8 +96,8 @@ static DEFINE_MUTEX(nf_conntrack_mutex);
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 #define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
-#define MIN_CHAINLEN	8u
-#define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
+#define MIN_CHAINLEN	50u
+#define MAX_CHAINLEN	(80u - MIN_CHAINLEN)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

