Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FB6431FB1
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhJROcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhJROcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42D55610A1;
        Mon, 18 Oct 2021 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567389;
        bh=0rCvsRVkCwbt0/BqcEG1dV8uNaI9gHuY2hhoqS7dgLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWBpomTFvCW+Y/rpyMuk2ODwO+QtooJURP0qCW3nDh+R1Nkutr/I6xJXE+hNMKwDq
         KTR2TqcH9H2JBJP6ft9OY2pNaB2I1am6qKRiWvm1NlKG/M0oM9KyRv+AxaREabT3yQ
         6qQ68FkBIrcbs+kul0Vxm1BHKrlZKPXnJPYiaqedPsGrjeRcWabWmUgQl74byryxAM
         pUWWc+LTLfefzT+VDmb3tpDvmGqzJfCXnin2ii7q04A4pBFRyd8gnbnVdu76qZM2jE
         XlijFoWDp6FZxhB1w0DNBe0eD4ftACtpsFP8w9TfjHP/oAkBD+aJnXyH6ZplbsJFf4
         mYTUALmFS175A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        manishc@marvell.com, rahulv@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Subject: [PATCH net-next 04/12] ethernet: netxen: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:24 -0700
Message-Id: <20211018142932.1000613-5-kuba@kernel.org>
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

Invert the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: manishc@marvell.com
CC: rahulv@marvell.com
CC: GR-Linux-NIC-Dev@marvell.com
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index b4e094e6f58c..4cfab4434e80 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -463,6 +463,7 @@ netxen_read_mac_addr(struct netxen_adapter *adapter)
 	u64 mac_addr;
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
+	u8 addr[ETH_ALEN];
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
 		if (netxen_p3_get_mac_addr(adapter, &mac_addr) != 0)
@@ -474,7 +475,8 @@ netxen_read_mac_addr(struct netxen_adapter *adapter)
 
 	p = (unsigned char *)&mac_addr;
 	for (i = 0; i < 6; i++)
-		netdev->dev_addr[i] = *(p + 5 - i);
+		addr[i] = *(p + 5 - i);
+	eth_hw_addr_set(netdev, addr);
 
 	memcpy(adapter->mac_addr, netdev->dev_addr, netdev->addr_len);
 
-- 
2.31.1

