Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94AA339578
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhCLRsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhCLRsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:22 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A4BC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:22 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t37so5542140pga.11
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=llWoi5Oz4cqtzO38dPbZfnNzhy8uG4ghtKaDmv3GSRM=;
        b=WnSlDqAqXtR0LthE2q/iuHQ6lBIBCK4FZ6IsZbWElT+Ly9IUQ5XBuwutVu30z89tVb
         dCS3JwcowOsiMSXZC/ql/KAin+Fj0EZC6SthZTN+SeH7ucKmLc2qapN1MefUxPnTGfTG
         u/X5Ra6doePLRclrbHM3lBdaLPWSyB1BdZv6JKTnwidcbqj/+GPPir030wVYnWD6RvjC
         N3t3v8dGOI1CFbAjDwLwBFc8I24mtNAUuoJbjJ8BD5Yg4Cd05amg3sbie+7Zl7Z4YEwi
         DYCf+M1hYfjwvg+HPaVRzIjP/xHbj9SIp0hZK0u3mNbHZNIiOQv6A44jZfjbeM6xB+k1
         7c/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=llWoi5Oz4cqtzO38dPbZfnNzhy8uG4ghtKaDmv3GSRM=;
        b=rWvEO3+dyo+Jt8SYZ9dZFMNKgwQxUBoA2Lka2xFtAY5CPdx9Zh1kQfIAukIMfJEvLD
         dbhyj7elqxLouR2sEqMG5VylyLWdltn+e4tV4rLpcH7y2qLWvLdrNQ6wgflNP6smZBLY
         /ogemjptouXrKb6H8o9LwWdz4JsmOAWiLH/0o+G65RqjzWRNKCz7X0PUyz9XpxBajXS/
         nzFKTRoivSD4rNetWGKr6Mxff1R+Y2qWcjN7dZNeAlzzpQw1yvTAF3bKaofr9ufnR1jj
         9JiSJ6DwMrpVBqqAMdVWr+dxq4oi1IzNjW5d+BtlFUUfVNf6rBxlHYxFJp9e6yfM8+vU
         BE/A==
X-Gm-Message-State: AOAM530EWBVEuavE5l5Y6Y/GWJnuCbfXf+HY7CPVM5j5CyIPIQhsvSE8
        mttWIrLbQNCM5QA4XhQKK7A=
X-Google-Smtp-Source: ABdhPJxVDDkL5KGlILgrWCnDHWJmzwgmWA38S03XsAJqobBbSgELPmcoimEldcJSwSQPXq/fA6f8Gg==
X-Received: by 2002:a65:498b:: with SMTP id r11mr11805842pgs.364.1615571301919;
        Fri, 12 Mar 2021 09:48:21 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 186sm6660147pfb.143.2021.03.12.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:21 -0800 (PST)
Subject: [net-next PATCH 03/10] nfp: Replace nfp_pr_et with ethtool_sprintf
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
Date:   Fri, 12 Mar 2021 09:48:20 -0800
Message-ID: <161557130065.10304.17172554185031988114.stgit@localhost.localdomain>
In-Reply-To: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

The nfp_pr_et function is nearly identical to ethtool_sprintf except for
the fact that it passes the pointer by value and as a return whereas
ethtool_sprintf passes it as a pointer.

Since they are so close just update nfp to make use of ethtool_sprintf

Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c      |    4 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   79 +++++++++-----------
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |    2 -
 3 files changed, 36 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index bdbf0726145e..605a1617b195 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -419,8 +419,8 @@ nfp_abm_port_get_stats_strings(struct nfp_app *app, struct nfp_port *port,
 		return data;
 	alink = repr->app_priv;
 	for (i = 0; i < alink->vnic->dp.num_r_vecs; i++) {
-		data = nfp_pr_et(data, "q%u_no_wait", i);
-		data = nfp_pr_et(data, "q%u_delayed", i);
+		ethtool_sprintf(&data, "q%u_no_wait", i);
+		ethtool_sprintf(&data, "q%u_delayed", i);
 	}
 	return data;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 9c9ae33d84ce..1b482446536d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -429,17 +429,6 @@ static int nfp_net_set_ringparam(struct net_device *netdev,
 	return nfp_net_set_ring_size(nn, rxd_cnt, txd_cnt);
 }
 
-__printf(2, 3) u8 *nfp_pr_et(u8 *data, const char *fmt, ...)
-{
-	va_list args;
-
-	va_start(args, fmt);
-	vsnprintf(data, ETH_GSTRING_LEN, fmt, args);
-	va_end(args);
-
-	return data + ETH_GSTRING_LEN;
-}
-
 static unsigned int nfp_vnic_get_sw_stats_count(struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -454,29 +443,29 @@ static u8 *nfp_vnic_get_sw_stats_strings(struct net_device *netdev, u8 *data)
 	int i;
 
 	for (i = 0; i < nn->max_r_vecs; i++) {
-		data = nfp_pr_et(data, "rvec_%u_rx_pkts", i);
-		data = nfp_pr_et(data, "rvec_%u_tx_pkts", i);
-		data = nfp_pr_et(data, "rvec_%u_tx_busy", i);
+		ethtool_sprintf(&data, "rvec_%u_rx_pkts", i);
+		ethtool_sprintf(&data, "rvec_%u_tx_pkts", i);
+		ethtool_sprintf(&data, "rvec_%u_tx_busy", i);
 	}
 
-	data = nfp_pr_et(data, "hw_rx_csum_ok");
-	data = nfp_pr_et(data, "hw_rx_csum_inner_ok");
-	data = nfp_pr_et(data, "hw_rx_csum_complete");
-	data = nfp_pr_et(data, "hw_rx_csum_err");
-	data = nfp_pr_et(data, "rx_replace_buf_alloc_fail");
-	data = nfp_pr_et(data, "rx_tls_decrypted_packets");
-	data = nfp_pr_et(data, "hw_tx_csum");
-	data = nfp_pr_et(data, "hw_tx_inner_csum");
-	data = nfp_pr_et(data, "tx_gather");
-	data = nfp_pr_et(data, "tx_lso");
-	data = nfp_pr_et(data, "tx_tls_encrypted_packets");
-	data = nfp_pr_et(data, "tx_tls_ooo");
-	data = nfp_pr_et(data, "tx_tls_drop_no_sync_data");
-
-	data = nfp_pr_et(data, "hw_tls_no_space");
-	data = nfp_pr_et(data, "rx_tls_resync_req_ok");
-	data = nfp_pr_et(data, "rx_tls_resync_req_ign");
-	data = nfp_pr_et(data, "rx_tls_resync_sent");
+	ethtool_sprintf(&data, "hw_rx_csum_ok");
+	ethtool_sprintf(&data, "hw_rx_csum_inner_ok");
+	ethtool_sprintf(&data, "hw_rx_csum_complete");
+	ethtool_sprintf(&data, "hw_rx_csum_err");
+	ethtool_sprintf(&data, "rx_replace_buf_alloc_fail");
+	ethtool_sprintf(&data, "rx_tls_decrypted_packets");
+	ethtool_sprintf(&data, "hw_tx_csum");
+	ethtool_sprintf(&data, "hw_tx_inner_csum");
+	ethtool_sprintf(&data, "tx_gather");
+	ethtool_sprintf(&data, "tx_lso");
+	ethtool_sprintf(&data, "tx_tls_encrypted_packets");
+	ethtool_sprintf(&data, "tx_tls_ooo");
+	ethtool_sprintf(&data, "tx_tls_drop_no_sync_data");
+
+	ethtool_sprintf(&data, "hw_tls_no_space");
+	ethtool_sprintf(&data, "rx_tls_resync_req_ok");
+	ethtool_sprintf(&data, "rx_tls_resync_req_ign");
+	ethtool_sprintf(&data, "rx_tls_resync_sent");
 
 	return data;
 }
@@ -550,19 +539,19 @@ nfp_vnic_get_hw_stats_strings(u8 *data, unsigned int num_vecs, bool repr)
 	swap_off = repr * NN_ET_SWITCH_STATS_LEN;
 
 	for (i = 0; i < NN_ET_SWITCH_STATS_LEN; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i + swap_off].name);
+		ethtool_sprintf(&data, nfp_net_et_stats[i + swap_off].name);
 
 	for (i = NN_ET_SWITCH_STATS_LEN; i < NN_ET_SWITCH_STATS_LEN * 2; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i - swap_off].name);
+		ethtool_sprintf(&data, nfp_net_et_stats[i - swap_off].name);
 
 	for (i = NN_ET_SWITCH_STATS_LEN * 2; i < NN_ET_GLOBAL_STATS_LEN; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i].name);
+		ethtool_sprintf(&data, nfp_net_et_stats[i].name);
 
 	for (i = 0; i < num_vecs; i++) {
-		data = nfp_pr_et(data, "rxq_%u_pkts", i);
-		data = nfp_pr_et(data, "rxq_%u_bytes", i);
-		data = nfp_pr_et(data, "txq_%u_pkts", i);
-		data = nfp_pr_et(data, "txq_%u_bytes", i);
+		ethtool_sprintf(&data, "rxq_%u_pkts", i);
+		ethtool_sprintf(&data, "rxq_%u_bytes", i);
+		ethtool_sprintf(&data, "txq_%u_pkts", i);
+		ethtool_sprintf(&data, "txq_%u_bytes", i);
 	}
 
 	return data;
@@ -610,15 +599,15 @@ static u8 *nfp_vnic_get_tlv_stats_strings(struct nfp_net *nn, u8 *data)
 			memcpy(data, nfp_tlv_stat_names[id], ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		} else {
-			data = nfp_pr_et(data, "dev_unknown_stat%u", id);
+			ethtool_sprintf(&data, "dev_unknown_stat%u", id);
 		}
 	}
 
 	for (i = 0; i < nn->max_r_vecs; i++) {
-		data = nfp_pr_et(data, "rxq_%u_pkts", i);
-		data = nfp_pr_et(data, "rxq_%u_bytes", i);
-		data = nfp_pr_et(data, "txq_%u_pkts", i);
-		data = nfp_pr_et(data, "txq_%u_bytes", i);
+		ethtool_sprintf(&data, "rxq_%u_pkts", i);
+		ethtool_sprintf(&data, "rxq_%u_bytes", i);
+		ethtool_sprintf(&data, "txq_%u_pkts", i);
+		ethtool_sprintf(&data, "txq_%u_bytes", i);
 	}
 
 	return data;
@@ -666,7 +655,7 @@ static u8 *nfp_mac_get_stats_strings(struct net_device *netdev, u8 *data)
 		return data;
 
 	for (i = 0; i < ARRAY_SIZE(nfp_mac_et_stats); i++)
-		data = nfp_pr_et(data, "mac.%s", nfp_mac_et_stats[i].name);
+		ethtool_sprintf(&data, "mac.%s", nfp_mac_et_stats[i].name);
 
 	return data;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index d7fd203bb180..ae4da189d955 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -92,8 +92,6 @@ struct nfp_port {
 
 extern const struct ethtool_ops nfp_port_ethtool_ops;
 
-__printf(2, 3) u8 *nfp_pr_et(u8 *data, const char *fmt, ...);
-
 int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		      void *type_data);
 


