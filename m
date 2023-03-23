Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EDB6C5D38
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCWD2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCWD2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:28:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02FB9747
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C7AB811AB
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417ACC433EF;
        Thu, 23 Mar 2023 03:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679542076;
        bh=kE8dpu6QSEPFy6ETzW5VBAbBgYaAaIotKQYYrnBq6VM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pn1J34J669wyYfMbAlifakdFlyWw1C0X1Zq6b2U4yBsqIU+A5OEram85AbtRLx7iR
         H55uILKtx9DeRz6R/JvjKvA0XNEFFIyeM9czayPl2KpwXAXp7sWbliqw3B0cZ2fR/s
         OYuQjqHc7CBXtUXfKkaY8i9b5xauqmXh01nGpu9jnV2wpApja892f3N5pyHmyHefhh
         WavedHPEOzcV9lMbXUHE1M2FauL8CqfgNNMDycIaA/NGXzRni8j5JHLq7qEfJ2cArn
         cK3Z3LzwbPTJ1PvKw4s29T7WUxeqSJd7IdWxhS3QI9ghZYDLKmdXrPA+hAuOAzotio
         ZuOXQzez3e+CA==
Date:   Wed, 22 Mar 2023 20:27:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <willemb@google.com>,
        <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230322202755.18e0f105@kernel.org>
In-Reply-To: <e66b0ae0-8c26-927f-2342-a7a4383068a3@huawei.com>
References: <20230322233028.269410-1-kuba@kernel.org>
        <e66b0ae0-8c26-927f-2342-a7a4383068a3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 11:05:36 +0800 Yunsheng Lin wrote:
> > +/* Lockless queue stopping / waking helpers.
> > + *
> > + * These macros are designed to safely implement stopping and waking
> > + * netdev queues without full lock protection. We assume that there can
> > + * be no concurrent stop attempts and no concurrent wake attempts.
> > + * The try-stop should happen from the xmit handler*, while wake up =20
>=20
> unnecessary '*' after handler?
>=20
> > + * should be triggered from NAPI poll context. The two may run
> > + * concurrently (single producer, single consumer).
> > + *
> > + * All descriptor ring indexes (and other relevant shared state) must
> > + * be updated before invoking the macros.
> > + *
> > + * * the try-stop side does not reschedule Tx (netif_tx_start_queue() =
=20
>=20
> double '*' here?

It's a footnote..

> > + *   instead of netif_tx_wake_queue()) so uses outside of the xmit
> > + *   handler may lead to bugs
> > + */
> > +
> > +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> > +	({								\
> > +		int _res;						\
> > +									\
> > +		netif_tx_stop_queue(txq);				\
> > +									\
> > +		smp_mb();						\
> > +									\
> > +		/* We need to check again in a case another		\
> > +		 * CPU has just made room available.			\
> > +		 */							\
> > +		if (likely(get_desc < start_thrs)) {			\
> > +			_res =3D 0;					\
> > +		} else {						\
> > +			netif_tx_start_queue(txq);			\
> > +			_res =3D -1;					\
> > +		}							\
> > +		_res;							\
> > +	})								\
> > +
> > +/**
> > + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
> > + * @txq:	struct netdev_queue to stop/start
> > + * @get_desc:	get current number of free descriptors (see requirements=
 below!)
> > + * @stop_thrs:	minimal number of available descriptors for queue to be=
 left
> > + *		enabled
> > + * @start_thrs:	minimal number of descriptors to re-enable the queue, =
can be
> > + *		equal to @stop_thrs or higher to avoid frequent waking
> > + *
> > + * All arguments may be evaluated multiple times, beware of side effec=
ts.
> > + * @get_desc must be a formula or a function call, it must always
> > + * return up-to-date information when evaluated!
> > + * Expected to be used from ndo_start_xmit, see the comment on top of =
the file. =20
>=20
> For now=EF=BC=8Cthere seems to be three ways of calling *_maybe_stop():
> 1. called before transimting a skb.
> 2. called after transimting a skb.
> 3. called both before and after transimting a skb.
>=20
> Which one should new driver follow?
> Do we need to make it clear here?

After, the check before is more of a sanity check.
AFAIR netdevice.rst or some other place documents the stopping
expectations.
