Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64C63369C3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhCKBgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhCKBfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:47 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376E7C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:47 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a8so2911541plp.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mXovWmaN3OxpZPX5auZkxx4/rCgtSqTeDRTaO9fib40=;
        b=ToOsEVKUaEJN7rGfFWFJCslgbWhCmFi9RGkpAlGO+tSSM5B/GXFf76/ZnyQ4/RhAgc
         VtEHpSYBHokqiRmCDJp6imbfYGTtbyB1p1TXnLgmrxkCy70wwXuTCtYtJ+ySed2nudZy
         JeeLI15RTK+xiTDjcBVXHzvSO9DiaIRaAg8R6n0OIAuJ3b/zdT8jRCoR+JVkt81ANp98
         5Ra032Ybrx+aPFJlnDXpeYyNuVS+HXWqo/5HcQGOeEZsqSM527Avh1X0hNam+vjI346K
         y5Rwhj4pH9IAuY8LeKfWWUNghYp1jhhboqNFgTGM7/RBZamEHsMrCHQZvonyBdVgQbh6
         AHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mXovWmaN3OxpZPX5auZkxx4/rCgtSqTeDRTaO9fib40=;
        b=f1KFZxFHiRt4efXrvdM7b1u8FU70x1NPowKUZ1vSaLAzufUjcjV0iG5hx8tC9csXOK
         CrbRU9tCRBm7pq31ChG+0FHSJB8+YMFwG3ekWOGD8xwyTKziKvhdnfLmWS6IJgBUQ7IA
         kP9R8Av91LR+aS+6kOS+HaI3EPPG5hIY+MFESISCaWRjqstvv1OBEskGLx+1UelWNhx5
         mwRhHhBQBCs7jew/2YSOMFZIilZZ1zaTjeiAJ+M26AyajwsetTjvXFAA/UoCOLR0ZgDM
         wEsbq4d3EnTUtb3WR1117nu8qjdKYZKyciV6WGs8+yBfI6YRwbCaXOh2DPl3nS4XYkvL
         O1hA==
X-Gm-Message-State: AOAM530ufa9UwMLS7Xzf/21sozwOKoCkYQU7X5f6ULBbzhkypyNl94P7
        c3wMWip2coHJOMX0kABJPkY=
X-Google-Smtp-Source: ABdhPJw3VkZ7T0dpW+GqubGyANkwxTUpfkfw2teOdE71KvR/qSufUQ5TTETgX+4yaNtpnGf+xdV0aw==
X-Received: by 2002:a17:902:b711:b029:e3:71f1:e08e with SMTP id d17-20020a170902b711b02900e371f1e08emr5887183pls.18.1615426546679;
        Wed, 10 Mar 2021 17:35:46 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id y22sm652996pfn.32.2021.03.10.17.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:46 -0800 (PST)
Subject: [RFC PATCH 05/10] ena: Update driver to use ethtool_gsprintf
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
Date:   Wed, 10 Mar 2021 17:35:45 -0800
Message-ID: <161542654541.13546.817443057977441498.stgit@localhost.localdomain>
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

Replace instances of snprintf or memcpy with a pointer update with
ethtool_gsprintf.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d6cc7aa612b7..42f6bad7ca26 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -251,10 +251,10 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
 			ena_stats = &ena_stats_tx_strings[j];
 
-			snprintf(*data, ETH_GSTRING_LEN,
-				 "queue_%u_%s_%s", i,
-				 is_xdp ? "xdp_tx" : "tx", ena_stats->name);
-			(*data) += ETH_GSTRING_LEN;
+			ethtool_gsprintf(data,
+					 "queue_%u_%s_%s", i,
+					 is_xdp ? "xdp_tx" : "tx",
+					 ena_stats->name);
 		}
 
 		if (!is_xdp) {
@@ -264,9 +264,9 @@ static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
 			for (j = 0; j < ENA_STATS_ARRAY_RX; j++) {
 				ena_stats = &ena_stats_rx_strings[j];
 
-				snprintf(*data, ETH_GSTRING_LEN,
-					 "queue_%u_rx_%s", i, ena_stats->name);
-				(*data) += ETH_GSTRING_LEN;
+				ethtool_gsprintf(data,
+						 "queue_%u_rx_%s", i,
+						 ena_stats->name);
 			}
 		}
 	}
@@ -280,9 +280,8 @@ static void ena_com_dev_strings(u8 **data)
 	for (i = 0; i < ENA_STATS_ARRAY_ENA_COM; i++) {
 		ena_stats = &ena_stats_ena_com_strings[i];
 
-		snprintf(*data, ETH_GSTRING_LEN,
-			 "ena_admin_q_%s", ena_stats->name);
-		(*data) += ETH_GSTRING_LEN;
+		ethtool_gsprintf(data,
+				 "ena_admin_q_%s", ena_stats->name);
 	}
 }
 
@@ -295,15 +294,13 @@ static void ena_get_strings(struct ena_adapter *adapter,
 
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
-		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
-		data += ETH_GSTRING_LEN;
+		ethtool_gsprintf(&data, ena_stats->name);
 	}
 
 	if (eni_stats_needed) {
 		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
 			ena_stats = &ena_stats_eni_strings[i];
-			memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
-			data += ETH_GSTRING_LEN;
+			ethtool_gsprintf(&data, ena_stats->name);
 		}
 	}
 


