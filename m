Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F03D0C3B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhGUJVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGUJNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:13:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2226461181;
        Wed, 21 Jul 2021 09:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626861258;
        bh=enKOQeFSPKGFuiBSAofb41ommxAMjY4ME+9EOlVJKwg=;
        h=From:To:Cc:Subject:Date:From;
        b=BSNx+V08lATWNIyptIgGG7IFzF2nO4UEOsAA4GipoXj+9JAB0ygBeDjmdtb/rQT5N
         +ercli1zMsA76AcYvBjk1VHZ0a+ScRAs/Fz/RdbfP7q5rHFOsjxpu6VAmkXIZy0Th6
         65vEU7y6xoNy5mFyBPbTK/lgWXqPHdl2YBwRWza60FGE/+x5308Hoey76pG9Ey+ZIH
         iSgYRa1/IVyNgestYSbuZa7Apu+rWbecnHvLAKVrXYWuyj5/QpO78O9VKoLGuLACvW
         4dheMCP4radW1v+TcUNSOgdlPfbkCez+t/hVW8z2W5zDJiYwWC2AgKDuwI0wWORlHc
         9Ff6xV94vIVdw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     Leon Romanovsky <leonro@nvidia.com>, drivers@pensando.io,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] ionic: drop useless check of PCI driver data validity
Date:   Wed, 21 Jul 2021 12:54:13 +0300
Message-Id: <93b5b93f83fae371e53069fc27975e59de493a3b.1626861128.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The driver core will call to .remove callback only if .probe succeeded
and it will ensure that driver data has pointer to struct ionic.

There is no need to check it again.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index e4a5416adc80..505f605fa40b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -373,9 +373,6 @@ static void ionic_remove(struct pci_dev *pdev)
 {
 	struct ionic *ionic = pci_get_drvdata(pdev);
 
-	if (!ionic)
-		return;
-
 	del_timer_sync(&ionic->watchdog_timer);
 
 	if (ionic->lif) {
-- 
2.31.1

