Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D687D49B6AE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388788AbiAYOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:44:38 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:48844 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388586AbiAYOkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:40:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C88F3218E2;
        Tue, 25 Jan 2022 14:40:08 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B224AA3B87;
        Tue, 25 Jan 2022 14:40:08 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] amd: declance: use eth_hw_addr_set()
Date:   Tue, 25 Jan 2022 15:40:06 +0100
Message-Id: <20220125144007.64407-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy scattered mac address octets into an array then eth_hw_addr_set().

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/amd/declance.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 493b0cefcc2a..ec8df05e7bf6 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -1032,6 +1032,7 @@ static int dec_lance_probe(struct device *bdev, const int type)
 	int i, ret;
 	unsigned long esar_base;
 	unsigned char *esar;
+	u8 addr[ETH_ALEN];
 	const char *desc;
 
 	if (dec_lance_debug && version_printed++ == 0)
@@ -1228,7 +1229,8 @@ static int dec_lance_probe(struct device *bdev, const int type)
 		break;
 	}
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = esar[i * 4];
+		addr[i] = esar[i * 4];
+	eth_hw_addr_set(dev, addr);
 
 	printk("%s: %s, addr = %pM, irq = %d\n",
 	       name, desc, dev->dev_addr, dev->irq);
-- 
2.29.2

