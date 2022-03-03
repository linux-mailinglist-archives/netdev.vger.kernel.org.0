Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CE84CC37E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiCCRQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiCCRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:16:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B37D16EA8D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:15:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6AzOvxp2CuL8zOXMMvPfKvtXsvb54t/lP6F2jVGxpQ=;
        b=tpNH4KzAF1IU9uKg/D9GNzWvi9sNM91yyHsRSbel94cNsifQN6yj/iIen4Yzek05RRHzzm
        wGobYwu1ocbtEvEZx04QomL0VjGyiISJhpl0Q5qfNWXFYB+KO0/E4MMeo0LPDftJaHs1t8
        GECspYnxeq0GUfmFe6kNtePxbgogvkN4KM9uwN0Z4uKHt+p9u/aIwWiD9l/nbVIKqk8blF
        /dHgcHnesH0w/1GYqMRxD8ddqDOGp1WQGyMRmJWoRqi80m7jvtEpKkq5XCOrqyvQdfVmYR
        NYdahsHeQMVxIfUWEYIDFAkaKaz/5oL4nXtPjEPUr/vgB8ylpT8vB7L4vwM67w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646327717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6AzOvxp2CuL8zOXMMvPfKvtXsvb54t/lP6F2jVGxpQ=;
        b=4vxAz9Els4CE+L/etP9IoK5MjKALsGCuZxYCkM86JU/6uRa3FG+Ri05zF8t4JRYz2qWOJs
        5HD5DEWF4dlPZUDA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Robin Holt <robinmholt@gmail.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Mike Travis <mike.travis@hpe.com>
Subject: [PATCH net-next 3/9] net: sgi-xp: Use netif_rx().
Date:   Thu,  3 Mar 2022 18:14:59 +0100
Message-Id: <20220303171505.1604775-4-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Mike Travis <mike.travis@hpe.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/misc/sgi-xp/xpnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index dab7b92db790a..50644f83e78ce 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -247,7 +247,7 @@ xpnet_receive(short partid, int channel, struct xpnet_m=
essage *msg)
 	xpnet_device->stats.rx_packets++;
 	xpnet_device->stats.rx_bytes +=3D skb->len + ETH_HLEN;
=20
-	netif_rx_ni(skb);
+	netif_rx(skb);
 	xpc_received(partid, channel, (void *)msg);
 }
=20
--=20
2.35.1

