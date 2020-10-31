Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D32A18EB
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 18:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgJaRMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 13:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgJaRMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 13:12:17 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F444206E5;
        Sat, 31 Oct 2020 17:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604164337;
        bh=twQgN1Y1z8exlY3r71I3ZihQiCAGvG9Gae4RwmXJ/ts=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BtU7BEOuk65G9AhsBSbq29tqoeagdjbEzoTanYWmoCtuMCYigAiLgK11D5wMFmwcJ
         nGdnuDEWBvTemNLvy3iTArF4CpVp2MfmgvvkX5CtfAtpJfwrL7jbbg8oi8TU3fN+AS
         CjvtkSVxRf+kBaJf3M0H7+fviR9KvGGUqFE5Tcjg=
Date:   Sat, 31 Oct 2020 10:12:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Jon Mason <jdmason@kudzu.us>, Jouni Malinen <j@w1.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 14/15] net: dpaa: Replace in_irq() usage.
Message-ID: <20201031101215.38a13e51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027225454.3492351-15-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
        <20201027225454.3492351-15-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 23:54:53 +0100 Sebastian Andrzej Siewior wrote:
> The driver uses in_irq() + in_serving_softirq() magic to decide if NAPI
> scheduling is required or packet processing.
>=20
> The usage of in_*() in drivers is phased out and Linus clearly requested
> that code which changes behaviour depending on context should either be
> seperated or the context be conveyed in an argument passed by the caller,
> which usually knows the context.
>=20
> Use the `napi' argument passed by the callback. It is set true if
> called from the interrupt handler and NAPI should be scheduled.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Horia Geant=C4=83" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Li Yang <leoyang.li@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net=
/ethernet/freescale/dpaa/dpaa_eth.c
> index 27835310b718e..2c949acd74c67 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2300,9 +2300,9 @@ static void dpaa_tx_conf(struct net_device *net_dev,
>  }
> =20
>  static inline int dpaa_eth_napi_schedule(struct dpaa_percpu_priv *percpu=
_priv,
> -					 struct qman_portal *portal)
> +					 struct qman_portal *portal, bool napi)
>  {
> -	if (unlikely(in_irq() || !in_serving_softirq())) {
> +	if (napi) {
>  		/* Disable QMan IRQ and invoke NAPI */
>  		qman_p_irqsource_remove(portal, QM_PIRQ_DQRI);
> =20

Nit: some networking drivers have a bool napi which means "are we
running in napi context", the semantics here feel a little backwards,
at least to me. But if I'm the only one thinking this, so be it.
