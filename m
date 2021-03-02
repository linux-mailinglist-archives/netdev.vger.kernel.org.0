Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC59D32A343
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378772AbhCBIyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:54:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:39618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835871AbhCBGYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:24:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4161CAFDF;
        Tue,  2 Mar 2021 06:22:18 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 16/44] net: nfc: nci: drop nci_uart_ops::recv_buf
Date:   Tue,  2 Mar 2021 07:21:46 +0100
Message-Id: <20210302062214.29627-16-jslaby@suse.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302062214.29627-1-jslaby@suse.cz>
References: <20210302062214.29627-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is noone setting nci_uart_ops::recv_buf, so the default one
(nci_uart_default_recv_buf) is always used. So drop this hook, move
nci_uart_default_recv_buf before the use in nci_uart_tty_receive and
remove unused parameter flags.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/nfc/nci_core.h |   2 -
 net/nfc/nci/uart.c         | 136 ++++++++++++++++++-------------------
 2 files changed, 67 insertions(+), 71 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 43c9c5d2bedb..bd76e8e082c0 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -430,8 +430,6 @@ struct nci_uart_ops {
 	int (*open)(struct nci_uart *nci_uart);
 	void (*close)(struct nci_uart *nci_uart);
 	int (*recv)(struct nci_uart *nci_uart, struct sk_buff *skb);
-	int (*recv_buf)(struct nci_uart *nci_uart, const u8 *data, char *flags,
-			int count);
 	int (*send)(struct nci_uart *nci_uart, struct sk_buff *skb);
 	void (*tx_start)(struct nci_uart *nci_uart);
 	void (*tx_done)(struct nci_uart *nci_uart);
diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index c9987d1cccdf..5cf7d3729d5f 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -229,6 +229,72 @@ static void nci_uart_tty_wakeup(struct tty_struct *tty)
 	nci_uart_tx_wakeup(nu);
 }
 
+/* -- Default recv_buf handler --
+ *
+ * This handler supposes that NCI frames are sent over UART link without any
+ * framing. It reads NCI header, retrieve the packet size and once all packet
+ * bytes are received it passes it to nci_uart driver for processing.
+ */
+static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
+				     int count)
+{
+	int chunk_len;
+
+	if (!nu->ndev) {
+		nfc_err(nu->tty->dev,
+			"receive data from tty but no NCI dev is attached yet, drop buffer\n");
+		return 0;
+	}
+
+	/* Decode all incoming data in packets
+	 * and enqueue then for processing.
+	 */
+	while (count > 0) {
+		/* If this is the first data of a packet, allocate a buffer */
+		if (!nu->rx_skb) {
+			nu->rx_packet_len = -1;
+			nu->rx_skb = nci_skb_alloc(nu->ndev,
+						   NCI_MAX_PACKET_SIZE,
+						   GFP_ATOMIC);
+			if (!nu->rx_skb)
+				return -ENOMEM;
+		}
+
+		/* Eat byte after byte till full packet header is received */
+		if (nu->rx_skb->len < NCI_CTRL_HDR_SIZE) {
+			skb_put_u8(nu->rx_skb, *data++);
+			--count;
+			continue;
+		}
+
+		/* Header was received but packet len was not read */
+		if (nu->rx_packet_len < 0)
+			nu->rx_packet_len = NCI_CTRL_HDR_SIZE +
+				nci_plen(nu->rx_skb->data);
+
+		/* Compute how many bytes are missing and how many bytes can
+		 * be consumed.
+		 */
+		chunk_len = nu->rx_packet_len - nu->rx_skb->len;
+		if (count < chunk_len)
+			chunk_len = count;
+		skb_put_data(nu->rx_skb, data, chunk_len);
+		data += chunk_len;
+		count -= chunk_len;
+
+		/* Chcek if packet is fully received */
+		if (nu->rx_packet_len == nu->rx_skb->len) {
+			/* Pass RX packet to driver */
+			if (nu->ops.recv(nu, nu->rx_skb) != 0)
+				nfc_err(nu->tty->dev, "corrupted RX packet\n");
+			/* Next packet will be a new one */
+			nu->rx_skb = NULL;
+		}
+	}
+
+	return 0;
+}
+
 /* nci_uart_tty_receive()
  *
  *     Called by tty low level driver when receive data is
@@ -250,7 +316,7 @@ static void nci_uart_tty_receive(struct tty_struct *tty, const u8 *data,
 		return;
 
 	spin_lock(&nu->rx_lock);
-	nu->ops.recv_buf(nu, (void *)data, flags, count);
+	nci_uart_default_recv_buf(nu, data, count);
 	spin_unlock(&nu->rx_lock);
 
 	tty_unthrottle(tty);
@@ -321,72 +387,6 @@ static int nci_uart_send(struct nci_uart *nu, struct sk_buff *skb)
 	return 0;
 }
 
-/* -- Default recv_buf handler --
- *
- * This handler supposes that NCI frames are sent over UART link without any
- * framing. It reads NCI header, retrieve the packet size and once all packet
- * bytes are received it passes it to nci_uart driver for processing.
- */
-static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
-				     char *flags, int count)
-{
-	int chunk_len;
-
-	if (!nu->ndev) {
-		nfc_err(nu->tty->dev,
-			"receive data from tty but no NCI dev is attached yet, drop buffer\n");
-		return 0;
-	}
-
-	/* Decode all incoming data in packets
-	 * and enqueue then for processing.
-	 */
-	while (count > 0) {
-		/* If this is the first data of a packet, allocate a buffer */
-		if (!nu->rx_skb) {
-			nu->rx_packet_len = -1;
-			nu->rx_skb = nci_skb_alloc(nu->ndev,
-						   NCI_MAX_PACKET_SIZE,
-						   GFP_ATOMIC);
-			if (!nu->rx_skb)
-				return -ENOMEM;
-		}
-
-		/* Eat byte after byte till full packet header is received */
-		if (nu->rx_skb->len < NCI_CTRL_HDR_SIZE) {
-			skb_put_u8(nu->rx_skb, *data++);
-			--count;
-			continue;
-		}
-
-		/* Header was received but packet len was not read */
-		if (nu->rx_packet_len < 0)
-			nu->rx_packet_len = NCI_CTRL_HDR_SIZE +
-				nci_plen(nu->rx_skb->data);
-
-		/* Compute how many bytes are missing and how many bytes can
-		 * be consumed.
-		 */
-		chunk_len = nu->rx_packet_len - nu->rx_skb->len;
-		if (count < chunk_len)
-			chunk_len = count;
-		skb_put_data(nu->rx_skb, data, chunk_len);
-		data += chunk_len;
-		count -= chunk_len;
-
-		/* Chcek if packet is fully received */
-		if (nu->rx_packet_len == nu->rx_skb->len) {
-			/* Pass RX packet to driver */
-			if (nu->ops.recv(nu, nu->rx_skb) != 0)
-				nfc_err(nu->tty->dev, "corrupted RX packet\n");
-			/* Next packet will be a new one */
-			nu->rx_skb = NULL;
-		}
-	}
-
-	return 0;
-}
-
 /* -- Default recv handler -- */
 static int nci_uart_default_recv(struct nci_uart *nu, struct sk_buff *skb)
 {
@@ -403,8 +403,6 @@ int nci_uart_register(struct nci_uart *nu)
 	nu->ops.send = nci_uart_send;
 
 	/* Install default handlers if not overridden */
-	if (!nu->ops.recv_buf)
-		nu->ops.recv_buf = nci_uart_default_recv_buf;
 	if (!nu->ops.recv)
 		nu->ops.recv = nci_uart_default_recv;
 
-- 
2.30.1

