Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B05456AB1
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhKSHNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhKSHNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B68461B62;
        Fri, 19 Nov 2021 07:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305842;
        bh=UHJGqe9P77z3d0Q5fJ5hc2zZFIN2uam0tHaRtDuM85w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8zkNa8erZWuO4Ir654O6c2+X+n0oJQHWjT/8z6y9vyds4UaJSslPAhhzmHTH+AX7
         fLZAFiGyXWpDwVfeIM/7ek0xy/xY5B+auGi7nVtmn4MNpyZRfUAOADDEloAEJRDq1I
         v1DxWy0YHxKBtOcKIfN+2C5IaiVJDUi984QpFkczqcgAiED15lsbys9Fp5t9a0okkp
         N4tTtzLbbPduTjRYEPQa+JmuSAkf8yAKUuOn3FzOH5y99/EIj53HuQXPLU5nrDDddN
         uFmdDZ0H/p/ETMX/JUp8KNiLklde/TJS3WJ+yTMJ78g7szp7FszFKUOoH8otkXH7o4
         1sMo5ZIPzrUNg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/15] 8390: smc-ultra: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:25 -0800
Message-Id: <20211119071033.3756560-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on Alpha.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/smc-ultra.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 0890fa493f70..6e62c37c9400 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -204,6 +204,7 @@ static int __init ultra_probe1(struct net_device *dev, int ioaddr)
 {
 	int i, retval;
 	int checksum = 0;
+	u8 macaddr[ETH_ALEN];
 	const char *model_name;
 	unsigned char eeprom_irq = 0;
 	static unsigned version_printed;
@@ -239,7 +240,8 @@ static int __init ultra_probe1(struct net_device *dev, int ioaddr)
 	model_name = (idreg & 0xF0) == 0x20 ? "SMC Ultra" : "SMC EtherEZ";
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + 8 + i);
+		macaddr[i] = inb(ioaddr + 8 + i);
+	eth_hw_addr_set(dev, macaddr);
 
 	netdev_info(dev, "%s at %#3x, %pM", model_name,
 		    ioaddr, dev->dev_addr);
-- 
2.31.1

