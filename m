Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CBD176AF1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgCCCrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgCCCra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 697A4246DE;
        Tue,  3 Mar 2020 02:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203649;
        bh=1Y0TjNSWX3z/xqRoK7YVkvMrzuGCXWFlefxsN8emi/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zk7UjH26EWaUSdwjtMfXSjpR6a/6x2dbZr2hUm93SRo5Bd6oVviJmz4alqG9/J7AU
         aUYSYJ7uN0Xvpm+ShpyRRmXgA0jHbwxNbsmc/UI5CcqoEhJeE/hDx08XQBdQ41Fd99
         kc7glf5jZSRX5bh1doK3l+D5wPucln04ScGx7p7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 59/66] bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.
Date:   Mon,  2 Mar 2020 21:46:08 -0500
Message-Id: <20200303024615.8889-59-sashal@kernel.org>
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

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 8743db4a9acfd51f805ac0c87bcaae92c42d1061 ]

If crashed kernel does not shutdown the NIC properly, PCIe FLR
is required in the kdump kernel in order to initialize all the
functions properly.

Fixes: d629522e1d66 ("bnxt_en: Reduce memory usage when running in kdump kernel.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1a90118370ea1..cc86038b1d96b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11775,6 +11775,14 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (version_printed++ == 0)
 		pr_info("%s", version);
 
+	/* Clear any pending DMA transactions from crash kernel
+	 * while loading driver in capture kernel.
+	 */
+	if (is_kdump_kernel()) {
+		pci_clear_master(pdev);
+		pcie_flr(pdev);
+	}
+
 	max_irqs = bnxt_get_max_irq(pdev);
 	dev = alloc_etherdev_mq(sizeof(*bp), max_irqs);
 	if (!dev)
-- 
2.20.1

