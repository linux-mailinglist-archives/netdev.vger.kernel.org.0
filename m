Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4584A94FF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 09:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiBDIT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 03:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbiBDIT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 03:19:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7295BC061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 00:19:26 -0800 (PST)
Date:   Fri, 4 Feb 2022 09:19:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643962763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EVqzfBHngLFj0WvMsDBX7PUceCV7lBGA4L5jVwG7vw=;
        b=Cxlpr/2qIhsE/fte7cb1HgHCTd2elrrQ9z/+c9sV3QsODR+qhGxM5NgvwepE2+4t2G4irY
        CrREhnCYrzent8bqZykgmQtLBaw6hreji4QaB2wsE5xV48IVPm50Lwge8ZJxKsPesFBYmh
        KSz+XULro99j2YNm9QKZ55s1d+/4aYU9GasBFga1eVvHRT5OEofwxkgqTmo4DmYPK9sMpg
        CBhlFw5JpDUQOb+z6FOpasOkCSmCVIUM5KMNN7N6pzEG8iP4TS9nJZZhdetZmE2PhW0rR9
        HqDbHP32exFiD+WhEo+LaD3k4W2BjL2mZjWDBY0FTASOAhWUhJdXjGXtdj3bSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643962763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0EVqzfBHngLFj0WvMsDBX7PUceCV7lBGA4L5jVwG7vw=;
        b=rtbuQpOJgwEmcbJ11r4HTYRHQFSOsYovnsuXf+wpmWA/+nkNQU0fKuKpn5Gzv1z/oueNKd
        9Kx2fcZWkNLEpzAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <YfzhioY0Mj3M1v4S@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
 <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 17:09:01 [-0800], Jakub Kicinski wrote:
> Let's be clear that the problem only exists when switching to threaded
> IRQs on _non_ PREEMPT_RT kernel (or old kernels). We already have a
> check in __napi_schedule_irqoff() which should handle your problem on
> PREEMPT_RT.

It does not. The problem is the missing bh-off/on around the call. The
forced-threaded handler has this. His explicit threaded-handler does not
and needs it.

> We should slap a lockdep warning for non-irq contexts in
> ____napi_schedule(), I think, it was proposed by got lost.

Something like this perhaps?:

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65..11c5f003d1591 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4217,6 +4217,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 {
 	struct task_struct *thread;
 
+	lockdep_assert_once(hardirq_count() | softirq_count());
+	lockdep_assert_irqs_disabled();
+
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		/* Paired with smp_mb__before_atomic() in
 		 * napi_enable()/dev_set_threaded().

Be aware that this (the first assert) will trigger in dev_cpu_dead() and
needs a bh-off/on around. I should have something in my RT tree :)

Sebastian
