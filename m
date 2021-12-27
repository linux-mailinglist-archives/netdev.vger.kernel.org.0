Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE547FDB9
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhL0NyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 08:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhL0NyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 08:54:20 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159BEC06173E;
        Mon, 27 Dec 2021 05:54:20 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id v22so13500165qtx.8;
        Mon, 27 Dec 2021 05:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=g4y3DBv8I9/0Er3TE7fJ214VmxYgDZBGADuJ1pOAYnU=;
        b=BxivrrOfzULF2mVtGM2hK0E9oESuSo6z279/7yvKG3e0Eh2Mm8fIjK+z3mgIT61OJh
         UPDxmXRnjN6Y3A49p/I59LMNtPt0mTBdbzfWs7WFFp9nAy6955T5Exhj3OHQ8eW1RrQ6
         osj2tIrQrdC6eVn+naHOTDEw6dDbOFXtpLl0mh0Vd/WJreaE/yVZqD5DE/TYLKmfibVv
         2km9qtbzlmXL62tl6+7mit7gZpaTQItuGmJ9huSfM2YQPoOZk1Hjun1zGrRfMevpfm/m
         hdoUIU7zB0koHkq2d2Fl6c1pgQYDFKagVLad/p4ubf0rJTearttmHLrGDxYZyDXLxODf
         I59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=g4y3DBv8I9/0Er3TE7fJ214VmxYgDZBGADuJ1pOAYnU=;
        b=46M581VJgoXQLGJaJADJ8d12q9MXB1tE+XtuWDBztnqr+vGNrPPSh2X3FGGRARFBL+
         GNtpheGO+sxxIvNe30BSFuKQvsQ9Yf3IrGh6iYzSODxJiBUeLcmzKBjIIoC9H/H8k0Kc
         ECyqBWq0Z5iaab9IUeUCs+wSkplRdgGBvrVbm4uqWWrGdVXYdfr9vbStyeGT9ume/DhE
         osc8ItpJvNRMcHsTclIFtI+amfLuBaVO3Sx/l9y7r5c8BT++M7l+hfZFJ6J7CGYVLG1O
         7pdlOdv2wl+oq0jrf53gshn4iD+8LGWJ9fZfLdTaTo+EZCwNWOjhqo1isAYRhPzeQXZ+
         BKGg==
X-Gm-Message-State: AOAM5302QuOblI4xa09//kTLTP1ov70FRFywPdAsdHzx1xJEyp8tiwn8
        PioeRc9k4uuBYIivf6zcl96pRWEa+q6+xOMd
X-Google-Smtp-Source: ABdhPJwHbKxrwsNQiSO6jlHZFlPW9xCob2KiJg27u3ACtMEOsJoM0kgyNYnr8TaFUkh61qYSfHwwzA==
X-Received: by 2002:a05:622a:193:: with SMTP id s19mr12068795qtw.266.1640613259204;
        Mon, 27 Dec 2021 05:54:19 -0800 (PST)
Received: from b-10-27-92-143.dynapool.vpn.nyu.edu (vpnrasb-10wp-pat-01.natpool.nyu.edu. [216.165.95.86])
        by smtp.gmail.com with ESMTPSA id y5sm12766210qkp.103.2021.12.27.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 05:54:18 -0800 (PST)
Date:   Mon, 27 Dec 2021 08:54:16 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] rsi: fix oob in rsi_prepare_skb
Message-ID: <YcnFiGzk67p0PSgd@b-10-27-92-143.dynapool.vpn.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found this bug while fuzzing the rsi_usb driver.
rsi_prepare_skb does not check for OOB memcpy. We
add the check in the caller to fix.

Although rsi_prepare_skb checks if length is larger
than (4 * RSI_RCV_BUFFER_LEN), it really can't because
length is 0xfff maximum. So the check in patch is sufficient.

This patch is created upon ath-next branch. It is
NOT tested with real device, but with QEMU emulator.

Following is the bug report

BUG: KASAN: use-after-free in rsi_read_pkt
(/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
Read of size 3815 at addr ffff888031da736d by task RX-Thread/204

CPU: 0 PID: 204 Comm: RX-Thread Not tainted 5.6.0 #5
Call Trace:
dump_stack (/linux/lib/dump_stack.c:120)
 ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
 print_address_description.constprop.6 (/linux/mm/kasan/report.c:377)
 ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
 ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
 __kasan_report.cold.9 (/linux/mm/kasan/report.c:510)
 ? syscall_return_via_sysret (/linux/arch/x86/entry/entry_64.S:253)
 ? rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
 kasan_report (/linux/arch/x86/include/asm/smap.h:69 /linux/mm/kasan/common.c:644)
 check_memory_region (/linux/mm/kasan/generic.c:186 /linux/mm/kasan/generic.c:192)
 memcpy (/linux/mm/kasan/common.c:130)
 rsi_read_pkt (/linux/drivers/net/wireless/rsi/rsi_91x_main.c:206) rsi_91x
 ? skb_dequeue (/linux/net/core/skbuff.c:3042)
 rsi_usb_rx_thread (/linux/drivers/net/wireless/rsi/rsi_91x_usb_ops.c:47) rsi_usb

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 5d1490fc3..41d3c12e0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -193,6 +193,10 @@ int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len)
 			break;
 
 		case RSI_WIFI_DATA_Q:
+			if (!rcv_pkt_len && offset + length >
+				RSI_MAX_RX_USB_PKT_SIZE)
+				goto fail;
+
 			skb = rsi_prepare_skb(common,
 					      (frame_desc + offset),
 					      length,
-- 
2.25.1

