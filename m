Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC73BD5DC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242009AbhGFMZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237042AbhGFLfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6548B61CA0;
        Tue,  6 Jul 2021 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570716;
        bh=DZWfHZIV3aw0eRtV+zhV+7WT6HPnkQnGI0dqYNCuIB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlnfuP14P5i3TtVXDCbmOevcRambHk43tHBf8YJTfewJFOPorJx2C9f3msoCgccW/
         9xUojVHfUiEW9IzwMk3JaXrBY2+jcwv+eD/9WT2Kr19T4huD8PXoMzU1R/WLwwImAF
         JiyTThkNy9+ATNDrncOvEDRsju5YbP7Rc6xDmSsAAA/FSzz9NeFCckrP2F6cbQQ7U+
         MB9rnvOCTkdEfhCZg1S+sIpiHoSNabzmuz4Csn/MsjIAWEVfNs0dft3NrqXxHO4hzk
         1b8F7qUw1LuY4hfGXA7AX7hpTGEJpNSQCXrwLZoi5X4/juPlGuQ4fGfqYSsr7Ry/Fn
         Oq5bVHnNJ+1hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/74] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue,  6 Jul 2021 07:23:58 -0400
Message-Id: <20210706112502.2064236-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 2330a7d24267..a2b2ce1dfec8 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2341,7 +2341,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.30.2

