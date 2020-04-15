Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4871A9DF6
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897642AbgDOLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 07:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409460AbgDOLsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887B620775;
        Wed, 15 Apr 2020 11:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951304;
        bh=DJX25bhZXAoYinOF72m/TtqTOSIs7bBbtLa24YaT3Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1OdW2K99DCfuOhtLxFzFUJ1c14WAoB+/L7VZCMSAqg9eMas2u7hrxyKkiM7Sm5dt
         988d/OBKwgesjTSu411vjQo+SsJR0uNc5dR3nZ/J2QADJvhoXw3H9DTaP0W+l7ESAN
         rj22kJasCBCON++WKXG7BaGJX4Dp5IX5n2KGZTTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 08/14] net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting
Date:   Wed, 15 Apr 2020 07:48:08 -0400
Message-Id: <20200415114814.15954-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114814.15954-1-sashal@kernel.org>
References: <20200415114814.15954-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

[ Upstream commit 3e1221acf6a8f8595b5ce354bab4327a69d54d18 ]

Commit 9463c4455900 ("net: stmmac: dwmac1000: Clear unused address
entries") cleared the unused mac address entries, but introduced an
out-of bounds mac address register programming bug -- After setting
the secondary unicast mac addresses, the "reg" value has reached
netdev_uc_count() + 1, thus we should only clear address entries
if (addr < perfect_addr_number)

Fixes: 9463c4455900 ("net: stmmac: dwmac1000: Clear unused address entries")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 1df84c8de9d75..b535f6c378386 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -188,7 +188,7 @@ static void dwmac1000_set_filter(struct mac_device_info *hw,
 			reg++;
 		}
 
-		while (reg <= perfect_addr_number) {
+		while (reg < perfect_addr_number) {
 			writel(0, ioaddr + GMAC_ADDR_HIGH(reg));
 			writel(0, ioaddr + GMAC_ADDR_LOW(reg));
 			reg++;
-- 
2.20.1

