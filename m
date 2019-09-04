Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD112A8A99
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbfIDQAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732520AbfIDQAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8AFF20820;
        Wed,  4 Sep 2019 15:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612799;
        bh=7jrej0KAdtSGw1xy2W0LyObM7950SsjKvp9AEmqT/q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvQWC2YLUEijZwnksmuWRaNS02CybXBGyak3q4KF/ogERWNwAOoNqbF6z528d39pt
         K5GwDZxzKIFfrhcL6LhwSGdRhtwzRaLRJgBnunZ0tOtjxtYWrIqT4+brGseC7+c6+O
         16xZ/TZMe4rfjlDwZREvpCeyE6gYAhGxLB5kZco0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 93/94] enetc: Add missing call to 'pci_free_irq_vectors()' in probe and remove functions
Date:   Wed,  4 Sep 2019 11:57:38 -0400
Message-Id: <20190904155739.2816-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit dd7078f05e1b774a9e8c9f117101d97e4ccd0691 ]

Call to 'pci_free_irq_vectors()' are missing both in the error handling
path of the probe function, and in the remove function.
Add them.

Fixes: 19971f5ea0ab ("enetc: add PTP clock driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index 8c1497e7d9c5c..aa31948eac644 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -79,7 +79,7 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 	n = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSIX);
 	if (n != 1) {
 		err = -EPERM;
-		goto err_irq;
+		goto err_irq_vectors;
 	}
 
 	ptp_qoriq->irq = pci_irq_vector(pdev, 0);
@@ -103,6 +103,8 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 err_no_clock:
 	free_irq(ptp_qoriq->irq, ptp_qoriq);
 err_irq:
+	pci_free_irq_vectors(pdev);
+err_irq_vectors:
 	iounmap(base);
 err_ioremap:
 	kfree(ptp_qoriq);
@@ -120,6 +122,7 @@ static void enetc_ptp_remove(struct pci_dev *pdev)
 	struct ptp_qoriq *ptp_qoriq = pci_get_drvdata(pdev);
 
 	ptp_qoriq_free(ptp_qoriq);
+	pci_free_irq_vectors(pdev);
 	kfree(ptp_qoriq);
 
 	pci_release_mem_regions(pdev);
-- 
2.20.1

