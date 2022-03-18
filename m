Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9ED4DE176
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbiCRS6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiCRS6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:22 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8613D231931;
        Fri, 18 Mar 2022 11:56:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4274AC000B;
        Fri, 18 Mar 2022 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2WpSQlL9iRQVXHYtk1zbsq2tjToAgrdryWP8rjDYmI=;
        b=GEwlFj4OEmHRfN+vsHyl6HcU5HN4/oqcdyDpDvOxUOVavVHD3ayBosYx6XCsY1MAdnLSnq
        tiTl1uBEkmgr2FN/LxfzCWAXUIYeRY/4QG71h1jZJysVNVNRhEazn+7oo0CR+01wVcGj/+
        w1krPzJmdoDOCDp+zpjUa3JT9cjgavTi+fKWmeqloge7OlAHg10k3tgKBxI6dEkpjsDWl+
        ninpE8infPTUYOeT39/8N5k8cUu6+sJ3uR7/vGYvY5TjtM+z1TF4kIz96PqABt/2ofn1gw
        PgtqEon7BhYX0x5fNwxwXpK3NEXcnEbymdNKCHXWuTWeea9ILF9oizXYcnJseQ==
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
Subject: [PATCH wpan-next v4 05/11] Revert "at86rf230: add debugfs support"
Date:   Fri, 18 Mar 2022 19:56:38 +0100
Message-Id: <20220318185644.517164-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318185644.517164-1-miquel.raynal@bootlin.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
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

This reverts commit 493bc90a96839ffde5e6216c62c025d2f9e6efc3.

This commit was introduced because of some testing capabilities
involving ack handling. Not we want to collect errors so let's first
revert this commit, then right after reintroduce the Tx trac handling
which is the only one that makes sense for now.

Suggested-by: Alexander Aring <alex.aring@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/Kconfig     |   7 --
 drivers/net/ieee802154/at86rf230.c | 108 +----------------------------
 drivers/net/ieee802154/at86rf230.h |   8 ---
 3 files changed, 1 insertion(+), 122 deletions(-)

diff --git a/drivers/net/ieee802154/Kconfig b/drivers/net/ieee802154/Kconfig
index 0f7c6dc2ed15..95da876c5613 100644
--- a/drivers/net/ieee802154/Kconfig
+++ b/drivers/net/ieee802154/Kconfig
@@ -33,13 +33,6 @@ config IEEE802154_AT86RF230
 	  This driver can also be built as a module. To do so, say M here.
 	  the module will be called 'at86rf230'.
 
-config IEEE802154_AT86RF230_DEBUGFS
-	depends on IEEE802154_AT86RF230
-	bool "AT86RF230 debugfs interface"
-	depends on DEBUG_FS
-	help
-	  This option compiles debugfs code for the at86rf230 driver.
-
 config IEEE802154_MRF24J40
 	tristate "Microchip MRF24J40 transceiver driver"
 	depends on IEEE802154_DRIVERS && MAC802154
diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 563031ce76f0..8a03722cd1f7 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <linux/of_gpio.h>
 #include <linux/ieee802154.h>
-#include <linux/debugfs.h>
 
 #include <net/mac802154.h>
 #include <net/cfg802154.h>
@@ -76,15 +75,6 @@ struct at86rf230_state_change {
 	bool free;
 };
 
-struct at86rf230_trac {
-	u64 success;
-	u64 success_data_pending;
-	u64 success_wait_for_ack;
-	u64 channel_access_failure;
-	u64 no_ack;
-	u64 invalid;
-};
-
 struct at86rf230_local {
 	struct spi_device *spi;
 
@@ -104,8 +94,6 @@ struct at86rf230_local {
 	u8 tx_retry;
 	struct sk_buff *tx_skb;
 	struct at86rf230_state_change tx;
-
-	struct at86rf230_trac trac;
 };
 
 #define AT86RF2XX_NUMREGS 0x3F
@@ -673,31 +661,6 @@ at86rf230_tx_trac_check(void *context)
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
 
-	if (IS_ENABLED(CONFIG_IEEE802154_AT86RF230_DEBUGFS)) {
-		u8 trac = TRAC_MASK(ctx->buf[1]);
-
-		switch (trac) {
-		case TRAC_SUCCESS:
-			lp->trac.success++;
-			break;
-		case TRAC_SUCCESS_DATA_PENDING:
-			lp->trac.success_data_pending++;
-			break;
-		case TRAC_CHANNEL_ACCESS_FAILURE:
-			lp->trac.channel_access_failure++;
-			break;
-		case TRAC_NO_ACK:
-			lp->trac.no_ack++;
-			break;
-		case TRAC_INVALID:
-			lp->trac.invalid++;
-			break;
-		default:
-			WARN_ONCE(1, "received tx trac status %d\n", trac);
-			break;
-		}
-	}
-
 	at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
 }
 
@@ -737,25 +700,6 @@ at86rf230_rx_trac_check(void *context)
 	u8 *buf = ctx->buf;
 	int rc;
 
-	if (IS_ENABLED(CONFIG_IEEE802154_AT86RF230_DEBUGFS)) {
-		u8 trac = TRAC_MASK(buf[1]);
-
-		switch (trac) {
-		case TRAC_SUCCESS:
-			lp->trac.success++;
-			break;
-		case TRAC_SUCCESS_WAIT_FOR_ACK:
-			lp->trac.success_wait_for_ack++;
-			break;
-		case TRAC_INVALID:
-			lp->trac.invalid++;
-			break;
-		default:
-			WARN_ONCE(1, "received rx trac status %d\n", trac);
-			break;
-		}
-	}
-
 	buf[0] = CMD_FB;
 	ctx->trx.len = AT86RF2XX_MAX_BUF;
 	ctx->msg.complete = at86rf230_rx_read_frame_complete;
@@ -951,10 +895,6 @@ at86rf230_start(struct ieee802154_hw *hw)
 {
 	struct at86rf230_local *lp = hw->priv;
 
-	/* reset trac stats on start */
-	if (IS_ENABLED(CONFIG_IEEE802154_AT86RF230_DEBUGFS))
-		memset(&lp->trac, 0, sizeof(struct at86rf230_trac));
-
 	at86rf230_awake(lp);
 	enable_irq(lp->spi->irq);
 
@@ -1582,47 +1522,6 @@ at86rf230_detect_device(struct at86rf230_local *lp)
 	return rc;
 }
 
-#ifdef CONFIG_IEEE802154_AT86RF230_DEBUGFS
-static struct dentry *at86rf230_debugfs_root;
-
-static int at86rf230_stats_show(struct seq_file *file, void *offset)
-{
-	struct at86rf230_local *lp = file->private;
-
-	seq_printf(file, "SUCCESS:\t\t%8llu\n", lp->trac.success);
-	seq_printf(file, "SUCCESS_DATA_PENDING:\t%8llu\n",
-		   lp->trac.success_data_pending);
-	seq_printf(file, "SUCCESS_WAIT_FOR_ACK:\t%8llu\n",
-		   lp->trac.success_wait_for_ack);
-	seq_printf(file, "CHANNEL_ACCESS_FAILURE:\t%8llu\n",
-		   lp->trac.channel_access_failure);
-	seq_printf(file, "NO_ACK:\t\t\t%8llu\n", lp->trac.no_ack);
-	seq_printf(file, "INVALID:\t\t%8llu\n", lp->trac.invalid);
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(at86rf230_stats);
-
-static void at86rf230_debugfs_init(struct at86rf230_local *lp)
-{
-	char debugfs_dir_name[DNAME_INLINE_LEN + 1] = "at86rf230-";
-
-	strncat(debugfs_dir_name, dev_name(&lp->spi->dev), DNAME_INLINE_LEN);
-
-	at86rf230_debugfs_root = debugfs_create_dir(debugfs_dir_name, NULL);
-
-	debugfs_create_file("trac_stats", 0444, at86rf230_debugfs_root, lp,
-			    &at86rf230_stats_fops);
-}
-
-static void at86rf230_debugfs_remove(void)
-{
-	debugfs_remove_recursive(at86rf230_debugfs_root);
-}
-#else
-static void at86rf230_debugfs_init(struct at86rf230_local *lp) { }
-static void at86rf230_debugfs_remove(void) { }
-#endif
-
 static int at86rf230_probe(struct spi_device *spi)
 {
 	struct ieee802154_hw *hw;
@@ -1719,16 +1618,12 @@ static int at86rf230_probe(struct spi_device *spi)
 	/* going into sleep by default */
 	at86rf230_sleep(lp);
 
-	at86rf230_debugfs_init(lp);
-
 	rc = ieee802154_register_hw(lp->hw);
 	if (rc)
-		goto free_debugfs;
+		goto free_dev;
 
 	return rc;
 
-free_debugfs:
-	at86rf230_debugfs_remove();
 free_dev:
 	ieee802154_free_hw(lp->hw);
 
@@ -1743,7 +1638,6 @@ static int at86rf230_remove(struct spi_device *spi)
 	at86rf230_write_subreg(lp, SR_IRQ_MASK, 0);
 	ieee802154_unregister_hw(lp->hw);
 	ieee802154_free_hw(lp->hw);
-	at86rf230_debugfs_remove();
 	dev_dbg(&spi->dev, "unregistered at86rf230\n");
 
 	return 0;
diff --git a/drivers/net/ieee802154/at86rf230.h b/drivers/net/ieee802154/at86rf230.h
index 042bb27287a3..fbdfb705c7a3 100644
--- a/drivers/net/ieee802154/at86rf230.h
+++ b/drivers/net/ieee802154/at86rf230.h
@@ -208,13 +208,5 @@
 #define STATE_TRANSITION_IN_PROGRESS 0x1F
 
 #define TRX_STATE_MASK		(0x1F)
-#define TRAC_MASK(x)		((x & 0xe0) >> 5)
-
-#define TRAC_SUCCESS			0
-#define TRAC_SUCCESS_DATA_PENDING	1
-#define TRAC_SUCCESS_WAIT_FOR_ACK	2
-#define TRAC_CHANNEL_ACCESS_FAILURE	3
-#define TRAC_NO_ACK			5
-#define TRAC_INVALID			7
 
 #endif /* !_AT86RF230_H */
-- 
2.27.0

