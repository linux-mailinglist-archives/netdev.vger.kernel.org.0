Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53E23655A3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 11:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhDTJoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhDTJoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:44:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE00C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:43:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p16so15418934plf.12
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 02:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zGycjEf+w5ATtSrKPNMDPKepC5i8j4NCy1WccYtrWo=;
        b=QqOpWHbt6U8N2elVbpSCNvzZXuOjgB9rFEjgBLcbbol//NpfpDX4uBQ7hJFYXHf/sR
         b9Bndqc5ia4cglVJSHXsuG1Pic44JZCtYzjoseI6ioscGu0bXioBJ+QP6KZC5xJrhscl
         o/YUdbHMWCrJKdbiQe/JGj3hzUoQ6HLC23goS0WQHE1hRD0ok6lwzbFXIkgBxY1ktLPk
         SPMsBpMCXtGhn8l0Agl7LhQiCCmdi/dMY+CWXkZ9Fnqs0OJdNgL1CgZ39QY/Qh6nKQ8a
         W3XmuzCJnIcWteB2f7/NMkO/MUZ1CnVkvRJvaQCVHtWdeoZjEnZybXm+ASgGtbCr8455
         g8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8zGycjEf+w5ATtSrKPNMDPKepC5i8j4NCy1WccYtrWo=;
        b=Zuw3ynSceAnqNvmuPzA7Wh5fG/b6euxOl0goStrbNsnCWG+kZSYDA0SR0FdN3ECk1z
         mNOy5c0bgDV0CB7CCGaqMGjoH8IedU/omps7Qs+89+g/ttM6spNskEZFezfivcABNPpa
         ZElxUMpXcr5lhuDjn2i7/iZJFslg6EEK5JHzVf0+7+wGyvr/jY00CNCVVME8aTTjUB0m
         tkjcezcneWeDbyjquFlpxZAvt1/eOT/d2THVLLIv8kLBvH0M9o+BQ3slbZ8Z6j9TOlXB
         6Ti7oXy1CweAgFO6TMS64Rfw7FUOdDfCPty+/u2OjUNJs4eggLvGLUeMvHRlF2u2uT3+
         Nv6Q==
X-Gm-Message-State: AOAM530HNqCDC7fJa3+KdCOkngqifIEmi7kOd0gHhza5qL12vupeH1+h
        R8ZnZOFi/xr7+oX/9CYUIdQ=
X-Google-Smtp-Source: ABdhPJwrpnp9YcLIIGqvPc+Gv1KTSyYxQkHFofF+TIndrIZ21eYxCcGBZ+x8KHLRLCC5ElfG0rLZLw==
X-Received: by 2002:a17:90a:1b4b:: with SMTP id q69mr3961950pjq.188.1618911827553;
        Tue, 20 Apr 2021 02:43:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:71c5:2f2b:f562:605b])
        by smtp.gmail.com with ESMTPSA id u1sm14783495pgg.11.2021.04.20.02.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 02:43:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
Date:   Tue, 20 Apr 2021 02:43:41 -0700
Message-Id: <20210420094341.3259328-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KASAN/syzbot had 4 reports, one of them being:

BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: slab-out-of-bounds in page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
Read of size 12 at addr ffff888014a5f800 by task systemd-udevd/8445

CPU: 0 PID: 8445 Comm: systemd-udevd Not tainted 5.12.0-rc8-next-20210419-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 memcpy+0x20/0x60 mm/kasan/shadow.c:65
 memcpy include/linux/fortify-string.h:191 [inline]
 page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
 receive_mergeable drivers/net/virtio_net.c:1009 [inline]
 receive_buf+0x2bc0/0x6250 drivers/net/virtio_net.c:1119
 virtnet_receive drivers/net/virtio_net.c:1411 [inline]
 virtnet_poll+0x568/0x10b0 drivers/net/virtio_net.c:1516
 __napi_poll+0xaf/0x440 net/core/dev.c:6962
 napi_poll net/core/dev.c:7029 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7116
 __do_softirq+0x29b/0x9fe kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 common_interrupt+0xa4/0xd0 arch/x86/kernel/irq.c:240

Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	unsigned int copy, hdr_len, hdr_padded_len;
+	struct page *page_to_free = NULL;
 	int tailroom, shinfo_size;
 	char *p, *hdr_p;
 
@@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		if (len)
 			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
 		else
-			put_page(page);
+			page_to_free = page;
 		goto ok;
 	}
 
@@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		hdr = skb_vnet_hdr(skb);
 		memcpy(hdr, hdr_p, hdr_len);
 	}
+	if (page_to_free)
+		put_page(page_to_free);
 
 	if (metasize) {
 		__skb_pull(skb, metasize);
-- 
2.31.1.368.gbe11c130af-goog

