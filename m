Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A135160461
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 15:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgBPOrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 09:47:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37306 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgBPOre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 09:47:34 -0500
Received: by mail-pj1-f68.google.com with SMTP id m13so6076822pjb.2;
        Sun, 16 Feb 2020 06:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/yxpPs59abqNVjxSYNlOB5b7zvZlqst1mIuiTiFCWSM=;
        b=MtDv+8SJmurZEHiKTetbGWqHr1+D9ZFirpF2VAcMFMR5FKWTQUgJascjxn6wo3VSJ6
         c/8OeKK66WVHn4IZNXfBQr3kMo8VGv0asPB8ERRVQ/SNG0O+vum8rb6n5f6vD75LEWqb
         02HV7Zdv+0Nei29jy+oP6WyxVi8K/eggvooFsnN2OKc0dwphYOY+7+r6n97tcCGWxW8Z
         Z4gm4z7oY4lfEo1Jsp9HtCfTFKDF15tWFeLtF56YHmJVWrrHCE6uQNTfdGC3vFJcZUO9
         fYvMI8dtt3xVIK9DQ6uN7LaYAurOx7UtspBYpyqQ7bqPjFKHvkNSWKZUEUg3KZuysJjX
         IDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/yxpPs59abqNVjxSYNlOB5b7zvZlqst1mIuiTiFCWSM=;
        b=m2/PC1X+oePTurAnWEgcPsJY3aioELCycnU9rqDldaWjDpdEsdVy4hfY85M5YIhO/i
         +ws0owtHLf8i+LD0V9lSgaY2j5RnYzP1l1n7g7GUWVdtUKyX/gjsrDpxVU0bkHLug7xt
         43/i6E4xQo2A8w5dKMuIfD/sqysnbuYsHyyOKnn7w9u6eQswwuuequtRm03Hhdwh5i2K
         O0XDLUVdKprHzr9/hZSnM4WRRCT6gJ6duQG+5DEdWFPHxjnPiEjwWv8EmdvqddloR42A
         bzLhz2YaNtN99PM0KGteEMpDXDTow/I9LsuFa1vsYBH6HYB5nzkkwQ3EJQ2TIzKdGoBC
         Tlug==
X-Gm-Message-State: APjAAAXp0m2LMimjgaeKZ4JiHUNeIfBg17ldwfKBnJ2qQQMEHdZOnMwI
        YK4Bb4r380L7ZzHytEOYzgypr5s=
X-Google-Smtp-Source: APXvYqz4n3ibLmZFW/6xgnZe1Gc126eGPEgdC06A/0OYeZxnDP8axu+/9nkB06ALCtMl7qIx0JIxlw==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr14713869pjb.89.1581864452748;
        Sun, 16 Feb 2020 06:47:32 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:d03:50cf:55e:33bd:4fac:caa])
        by smtp.gmail.com with ESMTPSA id t15sm13683049pgr.60.2020.02.16.06.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 06:47:32 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: batman-adv: Use built-in RCU list checking
Date:   Sun, 16 Feb 2020 20:17:18 +0530
Message-Id: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to hlist_for_each_entry_rcu() to silence
false lockdep warnings when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/batman-adv/translation-table.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8a482c5ec67b..0e3c31cbe0e8 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -862,7 +862,8 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	u8 *tt_change_ptr;
 
 	spin_lock_bh(&orig_node->vlan_list_lock);
-	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
+	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list,
+				lockdep_is_held(&orig_node->vlan_list_lock)) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
 	}
@@ -888,7 +889,8 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	(*tt_data)->num_vlan = htons(num_vlan);
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
-	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
+	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list,
+				lockdep_is_held(&orig_node->vlan_list_lock)) {
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
 
@@ -937,7 +939,8 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	int change_offset;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
-	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list,
+				lockdep_is_held(&bat_priv->softif_vlan_list_lock)) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
 		if (vlan_entries < 1)
 			continue;
@@ -967,7 +970,8 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	(*tt_data)->num_vlan = htons(num_vlan);
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
-	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list,
+				lockdep_is_held(&bat_priv->softif_vlan_list_lock)) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
 		if (vlan_entries < 1)
 			continue;
-- 
2.17.1

