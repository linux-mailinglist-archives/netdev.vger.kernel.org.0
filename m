Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F69869A8B3
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBQJ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQJ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FEF5F83A;
        Fri, 17 Feb 2023 01:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53943617D5;
        Fri, 17 Feb 2023 09:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB9DC433D2;
        Fri, 17 Feb 2023 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676627813;
        bh=XbLUVd/DiF+mzfEKHNxTFeE4EBSXo9Y2euw6icu02Nc=;
        h=From:To:Cc:Subject:Date:From;
        b=o+avbq99bcmuz6rYatJStUVjB7xrxFZ5cOLB/6iR6O43ijPib0maB0ATo+omB968I
         dLuBq0wbFuLv6HRvDhTtQ53qDHun25SKTz03WbL9L/mI/cSMYRMontFqksWKesQ3zG
         6Kzqy8AjrlMJWMqUYOuKBoYqDeGqnxARlttukuKQwUDQhlZRJCzPqIVEoGrmoLn5vV
         0NHJSrfrpGPM0uX7HNKC/3eCIxxTCctPWZUo154fVdeBxeIZTUvPYrzw1kgZhxvPEI
         WhxZMv+PY3HmOQiox4NBZEMin3K2SRtox0O95InLNlu7pwifmPzpWEsHXbV5EuPLXV
         LrA7UeAhqiyxg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
Date:   Fri, 17 Feb 2023 10:56:39 +0100
Message-Id: <20230217095650.2305559-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

One local variable has become unused after a recent change:

drivers/net/ethernet/sfc/ef100_nic.c: In function 'ef100_probe_netdev_pf':
drivers/net/ethernet/sfc/ef100_nic.c:1155:21: error: unused variable 'net_dev' [-Werror=unused-variable]
  struct net_device *net_dev = efx->net_dev;
                     ^~~~~~~

The variable is still used in an #ifdef. Replace the #ifdef with
an if(IS_ENABLED()) check that lets the compiler see where it is
used, rather than adding another #ifdef.

This also fixes an uninitialized return value in ef100_probe_netdev_pf()
that gcc did not spot.

Fixes: 7e056e2360d9 ("sfc: obtain device mac address based on firmware handle for ef100")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index becd21c2325d..4dc643b0d2db 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -399,14 +399,14 @@ static int ef100_filter_table_up(struct efx_nic *efx)
 	 * filter insertion will need to take the lock for read.
 	 */
 	up_write(&efx->filter_sem);
-#ifdef CONFIG_SFC_SRIOV
-	rc = efx_tc_insert_rep_filters(efx);
+	if (IS_ENABLED(CONFIG_SFC_SRIOV))
+		rc = efx_tc_insert_rep_filters(efx);
+
 	/* Rep filter failure is nonfatal */
 	if (rc)
 		netif_warn(efx, drv, efx->net_dev,
 			   "Failed to insert representor filters, rc %d\n",
 			   rc);
-#endif
 	return 0;
 
 fail_vlan0:
@@ -419,9 +419,8 @@ static int ef100_filter_table_up(struct efx_nic *efx)
 
 static void ef100_filter_table_down(struct efx_nic *efx)
 {
-#ifdef CONFIG_SFC_SRIOV
-	efx_tc_remove_rep_filters(efx);
-#endif
+	if (IS_ENABLED(CONFIG_SFC_SRIOV))
+		efx_tc_remove_rep_filters(efx);
 	down_write(&efx->filter_sem);
 	efx_mcdi_filter_del_vlan(efx, 0);
 	efx_mcdi_filter_del_vlan(efx, EFX_FILTER_VID_UNSPEC);
@@ -737,7 +736,6 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
-#ifdef CONFIG_SFC_SRIOV
 static int efx_ef100_get_base_mport(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -773,7 +771,6 @@ static int efx_ef100_get_base_mport(struct efx_nic *efx)
 
 	return 0;
 }
-#endif
 
 static int compare_versions(const char *a, const char *b)
 {
@@ -1155,10 +1152,9 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 	struct net_device *net_dev = efx->net_dev;
 	int rc;
 
-	if (!nic_data->grp_mae)
+	if (!IS_ENABLED(CONFIG_SFC_SRIOV) || !nic_data->grp_mae)
 		return 0;
 
-#ifdef CONFIG_SFC_SRIOV
 	rc = efx_init_struct_tc(efx);
 	if (rc)
 		return rc;
@@ -1193,7 +1189,6 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		net_dev->features |= NETIF_F_HW_TC;
 		efx->fixed_features |= NETIF_F_HW_TC;
 	}
-#endif
 	return rc;
 }
 
@@ -1206,12 +1201,11 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->mae) {
+	if (IS_ENABLED(CONFIG_SFC_SRIOV) && efx->mae) {
 		efx_ef100_fini_reps(efx);
 		efx_fini_mae(efx);
 	}
-#endif
+
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
 	if (nic_data)
@@ -1304,9 +1298,8 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.update_stats = ef100_update_stats,
 	.pull_stats = efx_mcdi_mac_pull_stats,
 	.stop_stats = efx_mcdi_mac_stop_stats,
-#ifdef CONFIG_SFC_SRIOV
-	.sriov_configure = efx_ef100_sriov_configure,
-#endif
+	.sriov_configure = IS_ENABLED(CONFIG_SFC_SRIOV) ?
+		efx_ef100_sriov_configure : NULL,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
 	 * registers is defined by extended capabilities.
-- 
2.39.1

