Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483C64F7C6D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244135AbiDGKLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244123AbiDGKLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:14 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D42172E19;
        Thu,  7 Apr 2022 03:09:14 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8738760006;
        Thu,  7 Apr 2022 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sU6IzB0t/DtESo61MF3mytkIx1IBpiMobkcoPdkv94E=;
        b=CpzFuwdb/3IF28UsxqumIG+5sQ+NRu7+wcNsCVnUer3BLXg8ArIDkuOJY/qVm0YMzsYU6n
        99oMEz81I0WP/jhMYHZDDybwkxZPgBTiJtJ5UBXVF/+h3B2sMb5YloBL9vdx19yRvZL8LJ
        KnyXHY4BCrxqIG40zUDelD00xuzslAqk63Q4Dh2wygtmRJBMXQpyNyGpcdIuB/qs1HZMsl
        v+tEjceYxWVkGvWsGpS7xfjGuvGaLyUTpF9Xkub5dShdxfv/G0DuJF9Hu9/qIfqat0onTd
        5WKtqzXlCXCudCXMUm/f0z2T5wr/Fh8u9fgo4ZQxyCKS4hpR9DCy+5c+uD02gQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v6 05/10] net: mac802154: Create an error helper for asynchronous offloading errors
Date:   Thu,  7 Apr 2022 12:08:58 +0200
Message-Id: <20220407100903.1695973-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few drivers do the full transmit operation asynchronously, which means
that a bus error that happens when forwarding the packet to the
transmitter or a timeout happening when offloading the request to the
transmitter will not be reported immediately.

The solution in this case is to call this new helper to free the
necessary resources, restart the queue and always return the same
generic TRAC error code: IEEE802154_SYSTEM_ERROR.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h | 9 +++++++++
 net/mac802154/util.c    | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 29f289d58720..bdac0ddbdcdb 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -508,4 +508,13 @@ void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 			   int reason);
 
+/**
+ * ieee802154_xmit_hw_error - frame could not be offloaded to the transmitter
+ *                            because of a hardware error (bus error, timeout, etc)
+ *
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ * @skb: buffer for transmission
+ */
+void ieee802154_xmit_hw_error(struct ieee802154_hw *hw, struct sk_buff *skb);
+
 #endif /* NET_MAC802154_H */
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index ec523335336c..9f024d85563b 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -102,6 +102,12 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
+void ieee802154_xmit_hw_error(struct ieee802154_hw *hw, struct sk_buff *skb)
+{
+	ieee802154_xmit_error(hw, skb, IEEE802154_SYSTEM_ERROR);
+}
+EXPORT_SYMBOL(ieee802154_xmit_hw_error);
+
 void ieee802154_stop_device(struct ieee802154_local *local)
 {
 	flush_workqueue(local->workqueue);
-- 
2.27.0

