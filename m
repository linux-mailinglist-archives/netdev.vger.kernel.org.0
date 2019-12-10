Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D0211973A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfLJVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbfLJVJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584E2246A3;
        Tue, 10 Dec 2019 21:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012158;
        bh=xJ6cWECGTI87+zeHdc7ft6/oh7NfheN/H4B2YxWsVek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLX/qN5veZDCVw16P/qZkev7aXInRj2LBV+zCBrciFXq1vliKCewh+gWhr5ceSau/
         3DWItK6ZFVInsaczV8dGebJe+giixihrvirVfkg37DqbjStzOZr8BnQZAcbLD9ZYcT
         2cMAh6ji3ai6llIQFyHnexbFGpw28SaMWYZ2gslY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Szymon Janc <szymon.janc@codecoup.pl>,
        =?UTF-8?q?S=C3=B6ren=20Beye?= <linux@hypfer.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 120/350] Bluetooth: Workaround directed advertising bug in Broadcom controllers
Date:   Tue, 10 Dec 2019 16:03:45 -0500
Message-Id: <20191210210735.9077-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Szymon Janc <szymon.janc@codecoup.pl>

[ Upstream commit 4c371bb95cf06ded80df0e6139fdd77cee1d9a94 ]

It appears that some Broadcom controllers (eg BCM20702A0) reject LE Set
Advertising Parameters command if advertising intervals provided are not
within range for undirected and low duty directed advertising.

Workaround this bug by populating min and max intervals with 'valid'
values.

< HCI Command: LE Set Advertising Parameters (0x08|0x0006) plen 15
        Min advertising interval: 0.000 msec (0x0000)
        Max advertising interval: 0.000 msec (0x0000)
        Type: Connectable directed - ADV_DIRECT_IND (high duty cycle) (0x01)
        Own address type: Public (0x00)
        Direct address type: Random (0x01)
        Direct address: E2:F0:7B:9F:DC:F4 (Static)
        Channel map: 37, 38, 39 (0x07)
        Filter policy: Allow Scan Request from Any, Allow Connect Request from Any (0x00)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Advertising Parameters (0x08|0x0006) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

Signed-off-by: Szymon Janc <szymon.janc@codecoup.pl>
Tested-by: Sören Beye <linux@hypfer.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ad5b0ac1f9cef..7ff92dd4c53cd 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -934,6 +934,14 @@ static void hci_req_directed_advertising(struct hci_request *req,
 			return;
 
 		memset(&cp, 0, sizeof(cp));
+
+		/* Some controllers might reject command if intervals are not
+		 * within range for undirected advertising.
+		 * BCM20702A0 is known to be affected by this.
+		 */
+		cp.min_interval = cpu_to_le16(0x0020);
+		cp.max_interval = cpu_to_le16(0x0020);
+
 		cp.type = LE_ADV_DIRECT_IND;
 		cp.own_address_type = own_addr_type;
 		cp.direct_addr_type = conn->dst_type;
-- 
2.20.1

