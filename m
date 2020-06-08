Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D107E1F2848
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732622AbgFHXuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387534AbgFHXZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04C72076C;
        Mon,  8 Jun 2020 23:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658715;
        bh=ZMwayBUU3/PlVmz76TjQ1HqD5QNQrMGAw7LYg//B0fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+KMJX0uKylzn3Mrzt1klpRK/onvQ7SS0AwgOyO4mo40B9j3IfBLGWQUHI1NdkLvQ
         A3hH6jOaf7rHk7pioePrRFxFG5g7ZIxYhxalnzKerHKnx1I8yHEQUfDCC5qc2j0NkM
         qYHfMcCuGmZ8P57FFJcV75B34lBKL1YaL03j5mD8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hsin-Yu Chao <hychao@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/72] Bluetooth: Add SCO fallback for invalid LMP parameters error
Date:   Mon,  8 Jun 2020 19:24:00 -0400
Message-Id: <20200608232500.3369581-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hsin-Yu Chao <hychao@chromium.org>

[ Upstream commit 56b5453a86203a44726f523b4133c1feca49ce7c ]

Bluetooth PTS test case HFP/AG/ACC/BI-12-I accepts SCO connection
with invalid parameter at the first SCO request expecting AG to
attempt another SCO request with the use of "safe settings" for
given codec, base on section 5.7.1.2 of HFP 1.7 specification.

This patch addresses it by adding "Invalid LMP Parameters" (0x1e)
to the SCO fallback case. Verified with below log:

< HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17
        Handle: 256
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 13
        Setting: 0x0003
          Input Coding: Linear
          Input Data Format: 1's complement
          Input Sample Size: 8-bit
          # of bits padding at MSB: 0
          Air Coding Format: Transparent Data
        Retransmission effort: Optimize for link quality (0x02)
        Packet type: 0x0380
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Number of Completed Packets (0x13) plen 5
        Num handles: 1
        Handle: 256
        Count: 1
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 1
> HCI Event: Synchronous Connect Complete (0x2c) plen 17
        Status: Invalid LMP Parameters / Invalid LL Parameters (0x1e)
        Handle: 0
        Address: 00:1B:DC:F2:21:59 (OUI 00-1B-DC)
        Link type: eSCO (0x02)
        Transmission interval: 0x00
        Retransmission window: 0x02
        RX packet length: 0
        TX packet length: 0
        Air mode: Transparent (0x03)
< HCI Command: Setup Synchronous Connection (0x01|0x0028) plen 17
        Handle: 256
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 8
        Setting: 0x0003
          Input Coding: Linear
          Input Data Format: 1's complement
          Input Sample Size: 8-bit
          # of bits padding at MSB: 0
          Air Coding Format: Transparent Data
        Retransmission effort: Optimize for link quality (0x02)
        Packet type: 0x03c8
          EV3 may be used
          2-EV3 may not be used
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 5
> HCI Event: Max Slots Change (0x1b) plen 3
        Handle: 256
        Max slots: 1
> HCI Event: Synchronous Connect Complete (0x2c) plen 17
        Status: Success (0x00)
        Handle: 257
        Address: 00:1B:DC:F2:21:59 (OUI 00-1B-DC)
        Link type: eSCO (0x02)
        Transmission interval: 0x06
        Retransmission window: 0x04
        RX packet length: 30
        TX packet length: 30
        Air mode: Transparent (0x03)

Signed-off-by: Hsin-Yu Chao <hychao@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 363dc85bbc5c..56e4ae7d7f63 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3775,6 +3775,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 	case 0x11:	/* Unsupported Feature or Parameter Value */
 	case 0x1c:	/* SCO interval rejected */
 	case 0x1a:	/* Unsupported Remote Feature */
+	case 0x1e:	/* Invalid LMP Parameters */
 	case 0x1f:	/* Unspecified error */
 	case 0x20:	/* Unsupported LMP Parameter value */
 		if (conn->out) {
-- 
2.25.1

