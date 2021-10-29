Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A14403F5
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhJ2UV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhJ2UV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 16:21:56 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229D7C061570;
        Fri, 29 Oct 2021 13:19:27 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id 19so8670533qtt.7;
        Fri, 29 Oct 2021 13:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=V1vZM1rn/vf1mH3nnfwhGs4Yv2g9sjHwncQx+vzOpzI=;
        b=mzQD1q6deK8up7ZSeFDlymCWC+5xY+rzC6C3Cd8+T//bmebUn5xMmDAnMejgHHWeKT
         i6a+9TBTaN5PjooepEBqg11b9EDqE0r8nqwgnfRZN4t5ZtbuON+gB6cIsqzTKLcyJDPB
         djgXvKRwLM7lMZvdIJW6LRUrRcqGvsDNW7PZiNj7Cb7FHAdMnoa64hudAK7FmKFPjvfJ
         KPoXuwGF8oJrVDme9QGJR08tjVRCMYcadiOjX3PqK/hyAQIn1SjzXT7N5n4iLeOw43jB
         722htxqBttEwxl4/Z6ssOmdW6B/bBS3D+j/2J/x6Q7rBnsP2PlZWroE2ZzG1Cpf6otyI
         xP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=V1vZM1rn/vf1mH3nnfwhGs4Yv2g9sjHwncQx+vzOpzI=;
        b=4q4rkMzgZ1ONq5KgrvbR65AjqO1vfcNk2sT8djWqcxN+oi4nsZ6IkIeouBRmVR9y7X
         h3PXaM74RuNWBZBXCblKlZ6YvePVle+58DLmzPA9WpHZfbAy6lmG5OoVMAHMVQ+yh1xb
         DGd1NMULnH0/6qZ7gE/WqiSAIJnGvKUwathVglgyzs85lGFBLNPNWvKiv4UYMw+IAPon
         Lf9922jA/W7/0UKGRASt7btDlTQHRHAvYFvdOmlzY+mBaSSZj0QDL2wxyTp4k7cHCaEM
         X/6dtsv3qPL75hWHW8xbTko9fFAExxmIuTat8/pjyk1wAT9ZwTr7bFAYfeXv/2pfE3vc
         LY8A==
X-Gm-Message-State: AOAM531wPoAp8A5MniiBR0rOuDd4FfQ+1g1YKWh5h8ZdL4mbYQVXwown
        a3D3ZB2ru9jqmTeERcrXWE8=
X-Google-Smtp-Source: ABdhPJxiA8ZUQJ4ch2G+XXXE/WIShjgGf+XD5EwZrgYyc4wwaCQKw3Yjyr7rPfTFI1FEcuDDl+sECg==
X-Received: by 2002:a05:622a:28b:: with SMTP id z11mr926190qtw.193.1635538766259;
        Fri, 29 Oct 2021 13:19:26 -0700 (PDT)
Received: from 10-18-43-117.dynapool.wireless.nyu.edu (216-165-95-181.natpool.nyu.edu. [216.165.95.181])
        by smtp.gmail.com with ESMTPSA id c10sm5072943qtd.27.2021.10.29.13.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:19:25 -0700 (PDT)
Date:   Fri, 29 Oct 2021 16:19:23 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] rsi_usb: Fix out-of-bounds read in rsi_read_pkt
Message-ID: <YXxXS4wgu2OsmlVv@10-18-43-117.dynapool.wireless.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rsi_get_* functions rely on an offset variable from usb
input. The size of usb input is RSI_MAX_RX_USB_PKT_SIZE(3000),
while 2-byte offset can be up to 0xFFFF. Thus a large offset
can cause out-of-bounds read.

The patch adds a bound checking condition when rcv_pkt_len is 0,
indicating it's USB. It's unclear whether this is triggerable
from other type of bus. The following check might help in that case.
offset > rcv_pkt_len - FRAME_DESC_SZ

The bug is trigerrable with conpromised/malfunctioning USB devices.
I tested the patch with the crashing input and got no more bug report.

Attached is the KASAN report from fuzzing.

BUG: KASAN: slab-out-of-bounds in rsi_read_pkt+0x42e/0x500 [rsi_91x]
Read of size 2 at addr ffff888019439fdb by task RX-Thread/227

CPU: 0 PID: 227 Comm: RX-Thread Not tainted 5.6.0 #66
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 __kasan_report.cold+0x37/0x7c
 ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
 kasan_report+0xe/0x20
 rsi_read_pkt+0x42e/0x500 [rsi_91x]
 rsi_usb_rx_thread+0x1b1/0x2fc [rsi_usb]
 ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
 ? _raw_spin_lock_irqsave+0x7b/0xd0
 ? _raw_spin_trylock_bh+0x120/0x120
 ? __wake_up_common+0x10b/0x520
 ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
 kthread+0x2b5/0x3b0
 ? kthread_create_on_node+0xd0/0xd0
 ret_from_fork+0x22/0x40

Reported-by: Zekun Shen <bruceshenzk@gmail.com>
Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 4 ++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 1 -
 drivers/net/wireless/rsi/rsi_usb.h      | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index d98483298..61fc27714 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -23,6 +23,7 @@
 #include "rsi_common.h"
 #include "rsi_coex.h"
 #include "rsi_hal.h"
+#include "rsi_usb.h"
 
 u32 rsi_zone_enabled = /* INFO_ZONE |
 			INIT_ZONE |
@@ -168,6 +169,9 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 		frame_desc = &rx_pkt[index];
 		actual_length = *(u16 *)&frame_desc[0];
 		offset = *(u16 *)&frame_desc[2];
+		if (!rcv_pkt_len && offset >
+			RSI_MAX_RX_USB_PKT_SIZE - FRAME_DESC_SZ)
+			goto fail;
 
 		queueno = rsi_get_queueno(frame_desc, offset);
 		length = rsi_get_length(frame_desc, offset);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index d9e9bf26e..49ae4ae69 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -333,7 +333,6 @@ static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num, gfp_t mem_flags)
 	struct sk_buff *skb;
 	u8 dword_align_bytes = 0;
 
-#define RSI_MAX_RX_USB_PKT_SIZE	3000
 	skb = dev_alloc_skb(RSI_MAX_RX_USB_PKT_SIZE);
 	if (!skb)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 254d19b66..961851748 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -44,6 +44,8 @@
 #define RSI_USB_BUF_SIZE	     4096
 #define RSI_USB_CTRL_BUF_SIZE	     0x04
 
+#define RSI_MAX_RX_USB_PKT_SIZE	3000
+
 struct rx_usb_ctrl_block {
 	u8 *data;
 	struct urb *rx_urb;
-- 
2.25.1

