Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1581A56C7
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbgDKXO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbgDKXO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2470F20708;
        Sat, 11 Apr 2020 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646866;
        bh=MQrhq1PQAbbHEOt6Vnp7aTJD2bbSPul7BqLClBPI6Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq5f7cX7R9V+0Rs2U4920kH386zHGiAk+K54TlRHByfm6oAVpxuxa0yreu9gQizHw
         6BR2tJ82gd1zl/NIjge/cMSPSLvUXxs07b7u0iRys1+uWl2955uABk8Ubk0q6dEAjn
         DdkcK5EBnzbD3u7L9r4xkba9neGDuTKeOqfSZsbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/26] Bluetooth: guard against controllers sending zero'd events
Date:   Sat, 11 Apr 2020 19:13:58 -0400
Message-Id: <20200411231413.26911-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231413.26911-1-sashal@kernel.org>
References: <20200411231413.26911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index 6f78489fdb132..227b2e14eaeac 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5249,6 +5249,11 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -5460,6 +5465,7 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 		req_complete_skb(hdev, status, opcode, orig_skb);
 	}
 
+done:
 	kfree_skb(orig_skb);
 	kfree_skb(skb);
 	hdev->stat.evt_rx++;
-- 
2.20.1

