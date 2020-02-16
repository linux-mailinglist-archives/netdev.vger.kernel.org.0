Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADFA160601
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgBPTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 14:40:00 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:35320 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgBPTj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:39:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1581881998; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=xOd8vpBAcGa3BeTpj1bp17aeuVAAbyNS4ZEySTi8Lrw=;
        b=et0F/S1dj/H3xCe0U+YJsOx2C5vzFMgvGS4AAnJinGfSAsINFPGAsAwtT6bftHGvYVDGVh
        G3gBqX67JXg0VSN0MNm8HutitVL+/wOTE/JLfa+b4mtsC6x/w4lOdfrEVw5xd2LRv/JfsL
        J4EufEuPiub6Ga2l0f/PZutHY1yk6sE=
From:   Paul Cercueil <paul@crapouillou.net>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Mathieu Malaterre <malat@debian.org>
Subject: [PATCH] net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()
Date:   Sun, 16 Feb 2020 16:39:43 -0300
Message-Id: <20200216193943.81134-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call to of_get_mac_address() can return -EPROBE_DEFER, for instance
when the MAC address is read from a NVMEM driver that did not probe yet.

Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 1ea3372775e6..e94ae9b94dbf 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1405,6 +1405,8 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 	mac_addr = of_get_mac_address(np);
 	if (!IS_ERR(mac_addr))
 		ether_addr_copy(pdata->dev_addr, mac_addr);
+	else if (PTR_ERR(mac_addr) == -EPROBE_DEFER)
+		return ERR_CAST(mac_addr);
 
 	return pdata;
 }
-- 
2.25.0

