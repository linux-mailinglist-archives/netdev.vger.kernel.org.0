Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1018C42B8DE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhJMHVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbhJMHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:20:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB23C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p13so6297589edw.0
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 00:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=LanR1i/jLsmAYTFwokdAovmWU5V1IgQOn7DGsNQxptrH1rXx2irbNV7tr6koSM4u5b
         ZtSofIF3wJ/d0YnTRLIM9NYZR8TAzjxjXlkoV+JrdlWtbyv4yhd9XAD6TCOkuu/IJjLP
         /JX2/SYKtj6UQYyQZc2BmIxSRjwZZTUodhunkF983zVT8JJs5C3XW9IIBdYz6wO8p8hf
         WUnxOqhvC5Q0iKrOyOxV285Vj0YNH2SW/ndh37Ni7sJ1DrT5OqzikpJezzhTSq79KYvP
         Re953GUUNr5ovVQs12DMPW8YAtMnzNOq7gG9+AVAUCBfVkK/RUWM3I6CEgq+//iyl1PK
         x69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=Py4rOPNElPIe6nxW00hzBKdesBbf0p3yN+2TIbuoqziLrr3P1AlDxqJrOxUBO8P5We
         eGcSTVJ+vx9NyFGr9tmdj/MzGsjbtZO2wW8ei+mBloJgxmEH23h+j23Malu3oLAZPftv
         HV4eia0gdLcpQZEePXsZS7yXTf1wyzgwzbg9sHZSqJraXP72fX2mTXgrxZCzk/MlPYvs
         vHWI+bYJBNlQJUF12FRUpm8BKJDxNreFVTmSNafr2HTQsPpMFWF+HTn4cAX4I72uSTOo
         Ho85NSokvSHRbyW9+cw99hOpE0oQM0cfUI2BhcTEnDmxCs7xTDESaQspCGRYp0Xo0z8/
         o3cQ==
X-Gm-Message-State: AOAM530cWy9kIp+xxNJ4tumFPw7i6PCvuiUzC1WIKRL8g+3vn0+vNSnA
        ZIdFHhxq3e/8/HOg/QMbRDI=
X-Google-Smtp-Source: ABdhPJzor9o478DV6DeLHCDydcB9hF5OEEAmPoN2viKapFSJ/J+l5QuDHam4xNzg412faqgFYIRkIQ==
X-Received: by 2002:a17:906:26c4:: with SMTP id u4mr37236958ejc.511.1634109482708;
        Wed, 13 Oct 2021 00:18:02 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id f7sm2935886edl.33.2021.10.13.00.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:18:02 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next RESEND 1/4] igb: move SDP config initialization to separate function
Date:   Wed, 13 Oct 2021 09:15:28 +0200
Message-Id: <20211013071531.1145-2-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013071531.1145-1-kernel.hbk@gmail.com>
References: <20211013071531.1145-1-kernel.hbk@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow reuse of SDP config struct initialization by moving it to a
separate function.

Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 27 +++++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 0011b15e678c..c78d0c2a5341 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -69,6 +69,7 @@
 #define IGB_NBITS_82580			40
 
 static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter);
+static void igb_ptp_sdp_init(struct igb_adapter *adapter);
 
 /* SYSTIM read access for the 82576 */
 static u64 igb_ptp_read_82576(const struct cyclecounter *cc)
@@ -1192,7 +1193,6 @@ void igb_ptp_init(struct igb_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
-	int i;
 
 	switch (hw->mac.type) {
 	case e1000_82576:
@@ -1233,13 +1233,7 @@ void igb_ptp_init(struct igb_adapter *adapter)
 		break;
 	case e1000_i210:
 	case e1000_i211:
-		for (i = 0; i < IGB_N_SDP; i++) {
-			struct ptp_pin_desc *ppd = &adapter->sdp_config[i];
-
-			snprintf(ppd->name, sizeof(ppd->name), "SDP%d", i);
-			ppd->index = i;
-			ppd->func = PTP_PF_NONE;
-		}
+		igb_ptp_sdp_init(adapter);
 		snprintf(adapter->ptp_caps.name, 16, "%pm", netdev->dev_addr);
 		adapter->ptp_caps.owner = THIS_MODULE;
 		adapter->ptp_caps.max_adj = 62499999;
@@ -1284,6 +1278,23 @@ void igb_ptp_init(struct igb_adapter *adapter)
 	}
 }
 
+/**
+ * igb_ptp_sdp_init - utility function which inits the SDP config structs
+ * @adapter: Board private structure.
+ **/
+void igb_ptp_sdp_init(struct igb_adapter *adapter)
+{
+	int i;
+
+	for (i = 0; i < IGB_N_SDP; i++) {
+		struct ptp_pin_desc *ppd = &adapter->sdp_config[i];
+
+		snprintf(ppd->name, sizeof(ppd->name), "SDP%d", i);
+		ppd->index = i;
+		ppd->func = PTP_PF_NONE;
+	}
+}
+
 /**
  * igb_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
-- 
2.30.2

