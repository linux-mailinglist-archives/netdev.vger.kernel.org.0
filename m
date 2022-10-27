Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0D460F5E4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiJ0LGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiJ0LGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:06:10 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43CDE0706;
        Thu, 27 Oct 2022 04:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1666868767; x=1698404767;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9vDsFDWsTM0HLzYvJtlR+FkhaxKdyM61nwfYVVJDHfs=;
  b=q/YD47EfZ24rAElSea5YNfe1GAz6V0idmC/rXu13Ef4V+eMb8v3RXHr0
   Rzt+sGwgfYC0Lq9XpM2LFLjaFBiuSlxvTam7f+SfAEUbXYow6mdizd0rH
   Ef15ybKtN8acLjjYTiYhpdHpMsolvnuhkCyhzHdfCR1FXx8ruAu6a2GKS
   Y=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 27 Oct 2022 04:06:07 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 04:06:07 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 27 Oct 2022 04:06:05 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <luiz.von.dentz@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, Zijun Hu <zijuhu@qti.qualcomm.com>
Subject: [PATCH v1] Bluetooth: btusb: Fix enable failure for a CSR BT dongle
Date:   Thu, 27 Oct 2022 19:06:00 +0800
Message-ID: <1666868760-4680-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zijun Hu <zijuhu@qti.qualcomm.com>

A CSR BT dongle fails to be enabled bcz it is not detected as fake
rightly, fixed by correcting fake detection condition.

below btmon error log says HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL is not set.

< HCI Command: Set Event Filter (0x03|0x0005) plen 1        #23 [hci0]
        Type: Clear All Filters (0x00)
> HCI Event: Command Complete (0x0e) plen 4                 #24 [hci0]
      Set Event Filter (0x03|0x0005) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

the quirk is not set bcz current fake detection does not mark the dongle
as fake with below version info.

< HCI Command: Read Local Version In.. (0x04|0x0001) plen 0  #1 [hci0]
> HCI Event: Command Complete (0x0e) plen 12                 #2 [hci0]
      Read Local Version Information (0x04|0x0001) ncmd 1
        Status: Success (0x00)
        HCI version: Bluetooth 4.0 (0x06) - Revision 12576 (0x3120)
        LMP version: Bluetooth 4.0 (0x06) - Subversion 8891 (0x22bb)
        Manufacturer: Cambridge Silicon Radio (10)

Link: https://bugzilla.kernel.org/show_bug.cgi?id=60824
Signed-off-by: Zijun Hu <zijuhu@qti.qualcomm.com>
---
 drivers/bluetooth/btusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 420be2ee2acf..727469d073f9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2155,7 +2155,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 		is_fake = true;
 
 	else if (le16_to_cpu(rp->lmp_subver) <= 0x22bb &&
-		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_4_0)
+		 le16_to_cpu(rp->hci_ver) >= BLUETOOTH_VER_4_0)
 		is_fake = true;
 
 	/* Other clones which beat all the above checks */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

