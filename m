Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228E6EAD59
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 11:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJaKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 06:23:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37160 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfJaKXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 06:23:47 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C419A140066;
        Thu, 31 Oct 2019 10:23:45 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 31 Oct 2019 10:23:40 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v4 3/6] sfc: Enable setting of xdp_prog
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Message-ID: <c5da10a4-884d-e94b-1473-00b9d9a2d5d2@solarflare.com>
Date:   Thu, 31 Oct 2019 10:23:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25012.003
X-TM-AS-Result: No-3.474300-8.000000-10
X-TMASE-MatchedRID: Jjac64tbHndG7jIPw/RhEP9XRIMLUOjQUi+zC3M9+8Hfc2Xd6VJ+yu73
        4x6nzMNihzuuxUHvk3q6sghyELan/KH2g9syPs888Kg68su2wyFLXPA26IG0hN9RlPzeVuQQj78
        +1uscT5IL4imyL647uM0CjKwcYFKxP2dDgSWCh78SEYfcJF0pRaLwP+jjbL9KEy7p6uycXL0zoo
        /V8WNVFeg0wU8h1M/OtcO31niXmWteptmfj4Bki0f49ONH0RaSUHV7v8X++rm8NrbzjPvzJyJXm
        JtFWsY7ZH2IWO92hfQe3NMhq0+LXmG/iPOyVtTiI0cHLI6lhgI1TzP60UkdHXTcRTxyvO5LhoBN
        KnOJHc1aHs39o4o6EMXvtECybgeqEpF1BbYvTWbxWp8B+pjaLJyqUJ2uHKFAL++JA985eCeDuU3
        0s68UO6KSsLeXp95xNqkoU1BsedmGFN7r+9GAi3CO70QAsBdC64sVlliWKx9Nfs8n85Te8r2jEZ
        ABTymN3QfwsVk0Ubt2gyyw2xTBhSJkyzpLbJQ66iG2uv8XDRo7HBw/GJnkOYT8S8AX6uqSfGsfu
        L0TSkFqgyo0DoPgoVJpvysbHO9EQwaohjva60pSyF5oeuxmijHCqV7rv9Y1QDMFuK2P9FjtoWav
        EW7HRE3Z8jKJCdR0Rfwnj+uLV5w=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.474300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25012.003
X-MDID: 1572517426-1Q-SmLWl0cW3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an ndo_bpf function to efx_netdev_ops that allows setting and
querying of xdp programs on an interface.

Also check that the MTU size isn't too big when setting a program or
when the MTU is explicitly set.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c | 70 ++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index bd0424414781..429fb268b0da 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -226,6 +226,8 @@ static void efx_fini_napi_channel(struct efx_channel *channel);
 static void efx_fini_struct(struct efx_nic *efx);
 static void efx_start_all(struct efx_nic *efx);
 static void efx_stop_all(struct efx_nic *efx);
+static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog);
+static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
@@ -2025,6 +2027,10 @@ static void efx_stop_all(struct efx_nic *efx)
 
 static void efx_remove_all(struct efx_nic *efx)
 {
+	rtnl_lock();
+	efx_xdp_setup_prog(efx, NULL);
+	rtnl_unlock();
+
 	efx_remove_channels(efx);
 	efx_remove_filters(efx);
 #ifdef CONFIG_SFC_SRIOV
@@ -2280,6 +2286,17 @@ static void efx_watchdog(struct net_device *net_dev)
 	efx_schedule_reset(efx, RESET_TYPE_TX_WATCHDOG);
 }
 
+static unsigned int efx_xdp_max_mtu(struct efx_nic *efx)
+{
+	/* The maximum MTU that we can fit in a single page, allowing for
+	 * framing, overhead and XDP headroom.
+	 */
+	int overhead = EFX_MAX_FRAME_LEN(0) + sizeof(struct efx_rx_page_state) +
+		       efx->rx_prefix_size + efx->type->rx_buffer_padding +
+		       efx->rx_ip_align + XDP_PACKET_HEADROOM;
+
+	return PAGE_SIZE - overhead;
+}
 
 /* Context: process, rtnl_lock() held. */
 static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
@@ -2291,6 +2308,14 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	if (rc)
 		return rc;
 
+	if (rtnl_dereference(efx->xdp_prog) &&
+	    new_mtu > efx_xdp_max_mtu(efx)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Requested MTU of %d too big for XDP (max: %d)\n",
+			  new_mtu, efx_xdp_max_mtu(efx));
+		return -EINVAL;
+	}
+
 	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
 
 	efx_device_detach_sync(efx);
@@ -2492,8 +2517,53 @@ static const struct net_device_ops efx_netdev_ops = {
 #endif
 	.ndo_udp_tunnel_add	= efx_udp_tunnel_add,
 	.ndo_udp_tunnel_del	= efx_udp_tunnel_del,
+	.ndo_bpf		= efx_xdp
 };
 
+static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
+
+	if (efx->xdp_rxq_info_failed) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Unable to bind XDP program due to previous failure of rxq_info\n");
+		return -EINVAL;
+	}
+
+	if (prog && efx->net_dev->mtu > efx_xdp_max_mtu(efx)) {
+		netif_err(efx, drv, efx->net_dev,
+			  "Unable to configure XDP with MTU of %d (max: %d)\n",
+			  efx->net_dev->mtu, efx_xdp_max_mtu(efx));
+		return -EINVAL;
+	}
+
+	old_prog = rtnl_dereference(efx->xdp_prog);
+	rcu_assign_pointer(efx->xdp_prog, prog);
+	/* Release the reference that was originally passed by the caller. */
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+/* Context: process, rtnl_lock() held. */
+static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct efx_nic *efx = netdev_priv(dev);
+	struct bpf_prog *xdp_prog;
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return efx_xdp_setup_prog(efx, xdp->prog);
+	case XDP_QUERY_PROG:
+		xdp_prog = rtnl_dereference(efx->xdp_prog);
+		xdp->prog_id = xdp_prog ? xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static void efx_update_name(struct efx_nic *efx)
 {
 	strcpy(efx->name, efx->net_dev->name);
