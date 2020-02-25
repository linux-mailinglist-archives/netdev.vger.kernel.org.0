Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782F916C1AF
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgBYNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:07:23 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40277 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbgBYNHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:07:22 -0500
Received: by mail-pl1-f196.google.com with SMTP id y1so5473088plp.7;
        Tue, 25 Feb 2020 05:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1bjATN5yUQRktfOaoPKCC0Tyl9TIao9QDPF9Tp8wgtM=;
        b=c/aX2xklwzN+KnL1Z0gS/vWAo34D7B+EVCyRXa1sgSGIxkEwXGMtnLjDb06SaW6TV4
         poMEIqGLmg1KJrMLIUiVgZS0KWPG8ctxN7CBg9Ly/OimQ1ZgN6Y6NgVj7AgdClRM+jb5
         EW0Xut8jNmTiVhGfgelmisiwJiDIwm7tuzzx2el4955WR6jKsFGeUJMrgOzeOLIvdzSJ
         itgDnFljBrFvVl9FVXN63kKDys0rdJtm/Xwkv9kEVztRae2l2+34UPgc5tjPIK3swwx4
         jnMp7VuSAmIfweh50M43NWjfak/4QtyjVk28klahBW9drhnBIsR1Ud1/0RionuTuDYhv
         yLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1bjATN5yUQRktfOaoPKCC0Tyl9TIao9QDPF9Tp8wgtM=;
        b=SCdv8jUd1wzquk2X3S06G19VJX0SoDB4tkC0RlhWDvVDAnQocZ4G46AG58r6OvnElP
         4Iy3bjTC9fSdcMuWxPgciaXgnE/FnPhrsXOzJqg+dSI34n2JXg8IXtKrNNMshi9vM6MC
         DHmcGfNhlaIf6tv6BMvFCfszGXNvsvHuH1w00N/C1b4aZvVOoA6bSxJBu2UCddmTzo+/
         0HKMyTL3zS/lVHJh+2py0hyzMCDk3AxGt03yq56CmfsCOlpnj8b1K40WmPLJe1V/BxPg
         iYBzyHHiNZ8ho5D/tgfK40iaoFXFEJuWrpj1+/YviR0hXPZyJb21mGzyRYGW2vMUvul2
         Hbzg==
X-Gm-Message-State: APjAAAWS1yhv/ko78ryHM6cRYNmI0DGxPjRNbzGGTgEjECqAtZTWmXUL
        1n4a2dx7OD3o0YNqiZaOSvBcmR8=
X-Google-Smtp-Source: APXvYqx9u7699mSLH5QM5nQvKggMKDwMmVA1TGSCMDygfPwY1tQRBvHxTUNFIRyMh+PucBct8heGZA==
X-Received: by 2002:a17:902:223:: with SMTP id 32mr55786706plc.167.1582636041493;
        Tue, 25 Feb 2020 05:07:21 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([112.79.48.254])
        by smtp.gmail.com with ESMTPSA id e2sm3156979pjs.25.2020.02.25.05.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:07:20 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.or, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: bluetooth: hci_core: Fix Suspicious RCU usage warnings
Date:   Tue, 25 Feb 2020 18:36:38 +0530
Message-Id: <20200225130638.32394-1-madhuparnabhowmik10@gmail.com>
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

