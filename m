Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A588C26EF50
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgIRCer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbgIRCN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2816208DB;
        Fri, 18 Sep 2020 02:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395207;
        bh=lFCzPiwrwZi+2I/qPpv079tYMk9JTossO09i+z/sBqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqKu+4nhks9QxzsavxVQx3+QLN0+F5dV9F+/Q9nz5HvFp1IbnK6Ls8HzM77BJDJ6d
         rigsD6LaMveBtZ4FxwCp+LA4D/hjzs7KU/lgAqlvXBmmyKadXjoWdavRip/63HK0No
         wzoS2+FE2uTlZNFuNWCNfuBRXwMmQ3tn6/LfDPc8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 056/127] Bluetooth: guard against controllers sending zero'd events
Date:   Thu, 17 Sep 2020 22:11:09 -0400
Message-Id: <20200918021220.2066485-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
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
index 70b8e2de40cf4..1d2f439043669 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5257,6 +5257,11 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
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
@@ -5468,6 +5473,7 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 		req_complete_skb(hdev, status, opcode, orig_skb);
 	}
 
+done:
 	kfree_skb(orig_skb);
 	kfree_skb(skb);
 	hdev->stat.evt_rx++;
-- 
2.25.1

