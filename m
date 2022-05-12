Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF96525023
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbiELOd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355352AbiELOdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:47 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4B925E782;
        Thu, 12 May 2022 07:33:32 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 68A03FF80B;
        Thu, 12 May 2022 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652366011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e94S7M6FmCgpmql892vEUBnUE0cfzYvX74OoUdY9rRc=;
        b=KpfSYB6pkZYwAUS1STTllJjW34c0ENphPyEQRiyzy3mzZQwXPCE1rfu6JPkwO5vhZSUiEe
        fRrvramxeR0SCRJkHAcvQs4giiFZN5+TJdnhprfM/g1IqbFOB9xi+ogAZor6o4Ih7o5qNE
        hmO/8/hCD4Lk3gTSL0Blo7ViTgRKQX3+WUPusbnuAdMCwT0Kg+lGobGmc2lUmTrylu10wp
        JbETRdY+iCWVsnMObLv6rAFktcyhTPKiF1t0ZDSfE4kyDfD1johhCU6UDVXXGzr1LgtQ37
        Nszbbyr29ubGkfrQLEMzvqyRRlhUy6szZpaizSLS1sLPSk3VUt/EY+nhoaLN1g==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 09/11] net: mac802154: Introduce a synchronous API for MLME commands
Date:   Thu, 12 May 2022 16:33:12 +0200
Message-Id: <20220512143314.235604-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512143314.235604-1-miquel.raynal@bootlin.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the slow path, we need to wait for each command to be processed
before continuing so let's introduce an helper which does the
transmission and blocks until it gets notified of its asynchronous
completion. This helper is going to be used when introducing scan
support.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/ieee802154_i.h |  1 +
 net/mac802154/tx.c           | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
index a057827fc48a..f8b374810a11 100644
--- a/net/mac802154/ieee802154_i.h
+++ b/net/mac802154/ieee802154_i.h
@@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
 void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
 void ieee802154_xmit_sync_worker(struct work_struct *work);
 int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
 netdev_tx_t
 ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 netdev_tx_t
diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 38f74b8b6740..ec8d872143ee 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -128,6 +128,31 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ieee802154_sync_queue(local);
 }
 
+int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
+{
+	int ret;
+
+	/* Avoid possible calls to ->ndo_stop() when we asynchronously perform
+	 * MLME transmissions.
+	 */
+	rtnl_lock();
+
+	/* Ensure the device was not stopped, otherwise error out */
+	if (!local->open_count)
+		return -EBUSY;
+
+	ieee802154_sync_and_hold_queue(local);
+
+	ieee802154_tx(local, skb);
+	ret = ieee802154_sync_queue(local);
+
+	ieee802154_release_queue(local);
+
+	rtnl_unlock();
+
+	return ret;
+}
+
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
-- 
2.27.0

