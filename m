Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DEE1A56C4
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbgDKXO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgDKXOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B9D20769;
        Sat, 11 Apr 2020 23:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646865;
        bh=yL0vixqPQqesLTulGlgyziqwc/+H2bQnh8uhuipTBfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBN2nY0gELuQHyR4X3VdxAITCAN/azCCajCk79/2tQOF3iQrfeK2k4KvmCWEAhwQ9
         AvNkF1EtAzqaplG3KG7th2df9tsAqlmPK0lCbys88XurqnY2boE39Hq6lkcej3ZWS1
         yMvMpt2yqCgVOu1oqaYi+7plrBfDhnaZJ/ddwveE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/26] Bluetooth: Fix calculation of SCO handle for packet processing
Date:   Sat, 11 Apr 2020 19:13:57 -0400
Message-Id: <20200411231413.26911-10-sashal@kernel.org>
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

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit debdedf2eb5a2d9777cabff40900772be13cd9f9 ]

When processing SCO packets, the handle is wrongly assumed as 16-bit
value. The actual size is 12-bits and the other 4-bits are used for
packet flags.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a70b078ceb3ca..0161bdbda71ec 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4043,13 +4043,16 @@ static void hci_scodata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_sco_hdr *hdr = (void *) skb->data;
 	struct hci_conn *conn;
-	__u16 handle;
+	__u16 handle, flags;
 
 	skb_pull(skb, HCI_SCO_HDR_SIZE);
 
 	handle = __le16_to_cpu(hdr->handle);
+	flags  = hci_flags(handle);
+	handle = hci_handle(handle);
 
-	BT_DBG("%s len %d handle 0x%4.4x", hdev->name, skb->len, handle);
+	BT_DBG("%s len %d handle 0x%4.4x flags 0x%4.4x", hdev->name, skb->len,
+	       handle, flags);
 
 	hdev->stat.sco_rx++;
 
-- 
2.20.1

