Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC603BD5FC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhGFM0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237732AbhGFLhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A197761DCE;
        Tue,  6 Jul 2021 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570976;
        bh=1J1EScfW7yJRqaoL4pux23XgwAQvFXnbifWtR0O+rnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE+3pf5ATi6Cl4zsFlxyPUCCCCAM0qxHw70dJAECM12HOnwAHFbv1QGtU358jhh5G
         nYiSZoDf5TSIp7gvfQId+/6WsrVVwtr2x2q4ouzivWrDI00vRW/Ht0EhUtXfu4g1Uk
         rHWOLEJbCvDxinAvBq2ZTTPN+YL1zRmrjOInn/tdBAITLl7RevzEXT4Td4fHgjK7GB
         v25jk7haGlMZR/qNu1IRAYViw2s9Czc8X7hLC2y+7IUZXaIgA4ED0n5a+BdIcYR+lg
         f6jmGVEAeE3TcfoLE7M68u8k0kZ9cJtq2t/bk466qMkRxxQGst+jbAywzcw1BlIPeC
         HiLxApeOCS8kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 03/31] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Tue,  6 Jul 2021 07:29:03 -0400
Message-Id: <20210706112931.2066397-3-sashal@kernel.org>
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

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

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
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 860a33a90ebf..dc1b7f11e6af 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3296,7 +3296,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2

