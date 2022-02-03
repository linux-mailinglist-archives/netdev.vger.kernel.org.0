Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109B54A87DE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiBCPko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243438AbiBCPkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:40:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D635C061714;
        Thu,  3 Feb 2022 07:40:39 -0800 (PST)
Date:   Thu, 3 Feb 2022 16:40:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643902836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=18aGWyGNO1weA/CrtPpkhyQkBZ6ZYq86BDBqYv5Eggs=;
        b=4EPsnViOAQtklcVhBnqsZE8Vfjzd2ST9SGkLLO6vvZYZZW9kwS49Nz+4ss0babhRIesSxp
        2rePC35D9ELzWY1FnppHfTmmuwKhWdzAg6fXW/onRbLU1QmckcL8TL0NQWVIfMsveUEcwJ
        NaWHZecGdkWfI1xq6CspOnGhyn2HcOZqtFqalvCCNrSQ0LIiB0Roccf71wfS9uuP2XY4cu
        C9szV7E1Wk/CMkS3MqXMpcOe41EU/reauusaHBrGabSCkO/tH+y/wXvcmswhDduktSDWZK
        2UshwvO6BrzNCfbh943Z7no8mbXDtWGWCvhspk6IMaSyU8fvFuPYI4m8C1sXlQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643902836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=18aGWyGNO1weA/CrtPpkhyQkBZ6ZYq86BDBqYv5Eggs=;
        b=Z0XbRsoSkuyAw0C5kChy+Ap5gzaCcxBhTMUC5sUfrYVhZm7wwxAsOcS1BRzLOHoua/aCcf
        pbqWzL9lb+ieX/BQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <Yfv3c+5XieVR0xAh@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de>
 <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de>
 <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 07:25:01 [-0800], Eric Dumazet wrote:
> 
> No, the loopback device (ifconfig log) I am referring to is in
> drivers/net/loopback.c
> 
> loopback_xmit() calls netif_rx() directly, while bh are already disabled.

ah okay. Makes sense.

> Instead of adding a local_bh_disable()/local_bh_enable() in netif_rx()
> I suggested
> to rename current netif_rx() to __netif_rx() and add a wrapper, eg :

So we still end up with two interfaces. Do I move a few callers like the
one you already mentioned over to the __netif_rx() interface or will it
be the one previously mentioned for now?

Would something like 

diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index fc53e0ad56d90..561cbca431ca6 100644
--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -30,7 +30,12 @@ static inline void local_bh_enable_ip(unsigned long ip)
 
 static inline void local_bh_enable(void)
 {
-	__local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+	if (unlikely(softirq_count() == SOFTIRQ_DISABLE_OFFSET)) {
+		__local_bh_enable_ip(_THIS_IP_, SOFTIRQ_DISABLE_OFFSET);
+	} else {
+		preempt_count_sub(SOFTIRQ_DISABLE_OFFSET);
+		barrier();
+	}
 }
 
 #ifdef CONFIG_PREEMPT_RT

lower the overhead to acceptable range? (I still need to sell this to
peterz first).

Sebastian
