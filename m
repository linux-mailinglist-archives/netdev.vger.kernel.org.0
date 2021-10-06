Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABC1423E56
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhJFNCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhJFNCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 09:02:42 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA04C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 06:00:50 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id l7so9720958edq.3
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=E7iAKuIhAGmf/af7KUIbkzSaqvAtKhIrTmCbMb5GU6+tqbDP+zBldpv6jP4vZICdD5
         zYb1RUDZLd1JO/0xZXUGYLNNG673riCS3/40ejVqdvshPp029dXwMBzh25ct1owS+Zsh
         Y1fc82le9ORNP68vzMSkN/tPluPKgwNQeugyzmH1UoX6eESaXrWeiVRqIEHpCedhYFAY
         6tzd+HHY1PNYlBh7OIvQ/Yd+Q9XU2t5tXw0YdDYDykzU0e6MTrAbia3iXnCVlStmx4Of
         ypGmTvy4XkuTUcPc5aZssdXIM/j3yhyVyupttdi2S8gFrkfn2Lplyq4PDmOR9sAsfMJK
         2GFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaLOI5pYECzKvo/+urqxhhg9PYPQu4oDJi6rLd02fk8=;
        b=cvcA+TiqiAMVR5aowTP6FPRyO5LpDWo6I909MO1j6kidQAtasVqZXlIdIvnf9BeACl
         oBAsW0hcWcOKHAJiaWG7pR9C2NoUZRC68yyKYSGYD+f5EeMF99i4voCLEuXFfI56yLnU
         nxVPvlrqsjoU89PwBgGA8O5O/D646cVK872U8fYMIAzrdwDwnDH0hhwhRc96snfivozr
         QEYUQNjaphvSzgnq00O0nAkaksNs2/aQkJMqY1jQhdFDg78nVVZ6lMdsQxQyGyyat2qf
         2Vx67OlQKZvIYhhdUEjGZyFUOhhjoJRDAwgodGTIJh8WStyAsTH040xQv9vR+DrrpbtS
         Svrg==
X-Gm-Message-State: AOAM532WHg2Yi1ijsun0I9zJb08TNj0QO66AsN+XOd2tDIpNm+TeNzbL
        9rSEI+bSXH04YCIIQ5P5K+C9EnoEN3c=
X-Google-Smtp-Source: ABdhPJyJxBwFL3uZvI1lzjLXo1Tahq3ljl832Hyk30QYzxg94/T7AZQY4VMNSkJfmownCHPgEu9w2g==
X-Received: by 2002:a50:fc8e:: with SMTP id f14mr33931073edq.87.1633525245352;
        Wed, 06 Oct 2021 06:00:45 -0700 (PDT)
Received: from localhost.localdomain (84-104-224-163.cable.dynamic.v4.ziggo.nl. [84.104.224.163])
        by smtp.gmail.com with ESMTPSA id y16sm194122eds.70.2021.10.06.06.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:00:44 -0700 (PDT)
From:   Ruud Bos <kernel.hbk@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Ruud Bos <kernel.hbk@gmail.com>
Subject: [PATCH net-next 1/4] igb: move SDP config initialization to separate function
Date:   Wed,  6 Oct 2021 14:58:22 +0200
Message-Id: <20211006125825.1383-2-kernel.hbk@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006125825.1383-1-kernel.hbk@gmail.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
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

