Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCD3C3F62
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhGKVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKVHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 17:07:19 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F15C0613DD;
        Sun, 11 Jul 2021 14:04:32 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id r17so1371614qtp.5;
        Sun, 11 Jul 2021 14:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=WhI1md3MVLVayd7+5Y8GQbHIv806Js5uafanhivIZcs=;
        b=uGB4DNtnY9qeRDA7+F1VQBOUJrIl0GDPIyjmxqjNEnqYUcXzrLtABmckPOnU3WAVR7
         Imp+vparzr1xQ8Q5RGEcBhwlHjY/XPh6yUYef06/rqdLqBHYb52kZ5FxdkSCyc+YvC6h
         PqpFNFfK2mxqYavlfbwORnDtC6vndNV8WtR2AAMqaTXKPVmi2WHQ1JjTA8F4WhKW63lQ
         9klGdXh4BOsEOyQ2P0npmL0L+B4hR/k+ZfsIvZh2/5rfoZr9GlsopZt0hXyxiy4e795Z
         vBy8V3kzpoP9jLv1oqf154xxEeMF6D9LKZYLVATJyl0//DRUTP4aNMIVZRrKlXGYGVGz
         4VuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WhI1md3MVLVayd7+5Y8GQbHIv806Js5uafanhivIZcs=;
        b=Qg4ZXstaqkkJQxu2WpRbfwo7BuQRspCgqAsMvV9Dj27an4+5SN6Uxa/q3i4nNUyfQJ
         S6z3j9zXeH7/WU5prVHd969ZmzVQVDpB74Z8l9LXXg+UzXkVybyBpElVqSYQWM0ATfUH
         Z4699fq2WcSuq60yqh8hQdh1EXBKRyDcztTMaypoH0X7XWGqWGf/O6lXGPFZV8RifAai
         HSoXvEPabt3RPxsPQE1kxkDSZXcF8JQaso3XjRR/nFsTQ2IcU3qsoQcic+Icpz0kauIt
         g3c5RqNTCqG0kuwZGz9oVF9dahIXM9wTdCeituG0fNTCrZYRnXl2tsmLTJtCcg6Aj73a
         ekwg==
X-Gm-Message-State: AOAM532PYdMeXaJNvNI3a0wJAsszU9angDNBR2NRlYC9vr3EmWfQvirx
        imZuhO8PTuX9jyUhU6idLMk=
X-Google-Smtp-Source: ABdhPJxvsUoBDGxLnigrToM3BQefVJ/loAzJLRt0sh45QiioduOS5NRs6MKKYkmcCW9Q9VJxcNK/1A==
X-Received: by 2002:ac8:708f:: with SMTP id y15mr37409307qto.392.1626037471289;
        Sun, 11 Jul 2021 14:04:31 -0700 (PDT)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id c27sm5430097qkk.59.2021.07.11.14.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 14:04:30 -0700 (PDT)
Date:   Sun, 11 Jul 2021 17:04:28 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net][atlantic] Fix buff_ring OOB in aq_ring_rx_clean
Message-ID: <YOtc3GEEVonOb1lf@Zekuns-MBP-16.fios-router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function obtain the next buffer without boundary check.
We should return with I/O error code.

The bug is found by fuzzing and the crash report is attached.
It is an OOB bug although reported as use-after-free.

[    4.804724] BUG: KASAN: use-after-free in aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.805661] Read of size 4 at addr ffff888034fe93a8 by task ksoftirqd/0/9
[    4.806505]
[    4.806703] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.6.0 #34
[    4.807636] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[    4.809030] Call Trace:
[    4.809343]  dump_stack+0x76/0xa0
[    4.809755]  print_address_description.constprop.0+0x16/0x200
[    4.810455]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.811234]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.813183]  __kasan_report.cold+0x37/0x7c
[    4.813715]  ? aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.814393]  kasan_report+0xe/0x20
[    4.814837]  aq_ring_rx_clean+0x1e88/0x2730 [atlantic]
[    4.815499]  ? hw_atl_b0_hw_ring_rx_receive+0x9a5/0xb90 [atlantic]
[    4.816290]  aq_vec_poll+0x179/0x5d0 [atlantic]
[    4.816870]  ? _GLOBAL__sub_I_65535_1_aq_pci_func_init+0x20/0x20 [atlantic]
[    4.817746]  ? __next_timer_interrupt+0xba/0xf0
[    4.818322]  net_rx_action+0x363/0xbd0
[    4.818803]  ? call_timer_fn+0x240/0x240
[    4.819302]  ? __switch_to_asm+0x40/0x70
[    4.819809]  ? napi_busy_loop+0x520/0x520
[    4.820324]  __do_softirq+0x18c/0x634
[    4.820797]  ? takeover_tasklets+0x5f0/0x5f0
[    4.821343]  run_ksoftirqd+0x15/0x20
[    4.821804]  smpboot_thread_fn+0x2f1/0x6b0
[    4.822331]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.823041]  ? __kthread_parkme+0x80/0x100
[    4.823571]  ? smpboot_unregister_percpu_thread+0x160/0x160
[    4.824301]  kthread+0x2b5/0x3b0
[    4.824723]  ? kthread_create_on_node+0xd0/0xd0
[    4.825304]  ret_from_fork+0x35/0x40

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 24122ccda614..f915b4885831 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -365,6 +365,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				if (buff_->next >= self->size) {
+					err = -EIO;
+					goto err_exit;
+				}
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
-- 
2.23.0.rc1

