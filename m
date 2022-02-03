Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE184A8805
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbiBCPuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiBCPuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:50:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FD5C061714;
        Thu,  3 Feb 2022 07:50:50 -0800 (PST)
Date:   Thu, 3 Feb 2022 16:50:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643903449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fm7tpDjpZB6Cmj4+E2uZUNML9F/fugSAgwa3q4DCpm0=;
        b=uYvvh1fsd8zxKy9m7W4IgHphpT6P24YHY32QRArMeEeufOQPqTCG6Ngtxf0e0TLMuuLnLE
        KDV1hBpTegJBAFIgWUYw3TblXN/8REg9LpTaoNewtoD2jBxCWODiuXuwXrwbiCxF4sc57i
        Kl81mZ7IlUz91xo7C5fd6Up4/58PJYwuTs7KLfdRA0P/CRhuQxiroGjomnA/UHvos37PWK
        cllOj4ONfhiKbSHybMMK8SJ2xgACCL74RCoqgOV2bajWA/hSruSB4k0OcIYbiZ69++6UW0
        lYB+SrNgXDbSvCzPSFKkIKQkT0/uOlC2qi836bBXFpz3aZoo0UvsYPeZyndr2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643903449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fm7tpDjpZB6Cmj4+E2uZUNML9F/fugSAgwa3q4DCpm0=;
        b=bOvlC4nfRmrsKnVhS/MVYVfXXigKqV5H9GXM21HyTKsNO7v/riCOpISS+5Hvdb5wuM3J3V
        LKwmhqgihpj0VfBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/4] net: dev: Remove the preempt_disable() in
 netif_rx_internal().
Message-ID: <Yfv514UZUgmS2dl/@linutronix.de>
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-2-bigeasy@linutronix.de>
 <CANn89iJm9krQ-kjVBxFzxh0nG46O5RWDg=QyXhiq1nA3Erf9KQ@mail.gmail.com>
 <87v8xwb1o9.fsf@toke.dk>
 <YfvH9YpKTIU4EByk@linutronix.de>
 <87leysazrq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87leysazrq.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-03 13:41:13 [+0100], Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>=20
> > It would but as mentioned previously: BH is disabled and
> > smp_processor_id() is stable.
>=20
> Ah, right, because of the change in loopback to use netif_rx_ni()? But
> that bit of the analysis only comes later in your series, so at the very
> least you should be explaining this in the commit message here. Or you
> could potentially squash patches 1 and 2 and do both changes at once,
> since it's changing two bits of the same function and both need the same
> analysis...
>=20
> However, if we're going with Eric's suggestion of an internal
> __netif_rx() for loopback that *doesn't* do local_bh_disable() then this
> code would end up being called without BH disable, so we'd need the
> migrate_disable() anyway, no?

Eric suggested to the __netif_rx() for loopback which is already in
BH-disabled section. So if that is the only "allowed" caller, we
wouldn't have to worry.
If __netif_rx() becomes more users and one calls it from preemptible
context then we have a problem (like netif_rx() vs netif_rx_ni()).

migrate_disable() will shut up smp_processor_id(), yes, but we need
something to process pending softirqs. Otherwise they are delayed until
the next IRQ, spin_unlock_bh(), etc.

> -Toke

Sebastian
