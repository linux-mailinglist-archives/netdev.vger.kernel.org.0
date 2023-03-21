Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB83D6C262C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 01:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCUAC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 20:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCUAC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 20:02:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06352E815;
        Mon, 20 Mar 2023 17:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C8FFB810A6;
        Tue, 21 Mar 2023 00:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA57C4339B;
        Tue, 21 Mar 2023 00:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679356943;
        bh=VTTL1SGQRHR4W3FcEM1a2BDY6fXH3kN8C7dJcNttyao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wf2/AZnQvN8q16tcSJ0Wx3v9zxL98C65iTOBlFF0DxhC1bXKvogcnGonCnia86I/o
         4rBDt7Lhp6G5HxLQd8gE9RYhw9idzQM9WF3Zb0KRUocp7XQ68/cijw87BNyv5tM5x3
         50roNDQVYTziOSMYvi3jWYnUdWjhFj/C0svP7t2LUO4wkb8AHM1rMwWW92a96yI5I6
         SHG6F+ntTuFkGZAVCnGYPbKmYeZjMZYY7Ot1JtXNigEsRONUKfYVmRYntwLAyLMhHT
         CZ53MxzD80ff8WhRKpti0kkAiZSz1PimbHy+4MZSWu7QmCYLSDIO0e/OUwT5Yxa/R/
         d3YWmzKGzGx3g==
Date:   Mon, 20 Mar 2023 17:02:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: document NAPI
Message-ID: <20230320170221.27896adb@kernel.org>
In-Reply-To: <8da9b24b-966a-0334-d322-269b103f7550@gmail.com>
References: <20230315223044.471002-1-kuba@kernel.org>
        <8da9b24b-966a-0334-d322-269b103f7550@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 16:16:39 -0700 Florian Fainelli wrote:
> Did it not stand for New API?

I think it did. But we had extra 20 years of software development
experience and now agree that naming things "new" or "next" is
a bad idea? So let's pretend it stands for nothing. Or NAPI API ;)

> > +NAPI processing usually happens in the software interrupt context,
> > +but user may choose to use separate kernel threads for NAPI processing=
. =20
>=20
> (called threaded NAPI)

I added a cross link:

but user may choose to use :ref:`separate kernel threads<threaded>`

(and same for the busy poll sentence).

> > +Control API
> > +-----------
> > +
> > +netif_napi_add() and netif_napi_del() add/remove a NAPI instance
> > +from the system. The instances are attached to the netdevice passed
> > +as argument (and will be deleted automatically when netdevice is
> > +unregistered). Instances are added in a disabled state.
> > +
> > +napi_enable() and napi_disable() manage the disabled state.
> > +A disabled NAPI can't be scheduled and its poll method is guaranteed
> > +to not be invoked. napi_disable() waits for ownership of the NAPI
> > +instance to be released. =20
>=20
> Might add a word that calling napi_disable() twice will deadlock? This=20
> seems to be a frequent trap driver authors fall into.

Good point. I'll say that the APIs are not idempotent:

The control APIs are not idempotent. Control API calls are safe against
concurrent use of datapath APIs but incorrect sequence of control API
calls may result in crashes, deadlocks, or race conditions. For example
calling napi_disable() multiple times in a row will deadlock.

> > +Datapath API
> > +------------
> > +
> > +napi_schedule() is the basic method of scheduling a NAPI poll.
> > +Drivers should call this function in their interrupt handler
> > +(see :ref:`drv_sched` for more info). Successful call to napi_schedule=
()
> > +will take ownership of the NAPI instance.
> > +
> > +Some time after NAPI is scheduled driver's poll method will be
> > +called to process the events/packets. The method takes a ``budget``
> > +argument - drivers can process completions for any number of Tx
> > +packets but should only process up to ``budget`` number of
> > +Rx packets. Rx processing is usually much more expensive. =20
>=20
> In other words, it is recommended to ignore the budget argument when=20
> performing TX buffer reclamation to ensure that the reclamation is not=20
> arbitrarily bounded, however it is required to honor the budget argument=
=20
> for RX processing.

Added verbatim.

> > +.. warning::
> > +
> > +   ``budget`` may be 0 if core tries to only process Tx completions
> > +   and no Rx packets.
> > +
> > +The poll method returns amount of work performed. =20
>=20
> returns the amount of work.

Hm. Reads to me like we need an attributive(?) in this sentence.
"amount of work done" maybe? No?

> > +has outstanding work to do (e.g. ``budget`` was exhausted)
> > +the poll method should return exactly ``budget``. In that case
> > +the NAPI instance will be serviced/polled again (without the
> > +need to be scheduled).
> > +
> > +If event processing has been completed (all outstanding packets
> > +processed) the poll method should call napi_complete_done()
> > +before returning. napi_complete_done() releases the ownership
> > +of the instance.
> > +
> > +.. warning::
> > +
> > +   The case of finishing all events and using exactly ``budget``
> > +   must be handled carefully. There is no way to report this
> > +   (rare) condition to the stack, so the driver must either
> > +   not call napi_complete_done() and wait to be called again,
> > +   or return ``budget - 1``.
> > +
> > +   If ``budget`` is 0 napi_complete_done() should never be called. =20
>=20
> Can we detail when budget may be 0?

I was trying to avoid enshrining implementation details.
budget =3D=3D 0 -> don't process Rx, don't ask why.
In practice AFAIK it's only done by netpoll. I don't think AF_XDP=20
does it.

> > +Call sequence
> > +-------------
> > +
> > +Drivers should not make assumptions about the exact sequencing
> > +of calls. The poll method may be called without driver scheduling
> > +the instance (unless the instance is disabled). Similarly if

s/if//

> > +it's not guaranteed that the poll method will be called, even
> > +if napi_schedule() succeeded (e.g. if the instance gets disabled). =20
>=20
> You lost me there, it seems to me that what you mean to say is that:
>=20
> - drivers should ensure that past the point where they call=20
> netif_napi_add(), any software context referenced by the NAPI poll=20
> function should be fully set-up
>=20
> - it is not guaranteed that the NAPI poll function will not be called=20
> once netif_napi_disable() returns

That is guaranteed. What's not guaranteed is 1:1 relationship between
napi_schedule() and napi->poll(). For busy polling we'll see
napi->poll() without there ever being an interrupt. And inverse may
also be true, where napi_schedule() is done but the polling never
happens.

I'm trying to make sure nobody tries to split the logic between the IRQ
handler and napi->poll(), expecting 1:1.

> > +NAPI instances most often correspond 1:1:1 to interrupts and queue pai=
rs
> > +(queue pair is a set of a single Rx and single Tx queue). =20
>=20
> correspond to.

1:1:1 is meant as an attributive(?), describing the relationship
as 3-way 1:1.

> > As is the case with any busy polling it trades
> > +off CPU cycles for lower latency (in fact production uses of NAPI busy
> > +polling are not well known). =20
>=20
> Did not this originate via Intel at the request of financial companies=20
> doing high speed trading? Have they moved entirely away from busy=20
> polling nowadays?

No idea. If someone knows of prod use please speak up? =F0=9F=A4=B7=EF=B8=8F
I feel like the theoretical excitement about this feature does=20
not match its impact :S

> > The configuration is per netdevice and will affect all
> > +NAPI instances of that device. Each NAPI instance will spawn a separate
> > +thread (called ``napi/${ifc-name}-${napi-id}``).
> > +
> > +It is recommended to pin each kernel thread to a single CPU, the same
> > +CPU as services the interrupt. Note that the mapping between IRQs and
> > +NAPI instances may not be trivial (and is driver dependent).
> > +The NAPI instance IDs will be assigned in the opposite order
> > +than the process IDs of the kernel threads. =20
>=20
> Device drivers may opt for threaded NAPI behavior by default by calling=20
> dev_set_threaded(.., true)

Let's not advertise it too widely... We'd need to describe under what
conditions it's okay to opt-in by default.

Fixed all the points which I'm not quoting. Thanks!!
