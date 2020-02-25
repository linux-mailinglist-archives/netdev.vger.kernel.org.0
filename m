Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D370316C1DB
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbgBYNNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:13:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:54214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgBYNNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 08:13:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F859B162;
        Tue, 25 Feb 2020 13:13:20 +0000 (UTC)
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Wahren <wahrenst@gmx.net>
Cc:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed
Date:   Tue, 25 Feb 2020 14:11:59 +0100
Message-Id: <20200225131159.26602-1-nsaenzjulienne@suse.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Outdated Raspberry Pi 4 firmware might configure the external PHY as
rgmii although the kernel currently sets it as rgmii-rxid. This makes
connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
explicitly clear that bit whenever we don't need it.

Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
---

Changes since v1:
 - Fix tags ordering
 - Add targeted tree

 drivers/net/ethernet/broadcom/genet/bcmmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6392a2530183..10244941a7a6 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -294,6 +294,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	 */
 	if (priv->ext_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
+		reg &= ~ID_MODE_DIS;
 		reg |= id_mode_dis;
 		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
 			reg |= RGMII_MODE_EN_V123;
-- 
2.25.1

