Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092DB2060C1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392819AbgFWUqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:46:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:38312 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392813AbgFWUqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:46:11 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKk8fq019582;
        Tue, 23 Jun 2020 13:46:09 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 1/2] cxgb4: always sync access when flashing PHY firmware
Date:   Wed, 24 Jun 2020 02:03:22 +0530
Message-Id: <8a7f61ef7547f8fe6db1abe52c6fdad6f55ddfa6.1592941598.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592941598.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access to on-chip memory for flashing PHY firmware must always
be synchronized. So, ensure the callers take on-chip memory lock.

Also fixes following sparse warning:
sge.c:1641:26: warning: context imbalance in 't4_load_phy_fw' -
different lock contexts for basic block

Fixes: 01b6961410b7 ("cxgb4: Add PHY firmware support for T420-BT cards")
Fixes: 4ee339e1e92a ("cxgb4: add support to flash PHY image")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |  3 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |  5 +++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  5 +++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         | 14 +++-----------
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 466a61ba23ce..d811df1b93d9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1813,8 +1813,7 @@ int t4_get_pfres(struct adapter *adapter);
 int t4_read_flash(struct adapter *adapter, unsigned int addr,
 		  unsigned int nwords, u32 *data, int byte_oriented);
 int t4_load_fw(struct adapter *adapter, const u8 *fw_data, unsigned int size);
-int t4_load_phy_fw(struct adapter *adap,
-		   int win, spinlock_t *lock,
+int t4_load_phy_fw(struct adapter *adap, int win,
 		   int (*phy_fw_version)(const u8 *, size_t),
 		   const u8 *phy_fw_data, size_t phy_fw_size);
 int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 3dd28e5856ba..37d86af44074 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1305,8 +1305,9 @@ static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
 		return ret;
 	}
 
-	ret = t4_load_phy_fw(adap, MEMWIN_NIC, &adap->win0_lock,
-			     NULL, data, size);
+	spin_lock_bh(&adap->win0_lock);
+	ret = t4_load_phy_fw(adap, MEMWIN_NIC, NULL, data, size);
+	spin_unlock_bh(&adap->win0_lock);
 	if (ret)
 		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7423980bc49a..87505a0d906a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -4146,9 +4146,10 @@ static int adap_init0_phy(struct adapter *adap)
 
 	/* Load PHY Firmware onto adapter.
 	 */
-	ret = t4_load_phy_fw(adap, MEMWIN_NIC, &adap->win0_lock,
-			     phy_info->phy_fw_version,
+	spin_lock_bh(&adap->win0_lock);
+	ret = t4_load_phy_fw(adap, MEMWIN_NIC, phy_info->phy_fw_version,
 			     (u8 *)phyf->data, phyf->size);
+	spin_unlock_bh(&adap->win0_lock);
 	if (ret < 0)
 		dev_err(adap->pdev_dev, "PHY Firmware transfer error %d\n",
 			-ret);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 9d557f3cd3aa..8f2b7c9aa384 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3752,7 +3752,6 @@ int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver)
  *	t4_load_phy_fw - download port PHY firmware
  *	@adap: the adapter
  *	@win: the PCI-E Memory Window index to use for t4_memory_rw()
- *	@win_lock: the lock to use to guard the memory copy
  *	@phy_fw_version: function to check PHY firmware versions
  *	@phy_fw_data: the PHY firmware image to write
  *	@phy_fw_size: image size
@@ -3761,9 +3760,7 @@ int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver)
  *	@phy_fw_version is supplied, then it will be used to determine if
  *	it's necessary to perform the transfer by comparing the version
  *	of any existing adapter PHY firmware with that of the passed in
- *	PHY firmware image.  If @win_lock is non-NULL then it will be used
- *	around the call to t4_memory_rw() which transfers the PHY firmware
- *	to the adapter.
+ *	PHY firmware image.
  *
  *	A negative error number will be returned if an error occurs.  If
  *	version number support is available and there's no need to upgrade
@@ -3775,14 +3772,13 @@ int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver)
  *	contents.  Thus, loading PHY firmware on such adapters must happen
  *	after any FW_RESET_CMDs ...
  */
-int t4_load_phy_fw(struct adapter *adap,
-		   int win, spinlock_t *win_lock,
+int t4_load_phy_fw(struct adapter *adap, int win,
 		   int (*phy_fw_version)(const u8 *, size_t),
 		   const u8 *phy_fw_data, size_t phy_fw_size)
 {
+	int cur_phy_fw_ver = 0, new_phy_fw_vers = 0;
 	unsigned long mtype = 0, maddr = 0;
 	u32 param, val;
-	int cur_phy_fw_ver = 0, new_phy_fw_vers = 0;
 	int ret;
 
 	/* If we have version number support, then check to see if the adapter
@@ -3822,13 +3818,9 @@ int t4_load_phy_fw(struct adapter *adap,
 	/* Copy the supplied PHY Firmware image to the adapter memory location
 	 * allocated by the adapter firmware.
 	 */
-	if (win_lock)
-		spin_lock_bh(win_lock);
 	ret = t4_memory_rw(adap, win, mtype, maddr,
 			   phy_fw_size, (__be32 *)phy_fw_data,
 			   T4_MEMORY_WRITE);
-	if (win_lock)
-		spin_unlock_bh(win_lock);
 	if (ret)
 		return ret;
 
-- 
2.24.0

