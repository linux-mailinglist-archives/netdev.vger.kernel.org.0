Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05EE42FDFC
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbhJOWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238787AbhJOWTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C68611F0;
        Fri, 15 Oct 2021 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336221;
        bh=kW53tfWc5n/jzsp+9d89Ha7x0q4gvvQkPAGhLt/pVz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rERmcOWBHU57gm3UF3FrKqZeyFBPKt2fRRpcuFh9q4ytG21zjL6/rQVRF1ZpKOae0
         PGLOth5/dsrrAOC1i6tzLanux1gZcjoQpDb8E/KKTfBqzMVafn9HGZDP0ZYbYH3uq1
         p6+Xb/DM8kGbpz3DA45qIMZBzy/yN0XJC1XnX2iRk5l/Mu1cMTw4cwcoLurAlkffUQ
         Rx7S+RnWK5uLZfEqJ5Voua5VEUpOkhF8/ZYyQ7a0Ej3zRdJZfJOsDJgyfpYTJYdUt2
         N5AWZOoZgN+XPRsQIQBqLNpPksCPoHLTtgWy7bmvRLdaKV7C8h58K/BGUyVYL+9itZ
         E8j60d7qRBesQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        irusskikh@marvell.com
Subject: [PATCH net-next 05/12] ethernet: aquantia: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:45 -0700
Message-Id: <20211015221652.827253-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Use an array on the stack, then call eth_hw_addr_set().
eth_hw_addr_set() is after error checking, this should
be fine, error propagates all the way to failing probe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: irusskikh@marvell.com
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 694aa70bcafe..1acf544afeb4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -300,6 +300,7 @@ static bool aq_nic_is_valid_ether_addr(const u8 *addr)
 
 int aq_nic_ndev_register(struct aq_nic_s *self)
 {
+	u8 addr[ETH_ALEN];
 	int err = 0;
 
 	if (!self->ndev) {
@@ -316,12 +317,13 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
 #endif
 
 	mutex_lock(&self->fwreq_mutex);
-	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw,
-			    self->ndev->dev_addr);
+	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
 	mutex_unlock(&self->fwreq_mutex);
 	if (err)
 		goto err_exit;
 
+	eth_hw_addr_set(self->ndev, addr);
+
 	if (!is_valid_ether_addr(self->ndev->dev_addr) ||
 	    !aq_nic_is_valid_ether_addr(self->ndev->dev_addr)) {
 		netdev_warn(self->ndev, "MAC is invalid, will use random.");
-- 
2.31.1

