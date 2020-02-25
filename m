Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F156616C1B8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgBYNIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:08:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37929 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgBYNIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:08:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so7166950pfc.5;
        Tue, 25 Feb 2020 05:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1bjATN5yUQRktfOaoPKCC0Tyl9TIao9QDPF9Tp8wgtM=;
        b=uvN6kIxK9vk6GbegcH4Kbd7p2T9YC5SqOl4mUP7VZYonTQTCsZzdM5Wb/iD3AGteau
         sUjlLSX5mg48I8NaR6m8Ls4t45N+CXdESz1LJ8pYWP9VIVGHPbEjt7vKINgMQoHR8k/N
         S4c5mu7Boh49/asjAfxDsrczi3xkcjA5TmYu7C3zhAZTjnOfimGQXGlJKHIIo6vHMNfY
         5HWx5XVpCFys9o4JmQk0u0V9zsev1jLeTU3aTJu0DIA6z3e66IwQ0y7+T4ta0v/RQVYE
         HFYzLyR4QjxCcPPaH3z6pVIjTRcZPXr0tyojGCk5PZkeDuTnnU61zGtj1aX9wuHta89S
         hTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1bjATN5yUQRktfOaoPKCC0Tyl9TIao9QDPF9Tp8wgtM=;
        b=LxnLw241wodknEsEzoqiqtoDjr6NWY/DdOGZuZ8a2UbU1LfbucZ7gOtnVkoalC0cqy
         7uhCWaLnJZTX92/WdWUbmOVCbnhiS992X4qVvdaGTKosHSSiVqExBZVrFc0acTuAOh4y
         koNOVcMyFdj5ut//ajFy4ifXYJr2n0sBioyakPTy43pTOFAedgBcJx+/UWEJ0jcBfnN4
         wbt/3lXuZv/J0wXnAfQI7XeQKYdj9vEm/kg3HTLlVwSdi18l3QMiA9Po7udgIf3HS8n0
         hPYgw738m+YJgZEzFeNoatLmIkfV6vheZBTj4tmyusfEVfmo3vWDVw4HZtHnn2sZl4S+
         67yg==
X-Gm-Message-State: APjAAAXwFf/NF3o0JukuLbJTFYiqhhafImNuIUbRGj4DLgsguZfusmGJ
        sZaArdWt/v1yG/AG9zlUXQ==
X-Google-Smtp-Source: APXvYqwaimesWPD/s9AtUlqC9UWr76llfcjVPJ/inH6Pf263cKIywJYT06l587vdDDb+Q4G/RHQ4Uw==
X-Received: by 2002:a63:cf4f:: with SMTP id b15mr34802096pgj.287.1582636099106;
        Tue, 25 Feb 2020 05:08:19 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee1:f355:dcbb:6353:6580:5d41])
        by smtp.gmail.com with ESMTPSA id 5sm17241541pfx.163.2020.02.25.05.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:08:18 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: bluetooth: hci_core: Fix Suspicious RCU usage warnings
Date:   Tue, 25 Feb 2020 18:38:09 +0530
Message-Id: <20200225130809.32750-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

The following functions in hci_core are always called with
hdev->lock held. No need to use list_for_each_entry_rcu(), therefore
change the usage of list_for_each_entry_rcu() in these functions
to list_for_each_entry().

hci_link_keys_clear()
hci_smp_ltks_clear()
hci_smp_irks_clear()
hci_blocked_keys_clear()

Warning encountered with CONFIG_PROVE_RCU_LIST:

[   72.213184] =============================
[   72.213188] WARNING: suspicious RCU usage
[   72.213192] 5.6.0-rc1+ #5 Not tainted
[   72.213195] -----------------------------
[   72.213198] net/bluetooth/hci_core.c:2288 RCU-list traversed in non-reader section!!

[   72.213676] =============================
[   72.213679] WARNING: suspicious RCU usage
[   72.213683] 5.6.0-rc1+ #5 Not tainted
[   72.213685] -----------------------------
[   72.213689] net/bluetooth/hci_core.c:2298 RCU-list traversed in non-reader section!!

[   72.214195] =============================
[   72.214198] WARNING: suspicious RCU usage
[   72.214201] 5.6.0-rc1+ #5 Not tainted
[   72.214204] -----------------------------
[   72.214208] net/bluetooth/hci_core.c:2308 RCU-list traversed in non-reader section!!

[  333.456972] =============================
[  333.456979] WARNING: suspicious RCU usage
[  333.457001] 5.6.0-rc1+ #5 Not tainted
[  333.457007] -----------------------------
[  333.457014] net/bluetooth/hci_core.c:2318 RCU-list traversed in non-reader section!!

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/bluetooth/hci_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cbbc34a006d1..8ddd1bea02be 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2285,7 +2285,7 @@ void hci_link_keys_clear(struct hci_dev *hdev)
 {
 	struct link_key *key;
 
-	list_for_each_entry_rcu(key, &hdev->link_keys, list) {
+	list_for_each_entry(key, &hdev->link_keys, list) {
 		list_del_rcu(&key->list);
 		kfree_rcu(key, rcu);
 	}
@@ -2295,7 +2295,7 @@ void hci_smp_ltks_clear(struct hci_dev *hdev)
 {
 	struct smp_ltk *k;
 
-	list_for_each_entry_rcu(k, &hdev->long_term_keys, list) {
+	list_for_each_entry(k, &hdev->long_term_keys, list) {
 		list_del_rcu(&k->list);
 		kfree_rcu(k, rcu);
 	}
@@ -2305,7 +2305,7 @@ void hci_smp_irks_clear(struct hci_dev *hdev)
 {
 	struct smp_irk *k;
 
-	list_for_each_entry_rcu(k, &hdev->identity_resolving_keys, list) {
+	list_for_each_entry(k, &hdev->identity_resolving_keys, list) {
 		list_del_rcu(&k->list);
 		kfree_rcu(k, rcu);
 	}
@@ -2315,7 +2315,7 @@ void hci_blocked_keys_clear(struct hci_dev *hdev)
 {
 	struct blocked_key *b;
 
-	list_for_each_entry_rcu(b, &hdev->blocked_keys, list) {
+	list_for_each_entry(b, &hdev->blocked_keys, list) {
 		list_del_rcu(&b->list);
 		kfree_rcu(b, rcu);
 	}
-- 
2.17.1

