Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563A43E0FB2
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhHEHyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238830AbhHEHyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:54:32 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C97AC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 00:54:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z3so6074819plg.8
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 00:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=R49BBtfwUSQ0Gn8IrXLWnW688wWW2GAReEpfTpLLUm4=;
        b=EPCTMrMXzZSix+p+Oi/ysvUIe/5QCJsuzBejYSLrLblGCWl3XZGeRIhXbOKL1n0hkQ
         iD9cK55xd3t2U239+6JmzpGoWZN1t/6AhnX3ej+Q2RpRmiVK2TevMpP7/27jJ8KSudWU
         Rf7A/YxxQ9Ra6xYyUx/HFFRUtvv1aeTB4uUAnQElzMHQYLuMcO+MFTNs8Bmv8fjH9Yvc
         e6dftAwccuM3M0oqM9y7HRbGG0BJCvrmq9audc3KQstA4FUeqpGYMaR8ojSv5zUEPqSj
         u7AZY6Wqku92iM+Dda/99z2ZXTSoq6zkNKSnSom1vKSfYXMA6h7G9dledQTaTVMjJMIE
         PDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=R49BBtfwUSQ0Gn8IrXLWnW688wWW2GAReEpfTpLLUm4=;
        b=FvzvqDLmYh9DqJNdHBApfIesbuwaXDdtTpQLxHE8of7oZo/WfFaDzGtDRrAJPYjR5w
         xrOVuD/M4mCCxgCuRq8pIgXR0ZKqEGN9eMJaU6/xQiMurGXQQ7FA4u6vmU4W28hSY61D
         TU9XEigmhlGpcx6rQgEE4KArjSnEbVL6fx7YcEujp/EMLwxpk/wgPse9K8QestwB4Qdf
         6rDKilOCv/ffi8Abvc2AUDZXCVIhuGkW1JCFX6IFAGtT3F0WgylqwMlML0MqgPtJZxMC
         CLFr8+5oRZg1kIbjwAXz3FC1r3I6+cAjr3x4swBVWEtU78OQWLbucsuE3coeukDs7iWX
         QlYg==
X-Gm-Message-State: AOAM5311d/j80XALIF2qooGQ/56Yiu3AEMZ/7Mqt5bT33Ooklncem3fj
        YkvIGud4F+Cw4gK4FMpSqQ==
X-Google-Smtp-Source: ABdhPJworZo0SuDFX4r/a7j32vEs12EOwd+SqzzGHiSjkUZ1Nci/H7ixzDgN1VfLkNGq2fiYAjyS/Q==
X-Received: by 2002:a17:902:c651:b029:12c:1ec0:a8b8 with SMTP id s17-20020a170902c651b029012c1ec0a8b8mr2867053pls.40.1628150058060;
        Thu, 05 Aug 2021 00:54:18 -0700 (PDT)
Received: from DESKTOP (softbank126075190089.bbtec.net. [126.75.190.89])
        by smtp.gmail.com with ESMTPSA id n23sm5986591pgv.76.2021.08.05.00.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 00:54:17 -0700 (PDT)
Date:   Thu, 5 Aug 2021 16:54:14 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: Fix memory leak in ieee802154_raw_deliver
Message-ID: <20210805075414.GA15796@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IEEE-802.15.4-RAW is closed before receive skb, skb is leaked.
Fix this, by freeing sk_receive_queue in sk->sk_destruct().

syzbot report:
BUG: memory leak
unreferenced object 0xffff88810f644600 (size 232):
  comm "softirq", pid 0, jiffies 4294967032 (age 81.270s)
  hex dump (first 32 bytes):
    10 7d 4b 12 81 88 ff ff 10 7d 4b 12 81 88 ff ff  .}K......}K.....
    00 00 00 00 00 00 00 00 40 7c 4b 12 81 88 ff ff  ........@|K.....
  backtrace:
    [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
    [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
    [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
    [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
    [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
    [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
    [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
    [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
    [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
    [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
    [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
    [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
    [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
    [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
    [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
    [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
    [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
    [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
    [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
    [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
    [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
    [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
    [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
    [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985

Fixes: 9ec767160357 ("net: add IEEE 802.15.4 socket family implementation")
Reported-and-tested-by: syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
Dear David Howells, Jakub Kicinski

syzbot reported memory leak in ieee802154_raw_deliver.

I send a patch that passed syzbot reproducer test.
Please consider this memory leak and patch.

syzbot link:
https://syzkaller.appspot.com/bug?id=8dd3bcb1dc757587adfb4dbb810fd24dd990283f

Regards.
---
 net/ieee802154/socket.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a45a0401adc5..c25f7617770c 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -984,6 +984,11 @@ static const struct proto_ops ieee802154_dgram_ops = {
 	.sendpage	   = sock_no_sendpage,
 };
 
+static void ieee802154_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 /* Create a socket. Initialise the socket, blank the addresses
  * set the state.
  */
@@ -1024,7 +1029,7 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 	sock->ops = ops;
 
 	sock_init_data(sock, sk);
-	/* FIXME: sk->sk_destruct */
+	sk->sk_destruct = ieee802154_sock_destruct;
 	sk->sk_family = PF_IEEE802154;
 
 	/* Checksums on by default */
-- 
2.25.1

