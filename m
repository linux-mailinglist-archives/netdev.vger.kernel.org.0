Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B0B55E882
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346198AbiF1N7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346287AbiF1N7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:59:15 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 857FD35DC1
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:58:57 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id B7A0E320102;
        Tue, 28 Jun 2022 14:58:56 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6Bjz-0008Gu-NW;
        Tue, 28 Jun 2022 14:58:55 +0100
Subject: [PATCH net-next v2 01/10] sfc: Split STATE_READY in to STATE_NET_DOWN
 and STATE_NET_UP.
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 14:58:55 +0100
Message-ID: <165642473560.31669.12037246589913032497.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

This patch splits the READY state in to NET_UP and NET_DOWN. This
is to prepare for future work to delay resource allocation until
interface up so that we can use resources more efficiently in
SRIOV environments, and also to lay the ground work for an extra
PROBED state where we don't create a network interface,
for VDPA operation.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c   |    6 +++
 drivers/net/ethernet/sfc/efx.c            |   29 ++++++++---------
 drivers/net/ethernet/sfc/efx_common.c     |   10 +++---
 drivers/net/ethernet/sfc/efx_common.h     |    6 +--
 drivers/net/ethernet/sfc/ethtool_common.c |    2 +
 drivers/net/ethernet/sfc/net_driver.h     |   50 +++++++++++++++++++++++++++--
 6 files changed, 72 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..b9106ce678d9 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -96,6 +96,8 @@ static int ef100_net_stop(struct net_device *net_dev)
 	efx_mcdi_free_vis(efx);
 	efx_remove_interrupts(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 }
 
@@ -172,6 +174,8 @@ static int ef100_net_open(struct net_device *net_dev)
 		efx_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
+	efx->state = STATE_NET_UP;
+
 	return 0;
 
 fail:
@@ -271,7 +275,7 @@ int ef100_register_netdev(struct efx_nic *efx)
 	/* Always start with carrier off; PHY events will detect the link */
 	netif_carrier_off(net_dev);
 
-	efx->state = STATE_READY;
+	efx->state = STATE_NET_DOWN;
 	rtnl_unlock();
 	efx_init_mcdi_logging(efx);
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 5a772354da83..7f4e96a422e6 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -106,14 +106,6 @@ static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			u32 flags);
 
-#define EFX_ASSERT_RESET_SERIALISED(efx)		\
-	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
-			ASSERT_RTNL();			\
-	} while (0)
-
 /**************************************************************************
  *
  * Port handling
@@ -378,6 +370,8 @@ static int efx_probe_all(struct efx_nic *efx)
 	if (rc)
 		goto fail5;
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 
  fail5:
@@ -544,6 +538,9 @@ int efx_net_open(struct net_device *net_dev)
 	efx_start_all(efx);
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
+	else
+		efx->state = STATE_NET_UP;
+
 	efx_selftest_async_start(efx);
 	return 0;
 }
@@ -720,8 +717,6 @@ static int efx_register_netdev(struct efx_nic *efx)
 	 * already requested.  If so, the NIC is probably hosed so we
 	 * abort.
 	 */
-	efx->state = STATE_READY;
-	smp_mb(); /* ensure we change state before checking reset_pending */
 	if (efx->reset_pending) {
 		pci_err(efx->pci_dev, "aborting probe due to scheduled reset\n");
 		rc = -EIO;
@@ -748,6 +743,8 @@ static int efx_register_netdev(struct efx_nic *efx)
 
 	efx_associate(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	rtnl_unlock();
 
 	rc = device_create_file(&efx->pci_dev->dev, &dev_attr_phy_type);
@@ -845,7 +842,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	/* Flush reset_work. It can no longer be scheduled since we
 	 * are not READY.
 	 */
-	BUG_ON(efx->state == STATE_READY);
+	WARN_ON(efx_net_active(efx->state));
 	efx_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
@@ -1150,13 +1147,13 @@ static int efx_pm_freeze(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_UNINIT;
-
+	if (efx_net_active(efx->state)) {
 		efx_device_detach_sync(efx);
 
 		efx_stop_all(efx);
 		efx_disable_interrupts(efx);
+
+		efx->state = efx_freeze(efx->state);
 	}
 
 	rtnl_unlock();
@@ -1171,7 +1168,7 @@ static int efx_pm_thaw(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
+	if (efx_frozen(efx->state)) {
 		rc = efx_enable_interrupts(efx);
 		if (rc)
 			goto fail;
@@ -1184,7 +1181,7 @@ static int efx_pm_thaw(struct device *dev)
 
 		efx_device_attach_if_not_resetting(efx);
 
-		efx->state = STATE_READY;
+		efx->state = efx_thaw(efx->state);
 
 		efx->type->resume_wol(efx);
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f6577e74d6e6..f6baebd9d632 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -898,7 +898,7 @@ static void efx_reset_work(struct work_struct *data)
 	 * have changed by now.  Now that we have the RTNL lock,
 	 * it cannot change again.
 	 */
-	if (efx->state == STATE_READY)
+	if (efx_net_active(efx->state))
 		(void)efx_reset(efx, method);
 
 	rtnl_unlock();
@@ -908,7 +908,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 {
 	enum reset_type method;
 
-	if (efx->state == STATE_RECOVERY) {
+	if (efx_recovering(efx->state)) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "recovering: skip scheduling %s reset\n",
 			  RESET_TYPE(type));
@@ -943,7 +943,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	/* If we're not READY then just leave the flags set as the cue
 	 * to abort probing or reschedule the reset later.
 	 */
-	if (READ_ONCE(efx->state) != STATE_READY)
+	if (!efx_net_active(READ_ONCE(efx->state)))
 		return;
 
 	/* efx_process_channel() will no longer read events once a
@@ -1217,7 +1217,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 	rtnl_lock();
 
 	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_RECOVERY;
+		efx->state = efx_recover(efx->state);
 		efx->reset_pending = 0;
 
 		efx_device_detach_sync(efx);
@@ -1271,7 +1271,7 @@ static void efx_io_resume(struct pci_dev *pdev)
 		netif_err(efx, hw, efx->net_dev,
 			  "efx_reset failed after PCI error (%d)\n", rc);
 	} else {
-		efx->state = STATE_READY;
+		efx->state = efx_recovered(efx->state);
 		netif_dbg(efx, hw, efx->net_dev,
 			  "Done resetting and resuming IO after PCI error.\n");
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..c72e819da8fd 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -45,9 +45,7 @@ int efx_reconfigure_port(struct efx_nic *efx);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
+		if (efx->state != STATE_UNINIT)		\
 			ASSERT_RTNL();			\
 	} while (0)
 
@@ -64,7 +62,7 @@ void efx_port_dummy_op_void(struct efx_nic *efx);
 
 static inline int efx_check_disabled(struct efx_nic *efx)
 {
-	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
+	if (efx->state == STATE_DISABLED || efx_recovering(efx->state)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "device is disabled due to earlier errors\n");
 		return -EIO;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bd552c7dffcb..3846b76b8972 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -137,7 +137,7 @@ void efx_ethtool_self_test(struct net_device *net_dev,
 	if (!efx_tests)
 		goto fail;
 
-	if (efx->state != STATE_READY) {
+	if (!efx_net_active(efx->state)) {
 		rc = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 723bbeea5d0c..95069125931a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -622,12 +622,54 @@ enum efx_int_mode {
 #define EFX_INT_MODE_USE_MSI(x) (((x)->interrupt_mode) <= EFX_INT_MODE_MSI)
 
 enum nic_state {
-	STATE_UNINIT = 0,	/* device being probed/removed or is frozen */
-	STATE_READY = 1,	/* hardware ready and netdev registered */
-	STATE_DISABLED = 2,	/* device disabled due to hardware errors */
-	STATE_RECOVERY = 3,	/* device recovering from PCI error */
+	STATE_UNINIT = 0,	/* device being probed/removed */
+	STATE_NET_DOWN,		/* hardware probed and netdev registered */
+	STATE_NET_UP,		/* ready for traffic */
+	STATE_DISABLED,		/* device disabled due to hardware errors */
+
+	STATE_RECOVERY = 0x100,/* recovering from PCI error */
+	STATE_FROZEN = 0x200,	/* frozen by power management */
 };
 
+static inline bool efx_net_active(enum nic_state state)
+{
+	return state == STATE_NET_DOWN || state == STATE_NET_UP;
+}
+
+static inline bool efx_frozen(enum nic_state state)
+{
+	return state & STATE_FROZEN;
+}
+
+static inline bool efx_recovering(enum nic_state state)
+{
+	return state & STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_freeze(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_FROZEN;
+}
+
+static inline enum nic_state efx_thaw(enum nic_state state)
+{
+	WARN_ON(!efx_frozen(state));
+	return state & ~STATE_FROZEN;
+}
+
+static inline enum nic_state efx_recover(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_recovered(enum nic_state state)
+{
+	WARN_ON(!efx_recovering(state));
+	return state & ~STATE_RECOVERY;
+}
+
 /* Forward declaration */
 struct efx_nic;
 


