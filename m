Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002CA4A9C29
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiBDPnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBDPnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC55C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 07:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F83C615F4
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A0C004E1;
        Fri,  4 Feb 2022 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643989399;
        bh=7GY+SB9RcTUPr3tw03/aOQLdk5r8xCOKVtLSkvhdTU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U+Uw5YxkRBfVxZtJJu1pqt70aSFhkfxk06hl2AdDD3sXJJgiYWkjVJHgu7N30t90X
         D+blNOf615m7kfVPWugoMGKETgilFe14v5p5C9Z53qsP0Klwq9Nmz4VJNx6+aQwES2
         5NJgBAEBjp1BCba3lBKpGY9A2metTTirFZtP6Z3Vo42KICelzsWzBfpuybHUeCXswD
         ZYELRM3OCjAh+8AoRc1qRDXEV7E/ortaDLkeIAeAYT1jeUbmdOETZYVv0jkxe4FZ4j
         eqUar0+8DtIuCunqd9RmCXITYQO/S/iwduEjkU1NMAYxnoujN3AZEBFQ/mugftHwwb
         xBTmJ2r7Ux2yg==
Date:   Fri, 4 Feb 2022 07:43:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
Message-ID: <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YfzhioY0Mj3M1v4S@linutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
        <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
        <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
        <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YfzhioY0Mj3M1v4S@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 09:19:22 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-03 17:09:01 [-0800], Jakub Kicinski wrote:
> > Let's be clear that the problem only exists when switching to threaded
> > IRQs on _non_ PREEMPT_RT kernel (or old kernels). We already have a
> > check in __napi_schedule_irqoff() which should handle your problem on
> > PREEMPT_RT. =20
>=20
> It does not. The problem is the missing bh-off/on around the call. The
> forced-threaded handler has this. His explicit threaded-handler does not
> and needs it.

I see, what I was getting at is on PREEMPT_RT IRQs are already threaded
so I thought the patch was only targeting non-RT, I didn't think that
explicitly threading IRQ is advantageous also on RT.

> > We should slap a lockdep warning for non-irq contexts in
> > ____napi_schedule(), I think, it was proposed by got lost. =20
>=20
> Something like this perhaps?:
>=20
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1baab07820f65..11c5f003d1591 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4217,6 +4217,9 @@ static inline void ____napi_schedule(struct softnet=
_data *sd,
>  {
>  	struct task_struct *thread;
> =20
> +	lockdep_assert_once(hardirq_count() | softirq_count());
> +	lockdep_assert_irqs_disabled();
> +
>  	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>  		/* Paired with smp_mb__before_atomic() in
>  		 * napi_enable()/dev_set_threaded().

=F0=9F=91=8D maybe with a comment above the first one saying that we want t=
o make
sure softirq will be handled somewhere down the callstack. Possibly push
it as a helper in lockdep.h called "lockdep_assert_softirq_will_run()"
so it's self-explanatory?

> Be aware that this (the first assert) will trigger in dev_cpu_dead() and
> needs a bh-off/on around. I should have something in my RT tree :)

Or we could push the asserts only into the driver-facing helpers
(__napi_schedule(), __napi_schedule_irqoff()).
