Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB270A3D
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbfGVUBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:01:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40893 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfGVUBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 16:01:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so40674717wrl.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 13:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NGETDvU9f7aNKaiEBJIVqn6Xb0czayqHM/uG8KDA/+M=;
        b=Y+PZAQBCeyfD0n82s4/gGHX3C2glE6J7yXohNSo3Bh76zPzU+rVHoKpjey8V2UhTBm
         i7taeDvU/WGpFk2Lx/1E7AZYdQkwsb2DpNQGN8Nwi9/fEL+XSw6kRfW/QQgPLw00Tg5v
         wA7sWv6GA9adHP4pkh9Z3DlyeOepy2kCcSnEGpZLRCxapTs4zGr0xT/cnQRPvrKuza26
         qnRU90jRk40388CkS5sn44TdbeLZSjKZqVDftiR6Hrw2+64jQGORfPoJE2cqIrau589i
         Jm2eek13JXrFUBElZJyvbJ77haXFMSPjEdEuVJI2hxxhQ3Mwy+zX8m0lelo/kR5cAt3K
         7Eqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NGETDvU9f7aNKaiEBJIVqn6Xb0czayqHM/uG8KDA/+M=;
        b=Ylty3Ak7I5AETnrbJEu0QzzKkjnfHF77SwYAmjq8u6tQYE5fVzwSgchCCoEkUQodJO
         6tG9PKdpgiRzZHxnS7eQJw5Z1B/MmmjhL2BZTa2kJ0zo+evtaF544fXdY3I+DEsyeex5
         0LAyMW0R44mxoLNTCSin0z3dFNT+zabBk4GQl2XZDjR5eyktW38nuaSmqhhMwFsL1Qz5
         pJdNGal6lYADVJaOaRY0EQHcxUZCEmx3V/q0GDAvx6rDoTfqpdomQ0qa8j3AXNBiuk1d
         ezB0gsg/qd2jWPIAHGLoQzhlam/fMkplv08mlers11wKmC+11kUfTcYQtb3uNQ4lP/tr
         e2Qw==
X-Gm-Message-State: APjAAAUC64R9vm8kOB1k8pwZUKfJSSC90klt+9kee/mPLS6FfTG4+oNQ
        tnQl33ohxi0eH1vqYJHUkBsIgN7O
X-Google-Smtp-Source: APXvYqwksuoBVkGI906nJt1aO2YViqqYPvefBVbTfJqfHJS6GlHoNuLCpXK12EzDItR31lUs3HF0GA==
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr78698851wrs.88.1563825683159;
        Mon, 22 Jul 2019 13:01:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:ac26:9618:cfee:a3e8? (p200300EA8F434200AC269618CFEEA3E8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:ac26:9618:cfee:a3e8])
        by smtp.googlemail.com with ESMTPSA id e3sm36669100wrt.93.2019.07.22.13.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 13:01:22 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl_rx
Message-ID: <c1533e9c-4287-0129-a6cf-bade51aeec26@gmail.com>
Date:   Mon, 22 Jul 2019 22:01:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves few aspects of rtl_rx, no functional change intended.

1. inline rtl8169_try_rx_copy
2. make pkt_size unsigned
3. use constant ETH_FCS_LEN instead of value 4
4. We just created the skb, so we don't need the checks in skb_put.
   Also we don't need the return value of skb_put.
   Set skb->tail and skb->len directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 43 ++++++++---------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6272115b2..9c743d2fc 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5908,23 +5908,6 @@ static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 		skb_checksum_none_assert(skb);
 }
 
-static struct sk_buff *rtl8169_try_rx_copy(void *data,
-					   struct rtl8169_private *tp,
-					   int pkt_size,
-					   dma_addr_t addr)
-{
-	struct sk_buff *skb;
-	struct device *d = tp_to_dev(tp);
-
-	dma_sync_single_for_cpu(d, addr, pkt_size, DMA_FROM_DEVICE);
-	prefetch(data);
-	skb = napi_alloc_skb(&tp->napi, pkt_size);
-	if (skb)
-		skb_copy_to_linear_data(skb, data, pkt_size);
-
-	return skb;
-}
-
 static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget)
 {
 	unsigned int cur_rx, rx_left;
@@ -5960,17 +5943,13 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				goto process_pkt;
 			}
 		} else {
+			unsigned int pkt_size;
 			struct sk_buff *skb;
-			dma_addr_t addr;
-			int pkt_size;
 
 process_pkt:
-			addr = le64_to_cpu(desc->addr);
+			pkt_size = status & GENMASK(13, 0);
 			if (likely(!(dev->features & NETIF_F_RXFCS)))
-				pkt_size = (status & 0x00003fff) - 4;
-			else
-				pkt_size = status & 0x00003fff;
-
+				pkt_size -= ETH_FCS_LEN;
 			/*
 			 * The driver does not support incoming fragmented
 			 * frames. They are seen as a symptom of over-mtu
@@ -5982,15 +5961,23 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				goto release_descriptor;
 			}
 
-			skb = rtl8169_try_rx_copy(tp->Rx_databuff[entry],
-						  tp, pkt_size, addr);
-			if (!skb) {
+			dma_sync_single_for_cpu(tp_to_dev(tp),
+						le64_to_cpu(desc->addr),
+						pkt_size, DMA_FROM_DEVICE);
+
+			skb = napi_alloc_skb(&tp->napi, pkt_size);
+			if (unlikely(!skb)) {
 				dev->stats.rx_dropped++;
 				goto release_descriptor;
 			}
 
+			prefetch(tp->Rx_databuff[entry]);
+			skb_copy_to_linear_data(skb, tp->Rx_databuff[entry],
+						pkt_size);
+			skb->tail += pkt_size;
+			skb->len = pkt_size;
+
 			rtl8169_rx_csum(skb, status);
-			skb_put(skb, pkt_size);
 			skb->protocol = eth_type_trans(skb, dev);
 
 			rtl8169_rx_vlan_tag(desc, skb);
-- 
2.22.0

