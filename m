Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDC43E3E9
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhJ1OkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhJ1OkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:40:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723BC061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:57 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id h7so26298752ede.8
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=IQj8LxZyvOCURsCt4XI4Uell0chqwPh5nCOspgWJlJZGvzIHjJ3pxLbi7yWZ9SZmwq
         zwByaev4ety2VWcVO885idO++vT3cLO8jEfn5XOUklswu29JSovc5PrOFD/xl2zhX7y5
         4qZ3QcgC3olamUrrEFep4eMAOdnkwy3vsXeSzlxQAMeEX/U9oMmJrDRi25APKJMFUPQJ
         7I8uyKnGeDTX+jEHiv9AtbPEaZLe9FCCuqioN+maZmWbTIR0dau5mZQT3b2I2vwZm2Hd
         koJPRfvJbTVNH/3unIgVNvRNKyRbVXgGEeFTOX53zvbLWUziKZ3mAVkTjU672n3JwSxb
         m12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=atu32CkZti1nWfevi7DbT5BLUNzAh1Q21/SFv2SZrRARR7bLN2bNzyq4nowlJnldUG
         ZEriVoeUn45KdmiUeT7XObEN9rCl+2MGEfhvabQoJ/9DPvDuivgHP5R+5XUYab1AK6Ml
         y2mfi2wsUUO/82A+Wn6VBDdbiGCeIyID8KHwHt4IAPUeju0dhfJcAQw00gQdQuSdyjGQ
         nQuFHQwQ3iCgUSIdH1ZY+hKa3IIw5BM6MLHCvBGUHPpIaAww0e7ErIQ/R744oU4HFbox
         /bPdaPpPLFG/ZjAdhjW0BjoYo+Nv/egjWmhpeYZRB+zf/H/YFl3tQ8UoMSxLd0eCKPV4
         hEOA==
X-Gm-Message-State: AOAM532ctk8pmQZ7F2yklxWY5HX4vrhZgk3XNjS5NK6vXT0ScSTRdV0J
        us4orf/MjWgn1ytQUhItEcnOKIiNWjE=
X-Google-Smtp-Source: ABdhPJz8lFRb/ojGG8pVeHunZek/PGq+OrMC+uvSiiDMz7LHBUhKKl+dM3G8tImDm2dIhppEHcbMCg==
X-Received: by 2002:a05:6402:1511:: with SMTP id f17mr6628020edw.68.1635431875857;
        Thu, 28 Oct 2021 07:37:55 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id di12sm1514501ejc.3.2021.10.28.07.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 07:37:55 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next v2 1/4] igb: move SDP config initialization to separate function
Date:   Thu, 28 Oct 2021 16:34:56 +0200
Message-Id: <20211028143459.903439-2-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211028143459.903439-1-kernel.hbk@gmail.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
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

