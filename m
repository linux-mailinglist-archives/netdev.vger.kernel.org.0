Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB473BCC6D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhGFLTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhGFLSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2836661C4C;
        Tue,  6 Jul 2021 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570163;
        bh=n4e4i6b7pu+S+LOQhnplVOflen9SPRukJwk4NQNpG+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyG+mtW9uayAkgvSkmCKNWQxbqGNl8fkF4hCWN39ivElebpn99gM98LJDgfNkvUXK
         Xfgo1n9Ep535etd48gchxZZDU754jHq+6eYCFbnvWajPFHlAEGU+t676dVFgPCCRmU
         62qNwi5yTzlvTjzKnHMbyq2lewF2TTidUdgdujDV68U9hFxXRFdV/3UHn9Bq1q+AXR
         OnakG7NcXPptndH5o44FQ+areaZYsfkqVLjMJpH16YdFk/Qe6MF7fQ2XdtePJjFiGJ
         FqMUi8jZ8GxFzsSSKz+py1Ocptu6gxASHlrfIFV6gr2x26vcedLaYHQ7TFJc+X7tct
         vF8l/ZxBlFqAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 084/189] net: bcmgenet: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:12:24 -0400
Message-Id: <20210706111409.2058071-84-sashal@kernel.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 74325bf0104573c6dfce42837139aeef3f34be76 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 5335244e4577..89d16c587bb7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -423,6 +423,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	int id, ret;
 
 	pres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pres) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	memset(&res, 0, sizeof(res));
 	memset(&ppd, 0, sizeof(ppd));
 
-- 
2.30.2

