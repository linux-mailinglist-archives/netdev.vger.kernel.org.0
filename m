Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE3B3CFD6A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbhGTOkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239398AbhGTOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D8C6121E;
        Tue, 20 Jul 2021 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792431;
        bh=sVbOp188yi2tF3NVLhBd9gD5vPVYyqpmmx/gr7rXj78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqrIvO092Hu1lVaoH3jRadeudoflkFgWpqnpa8XyfBGfCDymTKGl6J0NNOHpdJZfw
         95dKPWf426sDNzRym7f9WJSz4cnBvUcFNVboB7joqqFOKZrro9ZM6fSkCjSgDxdEUB
         +nObX84N4BDWjX7/yqun39tW9k7vxxXSdVmktu/txxpg6nmLgm7+J2vtG+kchDz31x
         fcLu3RfVK4dRxgfwYJjOlPtHpD2BfryQKHc8SeSTdqKDWQ7G2Ad5DCgfJcoLuagCla
         yO2PgRqnY57yMx90vCkU9WZcuWdpwa2yTkTz0zs/lJeVQKbjoQLMrE0xToYvHYcr/0
         IhgS0kUfbBTAA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 16/31] qeth: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:23 +0200
Message-Id: <20210720144638.2859828-17-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

qeth has both standard MII ioctls and custom SIOCDEVPRIVATE ones,
all of which work correctly with compat user space.

Move the private ones over to the new ndo_siocdevprivate callback.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/s390/net/qeth_core.h      |  5 ++++-
 drivers/s390/net/qeth_core_main.c | 35 ++++++++++++++++++++++---------
 drivers/s390/net/qeth_l3_main.c   |  6 +++---
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f4d554ea0c93..89fd7432dbec 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -790,7 +790,8 @@ struct qeth_discipline {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online)(struct qeth_card *card, bool carrier_ok);
 	void (*set_offline)(struct qeth_card *card);
-	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
+	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq,
+			void __user *data, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
 };
@@ -1124,6 +1125,8 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			unsigned int offset, unsigned int hd_len,
 			int elements_needed);
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			void __user *data, int cmd);
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 62f88ccbd03f..be19cfd05136 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6672,21 +6672,42 @@ struct qeth_card *qeth_get_card_by_busid(char *bus_id)
 }
 EXPORT_SYMBOL_GPL(qeth_get_card_by_busid);
 
-int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
 {
 	struct qeth_card *card = dev->ml_priv;
-	struct mii_ioctl_data *mii_data;
 	int rc = 0;
 
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
-		rc = qeth_snmp_command(card, rq->ifr_ifru.ifru_data);
+		rc = qeth_snmp_command(card, data);
 		break;
 	case SIOC_QETH_GET_CARD_TYPE:
 		if ((IS_OSD(card) || IS_OSM(card) || IS_OSX(card)) &&
 		    !IS_VM_NIC(card))
 			return 1;
 		return 0;
+	case SIOC_QETH_QUERY_OAT:
+		rc = qeth_query_oat_command(card, data);
+		break;
+	default:
+		if (card->discipline->do_ioctl)
+			rc = card->discipline->do_ioctl(dev, rq, data, cmd);
+		else
+			rc = -EOPNOTSUPP;
+	}
+	if (rc)
+		QETH_CARD_TEXT_(card, 2, "ioce%x", rc);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(qeth_siocdevprivate);
+
+int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct qeth_card *card = dev->ml_priv;
+	struct mii_ioctl_data *mii_data;
+	int rc = 0;
+
+	switch (cmd) {
 	case SIOCGMIIPHY:
 		mii_data = if_mii(rq);
 		mii_data->phy_id = 0;
@@ -6699,14 +6720,8 @@ int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			mii_data->val_out = qeth_mdio_read(dev,
 				mii_data->phy_id, mii_data->reg_num);
 		break;
-	case SIOC_QETH_QUERY_OAT:
-		rc = qeth_query_oat_command(card, rq->ifr_ifru.ifru_data);
-		break;
 	default:
-		if (card->discipline->do_ioctl)
-			rc = card->discipline->do_ioctl(dev, rq, cmd);
-		else
-			rc = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 	if (rc)
 		QETH_CARD_TEXT_(card, 2, "ioce%x", rc);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f0d6f205c53c..71778b6076bd 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1512,7 +1512,7 @@ static int qeth_l3_arp_flush_cache(struct qeth_card *card)
 	return rc;
 }
 
-static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
 {
 	struct qeth_card *card = dev->ml_priv;
 	struct qeth_arp_cache_entry arp_entry;
@@ -1532,13 +1532,13 @@ static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 			rc = -EPERM;
 			break;
 		}
-		rc = qeth_l3_arp_query(card, rq->ifr_ifru.ifru_data);
+		rc = qeth_l3_arp_query(card, data);
 		break;
 	case SIOC_QETH_ARP_ADD_ENTRY:
 	case SIOC_QETH_ARP_REMOVE_ENTRY:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		if (copy_from_user(&arp_entry, rq->ifr_data, sizeof(arp_entry)))
+		if (copy_from_user(&arp_entry, data, sizeof(arp_entry)))
 			return -EFAULT;
 
 		arp_cmd = (cmd == SIOC_QETH_ARP_ADD_ENTRY) ?
-- 
2.29.2

