Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F423369BE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCKBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhCKBfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F11C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:34 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id bt4so2642305pjb.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=m0otFb6AnbGVYV3zd44lNY0Yw52LsGJQVA35MU39ENQ=;
        b=oCWmMkJsohBdbkUZC13x+MCZXzTqrLkYxBmmsvDUDSDQGyKbx7wOL1HDxjO7bV1oRc
         1W2ex2sKISR0ZH0wMLEQyMa7pUMIPBrHdjbcCfHXDhjyBr7yM3DbISSdwEhNgBGLxyPt
         oespJ0WVHUM1jrCIVlOhdwPSTzfFy1Q6hiwLLC7yie0fq/XbwVTxhygY0/+PHcZtCf1u
         Aw+ZhoUuwjZ2dZw+cVPRJrmmoFTc9HFTvZOpNfzKiblXKiG2/jUHHJWQdaP7VQFBY9yX
         FmQcCT3yof+Zf8PI7KdJhPXZjWgSW8qvFQ8moNm24SrqwWAuyWGGyukvsfUBnJituFG5
         woUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m0otFb6AnbGVYV3zd44lNY0Yw52LsGJQVA35MU39ENQ=;
        b=eNl0wpINISHNUKQxJjQgg4IhyRSlTNxKzmaXBYY7f2bI35hmIB+SEXLE4UNxw2OtR8
         lA8Z6ulO5k0lvLmecI4O8sD+nsxcDxozykwb0TSv4LCIijwyk15w6WgDt1a03I3opO7Y
         tUV8LQgzF1O4rCvHziuAu9pnsFh0KIDX93QqqCkKIOkoOe9xGX4ok0Ab2euuwMSxBO6g
         xQjw/iUmVLI6N1JwdiFXNn7hmJC0FTrzX0xXIQaQdi3OgFzhj1pGvWjkYmcCTBe8MBMy
         7EPeBKlEzUC7JZfbwbHMNLjmHy5jFiviSfD/4F00Auw7H0/ghTSmzo73AbjKDs7cP1NY
         wwvw==
X-Gm-Message-State: AOAM531mZoFjpNJuS4vuCnUiRG90LfY09UpyTvGa14hztF4gUdL2BYEP
        z1gnEjKcQ/V9w6QCTZ0y4u8=
X-Google-Smtp-Source: ABdhPJwpZiATauy1Mu+EyfJ1ZAR7zYSpBFBLue2naiFUkl0t0kpxN3GpttbJXJpe6ntHh01Wnvp5dA==
X-Received: by 2002:a17:90a:17c3:: with SMTP id q61mr6183465pja.58.1615426533904;
        Wed, 10 Mar 2021 17:35:33 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z22sm651021pfa.41.2021.03.10.17.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:33 -0800 (PST)
Subject: [RFC PATCH 03/10] nfp: Replace nfp_pr_et with ethtool_gsprintf
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
Date:   Wed, 10 Mar 2021 17:35:32 -0800
Message-ID: <161542653266.13546.11914667071718045956.stgit@localhost.localdomain>
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

The nfp_pr_et function is nearly identical to ethtool_gsprintf except for
the fact that it passes the pointer by value and as a return whereas
ethtool_gsprintf passes it as a pointer.

Since they are so close just update nfp to make use of ethtool_gsprintf

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c      |    4 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   79 +++++++++-----------
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |    2 -
 3 files changed, 36 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index bdbf0726145e..3e8a9a7d7327 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -419,8 +419,8 @@ nfp_abm_port_get_stats_strings(struct nfp_app *app, struct nfp_port *port,
 		return data;
 	alink = repr->app_priv;
 	for (i = 0; i < alink->vnic->dp.num_r_vecs; i++) {
-		data = nfp_pr_et(data, "q%u_no_wait", i);
-		data = nfp_pr_et(data, "q%u_delayed", i);
+		ethtool_gsprintf(&data, "q%u_no_wait", i);
+		ethtool_gsprintf(&data, "q%u_delayed", i);
 	}
 	return data;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 9c9ae33d84ce..33097c411d7d 100644
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
+		ethtool_gsprintf(&data, "rvec_%u_rx_pkts", i);
+		ethtool_gsprintf(&data, "rvec_%u_tx_pkts", i);
+		ethtool_gsprintf(&data, "rvec_%u_tx_busy", i);
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
+	ethtool_gsprintf(&data, "hw_rx_csum_ok");
+	ethtool_gsprintf(&data, "hw_rx_csum_inner_ok");
+	ethtool_gsprintf(&data, "hw_rx_csum_complete");
+	ethtool_gsprintf(&data, "hw_rx_csum_err");
+	ethtool_gsprintf(&data, "rx_replace_buf_alloc_fail");
+	ethtool_gsprintf(&data, "rx_tls_decrypted_packets");
+	ethtool_gsprintf(&data, "hw_tx_csum");
+	ethtool_gsprintf(&data, "hw_tx_inner_csum");
+	ethtool_gsprintf(&data, "tx_gather");
+	ethtool_gsprintf(&data, "tx_lso");
+	ethtool_gsprintf(&data, "tx_tls_encrypted_packets");
+	ethtool_gsprintf(&data, "tx_tls_ooo");
+	ethtool_gsprintf(&data, "tx_tls_drop_no_sync_data");
+
+	ethtool_gsprintf(&data, "hw_tls_no_space");
+	ethtool_gsprintf(&data, "rx_tls_resync_req_ok");
+	ethtool_gsprintf(&data, "rx_tls_resync_req_ign");
+	ethtool_gsprintf(&data, "rx_tls_resync_sent");
 
 	return data;
 }
@@ -550,19 +539,19 @@ nfp_vnic_get_hw_stats_strings(u8 *data, unsigned int num_vecs, bool repr)
 	swap_off = repr * NN_ET_SWITCH_STATS_LEN;
 
 	for (i = 0; i < NN_ET_SWITCH_STATS_LEN; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i + swap_off].name);
+		ethtool_gsprintf(&data, nfp_net_et_stats[i + swap_off].name);
 
 	for (i = NN_ET_SWITCH_STATS_LEN; i < NN_ET_SWITCH_STATS_LEN * 2; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i - swap_off].name);
+		ethtool_gsprintf(&data, nfp_net_et_stats[i - swap_off].name);
 
 	for (i = NN_ET_SWITCH_STATS_LEN * 2; i < NN_ET_GLOBAL_STATS_LEN; i++)
-		data = nfp_pr_et(data, nfp_net_et_stats[i].name);
+		ethtool_gsprintf(&data, nfp_net_et_stats[i].name);
 
 	for (i = 0; i < num_vecs; i++) {
-		data = nfp_pr_et(data, "rxq_%u_pkts", i);
-		data = nfp_pr_et(data, "rxq_%u_bytes", i);
-		data = nfp_pr_et(data, "txq_%u_pkts", i);
-		data = nfp_pr_et(data, "txq_%u_bytes", i);
+		ethtool_gsprintf(&data, "rxq_%u_pkts", i);
+		ethtool_gsprintf(&data, "rxq_%u_bytes", i);
+		ethtool_gsprintf(&data, "txq_%u_pkts", i);
+		ethtool_gsprintf(&data, "txq_%u_bytes", i);
 	}
 
 	return data;
@@ -610,15 +599,15 @@ static u8 *nfp_vnic_get_tlv_stats_strings(struct nfp_net *nn, u8 *data)
 			memcpy(data, nfp_tlv_stat_names[id], ETH_GSTRING_LEN);
 			data += ETH_GSTRING_LEN;
 		} else {
-			data = nfp_pr_et(data, "dev_unknown_stat%u", id);
+			ethtool_gsprintf(&data, "dev_unknown_stat%u", id);
 		}
 	}
 
 	for (i = 0; i < nn->max_r_vecs; i++) {
-		data = nfp_pr_et(data, "rxq_%u_pkts", i);
-		data = nfp_pr_et(data, "rxq_%u_bytes", i);
-		data = nfp_pr_et(data, "txq_%u_pkts", i);
-		data = nfp_pr_et(data, "txq_%u_bytes", i);
+		ethtool_gsprintf(&data, "rxq_%u_pkts", i);
+		ethtool_gsprintf(&data, "rxq_%u_bytes", i);
+		ethtool_gsprintf(&data, "txq_%u_pkts", i);
+		ethtool_gsprintf(&data, "txq_%u_bytes", i);
 	}
 
 	return data;
@@ -666,7 +655,7 @@ static u8 *nfp_mac_get_stats_strings(struct net_device *netdev, u8 *data)
 		return data;
 
 	for (i = 0; i < ARRAY_SIZE(nfp_mac_et_stats); i++)
-		data = nfp_pr_et(data, "mac.%s", nfp_mac_et_stats[i].name);
+		ethtool_gsprintf(&data, "mac.%s", nfp_mac_et_stats[i].name);
 
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
 


