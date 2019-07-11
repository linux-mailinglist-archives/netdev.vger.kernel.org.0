Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3A65161
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfGKFZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:25:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36188 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfGKFZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:25:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so2399784plt.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 22:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iAzKw0BoNuWYvRIzrLeTPP6dDrFST9kyO0Xv/W2qtaU=;
        b=E/e3PBgQ9/O1mYNDctMgvQ9JP5Ck/4I3S80VZF4toBAPiVDAgrviyTwC2sZQvNSJ+8
         rqBc9CSd+ScNVhuNdBxOzkoP/GY7op2PfRpfumWFKvyNfYd+2WJZFsK7sB3z1cURxgl0
         uEmaJE4HpYFWhom5pmmYwT/Fd/cHzso1rmGL9J7mv2hpFfeSGo+ncCGrCLjqDp8psUAf
         cuowLO5rLG0RFtKJHWOX4VAHvMNRblY7QbYQ7YtbKAHNhPg1o5zod0LM8I8oy3PixRg8
         2YGfEGPhDll9EPsFbfAp2CIDgqoluJP0sp/xyDLe93LooAdg+y7uAqGK0s6oQgU+Mvjk
         r8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iAzKw0BoNuWYvRIzrLeTPP6dDrFST9kyO0Xv/W2qtaU=;
        b=EXG8vNUmEd7xq/grEve77vrsGNdkrnJwTaU1wZyBFJtWQrWbLhfAgcGWI6ZSi/cVIk
         ytuGzc6fBZP3mvlnAnxu8vumtSqipx9FvinYSZjjBIc92gRgdam4YN0csmBpvj0XSdQC
         OxLIxQBTUzWsZj+PEOugdrbpto2W3WC3Rak1tPwAlgvvqWNa8PqrWdgoKCdx1xN8aK/I
         M5fgH7ZxHAZ7eCC8w0s8i19TNAFY8hMAKVgiBPKZDp406QzKJZlQPxRyFCMqSZzOLr1v
         vgiPbr3LGa6H43HGfplnwttMPklozvEQT1R9koGuBMdqMXL2H+BUHYSPlR8INm+YliVP
         HibA==
X-Gm-Message-State: APjAAAUVpzj9GICjj9keb+1Gqu5ufLiaWh7F/gb6qLgWcnXgMlzYo7AX
        O+ckGG0WjSZYDiUqZkeyCtkkaA==
X-Google-Smtp-Source: APXvYqxGCI9u1oZOuUKhbEq8FgFw3q63JFEadaGNOb5TRxahHVBCraKfOKWLZ0+otd5GC8em7POraQ==
X-Received: by 2002:a17:902:b68f:: with SMTP id c15mr2535175pls.104.1562822705862;
        Wed, 10 Jul 2019 22:25:05 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id 201sm5471345pfz.24.2019.07.10.22.25.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 22:25:05 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/2] rtw88: pci: Rearrange the memory usage for skb in RX ISR
Date:   Thu, 11 Jul 2019 13:24:26 +0800
Message-Id: <20190711052427.5582-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
References: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
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

This patch allocates a new, data-sized skb first in RX ISR. After
copying the data in, we pass it to the upper layers. However, if skb
allocation fails, we effectively drop the frame. In both cases, the
original, full size ring skb is reused.

In addition, to fixing the kernel crash, the RX routine should now
generally behave better under low memory conditions.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index cfe05ba7280d..c415f5e94fed 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	u32 pkt_offset;
 	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
 	u32 buf_desc_sz = chip->rx_buf_desc_sz;
+	u32 new_len;
 	u8 *rx_desc;
 	dma_addr_t dma;
 
@@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
 			     pkt_stat.shift;
 
-		if (pkt_stat.is_c2h) {
-			/* keep rx_desc, halmac needs it */
-			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
+		/* allocate a new skb for this frame,
+		 * discard the frame if none available
+		 */
+		new_len = pkt_stat.pkt_len + pkt_offset;
+		new = dev_alloc_skb(new_len);
+		if (WARN_ONCE(!new, "rx routine starvation\n"))
+			goto next_rp;
+
+		/* put the DMA data including rx_desc from phy to new skb */
+		skb_put_data(new, skb->data, new_len);
 
-			/* pass offset for further operation */
-			*((u32 *)skb->cb) = pkt_offset;
-			skb_queue_tail(&rtwdev->c2h_queue, skb);
+		if (pkt_stat.is_c2h) {
+			 /* pass rx_desc & offset for further operation */
+			*((u32 *)new->cb) = pkt_offset;
+			skb_queue_tail(&rtwdev->c2h_queue, new);
 			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
 		} else {
-			/* remove rx_desc, maybe use skb_pull? */
-			skb_put(skb, pkt_stat.pkt_len);
-			skb_reserve(skb, pkt_offset);
-
-			/* alloc a smaller skb to mac80211 */
-			new = dev_alloc_skb(pkt_stat.pkt_len);
-			if (!new) {
-				new = skb;
-			} else {
-				skb_put_data(new, skb->data, skb->len);
-				dev_kfree_skb_any(skb);
-			}
-			/* TODO: merge into rx.c */
-			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
+			/* remove rx_desc */
+			skb_pull(new, pkt_offset);
+
+			rtw_rx_stats(rtwdev, pkt_stat.vif, new);
 			memcpy(new->cb, &rx_status, sizeof(rx_status));
 			ieee80211_rx_irqsafe(rtwdev->hw, new);
 		}
 
-		/* skb delivered to mac80211, alloc a new one in rx ring */
-		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
-		if (WARN(!new, "rx routine starvation\n"))
-			return;
-
-		ring->buf[cur_rp] = new;
-		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
+next_rp:
+		/* new skb delivered to mac80211, re-enable original skb DMA */
+		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)
-- 
2.22.0

