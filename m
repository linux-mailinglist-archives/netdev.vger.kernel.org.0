Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739BD57B827
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240477AbiGTOHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240227AbiGTOHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:07:37 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E61545C0;
        Wed, 20 Jul 2022 07:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1658326056; x=1689862056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=iRQOrw4OMt9lUmiWeHiLLPc0cwwxT0dJRU4AMlrNZLE=;
  b=gBB+8VYe4IguQnHFE0LhwqfKgqCzv2+jEcJHTviqUCa5w/CCzW7gsEiC
   iuPmqTeO/ZSWYp/QwjR1TC/ntGGVamRLp3csnZBh05E5PTTYGwIP6/5aq
   SgAKl72mq1hjhwxgh12bR8IgHhYtGOcIHpWDK1g3Q4/dK02s68vObxND6
   s=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Jul 2022 07:07:36 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 07:07:36 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Jul 2022 07:07:33 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <swyterzone@gmail.com>,
        <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 1/3] Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
Date:   Wed, 20 Jul 2022 22:07:23 +0800
Message-ID: <1658326045-9931-2-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658326045-9931-1-git-send-email-quic_zijuhu@quicinc.com>
References: <1658326045-9931-1-git-send-email-quic_zijuhu@quicinc.com>
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

Check feature bit "Erroneous Data Reporting" instead of quirk
HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI command
HCI_Read|Write_Default_Erroneous_Data_Reporting work fine.

BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 2, Part C | page 587
This feature indicates whether the device is able to support the
Packet_Status_Flag and the HCI commands HCI_Write_Default_-
Erroneous_Data_Reporting and HCI_Read_Default_Erroneous_-
Data_Reporting.

ALL BT controller whose device driver set the quirk currently does not
enable the fearture bit as shown by below btmon log:

@ RAW Open: hcitool (privileged) version 2.22
< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
      Read Local Supported Commands (0x04|0x0002) ncmd 1
        Status: Success (0x00)
        Commands: 288 entries
......
          Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
          Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
......

< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
> HCI Event: Command Complete (0x0e) plen 4
      Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
        Status: Unknown HCI Command (0x01)

< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
      Read Local Supported Features (0x04|0x0003) ncmd 1
        Status: Success (0x00)
        Features: 0xff 0xfe 0x0f 0xfe 0xd8 0x3f 0x5b 0x87
          3 slot packets
......

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 include/net/bluetooth/hci.h | 12 +-----------
 net/bluetooth/hci_sync.c    |  7 ++-----
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 4a45c48eb0d2..927f51b92854 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,17 +228,6 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
-	/* When this quirk is set, then erroneous data reporting
-	 * is ignored. This is mainly due to the fact that the HCI
-	 * Read Default Erroneous Data Reporting command is advertised,
-	 * but not supported; these controllers often reply with unknown
-	 * command and tend to lock up randomly. Needing a hard reset.
-	 *
-	 * This quirk can be set before hci_register_dev is called or
-	 * during the hdev->setup vendor callback.
-	 */
-	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
-
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
@@ -497,6 +486,7 @@ enum {
 #define LMP_EXT_INQ	0x01
 #define LMP_SIMUL_LE_BR	0x02
 #define LMP_SIMPLE_PAIR	0x08
+#define LMP_ERR_DATA_REPORTING 0x20
 #define LMP_NO_FLUSH	0x40
 
 #define LMP_LSTO	0x01
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 464a5e2c56fb..0b6987b37c03 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3221,7 +3221,7 @@ static int hci_read_page_scan_activity_sync(struct hci_dev *hdev)
 static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[18] & 0x04) ||
-	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
@@ -3706,7 +3706,7 @@ static int hci_set_err_data_report_sync(struct hci_dev *hdev)
 	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
 
 	if (!(hdev->commands[18] & 0x08) ||
-	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
 		return 0;
 
 	if (enabled == hdev->err_data_reporting)
@@ -3865,9 +3865,6 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
-	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
-			 "HCI Read Default Erroneous Data Reporting command is "
-			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

