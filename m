Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DB62B0D10
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKLS74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKLS7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:59:55 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB26C0613D1;
        Thu, 12 Nov 2020 10:59:54 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id l2so6380250qkf.0;
        Thu, 12 Nov 2020 10:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IDS5Oufash5YwJYyq/CZbnqZxwavmq4JVvZ9D8fSXfI=;
        b=WqdwiYj7UK0daVrfpTcgvYX1w3ciXnhHTmQPRf6rN9hmaSOGUbeqOi7g/ry7+ZYJoW
         9uUms5XZkvXZrULPCVfii8vzqTqqXUXt0cCQUSQGstokUexSKpbIO2Ini1MYzdiIGsVF
         CeHsTETP2esEwXGDJONxGJUbsDOSkQb+5cxyiKZRdrDo7vuFwe+QimjHv3SqPMMaxw4Q
         nxqfldUPU+H2TtCJKcJnvlY92B3zu6n1U2HNAbsSvUL4kdAiYwUDI33PZimwfbRVnrpc
         MEY7oNYdlphYRYVBkY1M1KzNKVcGB0wuWYolSAdfhO09Cz2nEtQzY/42ebA8J/awhNwg
         lQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IDS5Oufash5YwJYyq/CZbnqZxwavmq4JVvZ9D8fSXfI=;
        b=Kvq39EiHG05FYN08wIfMuairfhRAPvNv4l+fdrYp8pvRi+/ZAAbv23cfn5MF5S4Po/
         M57l/HRgZcxGX1VsnVVRiPq7tXJ7u7nc0/RSj50iiSliqg7lTEirNtY3PcXDHFlQ7nZp
         1HbIlTa3w+RJG1sXtUUNnYW6/C44J3DVvy8nST7rAhM2jODKi0rfQ9UBgCZuDUIYIpco
         tWz8hmDNGkeFZaDIcpWrV3c6B3XCo3tiF1ULP0kn/XCRqnEur0Wx9npbpuZaM+3Hyvg+
         PbLEO+86HQuc/ROJNv0gcZLcu0pdT6kzi2a+pNPpgd7HV6V2g4xIW/qQsZiEp0llyTfy
         R4XA==
X-Gm-Message-State: AOAM531VUMou6pYfPe1pI8hLcRazhHWvxThux/DahYHYbCKT+pPB9ovQ
        azr6MIll1X0qG0m717yHvyD3hWMaDx4=
X-Google-Smtp-Source: ABdhPJzlLARUdjxIvGUsB5LecaHA+FHCisE+Ffg9rzImiYJDT3jd8hTCPLGDmJitWpaPXWcJmhAAaA==
X-Received: by 2002:a37:d16:: with SMTP id 22mr1188669qkn.335.1605207593310;
        Thu, 12 Nov 2020 10:59:53 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id g70sm5055192qke.8.2020.11.12.10.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 10:59:52 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1] lan743x: fix issue causing intermittent kernel log warnings
Date:   Thu, 12 Nov 2020 13:59:49 -0500
Message-Id: <20201112185949.11315-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

When running this chip on arm imx6, we intermittently observe
the following kernel warning in the log, especially when the
system is under high load:

[   50.119484] ------------[ cut here ]------------
[   50.124377] WARNING: CPU: 0 PID: 303 at kernel/softirq.c:169 __local_bh_enable_ip+0x100/0x184
[   50.132925] IRQs not enabled as expected
[   50.159250] CPU: 0 PID: 303 Comm: rngd Not tainted 5.7.8 #1
[   50.164837] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   50.171395] [<c0111a38>] (unwind_backtrace) from [<c010be28>] (show_stack+0x10/0x14)
[   50.179162] [<c010be28>] (show_stack) from [<c05b9dec>] (dump_stack+0xac/0xd8)
[   50.186408] [<c05b9dec>] (dump_stack) from [<c0122e40>] (__warn+0xd0/0x10c)
[   50.193391] [<c0122e40>] (__warn) from [<c0123238>] (warn_slowpath_fmt+0x98/0xc4)
[   50.200892] [<c0123238>] (warn_slowpath_fmt) from [<c012b010>] (__local_bh_enable_ip+0x100/0x184)
[   50.209860] [<c012b010>] (__local_bh_enable_ip) from [<bf09ecbc>] (destroy_conntrack+0x48/0xd8 [nf_conntrack])
[   50.220038] [<bf09ecbc>] (destroy_conntrack [nf_conntrack]) from [<c0ac9b58>] (nf_conntrack_destroy+0x94/0x168)
[   50.230160] [<c0ac9b58>] (nf_conntrack_destroy) from [<c0a4aaa0>] (skb_release_head_state+0xa0/0xd0)
[   50.239314] [<c0a4aaa0>] (skb_release_head_state) from [<c0a4aadc>] (skb_release_all+0xc/0x24)
[   50.247946] [<c0a4aadc>] (skb_release_all) from [<c0a4b4cc>] (consume_skb+0x74/0x17c)
[   50.255796] [<c0a4b4cc>] (consume_skb) from [<c081a2dc>] (lan743x_tx_release_desc+0x120/0x124)
[   50.264428] [<c081a2dc>] (lan743x_tx_release_desc) from [<c081a98c>] (lan743x_tx_napi_poll+0x5c/0x18c)
[   50.273755] [<c081a98c>] (lan743x_tx_napi_poll) from [<c0a6b050>] (net_rx_action+0x118/0x4a4)
[   50.282306] [<c0a6b050>] (net_rx_action) from [<c0101364>] (__do_softirq+0x13c/0x53c)
[   50.290157] [<c0101364>] (__do_softirq) from [<c012b29c>] (irq_exit+0x150/0x17c)
[   50.297575] [<c012b29c>] (irq_exit) from [<c0196a08>] (__handle_domain_irq+0x60/0xb0)
[   50.305423] [<c0196a08>] (__handle_domain_irq) from [<c05d44fc>] (gic_handle_irq+0x4c/0x90)
[   50.313790] [<c05d44fc>] (gic_handle_irq) from [<c0100ed4>] (__irq_usr+0x54/0x80)
[   50.321287] Exception stack(0xecd99fb0 to 0xecd99ff8)
[   50.326355] 9fa0:                                     1cf1aa74 00000001 00000001 00000000
[   50.334547] 9fc0: 00000001 00000000 00000000 00000000 00000000 00000000 00004097 b6d17d14
[   50.342738] 9fe0: 00000001 b6d17c60 00000000 b6e71f94 800b0010 ffffffff
[   50.349364] irq event stamp: 2525027
[   50.352955] hardirqs last  enabled at (2525026): [<c0a6afec>] net_rx_action+0xb4/0x4a4
[   50.360892] hardirqs last disabled at (2525027): [<c0d6d2fc>] _raw_spin_lock_irqsave+0x1c/0x50
[   50.369517] softirqs last  enabled at (2524660): [<c01015b4>] __do_softirq+0x38c/0x53c
[   50.377446] softirqs last disabled at (2524693): [<c012b29c>] irq_exit+0x150/0x17c
[   50.385027] ---[ end trace c0b571db4bc8087d ]---

The driver is calling dev_kfree_skb() from code inside a spinlock,
where h/w interrupts are disabled. This is forbidden, as documented
in include/linux/netdevice.h. The correct function to use
dev_kfree_skb_irq(), or dev_kfree_skb_any().

Fix by using the correct dev_kfree_skb_xxx() functions:

in lan743x_tx_release_desc():
  called by lan743x_tx_release_completed_descriptors()
    called by in lan743x_tx_napi_poll()
    which holds a spinlock
  called by lan743x_tx_release_all_descriptors()
    called by lan743x_tx_close()
    which can-sleep
conclusion: use dev_kfree_skb_any()

in lan743x_tx_xmit_frame():
  which holds a spinlock
conclusion: use dev_kfree_skb_irq()

in lan743x_tx_close():
  which can-sleep
conclusion: use dev_kfree_skb()

in lan743x_rx_release_ring_element():
  called by lan743x_rx_close()
    which can-sleep
  called by lan743x_rx_open()
    which can-sleep
conclusion: use dev_kfree_skb()

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # edbc21113bde

To: Jakub Kicinski <kuba@kernel.org>
To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 9de970ec2056..a9fda2e6e715 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1291,13 +1291,13 @@ static void lan743x_tx_release_desc(struct lan743x_tx *tx,
 		goto clear_active;
 
 	if (!(buffer_info->flags & TX_BUFFER_INFO_FLAG_TIMESTAMP_REQUESTED)) {
-		dev_kfree_skb(buffer_info->skb);
+		dev_kfree_skb_any(buffer_info->skb);
 		goto clear_skb;
 	}
 
 	if (cleanup) {
 		lan743x_ptp_unrequest_tx_timestamp(tx->adapter);
-		dev_kfree_skb(buffer_info->skb);
+		dev_kfree_skb_any(buffer_info->skb);
 	} else {
 		ignore_sync = (buffer_info->flags &
 			       TX_BUFFER_INFO_FLAG_IGNORE_SYNC) != 0;
@@ -1607,7 +1607,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 	if (required_number_of_descriptors >
 		lan743x_tx_get_avail_desc(tx)) {
 		if (required_number_of_descriptors > (tx->ring_size - 1)) {
-			dev_kfree_skb(skb);
+			dev_kfree_skb_irq(skb);
 		} else {
 			/* save to overflow buffer */
 			tx->overflow_skb = skb;
@@ -1640,7 +1640,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 				   start_frame_length,
 				   do_timestamp,
 				   skb->ip_summed == CHECKSUM_PARTIAL)) {
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		goto unlock;
 	}
 
@@ -1659,7 +1659,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
 			 * frame assembler clean up was performed inside
 			 *	lan743x_tx_frame_add_fragment
 			 */
-			dev_kfree_skb(skb);
+			dev_kfree_skb_irq(skb);
 			goto unlock;
 		}
 	}
-- 
2.17.1

