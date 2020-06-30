Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E279D210038
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgF3Wur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgF3Wuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 18:50:46 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7183420722;
        Tue, 30 Jun 2020 22:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593557445;
        bh=ctxzCvGOJvu4SHcREPfr6tApTPXV/cZ+NMgQNB4YBJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=Qo3qDlfxctYuoTIpHU0T+jsJyxOdGZ1WUZRgpQRpKV7x/896QNX9YsjXW5t+CUmvN
         ou9PHm2gpYTSkfnP2Vt+rx/vfbrqS/6qgbb4ME6GTAhaNDWeIH1Kx2WzMpgLHrxtK0
         91DnMFeO66zvf3VNiWDHlTFiu1fLmRYygY/tTKns=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree@solarflare.com,
        mhabets@solarflare.com, linux-net-drivers@solarflare.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] sfc: remove udp_tnl_has_port
Date:   Tue, 30 Jun 2020 15:50:38 -0700
Message-Id: <20200630225038.1190589-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing seems to have ever been calling this.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c       | 23 -----------------------
 drivers/net/ethernet/sfc/net_driver.h |  2 --
 2 files changed, 25 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 5faf2f0e4d62..bd4f5eb5b098 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3907,28 +3907,6 @@ static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
 	return rc;
 }
 
-/* Called under the TX lock with the TX queue running, hence no-one can be
- * in the middle of updating the UDP tunnels table.  However, they could
- * have tried and failed the MCDI, in which case they'll have set the dirty
- * flag before dropping their locks.
- */
-static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
-{
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-
-	if (!(nic_data->datapath_caps &
-	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
-		return false;
-
-	if (nic_data->udp_tunnels_dirty)
-		/* SW table may not match HW state, so just assume we can't
-		 * use any UDP tunnel offloads.
-		 */
-		return false;
-
-	return __efx_ef10_udp_tnl_lookup_port(efx, port) != NULL;
-}
-
 static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
 				     struct efx_udp_tunnel tnl)
 {
@@ -4216,7 +4194,6 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.vlan_rx_kill_vid = efx_ef10_vlan_rx_kill_vid,
 	.udp_tnl_push_ports = efx_ef10_udp_tnl_push_ports,
 	.udp_tnl_add_port = efx_ef10_udp_tnl_add_port,
-	.udp_tnl_has_port = efx_ef10_udp_tnl_has_port,
 	.udp_tnl_del_port = efx_ef10_udp_tnl_del_port,
 #ifdef CONFIG_SFC_SRIOV
 	.sriov_configure = efx_ef10_sriov_configure,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index e0b84b2e3bd2..69d58f2b638c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1298,7 +1298,6 @@ struct efx_udp_tunnel {
  *	If %NULL, then device does not support any TSO version.
  * @udp_tnl_push_ports: Push the list of UDP tunnel ports to the NIC if required.
  * @udp_tnl_add_port: Add a UDP tunnel port
- * @udp_tnl_has_port: Check if a port has been added as UDP tunnel
  * @udp_tnl_del_port: Remove a UDP tunnel port
  * @print_additional_fwver: Dump NIC-specific additional FW version info
  * @revision: Hardware architecture revision
@@ -1472,7 +1471,6 @@ struct efx_nic_type {
 	u32 (*tso_versions)(struct efx_nic *efx);
 	int (*udp_tnl_push_ports)(struct efx_nic *efx);
 	int (*udp_tnl_add_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
-	bool (*udp_tnl_has_port)(struct efx_nic *efx, __be16 port);
 	int (*udp_tnl_del_port)(struct efx_nic *efx, struct efx_udp_tunnel tnl);
 	size_t (*print_additional_fwver)(struct efx_nic *efx, char *buf,
 					 size_t len);
-- 
2.26.2

