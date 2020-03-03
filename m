Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E45176AD7
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCCCqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbgCCCqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B6C2468E;
        Tue,  3 Mar 2020 02:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203610;
        bh=KXETZx78W1nFg7fzMxEN8ZOIA2q1bMHNCQ9ZoIq4xdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p25opntsV63i0A8Oht+jM/YyD5TKLrX5r93z4r6aD03lBRLXX5i5+QUrI6AyCNNCX
         YdjwuTXlPF8yy8O8LcjqexFzNSGphC0wbvQ9zeAiD2oj5ol44hURooiybUa/1MYReY
         5vtOkmX/47NwxTHKmf0ss+ERvbKNHkU9+9xR/3VY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Belous <pbelous@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 28/66] net: atlantic: possible fault in transition to hibernation
Date:   Mon,  2 Mar 2020 21:45:37 -0500
Message-Id: <20200303024615.8889-28-sashal@kernel.org>
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

From: Pavel Belous <pbelous@marvell.com>

[ Upstream commit 52a22f4d6ff95e8bdca557765c04893eb5dd83fd ]

during hibernation freeze, aq_nic_stop could be invoked
on a stopped device. That may cause panic on access to
not yet allocated vector/ring structures.

Add a check to stop device if it is not yet stopped.

Similiarly after freeze in hibernation thaw, aq_nic_start
could be invoked on a not initialized net device.
Result will be the same.

Add a check to start device if it is initialized.
In our case, this is the same as started.

Fixes: 8aaa112a57c1 ("net: atlantic: refactoring pm logic")
Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 2bb329606794b..f74952674084d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -359,7 +359,8 @@ static int aq_suspend_common(struct device *dev, bool deep)
 	netif_device_detach(nic->ndev);
 	netif_tx_stop_all_queues(nic->ndev);
 
-	aq_nic_stop(nic);
+	if (netif_running(nic->ndev))
+		aq_nic_stop(nic);
 
 	if (deep) {
 		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
@@ -375,7 +376,7 @@ static int atl_resume_common(struct device *dev, bool deep)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct aq_nic_s *nic;
-	int ret;
+	int ret = 0;
 
 	nic = pci_get_drvdata(pdev);
 
@@ -390,9 +391,11 @@ static int atl_resume_common(struct device *dev, bool deep)
 			goto err_exit;
 	}
 
-	ret = aq_nic_start(nic);
-	if (ret)
-		goto err_exit;
+	if (netif_running(nic->ndev)) {
+		ret = aq_nic_start(nic);
+		if (ret)
+			goto err_exit;
+	}
 
 	netif_device_attach(nic->ndev);
 	netif_tx_start_all_queues(nic->ndev);
-- 
2.20.1

