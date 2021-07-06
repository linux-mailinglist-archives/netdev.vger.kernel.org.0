Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F23BCC01
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhGFLSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232047AbhGFLRX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D1B861C3C;
        Tue,  6 Jul 2021 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570083;
        bh=1t40GFUdfFHXYov82Lchb4r/peMxoMO2yy/t5xvZifk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=siOw5d2HmpUVYriwxrOuJl4iGaZqqV64ksXBA5353f1Uz7SPsL0fhjC/lSyVgc6KG
         fRc/JClCoGKgAWDx4BOU7D06i07mvBA+HMof2cjD/QCEZYZewBpyRZ8ekzNxoMc1jr
         FpXGXQqQXyLQ+rJp4bR2Hcv+LVm+g8zJoHailDe7y934d+adCdxTGY7AWBBGcP3DVH
         AuszVL9x3vMgms44YZaH/MnayLAoFlxZuTkSgd8+cYhpewUxRRPEnxFCcc8HE3YpkK
         gys/zMEX6UXcYjO9aGpKLuSE5K1fSJ+RH7xYH2f1aQBcPQGYFIqL3BIwFgYTZjVWxe
         jniQ7iIq+Uizg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 023/189] atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
Date:   Tue,  6 Jul 2021 07:11:23 -0400
Message-Id: <20210706111409.2058071-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 34e7434ba4e97f4b85c1423a59b2922ba7dff2ea ]

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
 drivers/atm/nicstar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 5c7e4df159b9..b015c3e14336 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -299,7 +299,7 @@ static void __exit nicstar_cleanup(void)
 {
 	XPRINTK("nicstar: nicstar_cleanup() called.\n");
 
-	del_timer(&ns_timer);
+	del_timer_sync(&ns_timer);
 
 	pci_unregister_driver(&nicstar_driver);
 
-- 
2.30.2

