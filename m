Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0756B436282
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJUNOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhJUNOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48AE26128B;
        Thu, 21 Oct 2021 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821942;
        bh=rX6qUnWXInrIBP+dqrgOd9ydTHr7T8WZIpz5ZhQ8G20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un1mptCW39SlEWo6OAfNZXHVOGj64ns9pZ/qSssq5MGj7dvnBQxo1JFTbU+s0w7bQ
         w73booVkyJcIVAWCehgd8lxuMIAQi+8y8ZJyiLayqCi3DAjXmLqC5KvU/BAf7W/CJh
         S0yJn58phlCfB3rByonJMkH/Vgu6xc5AESeTyb6JNPWzGfdETHr9+1+WROgAGIFfgV
         4g2SvRO+CcNYT3ir6QtH/lvWQWEmblIlpQ8JiDnPWAc+5JIV1VeyebPxVEaCZVbh31
         H9hdcLhnbtXtelkxPl4J4NV8FEwQdgw8bkB7gyEBPlSc4k4FCwQ22A1EjjiBSApHyK
         ZsbDuCtyEmQsw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v2 09/12] net: s390: constify and use eth_hw_addr_set()
Date:   Thu, 21 Oct 2021 06:12:11 -0700
Message-Id: <20211021131214.2032925-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
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

Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
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

