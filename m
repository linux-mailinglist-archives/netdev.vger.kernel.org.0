Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44796099B3
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 07:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJXFVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 01:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJXFVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 01:21:20 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF9565271
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 22:21:18 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-367cd2807f2so76733157b3.1
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 22:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/gAfybOY3UbaMo3X0FCxvHr2ytztZWyUcTh9xOi9xEU=;
        b=hQ21BxPkmt1H8Nmam2/tzAclzxiS0ruEdg0J6+vXBspyMTBeNvU+tHLhB3RhiUVpk+
         PJenENE2QaVAiFGnE6iLSur6Fkv89871tSt4aNHmsO00O8judWfptmptBeI77DJOmxoH
         ULp+zDvqWXzT85LWfW0zXGzKDeB31xi9PU1a6CejVVBpyZIrH31lj1WH8GQfAl0x++Dl
         tBH06d//si3z00oJz69YVieNg8aQanua5ri4kUwAdZex8k+MhYc2SZZTpMzgcpVcSxFm
         XTwoTy6fMbrWsB6pb0quidvZTAVhTIp6OH5HcSik4Ly66jYSGJyxq6Bco+lDMP4EZLw2
         m5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/gAfybOY3UbaMo3X0FCxvHr2ytztZWyUcTh9xOi9xEU=;
        b=b8YdA8+24/7tN+nsR2asfwCy2LaSPnT/ZRaOouq6o7rd/O0AMuxMlcDvAioHMTji7X
         +yYxvVmp8vBh/dbjyZ6dCuwh/j5vEtr0mRtMgG+z7xPwN7H3aUV+9mhfWQogxAzN9OEg
         VzvTPbobEC8DBHhSukbr3Vl97M9BqCSqupSHQ5D1G1Ep6tCGRFMu8q2h1wb79Rg2/dT2
         9fNec+KCOwBuNS6gfhfdBbId6KnvnpYjL9IOYfKx2coq1ogrJSkk5taJPl0AyIo7/nuj
         Mnh71yyAe8d15kwvMA/Au/8yY81VN/tT9fw6Ysm9n+PBxhmW/dANO9B+bU30YXx5zobu
         lv8g==
X-Gm-Message-State: ACrzQf1IMLFsdh7kcM+akRj2ZzIc/jRAJhtFozKZ2LRUXrugxEu41JOV
        EQrv6XGYmgufMF/IPwh65KoE4erWpv/t5tDBb5qOEQ==
X-Google-Smtp-Source: AMsMyM7VT5V/to66r1kXM1NGE0qL8/INeyF6XhoraaYElRzcQ6FA2Ak10XT0CVmfUAotKRJd3cIEmehb2DKuR0wLnUY=
X-Received: by 2002:a81:1b09:0:b0:35d:cf91:aadc with SMTP id
 b9-20020a811b09000000b0035dcf91aadcmr27286274ywb.47.1666588876995; Sun, 23
 Oct 2022 22:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fd9a4005ebbeac67@google.com> <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
In-Reply-To: <Y1YeSj2vwPvRAW61@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Oct 2022 22:21:05 -0700
Message-ID: <CANn89i+41Whp=ACQo393s_wPx_MtWAZgL9DqG9aoLomN4ddwTg@mail.gmail.com>
Subject: Re: [PATCH] af_key: Fix send_acquire race with pfkey_register
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 23, 2022 at 10:10 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> With name space support, it is possible for a pfkey_register to
> occur in the middle of a send_acquire, thus changing the number
> of supported algorithms.
>
> This can be fixed by taking a mutex to make it single-threaded
> again.
>
> Reported-by: syzbot+1e9af9185d8850e2c2fa@syzkaller.appspotmail.com
> Fixes: 283bc9f35bbb ("xfrm: Namespacify xfrm state/policy locks")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index c85df5b958d2..4ceef96fef57 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3160,6 +3160,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>                 (sockaddr_size * 2) +
>                 sizeof(struct sadb_x_policy);
>
> +       mutex_lock(&pfkey_mutex);
>         if (x->id.proto == IPPROTO_AH)
>                 size += count_ah_combs(t);
>         else if (x->id.proto == IPPROTO_ESP)
> @@ -3171,8 +3172,10 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>         }
>
>         skb =  alloc_skb(size + 16, GFP_ATOMIC);

Are you sure we can sleep in mutex_lock() ?

Use of GFP_ATOMIC would suggest otherwise :/


> -       if (skb == NULL)
> +       if (skb == NULL) {
> +               mutex_unlock(&pfkey_mutex);
>                 return -ENOMEM;
> +       }
>
>         hdr = skb_put(skb, sizeof(struct sadb_msg));
>         hdr->sadb_msg_version = PF_KEY_V2;
> @@ -3228,6 +3231,7 @@ static int pfkey_send_acquire(struct xfrm_state *x, struct xfrm_tmpl *t, struct
>                 dump_ah_combs(skb, t);
>         else if (x->id.proto == IPPROTO_ESP)
>                 dump_esp_combs(skb, t);
> +       mutex_unlock(&pfkey_mutex);
>
>         /* security context */
>         if (xfrm_ctx) {
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
