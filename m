Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224EC68F0AC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjBHOZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBHOZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CB64B19A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:25:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-527b1358200so92644857b3.13
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ladg9laQhd/n/5kQ3H+SHhzGqQ2exbdd69cGwsuFLsA=;
        b=l9ZFTW5wfmHrJxR64+ttG2T9EihrPZ6RH8yKRXwyMmxu51wI5SIfb9qE3AS467+P2g
         awgYYothivCrVLolDgwJ2xvC6VcbexbGDxeY37GcEYFpOwkaCm/kWrHoq/k4abqMye4p
         7oaRCYf0XYK8Jrw1oqltCTqJDaN4v0w/RUYg+m+Xsowpmgo9vnlpNGw77kUE1+DWXndc
         /Id8xz38/d83iD3U8Y0QLUSI3DPNOuHcBTzQ+G8572J99W1GMa63OtBbSluxOrlmc1L+
         LJ2P1sKaHq3ZG97XaT0JkTHsTUxsgVfDWSc92PVz81b7CjndNwm1lOD1ZZIN6Y6FH8N0
         9kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ladg9laQhd/n/5kQ3H+SHhzGqQ2exbdd69cGwsuFLsA=;
        b=3kAYySll3xTxbSfheouTsei1hJr+2F57Z/B4GG/1c55YXF72ovQjpGsbaGW9ND1EA1
         nvUdRZPpwpAmGDLkaEwPEKk1+91f+6CEonDPD/L53GEOET7lhVpn+BaHBC7eHh4pApCc
         2bRNtklgRf8A8dlGkKSttl9pWGxHWUPBw1Z1JicKETbWqtpOrVCBF4L+q9UguhqoH+Yk
         xPfieAAeWPX9AGkzKR1H4pHTv/63XB9W8/PBRhkIwsCMi4/t9K1F1z4PkjWi2o4xDZfq
         oZrDg3izEoHuj1vVtzMTOm9vaujTs0ex32sT2zu36eH/HLq6ooiImPD0504K+GsFLYnd
         Q1rw==
X-Gm-Message-State: AO0yUKWUTSiKmQujoGdw1tjncaLb6ld58gLXmM2rzbK2A7j6nR5zsDuv
        x3/Bll0JgmW0Fu7OKmUD7suUxhC5SBOl4A==
X-Google-Smtp-Source: AK7set/KZEp02GwroZ0wGm//tMtk9kaCEBTxhZoK7AVcQ+oEoLdiiAy4lfY3DyBhTxreff0Ixk9GpZE8LNe4oA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:407:0:b0:88a:f2f:d004 with SMTP id
 7-20020a250407000000b0088a0f2fd004mr5ybe.5.1675866310291; Wed, 08 Feb 2023
 06:25:10 -0800 (PST)
Date:   Wed,  8 Feb 2023 14:25:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208142508.3278406-1-edumazet@google.com>
Subject: [PATCH net-next] net: enable usercopy for skb_small_head_cache
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot and other bots reported that we have to enable
user copy to/from skb->head. [1]

We can prevent access to skb_shared_info, which is a nice
improvement over standard kmem_cache.

Layout of these kmem_cache objects is:

< SKB_SMALL_HEAD_HEADROOM >< struct skb_shared_info >

usercopy: Kernel memory overwrite attempt detected to SLUB object 'skbuff_small_head' (offset 32, size 20)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:102 !
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.2.0-rc6-syzkaller-01425-gcb6b2e11a42d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
RIP: 0010:usercopy_abort+0xbd/0xbf mm/usercopy.c:102
Code: e8 ee ad ba f7 49 89 d9 4d 89 e8 4c 89 e1 41 56 48 89 ee 48 c7 c7 20 2b 5b 8a ff 74 24 08 41 57 48 8b 54 24 20 e8 7a 17 fe ff <0f> 0b e8 c2 ad ba f7 e8 7d fb 08 f8 48 8b 0c 24 49 89 d8 44 89 ea
RSP: 0000:ffffc90000067a48 EFLAGS: 00010286
RAX: 000000000000006b RBX: ffffffff8b5b6ea0 RCX: 0000000000000000
RDX: ffff8881401c0000 RSI: ffffffff8166195c RDI: fffff5200000cf3b
RBP: ffffffff8a5b2a60 R08: 000000000000006b R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8bf2a925
R13: ffffffff8a5b29a0 R14: 0000000000000014 R15: ffffffff8a5b2960
FS: 0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000c48e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__check_heap_object+0xdd/0x110 mm/slub.c:4761
check_heap_object mm/usercopy.c:196 [inline]
__check_object_size mm/usercopy.c:251 [inline]
__check_object_size+0x1da/0x5a0 mm/usercopy.c:213
check_object_size include/linux/thread_info.h:199 [inline]
check_copy_size include/linux/thread_info.h:235 [inline]
copy_from_iter include/linux/uio.h:186 [inline]
copy_from_iter_full include/linux/uio.h:194 [inline]
memcpy_from_msg include/linux/skbuff.h:3977 [inline]
qrtr_sendmsg+0x65f/0x970 net/qrtr/af_qrtr.c:965
sock_sendmsg_nosec net/socket.c:722 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:745
say_hello+0xf6/0x170 net/qrtr/ns.c:325
qrtr_ns_init+0x220/0x2b0 net/qrtr/ns.c:804
qrtr_proto_init+0x59/0x95 net/qrtr/af_qrtr.c:1296
do_one_initcall+0x141/0x790 init/main.c:1306
do_initcall_level init/main.c:1379 [inline]
do_initcalls init/main.c:1395 [inline]
do_basic_setup init/main.c:1414 [inline]
kernel_init_freeable+0x6f9/0x782 init/main.c:1634
kernel_init+0x1e/0x1d0 init/main.c:1522
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
</TASK>

Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bdb1e015e32b9386139e9ad73acd6efb3c357118..70a6088e832682efccf081fa3e6a97cbdeb747ac 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4690,10 +4690,16 @@ void __init skb_init(void)
 						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
 						NULL);
 #ifdef HAVE_SKB_SMALL_HEAD_CACHE
-	skb_small_head_cache = kmem_cache_create("skbuff_small_head",
+	/* usercopy should only access first SKB_SMALL_HEAD_HEADROOM bytes.
+	 * struct skb_shared_info is located at the end of skb->head,
+	 * and should not be copied to/from user.
+	 */
+	skb_small_head_cache = kmem_cache_create_usercopy("skbuff_small_head",
 						SKB_SMALL_HEAD_CACHE_SIZE,
 						0,
 						SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+						0,
+						SKB_SMALL_HEAD_HEADROOM,
 						NULL);
 #endif
 	skb_extensions_init();
-- 
2.39.1.519.gcb327c4b5f-goog

