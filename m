Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6244390037
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhEYLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231765AbhEYLnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 07:43:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3430C60E0C;
        Tue, 25 May 2021 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621942940;
        bh=CvkvvdNVnAMZ6RmVFvM+ha645jXIy4op0pmLKXA80cA=;
        h=From:To:Cc:Subject:Date:From;
        b=sEHXCZ3lhIrPxuEm53kNDp497XibUIVMaIWFiT6U7EqjloQsEeajZUte2zm7/0/l5
         b+i68Tya8z6Jk8MeMEMgeEKE4eN5CHMsyDz5DRNF7jev5UsD1vGia232BTr+PHcSf9
         6T9gIqAlftk3Qp93yuRxppTItODY5Q5VeOKxj5UM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     linma <linma@zju.edu.cn>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hao Xiong <mart1n@zju.edu.cn>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Bluetooth: fix the erroneous flush_work() order
Date:   Tue, 25 May 2021 13:42:15 +0200
Message-Id: <20210525114215.141988-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: linma <linma@zju.edu.cn>

In the cleanup routine for failed initialization of HCI device,
the flush_work(&hdev->rx_work) need to be finished before the
flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
possibly invoke new cmd_work and cause a bug, like double free,
in late processings.

This was assigned CVE-2021-3564.

This patch reorder the flush_work() to fix this bug.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fd12f1652bdf..88aa32f44e68 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1610,8 +1610,13 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 	} else {
 		/* Init failed, cleanup */
 		flush_work(&hdev->tx_work);
-		flush_work(&hdev->cmd_work);
+		/*
+		 * Since hci_rx_work() is possible to awake new cmd_work
+		 * it should be flushed first to avoid unexpected call of
+		 * hci_cmd_work()
+		 */
 		flush_work(&hdev->rx_work);
+		flush_work(&hdev->cmd_work);
 
 		skb_queue_purge(&hdev->cmd_q);
 		skb_queue_purge(&hdev->rx_q);
-- 
2.31.1

