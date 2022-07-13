Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4B572E8B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiGMGxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiGMGxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:53:23 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E442AE0F45;
        Tue, 12 Jul 2022 23:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657695203; x=1689231203;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=8n8+PO3A95/qKneSFHtNBTYCjF+JHU9XIFkvb+rLAQ8=;
  b=uPq9DHAsMbPbm87n+OZip+1/u9dmsK3nj53IvftZlE2uj4BdP+9/FOFD
   V2u5BCQY/lzi38vaGYLbCWEM3TMfqwZA4ah24JUyLk7CZnTRafs8iQui8
   nMj6moLFz3AM2T+WYj1/hMTbN7n9h5k1fyM7XIMgOAGwi8Iq/sDPkwRjR
   s=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 12 Jul 2022 23:53:22 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 23:53:22 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 12 Jul 2022 23:53:19 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v1] Bluetooth: hci_sync: Correct hci_set_event_mask_page_2_sync() event mask
Date:   Wed, 13 Jul 2022 14:53:14 +0800
Message-ID: <1657695194-25801-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Event HCI_Truncated_Page_Complete should belong to central
and HCI_Peripheral_Page_Response_Timeout should belong to
peripheral, but hci_set_event_mask_page_2_sync() take these
two events for wrong roles, so correct it by this change.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 net/bluetooth/hci_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7cb310051879..c72533bb9834 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3602,7 +3602,7 @@ static int hci_set_event_mask_page_2_sync(struct hci_dev *hdev)
 	if (lmp_cpb_central_capable(hdev)) {
 		events[1] |= 0x40;	/* Triggered Clock Capture */
 		events[1] |= 0x80;	/* Synchronization Train Complete */
-		events[2] |= 0x10;	/* Peripheral Page Response Timeout */
+		events[2] |= 0x08;	/* Truncated Page Complete */
 		events[2] |= 0x20;	/* CPB Channel Map Change */
 		changed = true;
 	}
@@ -3614,7 +3614,7 @@ static int hci_set_event_mask_page_2_sync(struct hci_dev *hdev)
 		events[2] |= 0x01;	/* Synchronization Train Received */
 		events[2] |= 0x02;	/* CPB Receive */
 		events[2] |= 0x04;	/* CPB Timeout */
-		events[2] |= 0x08;	/* Truncated Page Complete */
+		events[2] |= 0x10;	/* Peripheral Page Response Timeout */
 		changed = true;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

