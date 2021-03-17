Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9633E2B8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCQAbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhCQAbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:31:16 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B8C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:15 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id o19so657628qvu.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/fmQByPw8bQivbovRXAWRMKHXhCMytDK4lqB3q/bdmo=;
        b=n+uQdxVuaNhHFBJNWvmEEkGGnHS/R4bUlnTEtc+xTWW1ONRcsPTe992ede/yUNW34m
         182fsVXPuNt7XWZ4KACbv9GrzifWqpZNoI+kqB1c6p0OFFW0YvxViUNsJwmvBq9wwNuL
         YpZia33RgryInSx6JsFdCbhSgdFUar6uUEgxgFPDWentPbFfl17x4/s3Z+kGi0k2istI
         oiAUX3K8fGL8TSHb5jicjMaZsgdL8nwhihVbaXWWdXa0qZAUaxXbLIOhSg3V+lmyYoCB
         H2xZutX3HBXXoNNYnRB10CtiuA5StArEG/tGwY0mlLNhp9Tw8J90BdmpczIO2m19vXzd
         LSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/fmQByPw8bQivbovRXAWRMKHXhCMytDK4lqB3q/bdmo=;
        b=hbCKLMSaIc1HQnuk0btbK2mlOZFdB+4V1BUfXD7tOKZKOWlXhHmWr+zNiF+ttXhDCY
         qrfLNJZTo+EKboq6ASwVyopBySACyrNLroE/L0zRaddHLJQh4agvSkuG1I4e/OPNFqk4
         rwONJRe2DpSFloPW4zob7NtZcBaPr8tGGVAPT2IyQjeG0pvYMODrXDdjngF5O9d5WsKE
         4Hc5qpFIL/+eAxiX+2S5kGorfahMOPid/U06pe4kyMbxmvJy02pE0wWNPUR1S3vgb6az
         6Wlsfuy234H7VabM+d3rQoK03lCf9d9yVDv2NEfLTC3GoDADPnvyvTPiM0kz9YxR/JrU
         gAhw==
X-Gm-Message-State: AOAM531GlvLiiUs1e/qpHLdKPLdufK0FB1E6D8b/lHVrpAOtZHSBsMvz
        1XbkbVX51h1gZE+ymJ0FHRw=
X-Google-Smtp-Source: ABdhPJyjK1/UQOEiXjOHksu08G+HarLa/XO9go12IH74RhFX1QIOPe93QQ8q7ZLyB88iiJc+An0kZg==
X-Received: by 2002:a0c:cb0c:: with SMTP id o12mr2690738qvk.54.1615941075148;
        Tue, 16 Mar 2021 17:31:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o125sm1730675qkf.87.2021.03.16.17.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:14 -0700 (PDT)
Subject: [net-next PATCH v2 05/10] ena: Update driver to use ethtool_sprintf
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
Date:   Tue, 16 Mar 2021 17:31:11 -0700
Message-ID: <161594107181.5644.15922720616568884335.stgit@localhost.localdomain>
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
 


