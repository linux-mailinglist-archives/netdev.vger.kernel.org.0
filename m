Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDC9434F74
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhJTP6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230521AbhJTP6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61DEF613A0;
        Wed, 20 Oct 2021 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745387;
        bh=Eyq6ycvurFoSB71j4SWhf8f8a3eHcrqtLRm5rL0RayI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m62FCZeb+iv79EfZhPRCxgf6kVZAo4c5t7KjaqHbXSK6AoCk9LRUNN6BtyIjkgQwb
         JFxcnuBQBs9QuJRejnKSMfzz1GhLJOJwIIjOalw83XkQ/2F57FlLS/97wKJ8rmcPTg
         6uRT/LL/1znTQ4KGRzLG5bYOxR4rucBYlrdDmB5XmsmUeGMwS1rwD5rgefl8Tbev38
         M2/MrBaY3hqECQdawb1cz9uBDCJPEhWv8G9YcKJ583YIfoLwHzbth87Mdo930qpDfN
         NlxH1ky/6Il5lUew5w4e93lOqhJRPDDmcY/jDZx1MeQWhe/pioBJJ5mVwRIuaF4/jN
         kv6pB4pP180gw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next 09/12] net: s390: constify and use eth_hw_addr_set()
Date:   Wed, 20 Oct 2021 08:56:14 -0700
Message-Id: <20211020155617.1721694-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Make sure local references to netdev->dev_addr are constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jwi@linux.ibm.com
CC: kgraul@linux.ibm.com
CC: hca@linux.ibm.com
CC: gor@linux.ibm.com
CC: borntraeger@de.ibm.com
CC: linux-s390@vger.kernel.org
---
 drivers/s390/net/lcs.c            | 2 +-
 drivers/s390/net/qeth_core_main.c | 4 ++--
 drivers/s390/net/qeth_l2_main.c   | 6 +++---
 drivers/s390/net/qeth_l3_main.c   | 3 +--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index c18fd48e02b6..2a6479740600 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -2162,7 +2162,7 @@ lcs_new_device(struct ccwgroup_device *ccwgdev)
 	card->dev->ml_priv = card;
 	card->dev->netdev_ops = &lcs_netdev_ops;
 	card->dev->dev_port = card->portno;
-	memcpy(card->dev->dev_addr, card->mac, LCS_MAC_LENGTH);
+	eth_hw_addr_set(card->dev, card->mac);
 #ifdef CONFIG_IP_MULTICAST
 	if (!lcs_check_multicast_support(card))
 		card->dev->netdev_ops = &lcs_mc_netdev_ops;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e9807d2996a9..15999a816054 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4375,7 +4375,7 @@ static int qeth_setadpparms_change_macaddr_cb(struct qeth_card *card,
 	    !(adp_cmd->hdr.flags & QETH_SETADP_FLAGS_VIRTUAL_MAC))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(card->dev->dev_addr, adp_cmd->data.change_addr.addr);
+	eth_hw_addr_set(card->dev, adp_cmd->data.change_addr.addr);
 	return 0;
 }
 
@@ -5046,7 +5046,7 @@ int qeth_vm_request_mac(struct qeth_card *card)
 		QETH_CARD_TEXT(card, 2, "badmac");
 		QETH_CARD_HEX(card, 2, response->mac, ETH_ALEN);
 	} else {
-		ether_addr_copy(card->dev->dev_addr, response->mac);
+		eth_hw_addr_set(card->dev, response->mac);
 	}
 
 out:
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index dc6c00768d91..5b6187f2d9d6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -71,7 +71,7 @@ static int qeth_l2_send_setdelmac_cb(struct qeth_card *card,
 	return qeth_l2_setdelmac_makerc(card, cmd->hdr.return_code);
 }
 
-static int qeth_l2_send_setdelmac(struct qeth_card *card, __u8 *mac,
+static int qeth_l2_send_setdelmac(struct qeth_card *card, const __u8 *mac,
 			   enum qeth_ipa_cmds ipacmd)
 {
 	struct qeth_ipa_cmd *cmd;
@@ -88,7 +88,7 @@ static int qeth_l2_send_setdelmac(struct qeth_card *card, __u8 *mac,
 	return qeth_send_ipa_cmd(card, iob, qeth_l2_send_setdelmac_cb, NULL);
 }
 
-static int qeth_l2_send_setmac(struct qeth_card *card, __u8 *mac)
+static int qeth_l2_send_setmac(struct qeth_card *card, const __u8 *mac)
 {
 	int rc;
 
@@ -377,7 +377,7 @@ static int qeth_l2_set_mac_address(struct net_device *dev, void *p)
 	if (rc)
 		return rc;
 	ether_addr_copy(old_addr, dev->dev_addr);
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	if (card->info.dev_addr_is_registered)
 		qeth_l2_remove_mac(card, old_addr);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 6fd3e288f059..e6e921310211 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -913,8 +913,7 @@ static int qeth_l3_iqd_read_initial_mac_cb(struct qeth_card *card,
 	if (!is_valid_ether_addr(cmd->data.create_destroy_addr.mac_addr))
 		return -EADDRNOTAVAIL;
 
-	ether_addr_copy(card->dev->dev_addr,
-			cmd->data.create_destroy_addr.mac_addr);
+	eth_hw_addr_set(card->dev, cmd->data.create_destroy_addr.mac_addr);
 	return 0;
 }
 
-- 
2.31.1

