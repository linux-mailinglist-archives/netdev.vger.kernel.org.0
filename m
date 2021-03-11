Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3313369C9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCKBgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhCKBgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:36:12 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C46C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:12 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s21so2642041pjq.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DJltLUYcs98/kijveBfZyUaWDIHwVhRt97pqpufw9i0=;
        b=scU65pB6xFpMzm1+8nIhbovGBVQq1DtmdBjSrEWTrUXE9VHbZuS3Lp1yFfeNpGFfxd
         Cg192aYX3oZnj0Vjf/xDZXhzxbnPGFY6nzOYMcZgXEafssYgqgiQTUElhKKRk1RSIt3w
         j6uwqDsJhAIHRrxiUgh8lfrcN5TpkjTx9T0VqizaOYxrtVhx/IlOCru4UmCjbY5kWqbK
         hsxwpPM5A2aN1K8dtdZ340qIcfmC9lMWZZV5vG9vB1Aap5phcHGC0vAoAxGZNO4njQf+
         pgr1Yh/62kmsT8+WMW12lAtChaLX09Czqn5I8v7f7yqp65WdgUmwpIhEmMacY/3e2efZ
         DjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DJltLUYcs98/kijveBfZyUaWDIHwVhRt97pqpufw9i0=;
        b=QCYiVZvQ93pGono5y/+k8seszsOTBgrwy715/z4jNlEtDQmXmKs2c24hQOtuP+yYiD
         GUdk8auC8KKJYdt9p6lJJASCayrFjivrfX+DA4dwrd0X6sNucrkFAipzJcpxjpfYQudF
         WJuALcdB5Lr/kaWOV2UKLY2f3djqNgv6ePSk2mMrT+ZcsJ3OxFGEolzmTgo9sP0ej6c3
         TU9i16taomOBDfVXHEqEXruRusLOX4dMqgJRUII9h6W3W/Oez1s/aX7NVuwf8NOynKfB
         /2+4ApWPoxR+WxrYaVWuwzE2m+YmNGvuUzcMpHKr8bZrU1vj7ZQ2GdMmvHGX6VCu7LH+
         Ythw==
X-Gm-Message-State: AOAM533+xtox93OY7wFjwFtf96NnCBn8J/j/nvWRhjIHSZJsrWX1bdWh
        o0i43qICzKNSOpw3fNtwPW8=
X-Google-Smtp-Source: ABdhPJzYqOo5VXwSONbDqpY26hTZ33JQIrILn89H5MFVviNNdeqdtDsgwtLdyDkytIH8dBO1ybn1gQ==
X-Received: by 2002:a17:90a:5302:: with SMTP id x2mr6557715pjh.232.1615426572198;
        Wed, 10 Mar 2021 17:36:12 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e1sm518190pjm.12.2021.03.10.17.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:36:11 -0800 (PST)
Subject: [RFC PATCH 09/10] bna: Update driver to use ethtool_gsprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
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
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:36:10 -0800
Message-ID: <161542657091.13546.17503493571307422104.stgit@localhost.localdomain>
In-Reply-To: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the bnad_get_strings to make use of ethtool_gsprintf and avoid
unnecessary line wrapping. To do this we invert the logic for the string
set test and instead exit immediately if we are not working with the stats
strings. In addition the function is broken up into subfunctions for each
area so that we can simply call ethtool_gsprintf once for each string in a
given subsection.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c |  266 +++++++++--------------
 1 file changed, 105 insertions(+), 161 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
index 588c4804d10a..9d72f896880d 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_ethtool.c
@@ -524,6 +524,68 @@ bnad_set_pauseparam(struct net_device *netdev,
 	return 0;
 }
 
+static void bnad_get_txf_strings(u8 **string, int f_num)
+{
+	ethtool_gsprintf(string, "txf%d_ucast_octets", f_num);
+	ethtool_gsprintf(string, "txf%d_ucast", f_num);
+	ethtool_gsprintf(string, "txf%d_ucast_vlan", f_num);
+	ethtool_gsprintf(string, "txf%d_mcast_octets", f_num);
+	ethtool_gsprintf(string, "txf%d_mcast", f_num);
+	ethtool_gsprintf(string, "txf%d_mcast_vlan", f_num);
+	ethtool_gsprintf(string, "txf%d_bcast_octets", f_num);
+	ethtool_gsprintf(string, "txf%d_bcast", f_num);
+	ethtool_gsprintf(string, "txf%d_bcast_vlan", f_num);
+	ethtool_gsprintf(string, "txf%d_errors", f_num);
+	ethtool_gsprintf(string, "txf%d_filter_vlan", f_num);
+	ethtool_gsprintf(string, "txf%d_filter_mac_sa", f_num);
+}
+
+static void bnad_get_rxf_strings(u8 **string, int f_num)
+{
+	ethtool_gsprintf(string, "rxf%d_ucast_octets", f_num);
+	ethtool_gsprintf(string, "rxf%d_ucast", f_num);
+	ethtool_gsprintf(string, "rxf%d_ucast_vlan", f_num);
+	ethtool_gsprintf(string, "rxf%d_mcast_octets", f_num);
+	ethtool_gsprintf(string, "rxf%d_mcast", f_num);
+	ethtool_gsprintf(string, "rxf%d_mcast_vlan", f_num);
+	ethtool_gsprintf(string, "rxf%d_bcast_octets", f_num);
+	ethtool_gsprintf(string, "rxf%d_bcast", f_num);
+	ethtool_gsprintf(string, "rxf%d_bcast_vlan", f_num);
+	ethtool_gsprintf(string, "rxf%d_frame_drops", f_num);
+}
+
+static void bnad_get_cq_strings(u8 **string, int q_num)
+{
+	ethtool_gsprintf(string, "cq%d_producer_index", q_num);
+	ethtool_gsprintf(string, "cq%d_consumer_index", q_num);
+	ethtool_gsprintf(string, "cq%d_hw_producer_index", q_num);
+	ethtool_gsprintf(string, "cq%d_intr", q_num);
+	ethtool_gsprintf(string, "cq%d_poll", q_num);
+	ethtool_gsprintf(string, "cq%d_schedule", q_num);
+	ethtool_gsprintf(string, "cq%d_keep_poll", q_num);
+	ethtool_gsprintf(string, "cq%d_complete", q_num);
+}
+
+static void bnad_get_rxq_strings(u8 **string, int q_num)
+{
+	ethtool_gsprintf(string, "rxq%d_packets", q_num);
+	ethtool_gsprintf(string, "rxq%d_bytes", q_num);
+	ethtool_gsprintf(string, "rxq%d_packets_with_error", q_num);
+	ethtool_gsprintf(string, "rxq%d_allocbuf_failed", q_num);
+	ethtool_gsprintf(string, "rxq%d_mapbuf_failed", q_num);
+	ethtool_gsprintf(string, "rxq%d_producer_index", q_num);
+	ethtool_gsprintf(string, "rxq%d_consumer_index", q_num);
+}
+
+static void bnad_get_txq_strings(u8 **string, int q_num)
+{
+	ethtool_gsprintf(string, "txq%d_packets", q_num);
+	ethtool_gsprintf(string, "txq%d_bytes", q_num);
+	ethtool_gsprintf(string, "txq%d_producer_index", q_num);
+	ethtool_gsprintf(string, "txq%d_consumer_index", q_num);
+	ethtool_gsprintf(string, "txq%d_hw_consumer_index", q_num);
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
+		ethtool_gsprintf(&string, bnad_net_stats_strings[i]);
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


