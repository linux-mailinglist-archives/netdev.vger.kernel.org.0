Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212DA339579
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhCLRss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhCLRsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:35 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EDAC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:35 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 16so2362650pfn.5
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/fmQByPw8bQivbovRXAWRMKHXhCMytDK4lqB3q/bdmo=;
        b=doGB/4Pq9olMn5+PSqzBsBNpir0m4//YIyQZMLzAJyr5fZQD38kzJ5zr7xg1yMdW8I
         CJ3M/12T8OFVr1JB/iagyZrIpG8aJtm+NgxdncHKoEQLRRAt+rGmFiy0ZYT2W8Ufspu3
         WviEVoObgiMKlZxk4hCntNzNg05NvPvz3j0nFi2M9zqy4HJ1uXAAGmhhytfMamT/qG3I
         l1IZphpfcoC5REaVfLjVPJZ8mSLhP/DneAIeTxYV5quivHO3gvJy5wq1BW4yCIFduLIO
         9jMZraT8n4KI0vi+eukF3GnjLkzQBkQ8FiYRCNvWXBMxqI+ffIn4qYhRxYI3CzmDpYB7
         bfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/fmQByPw8bQivbovRXAWRMKHXhCMytDK4lqB3q/bdmo=;
        b=ekncjXoJh/ydWWMcwAPBftADS4h7SE0fpSzownOLRcpdtBSMjaLjo4iKtS/yTlIv5a
         dO/qYFur1CQNMpTjH9FH3/Am5dpsvl4DCm3AZQ1RvVeeFxPIsk60OunC7Vyq0i1f9c2R
         b9NyUgF+lwyh5NyMwDrDv+X8pmFzj4jV0zhqYgNuXOD+MjavWnfp7GPnfPbOtU732v9n
         kYEtoJf1KpekS67MR7jYtrUFtdBjyE4gniIKkEGzfdavcmQwCyEEPVnW5XPuYVEI96hB
         AsQebJLynw/TS7KQVer2X8vFo57BR7KSS85HGWlSk+Y7BU5Thbo3tWY24sXeselIWWFm
         MzEg==
X-Gm-Message-State: AOAM530oWyIBinfFV+rcJddbzKcQLVT/c/5lvUFWf5sTToFazd9482A4
        nycziQ7gfQTtpOQARGQEtnQ=
X-Google-Smtp-Source: ABdhPJzwCDLntiM5dSt1+MTZChYcpHx2hjhmdHzHuIgYCZ5X80nvDeDB0sd3JmYJDfPTR6ROAP4UUA==
X-Received: by 2002:a63:5a0c:: with SMTP id o12mr12664925pgb.76.1615571314900;
        Fri, 12 Mar 2021 09:48:34 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id h14sm2822675pjc.37.2021.03.12.09.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:34 -0800 (PST)
Subject: [net-next PATCH 05/10] ena: Update driver to use ethtool_sprintf
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
Date:   Fri, 12 Mar 2021 09:48:33 -0800
Message-ID: <161557131360.10304.1549281998235246752.stgit@localhost.localdomain>
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

Replace instances of snprintf or memcpy with a pointer update with
ethtool_sprintf.

Acked-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d6cc7aa612b7..2fe7ccee55b2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -251,10 +251,10 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
 
-			snprintf(*data, ETH_GSTRING_LEN,
-				 "queue_%u_%s_%s", i,
-				 is_xdp ? "xdp_tx" : "tx", ena_stats->name);
-			(*data) += ETH_GSTRING_LEN;
+			ethtool_sprintf(data,
+					"queue_%u_%s_%s", i,
+					is_xdp ? "xdp_tx" : "tx",
+					ena_stats->name);
 		}
 
 		if (!is_xdp) {
@@ -264,9 +264,9 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 			for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
 				ena_stats = &ena_stats_rx_strings[j];
 
-				snprintf(*data, ETH_GSTRING_LEN,
-					 "queue_%u_rx_%s", i, ena_stats->name);
-				(*data) += ETH_GSTRING_LEN;
+				ethtool_sprintf(data,
+						"queue_%u_rx_%s", i,
+						ena_stats->name);
 			}
 		}
 	}
@@ -280,9 +280,8 @@ static void ena_com_dev_strings(u8 **data)
 	for (i = 0; i < ENA_STATS_ARRAY_ENA_COM; i++) {
 		ena_stats = &ena_stats_ena_com_strings[i];
 
-		snprintf(*data, ETH_GSTRING_LEN,
-			 "ena_admin_q_%s", ena_stats->name);
-		(*data) += ETH_GSTRING_LEN;
+		ethtool_sprintf(data,
+				"ena_admin_q_%s", ena_stats->name);
 	}
 }
 
@@ -295,15 +294,13 @@ static void ena_get_strings(struct ena_adapter *adapter,
 
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
-		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
-		data += ETH_GSTRING_LEN;
+		ethtool_sprintf(&data, ena_stats->name);
 	}
 
 	if (eni_stats_needed) {
 		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
 			ena_stats = &ena_stats_eni_strings[i];
-			memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
-			data += ETH_GSTRING_LEN;
+			ethtool_sprintf(&data, ena_stats->name);
 		}
 	}
 


