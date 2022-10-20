Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C77606B7A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiJTWpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiJTWpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:45:22 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA7AEC506
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:17 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id u9-20020a05620a454900b006eeafac8ea4so1214784qkp.19
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WNPO3f7VcC0JzG0u4+ofWwLPFK0No97JmpOinn9qHUY=;
        b=s46zASXWNOgX5ibBSdcpG4JFoGOKa/H6KStJd/3Fw6DgpaG7mzsMBYEFaJe1TBDvtk
         TI1l+7Q3u7kWNEgdC6sblQ+PqdMuWuLHaBKKVv0oV2mdFYzWiVKc16ZrjNzaEtZhKgJV
         sFCz74UCjO50NdX5MiAECsgwaYdLAxkXqPWfdFpfww9AiMfjpQijeXdgh7Wd45TWYy0z
         0I6oJO5yeHj1DlczDLLkJizcOVq5Ja6a1J9DbzkYjGlQ/5AkZTGmWIKbeGzr2wblf8iZ
         M3Mil6iUtum2EYSO+ygHSqo/xYMK/carP2dQaZkLkUFpJY74NDGtg+fA3vzQ4FY9h9bh
         XVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNPO3f7VcC0JzG0u4+ofWwLPFK0No97JmpOinn9qHUY=;
        b=XQfrA2ee7bP8T0LIcs7l+B+APnmBy6GnzqxGFo2dpLjcbtvn0KHj1SQ/NWwp4OFQxA
         wseVyk+fxemxvAa+BmMNhQhuOIPI/u9Z816dapBMh9t+86B+1+8FI3jduMWxt7X5CLH2
         y22q2LSOH4Eor9i/ENi52M5RfD233tVvqijb/DW7Y24CoBoolDxWuwVlbptsDyQYc2Ef
         MDDsp8wwjDX9FEGwQXmllpExSqiT5PH7bTSVRexyX8HkMc4F6XB308fj+4Be8+HqUk74
         SohLIzzIjyMeo7HxOSxchUFoP5slOBRn0J6W/Hy0IwzTG23B33oRRmIHf8vnbyMRRlOf
         dGhg==
X-Gm-Message-State: ACrzQf3zX7G4AF+OtoEDgE67ikqWNXERlvQ5eZXDofkmVWFwh1ZkkK1m
        dHnVGEGxuim50jszTXpuavjusIjSJNBkPw==
X-Google-Smtp-Source: AMsMyM5OLDI38tLYwXNpPKHSZh/BOqE8IxzN1PmGVoDhUhyRlOGU0lB5hmOHx6Suird3Vh7vDQUAP/AQm6EhNg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ac8:5707:0:b0:39d:c40:cf51 with SMTP id
 7-20020ac85707000000b0039d0c40cf51mr4526637qtw.102.1666305916364; Thu, 20 Oct
 2022 15:45:16 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:45:11 +0000
In-Reply-To: <20221020224512.3211657-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221020224512.3211657-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221020224512.3211657-2-edumazet@google.com>
Subject: [PATCH net 1/2] kcm: annotate data-races around kcm->rx_psock
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
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

kcm->rx_psock can be read locklessly in kcm_rfree().
Annotate the read and writes accordingly.

We do the same for kcm->rx_wait in the following patch.

syzbot reported:
BUG: KCSAN: data-race in kcm_rfree / unreserve_rx_kcm

write to 0xffff888123d827b8 of 8 bytes by task 2758 on cpu 1:
unreserve_rx_kcm+0x72/0x1f0 net/kcm/kcmsock.c:313
kcm_rcv_strparser+0x2b5/0x3a0 net/kcm/kcmsock.c:373
__strp_recv+0x64c/0xd20 net/strparser/strparser.c:301
strp_recv+0x6d/0x80 net/strparser/strparser.c:335
tcp_read_sock+0x13e/0x5a0 net/ipv4/tcp.c:1703
strp_read_sock net/strparser/strparser.c:358 [inline]
do_strp_work net/strparser/strparser.c:406 [inline]
strp_work+0xe8/0x180 net/strparser/strparser.c:415
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

read to 0xffff888123d827b8 of 8 bytes by task 5859 on cpu 0:
kcm_rfree+0x14c/0x220 net/kcm/kcmsock.c:181
skb_release_head_state+0x8e/0x160 net/core/skbuff.c:841
skb_release_all net/core/skbuff.c:852 [inline]
__kfree_skb net/core/skbuff.c:868 [inline]
kfree_skb_reason+0x5c/0x260 net/core/skbuff.c:891
kfree_skb include/linux/skbuff.h:1216 [inline]
kcm_recvmsg+0x226/0x2b0 net/kcm/kcmsock.c:1161
____sys_recvmsg+0x16c/0x2e0
___sys_recvmsg net/socket.c:2743 [inline]
do_recvmmsg+0x2f1/0x710 net/socket.c:2837
__sys_recvmmsg net/socket.c:2916 [inline]
__do_sys_recvmmsg net/socket.c:2939 [inline]
__se_sys_recvmmsg net/socket.c:2932 [inline]
__x64_sys_recvmmsg+0xde/0x160 net/socket.c:2932
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0xffff88812971ce00 -> 0x0000000000000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 5859 Comm: syz-executor.3 Not tainted 6.0.0-syzkaller-12189-g19d17ab7c68b-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/kcm/kcmsock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 27725464ec08fe2b5f2e86202636cbc895568098..0109ef6ddf9aed853a6cf1fb69e330fd8bc6654a 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -178,7 +178,7 @@ static void kcm_rfree(struct sk_buff *skb)
 	/* For reading rx_wait and rx_psock without holding lock */
 	smp_mb__after_atomic();
 
-	if (!kcm->rx_wait && !kcm->rx_psock &&
+	if (!kcm->rx_wait && !READ_ONCE(kcm->rx_psock) &&
 	    sk_rmem_alloc_get(sk) < sk->sk_rcvlowat) {
 		spin_lock_bh(&mux->rx_lock);
 		kcm_rcv_ready(kcm);
@@ -283,7 +283,8 @@ static struct kcm_sock *reserve_rx_kcm(struct kcm_psock *psock,
 	kcm->rx_wait = false;
 
 	psock->rx_kcm = kcm;
-	kcm->rx_psock = psock;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, psock);
 
 	spin_unlock_bh(&mux->rx_lock);
 
@@ -310,7 +311,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 	spin_lock_bh(&mux->rx_lock);
 
 	psock->rx_kcm = NULL;
-	kcm->rx_psock = NULL;
+	/* paired with lockless reads in kcm_rfree() */
+	WRITE_ONCE(kcm->rx_psock, NULL);
 
 	/* Commit kcm->rx_psock before sk_rmem_alloc_get to sync with
 	 * kcm_rfree
-- 
2.38.0.135.g90850a2211-goog

