Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1788D176C65
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgCCC4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgCCCsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB250246A1;
        Tue,  3 Mar 2020 02:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203722;
        bh=wvIZGTrfVEJX+/h/0jYTc6W39qvqgiRTacB6jjgXu9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CD8yD6WCNdyAVZvkGuFRuJ5j9FTEcH11DoFzfjvM+xL1XvM5RZGiF8UWlde1JswuA
         LzqpUFIUW4P/PU8C9GGijpOrZ9e8r/Ir3vBGSZ9byg5tXvFzgEl4ir8TF3iNbCooGW
         wUWfjWCo6G37IZW85g32ljG/q4qn8usMZIxN4Odk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 51/58] bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.
Date:   Mon,  2 Mar 2020 21:47:33 -0500
Message-Id: <20200303024740.9511-51-sashal@kernel.org>
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
index e03e610dd1831..374e11a91790b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11712,6 +11712,14 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

