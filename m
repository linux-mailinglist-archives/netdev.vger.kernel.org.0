Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804EF6B9994
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjCNPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjCNPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:35:58 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE3D2884F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:35:02 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id b26-20020a9d755a000000b006972b28ae37so1190251otl.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678808094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXF/sgIHn5IY/DFNG1dgAypPPI+KWpv/ETLtS0j9Gbs=;
        b=IWUTCcHQjUi+pqw4fI/GIVwJJSKTLtj/WYk7MGzuHfeIKPwvR5jLu2DS/BJHNXY7dn
         WDeRJiJl47VPSKCxy0aLVwb8L19WAUFb17AZ6Xu+Vf4H5E7WL/1ZT51uriXqhUoO5isS
         nnu3Uvy0ZRpJZNMyOKg6Mdwq89KYKwJDqa0P0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXF/sgIHn5IY/DFNG1dgAypPPI+KWpv/ETLtS0j9Gbs=;
        b=e3aCBBF0xwt+vTZUW4mKxsolor/GzL9nOYr2nuf2MelXAMdUUkWUic0/m3s9neeaBR
         GeWKWk5pH1C5rkq46F/POFN47C6f9URLfXxMSQf5mjI8GtCnRaDulPjp4x4+QQp1h2qy
         3wKqSXR/OFI0SUgVoiFdGZeJ/P32RyL5RKHVpq9nBm4a8i8DASf5EjXqwih3r2GFcosU
         JuW6iNGPngoPiroUYDCtsLlabjKmwAj7nu8LTZROjDAYCAqdeoXwbNmnO0UZxLAoRhJU
         IzGoSUJbvms88fv7QApZ34blkCzR+CNZaVlOahqgY8z9IcZqXFtbI5VnxfH/v16Fda+h
         0MPA==
X-Gm-Message-State: AO0yUKUrc5kV/9sCZfjqONt5jOnm+sYtMuYg3u6NitnGo7Zj1wmPaGkZ
        DLHJrw0y/2JGBAqiv0VhDgsWMQ==
X-Google-Smtp-Source: AK7set91vc8MbNbQSVG1q1MhN6sYhj1Rx/7InNJR/wggV2TUV8x+xX22ckKqB3U4MlO3gFG6q7FzCQ==
X-Received: by 2002:a05:6830:4123:b0:684:ac9d:1a17 with SMTP id w35-20020a056830412300b00684ac9d1a17mr9915686ott.3.1678808094577;
        Tue, 14 Mar 2023 08:34:54 -0700 (PDT)
Received: from JNXK7M3.. ([2a09:bac5:bf22:96::f:316])
        by smtp.gmail.com with ESMTPSA id a22-20020a9d4716000000b00693ea7bfdc2sm1180855otf.76.2023.03.14.08.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:34:54 -0700 (PDT)
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     toshiaki.makita1@gmail.com
Cc:     toke@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, lorenzo@kernel.org,
        Shawn Bohrer <sbohrer@cloudflare.com>
Subject: [PATCH] veth: Fix use after free in XDP_REDIRECT
Date:   Tue, 14 Mar 2023 10:33:51 -0500
Message-Id: <20230314153351.2201328-1-sbohrer@cloudflare.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZBCSAsUBeNvTPj/s@JNXK7M3>
References: <ZBCSAsUBeNvTPj/s@JNXK7M3>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework veth_xdp_rcv_skb
in order to accept non-linear skb" introduced a bug where it tried to
use pskb_expand_head() if the headroom was less than
XDP_PACKET_HEADROOM.  This however uses kmalloc to expand the head,
which will later allow consume_skb() to free the skb while is it still
in use by AF_XDP.

Previously if the headroom was less than XDP_PACKET_HEADROOM we
continued on to allocate a new skb from pages so this restores that
behavior.

BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640

CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x48
  print_report+0x170/0x473
  ? __xsk_rcv+0x18d/0x2c0
  kasan_report+0xad/0x130
  ? __xsk_rcv+0x18d/0x2c0
  kasan_check_range+0x149/0x1a0
  memcpy+0x20/0x60
  __xsk_rcv+0x18d/0x2c0
  __xsk_map_redirect+0x1f3/0x490
  ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
  xdp_do_redirect+0x5ca/0xd60
  veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
  ? __netif_receive_skb_list_core+0x671/0x920
  ? veth_xdp+0x670/0x670 [veth]
  veth_xdp_rcv+0x304/0xa20 [veth]
  ? do_xdp_generic+0x150/0x150
  ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
  ? _raw_spin_lock_bh+0xe0/0xe0
  ? newidle_balance+0x887/0xe30
  ? __perf_event_task_sched_in+0xdb/0x800
  veth_poll+0x139/0x571 [veth]
  ? veth_xdp_rcv+0xa20/0xa20 [veth]
  ? _raw_spin_unlock+0x39/0x70
  ? finish_task_switch.isra.0+0x17e/0x7d0
  ? __switch_to+0x5cf/0x1070
  ? __schedule+0x95b/0x2640
  ? io_schedule_timeout+0x160/0x160
  __napi_poll+0xa1/0x440
  napi_threaded_poll+0x3d1/0x460
  ? __napi_poll+0x440/0x440
  ? __kthread_parkme+0xc6/0x1f0
  ? __napi_poll+0x440/0x440
  kthread+0x2a2/0x340
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

Freed by task 148640:
  kasan_save_stack+0x23/0x50
  kasan_set_track+0x21/0x30
  kasan_save_free_info+0x2a/0x40
  ____kasan_slab_free+0x169/0x1d0
  slab_free_freelist_hook+0xd2/0x190
  __kmem_cache_free+0x1a1/0x2f0
  skb_release_data+0x449/0x600
  consume_skb+0x9f/0x1c0
  veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
  veth_xdp_rcv+0x304/0xa20 [veth]
  veth_poll+0x139/0x571 [veth]
  __napi_poll+0xa1/0x440
  napi_threaded_poll+0x3d1/0x460
  kthread+0x2a2/0x340
  ret_from_fork+0x22/0x30

The buggy address belongs to the object at ffff888976250000
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 340 bytes inside of
  2048-byte region [ffff888976250000, ffff888976250800)

The buggy address belongs to the physical page:
page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                  ^
  ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb")
Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>
---
 drivers/net/veth.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 1bb54de7124d..6b10aa3883c5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -708,7 +708,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	u32 frame_sz;
 
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
-	    skb_shinfo(skb)->nr_frags) {
+	    skb_shinfo(skb)->nr_frags || skb_headroom(skb) < XDP_PACKET_HEADROOM) {
 		u32 size, len, max_head_size, off;
 		struct sk_buff *nskb;
 		struct page *page;
@@ -773,9 +773,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 
 		consume_skb(skb);
 		skb = nskb;
-	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
-		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
-		goto drop;
 	}
 
 	/* SKB "head" area always have tailroom for skb_shared_info */
-- 
2.34.1

