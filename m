Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F753D7770
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhG0NsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236975AbhG0Nq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E1D61AA8;
        Tue, 27 Jul 2021 13:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393587;
        bh=gBgBZAebDtJXSKWPcxqP0vNXivcofN4bdSs/nzHkjyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aCynIkpi7eoqDG56P8ZjOXC/eEBoSD5j9p0gIJ6IsDRJENHvZZaoDxMbwnypMPV1R
         11MQBrLKP4OANvXzfUhA/QzkwxNDk0oSxgvJxfuwLw8mNpFKLan/gdFuuWz84pN/jU
         qnHFs5N2gnk3oiE5z4yfIitArVHrzuSZ0xF+gDRN+PNqcWzNyUBIM6RUnivJp2JbcQ
         LiubyUn/7Ortk/BfndD0Ma1OdxB31IqPzS12xbiGzdCwbDD6Nyk0G/7yx27A4blQxg
         KMGMjSslJea5duASgwARzZznHRPUyphXOyjwEVxmiGI1FZhatDUFTbaye/nbMEewcM
         C0D3jyNo3l3Jw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH net-next v3 16/31] qeth: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:02 +0200
Message-Id: <20210727134517.1384504-17-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

qeth has both standard MII ioctls and custom SIOCDEVPRIVATE ones,
all of which work correctly with compat user space.

Move the private ones over to the new ndo_siocdevprivate callback.

Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/s390/net/qeth_core.h      |  5 ++++-
 drivers/s390/net/qeth_core_main.c | 35 ++++++++++++++++++++++---------
 drivers/s390/net/qeth_l2_main.c   |  1 +
 drivers/s390/net/qeth_l3_main.c   |  8 ++++---
 4 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c17031519900..535a60b3946d 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -771,7 +771,8 @@ struct qeth_discipline {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online)(struct qeth_card *card, bool carrier_ok);
 	void (*set_offline)(struct qeth_card *card);
-	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
+	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq,
+			void __user *data, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
 };
@@ -1085,6 +1086,8 @@ int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 				     enum qeth_ipa_isolation_modes mode);
 
 int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			void __user *data, int cmd);
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7f486212c6aa..5b973f377504 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6590,21 +6590,42 @@ static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
 	.shutdown = qeth_core_shutdown,
 };
 
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
@@ -6617,14 +6638,8 @@ int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
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
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 7fe0f1aea3cb..d50d3cba238e 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -837,6 +837,7 @@ static const struct net_device_ops qeth_l2_netdev_ops = {
 	.ndo_validate_addr	= qeth_l2_validate_addr,
 	.ndo_set_rx_mode	= qeth_l2_set_rx_mode,
 	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_set_mac_address    = qeth_l2_set_mac_address,
 	.ndo_vlan_rx_add_vid	= qeth_l2_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid   = qeth_l2_vlan_rx_kill_vid,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 7cc59f4f046c..d7a895372f19 100644
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
@@ -1842,6 +1842,7 @@ static const struct net_device_ops qeth_l3_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
 	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_tx_timeout		= qeth_tx_timeout,
@@ -1857,6 +1858,7 @@ static const struct net_device_ops qeth_l3_osa_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_rx_mode	= qeth_l3_set_rx_mode,
 	.ndo_do_ioctl		= qeth_do_ioctl,
+	.ndo_siocdevprivate	= qeth_siocdevprivate,
 	.ndo_fix_features	= qeth_fix_features,
 	.ndo_set_features	= qeth_set_features,
 	.ndo_tx_timeout		= qeth_tx_timeout,
-- 
2.29.2

