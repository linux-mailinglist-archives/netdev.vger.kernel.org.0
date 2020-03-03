Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E13176C61
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgCCCsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgCCCsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D91246D8;
        Tue,  3 Mar 2020 02:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203721;
        bh=umPpQzOU4eFA5s5p0KGpojStj0PTG+oVqhQ8CLaVrow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wn5ePJPKsR6GVaAvqfml9e4xYHYYyP53XzvWYP2CFN4oZMwAKqq/0KDi6P6y2QhiN
         ODG3bOPvVAarESpkFRbNKCME7GabyS3YP3DYy/CIEE0nf8e/U7kemOf+RpZpbitMk3
         DJYicxK7u9vNFIulGfEptAdknT5jbs5XDgzctdF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 50/58] bnxt_en: Improve device shutdown method.
Date:   Mon,  2 Mar 2020 21:47:32 -0500
Message-Id: <20200303024740.9511-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 5567ae4a8d569d996d0d88d0eceb76205e4c7ce5 ]

Especially when bnxt_shutdown() is called during kexec, we need to
disable MSIX and disable Bus Master to completely quiesce the device.
Make these 2 calls unconditionally in the shutdown method.

Fixes: c20dc142dd7b ("bnxt_en: Disable bus master during PCI shutdown and driver unload.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 68618891b0e42..e03e610dd1831 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11908,10 +11908,10 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 		dev_close(dev);
 
 	bnxt_ulp_shutdown(bp);
+	bnxt_clear_int_mode(bp);
+	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		bnxt_clear_int_mode(bp);
-		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.20.1

