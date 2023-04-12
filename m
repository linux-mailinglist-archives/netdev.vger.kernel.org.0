Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCBC6DF683
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDLNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDLNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:09:06 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0284558B
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:09:03 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e9e14a558f8ab-329577952c5so19105ab.1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681304943; x=1683896943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSKuOzO6pwUFqNBvJhzVjAAY5o2mptpHeIvx7F4mxZo=;
        b=iIcuqvQOSxN1lJfcn+w5lc8uF0VCNBeUFSdPMoiI13aDm8VRf6SelE1vPNJSbEtXSn
         NhEbQaWCZX55AfVp5/tZJeWoF1pI9fE8xapJbJsSNu0hzZq1FbqhsscDmlH9hUibFZgK
         8xHbqjodFQvQ0VBUE5zdRAj8Fk6z4kGzJGf4Zcd7INFc1aNah6axCR4GUaVE06aDzYG7
         7FnvqdWHS5QqMw2Eq2MTgmN+E+A/a4WoqA2cE2IshAHVg5l0m0i8PeDu9hUOx8xK57cM
         XwBcU3+aiVTH2sJWgJ07Z3FcFxnesDudA0bSBoHRv3sW9BF2hvvgrTYEJ7ljhcM4mZa8
         D8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681304943; x=1683896943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSKuOzO6pwUFqNBvJhzVjAAY5o2mptpHeIvx7F4mxZo=;
        b=k9V8vtj+d9V9X4Lxasn2cw49b+iYFY9ro+8gddBEuUqhMY9PNJniHQaV1CTkoH4Kso
         BVBVC6Px6hKMOjxHucSrZZjJICtY792+WtKNspdmaUUgMRLLax/ow852joQDqAMzM6A5
         dyfAlPSSEaY/MN3VGgnL4QUhO92ebWsqORao6aPlcjuCzcYk3IvoAPOF4oqgUXt0dMxj
         FREN+ZrGI1x7Nhw/dvxK9CL5gIGgnm6iVBpLWMkSSd3B6/bb3FDev8a8CS4klOtMRGpQ
         d685k1vYh2NwQ+2hXsp94TxyJVqlUvmlnZBif3rEWt2M+Ou14A9vFhndSapltVFQLzyj
         HMmw==
X-Gm-Message-State: AAQBX9d4aJxa7dHFR8DdZqDW5MHnYj3jrnytsps4J9CpsjMq0uVpxweh
        Y3ery3oHTqknLjLfKoJcDf7YkP0BBXor8gv2pV5fmzPMLOIPXbV5RwbDrQ==
X-Google-Smtp-Source: AKy350bhm1l1vyBnu/ZvrQWbtaGaWcZaj30INhq9Z7z2EWYrwdiJjtAPxi3w6fqJ+7LZAtiP9kDyaot99BWWjIP+F/I=
X-Received: by 2002:a05:6e02:184c:b0:329:3f69:539e with SMTP id
 b12-20020a056e02184c00b003293f69539emr202804ilv.2.1681304942943; Wed, 12 Apr
 2023 06:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230412130308.1202254-1-edumazet@google.com>
In-Reply-To: <20230412130308.1202254-1-edumazet@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 12 Apr 2023 15:08:51 +0200
Message-ID: <CANP3RGd8TgBeTpiMPWOGTNOfR6JoUqpgTejQhfpZCH9guS0_Gg@mail.gmail.com>
Subject: Re: [PATCH net] udp6: fix potential access to stale information
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, lena wang <lena.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Apr 12, 2023 at 3:03=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> lena wang reported an issue caused by udpv6_sendmsg()
> mangling msg->msg_name and msg->msg_namelen, which
> are later read from ____sys_sendmsg() :
>
>         /*
>          * If this is sendmmsg() and sending to current destination addre=
ss was
>          * successful, remember it.
>          */
>         if (used_address && err >=3D 0) {
>                 used_address->name_len =3D msg_sys->msg_namelen;
>                 if (msg_sys->msg_name)
>                         memcpy(&used_address->name, msg_sys->msg_name,
>                                used_address->name_len);
>         }
>
> udpv6_sendmsg() wants to pretend the remote address family
> is AF_INET in order to call udp_sendmsg().
>
> A fix would be to modify the address in-place, instead
> of using a local variable, but this could have other side effects.
>
> Instead, restore initial values before we return from udpv6_sendmsg().
>
> Fixes: c71d8ebe7a44 ("net: Fix security_socket_sendmsg() bypass problem."=
)
> Reported-by: lena wang <lena.wang@mediatek.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/ipv6/udp.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 9fb2f33ee3a76a09bbe15a9aaf1371a804f91ee2..a675acfb901d102ce56563b1d=
50ae827d9e04859 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1395,9 +1395,11 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *=
msg, size_t len)
>                         msg->msg_name =3D &sin;
>                         msg->msg_namelen =3D sizeof(sin);
>  do_udp_sendmsg:
> -                       if (ipv6_only_sock(sk))
> -                               return -ENETUNREACH;
> -                       return udp_sendmsg(sk, msg, len);
> +                       err =3D ipv6_only_sock(sk) ?
> +                               -ENETUNREACH : udp_sendmsg(sk, msg, len);
> +                       msg->msg_name =3D sin6;
> +                       msg->msg_namelen =3D addr_len;
> +                       return err;
>                 }
>         }
>
> --
> 2.40.0.577.gac1e443424-goog

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
