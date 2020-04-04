Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30519E2B2
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 06:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgDDETR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 00:19:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46882 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgDDETO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 00:19:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id q3so4616751pff.13;
        Fri, 03 Apr 2020 21:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3OVVO2ADZTyoYC8jre3rfDNBGTuwirm9KZaN24KTPZs=;
        b=ECUuerOUIFC8DX9onGTQDa/VE/1inoBXbJbYpJKcpDIsMUzPulztXLMIcwzKtLeMfw
         AH2JWuRToGh6rca/dMLlK9w2thPCuel13eESSvGkURJ1LmzfPzD61SYobIw6IOp2ORSh
         l7J2N4hj0J+Mnp+jv2ployrdJkzE2BsB3zfDOK95aXy6wLJgpvqnT6pamk6MfWUgYjoL
         mMlbyUZCIwEg74ZjLUTb07+fKTesQPYPLyB4266ogQBXJEmslOInBRqGu6kkHk+Bh0tJ
         qNWOBVdB2U/YXUrp6UGC8QOLesbQ9Bp+lh9osa01fpI7lh/uYk0PNIDjzFD/2tvwtnC6
         DM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3OVVO2ADZTyoYC8jre3rfDNBGTuwirm9KZaN24KTPZs=;
        b=Y4In64D+aUKnTuvRoy3MpMODLNO97rXJtfCLPapMeFOT2GDdYbDdfYHLBHHZzFkZHn
         opDQkUmczHYKG57M2l6Q+TBHIPqu7CXc7YuKyYEQ38/IJP+SoGB06Bhl4Sp1Rp0DuOP1
         t6TCN9668icB3dh2jbgtviDDQE26Vpb7ENbdCa3+2amZ1vGGzdIWTLDxsOFv/af0VKsY
         DoKIMbd5GUiV8TJpgY1di9a5TD+j7NT+Y1q53rEXZfLrYt22AFOY2ouK9r/351AF6okR
         MP2NiqT7tlapbGNhjX6Pt5anFdYFq/dZjWGRnXmLP0ADUaaYtiG1uw1BXd63KhgUabDe
         p19Q==
X-Gm-Message-State: AGi0PuZPa3hlFx7KtEHlWyQGu+xG9whkL3MMDMlbRUrPD96hLTxlu4bM
        XW+aS6ORWq6x1x3XueytYNY=
X-Google-Smtp-Source: APiQypKbx4aANJac1C3/+xhGPTGLleu4ehIjCpaJTeu55IV9MA+A202LOsa/nvPet5D5AbwNOfzXaQ==
X-Received: by 2002:a63:be49:: with SMTP id g9mr11313692pgo.30.1585973951390;
        Fri, 03 Apr 2020 21:19:11 -0700 (PDT)
Received: from localhost (n112120135125.netvigator.com. [112.120.135.125])
        by smtp.gmail.com with ESMTPSA id x68sm5404129pfb.5.2020.04.03.21.19.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 21:19:11 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH 4/5 resend] ath9x: Fix stack-out-of-bounds Write in ath9k_hif_usb_rx_cb
Date:   Sat,  4 Apr 2020 12:18:37 +0800
Message-Id: <20200404041838.10426-5-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200404041838.10426-1-hqjagain@gmail.com>
References: <20200404041838.10426-1-hqjagain@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add barrier to accessing the stack array skb_pool.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000003d7c1505a2168418@google.com
BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_stream
drivers/net/wireless/ath/ath9k/hif_usb.c:626 [inline]
BUG: KASAN: stack-out-of-bounds in ath9k_hif_usb_rx_cb+0xdf6/0xf70
drivers/net/wireless/ath/ath9k/hif_usb.c:666
Write of size 8 at addr ffff8881db309a28 by task swapper/1/0

Call Trace:
ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:626
[inline]
ath9k_hif_usb_rx_cb+0xdf6/0xf70
drivers/net/wireless/ath/ath9k/hif_usb.c:666
__usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+d403396d4df67ad0bd5f@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f227e19087ff..6049d3766c64 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -612,6 +612,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			hif_dev->remain_skb = nskb;
 			spin_unlock(&hif_dev->rx_lock);
 		} else {
+			if (pool_index == MAX_PKT_NUM_IN_TRANSFER) {
+				dev_err(&hif_dev->udev->dev,
+					"ath9k_htc: over RX MAX_PKT_NUM\n");
+				goto err;
+			}
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
 				dev_err(&hif_dev->udev->dev,
-- 
2.17.1

