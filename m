Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0405D176D24
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgCCDBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbgCCCrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF2A24684;
        Tue,  3 Mar 2020 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203621;
        bh=VwhYKLy1NhWaPZdxdXJS0pwQhJAtWfm9/KXs9tu/rec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjYpPTE60rzLIxj9yzaKK6p+UwLwq7PynsczSYyETkYrAOj4XixOvq+c5zKGXt0f4
         OabJO/wZu9HE/B33sH43gvN3HRaK6ThkqGOQ4g1KB7RMVKPiqCTKdsHifnOqcFLXVx
         F5XyGotKTLjNu3aegdqJaP6ExqoOX56DBXnGrrWA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Mathieu Malaterre <malat@debian.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 36/66] net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()
Date:   Mon,  2 Mar 2020 21:45:45 -0500
Message-Id: <20200303024615.8889-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 9a6a0dea16177ccaecc116f560232e63bec115f1 ]

The call to of_get_mac_address() can return -EPROBE_DEFER, for instance
when the MAC address is read from a NVMEM driver that did not probe yet.

Cc: H. Nikolaus Schaller <hns@goldelico.com>
Cc: Mathieu Malaterre <malat@debian.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index cce90b5925d93..70060c51854fd 100644
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
2.20.1

