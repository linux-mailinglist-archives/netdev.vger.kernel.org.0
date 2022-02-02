Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9184A70CA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344153AbiBBM3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344144AbiBBM25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:28:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2571C061714;
        Wed,  2 Feb 2022 04:28:56 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YC6m1HGsplsRfYYc3H2HMTpJd7knNBRVUNFvn5d4q1Q=;
        b=d6Cnvsc1SZIXrfawvWSn/LDVcRzILIAVDf3hJo/bOYiZK3y/5vMMjX5RGbg5XxhcSLVPUa
        tT6ch7oOOV1axeQAifPn1lQ/lQvBZNpUj5D8fBEKWiyzoOrtBIHJaOikyZikRT3zVrO7Ow
        QlQ2l1e+p7/iH3t6RiqG/HGawbZglQ2tBrHRfmGluytC45fWMifl7DYVYdX23HccRo4Avb
        C0LA8qAIJejbZAhudpDDkdLRk6ZS+ELR3HDGB9ICV+0VPn+dwhjwhyTHOUcl7ag3oSs/1F
        JqmFTsGY5+ijalLE9iyzfO2DA8wsUmGuU72t0lk6nWcZxYN8+FW0vu0c+bxn3g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643804934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YC6m1HGsplsRfYYc3H2HMTpJd7knNBRVUNFvn5d4q1Q=;
        b=Y0OSf43DP6OUKNTiwanuLoGQYwOjmvLzb5qz1h1iN+hv+UJDWJ2Yc5yotqXhsMRzCbhLJp
        d13VvtSWGLTPI3Bw==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/4] net: dev: Remove get_cpu() in netif_rx_internal().
Date:   Wed,  2 Feb 2022 13:28:46 +0100
Message-Id: <20220202122848.647635-3-bigeasy@linutronix.de>
In-Reply-To: <20220202122848.647635-1-bigeasy@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The get_cpu() usage was added in commit
    b0e28f1effd1d ("net: netif_rx() must disable preemption")

because ip_dev_loopback_xmit() invoked netif_rx() with enabled preemtion
causing a warning in smp_processor_id(). The function netif_rx() should
only be invoked from an interrupt context which implies disabled
preemption. The commit
   e30b38c298b55 ("ip: Fix ip_dev_loopback_xmit()")

was addressing this and replaced netif_rx() with in netif_rx_ni() in
ip_dev_loopback_xmit().

Based on the discussion on the list, the former patch (b0e28f1effd1d)
should not have been applied only the latter (e30b38c298b55).

Remove get_cpu() since the function is supossed to be invoked from
context with stable per-CPU pointers (either by disabling preemption or
software interrupts).

Link: https://lkml.kernel.org/r/20100415.013347.98375530.davem@davemloft.net
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 325b70074f4ae..0d13340ed4054 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4810,8 +4810,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 	{
 		unsigned int qtail;
=20
-		ret =3D enqueue_to_backlog(skb, get_cpu(), &qtail);
-		put_cpu();
+		ret =3D enqueue_to_backlog(skb, smp_processor_id(), &qtail);
 	}
 	return ret;
 }
--=20
2.34.1

