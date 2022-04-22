Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4E50BB02
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449112AbiDVPEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449098AbiDVPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:03:40 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDE355D19B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:00:44 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 88BAF320133;
        Fri, 22 Apr 2022 16:00:43 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhum2-0007Bf-Kp; Fri, 22 Apr 2022 16:00:42 +0100
Subject: [PATCH net-next 17/28] sfc/siena: Rename functions in
 mcdi_port_common.h to avoid conflicts with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:00:42 +0100
Message-ID: <165063964249.27138.14216599518871428740.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/siena/efx.c              |    4 -
 drivers/net/ethernet/sfc/siena/efx_common.c       |    6 +
 drivers/net/ethernet/sfc/siena/ethtool_common.c   |   16 ++-
 drivers/net/ethernet/sfc/siena/mcdi_port.c        |    8 +-
 drivers/net/ethernet/sfc/siena/mcdi_port_common.c |  106 +++++++++------------
 drivers/net/ethernet/sfc/siena/mcdi_port_common.h |   60 +++++-------
 drivers/net/ethernet/sfc/siena/selftest.c         |    4 -
 drivers/net/ethernet/sfc/siena/siena.c            |    8 +-
 8 files changed, 92 insertions(+), 120 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index c233808727ca..417c9f714da8 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -153,7 +153,7 @@ static int efx_init_port(struct efx_nic *efx)
 	efx->port_initialized = true;
 
 	/* Ensure the PHY advertises the correct flow control settings */
-	rc = efx_mcdi_port_reconfigure(efx);
+	rc = efx_siena_mcdi_port_reconfigure(efx);
 	if (rc && rc != -EPERM)
 		goto fail;
 
@@ -1158,7 +1158,7 @@ static int efx_pm_thaw(struct device *dev)
 			goto fail;
 
 		mutex_lock(&efx->mac_lock);
-		efx_mcdi_port_reconfigure(efx);
+		efx_siena_mcdi_port_reconfigure(efx);
 		mutex_unlock(&efx->mac_lock);
 
 		efx_siena_start_all(efx);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index e55aadcc4ed4..36f2c24b3c8a 100644
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
 
@@ -760,7 +760,7 @@ int efx_siena_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
 
 	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
 	    method != RESET_TYPE_DATAPATH) {
-		rc = efx_mcdi_port_reconfigure(efx);
+		rc = efx_siena_mcdi_port_reconfigure(efx);
 		if (rc && rc != -EPERM)
 			netif_err(efx, drv, efx->net_dev,
 				  "could not restore PHY settings\n");
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index a7f2b39761e0..c94a75df0d29 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
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
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port.c b/drivers/net/ethernet/sfc/siena/mcdi_port.c
index 4259be4674b0..93b8b2338f11 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port.c
@@ -96,15 +96,15 @@ int efx_siena_mcdi_port_probe(struct efx_nic *efx)
 	efx->mdio.mdio_write = efx_mcdi_mdio_write;
 
 	/* Fill out MDIO structure, loopback modes, and initial link state */
-	rc = efx_mcdi_phy_probe(efx);
+	rc = efx_siena_mcdi_phy_probe(efx);
 	if (rc != 0)
 		return rc;
 
-	return efx_mcdi_mac_init_stats(efx);
+	return efx_siena_mcdi_mac_init_stats(efx);
 }
 
 void efx_siena_mcdi_port_remove(struct efx_nic *efx)
 {
-	efx_mcdi_phy_remove(efx);
-	efx_mcdi_mac_fini_stats(efx);
+	efx_siena_mcdi_phy_remove(efx);
+	efx_siena_mcdi_mac_fini_stats(efx);
 }
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.c b/drivers/net/ethernet/sfc/siena/mcdi_port_common.c
index 0098ecc25733..a842c139d76f 100644
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
 
@@ -83,7 +84,7 @@ int efx_mcdi_set_link(struct efx_nic *efx, u32 capabilities,
 				  NULL, 0, NULL);
 }
 
-int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
+static int efx_mcdi_loopback_modes(struct efx_nic *efx, u64 *loopback_modes)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LOOPBACK_MODES_OUT_LEN);
 	size_t outlen;
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
@@ -421,7 +422,7 @@ bool efx_mcdi_phy_poll(struct efx_nic *efx)
 	return !efx_link_state_equal(&efx->link_state, &old_state);
 }
 
-int efx_mcdi_phy_probe(struct efx_nic *efx)
+int efx_siena_mcdi_phy_probe(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_data;
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_LINK_OUT_LEN);
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
@@ -727,7 +733,7 @@ int efx_mcdi_phy_test_alive(struct efx_nic *efx)
 	return 0;
 }
 
-int efx_mcdi_port_reconfigure(struct efx_nic *efx)
+int efx_siena_mcdi_port_reconfigure(struct efx_nic *efx)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 caps = (efx->link_advertising[0] ?
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
@@ -1134,21 +1143,6 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 				  sizeof(cmdbytes), NULL, 0, NULL);
 }
 
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
-	return efx_siena_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
-				  NULL, 0, NULL);
-}
-
 enum efx_stats_action {
 	EFX_STATS_ENABLE,
 	EFX_STATS_DISABLE,
@@ -1223,7 +1217,7 @@ void efx_siena_mcdi_mac_pull_stats(struct efx_nic *efx)
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
-	rc = efx_siena_mcdi_rpc(efx, MC_CMD_GET_PORT_ASSIGNMENT, NULL, 0,
-				outbuf, sizeof(outbuf), NULL);
-	if (rc)
-		return rc;
-
-	return MCDI_DWORD(outbuf, GET_PORT_ASSIGNMENT_OUT_PORT);
-}
-
 static unsigned int efx_mcdi_event_link_speed[] = {
 	[MCDI_EVENT_LINKCHANGE_SPEED_100M] = 100,
 	[MCDI_EVENT_LINKCHANGE_SPEED_1G] = 1000,
diff --git a/drivers/net/ethernet/sfc/siena/mcdi_port_common.h b/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
index 5e0599f1d657..7a6de13d9ce6 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/siena/mcdi_port_common.h
@@ -28,39 +28,31 @@ struct efx_mcdi_phy_data {
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
index 3cf55b44736a..74ed8e972c93 100644
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
@@ -650,7 +650,7 @@ static int siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only __always_unu
 
 	WARN_ON(!mutex_is_locked(&efx->mac_lock));
 
-	rc = efx_mcdi_set_mac(efx);
+	rc = efx_siena_mcdi_set_mac(efx);
 	if (rc != 0)
 		return rc;
 
@@ -1008,7 +1008,7 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.push_irq_moderation = siena_push_irq_moderation,
 	.reconfigure_mac = siena_mac_reconfigure,
 	.check_mac_fault = efx_siena_mcdi_mac_check_fault,
-	.reconfigure_port = efx_mcdi_port_reconfigure,
+	.reconfigure_port = efx_siena_mcdi_port_reconfigure,
 	.get_wol = siena_get_wol,
 	.set_wol = siena_set_wol,
 	.resume_wol = siena_init_wol,

