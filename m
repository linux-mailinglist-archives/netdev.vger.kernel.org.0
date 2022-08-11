Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AFB5900EF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiHKPrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbiHKPqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D2479A77;
        Thu, 11 Aug 2022 08:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70732B8214A;
        Thu, 11 Aug 2022 15:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977B5C433C1;
        Thu, 11 Aug 2022 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232456;
        bh=wk93eVSDYsfcr+KWzJsuTBj3BnCkHAZGo0rZVIe1z/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1RrzN/c+MuCOdNri1MnvQiJqaHUh+2HLDkjHi43JgCnqzoE4nmv+mv6L3MDD9U4u
         1IN1wzhNTSnhWlAXQ5O6OmcWsM52MSF+4/pjgOigO1sMbnlePMk/4jBfk8kFZmGHih
         oh1FNaSNkzwp6XNajoePLbziM3h1TheiLO5DoqV0Uk4kUB47yAC2X05J9aWWYGcy/0
         0yTi4+Z/JqEO34iBAnJ3/xyzxeKlPHft9JmzNN956lIgpk000cnzzvXEwQZnD4G1Qw
         KzoxxRGHpt9HBkI/K7OfRuEqcnU7aVJHfSnJDvovyIxKaUySHUVLubT+5kQczVPLc0
         JWBEx3pp2/8kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 085/105] Bluetooth: hci_sync: Check LMP feature bit instead of quirk
Date:   Thu, 11 Aug 2022 11:28:09 -0400
Message-Id: <20220811152851.1520029-85-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 766ae2422b4312a73510ebee9266bc23b466fbbb ]

BT core driver should addtionally check LMP feature bit
"Erroneous Data Reporting" instead of quirk
HCI_QUIRK_BROKEN_ERR_DATA_REPORTING set by BT device driver to decide if
HCI commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken.

BLUETOOTH CORE SPECIFICATION Version 5.3 | Vol 2, Part C | page 587
This feature indicates whether the device is able to support the
Packet_Status_Flag and the HCI commands HCI_Write_Default_-
Erroneous_Data_Reporting and HCI_Read_Default_Erroneous_-
Data_Reporting.

the quirk was introduced by 'commit cde1a8a99287 ("Bluetooth: btusb: Fix
and detect most of the Chinese Bluetooth controllers")' to mark HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting broken by BT
device driver, but the reason why these two HCI commands are broken is
that feature "Erroneous Data Reporting" is not enabled by firmware, this
scenario is illustrated by below log of QCA controllers with USB I/F:

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
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_sync.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fe7935be7dc4..000c70e88aa8 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -496,6 +496,7 @@ enum {
 #define LMP_EXT_INQ	0x01
 #define LMP_SIMUL_LE_BR	0x02
 #define LMP_SIMPLE_PAIR	0x08
+#define LMP_ERR_DATA_REPORTING 0x20
 #define LMP_NO_FLUSH	0x40
 
 #define LMP_LSTO	0x01
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c17021642234..a6418095b8d5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3191,7 +3191,7 @@ static int hci_read_page_scan_activity_sync(struct hci_dev *hdev)
 static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[18] & 0x04) ||
-	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
@@ -3676,7 +3676,7 @@ static int hci_set_err_data_report_sync(struct hci_dev *hdev)
 	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
 
 	if (!(hdev->commands[18] & 0x08) ||
-	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
 		return 0;
 
 	if (enabled == hdev->err_data_reporting)
-- 
2.35.1

