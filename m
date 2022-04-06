Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ABD4F6760
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbiDFRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238777AbiDFRb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:26 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D75657BF;
        Wed,  6 Apr 2022 08:34:52 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BD49120000E;
        Wed,  6 Apr 2022 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9svJxavWtfvvcfr/SJ9LwNMS+TMtO405lMcDS46GPiI=;
        b=AkN4DJmh5HqvZQXFi6DCOQGzv81gRzLUQ8ffp3Q02raCcuaCVJRVud2KfUIxTIF07TQoVF
        IRp5EmDWAZu7TMQ4Fc5p5Vl64id/JbwyhbJkmVgk8B+RDPZJrQJdEPKNPrx3wxGovMW24I
        NBCrQIZCYwR2ktOOPky+2mNSu7eJXMzlgh+6axy9FRMJsd4vu3OG4N6GWODZ5abzJC5VkF
        mNpOC3KmR6lvt4UHC8DkZCAZRzZ+/5WAB1W1tZC0QV9AYy+BN1V1VoGJi+fWpFn82vXmTU
        Zbem/ByoQyq2AphBfWrAjKpoXz3ojSqois/w8xwQpsurt+zSnzr49vPscxjIVQ==
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
Subject: [PATCH v5 05/11] net: mac802154: Create a transmit bus error helper
Date:   Wed,  6 Apr 2022 17:34:35 +0200
Message-Id: <20220406153441.1667375-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
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

A few drivers do the full transmit operation asynchronously, which means
that a bus error that happens when forwarding the packet to the
transmitter will not be reported immediately. The solution in this case
is to call this new helper to free the necessary resources, restart the
the queue and return a generic TRAC error code: IEEE802154_SYSTEM_ERROR.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h |  9 +++++++++
 net/mac802154/util.c    | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index abbe88dc9df5..5240d94aad8e 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -498,6 +498,15 @@ void ieee802154_stop_queue(struct ieee802154_hw *hw);
 void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb,
 			      bool ifs_handling);
 
+/**
+ * ieee802154_xmit_bus_error - frame could not be delivered to the trasmitter
+ *                             because of a bus error
+ *
+ * @hw: pointer as obtained from ieee802154_alloc_hw().
+ * @skb: buffer for transmission
+ */
+void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buff *skb);
+
 /**
  * ieee802154_xmit_error - frame transmission failed
  *
diff --git a/net/mac802154/util.c b/net/mac802154/util.c
index ec523335336c..79ba803c40c9 100644
--- a/net/mac802154/util.c
+++ b/net/mac802154/util.c
@@ -102,6 +102,16 @@ void ieee802154_xmit_error(struct ieee802154_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ieee802154_xmit_error);
 
+void ieee802154_xmit_bus_error(struct ieee802154_hw *hw, struct sk_buff *skb)
+{
+	struct ieee802154_local *local = hw_to_local(hw);
+
+	local->tx_result = IEEE802154_SYSTEM_ERROR;
+	ieee802154_wake_queue(hw);
+	dev_kfree_skb_any(skb);
+}
+EXPORT_SYMBOL(ieee802154_xmit_bus_error);
+
 void ieee802154_stop_device(struct ieee802154_local *local)
 {
 	flush_workqueue(local->workqueue);
-- 
2.27.0

