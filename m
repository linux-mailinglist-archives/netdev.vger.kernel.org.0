Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7116901D
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 17:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgBVQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 11:03:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36643 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbgBVQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 11:03:00 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so5414545wru.3
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 08:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/eYZwDQSQmZmDfkI2D7BwUz9cDyUzE8qZ14c7LJiRf8=;
        b=IxNdIfmVssyepd6I5k3ueI/vz4oq+ytzkfE2+C0MiRaB1QGxYHTBYzym56d2wZ6IqN
         Ssgfvr3NOKZ4nRHvvEd1yJDK+tvsyXkO/GzlZ+8iou5oqoTdp8lifaQntTUtr1ZiR9KP
         wh4UDeRmOFMwYNiKqH1zbRRp5fuJluHXQyc1hqT3ZWI2hVn0+8D98C6WKmN8kmtUY/Ax
         bJQyLilrw80elpVbvlcCwa+WYXeg05KsB8m7LI5niqYrIuqBgDv9Ch0FAYwb4dyZ8Cxz
         O9RtXUhfFoFNpy1FD1qRcpHumZq4/XJ6KARlZLRrH2ObyktFhErD1gOd3tqxzTWCcJTu
         Zn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/eYZwDQSQmZmDfkI2D7BwUz9cDyUzE8qZ14c7LJiRf8=;
        b=Je+v7MPWJ2CBnkRHm2hjaMqbfZr5VYWae8X47drW/LB9eYPVzZvVwly3SDhCvmUYuT
         Dkfle5TCKCgUTDAJsBtBwqUhLs4QLWPn4CHbCfnKm+8jWmeLioR6rxsYlIAIx0o43vVZ
         6lREqKmYL+WmH+rdA3gI/J/2cHCU6Ffl5AdoBPJJtI9EW+yB88l2ye8zwZOpuuqTGdE4
         VlgJp+4ThRqRABT7zre5NA63kkJ7VUEsld+6808GrO3J3ZTlrosYyFQGdBEHr4b1WHhh
         3gB6H7izARSuwMf4CfdQgzJQRoBwBD4EoXRCBIxi0WsUZ/DcaIT9nnAO8wz6YlKX2Xa2
         akMg==
X-Gm-Message-State: APjAAAUOoDXE3d2152C8wjwN2JRSXQaHzUoqarHcBA6Q3A2qzr41NrLj
        4LfyQRKAv2tISnaQyPcyIKzHgTcH
X-Google-Smtp-Source: APXvYqyAfwddqJjacA9SKkqFdu3pGaiyyNfw3MJtE8NbweEtcjBSTU85ecOz0VKU02d6ANx28qeyqw==
X-Received: by 2002:adf:e550:: with SMTP id z16mr56873609wrm.5.1582387378091;
        Sat, 22 Feb 2020 08:02:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:a18c:254e:e7c9:3c6f? (p200300EA8F296000A18C254EE7C93C6F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a18c:254e:e7c9:3c6f])
        by smtp.googlemail.com with ESMTPSA id e1sm8887242wrt.84.2020.02.22.08.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 08:02:57 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl8169_start_xmit
Message-ID: <ee5d5f3a-aaf8-a33d-da45-05843e990140@gmail.com>
Date:   Sat, 22 Feb 2020 17:02:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only call rtl8169_xmit_frags() if the skb is actually fragmented.
This avoid a small overhead for non-fragmented skb's, and it allows
to simplify rtl8169_xmit_frags() a little.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index cc4b6fd60..f081007a2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4087,12 +4087,10 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 		tp->tx_skb[entry].len = len;
 	}
 
-	if (cur_frag) {
-		tp->tx_skb[entry].skb = skb;
-		txd->opts1 |= cpu_to_le32(LastFrag);
-	}
+	tp->tx_skb[entry].skb = skb;
+	txd->opts1 |= cpu_to_le32(LastFrag);
 
-	return cur_frag;
+	return 0;
 
 err_out:
 	rtl8169_tx_clear_range(tp, tp->cur_tx + 1, cur_frag);
@@ -4217,6 +4215,7 @@ static void rtl8169_doorbell(struct rtl8169_private *tp)
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
+	unsigned int frags = skb_shinfo(skb)->nr_frags;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
 	struct TxDesc *txd = tp->TxDescArray + entry;
@@ -4225,9 +4224,8 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	u32 opts[2], len;
 	bool stop_queue;
 	bool door_bell;
-	int frags;
 
-	if (unlikely(!rtl_tx_slots_avail(tp, skb_shinfo(skb)->nr_frags))) {
+	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
 		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
 	}
@@ -4256,14 +4254,13 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	tp->tx_skb[entry].len = len;
 	txd->addr = cpu_to_le64(mapping);
 
-	frags = rtl8169_xmit_frags(tp, skb, opts);
-	if (frags < 0)
-		goto err_dma_1;
-	else if (frags)
-		opts[0] |= FirstFrag;
-	else {
+	if (!frags) {
 		opts[0] |= FirstFrag | LastFrag;
 		tp->tx_skb[entry].skb = skb;
+	} else {
+		if (rtl8169_xmit_frags(tp, skb, opts))
+			goto err_dma_1;
+		opts[0] |= FirstFrag;
 	}
 
 	txd->opts2 = cpu_to_le32(opts[1]);
-- 
2.25.1

