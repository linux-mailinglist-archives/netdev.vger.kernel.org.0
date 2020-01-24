Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE67147664
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 02:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgAXBTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 20:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbgAXBRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20D122071E;
        Fri, 24 Jan 2020 01:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828660;
        bh=vVzGl/1LrNLQUWSDodjDFOxHqfKPOheroeyONEUOIAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8EQcUWGSbyccxY7DXmqvaj1pE2kAvlhoUwCU3/UdBA2sxD9SlJTCXoFHH8xOmJ8d
         bZGtNQ91o1uMfx6MPNiYjd5xij9xPiqG99vaKuJcZRHopmRL/EIEfSIlyxJfD3hXNI
         rvPrDYR5DGMDCuf+i52+sdvoeTArA16so9gepLUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Andre Heider <a.heider@gmail.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/33] Bluetooth: Allow combination of BDADDR_PROPERTY and INVALID_BDADDR quirks
Date:   Thu, 23 Jan 2020 20:17:02 -0500
Message-Id: <20200124011708.18232-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 7fdf6c6a0d0e032aac2aa4537a23af1e04a397ce ]

When utilizing BDADDR_PROPERTY and INVALID_BDADDR quirks together it
results in an unconfigured controller even if the bootloader provides
a valid address. Fix this by allowing a bootloader provided address
to mark the controller as configured.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Tested-by: Andre Heider <a.heider@gmail.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0cc9ce9172229..9e19d5a3aac87 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1444,11 +1444,20 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 
 	if (hci_dev_test_flag(hdev, HCI_SETUP) ||
 	    test_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks)) {
+		bool invalid_bdaddr;
+
 		hci_sock_dev_event(hdev, HCI_DEV_SETUP);
 
 		if (hdev->setup)
 			ret = hdev->setup(hdev);
 
+		/* The transport driver can set the quirk to mark the
+		 * BD_ADDR invalid before creating the HCI device or in
+		 * its setup callback.
+		 */
+		invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR,
+					  &hdev->quirks);
+
 		if (ret)
 			goto setup_failed;
 
@@ -1457,20 +1466,33 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 				hci_dev_get_bd_addr_from_property(hdev);
 
 			if (bacmp(&hdev->public_addr, BDADDR_ANY) &&
-			    hdev->set_bdaddr)
+			    hdev->set_bdaddr) {
 				ret = hdev->set_bdaddr(hdev,
 						       &hdev->public_addr);
+
+				/* If setting of the BD_ADDR from the device
+				 * property succeeds, then treat the address
+				 * as valid even if the invalid BD_ADDR
+				 * quirk indicates otherwise.
+				 */
+				if (!ret)
+					invalid_bdaddr = false;
+			}
 		}
 
 setup_failed:
 		/* The transport driver can set these quirks before
 		 * creating the HCI device or in its setup callback.
 		 *
+		 * For the invalid BD_ADDR quirk it is possible that
+		 * it becomes a valid address if the bootloader does
+		 * provide it (see above).
+		 *
 		 * In case any of them is set, the controller has to
 		 * start up as unconfigured.
 		 */
 		if (test_bit(HCI_QUIRK_EXTERNAL_CONFIG, &hdev->quirks) ||
-		    test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks))
+		    invalid_bdaddr)
 			hci_dev_set_flag(hdev, HCI_UNCONFIGURED);
 
 		/* For an unconfigured controller it is required to
-- 
2.20.1

