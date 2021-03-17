Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2033E2CC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCQAcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhCQAb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:31:59 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CF7C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:59 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x9so230923qto.8
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ajh1+QbItc7CsqYtQsH4LdTlMDdkFsd6TJkeoaijHjM=;
        b=hzUSawBeHFdOg8Jqs1gwe17qiBs2ZQ/ZgbclHFNQK5cYqDDsRTe1gq5Pi+qbPauEQg
         rOuWfUg2dO2Dt8PoPuSwbxXzJf56o4ODaPkhNNLN6OVaTRI2qKt3eQ1he/A5Ja+Fvp9g
         9qGQT1b8uLbURGk/5PregpBYq7SKLIeEaLsEHB3R466aXy3pENHtYVj2I+CnlMz2+E53
         3s+5LiO1I3l1O4r2lDhAkzPsCMoYAnw8YdE+Ekiapu6g8WZnMc3YERk3nO4pv8UaUwrK
         UHVSEOvzigldjKfSixuMQYfT7zx4G0sahLbbn2GUKBDkr8FadOWg4loZRKoRjcOYomMG
         hntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ajh1+QbItc7CsqYtQsH4LdTlMDdkFsd6TJkeoaijHjM=;
        b=GaErNwYS9gUuf1QUJOhDKHIG4XlaS7xZENwU8AOIQ106HO28Pdplg7ds9g8PL+Cuv8
         ikuzjMHH3iWGabD8xA7DwD5YjoejgRTWwL+K9ooV2o0XvW0i6c1s4QEXqoMuteejxSDk
         FLxsgw2qvl694IVbB08Cwv1fpl44EAeQHhCe7/j9AaW5ey1dLBePqbNBF3s2tc9LL+Yu
         0nUhpzqqbq//11gLJw8rYSyQjywxXKG8umO0GGf+w4+cHA5K8qy2bUYWE2VfQUeLwHF2
         Zd3e84+jL+620Cq9QgRZRR9LAbaDfWLHnxxZhREc6r7qByoDcODuKfthDYaxTCfxgOoc
         JIVw==
X-Gm-Message-State: AOAM531PlLoj2G0sDW4KzlQZ5ITMwUtcQTzjg0nmlmxZvKGJlD+dfcyV
        NesnH3G87l52KfUZAQRVT9c=
X-Google-Smtp-Source: ABdhPJyycGqDdUPO/ARlPxw9Wcwk3LOLSzKnF0FRL0rMlZiSg7ev6OrpbAC2vu6oioWdu4Q/Qrk5Pg==
X-Received: by 2002:ac8:6b8a:: with SMTP id z10mr1421483qts.243.1615941118727;
        Tue, 16 Mar 2021 17:31:58 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id y19sm16392794qky.111.2021.03.16.17.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:58 -0700 (PDT)
Subject: [net-next PATCH v2 10/10] ionic: Update driver to use ethtool_sprintf
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
Date:   Tue, 16 Mar 2021 17:31:55 -0700
Message-ID: <161594111532.5644.3540447704803147733.stgit@localhost.localdomain>
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

Update the ionic driver to make use of ethtool_sprintf. In addition add
separate functions for Tx/Rx stats strings in order to reduce the total
amount of indenting needed in the driver code.

Acked-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_stats.c |  145 +++++++++------------
 1 file changed, 60 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 6ae75b771a15..308b4ac6c57b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -246,98 +246,73 @@ static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
 	return total;
 }
 
+static void ionic_sw_stats_get_tx_strings(struct ionic_lif *lif, u8 **buf,
+					  int q_num)
+{
+	int i;
+
+	for (i = 0; i < IONIC_NUM_TX_STATS; i++)
+		ethtool_sprintf(buf, "tx_%d_%s", q_num,
+				ionic_tx_stats_desc[i].name);
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++)
+		ethtool_sprintf(buf, "txq_%d_%s", q_num,
+				ionic_txq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
+		ethtool_sprintf(buf, "txq_%d_cq_%s", q_num,
+				ionic_dbg_cq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
+		ethtool_sprintf(buf, "txq_%d_intr_%s", q_num,
+				ionic_dbg_intr_stats_desc[i].name);
+	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++)
+		ethtool_sprintf(buf, "txq_%d_sg_cntr_%d", q_num, i);
+}
+
+static void ionic_sw_stats_get_rx_strings(struct ionic_lif *lif, u8 **buf,
+					  int q_num)
+{
+	int i;
+
+	for (i = 0; i < IONIC_NUM_RX_STATS; i++)
+		ethtool_sprintf(buf, "rx_%d_%s", q_num,
+				ionic_rx_stats_desc[i].name);
+
+	if (!test_bit(IONIC_LIF_F_UP, lif->state) ||
+	    !test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
+		return;
+
+	for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++)
+		ethtool_sprintf(buf, "rxq_%d_cq_%s", q_num,
+				ionic_dbg_cq_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++)
+		ethtool_sprintf(buf, "rxq_%d_intr_%s", q_num,
+				ionic_dbg_intr_stats_desc[i].name);
+	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++)
+		ethtool_sprintf(buf, "rxq_%d_napi_%s", q_num,
+				ionic_dbg_napi_stats_desc[i].name);
+	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++)
+		ethtool_sprintf(buf, "rxq_%d_napi_work_done_%d", q_num, i);
+}
+
 static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
 {
 	int i, q_num;
 
-	for (i = 0; i < IONIC_NUM_LIF_STATS; i++) {
-		snprintf(*buf, ETH_GSTRING_LEN, ionic_lif_stats_desc[i].name);
-		*buf += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < IONIC_NUM_LIF_STATS; i++)
+		ethtool_sprintf(buf, ionic_lif_stats_desc[i].name);
 
-	for (i = 0; i < IONIC_NUM_PORT_STATS; i++) {
-		snprintf(*buf, ETH_GSTRING_LEN,
-			 ionic_port_stats_desc[i].name);
-		*buf += ETH_GSTRING_LEN;
-	}
+	for (i = 0; i < IONIC_NUM_PORT_STATS; i++)
+		ethtool_sprintf(buf, ionic_port_stats_desc[i].name);
 
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
-			snprintf(*buf, ETH_GSTRING_LEN, "tx_%d_%s",
-				 q_num, ionic_tx_stats_desc[i].name);
-			*buf += ETH_GSTRING_LEN;
-		}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_tx_strings(lif, buf, q_num);
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_%s",
-					 q_num,
-					 ionic_txq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_cq_%s",
-					 q_num,
-					 ionic_dbg_cq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_intr_%s",
-					 q_num,
-					 ionic_dbg_intr_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "txq_%d_sg_cntr_%d",
-					 q_num, i);
-				*buf += ETH_GSTRING_LEN;
-			}
-		}
-	}
-	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
-			snprintf(*buf, ETH_GSTRING_LEN,
-				 "rx_%d_%s",
-				 q_num, ionic_rx_stats_desc[i].name);
-			*buf += ETH_GSTRING_LEN;
-		}
-
-		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
-		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_cq_%s",
-					 q_num,
-					 ionic_dbg_cq_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_intr_%s",
-					 q_num,
-					 ionic_dbg_intr_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_napi_%s",
-					 q_num,
-					 ionic_dbg_napi_stats_desc[i].name);
-				*buf += ETH_GSTRING_LEN;
-			}
-			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-				snprintf(*buf, ETH_GSTRING_LEN,
-					 "rxq_%d_napi_work_done_%d",
-					 q_num, i);
-				*buf += ETH_GSTRING_LEN;
-			}
-		}
-	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++)
+		ionic_sw_stats_get_rx_strings(lif, buf, q_num);
 }
 
 static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)


