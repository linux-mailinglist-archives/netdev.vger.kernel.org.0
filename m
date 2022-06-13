Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1D547EB9
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 06:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiFMEiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 00:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiFMEhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 00:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC820DE9F
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 21:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655095070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4t9/4CDUpDRGjOQagvJfmDA/AaSuEFVcCFu/jwsJx0=;
        b=e4IABO7XnJJr/PG8BFx/3JqSW1pcZoi1ha4wEqSqCZu2VIo1djmWeU1t64yy1cps5y04HT
        wT2iAETLK2TOjFEMYEgm3N4fV7XjALOibliee3Hd9vkI37pAP7tkFXAAnac57xwzqBrlkq
        GYxABlBGmDr6C3MUZqdThSgmXKgXYrw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-aN0UvhP3N9av4Kxnsnpb6w-1; Mon, 13 Jun 2022 00:37:46 -0400
X-MC-Unique: aN0UvhP3N9av4Kxnsnpb6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B1F580159B;
        Mon, 13 Jun 2022 04:37:46 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4360F492CA2;
        Mon, 13 Jun 2022 04:37:46 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        miquel.raynal@bootlin.com, aahringo@redhat.com
Subject: [PATCHv2 wpan-next 2/2] mac802154: fix atomic_dec_and_test checks
Date:   Mon, 13 Jun 2022 00:37:35 -0400
Message-Id: <20220613043735.1039895-3-aahringo@redhat.com>
In-Reply-To: <20220613043735.1039895-1-aahringo@redhat.com>
References: <20220613043735.1039895-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to call wake_up() when hold_txs reaches zero. The semantic of
atomic_dec_and_test() is that it returns true when it's zero.

Fixes: f0feb3490473 ("net: mac802154: Introduce a tx queue flushing mechanism")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/mac802154/tx.c   | 4 ++--
 net/mac802154/util.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 5b471e932271..8ddcd2e841ca 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -44,7 +44,7 @@ void ieee802154_xmit_sync_worker(struct work_struct *work)
 err_tx:
 	/* Restart the netif queue on each sub_if_data object. */
 	ieee802154_release_queue(local);
-	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+	if (atomic_dec_and_test(&local->phy->ongoing_txs))
 		wake_up(&local->phy->sync_txq);
 	kfree_skb(skb);
 	netdev_dbg(dev, "transmission failed\n");
@@ -101,7 +101,7 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 
 err_wake_netif_queue:
 	ieee802154_release_queue(local);
-	if (!atomic_dec_and_test(&local->phy->ongoing_txs))
+	if (atomic_dec_and_test(&local->phy->ongoing_txs))
 		wake_up(&local->phy->sync_txq);
 err_free_skb:
 	kfree_skb(skb);
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 60f6c0f10641..f08605f59b60 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -141,7 +141,7 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 	}
 
 	dev_consume_skb_any(skb);
-	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+	if (atomic_dec_and_test(&hw->phy->ongoing_txs))
 		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_complete);
@@ -154,7 +154,7 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 	local->tx_result = reason;
 	ieee802154_release_queue(local);
 	dev_kfree_skb_any(skb);
-	if (!atomic_dec_and_test(&hw->phy->ongoing_txs))
+	if (atomic_dec_and_test(&hw->phy->ongoing_txs))
 		wake_up(&hw->phy->sync_txq);
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
-- 
2.31.1

