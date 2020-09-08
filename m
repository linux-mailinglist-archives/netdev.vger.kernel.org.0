Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CD261480
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbgIHQYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731643AbgIHQXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:23:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D6FC061573;
        Tue,  8 Sep 2020 09:23:47 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id v123so4397715qkd.9;
        Tue, 08 Sep 2020 09:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fG9sh+VJ6ct/M0MnobHjuUiWeXeXy8C/WxdALo1qBnU=;
        b=cE8tyE/9HSYIG8dk3jsI1IxOkrH/eptnzh4Gvmdc/AbZVFA6bAqu5dG7OZZmqU6x+s
         uhEaBckRV9fI7izootzbkWI0/Gu7bWIsC6MqvRZE5TaNFrX5VjIbTHQC+QtCS+9bnfgH
         mWDRlS1vbqKv33sfcSbLJZVY52ns82Zb4XwWKLKm78ai0sTE3lRnZFLYEriGvssZvDOm
         HbcmgN+ualzlwRwasHwef0u4ab5YywzT8VwK/+uwiTnAH7YuKkJu7060G2eX6yNDF/3e
         HlPXnSqpoOLlI1BCJ172oG2mcfpscGHHCp8YE53Jxjh+ZfdxNN4mtPvU9HsdBuULEHLt
         uO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fG9sh+VJ6ct/M0MnobHjuUiWeXeXy8C/WxdALo1qBnU=;
        b=GKyOqpWpTfUJiWV50KYDSOy0sUhZrEamDxqDQbBZH53hrcQkQZ1KjopVrsOC6NstVY
         pNuKDyRmW1u1+LO3HyljxBFSGBXiJxGjXW0EMwPEM3YT11N+oazyoQtXxPa2zl8oGO7C
         S4/yADN6zRRrcQnCqOiNy2NmyAcKMmOzFKxCG1noWR2Ywu3LgHjlEbBtwXRchonqh+3x
         6jhVP5NdiqdoQ5ja5sDiQS2qehwua0/zdt1Jd0z+lb6MFfJ/sBHL4NAKF3rsbps35cUo
         j+qOECTTeSJSQKS1UgXu5pVsJaRB+iryF9zqsfrxohJ7QFF46YjKq6wbO7SG36CH+QDZ
         srKQ==
X-Gm-Message-State: AOAM532ktdjSI475jyld5JsMR+H2Btf2XwEsoeaT9ei/lj+y3icwf4wg
        N1DOkzwuRQHq4evIaiwqjGI=
X-Google-Smtp-Source: ABdhPJxpfm3QpXHAuIeFeYJLCfoUzaXZ4W3uRDAZdu3BeDGMwUmXEx9JOTLuway4RWSv8KI1muehmw==
X-Received: by 2002:a37:62c3:: with SMTP id w186mr803137qkb.227.1599582227058;
        Tue, 08 Sep 2020 09:23:47 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:393c:836a:3c13:11a6])
        by smtp.googlemail.com with ESMTPSA id z3sm6186348qkf.92.2020.09.08.09.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 09:23:46 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] e1000e: do not panic on malformed rx_desc
Date:   Tue,  8 Sep 2020 12:23:30 -0400
Message-Id: <20200908162330.4681-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

length may be corrupted in rx_desc and lead to panic, so check the
sanity before passing it to skb_put

[  103.840572] skbuff: skb_over_panic: text:ffffffff8f432cc1 len:61585 put:61585 head:ffff88805642b800 data:ffff88805642b840 tail:0xf0d1 end:0x6c0 dev:e
th0
[  103.841283] ------------[ cut here ]------------
[  103.841515] kernel BUG at net/core/skbuff.c:109!
[  103.841749] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  103.842063] CPU: 1 PID: 276 Comm: ping Tainted: G        W         5.8.0+ #4
[  103.842857] RIP: 0010:skb_panic+0xc4/0xc6
[  103.843022] Code: 89 f0 48 c7 c7 60 f2 3e 90 55 48 8b 74 24 18 4d 89 f9 56 48 8b 54 24 18 4c 89 e6 52 48 8b 44 24 18 4c 89 ea 50 e8 01 c5 2a ff <0f>
0b 4c 8b 64 24 18 e8 c1 b4 48 ff 48 c7 c1 e0 fc 3e 90 44 89 ee
[  103.843766] RSP: 0018:ffff88806d109c58 EFLAGS: 00010282
[  103.843976] RAX: 000000000000008c RBX: ffff8880683407c0 RCX: 0000000000000000
[  103.844262] RDX: 1ffff1100da24c91 RSI: 0000000000000008 RDI: ffffed100da2137e
[  103.844548] RBP: ffff88806bdcc000 R08: 000000000000008c R09: ffffed100da25cfb
[  103.844834] R10: ffff88806d12e7d7 R11: ffffed100da25cfa R12: ffffffff903efd20
[  103.845123] R13: ffffffff8f432cc1 R14: 000000000000f091 R15: ffff88805642b800
[  103.845410] FS:  00007efcd06852c0(0000) GS:ffff88806d100000(0000) knlGS:0000000000000000
[  103.845734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  103.845966] CR2: 00007efccf94f8dc CR3: 0000000064810000 CR4: 00000000000006e0
[  103.846254] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  103.846539] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  103.846823] Call Trace:
[  103.846925]  <IRQ>
[  103.847013]  ? e1000_clean_rx_irq+0x311/0x630
[  103.847190]  skb_put.cold+0x2b/0x4d
[  103.847334]  e1000_clean_rx_irq+0x311/0x630

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 664e8ccc88d2..f12bd00b2dbf 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1047,6 +1047,10 @@ static bool e1000_clean_rx_irq(struct e1000_ring *rx_ring, int *work_done,
 			}
 			/* else just continue with the old one */
 		}
+		/* check length sanity */
+		if (skb->tail + length > skb->end) {
+			length = skb->end - skb->tail;
+		}
 		/* end copybreak code */
 		skb_put(skb, length);
 
-- 
2.25.1

