Return-Path: <netdev+bounces-367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E676F7483
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 017BE280E3F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0560FC15B;
	Thu,  4 May 2023 19:44:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7052A101C2
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD613C4339C;
	Thu,  4 May 2023 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229449;
	bh=SHIJtT+/f6e2zoHBjSbl6lAvp2ZShP6iuhKQ6fD0XjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8DR/2xNKFNgpeZovLtss8oToJ8MXM638Dw4Ig6bv8KUPZU1RYR1cJk14nSp5pH1Q
	 1MT7VLKv2xe30y64XmJFhklFIlAzc4i33JplyNch2H0mAlL3oGeTQKQil05NvRfdb0
	 1rBCVd2cDOc386ivCl1OMjtL/PK3RwWExJO8D5Mi1FEHFEFy/90kMj4oIONdWVg5zE
	 MLDC3dXg//BLvxWigmQgRFesiaGN08Pbcz0PvUpleAbsSsuCN9w/bqLFoblKf7z503
	 rLhagw0SbdfG6+TqtJX6wvvGcpjaCBzFjmlqp1qVqudnPDIOMCQ2YHYrHl/qvBEp8T
	 aOAr8Ht3CejGg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Raul Cheleguini <raul.cheleguini@gmail.com>,
	imoc <wzj9912@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 57/59] Bluetooth: Add new quirk for broken set random RPA timeout for ATS2851
Date: Thu,  4 May 2023 15:41:40 -0400
Message-Id: <20230504194142.3805425-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Raul Cheleguini <raul.cheleguini@gmail.com>

[ Upstream commit 91b6d02ddcd113352bdd895990b252065c596de7 ]

The ATS2851 based controller advertises support for command "LE Set Random
Private Address Timeout" but does not actually implement it, impeding the
controller initialization.

Add the quirk HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT to unblock the controller
initialization.

< HCI Command: LE Set Resolvable Private... (0x08|0x002e) plen 2
        Timeout: 900 seconds
> HCI Event: Command Status (0x0f) plen 4
      LE Set Resolvable Private Address Timeout (0x08|0x002e) ncmd 1
        Status: Unknown HCI Command (0x01)

Co-developed-by: imoc <wzj9912@gmail.com>
Signed-off-by: imoc <wzj9912@gmail.com>
Signed-off-by: Raul Cheleguini <raul.cheleguini@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c   | 1 +
 include/net/bluetooth/hci.h | 8 ++++++++
 net/bluetooth/hci_sync.c    | 6 +++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1ab5663b009d8..0923582299f3a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -4106,6 +4106,7 @@ static int btusb_probe(struct usb_interface *intf,
 		/* Support is advertised, but not implemented */
 		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &hdev->quirks);
 	}
 
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 997107bfc0b12..07df96c47ef4f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -301,6 +301,14 @@ enum {
 	 * don't actually support features declared there.
 	 */
 	HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
+
+	/*
+	 * When this quirk is set, the HCI_OP_LE_SET_RPA_TIMEOUT command is
+	 * skipped during initialization. This is required for the Actions
+	 * Semiconductor ATS2851 based controllers, which erroneously claims
+	 * to support it.
+	 */
+	HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 632be12672887..b65ee3a32e5d7 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4093,7 +4093,8 @@ static int hci_le_set_rpa_timeout_sync(struct hci_dev *hdev)
 {
 	__le16 timeout = cpu_to_le16(hdev->rpa_timeout);
 
-	if (!(hdev->commands[35] & 0x04))
+	if (!(hdev->commands[35] & 0x04) ||
+	    test_bit(HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_RPA_TIMEOUT,
@@ -4533,6 +4534,9 @@ static const struct {
 			 "HCI Set Event Filter command not supported."),
 	HCI_QUIRK_BROKEN(ENHANCED_SETUP_SYNC_CONN,
 			 "HCI Enhanced Setup Synchronous Connection command is "
+			 "advertised, but not supported."),
+	HCI_QUIRK_BROKEN(SET_RPA_TIMEOUT,
+			 "HCI LE Set Random Private Address Timeout command is "
 			 "advertised, but not supported.")
 };
 
-- 
2.39.2


