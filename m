Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98DE0793
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732474AbfJVPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:38:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56608 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730305AbfJVPit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:38:49 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A6EE0B40076;
        Tue, 22 Oct 2019 15:38:48 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 22 Oct 2019 16:38:43 +0100
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next 3/6] sfc: Enable setting of xdp_prog.
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Message-ID: <2e95c1f4-6fa7-561a-30bc-1f4628e17c96@solarflare.com>
Date:   Tue, 22 Oct 2019 16:38:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <05b72fdb-165c-1350-787b-ca8c5261c459@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24994.003
X-TM-AS-Result: No-4.326200-8.000000-10
X-TMASE-MatchedRID: hmDxJoAItt9G7jIPw/RhEP9XRIMLUOjQUi+zC3M9+8Hfc2Xd6VJ+yu73
        4x6nzMNihzuuxUHvk3q6sghyELan/KH2g9syPs888Kg68su2wyFLXPA26IG0hN9RlPzeVuQQj78
        +1uscT5IL4imyL647uM0CjKwcYFKxP2dDgSWCh78SEYfcJF0pRaLwP+jjbL9KEy7p6uycXL0zoo
        /V8WNVFeg0wU8h1M/OtcO31niXmWteptmfj4Bki0f49ONH0RaSUHV7v8X++rm8NrbzjPvzJyJXm
        JtFWsY7ZH2IWO92hfQe3NMhq0+LXmG/iPOyVtTiI0cHLI6lhgI1TzP60UkdHXTcRTxyvO5LGSE9
        W8wHt0a4KmKNJNexnKob+cxzTFFZmuM9fNKqyJDl0qJwf9h/p2tNZoZ5+7ekYq4PLSQobHTzfqA
        OKCG9XTcQLw8RZlEYS/i41cQ7DTP++YYDD/V/l+LzNWBegCW2XC3N7C7YzreNo+PRbWqfRMprJP
        8FBOIar1S3+0WjH8xKLkFRjzGfjZqOnvREoxVCkDr+kVURPWltU9auXPMTRVMyw5WZw6qySoxU8
        j+ZDy4RWU8cVpDM1xrJfkINDYp5KxP1fzhj+RlDgw2OfwbhLKMa5OkNpiHkifsL+6CY4Rll3xQ+
        X3ZmUQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.326200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24994.003
X-MDID: 1571758729-xdvlt0eN28PM
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
 drivers/net/ethernet/sfc/efx.c | 64 ++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 2f1d851c7fd2..e382129617f9 100644
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
@@ -2024,6 +2026,10 @@ static void efx_stop_all(struct efx_nic *efx)
 
 static void efx_remove_all(struct efx_nic *efx)
 {
+	rtnl_lock();
+	efx_xdp_setup_prog(efx, NULL);
+	rtnl_unlock();
+
 	efx_remove_channels(efx);
 	efx_remove_filters(efx);
 #ifdef CONFIG_SFC_SRIOV
@@ -2279,6 +2285,17 @@ static void efx_watchdog(struct net_device *net_dev)
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
@@ -2290,6 +2307,14 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
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
@@ -2491,8 +2516,47 @@ static const struct net_device_ops efx_netdev_ops = {
 #endif
 	.ndo_udp_tunnel_add	= efx_udp_tunnel_add,
 	.ndo_udp_tunnel_del	= efx_udp_tunnel_del,
+	.ndo_bpf		= efx_xdp
 };
 
+static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
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
