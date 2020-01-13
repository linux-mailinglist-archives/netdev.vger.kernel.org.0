Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFE71397A1
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 18:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAMR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 12:27:16 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:52961 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMR1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 12:27:16 -0500
Received: by mail-ua1-f73.google.com with SMTP id n10so1427405ual.19
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 09:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JRjYbcM2SC+k7GP+rZPB/pimG3XkTeJVP6zcDS8rJ6I=;
        b=jR2K1RUZyy9DFKQOmMD3ybMYR+MFaZ8t9WQcNkb59VbrC7xNSg7YhI+wfFJE6IJIrx
         jn+ne6PyjkjquCqUurCCSpz4Jag2LYc1t5ioJzfZMtee9E4V7qR+u/MVFCzaeC4X7+Q3
         BGk07SBc70o9xWyJlz2MqN1TDMqrIuhuhXs9JrHra/VyiGpi/nqVgq9/uq6CD5RJgp+P
         7470pafwYHuPZilHRzZqj2R5nPzIe/JfAu2s1FV2l0qpdYY3J9mgXxuDlw3zQqGQJno4
         za34RTefSW3vBXeZfop4prXh0DpvjsxPoTa/h+mWI7x1C/LYwgfeVpuGQP8IJE8Zzuhp
         uyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JRjYbcM2SC+k7GP+rZPB/pimG3XkTeJVP6zcDS8rJ6I=;
        b=FB8r0ylWDtfXoJswo2mlVzJpiTfhrpfLWoq/4fDifWxQ7Kk/rkVc8g5qDueSo8mEzb
         Dlnzm61H/Hpu0MOWNYs8EXYovOFjZovy3NpZId7YXKl2xgxUZNZHEhqEZY5LM77Ce7S8
         mowji9T9PSNKvNzLd/f3nlugT7NKxQQDiz0uaVHsdHMLXElNnFF+8vRtlXTRzYxQl2O8
         tgkD7QSWklptlUUN/FJQcdx8UrfjnIvhxpr/PVUDZ9Dbsy1N8re9Ng7LE0U9ZRIRLTsv
         bjLLevV/zf1p7qY7Z65rL5avuwD3Pz/GcSqsPMWL9Ni1rlJ60MZ7t7p4V+dt98gcR9bv
         Kv8g==
X-Gm-Message-State: APjAAAVFUY54SsafbICuVQaZOtivUJ98xoSBJa340QhCLwXlf9xeRZlP
        9aob3p41dpMxH1BxgDZ7LhKvvxJZcixKLA==
X-Google-Smtp-Source: APXvYqw6yG3AWdGzdAxqr3xjLrSgtZEkzQgfBtBBt9ZAZQsk9jS8JVE7oTKbflvRsrlq8bo9HVnrpoqxbAHXcw==
X-Received: by 2002:ab0:2a93:: with SMTP id h19mr7955321uar.27.1578936435277;
 Mon, 13 Jan 2020 09:27:15 -0800 (PST)
Date:   Mon, 13 Jan 2020 09:27:11 -0800
Message-Id: <20200113172711.122918-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH net] net: usb: lan78xx: limit size of local TSO packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
bytes in the aggregated packets it builds, but does
nothing to prevent large GSO packets being submitted.

Pierre-Francois reported various hangs when/if TSO is enabled.

For localy generated packets, we can use netif_set_gso_max_size()
to limit the size of TSO packets.

Note that forwarded packets could still hit the issue,
so a complete fix might require implementing .ndo_features_check
for this driver, forcing a software segmentation if the size
of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
---
 drivers/net/usb/lan78xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index fb4781080d6dec2af22f41c5e064350ea74130b3..75bdfae5f3e20afef3d2880171c7c6e8511546c5 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3750,6 +3750,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	/* MTU range: 68 - 9000 */
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
+	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
 	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
 	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

