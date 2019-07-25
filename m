Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3F8749B8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390351AbfGYJUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:20:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39573 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389608AbfGYJUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:20:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so23212226pls.6;
        Thu, 25 Jul 2019 02:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zA7KRGQBThFlm3trFdcFJLFeokCVJBElzgWnMbH4/xY=;
        b=srjPnRvPY/aH+inPjd8GxoBJ9c8BAlAYvCtROiRCw5VK7mQ+3YQsHM9iiU0aJmzDOK
         h9ekc2iQkY03EcwrfIF2JaWxwmbrH0+3NflYT+xFOkQB4ZX0/FFqWJ2eP7mAfwi2rJzS
         Y764XokyisS4CiuKHKUrtAmMjqMgeydLpA//p8q18p4SManU6AsaV1jvovhpNYtM7Qhp
         usFWqBuefOJ4jDrVP2fKbmKX1L7zAp535EcJCSXCdAKw8hrDP18slnoRIaYbAwvLdBiJ
         rCBC0E+Dm/rmnLm051d/2IV9gWl6qbmCfWGVPxBwQ5mfuZ+7mZEs/OGA4kPhjOciD9pa
         clpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zA7KRGQBThFlm3trFdcFJLFeokCVJBElzgWnMbH4/xY=;
        b=DO5nN0DX764/zQdq0bfBlagALCldnHsEc5w8isXQFDKQT/+z8NLDpWm1AOgYJTZ5yp
         2okFWyJtWmW1z20TmfNaIg1ZZz+C1aJoQrjTWyQMCdPL1DWwpf2ZWz4jHiTkU72mW/9s
         LGWK4C5kOvh2iG4SJqwilicKPr9Y1u+eXPkEfgjQ/YqDFNw38i+O6uZysI528FUtQ1Lj
         e0y9Co4iOzFC2iEMBKIRsKYBNwy5lzLFQl/NUHyH+iIs+jdWltJrD5vL9EP+lXS8nTlu
         F1bt2+ifqdmHIA7wy2VU87ORIB0DMqB7rHZXQgQAMI7rVHPosvCoXDkIQuPjIhFkyzmo
         ZLQg==
X-Gm-Message-State: APjAAAVgW4HjkVDpCOLPN/TuQD+ayKQrZ4zuWrxQfDtHUg7XOsMmltu5
        IZWNndGxemR64s5SihbrYURefZqxtnA=
X-Google-Smtp-Source: APXvYqzCqFvoVk/5zWPv6j1nHOEeI11GV0H7hRlvnyHok4PklHT5XXeY2XXVO6icCHcI7eo4VD8Vqg==
X-Received: by 2002:a17:902:6b44:: with SMTP id g4mr89424816plt.152.1564046429985;
        Thu, 25 Jul 2019 02:20:29 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id s24sm49909791pfh.133.2019.07.25.02.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 02:20:29 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: tipc: Fix a possible null-pointer dereference in tipc_publ_purge()
Date:   Thu, 25 Jul 2019 17:20:21 +0800
Message-Id: <20190725092021.15855-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tipc_publ_purge(), there is an if statement on 215 to 
check whether p is NULL: 
    if (p)

When p is NULL, it is used on line 226:
    kfree_rcu(p, rcu);

Thus, a possible null-pointer dereference may occur.

To fix this bug, p is checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/tipc/name_distr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 44abc8e9c990..241ed2274473 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -223,7 +223,8 @@ static void tipc_publ_purge(struct net *net, struct publication *publ, u32 addr)
 		       publ->key);
 	}
 
-	kfree_rcu(p, rcu);
+	if (p)
+		kfree_rcu(p, rcu);
 }
 
 /**
-- 
2.17.0

