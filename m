Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFB48E332
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiANEO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:14:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59482 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbiANEO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 23:14:57 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n8Dz4-00053B-8s; Fri, 14 Jan 2022 15:14:39 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jan 2022 15:14:38 +1100
Date:   Fri, 14 Jan 2022 15:14:38 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: crypto: BUG: spinlock recursion when doing iperf over ipsec with
 crypto hardware device
Message-ID: <YeD4rt1OVnEMBr+A@gondor.apana.org.au>
References: <Yd1SIHUNdLIvKhzz@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd1SIHUNdLIvKhzz@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 10:47:12AM +0100, Corentin Labbe wrote:
>
> [   44.646050] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
> [   44.654143] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
> [   44.662408] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
> [   44.670766] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
> [   44.679900] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)

So did sun8i_ce_cipher_run ensure that BH is disabled before
invoking xfrm_input? If not then this explains the dead-lock.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
