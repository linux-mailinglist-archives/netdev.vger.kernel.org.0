Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22D3502E99
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 20:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345788AbiDOSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 14:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbiDOSRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 14:17:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BFA1EEDD
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 11:14:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d15so7662692pll.10
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 11:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oEXDQqkyUJBInPCjV3VQXv4+geBUUa+rPkypRObMfnk=;
        b=qkcNKOqXleOUX0zNRAcEjl8lcB6qSSuwudcfs3PNPas7HZvj2AKlYajh8eVbUctMnb
         LqcDS9XKtpx7ifdS6oC6zVG9+JhOXiEL2cBav/yjj6xDbJL+J0fwczttlZZd3eu4vdpO
         0s3D73czZvXO3mMLlBr/N0wTB2y6mtOwIorW4ZIrj12ezWeOE9KGNxdydHsoOVsoYde0
         KkOS/qwZMi1Q66S9wWJWXX+U/sUG3G2R7U3E/vPZ2lYnXhsfp1d0FdRQhV6erjXGqeKe
         9FtqvDLpB6ZK9tKm6m5rP6Je2tCTYLZLQsgahZ4+h3soaNyb7LD8hRd8TveU2v0RLm1Z
         bjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oEXDQqkyUJBInPCjV3VQXv4+geBUUa+rPkypRObMfnk=;
        b=lomlA9zo2GX1+yT54iKouOX9AUIyq7Yl74eSTz0R+awNod8rnZEhIuVlbY0TCCX53G
         c6deInPNL0UFH7S9+t3nfwuGvhuGEILJ0MMK52sCLzr4NLhBCXo831SbhHYitHEfWx2h
         y3oaXtim+plUsjqh9VAbyudL80JFNNdlhcnjk9e6N8GLclw+8LcihiB6/ZQQBWlaWjNO
         X24zOLMzeyU5XtV/hVtf/Gs4UNkQiKxggSSy+rBpr9WKeA8MLlyrrYlT1Xty68Rl8z+V
         Jm29Hu+fhoxKNjUm2PoNwlmrW0b9N4puuqA84CAEE5yiu23yp3gZ0uaGep6pSpHn5qE3
         eIZw==
X-Gm-Message-State: AOAM530KYh1uDrE4CclOt7+y6sG9SLv44tmEEcvQvFQFzR76PHRLYgTC
        vn4Skm18WyJNXJA2EvvenMU=
X-Google-Smtp-Source: ABdhPJxbvs8bNB1LnlYw2BjQE/V++3wuO3149YE4CVEzpMynP0sznJZGeCKeqrn6j/H+JgIADzXDzQ==
X-Received: by 2002:a17:90b:4a89:b0:1c7:3933:d802 with SMTP id lp9-20020a17090b4a8900b001c73933d802mr114856pjb.75.1650046486762;
        Fri, 15 Apr 2022 11:14:46 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:147b:581d:7b9d:b092])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a414a00b001cb776494a5sm9412744pjg.0.2022.04.15.11.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 11:14:45 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netlink: reset network and mac headers in netlink_dump()
Date:   Fri, 15 Apr 2022 11:14:42 -0700
Message-Id: <20220415181442.551228-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

netlink_dump() is allocating an skb, reserves space in it
but forgets to reset network header.

This allows a BPF program, invoked later from sk_filter()
to access uninitialized kernel memory from the reserved
space.

Theorically mac header reset could be omitted, because
it is set to a special initial value.
bpf_internal_load_pointer_neg_helper calls skb_mac_header()
without checking skb_mac_header_was_set().
Relying on skb->len not being too big seems fragile.
We also could add a sanity check in bpf_internal_load_pointer_neg_helper()
to avoid surprises in the future.

syzbot report was:

BUG: KMSAN: uninit-value in ___bpf_prog_run+0xa22b/0xb420 kernel/bpf/core.c:1637
 ___bpf_prog_run+0xa22b/0xb420 kernel/bpf/core.c:1637
 __bpf_prog_run32+0x121/0x180 kernel/bpf/core.c:1796
 bpf_dispatcher_nop_func include/linux/bpf.h:784 [inline]
 __bpf_prog_run include/linux/filter.h:626 [inline]
 bpf_prog_run include/linux/filter.h:633 [inline]
 __bpf_prog_run_save_cb+0x168/0x580 include/linux/filter.h:756
 bpf_prog_run_save_cb include/linux/filter.h:770 [inline]
 sk_filter_trim_cap+0x3bc/0x8c0 net/core/filter.c:150
 sk_filter include/linux/filter.h:905 [inline]
 netlink_dump+0xe0c/0x16c0 net/netlink/af_netlink.c:2276
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 ___bpf_prog_run+0x96c/0xb420 kernel/bpf/core.c:1558
 __bpf_prog_run32+0x121/0x180 kernel/bpf/core.c:1796
 bpf_dispatcher_nop_func include/linux/bpf.h:784 [inline]
 __bpf_prog_run include/linux/filter.h:626 [inline]
 bpf_prog_run include/linux/filter.h:633 [inline]
 __bpf_prog_run_save_cb+0x168/0x580 include/linux/filter.h:756
 bpf_prog_run_save_cb include/linux/filter.h:770 [inline]
 sk_filter_trim_cap+0x3bc/0x8c0 net/core/filter.c:150
 sk_filter include/linux/filter.h:905 [inline]
 netlink_dump+0xe0c/0x16c0 net/netlink/af_netlink.c:2276
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3244 [inline]
 __kmalloc_node_track_caller+0xde3/0x14f0 mm/slub.c:4972
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1158 [inline]
 netlink_dump+0x30f/0x16c0 net/netlink/af_netlink.c:2242
 netlink_recvmsg+0x1129/0x1c80 net/netlink/af_netlink.c:2002
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_read_iter+0x5a9/0x630 net/socket.c:1039
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_read+0x52c/0x14c0 fs/read_write.c:786
 vfs_readv fs/read_write.c:906 [inline]
 do_readv+0x432/0x800 fs/read_write.c:943
 __do_sys_readv fs/read_write.c:1034 [inline]
 __se_sys_readv fs/read_write.c:1031 [inline]
 __x64_sys_readv+0xe5/0x120 fs/read_write.c:1031
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 3470 Comm: syz-executor751 Not tainted 5.17.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: db65a3aaf29e ("netlink: Trim skb to alloc size to avoid MSG_TRUNC")
Fixes: 9063e21fb026 ("netlink: autosize skb lengthes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netlink/af_netlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 47a876ccd28816a6065d1c4b7de8cfc97e887a69..05a3795eac8e9a7c8343460d9a41e0755a64c36e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2263,6 +2263,13 @@ static int netlink_dump(struct sock *sk)
 	 * single netdev. The outcome is MSG_TRUNC error.
 	 */
 	skb_reserve(skb, skb_tailroom(skb) - alloc_size);
+
+	/* Make sure malicious BPF programs can not read unitialized memory
+	 * from skb->head -> skb->data
+	 */
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
+
 	netlink_skb_set_owner_r(skb, sk);
 
 	if (nlk->dump_done_errno > 0) {
-- 
2.36.0.rc0.470.gd361397f0d-goog

