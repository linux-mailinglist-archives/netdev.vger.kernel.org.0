Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E04162E3C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgBRSRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:17:50 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34773 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRSRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:17:49 -0500
Received: by mail-pj1-f66.google.com with SMTP id f2so848770pjq.1;
        Tue, 18 Feb 2020 10:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tw386GnWn7lj+7DS5UVonCjIBe7s4kOvANVaGw+hVzg=;
        b=YhOhNOGMg32OFt9+hY8OakRL4DmVH0jPNRRNE/E6tkW/9ccBR09BQA7dCQUs2MkmUu
         mARR3uHwAkKSOVX+kcW1sZFEihdGg6YcfHt4rgk3uekBDYLocuAG+oOBDcBhvv6BsqXJ
         dyy0x6j8c8aQy6Jqv4YLREsxGD1wl7U/nD+ADGhKoWCDJcETad+RpMrhLuuK565r68VM
         Irhn27ZhTQ/t/CZGbPPj4qvukPMUzUZO3UAYtopsVf+MDqOh9vs86Kummox/0AfpMKaX
         CEPGdzAzvbMiar11LAE1NX7bNRqXtJKzzgSyrUXJ00luH0kGWCXk5u9z6qaC70WAs3BD
         XClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tw386GnWn7lj+7DS5UVonCjIBe7s4kOvANVaGw+hVzg=;
        b=t+qbaIKr+b4l+dtXyD4yHfa7HWzNylev7z6ONoJwGjWHpu9ehU5cMRPyfTOzAv81pB
         l2blZSs7TUsSq298V1olIe5e8NRysfIPrP+HuvRPhVBNgrU4qgNYt0yfjhKMBnivMzeU
         MN+SsTIbJAPxOH7bEvjsvRqu3AVMdz85q6MwlD2gnl0C90jlOEcgQvxzDIuunrnlpBzV
         Txbmycx5v7hRLjRjMTBkxEi/S4uzm8aYNZS0j3JWWuqknJkgcHEvqoQwDTHrkPvBGiKU
         zG9SFrPDzzN7aHVsm8wcYFY4IPKGp2samVU5R4pm9KE7m42ovHM5O33BC0ygiR4DYZcZ
         Z5eA==
X-Gm-Message-State: APjAAAW7xdUe1qKZrd8ADOKZT8E43lJTSCeE6vnmWYIrYRvdbzojIh3s
        L4tDWZxU2GwSTjW6GWQOtQ==
X-Google-Smtp-Source: APXvYqwOgUC5exI24u36RZ9dseIdpW0+8p5dXgCQ/NuN3Ou6YZrerHkWr3LK9lWM9jlF1o9vCDlFuw==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr21462103pls.160.1582049869131;
        Tue, 18 Feb 2020 10:17:49 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:54c:a276:f869:e1e5:121e:cdbf])
        by smtp.gmail.com with ESMTPSA id f3sm5474950pga.38.2020.02.18.10.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 10:17:48 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     paul@paul-moore.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: netlabel: Use built-in RCU list checking
Date:   Tue, 18 Feb 2020 23:47:18 +0530
Message-Id: <20200218181718.7258-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/netlabel/netlabel_unlabeled.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index d2e4ab8d1cb1..77bb1bb22c3b 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -207,7 +207,8 @@ static struct netlbl_unlhsh_iface *netlbl_unlhsh_search_iface(int ifindex)
 
 	bkt = netlbl_unlhsh_hash(ifindex);
 	bkt_list = &netlbl_unlhsh_rcu_deref(netlbl_unlhsh)->tbl[bkt];
-	list_for_each_entry_rcu(iter, bkt_list, list)
+	list_for_each_entry_rcu(iter, bkt_list, list,
+				lockdep_is_held(&netlbl_unlhsh_lock))
 		if (iter->valid && iter->ifindex == ifindex)
 			return iter;
 
-- 
2.17.1

