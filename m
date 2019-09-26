Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF6BBEDF2
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfIZI7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:59:42 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:33270 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfIZI7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 04:59:41 -0400
Received: from iota-build.ysoft.local (unknown [10.1.5.151])
        by uho.ysoft.cz (Postfix) with ESMTP id 83C1CA45FC;
        Thu, 26 Sep 2019 10:59:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1569488379;
        bh=S+zR6hT69uMuvtLUzS5eVjfUv4JCt+CS0cXeaaqRO1w=;
        h=From:To:Cc:Subject:Date:From;
        b=Fe0DtrL6V6h2VapmNghlv7JdhcyF4p+Gg0QjoPcZTzi/uqa0CN/OB1DNiftMbzxgL
         n1m26wj1eobVRfoRujC1C+YMR+84R61XhbQ0UNqTxcxW/WGxJY7F69oLtonDqzLq/0
         VvykzCe1RLiIBQiQ7aCdSzvDRxIiguUw1IR4iFHY=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
Subject: [PATCH net] net: dsa: qca8k: Use up to 7 ports for all operations
Date:   Thu, 26 Sep 2019 10:59:17 +0200
Message-Id: <1569488357-31415-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QCA8K family supports up to 7 ports. So use the existing
QCA8K_NUM_PORTS define to allocate the switch structure and limit all
operations with the switch ports.

This was not an issue until commit 0394a63acfe2 ("net: dsa: enable and
disable all ports") disabled all unused ports. Since the unused ports 7-11
are outside of the correct register range on this switch some registers
were rewritten with invalid content.

Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
Fixes: a0c02161ecfc ("net: dsa: variable number of ports")
Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
I am not sure which of the fixes tags should be used but this definetelly
fixes something..

IMHO the 0394a63acfe2 ("net: dsa: enable and disable all ports") did not
cause the issue but made it visible.

 drivers/net/dsa/qca8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 16f15c93a102..bbeeb8618c80 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -705,7 +705,7 @@ qca8k_setup(struct dsa_switch *ds)
 		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
 
 	/* Setup connection between CPU port & user ports */
-	for (i = 0; i < DSA_MAX_PORTS; i++) {
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
 			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
@@ -1074,7 +1074,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (id != QCA8K_ID_QCA8337)
 		return -ENODEV;
 
-	priv->ds = dsa_switch_alloc(&mdiodev->dev, DSA_MAX_PORTS);
+	priv->ds = dsa_switch_alloc(&mdiodev->dev, QCA8K_NUM_PORTS);
 	if (!priv->ds)
 		return -ENOMEM;
 
-- 
2.1.4

