Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE79D7C8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfHZUwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:52:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34847 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfHZUwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:52:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so818785wmg.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9N2v7ISYhpaK5On/VTUK+7xPfi2wU1UeG6iLcwR65LI=;
        b=uTAxFfXRmJoJASOP69IvsJCxZJfMkLk+6CwzEu41Mqs5q+YVRUHxcMm+SV4ZQ+0Wm+
         chka2S8vVhHCauLs13xuJeD8b1tVe8jt1Bq/Tv88Lu/ZDcygP2RZNHDn+UW8oppVOrvL
         4xNICCLM2tV8Sov6bA+LFmc6utsgvruDlcfT+OLrZcbcrbyxMVC88OrduriOIh79Vz8V
         YEBJffck+l3RdyBNxALz8RQfmRFC3RNTjW20XOG5DyTRVwELgdOb10izhkGdabPS35SV
         qMpDBBKVzHp2RbTwpoWII/PEhoeiCPudYgTMF1lFWH8/BIOsfKdqzqey6v5qnTO5xDfD
         sPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9N2v7ISYhpaK5On/VTUK+7xPfi2wU1UeG6iLcwR65LI=;
        b=SGyJU2nw4mFR7oRwhOVR1Iy/eIW1WsiyUmU8kG+zKUTTGJ+QJyY5L9FhUc9xHWVamJ
         APaaytr9LxIE0juXE4tR4wQ7+qXGZhxMqjCYf9cltlVx/Mwo3V6fEhz8TJJfmGAi/Sdt
         JOkifr9hdgYCr3db47NvnJhTDf/Zwr24CPD576hAuKZsbb+HZ1DVV7CJVixR4kvBfS5L
         m8XeliuOXbI2VBF1TV5fQyZiAElPkuY67ReWZI8Ai4oOzudYD8L6qIHFU9hnc1sa+4Ky
         I6i335D2ZDOpbVCxbQHkj3qGgZMdSYIMLOEC+N4aJgfATJCvumtV7VJnzKqZ0g5D4GDi
         yMeg==
X-Gm-Message-State: APjAAAXvUQBng0D8/0ONQcoh8m6wChzz4IxwntZZ6DFxDI53wLeZ8+MZ
        nlRcb8tt3FPhh9joxCMel1O83Pm0
X-Google-Smtp-Source: APXvYqyuwXo/J9z4A7rRWdQAfeuHtDWFkE7zvpLCEcu49nV/CP/dgCQ82fsTC0TDueyeeu2FLAAubw==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr22542210wmj.37.1566852761193;
        Mon, 26 Aug 2019 13:52:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:787f:2a92:ccfe:e1e4? (p200300EA8F047C00787F2A92CCFEE1E4.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:787f:2a92:ccfe:e1e4])
        by smtp.googlemail.com with ESMTPSA id m188sm1362341wmm.32.2019.08.26.13.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 13:52:40 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve DMA handling in rtl_rx
Message-ID: <32c6566d-12c3-a01e-c8b0-f68c32949c2c@gmail.com>
Date:   Mon, 26 Aug 2019 22:52:36 +0200
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

Move the call to dma_sync_single_for_cpu after calling napi_alloc_skb.
This avoids calling dma_sync_single_for_cpu w/o handing control back
to device if the memory allocation should fail.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6182e7d33..faa4041cf 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5807,16 +5807,15 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				goto release_descriptor;
 			}
 
-			dma_sync_single_for_cpu(tp_to_dev(tp),
-						le64_to_cpu(desc->addr),
-						pkt_size, DMA_FROM_DEVICE);
-
 			skb = napi_alloc_skb(&tp->napi, pkt_size);
 			if (unlikely(!skb)) {
 				dev->stats.rx_dropped++;
 				goto release_descriptor;
 			}
 
+			dma_sync_single_for_cpu(tp_to_dev(tp),
+						le64_to_cpu(desc->addr),
+						pkt_size, DMA_FROM_DEVICE);
 			prefetch(rx_buf);
 			skb_copy_to_linear_data(skb, rx_buf, pkt_size);
 			skb->tail += pkt_size;
-- 
2.23.0

