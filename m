Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888F33A2401
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhFJFc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhFJFc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 01:32:58 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B42C061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 22:31:02 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i6so24312134ybm.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 22:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lIDUVSk62aGQFCrPWNU4KjW7FrPBH0uImlaY1uF3s70=;
        b=fiCdlz7jySErXU5K0U8K2zAE3EWQLnmDD2hG+/FP6b3Taq7EFwnPRcgj23aM7wO9bf
         trPcZ9tjMXkNZ+Xo78hVVc2nheYVO8Hhw2v/vpBZbECHaC4Js5s6UkBdoEgqGaup/Cqi
         8TsUx3tO/mDeYZXX0CNnaBYCZBdUyxgmNSeF41zMzh7tRQeiI722Gvk6BRpC/C+ErlGh
         j/1YCHDX8W5p3BPSX91Ti/tXSldmYT/t6ShuUa8XQeHO9IskjhRC2h+vcQdP3fSwBWKj
         ALew5/h892GGE6wPmsg+4XBJPeA1kGyIJ7aDC3oTT8dH2+VQTIzn0SPOX14cmd3caNll
         DrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lIDUVSk62aGQFCrPWNU4KjW7FrPBH0uImlaY1uF3s70=;
        b=Ca/dSHaGRRG8eN/xXBIjc0/Mj2kVg6kdeSrMLiEF/XO04KKt2iWc39lnb66eDAe5sU
         LKhEOKKtklP7HCGlqy3Vo/FZttTq40JGRChtFHzIQDEMfn3MxwQ84DCM+i14SMagNK0j
         XfE4oN4YFoV9uvRdcIizuytv12Eo0nW73AzmiBvTQG599Cdr/2y2MQu6d7nDvU8T0h/K
         h77YW4mDT9W3/uDHptwrnpV604zVtzj9MBTvhjoDEafe+rhs5uN1qH4Fhos/wwTQOkrH
         9cdWXPGFjyBA+DUnI0dIAdjzlNq5Kxy4AumsFbAWARIH143oHLF7fEjraq4DkMgzYJo4
         tNiw==
X-Gm-Message-State: AOAM5335KzCZ/x3i2l11ipdJyeWv/JuKdNRDKIIygncpnX5LvOxMmvuW
        joEkccf81FJcRQCdMC7tzV46EbxF2Fh6finHWVgFdw==
X-Google-Smtp-Source: ABdhPJwoZU+p9lvLTCn4AhMkpQVN5yY78JFoOAC/8FFAxBEdJRTL+DhhPeF657CoAcZ3SVa7g5jjqCtX2YO8sCMWZS8=
X-Received: by 2002:a05:6902:102d:: with SMTP id x13mr5268183ybt.408.1623303061888;
 Wed, 09 Jun 2021 22:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210609103326.278782-1-toke@redhat.com> <20210609103326.278782-16-toke@redhat.com>
In-Reply-To: <20210609103326.278782-16-toke@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 10 Jun 2021 08:30:25 +0300
Message-ID: <CAC_iWjJ9qyYHKe2QZtmSTQRc4jB4PQM9pT=vmLnd6YYSGd6zBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 15/17] netsec: remove rcu_read_lock() around XDP
 program invocation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Jun 2021 at 13:33, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> The netsec driver has a rcu_read_lock()/rcu_read_unlock() pair around the
> full RX loop, covering everything up to and including xdp_do_flush(). Thi=
s
> is actually the correct behaviour, but because it all happens in a single
> NAPI poll cycle (and thus under local_bh_disable()), it is also technical=
ly
> redundant.
>
> With the addition of RCU annotations to the XDP_REDIRECT map types that
> take bh execution into account, lockdep even understands this to be safe,
> so there's really no reason to keep the rcu_read_lock() around anymore, s=
o
> let's just remove it.
>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethern=
et/socionext/netsec.c
> index dfc85cc68173..20d148c019d8 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -958,7 +958,6 @@ static int netsec_process_rx(struct netsec_priv *priv=
, int budget)
>
>         xdp_init_buff(&xdp, PAGE_SIZE, &dring->xdp_rxq);
>
> -       rcu_read_lock();
>         xdp_prog =3D READ_ONCE(priv->xdp_prog);
>         dma_dir =3D page_pool_get_dma_dir(dring->page_pool);
>
> @@ -1069,8 +1068,6 @@ static int netsec_process_rx(struct netsec_priv *pr=
iv, int budget)
>         }
>         netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
>
> -       rcu_read_unlock();
> -
>         return done;
>  }
>
> --
> 2.31.1
>

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
