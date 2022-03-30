Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF5C4EB7D6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbiC3Bdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241642AbiC3Bd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB21170D98;
        Tue, 29 Mar 2022 18:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A77D612FA;
        Wed, 30 Mar 2022 01:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2E8C34110;
        Wed, 30 Mar 2022 01:31:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gtemOM1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648603903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PASLOmf9lZuBPPe9/WpVZbnvkcB0REuY6odAbEg0yUw=;
        b=gtemOM1vSfv+fUrW4sZjmPnFuRR46k97uX2FNHKnQsGM/Uf7YHF4iAYIThmvOVB6O06xAa
        cp44uXh1JC9o6aMK+BKjcelHeIClv1lfE/+eHzmvbiMywsvhLmZV3jid+QC3LbkgvbUE7Y
        PNujHTAXCAlg09zf570oDVIUW7itkvE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 514df384 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 30 Mar 2022 01:31:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, stable@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/4] wireguard: socket: free skb in send6 when ipv6 is disabled
Date:   Tue, 29 Mar 2022 21:31:26 -0400
Message-Id: <20220330013127.426620-4-Jason@zx2c4.com>
In-Reply-To: <20220330013127.426620-1-Jason@zx2c4.com>
References: <20220330013127.426620-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

I got a memory leak report:

unreferenced object 0xffff8881191fc040 (size 232):
  comm "kworker/u17:0", pid 23193, jiffies 4295238848 (age 3464.870s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814c3ef4>] slab_post_alloc_hook+0x84/0x3b0
    [<ffffffff814c8977>] kmem_cache_alloc_node+0x167/0x340
    [<ffffffff832974fb>] __alloc_skb+0x1db/0x200
    [<ffffffff82612b5d>] wg_socket_send_buffer_to_peer+0x3d/0xc0
    [<ffffffff8260e94a>] wg_packet_send_handshake_initiation+0xfa/0x110
    [<ffffffff8260ec81>] wg_packet_handshake_send_worker+0x21/0x30
    [<ffffffff8119c558>] process_one_work+0x2e8/0x770
    [<ffffffff8119ca2a>] worker_thread+0x4a/0x4b0
    [<ffffffff811a88e0>] kthread+0x120/0x160
    [<ffffffff8100242f>] ret_from_fork+0x1f/0x30

In function wg_socket_send_buffer_as_reply_to_skb() or wg_socket_send_
buffer_to_peer(), the semantics of send6() is required to free skb. But
when CONFIG_IPV6 is disable, kfree_skb() is missing. This patch adds it
to fix this bug.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 6f07b949cb81..467eef0e563b 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -160,6 +160,7 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 	rcu_read_unlock_bh();
 	return ret;
 #else
+	kfree_skb(skb);
 	return -EAFNOSUPPORT;
 #endif
 }
-- 
2.35.1

