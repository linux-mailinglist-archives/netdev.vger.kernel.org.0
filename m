Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0E8547EB7
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 06:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiFMEir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 00:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiFMEhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 00:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DA9ADE8B
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 21:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655095069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFK8VgmfKhb8+ilAV4dF73pOZWBIxqI+j0j5EzbPtiU=;
        b=IMRCM/TT1gytzVtX1EYNRqDu1YI6+BRbJTRgTFLeVglatVWtFx/69jo5gHLob/LFboNmOC
        bYWbAy8Y5EfdPsjS/FigiMDS550FPe1rtgbyeRdaJxGaPMMsygNsY3nyP8jYHJzHAYraZK
        1OyfqgUGSve3i+wivcVDtCJmnUIW5Sk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-JExgUTjtPuuzTQm2rQu0EQ-1; Mon, 13 Jun 2022 00:37:46 -0400
X-MC-Unique: JExgUTjtPuuzTQm2rQu0EQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B288811E75;
        Mon, 13 Jun 2022 04:37:46 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1393D492CA2;
        Mon, 13 Jun 2022 04:37:46 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        miquel.raynal@bootlin.com, aahringo@redhat.com
Subject: [PATCHv2 wpan-next 1/2] mac802154: util: fix release queue handling
Date:   Mon, 13 Jun 2022 00:37:34 -0400
Message-Id: <20220613043735.1039895-2-aahringo@redhat.com>
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

The semantic of atomic_dec_and_test() is to return true if zero is
reached and we need call ieee802154_wake_queue() when zero is reached.

Fixes: 20a19d1df3e4 ("net: mac802154: Bring the ability to hold the transmit queue")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/mac802154/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index 60eb7bd3bfc1..60f6c0f10641 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -79,7 +79,7 @@ void ieee802154_release_queue(struct ieee802154_local *local)
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->phy->queue_lock, flags);
-	if (!atomic_dec_and_test(&local->phy->hold_txs))
+	if (atomic_dec_and_test(&local->phy->hold_txs))
 		ieee802154_wake_queue(&local->hw);
 	spin_unlock_irqrestore(&local->phy->queue_lock, flags);
 }
-- 
2.31.1

