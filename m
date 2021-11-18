Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECC4564E1
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhKRVLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 16:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhKRVLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 16:11:07 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA77C061574;
        Thu, 18 Nov 2021 13:08:06 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id 8so7502545qtx.5;
        Thu, 18 Nov 2021 13:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=V4Bizq2uKgH6N0YB5LNpThf7393/o/90o2EQIuzARiw=;
        b=YSB64oKeWELyJPYAg90tSMO9QuV37hxGoJzSEmQeys3zn4DoF0RcseuuLcoCtDxzlR
         Wr/iApuRjXKsyxezoA5q36qkLEs7YLhzOibGSnKPrrdSr7+6mFVGBy5dAg9aVER1RDjW
         ZGs/qWJHstEiVBgDvIfOJd0zbr1SdcUxehHh7I3n/TH6Z52WO2eekjqKvc3jexb9AgQx
         SvjuhMXxdZ3lYqXK4Q5129lW0ZBGIeERnJFSDBkhxmAZieqT3NoLfS+OFZ1hLXz7uP/K
         sUcRdjjjqaPPh4f4vUT0qebBqG6tm1rVq26F1exYYXj1y/WrCgTfI+xuoYDojfURw2Qf
         VwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=V4Bizq2uKgH6N0YB5LNpThf7393/o/90o2EQIuzARiw=;
        b=JbF5mZbyEnJJoHy3hHpXUk2XoouiFooXV+/QtBPsXTP4YktdCUprVqKqOro1kbxl8A
         SKHe9wDxf2x5HwNuHLr57KL9ADSQ8YSDtulyj8y4hKvnuXrFGTFGk493ScXkbK5KlVa6
         d91NKIAb0ZARlS9eVdCCLjJh7D38QUivmsTsT/Lsq3L18/yin/2u2zIkp8jfLsqmW6zW
         oM1cr+QCRLXb8omRRhDw9k75pX4Mz4weXxEZgDAaYHdm7iKRlUrN0v4o+dBFAayWHHeE
         FI4l6R51oP2T9VIsdTmagEGDImy6XVvRqvJNcwBjelMeK7fJL15IdbwpWMFq1Xr/dF6/
         y6qg==
X-Gm-Message-State: AOAM532n8BXI/XNdsM4053fGQa525Db+F6Uqisyb8Zy6lJ1UqKk9NYmr
        90K7mqUQct8jS3P1avakXpBe29O0LAqMMg==
X-Google-Smtp-Source: ABdhPJz3fPY6mah3Q1m1/qTx1O9/zqQdnAgqAb0UlD2lvZ5M8ykcEZ1IcBqHKO3SFbemHIKn6yViiQ==
X-Received: by 2002:a05:622a:1d3:: with SMTP id t19mr548090qtw.181.1637269685345;
        Thu, 18 Nov 2021 13:08:05 -0800 (PST)
Received: from a-10-27-17-117.dynapool.vpn.nyu.edu (vpnrasa-wwh-pat-01.natpool.nyu.edu. [216.165.95.84])
        by smtp.gmail.com with ESMTPSA id m9sm395012qtn.73.2021.11.18.13.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 13:08:04 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:08:02 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] atlantic: fix double-free in aq_ring_tx_clean
Message-ID: <YZbAsgT17yxu4Otk@a-10-27-17-117.dynapool.vpn.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found this bug while fuzzing the device driver. Using and freeing
the dangling pointer buff->skb would cause use-after-free and
double-free.

This bug is triggerable with compromised/malfunctioning devices. We
found the bug with QEMU emulation and tested the patch by emulation.
We did NOT test on a real device.

Attached is the bug report.

BUG: KASAN: double-free or invalid-free in consume_skb+0x6c/0x1c0

Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? consume_skb+0x6c/0x1c0
 kasan_report_invalid_free+0x61/0xa0
 ? consume_skb+0x6c/0x1c0
 __kasan_slab_free+0x15e/0x170
 ? consume_skb+0x6c/0x1c0
 kfree+0x8c/0x230
 consume_skb+0x6c/0x1c0
 aq_ring_tx_clean+0x5c2/0xa80 [atlantic]
 aq_vec_poll+0x309/0x5d0 [atlantic]
 ? _sub_I_65535_1+0x20/0x20 [atlantic]
 ? __next_timer_interrupt+0xba/0xf0
 net_rx_action+0x363/0xbd0
 ? call_timer_fn+0x240/0x240
 ? __switch_to_asm+0x34/0x70
 ? napi_busy_loop+0x520/0x520
 ? net_tx_action+0x379/0x720
 __do_softirq+0x18c/0x634
 ? takeover_tasklets+0x5f0/0x5f0
 run_ksoftirqd+0x15/0x20
 smpboot_thread_fn+0x2f1/0x6b0
 ? smpboot_unregister_percpu_thread+0x160/0x160
 ? __kthread_parkme+0x80/0x100
 ? smpboot_unregister_percpu_thread+0x160/0x160
 kthread+0x2b5/0x3b0
 ? kthread_create_on_node+0xd0/0xd0
 ret_from_fork+0x22/0x40

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 24122ccda614..81b3756417ec 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -298,13 +298,14 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 			}
 		}
 
-		if (unlikely(buff->is_eop)) {
+		if (unlikely(buff->is_eop && buff->skb)) {
 			u64_stats_update_begin(&self->stats.tx.syncp);
 			++self->stats.tx.packets;
 			self->stats.tx.bytes += buff->skb->len;
 			u64_stats_update_end(&self->stats.tx.syncp);
 
 			dev_kfree_skb_any(buff->skb);
+			buff->skb = NULL;
 		}
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
-- 
2.25.1

