Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40355106511
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfKVFwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbfKVFwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78112068F;
        Fri, 22 Nov 2019 05:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401920;
        bh=XrgJf33ZX605w5/MqKEYzTarUruBrWyg+SRbs6OYdtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2L0S9UsmAM8rDpfUDqYewUQjpjGJCiOHi0pq7PMK7ApcZNA7dKaIQZB9mEMdsGlK
         fQ6kpFO6ARUTiKujEvMMSALlieoMfJ+Y4sFpIcc9UPA1GCNhgZPxxOdEUol8wK1cNk
         iANZYb/l9Egc8HBZ2tSFIYBgpRNVFyEuWi2rI6n8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 150/219] net: marvell: fix a missing check of acpi_match_device
Date:   Fri, 22 Nov 2019 00:48:02 -0500
Message-Id: <20191122054911.1750-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 92ee77d148bf06d8c52664be4d1b862583fd5c0e ]

When acpi_match_device fails, its return value is NULL. Directly using
the return value without a check may result in a NULL-pointer
dereference. The fix checks if acpi_match_device fails, and if so,
returns -EINVAL.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9b608d23ff7ee..9d95add05e3e6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5131,6 +5131,8 @@ static int mvpp2_probe(struct platform_device *pdev)
 	if (has_acpi_companion(&pdev->dev)) {
 		acpi_id = acpi_match_device(pdev->dev.driver->acpi_match_table,
 					    &pdev->dev);
+		if (!acpi_id)
+			return -EINVAL;
 		priv->hw_version = (unsigned long)acpi_id->driver_data;
 	} else {
 		priv->hw_version =
-- 
2.20.1

