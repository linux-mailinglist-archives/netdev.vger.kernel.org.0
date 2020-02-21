Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B20F8168456
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBURED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:04:03 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53811 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgBUREC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:04:02 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so1013410pjc.3;
        Fri, 21 Feb 2020 09:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OrtwbjkzZAaCxu6fxTwX/mVoWu62JfFRRGdv5Z4KXTI=;
        b=k1O1i51idMpFDe5dEonaVt7lv8r+IWCwHuI4KZfyZCFT+qwi7PmhYttbiKM4iTh7Au
         FHkTEXmjTQ0YsNa9zBZc7moIho4xBzOX35szcUBHIiB2NPenhGcHSrLWWTn1m+UL+5Fu
         ggxYBI3yEia96UReNK00nnCCGN9Ss4Nds+Li1ill5jBTM43AaqXCTnUvvMMSdbWJuskK
         4d7ILHS5EbbPgaxE+uMq5RJG90iYGD1jMYcQk3nklQQZqm9ZvPjyModNkdHPfh43+sqV
         MYMWz4pI65aEBvtzsRFzDtkZIV1JRl64DBLipv1zjqQRCf+QZqbsdSw8sieOLKMCu8VJ
         NSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OrtwbjkzZAaCxu6fxTwX/mVoWu62JfFRRGdv5Z4KXTI=;
        b=trMw/2utU7FFfLqQFq52lpeoDLOA7v5LIfZYAR4+jazcfiyioLlxyzeqpDIjKwbCzH
         mTbgZZS/hoS8DRlDtu9qse/j6KcjBb/0maxZasR+HeR0skHBBucGz9uZ7UcerYVT3Te3
         UMO0Hz0M8QflRhkBDedU9qYbbvK7AIG2QS5dh5oTDQALCcyRGpzJGh1OcrPOKbBjSyXw
         13D91hCO70n3Xz5vv9KhsK2azudeORGcifEsPOQkozAuQVm2WV+uZaQWpfvtvAcl7onz
         FFhKMCbm8SzFWY0PFDQRaSwJ8btTMOAODVoh2cB/K6L+cixcEl0E7f3tYANLrBWYvECy
         Inmw==
X-Gm-Message-State: APjAAAXrpqkRoITMnp1FxcN+NqRk1VFX3jE+qOTZdQunGREpelbK6xJL
        Qt6XMwHdqPDD+foTAHzrFg==
X-Google-Smtp-Source: APXvYqzuJMjU0coS40IxkcA1Mlm/EiQPHemJds7FMfgoeAfomG9wYeA6VFDcdwYFvEoIyxpsmBAmgg==
X-Received: by 2002:a17:902:aa45:: with SMTP id c5mr36394887plr.113.1582304640841;
        Fri, 21 Feb 2020 09:04:00 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee0:fe5e:d03d:769b:c838:c146])
        by smtp.gmail.com with ESMTPSA id z4sm3280785pfn.42.2020.02.21.09.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 09:04:00 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     john.fastabend@gmail.com, daniel@iogearbox.net, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: core: sock_map: Use built-in RCU list checking
Date:   Fri, 21 Feb 2020 22:33:47 +0530
Message-Id: <20200221170347.20526-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/core/sock_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index eb114ee419b6..c1549f189b0d 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -546,7 +546,7 @@ sock_hash_lookup_elem_raw(struct hlist_head *head, u32 hash, void *key,
 {
 	struct bpf_htab_elem *elem;
 
-	hlist_for_each_entry_rcu(elem, head, node) {
+	hlist_for_each_entry_rcu(elem, head, node, lockdep_is_held(&bucket->lock)) {
 		if (elem->hash == hash &&
 		    !memcmp(&elem->key, key, key_size))
 			return elem;
-- 
2.17.1

