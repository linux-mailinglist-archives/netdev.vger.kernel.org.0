Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19F32A344
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378785AbhCBIyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:54:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:39904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835884AbhCBGYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:24:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6EE01AFE2;
        Tue,  2 Mar 2021 06:22:18 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 17/44] net: nfc: nci: drop nci_uart_default_recv
Date:   Tue,  2 Mar 2021 07:21:47 +0100
Message-Id: <20210302062214.29627-17-jslaby@suse.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302062214.29627-1-jslaby@suse.cz>
References: <20210302062214.29627-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nci_uart_register returns -EINVAL immediately when nu->ops.recv is not
set. So the same 'if' later never triggers so nci_uart_default_recv is
never used. Drop it.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 net/nfc/nci/uart.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 5cf7d3729d5f..9958b37d8f9d 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -387,12 +387,6 @@ static int nci_uart_send(struct nci_uart *nu, struct sk_buff *skb)
 	return 0;
 }
 
-/* -- Default recv handler -- */
-static int nci_uart_default_recv(struct nci_uart *nu, struct sk_buff *skb)
-{
-	return nci_recv_frame(nu->ndev, skb);
-}
-
 int nci_uart_register(struct nci_uart *nu)
 {
 	if (!nu || !nu->ops.open ||
@@ -402,10 +396,6 @@ int nci_uart_register(struct nci_uart *nu)
 	/* Set the send callback */
 	nu->ops.send = nci_uart_send;
 
-	/* Install default handlers if not overridden */
-	if (!nu->ops.recv)
-		nu->ops.recv = nci_uart_default_recv;
-
 	/* Add this driver in the driver list */
 	if (nci_uart_drivers[nu->driver]) {
 		pr_err("driver %d is already registered\n", nu->driver);
-- 
2.30.1

