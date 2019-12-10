Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5691198BE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfLJVeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:34:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbfLJVeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA2324654;
        Tue, 10 Dec 2019 21:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013659;
        bh=ykKCGCn8/3t67A1Ya/4CAb5bkolOeo9qOFYnfKkRN8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mumTng4KbfrCJ5EASheNpQWolfviMdbE1iYef1PHw0eyy9YgpYVC0FuxqYFOquflG
         6nKEAW15pVjEV3GYiAMLvc/ci302O0hps/SIlR2O4vWTW/QtHsZWQ9qED8CKGIIKtC
         V6EhKDxXgKpinUNAXhiyrZohduQ6AOfrVMZhibzY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/177] Bluetooth: Fix advertising duplicated flags
Date:   Tue, 10 Dec 2019 16:31:01 -0500
Message-Id: <20191210213221.11921-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6012b9346d8959194c239fd60a62dfec98d43048 ]

Instances may have flags set as part of its data in which case the code
should not attempt to add it again otherwise it can cause duplication:

< HCI Command: LE Set Extended Advertising Data (0x08|0x0037) plen 35
        Handle: 0x00
        Operation: Complete extended advertising data (0x03)
        Fragment preference: Minimize fragmentation (0x01)
        Data length: 0x06
        Flags: 0x04
          BR/EDR Not Supported
        Flags: 0x06
          LE General Discoverable Mode
          BR/EDR Not Supported

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 9448ebd3780a3..a8ddd211e94c2 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1258,6 +1258,14 @@ static u8 create_instance_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
 
 	instance_flags = get_adv_instance_flags(hdev, instance);
 
+	/* If instance already has the flags set skip adding it once
+	 * again.
+	 */
+	if (adv_instance && eir_get_data(adv_instance->adv_data,
+					 adv_instance->adv_data_len, EIR_FLAGS,
+					 NULL))
+		goto skip_flags;
+
 	/* The Add Advertising command allows userspace to set both the general
 	 * and limited discoverable flags.
 	 */
@@ -1290,6 +1298,7 @@ static u8 create_instance_adv_data(struct hci_dev *hdev, u8 instance, u8 *ptr)
 		}
 	}
 
+skip_flags:
 	if (adv_instance) {
 		memcpy(ptr, adv_instance->adv_data,
 		       adv_instance->adv_data_len);
-- 
2.20.1

