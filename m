Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAADD6D831B
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjDEQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjDEQKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:02 -0400
X-Greylist: delayed 1809 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Apr 2023 09:09:53 PDT
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633AB10D8;
        Wed,  5 Apr 2023 09:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=HXWZ4XUXK8vGxYsn5UqljiIqwaTfxIUTeJ93pQO8yv0=;
        b=IIIgPy78rqr8S+tn6NsY2EvtjiKg+QIru842BL9PVeqTXvixeia2k4BeueSquX1gll0Q9MZpdk88P
         9wkbyAQ1mY0IZkGHObVLjCDxKyE7uOzpGdB2pSKRCDOYCFGvVovxZWcN4ArP442YbUpgfeVmiZgjn6
         B20s8KSfb8FdJPDiJH0tKbq49wMSRWpt80EPNpGf+X4KkLabY1WBNdnxVskiRdlaCt6DnsmmRuDGsf
         +Bsn+BZ4Oi5m29jHnE0Tb4cZ5ePwG0kTPm6mPj6COz5OP4QkkVKWh5Yt+k2ftvJ7LpLGJpfhcER6pZ
         58bgnFiOYPt+OvgZ2Ma8q0cwx1dtlNw==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000012,0.013713)], BW: [Enabled, t: (0.000025,0.000001)], RTDA: [Enabled, t: (0.090298), Hit: No, Details: v2.49.0; Id: 15.4d9lk.1gt9153nq.b2hs; mclb], total: 0(700)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Wed, 5 Apr 2023 18:39:18 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru,
        stable@vger.kernel.org
Subject: [PATCH net] net: sfp: initialize sfp->i2c_block_size at sfp allocation
Date:   Wed,  5 Apr 2023 18:39:00 +0300
Message-Id: <20230405153900.747-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp->i2c_block_size is initialized at SFP module insertion in
sfp_sm_mod_probe(). Because of that, if SFP module was not inserted
since boot, ethtool -m leads to zero-length I2C read attempt.

  # ethtool -m xge0
  i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
  Cannot get Module EEPROM data: Operation not supported

If SFP module was plugged then removed at least once,
sfp->i2c_block_size will be initialized and ethtool -m will fail with
different error

  # ethtool -m xge0
  Cannot get Module EEPROM data: Remote I/O error

Fix this by initializing sfp->i2_block_size at struct sfp allocation
stage so ethtool -m with SFP module removed will fail the same way, i.e.
-EREMOTEIO, in both cases and without errors from I2C adapter.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
Cc: stable@vger.kernel.org
---
 drivers/net/phy/sfp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 40c9a64c5e30..5663a184644d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -212,6 +212,12 @@ static const enum gpiod_flags gpio_flags[] = {
 #define SFP_PHY_ADDR		22
 #define SFP_PHY_ADDR_ROLLBALL	17
 
+/* SFP_EEPROM_BLOCK_SIZE is the size of data chunk to read the EEPROM
+ * at a time. Some SFP modules and also some Linux I2C drivers do not like
+ * reads longer than 16 bytes.
+ */
+#define SFP_EEPROM_BLOCK_SIZE	16
+
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
@@ -1928,11 +1934,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	u8 check;
 	int ret;
 
-	/* Some SFP modules and also some Linux I2C drivers do not like reads
-	 * longer than 16 bytes, so read the EEPROM in chunks of 16 bytes at
-	 * a time.
-	 */
-	sfp->i2c_block_size = 16;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -2615,6 +2617,7 @@ static struct sfp *sfp_alloc(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 
 	sfp->dev = dev;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	mutex_init(&sfp->sm_mutex);
 	mutex_init(&sfp->st_mutex);
-- 
2.39.2


