Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACF76BA99A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCOHn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCOHnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:43:53 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3B836683
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:43:25 -0700 (PDT)
X-QQ-mid: bizesmtp70t1678866196t4m43ow6
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 15 Mar 2023 15:43:06 +0800 (CST)
X-QQ-SSF: 01400000000000N0P000000A0000000
X-QQ-FEAT: hoArX50alxGGlg5J2KQzQGtf44KVwQS5pVuwE0NPw2xlfJ75jDZrtjAyaxtxE
        usrLdEVyqWv4Gnlo+RQz6K6+grtrH7UxdGVCK6FylJ7H4Qf2qs4eUcj5TFaBY25gHnfuaeH
        s2MoyWxHE20Uj/b3WGFubMLmLTCAc30xLCv5HuUT7FJKEJEPG7USueoUqLN3ocx5lxz3LoL
        3yzx7Ej73XAjsExDeUizOjkm5eSnLT6MbXvTQWylC9x+XPRDUcs9vPwJwuGE739gaKsSGM/
        1hiZN6CLE2uUfekovx5ec7GJAulw+lASzWoXiJJR7FkXPJogohfvG9cKfuO0xGK9KR3VDNL
        sGiE2vq+e+93QTz+BuaXh+IxPeEO/aL2On4it+M5Nb5GUd+PLUx0bc0fYysvU+Uw9UsgXZy
        Mi/DMpVK+MPhcD2GWnKib0g0jGj7att9
X-QQ-GoodBg: 2
From:   mengyuanlou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2] net: wangxun: Implement the ndo change mtu interface
Date:   Wed, 15 Mar 2023 15:43:04 +0800
Message-Id: <20230315074304.13178-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>

Add ngbe and txgbe ndo_change_mtu support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
v2:
- Andrew Lunn: https://lore.kernel.org/netdev/Y+4rd1q58XzLlCOy@lunn.ch/
- Alexander Lobakin:
	https://lore.kernel.org/netdev/fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com/

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 21 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  5 ++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  1 -
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  5 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 -
 7 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 7db57f934a91..ca409b4054d0 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 
@@ -1261,7 +1262,7 @@ static void wx_set_rx_buffer_len(struct wx *wx)
 	struct net_device *netdev = wx->netdev;
 	u32 mhadd, max_frame;
 
-	max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	max_frame = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	/* adjust max frame to be at least the size of a standard frame */
 	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
 		max_frame = (ETH_FRAME_LEN + ETH_FCS_LEN);
@@ -1271,6 +1272,24 @@ static void wx_set_rx_buffer_len(struct wx *wx)
 		wr32(wx, WX_PSR_MAX_SZ, max_frame);
 }
 
+/**
+ * wx_change_mtu - Change the Maximum Transfer Unit
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ **/
+int wx_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	netdev->mtu = new_mtu;
+	wx_set_rx_buffer_len(wx);
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_change_mtu);
+
 /* Disable the specified rx queue */
 void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring)
 {
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 44dfd6ea442a..c173c56f0ab5 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -23,6 +23,7 @@ void wx_flush_sw_mac_table(struct wx *wx);
 int wx_set_mac(struct net_device *netdev, void *p);
 void wx_disable_rx(struct wx *wx);
 void wx_set_rx_mode(struct net_device *netdev);
+int wx_change_mtu(struct net_device *netdev, int new_mtu);
 void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring);
 void wx_configure(struct wx *wx);
 int wx_disable_pcie_master(struct wx *wx);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 77d8d7f1707e..2b9efd13c500 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -300,6 +300,8 @@
 #define WX_MAX_RXD                   8192
 #define WX_MAX_TXD                   8192
 
+#define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
+
 /* Supported Rx Buffer Sizes */
 #define WX_RXBUFFER_256      256    /* Used for skb receive header */
 #define WX_RXBUFFER_2K       2048
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 0e4163e1106f..1a004aa2adcb 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <net/ip.h>
 #include <linux/phy.h>
+#include <linux/if_vlan.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
@@ -469,6 +470,7 @@ static void ngbe_shutdown(struct pci_dev *pdev)
 static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_open               = ngbe_open,
 	.ndo_stop               = ngbe_close,
+	.ndo_change_mtu         = wx_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
@@ -560,7 +562,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = NGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+	netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE -
+			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 
 	wx->bd_number = func_nums;
 	/* setup the private structure */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index a2351349785e..373d5af628cd 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -137,7 +137,6 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_RX_PB_SIZE				42
 #define NGBE_MC_TBL_SIZE			128
 #define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
-#define NGBE_MAX_JUMBO_FRAME_SIZE		9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define NGBE_DEFAULT_TXD			512 /* default ring size */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 859feaafd350..843a88bc416f 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -8,6 +8,7 @@
 #include <linux/string.h>
 #include <linux/etherdevice.h>
 #include <net/ip.h>
+#include <linux/if_vlan.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_lib.h"
@@ -486,6 +487,7 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
+	.ndo_change_mtu         = wx_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
@@ -603,7 +605,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+	netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE -
+			  (ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 
 	/* make sure the EEPROM is good */
 	err = txgbe_validate_eeprom_checksum(wx, NULL);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 563ea51deca6..63a1c733718d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -79,7 +79,6 @@
 #define TXGBE_SP_MC_TBL_SIZE    128
 #define TXGBE_SP_RX_PB_SIZE     512
 #define TXGBE_SP_TDB_PB_SZ      (160 * 1024) /* 160KB Packet Buffer */
-#define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define TXGBE_DEFAULT_TXD               512
-- 
2.40.0

