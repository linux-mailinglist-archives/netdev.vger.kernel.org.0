Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74491FBD6
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 22:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfEOUz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 16:55:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39849 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfEOUz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 16:55:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id y42so1397644qtk.6
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 13:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jb+iuYRwzEtpyUtUCF5pkxekAJ5ZvFOuXv0Om74AOK4=;
        b=T262mEfkYiHWzxpWMjWZHMOayCEvkQA0UBdxFytCblCubuWnSbpGtVqQPycbD9KbPK
         JIlY4fp/Z0B32p/FK7iPHgHiPKlSypRgb89SNkPigsJmCU5ocTdqPdGvdBISGU4ZLcGf
         gZebsJ0hABH54KyY/Z7xeEbFq78cCu4jrWKeJL7HEp9UwZD5wlXt0433QUmh1z/HhHAG
         S8gOhYb7JsPg/9PfZpGls3spXT7kV7zTum8Dbp2rXsRQNcUfDZGD8Xjm2QiHeu+RD9Gl
         3qWR0gLsa7aLyp28XhHZvQHoMfiTOagZRwJ0AoylFd7pl81y9/boIVRX6/XzzO732QM1
         +suA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jb+iuYRwzEtpyUtUCF5pkxekAJ5ZvFOuXv0Om74AOK4=;
        b=Uyqi8+EeCgCMABNWKS6AcHLQYc9F8WHn25Zb3Waulu7UPwhtHu17v+8IuvUL7LhEf8
         b6vj96jqYZFTVKvH7PUcGd7hCPNMGrJ95bC8vrXXVO97PaNFNQjbLPnpYnuK9xuIsY3T
         /gmoE/jkrfS53/krqRzh2eu4fOw4Z5hjBaNfETzskOZoTZe5+z9ZWJu7Ja/uDDsUD1Wp
         CrJ5xWWaYyv7fHvaAGDtPhlcysJRffe0jkPfDZDaAmjwRlQPH0K0P51g+Mper21T5CUI
         bVqaOjoNi5lH69YBFciTEOiron6qbVRwSozHZKilwLtdY9NHqDDZbCzSJOZRwtz6Wlgr
         xxpg==
X-Gm-Message-State: APjAAAWxE4MQK1M9yLF4hNx7YUG4/TwKGG1WQbtPoqrbd28iNF8CqWcj
        Kss14kyvghS7DdUQGwu/IdH5+g==
X-Google-Smtp-Source: APXvYqzaVzRipDshMhJ6rHeg/9OoKhxwf1iRsD/8ns8Dyaqs+S1udc/tq2e7bleqidMLC6w0IZJw2g==
X-Received: by 2002:aed:3eb8:: with SMTP id n53mr38362434qtf.286.1557953727876;
        Wed, 15 May 2019 13:55:27 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e37sm2298729qte.23.2019.05.15.13.55.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 13:55:27 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, tgraf@suug.ch, netdev@vger.kernel.org,
        oss-drivers@netronome.com, neilb@suse.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] rhashtable: fix sparse RCU warnings on bit lock in bucket pointer
Date:   Wed, 15 May 2019 13:55:01 -0700
Message-Id: <20190515205501.17810-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the bit_spin_lock() operations don't actually dereference
the pointer, it's fine to forcefully drop the RCU annotation.
This fixes 7 sparse warnings per include site.

Fixes: 8f0db018006a ("rhashtable: use bit_spin_locks to protect hash bucket.")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/linux/rhashtable.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index f7714d3b46bd..bea1e0440ab4 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -325,27 +325,27 @@ static inline struct rhash_lock_head __rcu **rht_bucket_insert(
  */
 
 static inline void rht_lock(struct bucket_table *tbl,
-			    struct rhash_lock_head **bkt)
+			    struct rhash_lock_head __rcu **bkt)
 {
 	local_bh_disable();
-	bit_spin_lock(0, (unsigned long *)bkt);
+	bit_spin_lock(0, (unsigned long __force *)bkt);
 	lock_map_acquire(&tbl->dep_map);
 }
 
 static inline void rht_lock_nested(struct bucket_table *tbl,
-				   struct rhash_lock_head **bucket,
+				   struct rhash_lock_head __rcu **bkt,
 				   unsigned int subclass)
 {
 	local_bh_disable();
-	bit_spin_lock(0, (unsigned long *)bucket);
+	bit_spin_lock(0, (unsigned long __force *)bkt);
 	lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
 }
 
 static inline void rht_unlock(struct bucket_table *tbl,
-			      struct rhash_lock_head **bkt)
+			      struct rhash_lock_head __rcu **bkt)
 {
 	lock_map_release(&tbl->dep_map);
-	bit_spin_unlock(0, (unsigned long *)bkt);
+	bit_spin_unlock(0, (unsigned long __force *)bkt);
 	local_bh_enable();
 }
 
-- 
2.21.0

