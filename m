Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D5612BA1F
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfL0SQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfL0SQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5F88208C4;
        Fri, 27 Dec 2019 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470574;
        bh=EvSiv8FLJV0cVmTE8MdJXabwPC8Qy3ipYItIfivMmyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWKE76ydbS1ub3jM6U+9jaemexpSuzlwntkwuI59tTWe26azrjmpquHMbEEE+rFuj
         WvKM9HlVJUXsVD+ddYmbVfi8Gl8M3KxiGzgVOoHV4EHV5QgDyQKjPbiQojLaSZaMQ/
         PNb4Zc91Rf445GaktylYhfRZf/UJc7caNs+0zi0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/25] net: nfc: nci: fix a possible sleep-in-atomic-context bug in nci_uart_tty_receive()
Date:   Fri, 27 Dec 2019 13:15:45 -0500
Message-Id: <20191227181549.8040-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit b7ac893652cafadcf669f78452329727e4e255cc ]

The kernel may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

net/nfc/nci/uart.c, 349:
	nci_skb_alloc in nci_uart_default_recv_buf
net/nfc/nci/uart.c, 255:
	(FUNC_PTR)nci_uart_default_recv_buf in nci_uart_tty_receive
net/nfc/nci/uart.c, 254:
	spin_lock in nci_uart_tty_receive

nci_skb_alloc(GFP_KERNEL) can sleep at runtime.
(FUNC_PTR) means a function pointer is called.

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC for
nci_skb_alloc().

This bug is found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 21d8875673a4..c3f2faa0210e 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -355,7 +355,7 @@ static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
 			nu->rx_packet_len = -1;
 			nu->rx_skb = nci_skb_alloc(nu->ndev,
 						   NCI_MAX_PACKET_SIZE,
-						   GFP_KERNEL);
+						   GFP_ATOMIC);
 			if (!nu->rx_skb)
 				return -ENOMEM;
 		}
-- 
2.20.1

