Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A8162EE8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBRSmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:42:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44827 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgBRSmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:42:44 -0500
Received: by mail-pf1-f195.google.com with SMTP id y5so11076972pfb.11;
        Tue, 18 Feb 2020 10:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FRPijcKo7kcY7YCcx2mnm2XntT5PXC3jc8cYZD9bnvc=;
        b=STSEWAj2mLLdHZrKCoSsV8S5dtobBUHz7/MKp0aKP2JnTSV18tnQhlLbjjBD5wAsyk
         ePvAISX8FcYTeBxh36DpesEK5H9hLIyHXPCaI53agF7h6zTrNhh3MO1631cf4QqufW42
         QQkE6llrFzaX0E7sDPbCe7F1FpDG8zHWxqNSBvWm8MucYpATLWu79qFmG5UWT7kRbWSj
         ltd36F12euAfNFEi+OdRHdpdTBNOQ/c0HHX+mvTuxDbggM8hbFsAOPnqU/edC1lHjvVR
         12Dux0Qg5EpOjGIdANsYT0hynAY00NrxXqpcQImu6orXAs/FBnK8po4uRFlIkNTmvl5m
         J4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FRPijcKo7kcY7YCcx2mnm2XntT5PXC3jc8cYZD9bnvc=;
        b=FvcCwn/jIRk/66QWFCKye09gc+rn1z6cBtVyLonAqASFQlQu4hmm1muddWvNM7Q/Er
         TvVhCcyDig43j99JyZ5mgDsoziJsgQZWNF8Zt+OY3kBRFnly1iU06a7/k52V02ae2oIS
         Kvk1fIX3/ZrsZ2orYYT8ylSZ0h5us1QjVygUqlGQ4HkVzzyfaK/8wPvfbnWmQvzqiIy7
         ZSWjkFYulDlnkb+skB9cjUayTP/47K6OP+PpQLqAYZOxAhHO2eygFX0EdZ9O/IRJk4Aq
         8eOiccY3IRz4+HJc5FUsds7kciWNu7j3bkgw6hK+Bc6tth5QXjcJf7cMkwgaBgvcnnQO
         r9Pw==
X-Gm-Message-State: APjAAAVDWLQxc0yM3UBtvI19rxxyn91pO81XfrvuC/ZQUjxb3/dJjyKD
        Hb81gGNcaSaOl2ibVp0tNg==
X-Google-Smtp-Source: APXvYqwl800bbQ26s9xKJZDhrO9PdZlbIcrYNVvwauRbeX7NJfuXFF1uGmSM7zo9LH4rJfVnnVed0w==
X-Received: by 2002:a63:515d:: with SMTP id r29mr23493038pgl.265.1582051363462;
        Tue, 18 Feb 2020 10:42:43 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:54c:a276:f869:e1e5:121e:cdbf])
        by smtp.gmail.com with ESMTPSA id v5sm5526791pgc.11.2020.02.18.10.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 10:42:42 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     paul@paul-moore.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] netlabel_domainhash.c: Use built-in RCU list checking
Date:   Wed, 19 Feb 2020 00:11:32 +0530
Message-Id: <20200218184132.20363-1-madhuparnabhowmik10@gmail.com>
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
 net/netlabel/netlabel_domainhash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index f5d34da0646e..a1f2320ecc16 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -143,7 +143,8 @@ static struct netlbl_dom_map *netlbl_domhsh_search(const char *domain,
 	if (domain != NULL) {
 		bkt = netlbl_domhsh_hash(domain);
 		bkt_list = &netlbl_domhsh_rcu_deref(netlbl_domhsh)->tbl[bkt];
-		list_for_each_entry_rcu(iter, bkt_list, list)
+		list_for_each_entry_rcu(iter, bkt_list, list,
+					lockdep_is_held(&netlbl_domhsh_lock))
 			if (iter->valid &&
 			    netlbl_family_match(iter->family, family) &&
 			    strcmp(iter->domain, domain) == 0)
-- 
2.17.1

