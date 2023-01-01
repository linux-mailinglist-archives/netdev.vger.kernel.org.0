Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A8665ABDB
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 22:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjAAV7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 16:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjAAV7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 16:59:07 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755922734
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 13:59:06 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id i12so18578812qvs.2
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 13:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idW/JBVcAyO1TsGvkOqgkkfuViALq33qRXyEBBjsqtI=;
        b=vKpWU7OAWanUmkY3FpGAizv2DF49uh+ce8IEMQLwbpgxH9PV2zOaEEyKrhFqqNur65
         E4xDGsqatTyVZnvZUIBrmlq67LmoYmveXP3qJHOZjJXDInHh4Cc0Z7MdhYTggKUzEPLl
         GJdH6f3zP809fZMvp5Ss3TZIVqS73QoOTWtcDGywQ73D7EUxxCCG2AKd3uwgvgEdP5QW
         3+WEOGMWV4HqAD3p4IKlDC4RmwfVwpHSRF71bd4nOh/+Nd+ez7zsUbQUz2zFFJOPdQ5V
         NvNSbpZ9OHUHU1hwBF4c0FHBryp7IiCbLHiFYerrLDRFeAwQKf2VAybQ9zlFnGfc56Yf
         6myQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idW/JBVcAyO1TsGvkOqgkkfuViALq33qRXyEBBjsqtI=;
        b=1PHCuYFnT+3ZUWz4/q+JMjT6qfS12tTSBtHSws6ttBaeQ6VK/ZvS1WW2fWFHevwfZU
         YYxD9ib4tQpLFixSHqKbMN9GYVacakDfo6MykQiGbkV09brSow6+0Vj1xiqpinxrvMPH
         lAkotlPBwFHq1BSSGrsQBXy790FxFnboWNd7LuR4NU+/vE3HiupRZkUXzash+zutgjpM
         ZX3ieyTfc+Cn8T3EePGXh0mRrk5zQ+BNlAy+eoMkbhVwaeL16giWLagXBUoqRFIJo9q0
         PGOcf/4n0Pu8gfS7oYQrj56AW2Sq6yJBf5cdukTAuo6RpnvBcEXa3SurRfQZgmC0Lv7z
         b8ng==
X-Gm-Message-State: AFqh2kpDs+4tibSMeV8sOD8d6bjI9+FFDAkuhDkFyktE5ebe3yC0YlXZ
        Xz5KNdX2N2FEDecJX3rX3YPDyQ==
X-Google-Smtp-Source: AMrXdXtIt2L7EW3I7xZ5nE58itxmTRCFAv8NRSbU5x6hf6FGJHHivCiuXwd59QNOHp1mbUOen2zi8g==
X-Received: by 2002:a0c:eecc:0:b0:531:c5ae:b9a1 with SMTP id h12-20020a0ceecc000000b00531c5aeb9a1mr3343522qvs.25.1672610345602;
        Sun, 01 Jan 2023 13:59:05 -0800 (PST)
Received: from mbili.. (bras-base-kntaon1618w-grc-10-184-145-9-33.dsl.bell.ca. [184.145.9.33])
        by smtp.gmail.com with ESMTPSA id m14-20020ae9e70e000000b006e42a8e9f9bsm19233073qka.121.2023.01.01.13.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 13:59:05 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        zengyhkyle@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 2/2] net: sched: cbq: dont intepret cls results when asked to drop
Date:   Sun,  1 Jan 2023 16:57:44 -0500
Message-Id: <20230101215744.709178-3-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230101215744.709178-1-jhs@mojatatu.com>
References: <20230101215744.709178-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If asked to drop a packet via TC_ACT_SHOT it is unsafe to assume that
res.class contains a valid pointer

Sample splat reported by Kyle Zeng

[    5.405624] 0: reclassify loop, rule prio 0, protocol 800
[    5.406326] ==================================================================
[    5.407240] BUG: KASAN: slab-out-of-bounds in cbq_enqueue+0x54b/0xea0
[    5.407987] Read of size 1 at addr ffff88800e3122aa by task poc/299
[    5.408731]
[    5.408897] CPU: 0 PID: 299 Comm: poc Not tainted 5.10.155+ #15
[    5.409516] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.15.0-1 04/01/2014
[    5.410439] Call Trace:
[    5.410764]  dump_stack+0x87/0xcd
[    5.411153]  print_address_description+0x7a/0x6b0
[    5.411687]  ? vprintk_func+0xb9/0xc0
[    5.411905]  ? printk+0x76/0x96
[    5.412110]  ? cbq_enqueue+0x54b/0xea0
[    5.412323]  kasan_report+0x17d/0x220
[    5.412591]  ? cbq_enqueue+0x54b/0xea0
[    5.412803]  __asan_report_load1_noabort+0x10/0x20
[    5.413119]  cbq_enqueue+0x54b/0xea0
[    5.413400]  ? __kasan_check_write+0x10/0x20
[    5.413679]  __dev_queue_xmit+0x9c0/0x1db0
[    5.413922]  dev_queue_xmit+0xc/0x10
[    5.414136]  ip_finish_output2+0x8bc/0xcd0
[    5.414436]  __ip_finish_output+0x472/0x7a0
[    5.414692]  ip_finish_output+0x5c/0x190
[    5.414940]  ip_output+0x2d8/0x3c0
[    5.415150]  ? ip_mc_finish_output+0x320/0x320
[    5.415429]  __ip_queue_xmit+0x753/0x1760
[    5.415664]  ip_queue_xmit+0x47/0x60
[    5.415874]  __tcp_transmit_skb+0x1ef9/0x34c0
[    5.416129]  tcp_connect+0x1f5e/0x4cb0
[    5.416347]  tcp_v4_connect+0xc8d/0x18c0
[    5.416577]  __inet_stream_connect+0x1ae/0xb40
[    5.416836]  ? local_bh_enable+0x11/0x20
[    5.417066]  ? lock_sock_nested+0x175/0x1d0
[    5.417309]  inet_stream_connect+0x5d/0x90
[    5.417548]  ? __inet_stream_connect+0xb40/0xb40
[    5.417817]  __sys_connect+0x260/0x2b0
[    5.418037]  __x64_sys_connect+0x76/0x80
[    5.418267]  do_syscall_64+0x31/0x50
[    5.418477]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[    5.418770] RIP: 0033:0x473bb7
[    5.418952] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00
00 00 90 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2a 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 18 89 54 24 0c 48 89 34
24 89
[    5.420046] RSP: 002b:00007fffd20eb0f8 EFLAGS: 00000246 ORIG_RAX:
000000000000002a
[    5.420472] RAX: ffffffffffffffda RBX: 00007fffd20eb578 RCX: 0000000000473bb7
[    5.420872] RDX: 0000000000000010 RSI: 00007fffd20eb110 RDI: 0000000000000007
[    5.421271] RBP: 00007fffd20eb150 R08: 0000000000000001 R09: 0000000000000004
[    5.421671] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[    5.422071] R13: 00007fffd20eb568 R14: 00000000004fc740 R15: 0000000000000002
[    5.422471]
[    5.422562] Allocated by task 299:
[    5.422782]  __kasan_kmalloc+0x12d/0x160
[    5.423007]  kasan_kmalloc+0x5/0x10
[    5.423208]  kmem_cache_alloc_trace+0x201/0x2e0
[    5.423492]  tcf_proto_create+0x65/0x290
[    5.423721]  tc_new_tfilter+0x137e/0x1830
[    5.423957]  rtnetlink_rcv_msg+0x730/0x9f0
[    5.424197]  netlink_rcv_skb+0x166/0x300
[    5.424428]  rtnetlink_rcv+0x11/0x20
[    5.424639]  netlink_unicast+0x673/0x860
[    5.424870]  netlink_sendmsg+0x6af/0x9f0
[    5.425100]  __sys_sendto+0x58d/0x5a0
[    5.425315]  __x64_sys_sendto+0xda/0xf0
[    5.425539]  do_syscall_64+0x31/0x50
[    5.425764]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[    5.426065]
[    5.426157] The buggy address belongs to the object at ffff88800e312200
[    5.426157]  which belongs to the cache kmalloc-128 of size 128
[    5.426955] The buggy address is located 42 bytes to the right of
[    5.426955]  128-byte region [ffff88800e312200, ffff88800e312280)
[    5.427688] The buggy address belongs to the page:
[    5.427992] page:000000009875fabc refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0xe312
[    5.428562] flags: 0x100000000000200(slab)
[    5.428812] raw: 0100000000000200 dead000000000100 dead000000000122
ffff888007843680
[    5.429325] raw: 0000000000000000 0000000000100010 00000001ffffffff
ffff88800e312401
[    5.429875] page dumped because: kasan: bad access detected
[    5.430214] page->mem_cgroup:ffff88800e312401
[    5.430471]
[    5.430564] Memory state around the buggy address:
[    5.430846]  ffff88800e312180: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[    5.431267]  ffff88800e312200: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 fc
[    5.431705] >ffff88800e312280: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[    5.432123]                                   ^
[    5.432391]  ffff88800e312300: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 fc
[    5.432810]  ffff88800e312380: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[    5.433229] ==================================================================
[    5.433648] Disabling lock debugging due to kernel taint

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/sch_cbq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 6568e17c4c63..36db5f6782f2 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -230,6 +230,8 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		result = tcf_classify(skb, NULL, fl, &res, true);
 		if (!fl || result < 0)
 			goto fallback;
+		if (result == TC_ACT_SHOT)
+			return NULL;

 		cl = (void *)res.class;
 		if (!cl) {
@@ -250,8 +252,6 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
 			fallthrough;
-		case TC_ACT_SHOT:
-			return NULL;
 		case TC_ACT_RECLASSIFY:
 			return cbq_reclassify(skb, cl);
 		}
-- 
2.34.1

