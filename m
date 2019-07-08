Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A324561ABA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 08:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfGHGgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 02:36:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42485 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbfGHGgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 02:36:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so7706705plb.9
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 23:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U5faaB2QS25gWcbZp0574GO7urSkcBDHpx7JYrayj6s=;
        b=k8AtqPPBAIU9BFgDc1LoJIroW15SoAkdAibpdma80r6iYC7+o9XxniV5aE+9a8Kcy7
         JsfzCV4LoqoMGDyWAXbL8IqAQQ6ANOsk74ESWQ972qbNDrsf0Irzbm8rGHqwIZwaewZ7
         xkEHNYC2wm5qTxlC8E8dWNp8znXKneU6XMJxcjqwsyaNSHV6/76+2bcasa5kmADB+UPl
         hrxgyIIvLY8QT2pUiwg+zKSWMI72eaq9go97g8Mey4V6Z/F0DBGAgHPc80HwTl4ARX9N
         GUUEo6RT5DvII4ycF6gwUa1uuC0n630vdKZU5IWN1FBLlL+7AtHDxs+y2iUQNTzI8yo1
         02kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U5faaB2QS25gWcbZp0574GO7urSkcBDHpx7JYrayj6s=;
        b=tAXar5m+3MVaTcyscH968PqxA6+m6oCD8EuEq2eWnVxtHA84M223ax5STrY5SqW4+C
         kt5iCjeO8/3GtNgCo4V1gOA97A+QwVPjb3aCkKmLNmTxNNmK/gcQGm03FcVcv1GDdgqF
         h94kSW/nYN7pJ7ym7G2xffqz7pbM2VFFkTmboSYWpBXNH1HaIKWnD8cI5IHC/CpHEGO3
         jNYyh4Jkoz7/EPIxe0D47pL5av6bH+McRwvKaQB8/ATkVKKfR4RgVM3FlLBSN1kRXxeo
         HvWnP4TGW3roJRFR8P5uZfEI8MOaBX8dS4A4zQ2NLWqZsCukOpU1mlkMiwxawlFxwu3z
         3Qog==
X-Gm-Message-State: APjAAAXkBk1EIsAOg92W/PSxyenhrXbi8X3Aknn1/u+Hk4qAAMKRKK6u
        fJhjYoOZp6Jm6MZ/2mbIl1Z4ng==
X-Google-Smtp-Source: APXvYqxA2c9ltYeJuPS/96QyMzXMHZoAV+lGrhI7hijTtcZlfz7f4W53t2DqphIMtl/XnK0J1m4Lvw==
X-Received: by 2002:a17:902:724:: with SMTP id 33mr21908419pli.49.1562567804038;
        Sun, 07 Jul 2019 23:36:44 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id s66sm21388130pgs.39.2019.07.07.23.36.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 23:36:43 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Date:   Mon,  8 Jul 2019 14:32:53 +0800
Message-Id: <20190708063252.4756-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Testing with RTL8822BE hardware, when available memory is low, we
frequently see a kernel panic and system freeze.

First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):

rx routine starvation
WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:822 rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
[ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]

Then we see a variety of different error conditions and kernel panics,
such as this one (trimmed):

rtw_pci 0000:02:00.0: pci bus timeout, check dma status
skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:00000000d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:105!
invalid opcode: 0000 [#1] SMP NOPTI
RIP: 0010:skb_panic+0x43/0x45

When skb allocation fails and the "rx routine starvation" is hit, the
function returns immediately without updating the RX ring. At this
point, the RX ring may continue referencing an old skb which was already
handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
bad things happen.

This patch allocates a new skb first in RX ISR. If we don't have memory
available, we discard the current frame, allowing the existing skb to be
reused in the ring. Otherwise, we simplify the code flow and just hand
over the RX-populated skb over to mac80211.

In addition, to fixing the kernel crash, the RX routine should now
generally behave better under low memory conditions.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Reviewed-by: Daniel Drake <drake@endlessm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 28 +++++++++++-------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index cfe05ba7280d..1bfc99ae6b84 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -786,6 +786,15 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		rx_desc = skb->data;
 		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
 
+		/* discard current skb if the new skb cannot be allocated as a
+		 * new one in rx ring later
+		 * */
+		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
+		if (WARN(!new, "rx routine starvation\n")) {
+			new = skb;
+			goto next_rp;
+		}
+
 		/* offset from rx_desc to payload */
 		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
 			     pkt_stat.shift;
@@ -803,25 +812,14 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 			skb_put(skb, pkt_stat.pkt_len);
 			skb_reserve(skb, pkt_offset);
 
-			/* alloc a smaller skb to mac80211 */
-			new = dev_alloc_skb(pkt_stat.pkt_len);
-			if (!new) {
-				new = skb;
-			} else {
-				skb_put_data(new, skb->data, skb->len);
-				dev_kfree_skb_any(skb);
-			}
 			/* TODO: merge into rx.c */
 			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
-			memcpy(new->cb, &rx_status, sizeof(rx_status));
-			ieee80211_rx_irqsafe(rtwdev->hw, new);
+			memcpy(skb->cb, &rx_status, sizeof(rx_status));
+			ieee80211_rx_irqsafe(rtwdev->hw, skb);
 		}
 
-		/* skb delivered to mac80211, alloc a new one in rx ring */
-		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
-		if (WARN(!new, "rx routine starvation\n"))
-			return;
-
+next_rp:
+		/* skb delivered to mac80211, attach the new one into rx ring */
 		ring->buf[cur_rp] = new;
 		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
 
-- 
2.22.0

