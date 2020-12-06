Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0897D2D007B
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgLFEQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbgLFEPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:15:36 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB84C061A4F;
        Sat,  5 Dec 2020 20:14:42 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id y18so9519611qki.11;
        Sat, 05 Dec 2020 20:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1fQ8taidIHERFu9rhcc1f+DqlLhV709thCI4SV5pbwM=;
        b=CLtHLijzL6iHSV2EfWfF0rlAvpyproBVCjJLl1c8jCdXAVnwybHGj9EbWdsXHGTqxS
         6KaxfUszSWXmse1eSPNOoYNMt3uApwYxTQEBpXlGBJWPPym2ScBDgfLa0xmVei+dHGk3
         NYDYReXM0Vn5CjZJ2QnozOwGoMn1+DatxvZuKp5VVgmMAkFf6z8yutRZD7NkcL+n30XP
         ead+w6LDC1zksPJbQrUy2NzrjKzAtPM850COB9RPyO6xMuBH2Rq2msZgL5heORjYcqRQ
         1ZkpRx0RCs0vzIuTyVf55vysvdIIJPYElT3NckaSsPt2BxjBCzDX4HpoOHtU7V26R7Hr
         mdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1fQ8taidIHERFu9rhcc1f+DqlLhV709thCI4SV5pbwM=;
        b=oiwGqJIn5rNJkytgSU6jiDqJNvlkGXD/JitSNmWoIilDBY7+9xcdyytXOuP+Sj1uUz
         ZxLzZLXZX+datvjhiNXNBAOD5AB6gTRdQgallKID54GqKBH2m11RXL9IkX4SCT/3mXUV
         bnTNJFqRdnsWWUcl72f6vwCzzyIB0pivB++D70oiABZ1DIzptSZj5wy5Qf1QSg6BygRw
         GFHbvAcLvwKd4w2fdHtweoCDTKX2bcCZIoOSAoJUDGG1gJK5xUOBwdw5ZDaQUXfVKCPM
         u2RMXJx9cIowaq5JCj4HRf9F7Ih/hpg3HMJZamUJDZ3PJ3viw2e38iRwAWy2uTpsiAj+
         4ybQ==
X-Gm-Message-State: AOAM531+4hIQFAlKB3jIHsWeWfvZ7qR2BhDzcnX+hNZmqWdXtxw0cZYm
        6BfxVViwHOdPUVgrODbP2lF2EjvFfiqBWA==
X-Google-Smtp-Source: ABdhPJxvrfOk5f5DBj/uaPwz6OOcc0Aa4YonJ+1Jed7MZk/QWC1C9TZ/J7Ths9985VW6LO7gua+5oQ==
X-Received: by 2002:ac8:a01:: with SMTP id b1mr17705127qti.217.1607226253200;
        Sat, 05 Dec 2020 19:44:13 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id z186sm9364566qke.100.2020.12.05.19.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 19:44:12 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe bandwidth requirement
Date:   Sat,  5 Dec 2020 22:44:08 -0500
Message-Id: <20201206034408.31492-2-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206034408.31492-1-TheSven73@gmail.com>
References: <20201206034408.31492-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

To support jumbo frames, each rx ring dma buffer is 9K in size.
But the chip only stores a single frame per dma buffer.

When the chip is working with the default 1500 byte MTU, a 9K
dma buffer goes from chip -> cpu per 1500 byte frame. This means
that to get 1G/s ethernet bandwidth, we need 6G/s PCIe bandwidth !

Fix by limiting the rx ring dma buffer size to the current MTU
size.

Tested with iperf3 on a freescale imx6 + lan7430, both sides
set to mtu 1500 bytes.

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec   483 MBytes   203 Mbits/sec    0
After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec  1.15 GBytes   496 Mbits/sec    0

And with both sides set to MTU 9000 bytes:
Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec  1.87 GBytes   803 Mbits/sec   27
After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-20.00  sec  1.98 GBytes   849 Mbits/sec    0

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 905b2032fa42

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index ebb5e0bc516b..2bded1c46784 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1957,11 +1957,11 @@ static int lan743x_rx_next_index(struct lan743x_rx *rx, int index)
 
 static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
 {
-	int length = 0;
+	struct net_device *netdev = rx->adapter->netdev;
 
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
-	return __netdev_alloc_skb(rx->adapter->netdev,
-				  length, GFP_ATOMIC | GFP_DMA);
+	return __netdev_alloc_skb(netdev,
+				  netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING,
+				  GFP_ATOMIC | GFP_DMA);
 }
 
 static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
@@ -1969,9 +1969,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 {
 	struct lan743x_rx_buffer_info *buffer_info;
 	struct lan743x_rx_descriptor *descriptor;
-	int length = 0;
+	struct net_device *netdev = rx->adapter->netdev;
+	int length;
 
-	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
+	length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
 	buffer_info->skb = skb;
@@ -2157,8 +2158,8 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			int index = first_index;
 
 			/* multi buffer packet not supported */
-			/* this should not happen since
-			 * buffers are allocated to be at least jumbo size
+			/* this should not happen since buffers are allocated
+			 * to be at least the mtu size configured in the mac.
 			 */
 
 			/* clean up buffers */
@@ -2632,9 +2633,13 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 	int ret = 0;
 
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ret = lan743x_mac_set_mtu(adapter, new_mtu);
 	if (!ret)
 		netdev->mtu = new_mtu;
+
 	return ret;
 }
 
-- 
2.17.1

