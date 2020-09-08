Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F52615C0
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbgIHQzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731903AbgIHQXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:23:19 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447EAC061573;
        Tue,  8 Sep 2020 09:23:19 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id p65so12377741qtd.2;
        Tue, 08 Sep 2020 09:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K5Evq+uTbM4yLIZD5njkPq4LQ+o2UWYUAtT6x7n9zzY=;
        b=b8XlRhZM0nQYdZDtTmmJqoRSSCLrq5Tf1z6fz22S7BgxJx7oiBUDvz8CG8BVD03LGJ
         /Hqpko9dlT/YILpdP7W81LAHXAsYE7VD69DbJEjcfSbnt7/dJSukr+Q4XcEsM1xdRW8k
         6SQ+7dbUdg72bZISIzIPBTTgklLK6CM60qsi/XIxt/0J63b3U0hYGs6n9VDgiuWoljLk
         wqNTj7y994lcrXpz+r/X1x/I6pZo8Q6yl6ePVF+FolPbXjcZZUPdtvmIGt49Pm5n6o68
         EI28Qr3lAckzbqLxuWfLF8YM9nAR+JmSpvBO+1XVFB7uX02Wzlqhoc58PmhiOrH8w7HM
         yGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K5Evq+uTbM4yLIZD5njkPq4LQ+o2UWYUAtT6x7n9zzY=;
        b=gBfzdBI6JfPgbtpjtSZa8K+g/SyylCZ5T7zfK7FNwxFdfvh/HHfSveTvwgq/1e971b
         dSNqj3YqJsEh3irmQKNaa2DNte/5hpn6Xp11VucMP3LxpYYexumQyabW0toCQ1mYhx5r
         fCa5NixmWjQRqwfkBvnO9jeG4VhPzr+rQcHszYIpgpMn+reY3kfvm3NdyrWs8MZsZrk9
         XWHg/J+aAGyINSD66w/6Usxleb5eA9l8tZvGZ1ONsINevms/D/8HjVz/n2zoBPxmogqp
         knsCI1Jx7qQtVbP+LAOPAKgs8KdoImfrrzwN7032bULPW9osfRSWzii5dfLvBg/8fg3v
         HmZQ==
X-Gm-Message-State: AOAM530O30KrviBw1aHKHn1qZLgzvI2IvbodLtMuaDwxRWdOAqqnOy2m
        E4f0y8VkBUxx1G5OM4IcBHs=
X-Google-Smtp-Source: ABdhPJzZAn3gEyTZN6G+TEQsP9eRJ97UWpa7Yi39ANb1CJ8Jzcek+peqEBJX2lfkWIxVJHp9CNGryw==
X-Received: by 2002:ac8:66da:: with SMTP id m26mr880116qtp.111.1599582198312;
        Tue, 08 Sep 2020 09:23:18 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c100:b9d:393c:836a:3c13:11a6])
        by smtp.googlemail.com with ESMTPSA id p205sm13879596qke.2.2020.09.08.09.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 09:23:17 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] e1000: do not panic on malformed rx_desc
Date:   Tue,  8 Sep 2020 12:22:31 -0400
Message-Id: <20200908162231.4592-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

length may be corrupted in rx_desc and lead to panic, so check the
sanity before passing it to skb_put

[  167.667701] skbuff: skb_over_panic: text:ffffffffb1e32cc1 len:60224 put:60224 head:ffff888055ac5000 data:ffff888055ac5040 tail:0xeb80 end:0x6c0 dev:e
th0
[  167.668429] ------------[ cut here ]------------
[  167.668661] kernel BUG at net/core/skbuff.c:109!
[  167.668910] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  167.669220] CPU: 1 PID: 170 Comm: sd-resolve Tainted: G        W         5.8.0+ #1
[  167.670161] RIP: 0010:skb_panic+0xc4/0xc6
[  167.670363] Code: 89 f0 48 c7 c7 60 f2 de b2 55 48 8b 74 24 18 4d 89 f9 56 48 8b 54 24 18 4c 89 e6 52 48 8b 44 24 18 4c 89 ea 50 e8 31 c5 2a ff <0f>
0b 4c 8b 64 24 18 e8 f1 b4 48 ff 48 c7 c1 00 fc de b2 44 89 ee
[  167.671272] RSP: 0018:ffff88806d109c68 EFLAGS: 00010286
[  167.671527] RAX: 000000000000008c RBX: ffff888065e9af40 RCX: 0000000000000000
[  167.671878] RDX: 1ffff1100da24c91 RSI: 0000000000000008 RDI: ffffed100da21380
[  167.672227] RBP: ffff88806bde4000 R08: 000000000000008c R09: ffffed100da25cfb
[  167.672583] R10: ffff88806d12e7d7 R11: ffffed100da25cfa R12: ffffffffb2defc40
[  167.672931] R13: ffffffffb1e32cc1 R14: 000000000000eb40 R15: ffff888055ac5000
[  167.673286] FS:  00007fc5f5375700(0000) GS:ffff88806d100000(0000) knlGS:0000000000000000
[  167.673681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  167.673973] CR2: 0000000000cb3008 CR3: 0000000063d36000 CR4: 00000000000006e0
[  167.674330] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  167.674677] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  167.675035] Call Trace:
[  167.675168]  <IRQ>
[  167.675315]  ? e1000_clean_rx_irq+0x311/0x630
[  167.687459]  skb_put.cold+0x1f/0x1f
[  167.687637]  e1000_clean_rx_irq+0x311/0x630
[  167.687852]  e1000e_poll+0x19a/0x4d0
[  167.688038]  ? e1000_watchdog_task+0x9d0/0x9d0
[  167.688262]  ? credit_entropy_bits.constprop.0+0x6f/0x1c0
[  167.688527]  net_rx_action+0x26e/0x650

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 1e6ec081fd9d..29e2ecb0358a 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4441,8 +4441,13 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 			 */
 			length -= 4;
 
-		if (buffer_info->rxbuf.data == NULL)
+		if (buffer_info->rxbuf.data == NULL)  {
+			/* check length sanity */
+			if (skb->tail + length > skb->end) {
+				length = skb->end - skb->tail;
+			}
 			skb_put(skb, length);
+		}
 		else /* copybreak skb */
 			skb_trim(skb, length);
 
-- 
2.25.1

