Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430F3BD5FA
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242192AbhGFM0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhGFLhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60FF61F28;
        Tue,  6 Jul 2021 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570977;
        bh=zGOVYjwyMffJLWfigNL2olJxhT7aPhNmZaFHOVgs7cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEu1l0kMfTWOn5gD1BHaEHrOQgiHzVApKcu24u2ulmpLrbQUhAvIWoOQz1O9OF6KY
         tnFtMLOR6u/545I9qJGq0RNiVOo5MCxWnwj6/AQfO4bpu656wSLROOHC/k1XqQuLSX
         6iJJlD18rK6IXQXYhOYPnuDbadlaTt4GIz5IY5U5sSnm9WYkoICYCSvN+ZQ8Xql6Dh
         dxE8XVmzGMD1OIrWMX/dSn4objInjzIFCHKFjyK44d3jsN87y9sFqRyVRDEscdZffi
         jTKRDoblvbNDHaW13F69gXb4w1D5b6vX5Zie11wojkUfoc/eg/X7bnlJ7Aev1geJke
         6E1EqPHI7vk/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/31] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue,  6 Jul 2021 07:29:04 -0400
Message-Id: <20210706112931.2066397-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112931.2066397-1-sashal@kernel.org>
References: <20210706112931.2066397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 009fc857c5f6fda81f2f7dd851b2d54193a8e733 ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index ff48da61c94c..89cf1d695a01 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2352,7 +2352,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2

