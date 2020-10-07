Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F4B285C9C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgJGKMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgJGKMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:12:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82D4C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:12:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id l126so1069674pfd.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z5OunPFStjs4HMvaYm8EjgeNUx/EpSL1WD0hDTrNWbI=;
        b=Ekk7lGunnVJ8afXxNlM8fL1IENf2Lxco3hR/XucFGqzRNzq7h7qEtefWqIT1p++Sy/
         jZdc1o4pK2NfnDBR8BMiD70Gbtn5fuR3ud2FrO3bwnGhQ/pIkp+z5QA6IBcQFJ2TkBCU
         tRxg0TZA3vqp0AOT4AVsFyrVelS1Ex/bxPAXb7/gXm8e1MpDvQbBWjIRP6WKCp/vbjzv
         9C8KxvYMkgPxihNkHPI7qYCftMqHKvhVZbT0U+i4KXZCsHSXEmkiwT6Ffy3FCHpv0b4U
         JEF91iFeaCVQB0qKIa3wLn9i+B4wW5hdF/jQPouv5YXTEwJbmBW27nNjxm7HszG91Wl6
         nm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5OunPFStjs4HMvaYm8EjgeNUx/EpSL1WD0hDTrNWbI=;
        b=mV6sqF0f2mpNgnHatN64PU/uheyTvcz1yi82EOlad1HjFR66Tpr1U3F/DiqNn1swTF
         xedSgDVtNwd8gzdz+Th7kbq4qOQoYwcJlNMh7c61eksUalB5SjSXov5XbPZR36jkzfdm
         ADQULB6EqNWWBswkOkjpj9I6hPuGackK9BXnczYY1TNpV0HAbBAP3j8Hw4Mtm1VPkT/i
         2dYaNEm2acSs5L9CcfbY9PPa4PPWCqDeO/+Kko8JBUMEIWACw1zeicEGB3Im5N6NSPip
         1XycXGP5qKrRP6REEDiHogwHYlhEDT05sL2hErz9p+/JXfjKkL6G6DH4YwFdQG/M9QXE
         AQ5Q==
X-Gm-Message-State: AOAM531BLdJ92KDBva6BhXcYOQpmAEfC5i4EUuq80/v92d5ftYO7Yd77
        isp4YpNrhEiVlULi/wevuJE=
X-Google-Smtp-Source: ABdhPJy7vkzDkf1PP/n/7I1jJdS9EzLrE0uIK7vW/UQhDSaOoEAkqo+ga0zJWiNl6XhuYB2AThNGsw==
X-Received: by 2002:a62:6044:0:b029:151:1a04:895 with SMTP id u65-20020a6260440000b02901511a040895mr2337057pfb.34.1602065574264;
        Wed, 07 Oct 2020 03:12:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:12:53 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v2 3/8] net: mac80211: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:14 +0530
Message-Id: <20201007101219.356499-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c3e357857..6d083a146 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1795,7 +1795,7 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
-void ieee80211_tx_pending(unsigned long data);
+void ieee80211_tx_pending(struct tasklet_struct *t);
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
@@ -2143,7 +2143,7 @@ void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
 void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
 			      struct txq_info *txqi);
-void ieee80211_wake_txqs(unsigned long data);
+void ieee80211_wake_txqs(struct tasklet_struct *t);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 523380aed..48ab05186 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -220,9 +220,9 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 	       BSS_CHANGED_ERP_SLOT;
 }
 
-static void ieee80211_tasklet_handler(unsigned long data)
+static void ieee80211_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -733,16 +733,12 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		skb_queue_head_init(&local->pending[i]);
 		atomic_set(&local->agg_queue_stop[i], 0);
 	}
-	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
-		     (unsigned long)local);
+	tasklet_setup(&local->tx_pending_tasklet, ieee80211_tx_pending);
 
 	if (ops->wake_tx_queue)
-		tasklet_init(&local->wake_txqs_tasklet, ieee80211_wake_txqs,
-			     (unsigned long)local);
+		tasklet_setup(&local->wake_txqs_tasklet, ieee80211_wake_txqs);
 
-	tasklet_init(&local->tasklet,
-		     ieee80211_tasklet_handler,
-		     (unsigned long) local);
+	tasklet_setup(&local->tasklet, ieee80211_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8ba10a48d..a50c0edb1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4406,9 +4406,10 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 /*
  * Transmit all pending packets. Called from tasklet.
  */
-void ieee80211_tx_pending(unsigned long data)
+void ieee80211_tx_pending(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     tx_pending_tasklet);
 	unsigned long flags;
 	int i;
 	bool txok;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 493420604..a25e47750 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -386,9 +386,10 @@ _ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
 	rcu_read_unlock();
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+void ieee80211_wake_txqs(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     wake_txqs_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-- 
2.25.1

