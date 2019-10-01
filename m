Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513F4C408A
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJAS6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:58:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51876 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfJAS6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:58:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so4555897wme.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VLS+i0mrs9VIQRBQEqGjdj2aSknb/G3vCgi0P+lgKa0=;
        b=kYySNO60TOx+mefJh4mGLpW4ebOO2jGgVvIi6Fr6RH6j5Xg8MQXGrLASX93HIbxcvj
         tlZkBHDgeR3tlAkolbtJ94Te+UOAEpdk7gtmzygRSJ9r4vDw1aVt/WtiXhr1HzEvVmqt
         aHkKREw3gXR3ZzLQh8iYW8weZ1FUgK0+KvHbCl76oWqyJFWrNdqEiLOJk/qQOw3lYeFB
         Pmh6vEU2hE3XhUpqHNkI6CTe84wVpfFBy3W9wJHsnmkOVBYRss3ZUcpsLg+5fNs7WdOZ
         x/S/Z0EAfufRizTWg7Fq+E0HqA1r6XAKpQ1GQOPWEbHV7qvykkMJtYWMZUsvXIYlDwdl
         7MdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VLS+i0mrs9VIQRBQEqGjdj2aSknb/G3vCgi0P+lgKa0=;
        b=DcIoyi4m8OzjAQGB/u1vHAEPW00ZbfyF242piEGa3RLc5MswP5hNm23E5JXGtwDi9J
         rjss8bVVXcPFRSB87xjcObnknBIqbLLFo7vXsXbYEbWgDmnmkWDp5BNjVn/KBx71tKWZ
         pAvzejqWOU6y2Bp+B03if/akEoJyBHqA7b1BYwcpVB0KrktBiIFvdQ70cN6hpE2KzLOZ
         JgvD9v6mGU9Njq/Ip/cy9VWu4PPxhOKklSRuGs0YymJsZk0pB3451dsbZKgcMNxscTuz
         qMhP9DGDGwo5ajp2K81zdQE11T9yvkFzpuLRvhR4fPDuw2ov3/TKbsVPtPuP1tzWsEQk
         GFgA==
X-Gm-Message-State: APjAAAWi2DQifOQ7KbBNyZiJBQOzuWBbP8IEdxQjmKJiWe581B64BWCJ
        NuUHuwweEL1x7gFBgduS2KE=
X-Google-Smtp-Source: APXvYqye2mPg2ZANJUehryB1e7VBRg9fuKWyzl0iT71qeom5h3J2YLpq7dRuKlX8aiTBKx3cMMaytA==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr5177918wmd.104.1569956308642;
        Tue, 01 Oct 2019 11:58:28 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id f143sm8066997wme.40.2019.10.01.11.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 11:58:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/2] net: dsa: sja1105: Initialize the meta_lock
Date:   Tue,  1 Oct 2019 21:58:18 +0300
Message-Id: <20191001185819.2539-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191001185819.2539-1-olteanv@gmail.com>
References: <20191001185819.2539-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, with CONFIG_DEBUG_SPINLOCK=y, this stack trace gets printed
when enabling RX timestamping and receiving a PTP frame:

[  318.537078] INFO: trying to register non-static key.
[  318.542040] the code is fine but needs lockdep annotation.
[  318.547500] turning off the locking correctness validator.
[  318.552972] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.0-13257-g0825b0669811-dirty #1962
[  318.561283] Hardware name: Freescale LS1021A
[  318.565566] [<c03144bc>] (unwind_backtrace) from [<c030e164>] (show_stack+0x10/0x14)
[  318.573289] [<c030e164>] (show_stack) from [<c11b9f50>] (dump_stack+0xd4/0x100)
[  318.580579] [<c11b9f50>] (dump_stack) from [<c03b9b40>] (register_lock_class+0x728/0x734)
[  318.588731] [<c03b9b40>] (register_lock_class) from [<c03b60c4>] (__lock_acquire+0x78/0x25cc)
[  318.597227] [<c03b60c4>] (__lock_acquire) from [<c03b8ef8>] (lock_acquire+0xd8/0x234)
[  318.605033] [<c03b8ef8>] (lock_acquire) from [<c11db934>] (_raw_spin_lock+0x44/0x54)
[  318.612755] [<c11db934>] (_raw_spin_lock) from [<c1164370>] (sja1105_rcv+0x1f8/0x4e8)
[  318.620561] [<c1164370>] (sja1105_rcv) from [<c115d7cc>] (dsa_switch_rcv+0x80/0x204)
[  318.628283] [<c115d7cc>] (dsa_switch_rcv) from [<c0f58c80>] (__netif_receive_skb_one_core+0x50/0x6c)
[  318.637386] [<c0f58c80>] (__netif_receive_skb_one_core) from [<c0f58f04>] (netif_receive_skb_internal+0xac/0x264)
[  318.647611] [<c0f58f04>] (netif_receive_skb_internal) from [<c0f59e98>] (napi_gro_receive+0x1d8/0x338)
[  318.656887] [<c0f59e98>] (napi_gro_receive) from [<c0c298a4>] (gfar_clean_rx_ring+0x328/0x724)
[  318.665472] [<c0c298a4>] (gfar_clean_rx_ring) from [<c0c29e60>] (gfar_poll_rx_sq+0x34/0x94)
[  318.673795] [<c0c29e60>] (gfar_poll_rx_sq) from [<c0f5b40c>] (net_rx_action+0x128/0x4f8)
[  318.681860] [<c0f5b40c>] (net_rx_action) from [<c03022f0>] (__do_softirq+0x148/0x5ac)
[  318.689666] [<c03022f0>] (__do_softirq) from [<c0355af4>] (irq_exit+0x160/0x170)
[  318.697040] [<c0355af4>] (irq_exit) from [<c03c6818>] (__handle_domain_irq+0x60/0xb4)
[  318.704847] [<c03c6818>] (__handle_domain_irq) from [<c07e9440>] (gic_handle_irq+0x58/0x9c)
[  318.713172] [<c07e9440>] (gic_handle_irq) from [<c0301a70>] (__irq_svc+0x70/0x98)
[  318.720622] Exception stack(0xc2001f18 to 0xc2001f60)
[  318.725656] 1f00:                                                       00000001 00000006
[  318.733805] 1f20: 00000000 c20165c0 ffffe000 c2010cac c2010cf4 00000001 00000000 c2010c88
[  318.741955] 1f40: c1f7a5a8 00000000 00000000 c2001f68 c03ba140 c030a288 200e0013 ffffffff
[  318.750110] [<c0301a70>] (__irq_svc) from [<c030a288>] (arch_cpu_idle+0x24/0x3c)
[  318.757486] [<c030a288>] (arch_cpu_idle) from [<c038a480>] (do_idle+0x1b8/0x2a4)
[  318.764859] [<c038a480>] (do_idle) from [<c038a94c>] (cpu_startup_entry+0x18/0x1c)
[  318.772407] [<c038a94c>] (cpu_startup_entry) from [<c1e00f10>] (start_kernel+0x4cc/0x4fc)

Fixes: 844d7edc6a34 ("net: dsa: sja1105: Add a global sja1105_tagger_data structure")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f3d38ff144c4..ea2e7f4f96d0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2201,6 +2201,7 @@ static int sja1105_probe(struct spi_device *spi)
 	tagger_data = &priv->tagger_data;
 	skb_queue_head_init(&tagger_data->skb_rxtstamp_queue);
 	INIT_WORK(&tagger_data->rxtstamp_work, sja1105_rxtstamp_work);
+	spin_lock_init(&tagger_data->meta_lock);
 
 	/* Connections between dsa_port and sja1105_port */
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-- 
2.17.1

