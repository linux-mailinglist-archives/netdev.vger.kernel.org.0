Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC64E5A29B8
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbiHZOlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHZOk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:40:59 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EA2ABD7C;
        Fri, 26 Aug 2022 07:40:57 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 80CD31BF215;
        Fri, 26 Aug 2022 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhPle3Loc9DzyWn1KWs/wY2k+T6fObmYwcJpPw+b7n0=;
        b=APwf/jHh9Eqc5GxoFMTZ7zEWgKx3MZL6iq4XqIACYYGjLdJ3EMY88kXhkikVnB92FYb18y
        vOTgTbDdZsPB94gf1Ak5qWhOEY9zZRiHDq4SIv/NTh1lxF7iCSsuqsir9V2E2IPR3fTUh8
        i24n81WUcXxQB4w168WMJz1rO3f2lRGDPaXSA+J5QDrtWdWCqkPpDeSWUlDcRL69Rqf7hg
        1wXxhfjTXCl0DOtEWdOpGST+kY3cn2SzONLAaWz1Kn3l/HhsSoEjbmkrST8TmoCUncmbFk
        IBEwXPx9vj0UtUvCNNLpt1wRSlFYy63mAax1habSfqL6FU0fniSQ2hccgrxhnA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 01/11] net: mac802154: Introduce filtering levels
Date:   Fri, 26 Aug 2022 16:40:39 +0200
Message-Id: <20220826144049.256134-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826144049.256134-1-miquel.raynal@bootlin.com>
References: <20220826144049.256134-1-miquel.raynal@bootlin.com>
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

The 802154 specification details several filtering levels in which the
PHY and the MAC could be. The amount of filtering will vary if they are
in promiscuous mode or in scanning mode. Otherwise they are expected to
do some very basic checks, such as enforcing the frame validity. Either
the PHY is able to do so, and the MAC has nothing to do, or the PHY has
a lower filtering level than expected and the MAC should take over.

For now we define these levels in an enumeration, we add a per-PHY
parameter showing the PHY filtering level and we set it to a default
value. The drivers, if they cannot reach this level of filtering, should
overwrite this value so that it reflects what they do. Then, in the
core, this filtering level will be used to decide whether some
additional software processing is needed or not.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h |  3 +++
 include/net/mac802154.h | 24 ++++++++++++++++++++++++
 net/mac802154/iface.c   |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 04b996895fc1..2f29e95da47a 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -223,6 +223,9 @@ struct wpan_phy {
 	atomic_t hold_txs;
 	wait_queue_head_t sync_txq;
 
+	/* Current filtering level on reception */
+	unsigned long filtering;
+
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 357d25ef627a..41c28118790c 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -130,6 +130,30 @@ enum ieee802154_hw_flags {
 #define IEEE802154_HW_OMIT_CKSUM	(IEEE802154_HW_TX_OMIT_CKSUM | \
 					 IEEE802154_HW_RX_OMIT_CKSUM)
 
+/**
+ * enum ieee802154_filtering_level - Filtering levels applicable to a PHY
+ *
+ * @IEEE802154_FILTERING_NONE: No filtering at all, what is received is
+ *	forwarded to the softMAC
+ * @IEEE802154_FILTERING_1_FCS: First filtering level, frames with an invalid
+ *	FCS should be dropped
+ * @IEEE802154_FILTERING_2_PROMISCUOUS: Second filtering level, promiscuous
+ *	mode, identical in terms of filtering to the first level at the PHY
+ *	level, but no ACK should be transmitted automatically and at the MAC
+ *	level the frame should be forwarded to the upper layer directly
+ * @IEEE802154_FILTERING_3_SCAN: Third filtering level, enforced during scans,
+ *	which only forwards beacons
+ * @IEEE802154_FILTERING_4_FRAME_FIELDS: Fourth filtering level actually
+ *	enforcing the validity of the content of the frame with various checks
+ */
+enum ieee802154_filtering_level {
+	IEEE802154_FILTERING_NONE,
+	IEEE802154_FILTERING_1_FCS,
+	IEEE802154_FILTERING_2_PROMISCUOUS,
+	IEEE802154_FILTERING_3_SCAN,
+	IEEE802154_FILTERING_4_FRAME_FIELDS,
+};
+
 /* struct ieee802154_ops - callbacks from mac802154 to the driver
  *
  * This structure contains various callbacks that the driver may
diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 500ed1b81250..4bab2807acbe 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -587,6 +587,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 		sdata->dev->netdev_ops = &mac802154_wpan_ops;
 		sdata->dev->ml_priv = &mac802154_mlme_wpan;
 		wpan_dev->promiscuous_mode = false;
+		wpan_dev->wpan_phy->filtering = IEEE802154_FILTERING_4_FRAME_FIELDS;
 		wpan_dev->header_ops = &ieee802154_header_ops;
 
 		mutex_init(&sdata->sec_mtx);
@@ -601,6 +602,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 		sdata->dev->needs_free_netdev = true;
 		sdata->dev->netdev_ops = &mac802154_monitor_ops;
 		wpan_dev->promiscuous_mode = true;
+		wpan_dev->wpan_phy->filtering = IEEE802154_FILTERING_2_PROMISCUOUS;
 		break;
 	default:
 		BUG();
-- 
2.34.1

