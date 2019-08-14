Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD38C92E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfHNCMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbfHNCMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BECF208C2;
        Wed, 14 Aug 2019 02:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748761;
        bh=nTNEIx10Vjh03n0qsD4zI8XKLpPpJTX9LKmOJDGNKXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvnsTDVYAsQQdesJ68BLAXMMR1KEFfw+ezqTU/Mw7OEJLZH7X46v7oga/qpgnD3iB
         7l4LDa0BcoLiThmA9GEpnfk0CTjh+ifvvxlrd70EmIZOv95oLIySfBJHHIYRGoZDiG
         vK+nSKTVea9BiNh2s2LEFn+52bpk5Szy8Jl9XfXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 054/123] net: stmmac: manage errors returned by of_get_mac_address()
Date:   Tue, 13 Aug 2019 22:09:38 -0400
Message-Id: <20190814021047.14828-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 195b2919ccd7ffcaf6b6bbcb39444a53ab8308c7 ]

Commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
added support for reading the MAC address from an nvmem-cell. This
required changing the logic to return an error pointer upon failure.

If stmmac is loaded before the nvmem provider driver then
of_get_mac_address() return an error pointer with -EPROBE_DEFER.

Propagate this error so the stmmac driver will be probed again after the
nvmem provider driver is loaded.
Default to a random generated MAC address in case of any other error,
instead of using the error pointer as MAC address.

Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 0f0f4b31eb7ec..9b5218a8c15bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -385,6 +385,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 		return ERR_PTR(-ENOMEM);
 
 	*mac = of_get_mac_address(np);
+	if (IS_ERR(*mac)) {
+		if (PTR_ERR(*mac) == -EPROBE_DEFER)
+			return ERR_CAST(*mac);
+
+		*mac = NULL;
+	}
+
 	plat->interface = of_get_phy_mode(np);
 
 	/* Get max speed of operation from device tree */
-- 
2.20.1

