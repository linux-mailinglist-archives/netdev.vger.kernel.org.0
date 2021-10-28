Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BA943F2A3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 00:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhJ1WYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 18:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbhJ1WYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 18:24:14 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828AFC061570;
        Thu, 28 Oct 2021 15:21:46 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id s9so2452944qvk.12;
        Thu, 28 Oct 2021 15:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=/T5F9B07gErRjYPria9st2w4l8wiE8xoQUEOHVZGBvM=;
        b=cqtX/zRCsu1o1qbVcFQmpDrYQ3+yL++ZD059O9aXErqM7s4r2YYk5G5k6k2MU4WCXU
         5d9YWkx5fJDDC7hrEIMFECAkWrHvfrIPWk+geI54qxLUqmOAnVK02sc9AJISjJpvooQs
         0zCZZuh/1T9etRR+mtyGLfqGY/vTqliOfMm36Hb3U+/PWjc+H8oXWfwGDaFpFbs2Sla3
         u8ym2NCG/EC7t25SqQOUy3lpC//9B96QDlNOatYWD3nDfJZT2JIENAyIzoNuzazZ0g2t
         VT3fwMoXDjzXR3zxawPSPtCA56kee46tlvy9mcwY2qRL7pmL+i765nXuC+YlA9C9kE5r
         7IlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=/T5F9B07gErRjYPria9st2w4l8wiE8xoQUEOHVZGBvM=;
        b=BQNbapo5Z+vF3qShO4lMIXUvXEfZe6TjaMpsUaTq/NuC8VJAou3WiUboWA9v5w1QT0
         9v/c3Z839/ZPl8o72wzRmsZKnfvWAmC3LqdLu4NPISCVK4Dup/902JMPFhLWfMmYXzqk
         aw7YMCOLFq3tXSx2Sl3wF4raNauE51LxlBBRL9q4yIRZr9/xlpju60W7ZVPTOrceYBfZ
         ew2bBai3yHBhAnADb6yoG/U+2ckAGO8Wiq/YbEvvkaiO03NyOOaPsvvFW/Mm8C0IXdPW
         j3MfmvXq45qR4pBlOT/00CRRzU1zbLARUNnY/iuePA39L6ULZvrSw9uijsjWRjwxTM6I
         s2Lg==
X-Gm-Message-State: AOAM531XxXhmoTgdR1PLckAS6OJC/qcKhJ9o5oh0IaK3U6ig+d79nBQE
        Ns5ws9b4uKtdIfwxKB1mgLg9tS6PTzLuWQ==
X-Google-Smtp-Source: ABdhPJxrFWd7ykakPW+atJE2BnfLAVVaBklvxy7ljS6mwW0kjUE7gDDiD31OnzQ/fxQohs1eq6P5kQ==
X-Received: by 2002:a05:6214:5086:: with SMTP id kk6mr6749178qvb.63.1635459705668;
        Thu, 28 Oct 2021 15:21:45 -0700 (PDT)
Received: from 10-18-43-117.dynapool.wireless.nyu.edu (216-165-95-164.natpool.nyu.edu. [216.165.95.164])
        by smtp.gmail.com with ESMTPSA id c10sm3067773qtd.27.2021.10.28.15.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 15:21:45 -0700 (PDT)
Date:   Thu, 28 Oct 2021 18:21:42 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream
Message-ID: <YXsidrRuK6zBJicZ@10-18-43-117.dynapool.wireless.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Large pkt_len can lead to out-out-bound memcpy. Current
ath9k_hif_usb_rx_stream allows combining the content of two urb
inputs to one pkt. The first input can indicate the size of the
pkt. Any remaining size is saved in hif_dev->rx_remain_len.
While processing the next input, memcpy is used with rx_remain_len.

4-byte pkt_len can go up to 0xffff, while a single input is 0x4000
maximum in size (MAX_RX_BUF_SIZE). Thus, the patch adds a check for
pkt_len which must not exceed 2 * MAX_RX_BUG_SIZE.

BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
Read of size 46393 at addr ffff888018798000 by task kworker/0:1/23

CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 5.6.0 #63
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
Workqueue: events request_firmware_work_func
Call Trace:
 <IRQ>
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
 ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
 __kasan_report.cold+0x37/0x7c
 ? ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
 kasan_report+0xe/0x20
 check_memory_region+0x15a/0x1d0
 memcpy+0x20/0x50
 ath9k_hif_usb_rx_cb+0x490/0xed7 [ath9k_htc]
 ? hif_usb_mgmt_cb+0x2d9/0x2d9 [ath9k_htc]
 ? _raw_spin_lock_irqsave+0x7b/0xd0
 ? _raw_spin_trylock_bh+0x120/0x120
 ? __usb_unanchor_urb+0x12f/0x210
 __usb_hcd_giveback_urb+0x1e4/0x380
 usb_giveback_urb_bh+0x241/0x4f0
 ? __hrtimer_run_queues+0x316/0x740
 ? __usb_hcd_giveback_urb+0x380/0x380
 tasklet_action_common.isra.0+0x135/0x330
 __do_softirq+0x18c/0x634
 irq_exit+0x114/0x140
 smp_apic_timer_interrupt+0xde/0x380
 apic_timer_interrupt+0xf/0x20

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 860da13bf..0681bc5fa 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -589,6 +589,12 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			RX_STAT_INC(skb_dropped);
 			return;
 		}
+		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
+			dev_err(&hif_dev->udev->dev,
+				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
+			RX_STAT_INC(skb_dropped);
+			return;
+		}
 
 		pad_len = 4 - (pkt_len & 0x3);
 		if (pad_len == 4)
-- 
2.25.1

