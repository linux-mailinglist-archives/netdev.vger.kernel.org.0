Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1299646E08E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhLICBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhLICBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:01:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDC1C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 17:57:33 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k64so4012075pfd.11
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 17:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AdeCej3J+6uy9p/0O/dEvGWH5KApNbQSo5i9Uiow35Q=;
        b=rRmQy3ng5cHjV01lvQ0zFI2WHmaPdUv8xT2ujk7K/B8xeLgOi2z5YOAYcrkD3+81Pg
         seoPXxl8m/IJMP9avBdRBz2jRO7YFSPwBY5bhMQId2n+niZQIH8WKPBjzCAFUjHRpKif
         nwgmihNC/sPNclsb9FibDXCCuy/M54MYO7Nck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AdeCej3J+6uy9p/0O/dEvGWH5KApNbQSo5i9Uiow35Q=;
        b=qwNM+OOE+59zZPY2ch3yo722rDYlNf2TNSfFrlyskMY2irdhqLw1EC6HebOPbratLJ
         D3HoqS1ph5xnkMCWjckEgFfixD6o8vmx3WTO3cj7T+IOsMOcyPlEFOX9kHtDGpOzfNN7
         Q5a6+kQDMOAUlC/sPr14NlH5a/tyTeeUUfocI/+VTgpHduZ0skb7lpngc+GAmWRihWE0
         9EmF7QwNBX1EGqR4VcZatqoprPQmyjdwNpLmLu6ggYpdUttOArlPBuKFKPdu7yHR6iaq
         4cItfMfYRCKFL5hbvCXBKKbdNmLJB3w7pjnqWGq9RoNR/BJd/0xszeIYbUGzXA6unnLL
         xzSA==
X-Gm-Message-State: AOAM531CoY8RIMjjTn6rRlnI1PphLDHhY1fBMGflbmVvgTaW0cvFW/my
        OSYT4v5yrPC6MHEARJB6TghEAV+q2CLhD7UvL/0SR9yf1WHaq+CmPtokt9n+PHcByWKZXzvTA/N
        O4o0x0IBbC7g5HLEeGI0mZaIlm0ggFDZXkcO8iO0wEzuoV/edfeuJOw9b0smxt2hJd/iEZUs=
X-Google-Smtp-Source: ABdhPJyA4KYIwA4nPe9PN+dBnkOwJvvUgTLonQRP/RyorYqBhVvRPaSLA7+d+xHPU7Sgu8QSQyQ5Pw==
X-Received: by 2002:a63:90c8:: with SMTP id a191mr32776644pge.400.1639015052891;
        Wed, 08 Dec 2021 17:57:32 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id f3sm4661739pfg.167.2021.12.08.17.57.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 17:57:32 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org,
        davem@davemloft.net, Joe Damato <jdamato@fastly.com>
Subject: [net v2] i40e: fix unsigned stat widths
Date:   Wed,  8 Dec 2021 17:56:33 -0800
Message-Id: <1639014993-89752-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <202112090744.QwfPrzIW-lkp@intel.com>
References: <202112090744.QwfPrzIW-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change i40e_update_vsi_stats and struct i40e_vsi to use u64 fields to match
the width of the stats counters in struct i40e_rx_queue_stats.

Update debugfs code to use the correct format specifier for u64.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 v1 -> v2: make tx_restart and tx_busy also u64, and fix format specifiers in
           debugfs code

 drivers/net/ethernet/intel/i40e/i40e.h         | 8 ++++----
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 4d939af..9a4c410 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -848,12 +848,12 @@ struct i40e_vsi {
 	struct rtnl_link_stats64 net_stats_offsets;
 	struct i40e_eth_stats eth_stats;
 	struct i40e_eth_stats eth_stats_offsets;
-	u32 tx_restart;
-	u32 tx_busy;
+	u64 tx_restart;
+	u64 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
-	u32 rx_buf_failed;
-	u32 rx_page_failed;
+	u64 rx_buf_failed;
+	u64 rx_page_failed;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 291e61a..c2c09dc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -240,7 +240,7 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 		 (unsigned long int)vsi->net_stats_offsets.rx_compressed,
 		 (unsigned long int)vsi->net_stats_offsets.tx_compressed);
 	dev_info(&pf->pdev->dev,
-		 "    tx_restart = %d, tx_busy = %d, rx_buf_failed = %d, rx_page_failed = %d\n",
+		 "    tx_restart = %llu, tx_busy = %llu, rx_buf_failed = %llu, rx_page_failed = %llu\n",
 		 vsi->tx_restart, vsi->tx_busy,
 		 vsi->rx_buf_failed, vsi->rx_page_failed);
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e118cf9..3352328 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -754,9 +754,9 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct rtnl_link_stats64 *ns;   /* netdev stats */
 	struct i40e_eth_stats *oes;
 	struct i40e_eth_stats *es;     /* device's eth stats */
-	u32 tx_restart, tx_busy;
+	u64 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u32 rx_page, rx_buf;
+	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
-- 
2.7.4

