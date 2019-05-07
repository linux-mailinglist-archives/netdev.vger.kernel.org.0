Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC24D1599F
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfEGFiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfEGFiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5887020578;
        Tue,  7 May 2019 05:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207500;
        bh=Odb2wR9MNZJs0FIio80DYt0+uYiHzp7oyXcT0w/Xpj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCWOGG6zS3QOacJ3XHxBeKI6DkWF03xlyBPBPPAETUhKV7+kcYf51FPjbU0iHQCWd
         1IIVt/2QfcedMlHhKLWNA2JlVk/BHI5LurVUG9QqUd0oFZOk9AObwqH5HKyVnt0Fw9
         yHBFRNj44e01eFe//yt7sozPu30mDSnktaW2Ogwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 79/81] NFC: nci: Add some bounds checking in nci_hci_cmd_received()
Date:   Tue,  7 May 2019 01:35:50 -0400
Message-Id: <20190507053554.30848-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d7ee81ad09f072eab1681877fc71ec05f9c1ae92 ]

This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
corruption when handling SHDLC I-Frame commands").

I'm not totally sure, but I think that commit description may have
overstated the danger.  I was under the impression that this data came
from the firmware?  If you can't trust your networking firmware, then
you're already in trouble.

Anyway, these days we add bounds checking where ever we can and we call
it kernel hardening.  Better safe than sorry.

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/nfc/nci/hci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index ddfc52ac1f9b..c0d323b58e73 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -312,6 +312,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 		create_info = (struct nci_hci_create_pipe_resp *)skb->data;
 		dest_gate = create_info->dest_gate;
 		new_pipe = create_info->pipe;
+		if (new_pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		/* Save the new created pipe and bind with local gate,
 		 * the description for skb->data[3] is destination gate id
@@ -336,6 +340,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 			goto exit;
 		}
 		delete_info = (struct nci_hci_delete_pipe_noti *)skb->data;
+		if (delete_info->pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		ndev->hci_dev->pipes[delete_info->pipe].gate =
 						NCI_HCI_INVALID_GATE;
-- 
2.20.1

