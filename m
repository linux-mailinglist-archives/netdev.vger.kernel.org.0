Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9866C431FB4
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhJROcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5256561250;
        Mon, 18 Oct 2021 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567390;
        bh=C+yaMZItvZvAIKlPUYRNB3jw8iKXx7+hN4hvNIMPLEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxoVEwVDRIwxNaN5p1P09g19GB5KwIYeraXjJEGXR69hDhqC67i4cXie06jBFiNxX
         hub8DxHgCOaJjYE2U5oYGPAa+jYFj7yxOQDt9035c4ysTQ1GBoPCzbhAqqL+4wpLiv
         5CA+g/aYK2TY81ROb26/AFWRig5BU9yGcd72+cZqiviiYEkkbN/iVfck7+9op02/J/
         yztrl8nlHvRrpBlt2qg0fqhPFMdgcRSiEJ+BptcJZmcgJ2CZqUfIjCrhf9bOY/OTf3
         u71mLyCypsCNX9qgWzIdpAsOgiUgJlqNGsES25ZzxaFPSBKEH3hnZxMYghQahh0dpV
         Dsf3B+LOZ0ufQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jiri@resnulli.us
Subject: [PATCH net-next 07/12] ethernet: rocker: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:27 -0700
Message-Id: <20211018142932.1000613-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@resnulli.us
---
 drivers/net/ethernet/rocker/rocker_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index f28c0c36b606..ba4062881eed 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2545,11 +2545,13 @@ static void rocker_port_dev_addr_init(struct rocker_port *rocker_port)
 {
 	const struct rocker *rocker = rocker_port->rocker;
 	const struct pci_dev *pdev = rocker->pdev;
+	u8 addr[ETH_ALEN];
 	int err;
 
-	err = rocker_cmd_get_port_settings_macaddr(rocker_port,
-						   rocker_port->dev->dev_addr);
-	if (err) {
+	err = rocker_cmd_get_port_settings_macaddr(rocker_port, addr);
+	if (!err) {
+		eth_hw_addr_set(rocker_port->dev, addr);
+	} else {
 		dev_warn(&pdev->dev, "failed to get mac address, using random\n");
 		eth_hw_addr_random(rocker_port->dev);
 	}
-- 
2.31.1

