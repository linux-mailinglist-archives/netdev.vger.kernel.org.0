Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A328A6D97A2
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbjDFNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbjDFNJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:09:24 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF966191;
        Thu,  6 Apr 2023 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding:
         in-reply-to:references;
        bh=IO1EPmwiDtC2Abwn+uXaFr8L4ym/D/q1VCAduJB0S5E=;
        b=OqltBQhyEToBbHc0pbG9rU+aQL2jXagCBFKlbuLlIaYcVVsw4bEx8zc+LE0uxjCLrcPAMLIuDxYZp
         fSKKeUcIZLVgPHaLJqHwANV4WmXeBt9im0Wifc4gm/IJyzsRHWVgsendPWpfDEt6220AB/fOnK+TQ6
         CWqQ4w5Vw2agZ3COwJ2RORYCvF3d7pxQgz/juVenZrp3Q+7/6M2duggyILwr29Rm4SHvSCTan6TLF2
         2VUV1h3zHMRq10Wae0ssb/1KV1zsxFo5EcAR/R+jK7tOG1nHJriXsvHSHTyFkvxKMWs8WmPmjUSYzI
         kSM8+WCK7G8iDy0inrrTzbqVF7iULVQ==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000006,0.014053)], BW: [Enabled, t: (0.000028,0.000001)], RTDA: [Enabled, t: (0.103778), Hit: No, Details: v2.49.0; Id: 15.8wv4b.1gtbaumsr.6g4f; mclb], total: 0(700)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Thu, 6 Apr 2023 16:09:02 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru,
        stable@vger.kernel.org
Subject: [PATCH net v2 1/2] net: sfp: initialize sfp->i2c_block_size at sfp allocation
Date:   Thu,  6 Apr 2023 16:08:32 +0300
Message-Id: <20230406130833.32160-2-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
References: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sfp->i2c_block_size is initialized at SFP module insertion in
sfp_sm_mod_probe(). Because of that, if SFP module was never inserted
since boot, sfp_read() call will lead to zero-length I2C read attempt,
and not all I2C controllers are happy with zero-length reads.

One way to issue sfp_read() on empty SFP cage is to execute ethtool -m.
If SFP module was never plugged since boot, there will be a zero-length
I2C read attempt.

  # ethtool -m xge0
  i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
  Cannot get Module EEPROM data: Operation not supported

If SFP module was plugged then removed at least once,
sfp->i2c_block_size will be initialized and ethtool -m will fail with
different exit code and without I2C error

  # ethtool -m xge0
  Cannot get Module EEPROM data: Remote I/O error

Fix this by initializing sfp->i2_block_size at struct sfp allocation
stage so no wild sfp_read() could issue zero-length I2C read.

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


