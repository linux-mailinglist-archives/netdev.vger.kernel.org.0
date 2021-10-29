Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC9440386
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 21:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhJ2Tvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 15:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ2Tvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 15:51:36 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB6DC061570;
        Fri, 29 Oct 2021 12:49:07 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id c9so6740400qvm.5;
        Fri, 29 Oct 2021 12:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=+gnKe1uFkc5TpmUIpYEj9gZ4DQw8prrAne9JOJR9lVE=;
        b=BSbw8g3jbztD4bxkva3/5PicIHcoFbWNV1Nc3GVX6+kpIS7f8DicCMUN55/Hbn5SvL
         Bt7gpebQYA1BAFdnkg7tJfnnoENfNEx/VbIRcT0Bk5deO2485ulB65u6JhYiE4+ws7cC
         p1S3E+qTWR76sFOdj+E3/8V/Kf542EhttPFaWABZNISgn9joJHInFAFkP4IQEER+jpOP
         vTU699oQnAfp9X/1wR4qMutCbQSY8dDsv8GaPC3zCSXrd2nT6iSPiIQvtZzewsJcRJua
         a9LJ6Jx896WIloEciHC/Fg/UQ6sJWt3aCH9Xl4/heTHFNM+pgyU3gIRdh38VedNgpm+l
         fDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+gnKe1uFkc5TpmUIpYEj9gZ4DQw8prrAne9JOJR9lVE=;
        b=Z4Hrve6bpW9UdEK6bMAqodOaLjnnvO7mrMwEyCh53SFOfHpwZKSehhCOk77cCTiogy
         WhSTXj2Zx3UPd6HzrLXYuA7+eJVLgjFlDlgXrHuYZtFRaIch5OOel4e7yteGLmpnIXuW
         A5FlmgIJwTsdUiWqvwi0dnil6vBRVSQSExDsRHkHJN5SHIRdqsHXuv/Ru1f87Ai/BRjK
         443nSt5HfoDuJrSL/raSbe5JHTYh4jUZynbiI1u6ftUFi1Bf5J9xapE5eJNe5iGlwgto
         dOHzgi+NL9CwQBhk+eVH7SCbMVfY2m9BlqHn3WifTa5NeXc3IgqXBjkrlj8PcXrmhC2n
         LnVg==
X-Gm-Message-State: AOAM5321JtIY4GasRRIz0B/aJAfZQg00W/jNn5lAwOQu4MBu2/Gev7Aw
        /EByVsj1+leC4MRROScOpsY=
X-Google-Smtp-Source: ABdhPJyO1keEiJvG9UlTmcyvdIGEdNVmxfcobLYeJ4UAwpoJlR9Z3NYRUDve0KXpY+Erpepmqm6Xvw==
X-Received: by 2002:ad4:5c63:: with SMTP id i3mr13304188qvh.2.1635536946243;
        Fri, 29 Oct 2021 12:49:06 -0700 (PDT)
Received: from 10-18-43-117.dynapool.wireless.nyu.edu (216-165-95-181.natpool.nyu.edu. [216.165.95.181])
        by smtp.gmail.com with ESMTPSA id az12sm4505125qkb.28.2021.10.29.12.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:49:05 -0700 (PDT)
Date:   Fri, 29 Oct 2021 15:49:03 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] rsi_usb: Fix use-after-free in rsi_rx_done_handler
Message-ID: <YXxQL/vIiYcZUu/j@10-18-43-117.dynapool.wireless.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When freeing rx_cb->rx_skb, the pointer is not set to NULL,
a later rsi_rx_done_handler call will try to read the freed
address.
This bug will very likley lead to double free, although
detected early as use-after-free bug.

The bug is triggerable with a compromised/malfunctional usb
device. After applying the patch, the same input no longer
triggers the use-after-free.

Attached is the kasan report from fuzzing.

BUG: KASAN: use-after-free in rsi_rx_done_handler+0x354/0x430 [rsi_usb]
Read of size 4 at addr ffff8880188e5930 by task modprobe/231
Call Trace:
 <IRQ>
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __kasan_report.cold+0x37/0x7c
 ? dma_direct_unmap_page+0x90/0x110
 ? rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 kasan_report+0xe/0x20
 rsi_rx_done_handler+0x354/0x430 [rsi_usb]
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __usb_hcd_giveback_urb+0x380/0x380
 ? apic_timer_interrupt+0xa/0x20
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 ? handle_irq_event+0xcd/0x157
 ? handle_edge_irq+0x1eb/0x7b0
 irq_exit+0x114/0x140
 do_IRQ+0x91/0x1e0
 common_interrupt+0xf/0xf
 </IRQ>

Reported-by: Zekun Shen <bruceshenzk@gmail.com>
Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 416976f09..d9e9bf26e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -272,8 +272,12 @@ static void rsi_rx_done_handler(struct urb *urb)
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)rx_cb->data;
 	int status = -EINVAL;
 
+	if (!rx_cb->rx_skb)
+		return;
+
 	if (urb->status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
 		return;
 	}
 
@@ -297,8 +301,10 @@ static void rsi_rx_done_handler(struct urb *urb)
 	if (rsi_rx_urb_submit(dev->priv, rx_cb->ep_num, GFP_ATOMIC))
 		rsi_dbg(ERR_ZONE, "%s: Failed in urb submission", __func__);
 
-	if (status)
+	if (status) {
 		dev_kfree_skb(rx_cb->rx_skb);
+		rx_cb->rx_skb = NULL;
+	}
 }
 
 static void rsi_rx_urb_kill(struct rsi_hw *adapter, u8 ep_num)
-- 
2.25.1

