Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEF55FC85C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJLPZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiJLPZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:25:23 -0400
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2550F9A
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:25:20 -0700 (PDT)
Received: by mail-ej1-x64a.google.com with SMTP id sd5-20020a1709076e0500b0078de7be1ee3so2277367ejc.23
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yu3GPHeMlULojI1/JTHmBLmYCXwxkibU0UYNSNib01c=;
        b=inBQ2+46OdZGEZP0EIgEMcLDhwizvr4YHaViVBNtyru9zGHKlVe/+cv6nNMrIIQMEJ
         G8SBsNVB5KVekNAAkoVnGh8uWqXP+C5qInIzagUUH8IJEb0Y0+thwCWwOCFxe31p5MFk
         VKO0vYPlrFI4qBJ6J7QiQl0Z7ve8sFFGMMbIIrASHKvmwM13K/hn/GM7zipYvCb8AZcM
         g1WJoA3/B8s4cIwV1ptkxEDlDX8uNZ+5IL/jMjhWPbjhMtNrHoodNRdxmfq/+YngOxAM
         gGYsiOUVilQPBB5jmQgDKlYzuRjvWWX1VIEf5k+wxlmMo4VE9+DW5/XomOJP/LuCGOuj
         R/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yu3GPHeMlULojI1/JTHmBLmYCXwxkibU0UYNSNib01c=;
        b=cjbUL5VLNGiG95N6s4fpJE8KwS7+j6rGHvWL+IRXm8b/cefhBt2+4wJm55z/hDuHjj
         JW89RdopZIzSzEAl3OON0URb3jMgBes4Gd5EyuLmHldF168msP6RvAIJn5ZpCY0gXRBo
         8UTDOI/Q0+kk3o6b3tWppvaf+vIVY5oUa6JP1wvv4XQUSJ+MasIuO83Fah9KQ2680p8O
         a7aDjHYgjb+JeQc3kdsqs5EWNDvnsoKuHND+A4xSKVbm2kqMNasPw95bEMoK9SwX8uDr
         IErkpYa+UYrWHhHvUm/AfcytU2AUx9nY6ETWIGIEvEFSDAh1qaHwcCWZP0s2U2Au7ltW
         Wt7Q==
X-Gm-Message-State: ACrzQf0zQv2i2XtWp9Jl1Ufzq82Jydh+9HZ/FC8gIonIS0ChM+AOkALV
        gBL0VFawLOk6IozHBVPvCwvUYK47eWA=
X-Google-Smtp-Source: AMsMyM4gX8K2jJoiz4dWY4552ehVtk3lBTyvItbXkXJvUlI1B3yrv+e6K6QubS86fCNeG7TL5oxMW1D43UE=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:9c:201:2b49:534b:bcb4:a3ee])
 (user=glider job=sendgmr) by 2002:a17:906:794b:b0:787:a9ee:3bf0 with SMTP id
 l11-20020a170906794b00b00787a9ee3bf0mr22636550ejo.354.1665588319189; Wed, 12
 Oct 2022 08:25:19 -0700 (PDT)
Date:   Wed, 12 Oct 2022 17:25:14 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012152514.2060384-1-glider@google.com>
Subject: [PATCH] tipc: fix an information leak in tipc_topsrv_kern_subscr
From:   Alexander Potapenko <glider@google.com>
To:     glider@google.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a 8-byte write to initialize sub.usr_handle in
tipc_topsrv_kern_subscr(), otherwise four bytes remain uninitialized
when issuing setsockopt(..., SOL_TIPC, ...).
This resulted in an infoleak reported by KMSAN when the packet was
received:

  =====================================================
  BUG: KMSAN: kernel-infoleak in copyout+0xbc/0x100 lib/iov_iter.c:169
   instrument_copy_to_user ./include/linux/instrumented.h:121
   copyout+0xbc/0x100 lib/iov_iter.c:169
   _copy_to_iter+0x5c0/0x20a0 lib/iov_iter.c:527
   copy_to_iter ./include/linux/uio.h:176
   simple_copy_to_iter+0x64/0xa0 net/core/datagram.c:513
   __skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:419
   skb_copy_datagram_iter+0x58/0x200 net/core/datagram.c:527
   skb_copy_datagram_msg ./include/linux/skbuff.h:3903
   packet_recvmsg+0x521/0x1e70 net/packet/af_packet.c:3469
   ____sys_recvmsg+0x2c4/0x810 net/socket.c:?
   ___sys_recvmsg+0x217/0x840 net/socket.c:2743
   __sys_recvmsg net/socket.c:2773
   __do_sys_recvmsg net/socket.c:2783
   __se_sys_recvmsg net/socket.c:2780
   __x64_sys_recvmsg+0x364/0x540 net/socket.c:2780
   do_syscall_x64 arch/x86/entry/common.c:50
   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd arch/x86/entry/entry_64.S:120

  ...

  Uninit was stored to memory at:
   tipc_sub_subscribe+0x42d/0xb50 net/tipc/subscr.c:156
   tipc_conn_rcv_sub+0x246/0x620 net/tipc/topsrv.c:375
   tipc_topsrv_kern_subscr+0x2e8/0x400 net/tipc/topsrv.c:579
   tipc_group_create+0x4e7/0x7d0 net/tipc/group.c:190
   tipc_sk_join+0x2a8/0x770 net/tipc/socket.c:3084
   tipc_setsockopt+0xae5/0xe40 net/tipc/socket.c:3201
   __sys_setsockopt+0x87f/0xdc0 net/socket.c:2252
   __do_sys_setsockopt net/socket.c:2263
   __se_sys_setsockopt net/socket.c:2260
   __x64_sys_setsockopt+0xe0/0x160 net/socket.c:2260
   do_syscall_x64 arch/x86/entry/common.c:50
   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd arch/x86/entry/entry_64.S:120

  Local variable sub created at:
   tipc_topsrv_kern_subscr+0x57/0x400 net/tipc/topsrv.c:562
   tipc_group_create+0x4e7/0x7d0 net/tipc/group.c:190

  Bytes 84-87 of 88 are uninitialized
  Memory access of size 88 starts at ffff88801ed57cd0
  Data copied to user address 0000000020000400
  ...
  =====================================================

Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: 026321c6d056a5 ("tipc: rename tipc_server to tipc_topsrv")
---
 net/tipc/topsrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5522865deae95..14fd05fd6107d 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -568,7 +568,7 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.seq.upper = upper;
 	sub.timeout = TIPC_WAIT_FOREVER;
 	sub.filter = filter;
-	*(u32 *)&sub.usr_handle = port;
+	*(u64 *)&sub.usr_handle = (u64)port;
 
 	con = tipc_conn_alloc(tipc_topsrv(net));
 	if (IS_ERR(con))
-- 
2.38.0.rc1.362.ged0d419d3c-goog

