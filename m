Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F14F33E2CD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCQAcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhCQAcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:32:02 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2430C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:50 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id d20so37279979qkc.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=klo9NI7Al0mSrlW2JABC/O/Er3IRIlz3LP3Zlwggg/0=;
        b=u8oqpvqQJGGUwPSiTlThPM1RC4P9kYhR4S4al216kYrfY8I1nXfo0CnCCXLnVaVepb
         enJjQ/9LVhgYyNBaxa2TrBr8w5Ni2y53wApXQhpPQtjUkikVjCKgmDlAgl82lACV33aP
         pIaFXoS+mrcnSm7W9sr2NVwE+oh+7ZZnM7z4mOD3W6pa7Ig79qclcl6AjPW1++3nrkDJ
         rC9rXCQmA1Pjqy9F8Vxbk+MqQYx29RJEMVwXSU0aJ/xOncIX9cM++4B9o19YII5qYIlT
         wJuzbvBCu92iH53WlnG3ZiKccLzCRgGdXAKEuY3P8mbt5RmovebgV9O/TBWzvzlru100
         ijkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=klo9NI7Al0mSrlW2JABC/O/Er3IRIlz3LP3Zlwggg/0=;
        b=CQdItPCZPhgXAFd9PufUAx+E/mWYO+sCmolubc3pcjp4clBwGZM7gIwHcHw0b/dJj1
         Vz1nf2vqkkEjfWibu/C7ZcWKLYOFoTmMnVE4c03lrb299tYCWd2yQbI5fGNii3K63NPR
         yaxdTK1JfDZSsWSSAvSA3fANRI0U9BVrs8kamnnv+03XgvCg2sTfJpyrXEuqBR34cbO3
         ehS7p0JRXxyRSouLoZjIVHlc1XOIz6vBAdqQsg63BY/tPb2Ose40AD3cweiL7OAHby2d
         x7fxbSZU3xzO9Es8Qh9I3yxcUtljl+BKXS/Av3NzVipCpq4RDNTjUggFrSW7dOGmUM9w
         tvLQ==
X-Gm-Message-State: AOAM532maZhPnm1JN0s0quKlAfttmasPIchAmwcXRhEnpNJej4duerGH
        A9FHn+0dbl1mxKEarOvth8U=
X-Google-Smtp-Source: ABdhPJyNr6DacGS7BLfUHztLqiRtKLoNZfAetyUFl3fXUm4fqUK4zrR9ziBjmCP64lh49jjfoV0aZQ==
X-Received: by 2002:a37:6191:: with SMTP id v139mr1946541qkb.32.1615941110154;
        Tue, 16 Mar 2021 17:31:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id d70sm16768478qkg.30.2021.03.16.17.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:49 -0700 (PDT)
Subject: [net-next PATCH v2 09/10] bna: Update driver to use ethtool_sprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:31:46 -0700
Message-ID: <161594110644.5644.13783223812358363602.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the bnad_get_strings to make use of ethtool_sprintf and avoid
unnecessary line wrapping. To do this we invert the logic for the string
set test and instead exit immediately if we are not working with the stats
strings. In addition the function is broken up into subfunctions for each
area so that we can simply call ethtool_sprintf once for each string in a
given subsection.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c |  266 +++++++++--------------
 1 file changed, 105 insertions(+), 161 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 588c4804d10a..265c2fa6bbe0 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -524,6 +524,68 @@ bnad_set_pauseparam(struct net_device *netdev,
 	return 0;
 }
 
+static void bnad_get_txf_strings(u8 **string, int f_num)
+{
+	ethtool_sprintf(string, "txf%d_ucast_octets", f_num);
+	ethtool_sprintf(string, "txf%d_ucast", f_num);
+	ethtool_sprintf(string, "txf%d_ucast_vlan", f_num);
+	ethtool_sprintf(string, "txf%d_mcast_octets", f_num);
+	ethtool_sprintf(string, "txf%d_mcast", f_num);
+	ethtool_sprintf(string, "txf%d_mcast_vlan", f_num);
+	ethtool_sprintf(string, "txf%d_bcast_octets", f_num);
+	ethtool_sprintf(string, "txf%d_bcast", f_num);
+	ethtool_sprintf(string, "txf%d_bcast_vlan", f_num);
+	ethtool_sprintf(string, "txf%d_errors", f_num);
+	ethtool_sprintf(string, "txf%d_filter_vlan", f_num);
+	ethtool_sprintf(string, "txf%d_filter_mac_sa", f_num);
+}
+
+static void bnad_get_rxf_strings(u8 **string, int f_num)
+{
+	ethtool_sprintf(string, "rxf%d_ucast_octets", f_num);
+	ethtool_sprintf(string, "rxf%d_ucast", f_num);
+	ethtool_sprintf(string, "rxf%d_ucast_vlan", f_num);
+	ethtool_sprintf(string, "rxf%d_mcast_octets", f_num);
+	ethtool_sprintf(string, "rxf%d_mcast", f_num);
+	ethtool_sprintf(string, "rxf%d_mcast_vlan", f_num);
+	ethtool_sprintf(string, "rxf%d_bcast_octets", f_num);
+	ethtool_sprintf(string, "rxf%d_bcast", f_num);
+	ethtool_sprintf(string, "rxf%d_bcast_vlan", f_num);
+	ethtool_sprintf(string, "rxf%d_frame_drops", f_num);
+}
+
+static void bnad_get_cq_strings(u8 **string, int q_num)
+{
+	ethtool_sprintf(string, "cq%d_producer_index", q_num);
+	ethtool_sprintf(string, "cq%d_consumer_index", q_num);
+	ethtool_sprintf(string, "cq%d_hw_producer_index", q_num);
+	ethtool_sprintf(string, "cq%d_intr", q_num);
+	ethtool_sprintf(string, "cq%d_poll", q_num);
+	ethtool_sprintf(string, "cq%d_schedule", q_num);
+	ethtool_sprintf(string, "cq%d_keep_poll", q_num);
+	ethtool_sprintf(string, "cq%d_complete", q_num);
+}
+
+static void bnad_get_rxq_strings(u8 **string, int q_num)
+{
+	ethtool_sprintf(string, "rxq%d_packets", q_num);
+	ethtool_sprintf(string, "rxq%d_bytes", q_num);
+	ethtool_sprintf(string, "rxq%d_packets_with_error", q_num);
+	ethtool_sprintf(string, "rxq%d_allocbuf_failed", q_num);
+	ethtool_sprintf(string, "rxq%d_mapbuf_failed", q_num);
+	ethtool_sprintf(string, "rxq%d_producer_index", q_num);
+	ethtool_sprintf(string, "rxq%d_consumer_index", q_num);
+}
+
+static void bnad_get_txq_strings(u8 **string, int q_num)
+{
+	ethtool_sprintf(string, "txq%d_packets", q_num);
+	ethtool_sprintf(string, "txq%d_bytes", q_num);
+	ethtool_sprintf(string, "txq%d_producer_index", q_num);
+	ethtool_sprintf(string, "txq%d_consumer_index", q_num);
+	ethtool_sprintf(string, "txq%d_hw_consumer_index", q_num);
+}
+
 static void
 bnad_get_strings(struct net_device *netdev, u32 stringset, u8 *string)
 {
@@ -531,175 +593,57 @@ bnad_get_strings(struct net_device *netdev, u32 stringset, u8 *string)
 	int i, j, q_num;
 	u32 bmap;
 
+	if (stringset != ETH_SS_STATS)
+		return;
+
 	mutex_lock(&bnad->conf_mutex);
 
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < BNAD_ETHTOOL_STATS_NUM; i++) {
-			BUG_ON(!(strlen(bnad_net_stats_strings[i]) <
-				   ETH_GSTRING_LEN));
-			strncpy(string, bnad_net_stats_strings[i],
-				ETH_GSTRING_LEN);
-			string += ETH_GSTRING_LEN;
-		}
-		bmap = bna_tx_rid_mask(&bnad->bna);
-		for (i = 0; bmap; i++) {
-			if (bmap & 1) {
-				sprintf(string, "txf%d_ucast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_ucast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_ucast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_mcast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_mcast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_mcast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_bcast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_bcast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_bcast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_errors", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_filter_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txf%d_filter_mac_sa", i);
-				string += ETH_GSTRING_LEN;
-			}
-			bmap >>= 1;
-		}
+	for (i = 0; i < BNAD_ETHTOOL_STATS_NUM; i++) {
+		BUG_ON(!(strlen(bnad_net_stats_strings[i]) < ETH_GSTRING_LEN));
+		ethtool_sprintf(&string, bnad_net_stats_strings[i]);
+	}
 
-		bmap = bna_rx_rid_mask(&bnad->bna);
-		for (i = 0; bmap; i++) {
-			if (bmap & 1) {
-				sprintf(string, "rxf%d_ucast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_ucast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_ucast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_mcast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_mcast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_mcast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_bcast_octets", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_bcast", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_bcast_vlan", i);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxf%d_frame_drops", i);
-				string += ETH_GSTRING_LEN;
-			}
-			bmap >>= 1;
-		}
+	bmap = bna_tx_rid_mask(&bnad->bna);
+	for (i = 0; bmap; i++) {
+		if (bmap & 1)
+			bnad_get_txf_strings(&string, i);
+		bmap >>= 1;
+	}
 
-		q_num = 0;
-		for (i = 0; i < bnad->num_rx; i++) {
-			if (!bnad->rx_info[i].rx)
-				continue;
-			for (j = 0; j < bnad->num_rxp_per_rx; j++) {
-				sprintf(string, "cq%d_producer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_consumer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_hw_producer_index",
-					q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_intr", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_poll", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_schedule", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_keep_poll", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "cq%d_complete", q_num);
-				string += ETH_GSTRING_LEN;
-				q_num++;
-			}
-		}
+	bmap = bna_rx_rid_mask(&bnad->bna);
+	for (i = 0; bmap; i++, bmap >>= 1) {
+		if (bmap & 1)
+			bnad_get_rxf_strings(&string, i);
+		bmap >>= 1;
+	}
 
-		q_num = 0;
-		for (i = 0; i < bnad->num_rx; i++) {
-			if (!bnad->rx_info[i].rx)
-				continue;
-			for (j = 0; j < bnad->num_rxp_per_rx; j++) {
-				sprintf(string, "rxq%d_packets", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_bytes", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_packets_with_error",
-								q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_allocbuf_failed", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_mapbuf_failed", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_producer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "rxq%d_consumer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				q_num++;
-				if (bnad->rx_info[i].rx_ctrl[j].ccb &&
-					bnad->rx_info[i].rx_ctrl[j].ccb->
-					rcb[1] &&
-					bnad->rx_info[i].rx_ctrl[j].ccb->
-					rcb[1]->rxq) {
-					sprintf(string, "rxq%d_packets", q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string, "rxq%d_bytes", q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string,
-					"rxq%d_packets_with_error", q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string, "rxq%d_allocbuf_failed",
-								q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string, "rxq%d_mapbuf_failed",
-						q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string, "rxq%d_producer_index",
-								q_num);
-					string += ETH_GSTRING_LEN;
-					sprintf(string, "rxq%d_consumer_index",
-								q_num);
-					string += ETH_GSTRING_LEN;
-					q_num++;
-				}
-			}
-		}
+	q_num = 0;
+	for (i = 0; i < bnad->num_rx; i++) {
+		if (!bnad->rx_info[i].rx)
+			continue;
+		for (j = 0; j < bnad->num_rxp_per_rx; j++)
+			bnad_get_cq_strings(&string, q_num++);
+	}
 
-		q_num = 0;
-		for (i = 0; i < bnad->num_tx; i++) {
-			if (!bnad->tx_info[i].tx)
-				continue;
-			for (j = 0; j < bnad->num_txq_per_tx; j++) {
-				sprintf(string, "txq%d_packets", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txq%d_bytes", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txq%d_producer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txq%d_consumer_index", q_num);
-				string += ETH_GSTRING_LEN;
-				sprintf(string, "txq%d_hw_consumer_index",
-									q_num);
-				string += ETH_GSTRING_LEN;
-				q_num++;
-			}
+	q_num = 0;
+	for (i = 0; i < bnad->num_rx; i++) {
+		if (!bnad->rx_info[i].rx)
+			continue;
+		for (j = 0; j < bnad->num_rxp_per_rx; j++) {
+			bnad_get_rxq_strings(&string, q_num++);
+			if (bnad->rx_info[i].rx_ctrl[j].ccb &&
+			    bnad->rx_info[i].rx_ctrl[j].ccb->rcb[1] &&
+			    bnad->rx_info[i].rx_ctrl[j].ccb->rcb[1]->rxq)
+				bnad_get_rxq_strings(&string, q_num++);
 		}
+	}
 
-		break;
-
-	default:
-		break;
+	q_num = 0;
+	for (i = 0; i < bnad->num_tx; i++) {
+		if (!bnad->tx_info[i].tx)
+			continue;
+		for (j = 0; j < bnad->num_txq_per_tx; j++)
+			bnad_get_txq_strings(&string, q_num++);
 	}
 
 	mutex_unlock(&bnad->conf_mutex);


