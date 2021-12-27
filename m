Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169A847F9C8
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 03:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhL0Cct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 21:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhL0Ccs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 21:32:48 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87FBC06173E;
        Sun, 26 Dec 2021 18:32:48 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id fo11so12799254qvb.4;
        Sun, 26 Dec 2021 18:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=EYfLYXJYtyGpTQDC9WA1MsCy/obwJTVAmoI4gHLrI8w=;
        b=arjF7gOn+JD8NLOPcRNug+lcH6ZDadxZPVQM5UzFD4Ijb+d0d8jnrF2Ei3lVrFg7vh
         9BPA3c+mq1vRFoPjXTBMW3SJfZQtR6b5IttSFcLj/LUOynSLRkRYKB/IhWWICf1oZJgF
         5z2agkgKhK+rH7ySX8AKrsCbECqVknS4dOMJEx1WP55IZuvresbHdUpzLcq8jgDxS+jm
         vnVLKpdqXRMxjkDC4Wwa812bXz+1BOj9OPEL2YZiaIqy2r67+qXq4/JgA6/4hLiHUFeq
         dIeMTZFyFJgT03+jyGN7YfOG7PMldP5xrGnI0MEx0ngcNjmcxlrNUz9bxtOpkCZqHlu2
         xYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=EYfLYXJYtyGpTQDC9WA1MsCy/obwJTVAmoI4gHLrI8w=;
        b=NluOHccQY7J0adseyXgaeBdaQXVQlAMVIxE0M6ZbtIFCsFyEybJFewdiQ9i5hM7T+i
         KywMFtB6W8zHNxQhNK4kinx0hERlqPq04vroeb9PUdeLVD2018k77r14fjJy9p+u4Acg
         vcGGG6IQMCibJijhCTRfhNSFnAfoO/PmT2pTszxDJm7aBJy7fIT9MLNV8yEffSBlwuuu
         5Ow7/+EWsnjZwGEPYSb1jYJIL2Ip6aKcBjld5OZHJxDlrt9w4jFoZnxjyqffgtrDx71S
         QRWN/Aq8syffXpb3C9fkU0/eWJIH+ehCVQwrmiP9+KvdUv2cPYzQ/3rA+4LrKDgWCBIg
         54hQ==
X-Gm-Message-State: AOAM532oqMAgRpxxDhEY76Sp1Wv5ZNLtEpBtrsj1Z60UEhDz0Hd59USq
        OkIpTf8HhdfRviiozc1WkBNBnxVWRn+U6g==
X-Google-Smtp-Source: ABdhPJxUGzmlfdKJV/FWOzzRcubohNM9tuGO/IsrodLI/O6E7JwMPzRxK/MLh8Eiu6ljACN9WMPROw==
X-Received: by 2002:ad4:5bc6:: with SMTP id t6mr13623395qvt.102.1640572367868;
        Sun, 26 Dec 2021 18:32:47 -0800 (PST)
Received: from a-10-27-26-18.dynapool.vpn.nyu.edu (vpnrasa-wwh-pat-01.natpool.nyu.edu. [216.165.95.84])
        by smtp.gmail.com with ESMTPSA id u28sm6466299qke.12.2021.12.26.18.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 18:32:47 -0800 (PST)
Date:   Sun, 26 Dec 2021 21:32:45 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [PATCH v2] atlantic: Fix buff_ring OOB in aq_ring_rx_clean
Message-ID: <YcklzW522Gkew1zI@a-10-27-26-18.dynapool.vpn.nyu.edu>
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
Changes in v2:
 - Add similar check in the second loop
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 81b375641..77e76c9ef 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -366,6 +366,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
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
@@ -389,6 +393,10 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
 				do {
+					if (buff_->next >= self->size) {
+						err = -EIO;
+						goto err_exit;
+					}
 					next_ = buff_->next,
 					buff_ = &self->buff_ring[next_];
 
-- 
2.25.1

