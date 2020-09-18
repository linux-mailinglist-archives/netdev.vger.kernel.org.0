Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DFA26EC27
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgIRCKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbgIRCJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:09:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDEB0239D1;
        Fri, 18 Sep 2020 02:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394997;
        bh=X7HvMDAeXbk7Y56Bs6YVhdAtjtsCFbi4aOnIKUSW0JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzOtc7c0w+3AL2Anp2r5onZ/S8j0TFuJv9roLQJGH2c694oEu75mZlXLjwY4Uu5mO
         uK3tGeT8OJjXeIP6VzlNbr7cPZfA7CEDSLMposBFZYmh93gw6xISz8gymEjg0vuvch
         TD1EUz3CJhjWDn6TlQZc+NG1B2VnafTWRZdVgWYA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 095/206] Bluetooth: guard against controllers sending zero'd events
Date:   Thu, 17 Sep 2020 22:06:11 -0400
Message-Id: <20200918020802.2065198-95-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit 08bb4da90150e2a225f35e0f642cdc463958d696 ]

Some controllers have been observed to send zero'd events under some
conditions.  This change guards against this condition as well as adding
a trace to facilitate diagnosability of this condition.

Signed-off-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 2b4a7cf03041b..ec6b3a87b3e7f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5738,6 +5738,11 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 	u8 status = 0, event = hdr->evt, req_evt = 0;
 	u16 opcode = HCI_OP_NOP;
 
+	if (!event) {
+		bt_dev_warn(hdev, "Received unexpected HCI Event 00000000");
+		goto done;
+	}
+
 	if (hdev->sent_cmd && bt_cb(hdev->sent_cmd)->hci.req_event == event) {
 		struct hci_command_hdr *cmd_hdr = (void *) hdev->sent_cmd->data;
 		opcode = __le16_to_cpu(cmd_hdr->opcode);
@@ -5949,6 +5954,7 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 		req_complete_skb(hdev, status, opcode, orig_skb);
 	}
 
+done:
 	kfree_skb(orig_skb);
 	kfree_skb(skb);
 	hdev->stat.evt_rx++;
-- 
2.25.1

