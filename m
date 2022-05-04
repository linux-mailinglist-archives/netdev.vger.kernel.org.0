Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453AF5198E2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbiEDHzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345850AbiEDHzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:55:39 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 847401A388
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:51:48 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 412533200C7;
        Wed,  4 May 2022 08:51:47 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nm9nX-0003U5-1J; Wed, 04 May 2022 08:51:47 +0100
Subject: [PATCH net-next v3 10/13] sfc/siena: Rename functions in mcdi
 headers to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 04 May 2022 08:51:46 +0100
Message-ID: <165165070672.13116.12047770756741249907.stgit@palantir17.mph.net>
In-Reply-To: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the function prefix.
Several functions are not used in Siena, so they are removed.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c              |    6 
 drivers/net/ethernet/sfc/siena/efx_channels.c     |    6 
 drivers/net/ethernet/sfc/siena/efx_common.c       |   10 -
 drivers/net/ethernet/sfc/siena/ethtool.c          |    2 
 drivers/net/ethernet/sfc/siena/ethtool_common.c   |   20 +
 drivers/net/ethernet/sfc/siena/farch.c            |    4 
 drivers/net/ethernet/sfc/siena/mcdi.c             |  410 ++++++++-------------
 drivers/net/ethernet/sfc/siena/mcdi.h             |  134 +++----
 drivers/net/ethernet/sfc/siena/mcdi_mon.c         |   25 +
 drivers/net/ethernet/sfc/siena/mcdi_port.c        |   33 +-
 drivers/net/ethernet/sfc/siena/mcdi_port.h        |    7 
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c |  174 ++++-----
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h |   61 +--
 drivers/net/ethernet/sfc/siena/ptp.c              |   70 ++--
 drivers/net/ethernet/sfc/siena/selftest.c         |    4 
 drivers/net/ethernet/sfc/siena/siena.c            |   93 ++---
 drivers/net/ethernet/sfc/siena/siena_sriov.c      |    9 
 17 files changed, 459 insertions(+), 609 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 0587877cc809..417c9f714da8 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -153,7 +153,7 @@ static int efx_init_port(struct efx_nic *efx)
 	efx->port_initialized = true;
 
 	/* Ensure the PHY advertises the correct flow control settings */
-	rc = efx_mcdi_port_reconfigure(efx);
+	rc = efx_siena_mcdi_port_reconfigure(efx);
 	if (rc && rc != -EPERM)
 		goto fail;
 
@@ -526,7 +526,7 @@ static int efx_net_open(struct net_device *net_dev)
 		return rc;
 	if (efx->phy_mode & PHY_MODE_SPECIAL)
 		return -EBUSY;
-	if (efx_mcdi_poll_reboot(efx) && efx_siena_reset(efx, RESET_TYPE_ALL))
+	if (efx_siena_mcdi_poll_reboot(efx) && efx_siena_reset(efx, RESET_TYPE_ALL))
 		return -EIO;
 
 	/* Notify the kernel of the link state polled during driver load,
@@ -1158,7 +1158,7 @@ static int efx_pm_thaw(struct device *dev)
 			goto fail;
 
 		mutex_lock(&efx->mac_lock);
-		efx_mcdi_port_reconfigure(efx);
+		efx_siena_mcdi_port_reconfigure(efx);
 		mutex_unlock(&efx->mac_lock);
 
 		efx_siena_start_all(efx);
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 0efe4c5c4d51..78246e6629f3 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -1022,7 +1022,7 @@ static int efx_soft_enable_interrupts(struct efx_nic *efx)
 		efx_siena_start_eventq(channel);
 	}
 
-	efx_mcdi_mode_event(efx);
+	efx_siena_mcdi_mode_event(efx);
 
 	return 0;
 fail:
@@ -1045,7 +1045,7 @@ static void efx_soft_disable_interrupts(struct efx_nic *efx)
 	if (efx->state == STATE_DISABLED)
 		return;
 
-	efx_mcdi_mode_poll(efx);
+	efx_siena_mcdi_mode_poll(efx);
 
 	efx->irq_soft_enabled = false;
 	smp_wmb();
@@ -1063,7 +1063,7 @@ static void efx_soft_disable_interrupts(struct efx_nic *efx)
 	}
 
 	/* Flush the asynchronous MCDI request queue */
-	efx_mcdi_flush_async(efx);
+	efx_siena_mcdi_flush_async(efx);
 }
 
 int efx_siena_enable_interrupts(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 6b524775c929..3293221b9e9e 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -456,7 +456,7 @@ static void efx_stop_datapath(struct efx_nic *efx)
  *
  **************************************************************************/
 
-/* Equivalent to efx_link_set_advertising with all-zeroes, except does not
+/* Equivalent to efx_siena_link_set_advertising with all-zeroes, except does not
  * force the Autoneg bit on.
  */
 void efx_siena_link_clear_advertising(struct efx_nic *efx)
@@ -547,7 +547,7 @@ void efx_siena_start_all(struct efx_nic *efx)
 	 * to poll now because we could have missed a change
 	 */
 	mutex_lock(&efx->mac_lock);
-	if (efx_mcdi_phy_poll(efx))
+	if (efx_siena_mcdi_phy_poll(efx))
 		efx_siena_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
@@ -665,7 +665,7 @@ static void efx_wait_for_bist_end(struct efx_nic *efx)
 	int i;
 
 	for (i = 0; i < BIST_WAIT_DELAY_COUNT; ++i) {
-		if (efx_mcdi_poll_reboot(efx))
+		if (efx_siena_mcdi_poll_reboot(efx))
 			goto out;
 		msleep(BIST_WAIT_DELAY_MS);
 	}
@@ -760,7 +760,7 @@ int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
 	    method != RESET_TYPE_DATAPATH) {
-		rc = efx_mcdi_port_reconfigure(efx);
+		rc = efx_siena_mcdi_port_reconfigure(efx);
 		if (rc && rc != -EPERM)
 			netif_err(efx, drv, efx->net_dev,
 				  "could not restore PHY settings\n");
@@ -950,7 +950,7 @@ void efx_siena_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	/* efx_process_channel() will no longer read events once a
 	 * reset is scheduled. So switch back to poll'd MCDI completions.
 	 */
-	efx_mcdi_mode_poll(efx);
+	efx_siena_mcdi_mode_poll(efx);
 
 	efx_siena_queue_reset_work(efx);
 }
diff --git a/drivers/net/ethernet/sfc/siena/ethtool.c b/drivers/net/ethernet/sfc/siena/ethtool.c
index 63388bec421d..5ee626ba4eb1 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool.c
@@ -50,7 +50,7 @@ static int efx_ethtool_phys_id(struct net_device *net_dev,
 		return 1;	/* cycle on/off once per second */
 	}
 
-	return efx_mcdi_set_id_led(efx, mode);
+	return efx_siena_mcdi_set_id_led(efx, mode);
 }
 
 static int efx_ethtool_get_regs_len(struct net_device *net_dev)
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index 91f750e4ede8..0207d07f54e3 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -106,8 +106,8 @@ void efx_siena_ethtool_get_drvinfo(struct net_device *net_dev,
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	efx_mcdi_print_fwver(efx, info->fw_version,
-			     sizeof(info->fw_version));
+	efx_siena_mcdi_print_fwver(efx, info->fw_version,
+				   sizeof(info->fw_version));
 	strlcpy(info->bus_info, pci_name(efx->pci_dev), sizeof(info->bus_info));
 }
 
@@ -173,7 +173,7 @@ int efx_siena_ethtool_set_pauseparam(struct net_device *net_dev,
 	efx_siena_link_set_wanted_fc(efx, wanted_fc);
 	if (efx->link_advertising[0] != old_adv ||
 	    (efx->wanted_fc ^ old_fc) & EFX_FC_AUTO) {
-		rc = efx_mcdi_port_reconfigure(efx);
+		rc = efx_siena_mcdi_port_reconfigure(efx);
 		if (rc) {
 			netif_err(efx, drv, efx->net_dev,
 				  "Unable to advertise requested flow "
@@ -328,7 +328,7 @@ static int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 		const char *name;
 
 		EFX_WARN_ON_PARANOID(i >= EFX_MAX_PHY_TESTS);
-		name = efx_mcdi_phy_test_name(efx, i);
+		name = efx_siena_mcdi_phy_test_name(efx, i);
 		if (name == NULL)
 			break;
 
@@ -565,7 +565,7 @@ int efx_siena_ethtool_get_link_ksettings(struct net_device *net_dev,
 	struct efx_link_state *link_state = &efx->link_state;
 
 	mutex_lock(&efx->mac_lock);
-	efx_mcdi_phy_get_link_ksettings(efx, cmd);
+	efx_siena_mcdi_phy_get_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 
 	/* Both MACs support pause frames (bidirectional and respond-only) */
@@ -597,7 +597,7 @@ efx_siena_ethtool_set_link_ksettings(struct net_device *net_dev,
 	}
 
 	mutex_lock(&efx->mac_lock);
-	rc = efx_mcdi_phy_set_link_ksettings(efx, cmd);
+	rc = efx_siena_mcdi_phy_set_link_ksettings(efx, cmd);
 	mutex_unlock(&efx->mac_lock);
 	return rc;
 }
@@ -609,7 +609,7 @@ int efx_siena_ethtool_get_fecparam(struct net_device *net_dev,
 	int rc;
 
 	mutex_lock(&efx->mac_lock);
-	rc = efx_mcdi_phy_get_fecparam(efx, fecparam);
+	rc = efx_siena_mcdi_phy_get_fecparam(efx, fecparam);
 	mutex_unlock(&efx->mac_lock);
 
 	return rc;
@@ -622,7 +622,7 @@ int efx_siena_ethtool_set_fecparam(struct net_device *net_dev,
 	int rc;
 
 	mutex_lock(&efx->mac_lock);
-	rc = efx_mcdi_phy_set_fecparam(efx, fecparam);
+	rc = efx_siena_mcdi_phy_set_fecparam(efx, fecparam);
 	mutex_unlock(&efx->mac_lock);
 
 	return rc;
@@ -1320,7 +1320,7 @@ int efx_siena_ethtool_get_module_eeprom(struct net_device *net_dev,
 	int ret;
 
 	mutex_lock(&efx->mac_lock);
-	ret = efx_mcdi_phy_get_module_eeprom(efx, ee, data);
+	ret = efx_siena_mcdi_phy_get_module_eeprom(efx, ee, data);
 	mutex_unlock(&efx->mac_lock);
 
 	return ret;
@@ -1333,7 +1333,7 @@ int efx_siena_ethtool_get_module_info(struct net_device *net_dev,
 	int ret;
 
 	mutex_lock(&efx->mac_lock);
-	ret = efx_mcdi_phy_get_module_info(efx, modinfo);
+	ret = efx_siena_mcdi_phy_get_module_info(efx, modinfo);
 	mutex_unlock(&efx->mac_lock);
 
 	return ret;
diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
index 4de36c6c28e1..ebd6fa408126 100644
--- a/drivers/net/ethernet/sfc/siena/farch.c
+++ b/drivers/net/ethernet/sfc/siena/farch.c
@@ -667,7 +667,7 @@ static int efx_farch_do_flush(struct efx_nic *efx)
 		 * completion). If that fails, fall back to the old scheme.
 		 */
 		if (efx_siena_sriov_enabled(efx)) {
-			rc = efx_mcdi_flush_rxqs(efx);
+			rc = efx_siena_mcdi_flush_rxqs(efx);
 			if (!rc)
 				goto wait;
 		}
@@ -1313,7 +1313,7 @@ int efx_farch_ev_process(struct efx_channel *channel, int budget)
 			break;
 #endif
 		case FSE_CZ_EV_CODE_MCDI_EV:
-			efx_mcdi_process_event(channel, &event);
+			efx_siena_mcdi_process_event(channel, &event);
 			break;
 		case FSE_AZ_EV_CODE_GLOBAL_EV:
 			if (efx->type->handle_global_event &&
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index ff426b228cb2..eb13aa59fe50 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(mcdi_logging_default,
 		 "Enable MCDI logging on newly-probed functions");
 #endif
 
-int efx_mcdi_init(struct efx_nic *efx)
+int efx_siena_mcdi_init(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi;
 	bool already_attached;
@@ -86,11 +86,11 @@ int efx_mcdi_init(struct efx_nic *efx)
 	INIT_LIST_HEAD(&mcdi->async_list);
 	timer_setup(&mcdi->async_timer, efx_mcdi_timeout_async, 0);
 
-	(void) efx_mcdi_poll_reboot(efx);
+	(void)efx_siena_mcdi_poll_reboot(efx);
 	mcdi->new_epoch = true;
 
 	/* Recover from a failed assertion before probing */
-	rc = efx_mcdi_handle_assertion(efx);
+	rc = efx_siena_mcdi_handle_assertion(efx);
 	if (rc)
 		goto fail2;
 
@@ -124,7 +124,7 @@ int efx_mcdi_init(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_mcdi_detach(struct efx_nic *efx)
+void efx_siena_mcdi_detach(struct efx_nic *efx)
 {
 	if (!efx->mcdi)
 		return;
@@ -135,7 +135,7 @@ void efx_mcdi_detach(struct efx_nic *efx)
 	efx_mcdi_drv_attach(efx, false, NULL);
 }
 
-void efx_mcdi_fini(struct efx_nic *efx)
+void efx_siena_mcdi_fini(struct efx_nic *efx)
 {
 	if (!efx->mcdi)
 		return;
@@ -360,7 +360,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 	int rc;
 
 	/* Check for a reboot atomically with respect to efx_mcdi_copyout() */
-	rc = efx_mcdi_poll_reboot(efx);
+	rc = efx_siena_mcdi_poll_reboot(efx);
 	if (rc) {
 		spin_lock_bh(&mcdi->iface_lock);
 		mcdi->resprc = rc;
@@ -401,7 +401,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 /* Test and clear MC-rebooted flag for this port/function; reset
  * software state as necessary.
  */
-int efx_mcdi_poll_reboot(struct efx_nic *efx)
+int efx_siena_mcdi_poll_reboot(struct efx_nic *efx)
 {
 	if (!efx->mcdi)
 		return 0;
@@ -440,7 +440,7 @@ static int efx_mcdi_await_completion(struct efx_nic *efx)
 	 * completed the request first, then we'll just end up completing the
 	 * request again, which is safe.
 	 *
-	 * We need an smp_rmb() to synchronise with efx_mcdi_mode_poll(), which
+	 * We need an smp_rmb() to synchronise with efx_siena_mcdi_mode_poll(), which
 	 * wait_event_timeout() implicitly provides.
 	 */
 	if (mcdi->mode == MCDI_MODE_POLL)
@@ -548,8 +548,8 @@ static bool efx_mcdi_complete_async(struct efx_mcdi_iface *mcdi, bool timeout)
 		err_len = min(sizeof(errbuf), data_len);
 		efx->type->mcdi_read_response(efx, errbuf, hdr_len,
 					      sizeof(errbuf));
-		efx_mcdi_display_error(efx, async->cmd, async->inlen, errbuf,
-				       err_len, rc);
+		efx_siena_mcdi_display_error(efx, async->cmd, async->inlen,
+					     errbuf, err_len, rc);
 	}
 
 	if (async->complete)
@@ -733,13 +733,13 @@ static int _efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned int cmd,
 			mcdi->proxy_rx_handle = 0;
 			mcdi->state = MCDI_STATE_PROXY_WAIT;
 		} else if (rc && !quiet) {
-			efx_mcdi_display_error(efx, cmd, inlen, errbuf, err_len,
-					       rc);
+			efx_siena_mcdi_display_error(efx, cmd, inlen, errbuf,
+						     err_len, rc);
 		}
 
 		if (rc == -EIO || rc == -EINTR) {
 			msleep(MCDI_STATUS_SLEEP_MS);
-			efx_mcdi_poll_reboot(efx);
+			efx_siena_mcdi_poll_reboot(efx);
 			mcdi->new_epoch = true;
 		}
 	}
@@ -813,7 +813,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 		return -EINVAL;
 	}
 
-	rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
+	rc = efx_siena_mcdi_rpc_start(efx, cmd, inbuf, inlen);
 	if (rc)
 		return rc;
 
@@ -894,14 +894,14 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
 	}
 
 	if (rc && !quiet && !(cmd == MC_CMD_REBOOT && rc == -EIO))
-		efx_mcdi_display_error(efx, cmd, inlen,
-				       outbuf, outlen, rc);
+		efx_siena_mcdi_display_error(efx, cmd, inlen,
+					     outbuf, outlen, rc);
 
 	return rc;
 }
 
 /**
- * efx_mcdi_rpc - Issue an MCDI command and wait for completion
+ * efx_siena_mcdi_rpc - Issue an MCDI command and wait for completion
  * @efx: NIC through which to issue the command
  * @cmd: Command type number
  * @inbuf: Command parameters
@@ -924,34 +924,34 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
  *	set accordingly.  In the latter case, *@outlen_actual will be
  *	set to zero.
  */
-int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
-		 const efx_dword_t *inbuf, size_t inlen,
-		 efx_dword_t *outbuf, size_t outlen,
-		 size_t *outlen_actual)
+int efx_siena_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
+		       const efx_dword_t *inbuf, size_t inlen,
+		       efx_dword_t *outbuf, size_t outlen,
+		       size_t *outlen_actual)
 {
 	return _efx_mcdi_rpc_evb_retry(efx, cmd, inbuf, inlen, outbuf, outlen,
 				       outlen_actual, false);
 }
 
 /* Normally, on receiving an error code in the MCDI response,
- * efx_mcdi_rpc will log an error message containing (among other
- * things) the raw error code, by means of efx_mcdi_display_error.
+ * efx_siena_mcdi_rpc will log an error message containing (among other
+ * things) the raw error code, by means of efx_siena_mcdi_display_error.
  * This _quiet version suppresses that; if the caller wishes to log
  * the error conditionally on the return code, it should call this
- * function and is then responsible for calling efx_mcdi_display_error
+ * function and is then responsible for calling efx_siena_mcdi_display_error
  * as needed.
  */
-int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
-		       const efx_dword_t *inbuf, size_t inlen,
-		       efx_dword_t *outbuf, size_t outlen,
-		       size_t *outlen_actual)
+int efx_siena_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
+			     const efx_dword_t *inbuf, size_t inlen,
+			     efx_dword_t *outbuf, size_t outlen,
+			     size_t *outlen_actual)
 {
 	return _efx_mcdi_rpc_evb_retry(efx, cmd, inbuf, inlen, outbuf, outlen,
 				       outlen_actual, true);
 }
 
-int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
-		       const efx_dword_t *inbuf, size_t inlen)
+int efx_siena_mcdi_rpc_start(struct efx_nic *efx, unsigned int cmd,
+			     const efx_dword_t *inbuf, size_t inlen)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
 	int rc;
@@ -1026,7 +1026,7 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
 }
 
 /**
- * efx_mcdi_rpc_async - Schedule an MCDI command to run asynchronously
+ * efx_siena_mcdi_rpc_async - Schedule an MCDI command to run asynchronously
  * @efx: NIC through which to issue the command
  * @cmd: Command type number
  * @inbuf: Command parameters
@@ -1046,42 +1046,44 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
  * (c) the request times-out (in timer context)
  */
 int
-efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
-		   const efx_dword_t *inbuf, size_t inlen, size_t outlen,
-		   efx_mcdi_async_completer *complete, unsigned long cookie)
+efx_siena_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
+			 const efx_dword_t *inbuf, size_t inlen, size_t outlen,
+			 efx_mcdi_async_completer *complete,
+			 unsigned long cookie)
 {
 	return _efx_mcdi_rpc_async(efx, cmd, inbuf, inlen, outlen, complete,
 				   cookie, false);
 }
 
-int efx_mcdi_rpc_async_quiet(struct efx_nic *efx, unsigned int cmd,
-			     const efx_dword_t *inbuf, size_t inlen,
-			     size_t outlen, efx_mcdi_async_completer *complete,
-			     unsigned long cookie)
+int efx_siena_mcdi_rpc_async_quiet(struct efx_nic *efx, unsigned int cmd,
+				   const efx_dword_t *inbuf, size_t inlen,
+				   size_t outlen,
+				   efx_mcdi_async_completer *complete,
+				   unsigned long cookie)
 {
 	return _efx_mcdi_rpc_async(efx, cmd, inbuf, inlen, outlen, complete,
 				   cookie, true);
 }
 
-int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
-			efx_dword_t *outbuf, size_t outlen,
-			size_t *outlen_actual)
+int efx_siena_mcdi_rpc_finish(struct efx_nic *efx, unsigned int cmd,
+			      size_t inlen, efx_dword_t *outbuf, size_t outlen,
+			      size_t *outlen_actual)
 {
 	return _efx_mcdi_rpc_finish(efx, cmd, inlen, outbuf, outlen,
 				    outlen_actual, false, NULL, NULL);
 }
 
-int efx_mcdi_rpc_finish_quiet(struct efx_nic *efx, unsigned cmd, size_t inlen,
-			      efx_dword_t *outbuf, size_t outlen,
-			      size_t *outlen_actual)
+int efx_siena_mcdi_rpc_finish_quiet(struct efx_nic *efx, unsigned int cmd,
+				    size_t inlen, efx_dword_t *outbuf,
+				    size_t outlen, size_t *outlen_actual)
 {
 	return _efx_mcdi_rpc_finish(efx, cmd, inlen, outbuf, outlen,
 				    outlen_actual, true, NULL, NULL);
 }
 
-void efx_mcdi_display_error(struct efx_nic *efx, unsigned cmd,
-			    size_t inlen, efx_dword_t *outbuf,
-			    size_t outlen, int rc)
+void efx_siena_mcdi_display_error(struct efx_nic *efx, unsigned int cmd,
+				  size_t inlen, efx_dword_t *outbuf,
+				  size_t outlen, int rc)
 {
 	int code = 0, err_arg = 0;
 
@@ -1098,7 +1100,7 @@ void efx_mcdi_display_error(struct efx_nic *efx, unsigned cmd,
  * error conditions with various locks held, so it must be lockless.
  * Caller is responsible for flushing asynchronous requests later.
  */
-void efx_mcdi_mode_poll(struct efx_nic *efx)
+void efx_siena_mcdi_mode_poll(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi;
 
@@ -1129,7 +1131,7 @@ void efx_mcdi_mode_poll(struct efx_nic *efx)
 /* Flush any running or queued asynchronous requests, after event processing
  * is stopped
  */
-void efx_mcdi_flush_async(struct efx_nic *efx)
+void efx_siena_mcdi_flush_async(struct efx_nic *efx)
 {
 	struct efx_mcdi_async_param *async, *next;
 	struct efx_mcdi_iface *mcdi;
@@ -1166,7 +1168,7 @@ void efx_mcdi_flush_async(struct efx_nic *efx)
 	}
 }
 
-void efx_mcdi_mode_event(struct efx_nic *efx)
+void efx_siena_mcdi_mode_event(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi;
 
@@ -1185,7 +1187,7 @@ void efx_mcdi_mode_event(struct efx_nic *efx)
 	 * request, because the completion method is specified in the request.
 	 * So acquire the interface to serialise the requestors. We don't need
 	 * to acquire the iface_lock to change the mode here, but we do need a
-	 * write memory barrier ensure that efx_mcdi_rpc() sees it, which
+	 * write memory barrier ensure that efx_siena_mcdi_rpc() sees it, which
 	 * efx_mcdi_acquire() provides.
 	 */
 	efx_mcdi_acquire_sync(mcdi);
@@ -1234,18 +1236,18 @@ static void efx_mcdi_ev_death(struct efx_nic *efx, int rc)
 	} else {
 		int count;
 
-		/* Consume the status word since efx_mcdi_rpc_finish() won't */
+		/* Consume the status word since efx_siena_mcdi_rpc_finish() won't */
 		for (count = 0; count < MCDI_STATUS_DELAY_COUNT; ++count) {
-			rc = efx_mcdi_poll_reboot(efx);
+			rc = efx_siena_mcdi_poll_reboot(efx);
 			if (rc)
 				break;
 			udelay(MCDI_STATUS_DELAY_US);
 		}
 
 		/* On EF10, a CODE_MC_REBOOT event can be received without the
-		 * reboot detection in efx_mcdi_poll_reboot() being triggered.
+		 * reboot detection in efx_siena_mcdi_poll_reboot() being triggered.
 		 * If zero was returned from the final call to
-		 * efx_mcdi_poll_reboot(), the MC reboot wasn't noticed but the
+		 * efx_siena_mcdi_poll_reboot(), the MC reboot wasn't noticed but the
 		 * MC has definitely rebooted so prepare for the reset.
 		 */
 		if (!rc && efx->type->mcdi_reboot_detected)
@@ -1308,8 +1310,8 @@ static void efx_handle_drain_event(struct efx_nic *efx)
 }
 
 /* Called from efx_farch_ev_process and efx_ef10_ev_process for MCDI events */
-void efx_mcdi_process_event(struct efx_channel *channel,
-			    efx_qword_t *event)
+void efx_siena_mcdi_process_event(struct efx_channel *channel,
+				  efx_qword_t *event)
 {
 	struct efx_nic *efx = channel->efx;
 	int code = EFX_QWORD_FIELD(*event, MCDI_EVENT_CODE);
@@ -1334,7 +1336,7 @@ void efx_mcdi_process_event(struct efx_channel *channel,
 		break;
 
 	case MCDI_EVENT_CODE_LINKCHANGE:
-		efx_mcdi_process_link_change(efx, event);
+		efx_siena_mcdi_process_link_change(efx, event);
 		break;
 	case MCDI_EVENT_CODE_SENSOREVT:
 		efx_sensor_event(efx, event);
@@ -1408,7 +1410,7 @@ void efx_mcdi_process_event(struct efx_channel *channel,
  **************************************************************************
  */
 
-void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
+void efx_siena_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_OUT_LEN);
 	size_t outlength;
@@ -1417,8 +1419,8 @@ void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len)
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_VERSION_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlength);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_VERSION, NULL, 0,
+				outbuf, sizeof(outbuf), &outlength);
 	if (rc)
 		goto fail;
 	if (outlength < MC_CMD_GET_VERSION_OUT_LEN) {
@@ -1464,8 +1466,9 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 	MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_UPDATE, 1);
 	MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_FIRMWARE_ID, MC_CMD_FW_LOW_LATENCY);
 
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_DRV_ATTACH, inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_DRV_ATTACH, inbuf,
+				      sizeof(inbuf), outbuf, sizeof(outbuf),
+				      &outlen);
 	/* If we're not the primary PF, trying to ATTACH with a FIRMWARE_ID
 	 * specified will fail with EPERM, and we have to tell the MC we don't
 	 * care what firmware we get.
@@ -1475,13 +1478,13 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 			  "efx_mcdi_drv_attach with fw-variant setting failed EPERM, trying without it\n");
 		MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_FIRMWARE_ID,
 			       MC_CMD_FW_DONT_CARE);
-		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_DRV_ATTACH, inbuf,
-					sizeof(inbuf), outbuf, sizeof(outbuf),
-					&outlen);
+		rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_DRV_ATTACH, inbuf,
+					      sizeof(inbuf), outbuf,
+					      sizeof(outbuf), &outlen);
 	}
 	if (rc) {
-		efx_mcdi_display_error(efx, MC_CMD_DRV_ATTACH, sizeof(inbuf),
-				       outbuf, outlen, rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_DRV_ATTACH,
+					     sizeof(inbuf), outbuf, outlen, rc);
 		goto fail;
 	}
 	if (outlen < MC_CMD_DRV_ATTACH_OUT_LEN) {
@@ -1518,8 +1521,8 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 	return rc;
 }
 
-int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
-			   u16 *fw_subtype_list, u32 *capabilities)
+int efx_siena_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
+				 u16 *fw_subtype_list, u32 *capabilities)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_BOARD_CFG_OUT_LENMAX);
 	size_t outlen, i;
@@ -1531,8 +1534,8 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 	BUILD_BUG_ON(MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT0_OFST & 1);
 	BUILD_BUG_ON(MC_CMD_GET_BOARD_CFG_OUT_MAC_ADDR_BASE_PORT1_OFST & 1);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_BOARD_CFG, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_BOARD_CFG, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 
@@ -1574,7 +1577,8 @@ int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 	return rc;
 }
 
-int efx_mcdi_log_ctrl(struct efx_nic *efx, bool evq, bool uart, u32 dest_evq)
+int efx_siena_mcdi_log_ctrl(struct efx_nic *efx, bool evq, bool uart,
+			    u32 dest_evq)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_LOG_CTRL_IN_LEN);
 	u32 dest = 0;
@@ -1590,12 +1594,12 @@ int efx_mcdi_log_ctrl(struct efx_nic *efx, bool evq, bool uart, u32 dest_evq)
 
 	BUILD_BUG_ON(MC_CMD_LOG_CTRL_OUT_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_LOG_CTRL, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_LOG_CTRL, inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
 	return rc;
 }
 
-int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out)
+int efx_siena_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_TYPES_OUT_LEN);
 	size_t outlen;
@@ -1603,8 +1607,8 @@ int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out)
 
 	BUILD_BUG_ON(MC_CMD_NVRAM_TYPES_IN_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_TYPES, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_TYPES, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 	if (outlen < MC_CMD_NVRAM_TYPES_OUT_LEN) {
@@ -1621,38 +1625,9 @@ int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out)
 	return rc;
 }
 
-/* This function finds types using the new NVRAM_PARTITIONS mcdi. */
-static int efx_new_mcdi_nvram_types(struct efx_nic *efx, u32 *number,
-				    u32 *nvram_types)
-{
-	efx_dword_t *outbuf = kzalloc(MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2,
-				      GFP_KERNEL);
-	size_t outlen;
-	int rc;
-
-	if (!outbuf)
-		return -ENOMEM;
-
-	BUILD_BUG_ON(MC_CMD_NVRAM_PARTITIONS_IN_LEN != 0);
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_PARTITIONS, NULL, 0,
-			  outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2, &outlen);
-	if (rc)
-		goto fail;
-
-	*number = MCDI_DWORD(outbuf, NVRAM_PARTITIONS_OUT_NUM_PARTITIONS);
-
-	memcpy(nvram_types, MCDI_PTR(outbuf, NVRAM_PARTITIONS_OUT_TYPE_ID),
-	       *number * sizeof(u32));
-
-fail:
-	kfree(outbuf);
-	return rc;
-}
-
-int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
-			size_t *size_out, size_t *erase_size_out,
-			bool *protected_out)
+int efx_siena_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
+			      size_t *size_out, size_t *erase_size_out,
+			      bool *protected_out)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_INFO_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_INFO_OUT_LEN);
@@ -1661,8 +1636,8 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 
 	MCDI_SET_DWORD(inbuf, NVRAM_INFO_IN_TYPE, type);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_INFO, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_INFO, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 	if (outlen < MC_CMD_NVRAM_INFO_OUT_LEN) {
@@ -1689,8 +1664,8 @@ static int efx_mcdi_nvram_test(struct efx_nic *efx, unsigned int type)
 
 	MCDI_SET_DWORD(inbuf, NVRAM_TEST_IN_TYPE, type);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_TEST, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_TEST, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		return rc;
 
@@ -1703,46 +1678,13 @@ static int efx_mcdi_nvram_test(struct efx_nic *efx, unsigned int type)
 	}
 }
 
-/* This function tests nvram partitions using the new mcdi partition lookup scheme */
-int efx_new_mcdi_nvram_test_all(struct efx_nic *efx)
-{
-	u32 *nvram_types = kzalloc(MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX_MCDI2,
-				   GFP_KERNEL);
-	unsigned int number;
-	int rc, i;
-
-	if (!nvram_types)
-		return -ENOMEM;
-
-	rc = efx_new_mcdi_nvram_types(efx, &number, nvram_types);
-	if (rc)
-		goto fail;
-
-	/* Require at least one check */
-	rc = -EAGAIN;
-
-	for (i = 0; i < number; i++) {
-		if (nvram_types[i] == NVRAM_PARTITION_TYPE_PARTITION_MAP ||
-		    nvram_types[i] == NVRAM_PARTITION_TYPE_DYNAMIC_CONFIG)
-			continue;
-
-		rc = efx_mcdi_nvram_test(efx, nvram_types[i]);
-		if (rc)
-			goto fail;
-	}
-
-fail:
-	kfree(nvram_types);
-	return rc;
-}
-
-int efx_mcdi_nvram_test_all(struct efx_nic *efx)
+int efx_siena_mcdi_nvram_test_all(struct efx_nic *efx)
 {
 	u32 nvram_types;
 	unsigned int type;
 	int rc;
 
-	rc = efx_mcdi_nvram_types(efx, &nvram_types);
+	rc = efx_siena_mcdi_nvram_types(efx, &nvram_types);
 	if (rc)
 		goto fail1;
 
@@ -1788,17 +1730,17 @@ static int efx_mcdi_read_assertion(struct efx_nic *efx)
 	retry = 2;
 	do {
 		MCDI_SET_DWORD(inbuf, GET_ASSERTS_IN_CLEAR, 1);
-		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_GET_ASSERTS,
-					inbuf, MC_CMD_GET_ASSERTS_IN_LEN,
-					outbuf, sizeof(outbuf), &outlen);
+		rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_GET_ASSERTS,
+					      inbuf, MC_CMD_GET_ASSERTS_IN_LEN,
+					      outbuf, sizeof(outbuf), &outlen);
 		if (rc == -EPERM)
 			return 0;
 	} while ((rc == -EINTR || rc == -EIO) && retry-- > 0);
 
 	if (rc) {
-		efx_mcdi_display_error(efx, MC_CMD_GET_ASSERTS,
-				       MC_CMD_GET_ASSERTS_IN_LEN, outbuf,
-				       outlen, rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_GET_ASSERTS,
+					     MC_CMD_GET_ASSERTS_IN_LEN, outbuf,
+					     outlen, rc);
 		return rc;
 	}
 	if (outlen < MC_CMD_GET_ASSERTS_OUT_LEN)
@@ -1847,17 +1789,17 @@ static int efx_mcdi_exit_assertion(struct efx_nic *efx)
 	BUILD_BUG_ON(MC_CMD_REBOOT_OUT_LEN != 0);
 	MCDI_SET_DWORD(inbuf, REBOOT_IN_FLAGS,
 		       MC_CMD_REBOOT_FLAGS_AFTER_ASSERTION);
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_REBOOT, inbuf, MC_CMD_REBOOT_IN_LEN,
-				NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_REBOOT, inbuf,
+				      MC_CMD_REBOOT_IN_LEN, NULL, 0, NULL);
 	if (rc == -EIO)
 		rc = 0;
 	if (rc)
-		efx_mcdi_display_error(efx, MC_CMD_REBOOT, MC_CMD_REBOOT_IN_LEN,
-				       NULL, 0, rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_REBOOT,
+					     MC_CMD_REBOOT_IN_LEN, NULL, 0, rc);
 	return rc;
 }
 
-int efx_mcdi_handle_assertion(struct efx_nic *efx)
+int efx_siena_mcdi_handle_assertion(struct efx_nic *efx)
 {
 	int rc;
 
@@ -1868,7 +1810,7 @@ int efx_mcdi_handle_assertion(struct efx_nic *efx)
 	return efx_mcdi_exit_assertion(efx);
 }
 
-int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
+int efx_siena_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_ID_LED_IN_LEN);
 
@@ -1880,7 +1822,8 @@ int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
 
 	MCDI_SET_DWORD(inbuf, SET_ID_LED_IN_STATE, mode);
 
-	return efx_mcdi_rpc(efx, MC_CMD_SET_ID_LED, inbuf, sizeof(inbuf), NULL, 0, NULL);
+	return efx_siena_mcdi_rpc(efx, MC_CMD_SET_ID_LED, inbuf, sizeof(inbuf),
+				  NULL, 0, NULL);
 }
 
 static int efx_mcdi_reset_func(struct efx_nic *efx)
@@ -1891,8 +1834,8 @@ static int efx_mcdi_reset_func(struct efx_nic *efx)
 	BUILD_BUG_ON(MC_CMD_ENTITY_RESET_OUT_LEN != 0);
 	MCDI_POPULATE_DWORD_1(inbuf, ENTITY_RESET_IN_FLAG,
 			      ENTITY_RESET_IN_FUNCTION_RESOURCE_RESET, 1);
-	rc = efx_mcdi_rpc(efx, MC_CMD_ENTITY_RESET, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_ENTITY_RESET, inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
 	return rc;
 }
 
@@ -1903,8 +1846,8 @@ static int efx_mcdi_reset_mc(struct efx_nic *efx)
 
 	BUILD_BUG_ON(MC_CMD_REBOOT_OUT_LEN != 0);
 	MCDI_SET_DWORD(inbuf, REBOOT_IN_FLAGS, 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_REBOOT, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_REBOOT, inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
 	/* White is black, and up is down */
 	if (rc == -EIO)
 		return 0;
@@ -1913,12 +1856,12 @@ static int efx_mcdi_reset_mc(struct efx_nic *efx)
 	return rc;
 }
 
-enum reset_type efx_mcdi_map_reset_reason(enum reset_type reason)
+enum reset_type efx_siena_mcdi_map_reset_reason(enum reset_type reason)
 {
 	return RESET_TYPE_RECOVER_OR_ALL;
 }
 
-int efx_mcdi_reset(struct efx_nic *efx, enum reset_type method)
+int efx_siena_mcdi_reset(struct efx_nic *efx, enum reset_type method)
 {
 	int rc;
 
@@ -1936,7 +1879,7 @@ int efx_mcdi_reset(struct efx_nic *efx, enum reset_type method)
 	}
 
 	/* Recover from a failed assertion pre-reset */
-	rc = efx_mcdi_handle_assertion(efx);
+	rc = efx_siena_mcdi_handle_assertion(efx);
 	if (rc)
 		return rc;
 
@@ -1961,8 +1904,8 @@ static int efx_mcdi_wol_filter_set(struct efx_nic *efx, u32 type,
 		       MC_CMD_FILTER_MODE_SIMPLE);
 	ether_addr_copy(MCDI_PTR(inbuf, WOL_FILTER_SET_IN_MAGIC_MAC), mac);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_WOL_FILTER_SET, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_WOL_FILTER_SET, inbuf,
+				sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 
@@ -1983,21 +1926,21 @@ static int efx_mcdi_wol_filter_set(struct efx_nic *efx, u32 type,
 }
 
 
-int
-efx_mcdi_wol_filter_set_magic(struct efx_nic *efx,  const u8 *mac, int *id_out)
+int efx_siena_mcdi_wol_filter_set_magic(struct efx_nic *efx,  const u8 *mac,
+					int *id_out)
 {
 	return efx_mcdi_wol_filter_set(efx, MC_CMD_WOL_TYPE_MAGIC, mac, id_out);
 }
 
 
-int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out)
+int efx_siena_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_WOL_FILTER_GET_OUT_LEN);
 	size_t outlen;
 	int rc;
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_WOL_FILTER_GET, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_WOL_FILTER_GET, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 
@@ -2017,19 +1960,19 @@ int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out)
 }
 
 
-int efx_mcdi_wol_filter_remove(struct efx_nic *efx, int id)
+int efx_siena_mcdi_wol_filter_remove(struct efx_nic *efx, int id)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_WOL_FILTER_REMOVE_IN_LEN);
 	int rc;
 
 	MCDI_SET_DWORD(inbuf, WOL_FILTER_REMOVE_IN_FILTER_ID, (u32)id);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_WOL_FILTER_REMOVE, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_WOL_FILTER_REMOVE, inbuf,
+				sizeof(inbuf), NULL, 0, NULL);
 	return rc;
 }
 
-int efx_mcdi_flush_rxqs(struct efx_nic *efx)
+int efx_siena_mcdi_flush_rxqs(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	struct efx_rx_queue *rx_queue;
@@ -2054,79 +1997,20 @@ int efx_mcdi_flush_rxqs(struct efx_nic *efx)
 		}
 	}
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_FLUSH_RX_QUEUES, inbuf,
-			  MC_CMD_FLUSH_RX_QUEUES_IN_LEN(count), NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_FLUSH_RX_QUEUES, inbuf,
+				MC_CMD_FLUSH_RX_QUEUES_IN_LEN(count),
+				NULL, 0, NULL);
 	WARN_ON(rc < 0);
 
 	return rc;
 }
 
-int efx_mcdi_wol_filter_reset(struct efx_nic *efx)
-{
-	int rc;
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_WOL_FILTER_RESET, NULL, 0, NULL, 0, NULL);
-	return rc;
-}
-
-int efx_mcdi_set_workaround(struct efx_nic *efx, u32 type, bool enabled,
-			    unsigned int *flags)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_WORKAROUND_IN_LEN);
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_WORKAROUND_EXT_OUT_LEN);
-	size_t outlen;
-	int rc;
-
-	BUILD_BUG_ON(MC_CMD_WORKAROUND_OUT_LEN != 0);
-	MCDI_SET_DWORD(inbuf, WORKAROUND_IN_TYPE, type);
-	MCDI_SET_DWORD(inbuf, WORKAROUND_IN_ENABLED, enabled);
-	rc = efx_mcdi_rpc(efx, MC_CMD_WORKAROUND, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		return rc;
-
-	if (!flags)
-		return 0;
-
-	if (outlen >= MC_CMD_WORKAROUND_EXT_OUT_LEN)
-		*flags = MCDI_DWORD(outbuf, WORKAROUND_EXT_OUT_FLAGS);
-	else
-		*flags = 0;
-
-	return 0;
-}
-
-int efx_mcdi_get_workarounds(struct efx_nic *efx, unsigned int *impl_out,
-			     unsigned int *enabled_out)
+int efx_siena_mcdi_wol_filter_reset(struct efx_nic *efx)
 {
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_WORKAROUNDS_OUT_LEN);
-	size_t outlen;
 	int rc;
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_WORKAROUNDS, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
-	if (rc)
-		goto fail;
-
-	if (outlen < MC_CMD_GET_WORKAROUNDS_OUT_LEN) {
-		rc = -EIO;
-		goto fail;
-	}
-
-	if (impl_out)
-		*impl_out = MCDI_DWORD(outbuf, GET_WORKAROUNDS_OUT_IMPLEMENTED);
-
-	if (enabled_out)
-		*enabled_out = MCDI_DWORD(outbuf, GET_WORKAROUNDS_OUT_ENABLED);
-
-	return 0;
-
-fail:
-	/* Older firmware lacks GET_WORKAROUNDS and this isn't especially
-	 * terrifying.  The call site will have to deal with it though.
-	 */
-	netif_cond_dbg(efx, hw, efx->net_dev, rc == -ENOSYS, err,
-		       "%s: failed rc=%d\n", __func__, rc);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_WOL_FILTER_RESET, NULL, 0,
+				NULL, 0, NULL);
 	return rc;
 }
 
@@ -2146,8 +2030,8 @@ static int efx_mcdi_nvram_update_start(struct efx_nic *efx, unsigned int type)
 
 	BUILD_BUG_ON(MC_CMD_NVRAM_UPDATE_START_OUT_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_UPDATE_START, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_UPDATE_START, inbuf,
+				sizeof(inbuf), NULL, 0, NULL);
 
 	return rc;
 }
@@ -2167,8 +2051,8 @@ static int efx_mcdi_nvram_read(struct efx_nic *efx, unsigned int type,
 	MCDI_SET_DWORD(inbuf, NVRAM_READ_IN_V2_MODE,
 		       MC_CMD_NVRAM_READ_IN_V2_DEFAULT);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_READ, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_READ, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
 
@@ -2190,9 +2074,9 @@ static int efx_mcdi_nvram_write(struct efx_nic *efx, unsigned int type,
 
 	BUILD_BUG_ON(MC_CMD_NVRAM_WRITE_OUT_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_WRITE, inbuf,
-			  ALIGN(MC_CMD_NVRAM_WRITE_IN_LEN(length), 4),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_WRITE, inbuf,
+				ALIGN(MC_CMD_NVRAM_WRITE_IN_LEN(length), 4),
+				NULL, 0, NULL);
 	return rc;
 }
 
@@ -2208,8 +2092,8 @@ static int efx_mcdi_nvram_erase(struct efx_nic *efx, unsigned int type,
 
 	BUILD_BUG_ON(MC_CMD_NVRAM_ERASE_OUT_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_ERASE, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_ERASE, inbuf, sizeof(inbuf),
+				NULL, 0, NULL);
 	return rc;
 }
 
@@ -2226,8 +2110,8 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
 			      NVRAM_UPDATE_FINISH_V2_IN_FLAG_REPORT_VERIFY_RESULT,
 			      1);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_NVRAM_UPDATE_FINISH, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_NVRAM_UPDATE_FINISH, inbuf,
+				sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
 	if (!rc && outlen >= MC_CMD_NVRAM_UPDATE_FINISH_V2_OUT_LEN) {
 		rc2 = MCDI_DWORD(outbuf, NVRAM_UPDATE_FINISH_V2_OUT_RESULT_CODE);
 		if (rc2 != MC_CMD_NVRAM_VERIFY_RC_SUCCESS)
@@ -2263,8 +2147,8 @@ static int efx_mcdi_nvram_update_finish(struct efx_nic *efx, unsigned int type)
 	return rc;
 }
 
-int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
-		      size_t len, size_t *retlen, u8 *buffer)
+int efx_siena_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
+			    size_t len, size_t *retlen, u8 *buffer)
 {
 	struct efx_mcdi_mtd_partition *part = to_efx_mcdi_mtd_partition(mtd);
 	struct efx_nic *efx = mtd->priv;
@@ -2287,7 +2171,7 @@ int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start,
 	return rc;
 }
 
-int efx_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len)
+int efx_siena_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len)
 {
 	struct efx_mcdi_mtd_partition *part = to_efx_mcdi_mtd_partition(mtd);
 	struct efx_nic *efx = mtd->priv;
@@ -2317,8 +2201,8 @@ int efx_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len)
 	return rc;
 }
 
-int efx_mcdi_mtd_write(struct mtd_info *mtd, loff_t start,
-		       size_t len, size_t *retlen, const u8 *buffer)
+int efx_siena_mcdi_mtd_write(struct mtd_info *mtd, loff_t start,
+			     size_t len, size_t *retlen, const u8 *buffer)
 {
 	struct efx_mcdi_mtd_partition *part = to_efx_mcdi_mtd_partition(mtd);
 	struct efx_nic *efx = mtd->priv;
@@ -2348,7 +2232,7 @@ int efx_mcdi_mtd_write(struct mtd_info *mtd, loff_t start,
 	return rc;
 }
 
-int efx_mcdi_mtd_sync(struct mtd_info *mtd)
+int efx_siena_mcdi_mtd_sync(struct mtd_info *mtd)
 {
 	struct efx_mcdi_mtd_partition *part = to_efx_mcdi_mtd_partition(mtd);
 	struct efx_nic *efx = mtd->priv;
@@ -2362,7 +2246,7 @@ int efx_mcdi_mtd_sync(struct mtd_info *mtd)
 	return rc;
 }
 
-void efx_mcdi_mtd_rename(struct efx_mtd_partition *part)
+void efx_siena_mcdi_mtd_rename(struct efx_mtd_partition *part)
 {
 	struct efx_mcdi_mtd_partition *mcdi_part =
 		container_of(part, struct efx_mcdi_mtd_partition, common);
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.h b/drivers/net/ethernet/sfc/siena/mcdi.h
index 69c2924a147c..dcebdbf956ce 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi.h
@@ -138,52 +138,54 @@ static inline struct efx_mcdi_mon *efx_mcdi_mon(struct efx_nic *efx)
 }
 #endif
 
-int efx_mcdi_init(struct efx_nic *efx);
-void efx_mcdi_detach(struct efx_nic *efx);
-void efx_mcdi_fini(struct efx_nic *efx);
+int efx_siena_mcdi_init(struct efx_nic *efx);
+void efx_siena_mcdi_detach(struct efx_nic *efx);
+void efx_siena_mcdi_fini(struct efx_nic *efx);
 
-int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd, const efx_dword_t *inbuf,
-		 size_t inlen, efx_dword_t *outbuf, size_t outlen,
-		 size_t *outlen_actual);
-int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
+int efx_siena_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
 		       const efx_dword_t *inbuf, size_t inlen,
 		       efx_dword_t *outbuf, size_t outlen,
 		       size_t *outlen_actual);
+int efx_siena_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
+			     const efx_dword_t *inbuf, size_t inlen,
+			     efx_dword_t *outbuf, size_t outlen,
+			     size_t *outlen_actual);
 
-int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
-		       const efx_dword_t *inbuf, size_t inlen);
-int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
-			efx_dword_t *outbuf, size_t outlen,
-			size_t *outlen_actual);
-int efx_mcdi_rpc_finish_quiet(struct efx_nic *efx, unsigned cmd,
-			      size_t inlen, efx_dword_t *outbuf,
-			      size_t outlen, size_t *outlen_actual);
+int efx_siena_mcdi_rpc_start(struct efx_nic *efx, unsigned int cmd,
+			     const efx_dword_t *inbuf, size_t inlen);
+int efx_siena_mcdi_rpc_finish(struct efx_nic *efx, unsigned int cmd,
+			      size_t inlen, efx_dword_t *outbuf, size_t outlen,
+			      size_t *outlen_actual);
+int efx_siena_mcdi_rpc_finish_quiet(struct efx_nic *efx, unsigned int cmd,
+				    size_t inlen, efx_dword_t *outbuf,
+				    size_t outlen, size_t *outlen_actual);
 
 typedef void efx_mcdi_async_completer(struct efx_nic *efx,
 				      unsigned long cookie, int rc,
 				      efx_dword_t *outbuf,
 				      size_t outlen_actual);
-int efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
-		       const efx_dword_t *inbuf, size_t inlen, size_t outlen,
-		       efx_mcdi_async_completer *complete,
-		       unsigned long cookie);
-int efx_mcdi_rpc_async_quiet(struct efx_nic *efx, unsigned int cmd,
+int efx_siena_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
 			     const efx_dword_t *inbuf, size_t inlen,
 			     size_t outlen,
 			     efx_mcdi_async_completer *complete,
 			     unsigned long cookie);
+int efx_siena_mcdi_rpc_async_quiet(struct efx_nic *efx, unsigned int cmd,
+				   const efx_dword_t *inbuf, size_t inlen,
+				   size_t outlen,
+				   efx_mcdi_async_completer *complete,
+				   unsigned long cookie);
 
-void efx_mcdi_display_error(struct efx_nic *efx, unsigned cmd,
-			    size_t inlen, efx_dword_t *outbuf,
-			    size_t outlen, int rc);
+void efx_siena_mcdi_display_error(struct efx_nic *efx, unsigned int cmd,
+				  size_t inlen, efx_dword_t *outbuf,
+				  size_t outlen, int rc);
 
-int efx_mcdi_poll_reboot(struct efx_nic *efx);
-void efx_mcdi_mode_poll(struct efx_nic *efx);
-void efx_mcdi_mode_event(struct efx_nic *efx);
-void efx_mcdi_flush_async(struct efx_nic *efx);
+int efx_siena_mcdi_poll_reboot(struct efx_nic *efx);
+void efx_siena_mcdi_mode_poll(struct efx_nic *efx);
+void efx_siena_mcdi_mode_event(struct efx_nic *efx);
+void efx_siena_mcdi_flush_async(struct efx_nic *efx);
 
-void efx_mcdi_process_event(struct efx_channel *channel, efx_qword_t *event);
-void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
+void efx_siena_mcdi_process_event(struct efx_channel *channel, efx_qword_t *event);
+void efx_siena_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 
 /* We expect that 16- and 32-bit fields in MCDI requests and responses
  * are appropriately aligned, but 64-bit fields are only
@@ -338,51 +340,47 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 			      MCDI_CAPABILITY(field), \
 			      MCDI_CAPABILITY_OFST(field))
 
-void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
-int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
-			   u16 *fw_subtype_list, u32 *capabilities);
-int efx_mcdi_log_ctrl(struct efx_nic *efx, bool evq, bool uart, u32 dest_evq);
-int efx_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out);
-int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
-			size_t *size_out, size_t *erase_size_out,
-			bool *protected_out);
-int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
-int efx_mcdi_nvram_test_all(struct efx_nic *efx);
-int efx_mcdi_handle_assertion(struct efx_nic *efx);
-int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
-int efx_mcdi_wol_filter_set_magic(struct efx_nic *efx, const u8 *mac,
-				  int *id_out);
-int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out);
-int efx_mcdi_wol_filter_remove(struct efx_nic *efx, int id);
-int efx_mcdi_wol_filter_reset(struct efx_nic *efx);
-int efx_mcdi_flush_rxqs(struct efx_nic *efx);
-void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
-void efx_mcdi_mac_start_stats(struct efx_nic *efx);
-void efx_mcdi_mac_stop_stats(struct efx_nic *efx);
-void efx_mcdi_mac_pull_stats(struct efx_nic *efx);
-enum reset_type efx_mcdi_map_reset_reason(enum reset_type reason);
-int efx_mcdi_reset(struct efx_nic *efx, enum reset_type method);
-int efx_mcdi_set_workaround(struct efx_nic *efx, u32 type, bool enabled,
-			    unsigned int *flags);
-int efx_mcdi_get_workarounds(struct efx_nic *efx, unsigned int *impl_out,
-			     unsigned int *enabled_out);
+void efx_siena_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
+int efx_siena_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
+				 u16 *fw_subtype_list, u32 *capabilities);
+int efx_siena_mcdi_log_ctrl(struct efx_nic *efx, bool evq, bool uart,
+			    u32 dest_evq);
+int efx_siena_mcdi_nvram_types(struct efx_nic *efx, u32 *nvram_types_out);
+int efx_siena_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
+			      size_t *size_out, size_t *erase_size_out,
+			      bool *protected_out);
+int efx_siena_mcdi_nvram_test_all(struct efx_nic *efx);
+int efx_siena_mcdi_handle_assertion(struct efx_nic *efx);
+int efx_siena_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
+int efx_siena_mcdi_wol_filter_set_magic(struct efx_nic *efx, const u8 *mac,
+					int *id_out);
+int efx_siena_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out);
+int efx_siena_mcdi_wol_filter_remove(struct efx_nic *efx, int id);
+int efx_siena_mcdi_wol_filter_reset(struct efx_nic *efx);
+int efx_siena_mcdi_flush_rxqs(struct efx_nic *efx);
+void efx_siena_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
+void efx_siena_mcdi_mac_start_stats(struct efx_nic *efx);
+void efx_siena_mcdi_mac_stop_stats(struct efx_nic *efx);
+void efx_siena_mcdi_mac_pull_stats(struct efx_nic *efx);
+enum reset_type efx_siena_mcdi_map_reset_reason(enum reset_type reason);
+int efx_siena_mcdi_reset(struct efx_nic *efx, enum reset_type method);
 
 #ifdef CONFIG_SFC_MCDI_MON
-int efx_mcdi_mon_probe(struct efx_nic *efx);
-void efx_mcdi_mon_remove(struct efx_nic *efx);
+int efx_siena_mcdi_mon_probe(struct efx_nic *efx);
+void efx_siena_mcdi_mon_remove(struct efx_nic *efx);
 #else
-static inline int efx_mcdi_mon_probe(struct efx_nic *efx) { return 0; }
-static inline void efx_mcdi_mon_remove(struct efx_nic *efx) {}
+static inline int efx_siena_mcdi_mon_probe(struct efx_nic *efx) { return 0; }
+static inline void efx_siena_mcdi_mon_remove(struct efx_nic *efx) {}
 #endif
 
 #ifdef CONFIG_SFC_MTD
-int efx_mcdi_mtd_read(struct mtd_info *mtd, loff_t start, size_t len,
-		      size_t *retlen, u8 *buffer);
-int efx_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len);
-int efx_mcdi_mtd_write(struct mtd_info *mtd, loff_t start, size_t len,
-		       size_t *retlen, const u8 *buffer);
-int efx_mcdi_mtd_sync(struct mtd_info *mtd);
-void efx_mcdi_mtd_rename(struct efx_mtd_partition *part);
+int efx_siena_mcdi_mtd_read(struct mtd_info *mtd, loff_t start, size_t len,
+			    size_t *retlen, u8 *buffer);
+int efx_siena_mcdi_mtd_erase(struct mtd_info *mtd, loff_t start, size_t len);
+int efx_siena_mcdi_mtd_write(struct mtd_info *mtd, loff_t start, size_t len,
+			     size_t *retlen, const u8 *buffer);
+int efx_siena_mcdi_mtd_sync(struct mtd_info *mtd);
+void efx_siena_mcdi_mtd_rename(struct efx_mtd_partition *part);
 #endif
 
 #endif /* EFX_MCDI_H */
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_mon.c b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
index 5954fcfee2b1..eb44d4140925 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_mon.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_mon.c
@@ -100,7 +100,7 @@ static const char *const sensor_status_names[] = {
 	[MC_CMD_SENSOR_STATE_NO_READING] = "No reading",
 };
 
-void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
+void efx_siena_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev)
 {
 	unsigned int type, state, value;
 	enum efx_hwmon_type hwmon_type = EFX_HWMON_UNKNOWN;
@@ -151,8 +151,8 @@ static int efx_mcdi_mon_update(struct efx_nic *efx)
 		       hwmon->dma_buf.dma_addr);
 	MCDI_SET_DWORD(inbuf, READ_SENSORS_EXT_IN_LENGTH, hwmon->dma_buf.len);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_READ_SENSORS,
-			  inbuf, sizeof(inbuf), NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_READ_SENSORS,
+				inbuf, sizeof(inbuf), NULL, 0, NULL);
 	if (rc == 0)
 		hwmon->last_update = jiffies;
 	return rc;
@@ -300,7 +300,7 @@ efx_mcdi_mon_add_attr(struct efx_nic *efx, const char *name,
 	hwmon->group.attrs[hwmon->n_attrs++] = &attr->dev_attr.attr;
 }
 
-int efx_mcdi_mon_probe(struct efx_nic *efx)
+int efx_siena_mcdi_mon_probe(struct efx_nic *efx)
 {
 	unsigned int n_temp = 0, n_cool = 0, n_in = 0, n_curr = 0, n_power = 0;
 	struct efx_mcdi_mon *hwmon = efx_mcdi_mon(efx);
@@ -318,8 +318,9 @@ int efx_mcdi_mon_probe(struct efx_nic *efx)
 	do {
 		MCDI_SET_DWORD(inbuf, SENSOR_INFO_EXT_IN_PAGE, page);
 
-		rc = efx_mcdi_rpc(efx, MC_CMD_SENSOR_INFO, inbuf, sizeof(inbuf),
-				  outbuf, sizeof(outbuf), &outlen);
+		rc = efx_siena_mcdi_rpc(efx, MC_CMD_SENSOR_INFO, inbuf,
+					sizeof(inbuf), outbuf, sizeof(outbuf),
+					&outlen);
 		if (rc)
 			return rc;
 		if (outlen < MC_CMD_SENSOR_INFO_OUT_LENMIN)
@@ -380,10 +381,10 @@ int efx_mcdi_mon_probe(struct efx_nic *efx)
 
 				MCDI_SET_DWORD(inbuf, SENSOR_INFO_EXT_IN_PAGE,
 					       page);
-				rc = efx_mcdi_rpc(efx, MC_CMD_SENSOR_INFO,
-						  inbuf, sizeof(inbuf),
-						  outbuf, sizeof(outbuf),
-						  &outlen);
+				rc = efx_siena_mcdi_rpc(efx, MC_CMD_SENSOR_INFO,
+							inbuf, sizeof(inbuf),
+							outbuf, sizeof(outbuf),
+							&outlen);
 				if (rc)
 					goto fail;
 				if (outlen < MC_CMD_SENSOR_INFO_OUT_LENMIN) {
@@ -513,11 +514,11 @@ int efx_mcdi_mon_probe(struct efx_nic *efx)
 	return 0;
 
 fail:
-	efx_mcdi_mon_remove(efx);
+	efx_siena_mcdi_mon_remove(efx);
 	return rc;
 }
 
-void efx_mcdi_mon_remove(struct efx_nic *efx)
+void efx_siena_mcdi_mon_remove(struct efx_nic *efx)
 {
 	struct efx_mcdi_mon *hwmon = efx_mcdi_mon(efx);
 
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port.c b/drivers/net/ethernet/sfc/siena/mcdi_port.c
index 94c6a345c0b1..93b8b2338f11 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port.c
@@ -31,8 +31,8 @@ static int efx_mcdi_mdio_read(struct net_device *net_dev,
 	MCDI_SET_DWORD(inbuf, MDIO_READ_IN_DEVAD, devad);
 	MCDI_SET_DWORD(inbuf, MDIO_READ_IN_ADDR, addr);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_MDIO_READ, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_MDIO_READ, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
 
@@ -58,8 +58,8 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	MCDI_SET_DWORD(inbuf, MDIO_WRITE_IN_ADDR, addr);
 	MCDI_SET_DWORD(inbuf, MDIO_WRITE_IN_VALUE, value);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_MDIO_WRITE, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_MDIO_WRITE, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
 
@@ -70,14 +70,7 @@ static int efx_mcdi_mdio_write(struct net_device *net_dev,
 	return 0;
 }
 
-u32 efx_mcdi_phy_get_caps(struct efx_nic *efx)
-{
-	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
-
-	return phy_data->supported_cap;
-}
-
-bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
+bool efx_siena_mcdi_mac_check_fault(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
 	size_t outlength;
@@ -85,15 +78,15 @@ bool efx_mcdi_mac_check_fault(struct efx_nic *efx)
 
 	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlength);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+				outbuf, sizeof(outbuf), &outlength);
 	if (rc)
 		return true;
 
 	return MCDI_DWORD(outbuf, GET_LINK_OUT_MAC_FAULT) != 0;
 }
 
-int efx_mcdi_port_probe(struct efx_nic *efx)
+int efx_siena_mcdi_port_probe(struct efx_nic *efx)
 {
 	int rc;
 
@@ -103,15 +96,15 @@ int efx_mcdi_port_probe(struct efx_nic *efx)
 	efx->mdio.mdio_write = efx_mcdi_mdio_write;
 
 	/* Fill out MDIO structure, loopback modes, and initial link state */
-	rc = efx_mcdi_phy_probe(efx);
+	rc = efx_siena_mcdi_phy_probe(efx);
 	if (rc != 0)
 		return rc;
 
-	return efx_mcdi_mac_init_stats(efx);
+	return efx_siena_mcdi_mac_init_stats(efx);
 }
 
-void efx_mcdi_port_remove(struct efx_nic *efx)
+void efx_siena_mcdi_port_remove(struct efx_nic *efx)
 {
-	efx_mcdi_phy_remove(efx);
-	efx_mcdi_mac_fini_stats(efx);
+	efx_siena_mcdi_phy_remove(efx);
+	efx_siena_mcdi_mac_fini_stats(efx);
 }
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port.h b/drivers/net/ethernet/sfc/siena/mcdi_port.h
index 07863ddbe740..7b4ae250b51f 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port.h
@@ -10,9 +10,8 @@
 
 #include "net_driver.h"
 
-u32 efx_mcdi_phy_get_caps(struct efx_nic *efx);
-bool efx_mcdi_mac_check_fault(struct efx_nic *efx);
-int efx_mcdi_port_probe(struct efx_nic *efx);
-void efx_mcdi_port_remove(struct efx_nic *efx);
+bool efx_siena_mcdi_mac_check_fault(struct efx_nic *efx);
+int efx_siena_mcdi_port_probe(struct efx_nic *efx);
+void efx_siena_mcdi_port_remove(struct efx_nic *efx);
 
 #endif /* EFX_MCDI_PORT_H */
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
index 57908045fb15..a842c139d76f 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
@@ -12,7 +12,8 @@
 #include "efx_common.h"
 #include "nic.h"
 
-int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
+static int efx_mcdi_get_phy_cfg(struct efx_nic *efx,
+				struct efx_mcdi_phy_data *cfg)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_CFG_OUT_LEN);
 	size_t outlen;
@@ -21,8 +22,8 @@ int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_IN_LEN != 0);
 	BUILD_BUG_ON(MC_CMD_GET_PHY_CFG_OUT_NAME_LEN != sizeof(cfg->name));
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_CFG, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_PHY_CFG, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 
@@ -52,8 +53,8 @@ int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg)
 	return rc;
 }
 
-void efx_link_set_advertising(struct efx_nic *efx,
-			      const unsigned long *advertising)
+void efx_siena_link_set_advertising(struct efx_nic *efx,
+				    const unsigned long *advertising)
 {
 	memcpy(efx->link_advertising, advertising,
 	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
@@ -67,8 +68,8 @@ void efx_link_set_advertising(struct efx_nic *efx,
 		efx->wanted_fc ^= EFX_FC_TX;
 }
 
-int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
-		      u32 flags, u32 loopback_mode, u32 loopback_speed)
+static int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
+			     u32 flags, u32 loopback_mode, u32 loopback_speed)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_LINK_IN_LEN);
 
@@ -79,18 +80,18 @@ int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
 	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_MODE, loopback_mode);
 	MCDI_SET_DWORD(inbuf, SET_LINK_IN_LOOPBACK_SPEED, loopback_speed);
 
-	return efx_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	return efx_siena_mcdi_rpc(efx, MC_CMD_SET_LINK, inbuf, sizeof(inbuf),
+				  NULL, 0, NULL);
 }
 
-int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
+static int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
 	size_t outlen;
 	int rc;
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LOOPBACK_MODES, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LOOPBACK_MODES, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		goto fail;
 
@@ -109,7 +110,7 @@ int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
 	return rc;
 }
 
-void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
+static void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 {
 	#define SET_BIT(name)	__set_bit(ETHTOOL_LINK_MODE_ ## name ## _BIT, \
 					  linkset)
@@ -184,7 +185,7 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
 	#undef SET_BIT
 }
 
-u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
+static u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 {
 	u32 result = 0;
 
@@ -229,7 +230,7 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
 	return result;
 }
 
-u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
+static u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	enum efx_phy_mode mode, supported;
@@ -257,7 +258,7 @@ u32 efx_get_mcdi_phy_flags(struct efx_nic *efx)
 	return flags;
 }
 
-u8 mcdi_to_ethtool_media(u32 media)
+static u8 mcdi_to_ethtool_media(u32 media)
 {
 	switch (media) {
 	case MC_CMD_MEDIA_XAUI:
@@ -278,9 +279,9 @@ u8 mcdi_to_ethtool_media(u32 media)
 	}
 }
 
-void efx_mcdi_phy_decode_link(struct efx_nic *efx,
-			      struct efx_link_state *link_state,
-			      u32 speed, u32 flags, u32 fcntl)
+static void efx_mcdi_phy_decode_link(struct efx_nic *efx,
+				     struct efx_link_state *link_state,
+				     u32 speed, u32 flags, u32 fcntl)
 {
 	switch (fcntl) {
 	case MC_CMD_FCNTL_AUTO:
@@ -321,7 +322,7 @@ void efx_mcdi_phy_decode_link(struct efx_nic *efx,
  * Both RS and BASER (whether AUTO or not) means use FEC if cable and link
  * partner support it, preferring RS to BASER.
  */
-u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap)
+static u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap)
 {
 	u32 ret = 0;
 
@@ -352,7 +353,7 @@ u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap)
  * maps both of those to AUTO.  This should never matter, and it's not clear
  * what a better mapping would be anyway.
  */
-u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
+static u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
 {
 	bool rs = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_LBN),
 	     rs_req = caps & (1 << MC_CMD_PHY_CAP_RS_FEC_REQUESTED_LBN),
@@ -371,7 +372,7 @@ u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g)
 /* Verify that the forced flow control settings (!EFX_FC_AUTO) are
  * supported by the link partner. Warn the user if this isn't the case
  */
-void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
+static void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 rmtadv;
@@ -397,7 +398,7 @@ void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa)
 			  "warning: link partner doesn't support pause frames");
 }
 
-bool efx_mcdi_phy_poll(struct efx_nic *efx)
+bool efx_siena_mcdi_phy_poll(struct efx_nic *efx)
 {
 	struct efx_link_state old_state = efx->link_state;
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
@@ -407,8 +408,8 @@ bool efx_mcdi_phy_poll(struct efx_nic *efx)
 
 	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		efx->link_state.up = false;
 	else
@@ -421,7 +422,7 @@ bool efx_mcdi_phy_poll(struct efx_nic *efx)
 	return !efx_link_state_equal(&efx->link_state, &old_state);
 }
 
-int efx_mcdi_phy_probe(struct efx_nic *efx)
+int efx_siena_mcdi_phy_probe(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data;
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
@@ -439,8 +440,8 @@ int efx_mcdi_phy_probe(struct efx_nic *efx)
 
 	/* Read initial link advertisement */
 	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		goto fail;
 
@@ -527,7 +528,7 @@ int efx_mcdi_phy_probe(struct efx_nic *efx)
 	return rc;
 }
 
-void efx_mcdi_phy_remove(struct efx_nic *efx)
+void efx_siena_mcdi_phy_remove(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data = efx->phy_data;
 
@@ -535,7 +536,8 @@ void efx_mcdi_phy_remove(struct efx_nic *efx)
 	kfree(phy_data);
 }
 
-void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ksettings *cmd)
+void efx_siena_mcdi_phy_get_link_ksettings(struct efx_nic *efx,
+					   struct ethtool_link_ksettings *cmd)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
@@ -555,8 +557,8 @@ void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ks
 	       sizeof(__ETHTOOL_DECLARE_LINK_MODE_MASK()));
 
 	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		return;
 	mcdi_to_ethtool_linkset(phy_cfg->media,
@@ -564,7 +566,9 @@ void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ks
 				cmd->link_modes.lp_advertising);
 }
 
-int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_link_ksettings *cmd)
+int
+efx_siena_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
+				      const struct ethtool_link_ksettings *cmd)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 caps;
@@ -602,7 +606,7 @@ int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_li
 		return rc;
 
 	if (cmd->base.autoneg) {
-		efx_link_set_advertising(efx, cmd->link_modes.advertising);
+		efx_siena_link_set_advertising(efx, cmd->link_modes.advertising);
 		phy_cfg->forced_cap = 0;
 	} else {
 		efx_siena_link_clear_advertising(efx);
@@ -611,7 +615,8 @@ int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_li
 	return 0;
 }
 
-int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
+int efx_siena_mcdi_phy_get_fecparam(struct efx_nic *efx,
+				    struct ethtool_fecparam *fec)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_V2_LEN);
 	u32 caps, active, speed; /* MCDI format */
@@ -620,8 +625,8 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 	int rc;
 
 	BUILD_BUG_ON(MC_CMD_GET_LINK_IN_LEN != 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_LINK, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
 	if (outlen < MC_CMD_GET_LINK_OUT_V2_LEN)
@@ -676,7 +681,8 @@ static int ethtool_fec_supported(u32 supported_cap, u32 ethtool_cap)
 	return 0;
 }
 
-int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec)
+int efx_siena_mcdi_phy_set_fecparam(struct efx_nic *efx,
+				    const struct ethtool_fecparam *fec)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 caps;
@@ -686,7 +692,7 @@ int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam
 	if (rc)
 		return rc;
 
-	/* Work out what efx_mcdi_phy_set_link_ksettings() would produce from
+	/* Work out what efx_siena_mcdi_phy_set_link_ksettings() would produce from
 	 * saved advertising bits
 	 */
 	if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, efx->link_advertising))
@@ -706,7 +712,7 @@ int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam
 	return 0;
 }
 
-int efx_mcdi_phy_test_alive(struct efx_nic *efx)
+int efx_siena_mcdi_phy_test_alive(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_STATE_OUT_LEN);
 	size_t outlen;
@@ -714,8 +720,8 @@ int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 
 	BUILD_BUG_ON(MC_CMD_GET_PHY_STATE_IN_LEN != 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PHY_STATE, NULL, 0,
-			  outbuf, sizeof(outbuf), &outlen);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_PHY_STATE, NULL, 0,
+				outbuf, sizeof(outbuf), &outlen);
 	if (rc)
 		return rc;
 
@@ -727,7 +733,7 @@ int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 	return 0;
 }
 
-int efx_mcdi_port_reconfigure(struct efx_nic *efx)
+int efx_siena_mcdi_port_reconfigure(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 caps = (efx->link_advertising[0] ?
@@ -764,16 +770,16 @@ static int efx_mcdi_bist(struct efx_nic *efx, unsigned int bist_mode,
 
 	BUILD_BUG_ON(MC_CMD_START_BIST_OUT_LEN != 0);
 	MCDI_SET_DWORD(inbuf, START_BIST_IN_TYPE, bist_mode);
-	rc = efx_mcdi_rpc(efx, MC_CMD_START_BIST,
-			  inbuf, MC_CMD_START_BIST_IN_LEN, NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_START_BIST, inbuf,
+				MC_CMD_START_BIST_IN_LEN, NULL, 0, NULL);
 	if (rc)
 		goto out;
 
 	/* Wait up to 10s for BIST to finish */
 	for (retry = 0; retry < 100; ++retry) {
 		BUILD_BUG_ON(MC_CMD_POLL_BIST_IN_LEN != 0);
-		rc = efx_mcdi_rpc(efx, MC_CMD_POLL_BIST, NULL, 0,
-				  outbuf, sizeof(outbuf), &outlen);
+		rc = efx_siena_mcdi_rpc(efx, MC_CMD_POLL_BIST, NULL, 0,
+					outbuf, sizeof(outbuf), &outlen);
 		if (rc)
 			goto out;
 
@@ -811,7 +817,8 @@ static int efx_mcdi_bist(struct efx_nic *efx, unsigned int bist_mode,
 	return rc;
 }
 
-int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned int flags)
+int efx_siena_mcdi_phy_run_tests(struct efx_nic *efx, int *results,
+				 unsigned int flags)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 mode;
@@ -850,7 +857,8 @@ int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned int flags
 	return 0;
 }
 
-const char *efx_mcdi_phy_test_name(struct efx_nic *efx, unsigned int index)
+const char *efx_siena_mcdi_phy_test_name(struct efx_nic *efx,
+					 unsigned int index)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 
@@ -913,10 +921,10 @@ static int efx_mcdi_phy_get_module_eeprom_page(struct efx_nic *efx,
 	to_copy = min(space, SFP_PAGE_SIZE - offset);
 
 	MCDI_SET_DWORD(inbuf, GET_PHY_MEDIA_INFO_IN_PAGE, page);
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_GET_PHY_MEDIA_INFO,
-				inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf),
-				&outlen);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_GET_PHY_MEDIA_INFO,
+				      inbuf, sizeof(inbuf),
+				      outbuf, sizeof(outbuf),
+				      &outlen);
 
 	if (rc)
 		return rc;
@@ -984,7 +992,8 @@ static u32 efx_mcdi_phy_module_type(struct efx_nic *efx)
 	}
 }
 
-int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *ee, u8 *data)
+int efx_siena_mcdi_phy_get_module_eeprom(struct efx_nic *efx,
+					 struct ethtool_eeprom *ee, u8 *data)
 {
 	int rc;
 	ssize_t space_remaining = ee->len;
@@ -1045,7 +1054,7 @@ int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *e
 	return 0;
 }
 
-int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo)
+int efx_siena_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo)
 {
 	int sff_8472_level;
 	int diag_type;
@@ -1090,7 +1099,7 @@ static unsigned int efx_calc_mac_mtu(struct efx_nic *efx)
 	return EFX_MAX_FRAME_LEN(efx->net_dev->mtu);
 }
 
-int efx_mcdi_set_mac(struct efx_nic *efx)
+int efx_siena_mcdi_set_mac(struct efx_nic *efx)
 {
 	u32 fcntl;
 	MCDI_DECLARE_BUF(cmdbytes, MC_CMD_SET_MAC_IN_LEN);
@@ -1130,23 +1139,8 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_SET_DWORD(cmdbytes, SET_MAC_IN_FCNTL, fcntl);
 
-	return efx_mcdi_rpc(efx, MC_CMD_SET_MAC, cmdbytes, sizeof(cmdbytes),
-			    NULL, 0, NULL);
-}
-
-int efx_mcdi_set_mtu(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MAC_EXT_IN_LEN);
-
-	BUILD_BUG_ON(MC_CMD_SET_MAC_OUT_LEN != 0);
-
-	MCDI_SET_DWORD(inbuf, SET_MAC_EXT_IN_MTU, efx_calc_mac_mtu(efx));
-
-	MCDI_POPULATE_DWORD_1(inbuf, SET_MAC_EXT_IN_CONTROL,
-			      SET_MAC_EXT_IN_CFG_MTU, 1);
-
-	return efx_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
-			    NULL, 0, NULL);
+	return efx_siena_mcdi_rpc(efx, MC_CMD_SET_MAC, cmdbytes,
+				  sizeof(cmdbytes), NULL, 0, NULL);
 }
 
 enum efx_stats_action {
@@ -1183,16 +1177,16 @@ static int efx_mcdi_mac_stats(struct efx_nic *efx,
 	if (efx_nic_rev(efx) >= EFX_REV_HUNT_A0)
 		MCDI_SET_DWORD(inbuf, MAC_STATS_IN_PORT_ID, efx->vport_id);
 
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_MAC_STATS, inbuf, sizeof(inbuf),
-				NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_MAC_STATS, inbuf,
+				      sizeof(inbuf), NULL, 0, NULL);
 	/* Expect ENOENT if DMA queues have not been set up */
 	if (rc && (rc != -ENOENT || atomic_read(&efx->active_queues)))
-		efx_mcdi_display_error(efx, MC_CMD_MAC_STATS, sizeof(inbuf),
-				       NULL, 0, rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_MAC_STATS,
+					     sizeof(inbuf), NULL, 0, rc);
 	return rc;
 }
 
-void efx_mcdi_mac_start_stats(struct efx_nic *efx)
+void efx_siena_mcdi_mac_start_stats(struct efx_nic *efx)
 {
 	__le64 *dma_stats = efx->stats_buffer.addr;
 
@@ -1201,7 +1195,7 @@ void efx_mcdi_mac_start_stats(struct efx_nic *efx)
 	efx_mcdi_mac_stats(efx, EFX_STATS_ENABLE, 0);
 }
 
-void efx_mcdi_mac_stop_stats(struct efx_nic *efx)
+void efx_siena_mcdi_mac_stop_stats(struct efx_nic *efx)
 {
 	efx_mcdi_mac_stats(efx, EFX_STATS_DISABLE, 0);
 }
@@ -1209,7 +1203,7 @@ void efx_mcdi_mac_stop_stats(struct efx_nic *efx)
 #define EFX_MAC_STATS_WAIT_US 100
 #define EFX_MAC_STATS_WAIT_ATTEMPTS 10
 
-void efx_mcdi_mac_pull_stats(struct efx_nic *efx)
+void efx_siena_mcdi_mac_pull_stats(struct efx_nic *efx)
 {
 	__le64 *dma_stats = efx->stats_buffer.addr;
 	int attempts = EFX_MAC_STATS_WAIT_ATTEMPTS;
@@ -1223,7 +1217,7 @@ void efx_mcdi_mac_pull_stats(struct efx_nic *efx)
 		udelay(EFX_MAC_STATS_WAIT_US);
 }
 
-int efx_mcdi_mac_init_stats(struct efx_nic *efx)
+int efx_siena_mcdi_mac_init_stats(struct efx_nic *efx)
 {
 	int rc;
 
@@ -1248,25 +1242,11 @@ int efx_mcdi_mac_init_stats(struct efx_nic *efx)
 	return 0;
 }
 
-void efx_mcdi_mac_fini_stats(struct efx_nic *efx)
+void efx_siena_mcdi_mac_fini_stats(struct efx_nic *efx)
 {
 	efx_nic_free_buffer(efx, &efx->stats_buffer);
 }
 
-/* Get physical port number (EF10 only; on Siena it is same as PF number) */
-int efx_mcdi_port_get_number(struct efx_nic *efx)
-{
-	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PORT_ASSIGNMENT_OUT_LEN);
-	int rc;
-
-	rc = efx_mcdi_rpc(efx, MC_CMD_GET_PORT_ASSIGNMENT, NULL, 0,
-			  outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		return rc;
-
-	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
-}
-
 static unsigned int efx_mcdi_event_link_speed[] = {
 	[MCDI_EVENT_LINKCHANGE_SPEED_100M] = 100,
 	[MCDI_EVENT_LINKCHANGE_SPEED_1G] = 1000,
@@ -1277,7 +1257,7 @@ static unsigned int efx_mcdi_event_link_speed[] = {
 	[MCDI_EVENT_LINKCHANGE_SPEED_100G] = 100000,
 };
 
-void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
+void efx_siena_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev)
 {
 	u32 flags, fcntl, speed, lpa;
 
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.h b/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
index ed31690e591c..7a6de13d9ce6 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
@@ -28,40 +28,31 @@ struct efx_mcdi_phy_data {
 	u32 forced_cap;
 };
 
-int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg);
-void efx_link_set_advertising(struct efx_nic *efx,
-			      const unsigned long *advertising);
-int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
-		      u32 flags, u32 loopback_mode, u32 loopback_speed);
-int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes);
-void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset);
-u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset);
-u32 efx_get_mcdi_phy_flags(struct efx_nic *efx);
-u8 mcdi_to_ethtool_media(u32 media);
-void efx_mcdi_phy_decode_link(struct efx_nic *efx,
-			      struct efx_link_state *link_state,
-			      u32 speed, u32 flags, u32 fcntl);
-u32 ethtool_fec_caps_to_mcdi(u32 supported_cap, u32 ethtool_cap);
-u32 mcdi_fec_caps_to_ethtool(u32 caps, bool is_25g);
-void efx_mcdi_phy_check_fcntl(struct efx_nic *efx, u32 lpa);
-bool efx_mcdi_phy_poll(struct efx_nic *efx);
-int efx_mcdi_phy_probe(struct efx_nic *efx);
-void efx_mcdi_phy_remove(struct efx_nic *efx);
-void efx_mcdi_phy_get_link_ksettings(struct efx_nic *efx, struct ethtool_link_ksettings *cmd);
-int efx_mcdi_phy_set_link_ksettings(struct efx_nic *efx, const struct ethtool_link_ksettings *cmd);
-int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec);
-int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec);
-int efx_mcdi_phy_test_alive(struct efx_nic *efx);
-int efx_mcdi_port_reconfigure(struct efx_nic *efx);
-int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned int flags);
-const char *efx_mcdi_phy_test_name(struct efx_nic *efx, unsigned int index);
-int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *ee, u8 *data);
-int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo);
-int efx_mcdi_set_mac(struct efx_nic *efx);
-int efx_mcdi_set_mtu(struct efx_nic *efx);
-int efx_mcdi_mac_init_stats(struct efx_nic *efx);
-void efx_mcdi_mac_fini_stats(struct efx_nic *efx);
-int efx_mcdi_port_get_number(struct efx_nic *efx);
-void efx_mcdi_process_link_change(struct efx_nic *efx, efx_qword_t *ev);
+void efx_siena_link_set_advertising(struct efx_nic *efx,
+				    const unsigned long *advertising);
+bool efx_siena_mcdi_phy_poll(struct efx_nic *efx);
+int efx_siena_mcdi_phy_probe(struct efx_nic *efx);
+void efx_siena_mcdi_phy_remove(struct efx_nic *efx);
+void efx_siena_mcdi_phy_get_link_ksettings(struct efx_nic *efx,
+					   struct ethtool_link_ksettings *cmd);
+int efx_siena_mcdi_phy_set_link_ksettings(struct efx_nic *efx,
+					  const struct ethtool_link_ksettings *cmd);
+int efx_siena_mcdi_phy_get_fecparam(struct efx_nic *efx,
+				    struct ethtool_fecparam *fec);
+int efx_siena_mcdi_phy_set_fecparam(struct efx_nic *efx,
+				    const struct ethtool_fecparam *fec);
+int efx_siena_mcdi_phy_test_alive(struct efx_nic *efx);
+int efx_siena_mcdi_port_reconfigure(struct efx_nic *efx);
+int efx_siena_mcdi_phy_run_tests(struct efx_nic *efx, int *results,
+				 unsigned int flags);
+const char *efx_siena_mcdi_phy_test_name(struct efx_nic *efx,
+					 unsigned int index);
+int efx_siena_mcdi_phy_get_module_eeprom(struct efx_nic *efx,
+					 struct ethtool_eeprom *ee, u8 *data);
+int efx_siena_mcdi_phy_get_module_info(struct efx_nic *efx,
+				       struct ethtool_modinfo *modinfo);
+int efx_siena_mcdi_set_mac(struct efx_nic *efx);
+int efx_siena_mcdi_mac_init_stats(struct efx_nic *efx);
+void efx_siena_mcdi_mac_fini_stats(struct efx_nic *efx);
 
 #endif
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index b67417063a80..5b4717520c3e 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -426,8 +426,8 @@ size_t efx_siena_ptp_update_stats(struct efx_nic *efx, u64 *stats)
 	 */
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_STATUS);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), NULL);
 	if (rc)
 		memset(outbuf, 0, sizeof(outbuf));
 	efx_nic_update_stats(efx_ptp_stat_desc, PTP_STAT_COUNT,
@@ -641,8 +641,8 @@ static int efx_ptp_get_attributes(struct efx_nic *efx)
 	 */
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_GET_ATTRIBUTES);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf), &out_len);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				      outbuf, sizeof(outbuf), &out_len);
 	if (rc == 0) {
 		fmt = MCDI_DWORD(outbuf, PTP_OUT_GET_ATTRIBUTES_TIME_FORMAT);
 	} else if (rc == -EINVAL) {
@@ -651,8 +651,8 @@ static int efx_ptp_get_attributes(struct efx_nic *efx)
 		pci_info(efx->pci_dev, "no PTP support\n");
 		return rc;
 	} else {
-		efx_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
-				       outbuf, sizeof(outbuf), rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
+					     outbuf, sizeof(outbuf), rc);
 		return rc;
 	}
 
@@ -739,8 +739,8 @@ static int efx_ptp_get_timestamp_corrections(struct efx_nic *efx)
 		       MC_CMD_PTP_OP_GET_TIMESTAMP_CORRECTIONS);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
 
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf), &out_len);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				      outbuf, sizeof(outbuf), &out_len);
 	if (rc == 0) {
 		efx->ptp_data->ts_corrections.ptp_tx = MCDI_DWORD(outbuf,
 			PTP_OUT_GET_TIMESTAMP_CORRECTIONS_TRANSMIT);
@@ -772,8 +772,8 @@ static int efx_ptp_get_timestamp_corrections(struct efx_nic *efx)
 		efx->ptp_data->ts_corrections.general_tx = 0;
 		efx->ptp_data->ts_corrections.general_rx = 0;
 	} else {
-		efx_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf), outbuf,
-				       sizeof(outbuf), rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_PTP, sizeof(inbuf),
+					     outbuf, sizeof(outbuf), rc);
 		return rc;
 	}
 
@@ -794,13 +794,13 @@ static int efx_ptp_enable(struct efx_nic *efx)
 		       efx->ptp_data->channel->channel : 0);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ENABLE_MODE, efx->ptp_data->mode);
 
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				      outbuf, sizeof(outbuf), NULL);
 	rc = (rc == -EALREADY) ? 0 : rc;
 	if (rc)
-		efx_mcdi_display_error(efx, MC_CMD_PTP,
-				       MC_CMD_PTP_IN_ENABLE_LEN,
-				       outbuf, sizeof(outbuf), rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_PTP,
+					     MC_CMD_PTP_IN_ENABLE_LEN,
+					     outbuf, sizeof(outbuf), rc);
 	return rc;
 }
 
@@ -817,8 +817,8 @@ static int efx_ptp_disable(struct efx_nic *efx)
 
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_DISABLE);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-				outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				      outbuf, sizeof(outbuf), NULL);
 	rc = (rc == -EALREADY) ? 0 : rc;
 	/* If we get ENOSYS, the NIC doesn't support PTP, and thus this function
 	 * should only have been called during probe.
@@ -826,9 +826,9 @@ static int efx_ptp_disable(struct efx_nic *efx)
 	if (rc == -ENOSYS || rc == -EPERM)
 		pci_info(efx->pci_dev, "no PTP support\n");
 	else if (rc)
-		efx_mcdi_display_error(efx, MC_CMD_PTP,
-				       MC_CMD_PTP_IN_DISABLE_LEN,
-				       outbuf, sizeof(outbuf), rc);
+		efx_siena_mcdi_display_error(efx, MC_CMD_PTP,
+					     MC_CMD_PTP_IN_DISABLE_LEN,
+					     outbuf, sizeof(outbuf), rc);
 	return rc;
 }
 
@@ -1042,8 +1042,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 
 	/* Clear flag that signals MC ready */
 	WRITE_ONCE(*start, 0);
-	rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
-				MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
+	rc = efx_siena_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
+				      MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
 	EFX_WARN_ON_ONCE_PARANOID(rc);
 
 	/* Wait for start from MCDI (or timeout) */
@@ -1062,10 +1062,10 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 		efx_ptp_send_times(efx, &last_time);
 
 	/* Collect results */
-	rc = efx_mcdi_rpc_finish(efx, MC_CMD_PTP,
-				 MC_CMD_PTP_IN_SYNCHRONIZE_LEN,
-				 synch_buf, sizeof(synch_buf),
-				 &response_length);
+	rc = efx_siena_mcdi_rpc_finish(efx, MC_CMD_PTP,
+				       MC_CMD_PTP_IN_SYNCHRONIZE_LEN,
+				       synch_buf, sizeof(synch_buf),
+				       &response_length);
 	if (rc == 0) {
 		rc = efx_ptp_process_times(efx, synch_buf, response_length,
 					   &last_time);
@@ -1127,9 +1127,9 @@ static void efx_ptp_xmit_skb_mc(struct efx_nic *efx, struct sk_buff *skb)
 				  MCDI_PTR(ptp_data->txbuf,
 					   PTP_IN_TRANSMIT_PACKET),
 				  skb->len);
-	rc = efx_mcdi_rpc(efx, MC_CMD_PTP,
-			  ptp_data->txbuf, MC_CMD_PTP_IN_TRANSMIT_LEN(skb->len),
-			  txtime, sizeof(txtime), &len);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_PTP, ptp_data->txbuf,
+				MC_CMD_PTP_IN_TRANSMIT_LEN(skb->len), txtime,
+				sizeof(txtime), &len);
 	if (rc != 0)
 		goto fail;
 
@@ -2068,8 +2068,8 @@ static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	MCDI_SET_QWORD(inadj, PTP_IN_ADJUST_FREQ, adjustment_ns);
 	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_SECONDS, 0);
 	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_NANOSECONDS, 0);
-	rc = efx_mcdi_rpc(efx, MC_CMD_PTP, inadj, sizeof(inadj),
-			  NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_PTP, inadj, sizeof(inadj),
+				NULL, 0, NULL);
 	if (rc != 0)
 		return rc;
 
@@ -2093,8 +2093,8 @@ static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	MCDI_SET_QWORD(inbuf, PTP_IN_ADJUST_FREQ, ptp_data->current_adjfreq);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_MAJOR, nic_major);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_MINOR, nic_minor);
-	return efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-			    NULL, 0, NULL);
+	return efx_siena_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				  NULL, 0, NULL);
 }
 
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
@@ -2111,8 +2111,8 @@ static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_READ_NIC_TIME);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-			  outbuf, sizeof(outbuf), NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
+				outbuf, sizeof(outbuf), NULL);
 	if (rc != 0)
 		return rc;
 
diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
index 83bd27df30d4..2d70b3356ddf 100644
--- a/drivers/net/ethernet/sfc/siena/selftest.c
+++ b/drivers/net/ethernet/sfc/siena/selftest.c
@@ -100,7 +100,7 @@ static int efx_test_phy_alive(struct efx_nic *efx, struct efx_self_tests *tests)
 {
 	int rc = 0;
 
-	rc = efx_mcdi_phy_test_alive(efx);
+	rc = efx_siena_mcdi_phy_test_alive(efx);
 	tests->phy_alive = rc ? -1 : 1;
 
 	return rc;
@@ -257,7 +257,7 @@ static int efx_test_phy(struct efx_nic *efx, struct efx_self_tests *tests,
 	int rc;
 
 	mutex_lock(&efx->mac_lock);
-	rc = efx_mcdi_phy_run_tests(efx, tests->phy_ext, flags);
+	rc = efx_siena_mcdi_phy_run_tests(efx, tests->phy_ext, flags);
 	mutex_unlock(&efx->mac_lock);
 	if (rc == -EPERM)
 		rc = 0;
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index d70e481d0c73..74ed8e972c93 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -59,13 +59,13 @@ static void siena_push_irq_moderation(struct efx_channel *channel)
 void efx_siena_prepare_flush(struct efx_nic *efx)
 {
 	if (efx->fc_disable++ == 0)
-		efx_mcdi_set_mac(efx);
+		efx_siena_mcdi_set_mac(efx);
 }
 
 void siena_finish_flush(struct efx_nic *efx)
 {
 	if (--efx->fc_disable == 0)
-		efx_mcdi_set_mac(efx);
+		efx_siena_mcdi_set_mac(efx);
 }
 
 static const struct efx_farch_register_test siena_register_tests[] = {
@@ -107,7 +107,7 @@ static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 	/* Reset the chip immediately so that it is completely
 	 * quiescent regardless of what any VF driver does.
 	 */
-	rc = efx_mcdi_reset(efx, reset_method);
+	rc = efx_siena_mcdi_reset(efx, reset_method);
 	if (rc)
 		goto out;
 
@@ -116,7 +116,7 @@ static int siena_test_chip(struct efx_nic *efx, struct efx_self_tests *tests)
 					 ARRAY_SIZE(siena_register_tests))
 		? -1 : 1;
 
-	rc = efx_mcdi_reset(efx, reset_method);
+	rc = efx_siena_mcdi_reset(efx, reset_method);
 out:
 	rc2 = efx_siena_reset_up(efx, reset_method, rc == 0);
 	return rc ? rc : rc2;
@@ -223,7 +223,8 @@ static int siena_probe_nvconfig(struct efx_nic *efx)
 	u32 caps = 0;
 	int rc;
 
-	rc = efx_mcdi_get_board_cfg(efx, efx->net_dev->perm_addr, NULL, &caps);
+	rc = efx_siena_mcdi_get_board_cfg(efx, efx->net_dev->perm_addr, NULL,
+					  &caps);
 
 	efx->timer_quantum_ns =
 		(caps & (1 << MC_CMD_CAPABILITIES_TURBO_ACTIVE_LBN)) ?
@@ -286,12 +287,12 @@ static int siena_probe_nic(struct efx_nic *efx)
 	efx_reado(efx, &reg, FR_AZ_CS_DEBUG);
 	efx->port_num = EFX_OWORD_FIELD(reg, FRF_CZ_CS_PORT_NUM) - 1;
 
-	rc = efx_mcdi_init(efx);
+	rc = efx_siena_mcdi_init(efx);
 	if (rc)
 		goto fail1;
 
 	/* Now we can reset the NIC */
-	rc = efx_mcdi_reset(efx, RESET_TYPE_ALL);
+	rc = efx_siena_mcdi_reset(efx, RESET_TYPE_ALL);
 	if (rc) {
 		netif_err(efx, probe, efx->net_dev, "failed to reset NIC\n");
 		goto fail3;
@@ -323,7 +324,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 		goto fail5;
 	}
 
-	rc = efx_mcdi_mon_probe(efx);
+	rc = efx_siena_mcdi_mon_probe(efx);
 	if (rc)
 		goto fail5;
 
@@ -338,8 +339,8 @@ static int siena_probe_nic(struct efx_nic *efx)
 	efx_nic_free_buffer(efx, &efx->irq_status);
 fail4:
 fail3:
-	efx_mcdi_detach(efx);
-	efx_mcdi_fini(efx);
+	efx_siena_mcdi_detach(efx);
+	efx_siena_mcdi_fini(efx);
 fail1:
 	kfree(efx->nic_data);
 	return rc;
@@ -406,7 +407,7 @@ static int siena_init_nic(struct efx_nic *efx)
 	int rc;
 
 	/* Recover from a failed assertion post-reset */
-	rc = efx_mcdi_handle_assertion(efx);
+	rc = efx_siena_mcdi_handle_assertion(efx);
 	if (rc)
 		return rc;
 
@@ -440,7 +441,7 @@ static int siena_init_nic(struct efx_nic *efx)
 	efx->rss_context.context_id = 0; /* indicates RSS is active */
 
 	/* Enable event logging */
-	rc = efx_mcdi_log_ctrl(efx, true, false, 0);
+	rc = efx_siena_mcdi_log_ctrl(efx, true, false, 0);
 	if (rc)
 		return rc;
 
@@ -457,14 +458,14 @@ static int siena_init_nic(struct efx_nic *efx)
 
 static void siena_remove_nic(struct efx_nic *efx)
 {
-	efx_mcdi_mon_remove(efx);
+	efx_siena_mcdi_mon_remove(efx);
 
 	efx_nic_free_buffer(efx, &efx->irq_status);
 
-	efx_mcdi_reset(efx, RESET_TYPE_ALL);
+	efx_siena_mcdi_reset(efx, RESET_TYPE_ALL);
 
-	efx_mcdi_detach(efx);
-	efx_mcdi_fini(efx);
+	efx_siena_mcdi_detach(efx);
+	efx_siena_mcdi_fini(efx);
 
 	/* Tear down the private nic state */
 	kfree(efx->nic_data);
@@ -649,14 +650,14 @@ static int siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only __always_unu
 
 	WARN_ON(!mutex_is_locked(&efx->mac_lock));
 
-	rc = efx_mcdi_set_mac(efx);
+	rc = efx_siena_mcdi_set_mac(efx);
 	if (rc != 0)
 		return rc;
 
 	memcpy(MCDI_PTR(inbuf, SET_MCAST_HASH_IN_HASH0),
 	       efx->multicast_hash.byte, sizeof(efx->multicast_hash));
-	return efx_mcdi_rpc(efx, MC_CMD_SET_MCAST_HASH,
-			    inbuf, sizeof(inbuf), NULL, 0, NULL);
+	return efx_siena_mcdi_rpc(efx, MC_CMD_SET_MCAST_HASH,
+				  inbuf, sizeof(inbuf), NULL, 0, NULL);
 }
 
 /**************************************************************************
@@ -689,16 +690,17 @@ static int siena_set_wol(struct efx_nic *efx, u32 type)
 
 	if (type & WAKE_MAGIC) {
 		if (nic_data->wol_filter_id != -1)
-			efx_mcdi_wol_filter_remove(efx,
-						   nic_data->wol_filter_id);
-		rc = efx_mcdi_wol_filter_set_magic(efx, efx->net_dev->dev_addr,
-						   &nic_data->wol_filter_id);
+			efx_siena_mcdi_wol_filter_remove(efx,
+						nic_data->wol_filter_id);
+		rc = efx_siena_mcdi_wol_filter_set_magic(efx,
+						efx->net_dev->dev_addr,
+						&nic_data->wol_filter_id);
 		if (rc)
 			goto fail;
 
 		pci_wake_from_d3(efx->pci_dev, true);
 	} else {
-		rc = efx_mcdi_wol_filter_reset(efx);
+		rc = efx_siena_mcdi_wol_filter_reset(efx);
 		nic_data->wol_filter_id = -1;
 		pci_wake_from_d3(efx->pci_dev, false);
 		if (rc)
@@ -718,12 +720,12 @@ static void siena_init_wol(struct efx_nic *efx)
 	struct siena_nic_data *nic_data = efx->nic_data;
 	int rc;
 
-	rc = efx_mcdi_wol_filter_get_magic(efx, &nic_data->wol_filter_id);
+	rc = efx_siena_mcdi_wol_filter_get_magic(efx, &nic_data->wol_filter_id);
 
 	if (rc != 0) {
 		/* If it failed, attempt to get into a synchronised
 		 * state with MC by resetting any set WoL filters */
-		efx_mcdi_wol_filter_reset(efx);
+		efx_siena_mcdi_wol_filter_reset(efx);
 		nic_data->wol_filter_id = -1;
 	} else if (nic_data->wol_filter_id != -1) {
 		pci_wake_from_d3(efx->pci_dev, true);
@@ -869,7 +871,8 @@ static int siena_mtd_probe_partition(struct efx_nic *efx,
 	if (info->port != efx_port_num(efx))
 		return -ENODEV;
 
-	rc = efx_mcdi_nvram_info(efx, type, &size, &erase_size, &protected);
+	rc = efx_siena_mcdi_nvram_info(efx, type, &size, &erase_size,
+				       &protected);
 	if (rc)
 		return rc;
 	if (protected)
@@ -896,7 +899,7 @@ static int siena_mtd_get_fw_subtypes(struct efx_nic *efx,
 	size_t i;
 	int rc;
 
-	rc = efx_mcdi_get_board_cfg(efx, NULL, fw_subtype_list, NULL);
+	rc = efx_siena_mcdi_get_board_cfg(efx, NULL, fw_subtype_list, NULL);
 	if (rc)
 		return rc;
 
@@ -916,7 +919,7 @@ static int siena_mtd_probe(struct efx_nic *efx)
 
 	ASSERT_RTNL();
 
-	rc = efx_mcdi_nvram_types(efx, &nvram_types);
+	rc = efx_siena_mcdi_nvram_types(efx, &nvram_types);
 	if (rc)
 		return rc;
 
@@ -987,11 +990,11 @@ const struct efx_nic_type siena_a0_nic_type = {
 #else
 	.monitor = NULL,
 #endif
-	.map_reset_reason = efx_mcdi_map_reset_reason,
+	.map_reset_reason = efx_siena_mcdi_map_reset_reason,
 	.map_reset_flags = siena_map_reset_flags,
-	.reset = efx_mcdi_reset,
-	.probe_port = efx_mcdi_port_probe,
-	.remove_port = efx_mcdi_port_remove,
+	.reset = efx_siena_mcdi_reset,
+	.probe_port = efx_siena_mcdi_port_probe,
+	.remove_port = efx_siena_mcdi_port_remove,
 	.fini_dmaq = efx_farch_fini_dmaq,
 	.prepare_flush = efx_siena_prepare_flush,
 	.finish_flush = siena_finish_flush,
@@ -999,18 +1002,18 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.finish_flr = efx_farch_finish_flr,
 	.describe_stats = siena_describe_nic_stats,
 	.update_stats = siena_update_nic_stats,
-	.start_stats = efx_mcdi_mac_start_stats,
-	.pull_stats = efx_mcdi_mac_pull_stats,
-	.stop_stats = efx_mcdi_mac_stop_stats,
+	.start_stats = efx_siena_mcdi_mac_start_stats,
+	.pull_stats = efx_siena_mcdi_mac_pull_stats,
+	.stop_stats = efx_siena_mcdi_mac_stop_stats,
 	.push_irq_moderation = siena_push_irq_moderation,
 	.reconfigure_mac = siena_mac_reconfigure,
-	.check_mac_fault = efx_mcdi_mac_check_fault,
-	.reconfigure_port = efx_mcdi_port_reconfigure,
+	.check_mac_fault = efx_siena_mcdi_mac_check_fault,
+	.reconfigure_port = efx_siena_mcdi_port_reconfigure,
 	.get_wol = siena_get_wol,
 	.set_wol = siena_set_wol,
 	.resume_wol = siena_init_wol,
 	.test_chip = siena_test_chip,
-	.test_nvram = efx_mcdi_nvram_test_all,
+	.test_nvram = efx_siena_mcdi_nvram_test_all,
 	.mcdi_request = siena_mcdi_request,
 	.mcdi_poll_response = siena_mcdi_poll_response,
 	.mcdi_read_response = siena_mcdi_read_response,
@@ -1057,11 +1060,11 @@ const struct efx_nic_type siena_a0_nic_type = {
 #endif
 #ifdef CONFIG_SFC_MTD
 	.mtd_probe = siena_mtd_probe,
-	.mtd_rename = efx_mcdi_mtd_rename,
-	.mtd_read = efx_mcdi_mtd_read,
-	.mtd_erase = efx_mcdi_mtd_erase,
-	.mtd_write = efx_mcdi_mtd_write,
-	.mtd_sync = efx_mcdi_mtd_sync,
+	.mtd_rename = efx_siena_mcdi_mtd_rename,
+	.mtd_read = efx_siena_mcdi_mtd_read,
+	.mtd_erase = efx_siena_mcdi_mtd_erase,
+	.mtd_write = efx_siena_mcdi_mtd_write,
+	.mtd_sync = efx_siena_mcdi_mtd_sync,
 #endif
 	.ptp_write_host_time = siena_ptp_write_host_time,
 	.ptp_set_ts_config = siena_ptp_set_ts_config,
@@ -1105,6 +1108,6 @@ const struct efx_nic_type siena_a0_nic_type = {
 			     1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT),
 	.rx_hash_key_size = 16,
 	.check_caps = siena_check_caps,
-	.sensor_event = efx_mcdi_sensor_event,
+	.sensor_event = efx_siena_mcdi_sensor_event,
 	.rx_recycle_ring_size = efx_siena_recycle_ring_size,
 };
diff --git a/drivers/net/ethernet/sfc/siena/siena_sriov.c b/drivers/net/ethernet/sfc/siena/siena_sriov.c
index f8e14f0d2f34..fdfcf480fd47 100644
--- a/drivers/net/ethernet/sfc/siena/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena/siena_sriov.c
@@ -206,8 +206,9 @@ static int efx_siena_sriov_cmd(struct efx_nic *efx, bool enable,
 	MCDI_SET_DWORD(inbuf, SRIOV_IN_VI_BASE, EFX_VI_BASE);
 	MCDI_SET_DWORD(inbuf, SRIOV_IN_VF_COUNT, efx->vf_count);
 
-	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_SRIOV, inbuf, MC_CMD_SRIOV_IN_LEN,
-				outbuf, MC_CMD_SRIOV_OUT_LEN, &outlen);
+	rc = efx_siena_mcdi_rpc_quiet(efx, MC_CMD_SRIOV, inbuf,
+				      MC_CMD_SRIOV_IN_LEN, outbuf,
+				      MC_CMD_SRIOV_OUT_LEN, &outlen);
 	if (rc)
 		return rc;
 	if (outlen < MC_CMD_SRIOV_OUT_LEN)
@@ -288,7 +289,7 @@ static int efx_siena_sriov_memcpy(struct efx_nic *efx,
 		++req;
 	}
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_MEMCPY, inbuf, used, NULL, 0, NULL);
+	rc = efx_siena_mcdi_rpc(efx, MC_CMD_MEMCPY, inbuf, used, NULL, 0, NULL);
 out:
 	mb();	/* Don't write source/read dest before DMA is complete */
 
@@ -712,7 +713,7 @@ static int efx_vfdi_fini_all_queues(struct siena_vf *vf)
 
 	atomic_set(&vf->rxq_retry_count, 0);
 	while (timeout && (vf->rxq_count || vf->txq_count)) {
-		rc = efx_mcdi_rpc(efx, MC_CMD_FLUSH_RX_QUEUES, inbuf,
+		rc = efx_siena_mcdi_rpc(efx, MC_CMD_FLUSH_RX_QUEUES, inbuf,
 				  MC_CMD_FLUSH_RX_QUEUES_IN_LEN(rxqs_count),
 				  NULL, 0, NULL);
 		WARN_ON(rc < 0);

