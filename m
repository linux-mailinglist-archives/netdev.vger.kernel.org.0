Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8031F26D2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbgFHXjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732195AbgFHX2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:28:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6124E208A9;
        Mon,  8 Jun 2020 23:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658897;
        bh=fcHWUoUlDAz5hZK8Ob+/8uvKjpjlxWU7J8rM9pzqcR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSKeoD6eXfamaJqBf+5yD+XsUUwgA8EdehwNwRTdru0dRE0uMUuwhuCGwNeMseVCI
         qCOkn7683UflRIall5HTq++1gEAYxwDZtOqKdkr5d2H4f8TR1iZhztRE1LwYukuFHy
         +c/2xJ7Dt2djr9f9+dMq1fZLX83v2ceDgs0mch+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/37] net: lpc-enet: fix error return code in lpc_mii_init()
Date:   Mon,  8 Jun 2020 19:27:31 -0400
Message-Id: <20200608232750.3370747-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232750.3370747-1-sashal@kernel.org>
References: <20200608232750.3370747-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 88ec7cb22ddde725ed4ce15991f0bd9dd817fd85 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index ba14bad81a21..14b5a0dbf40b 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -865,7 +865,8 @@ static int lpc_mii_init(struct netdata_local *pldat)
 	if (mdiobus_register(pldat->mii_bus))
 		goto err_out_free_mdio_irq;
 
-	if (lpc_mii_probe(pldat->ndev) != 0)
+	err = lpc_mii_probe(pldat->ndev);
+	if (err)
 		goto err_out_unregister_bus;
 
 	return 0;
-- 
2.25.1

