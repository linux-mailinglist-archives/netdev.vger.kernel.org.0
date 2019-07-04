Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492205F005
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGDAVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:21:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39726 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfGDAVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:21:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id j2so2049023pfe.6
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gx/ZCar9FOJA3QnWXJXP6MX9Ou1mdXPNbfC+er4hHk0=;
        b=BPg+NYOZQSY5Qe2M40a6Z0KSL4BzqKwOvHM5XAGev4HER7xOvOp6eBmL8y0lmpXjNQ
         pE0UJiT+GNvGyBrNsSw699t0edlXC5qscQPsMvWa5DUQaZOgbPyqa+5NBW7QQZ5qclqZ
         RotiqSGjQQQULDifKWK5RcZGA7gME43Q6uThMf2iNtCxAPtw8uv6vthgsQbKuyX9X/Ma
         HzKVmH/5au3D9Ks7lUBNILxERk1w3cHJ5V/bs1nNfAN/Ikmcgd5z+02KMG+3K2gT67BD
         HL2qRAteHj9z695xMNJNplph+CRHYQTtR1jQGahaQYRjcc66vLoHKgX95zhRtkeeI/PI
         CxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gx/ZCar9FOJA3QnWXJXP6MX9Ou1mdXPNbfC+er4hHk0=;
        b=TkbHLQcFHwGjLd1Vy9MI7RkaP46xkx8iKKtuDoLpH1NUcvtfFljtWjLcpmBDjBRsgl
         VilX1BDh0Ywh/3TtejsWTgs7aiQ0oudHFeJRCuyhiY5K5Cuy8wKqGu6Bmbw5srZHSvh0
         HbQjiUjtEWuZNZxPYrAe1QtBTM34SoZjcZs7y3TLkRFAMt0T7ydILgZ7qNG6vEXi4RIA
         V/hxNFagzKgBI5Dci0yP2+a5F5V4ZZ7Im6wGGne1XmpyW/F8VpRob/WgIvQUa01jdQ13
         KbArUuzWohAHLU7B/MVDh0zL0XoTUwexuCEPeBh1a5u+vez61Sq+elwqUS2o6jYegrbe
         4kYw==
X-Gm-Message-State: APjAAAWZm5vSfr3Rf3ERrfuX8SkMK7z//SISA+Lq6qTCe1uk9v0FOXI3
        60WcOZ15YB/SbjLeZKi0gZUzEHbMj5o=
X-Google-Smtp-Source: APXvYqxseEnmUVMWFqFejBrZdjsXbcl0qtD2PaMNyabv8Nxz61xNVjwqRhqgYyHb/PcAkewdE3jCVQ==
X-Received: by 2002:a17:90a:a404:: with SMTP id y4mr16514517pjp.58.1562199703350;
        Wed, 03 Jul 2019 17:21:43 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id e11sm7252426pfm.35.2019.07.03.17.21.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 17:21:42 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: [Patch net 3/3] hsr: fix a NULL pointer deref in hsr_dev_xmit()
Date:   Wed,  3 Jul 2019 17:21:14 -0700
Message-Id: <20190704002114.29004-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
References: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_port_get_hsr() could return NULL and kernel
could crash:

 BUG: kernel NULL pointer dereference, address: 0000000000000010
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 8000000074b84067 P4D 8000000074b84067 PUD 7057d067 PMD 0
 Oops: 0000 [#1] SMP PTI
 CPU: 0 PID: 754 Comm: a.out Not tainted 5.2.0-rc6+ #718
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
 RIP: 0010:hsr_dev_xmit+0x20/0x31
 Code: 48 8b 1b eb e0 5b 5d 41 5c c3 66 66 66 66 90 55 48 89 fd 48 8d be 40 0b 00 00 be 04 00 00 00 e8 ee f2 ff ff 48 89 ef 48 89 c6 <48> 8b 40 10 48 89 45 10 e8 6c 1b 00 00 31 c0 5d c3 66 66 66 66 90
 RSP: 0018:ffffb5b400003c48 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff9821b4509a88 RCX: 0000000000000000
 RDX: ffff9821b4509a88 RSI: 0000000000000000 RDI: ffff9821bc3fc7c0
 RBP: ffff9821bc3fc7c0 R08: 0000000000000000 R09: 00000000000c2019
 R10: 0000000000000000 R11: 0000000000000002 R12: ffff9821bc3fc7c0
 R13: ffff9821b4509a88 R14: 0000000000000000 R15: 000000000000006e
 FS:  00007fee112a1800(0000) GS:ffff9821bd800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000010 CR3: 000000006e9ce000 CR4: 00000000000406f0
 Call Trace:
  <IRQ>
  netdev_start_xmit+0x1b/0x38
  dev_hard_start_xmit+0x121/0x21e
  ? validate_xmit_skb.isra.0+0x19/0x1e3
  __dev_queue_xmit+0x74c/0x823
  ? lockdep_hardirqs_on+0x12b/0x17d
  ip6_finish_output2+0x3d3/0x42c
  ? ip6_mtu+0x55/0x5c
  ? mld_sendpack+0x191/0x229
  mld_sendpack+0x191/0x229
  mld_ifc_timer_expire+0x1f7/0x230
  ? mld_dad_timer_expire+0x58/0x58
  call_timer_fn+0x12e/0x273
  __run_timers.part.0+0x174/0x1b5
  ? mld_dad_timer_expire+0x58/0x58
  ? sched_clock_cpu+0x10/0xad
  ? mark_lock+0x26/0x1f2
  ? __lock_is_held+0x40/0x71
  run_timer_softirq+0x26/0x48
  __do_softirq+0x1af/0x392
  irq_exit+0x53/0xa2
  smp_apic_timer_interrupt+0x1c4/0x1d9
  apic_timer_interrupt+0xf/0x20
  </IRQ>

Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/hsr/hsr_device.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 4ea7d54a8262..f0f9b493c47b 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -227,9 +227,13 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct hsr_port *master;
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-	skb->dev = master->dev;
-	hsr_forward_skb(skb, master);
-
+	if (master) {
+		skb->dev = master->dev;
+		hsr_forward_skb(skb, master);
+	} else {
+		atomic_long_inc(&dev->tx_dropped);
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
 
-- 
2.21.0

