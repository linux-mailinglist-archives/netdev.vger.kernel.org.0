Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707E66A6865
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 08:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCAHsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 02:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCAHsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 02:48:51 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.215])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8CE910AA3
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 23:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=x0BSg
        JGdczER9zPWBpNenNYgXwIZGvS0+8Jb0A/PKk8=; b=OC5s/4kqs+3v0P9Kalx+Q
        R+TTvYoqdCphrwPVB84IgKVJJ+n70KRjSzjxwUHFZMln+rt4RBjcIY3sqCGUj2zl
        cVUAgPsEpHpdssHajyqC9vlhxsAVJWFyhorKcMuGczI5725wDPIiGes82ONTD5Y+
        oigSibKOdiqPGgUToPOFb4=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by zwqz-smtp-mta-g0-3 (Coremail) with SMTP id _____wCn1UpBA_9joBWBBg--.39417S2;
        Wed, 01 Mar 2023 15:48:18 +0800 (CST)
From:   Rongguang Wei <clementwei90@163.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        xiaolinkui@kylinos.cn
Cc:     netdev@vger.kernel.org, Rongguang Wei <weirongguang@kylinos.cn>
Subject: [PATCH v1] net: stmmac: add to set device wake up flag when stmmac init phy
Date:   Wed,  1 Mar 2023 15:47:56 +0800
Message-Id: <20230301074756.35156-1-clementwei90@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCn1UpBA_9joBWBBg--.39417S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZrWDAr13ZrW3ZF43XFyrZwb_yoW8WrWkpw
        4UAa40934DZr4xJwsxuw4jvFy5JayUtF4rKryIkwsY9w13CrZYqryFqrWYya4UXrs8X3W3
        ta1xur1kC3WDCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UHnQbUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5fohzv5qwzvxizq6il2tof0z/xtbBuhQla1+GuXSb+AABsW
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongguang Wei <weirongguang@kylinos.cn>

When MAC is not support PMT, driver will check PHY's WoL capability
and set device wakeup capability in stmmac_init_phy(). We can enable
the WoL through ethtool, the driver would enable the device wake up
flag. Now the device_may_wakeup() return true.

But if there is a way which enable the PHY's WoL capability derectly,
like in BIOS. The driver would not know the enable thing and would not
set the device wake up flag. The phy_suspend may failed like this:

[   32.409063] PM: dpm_run_callback(): mdio_bus_phy_suspend+0x0/0x50 returns -16
[   32.409065] PM: Device stmmac-1:00 failed to suspend: error -16
[   32.409067] PM: Some devices failed to suspend, or early wake event detected

Add to set the device wakeup enable flag according to the get_wol
function result in PHY can fix the error in this scene.

Signed-off-by: Rongguang Wei <weirongguang@kylinos.cn>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4902a7bb61e..8f543c3ab5c5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1170,6 +1170,7 @@ static int stmmac_init_phy(struct net_device *dev)
 
 		phylink_ethtool_get_wol(priv->phylink, &wol);
 		device_set_wakeup_capable(priv->device, !!wol.supported);
+		device_set_wakeup_enable(priv->device, !!wol.wolopts);
 	}
 
 	return ret;
-- 
2.25.1

