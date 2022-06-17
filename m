Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AE54EFB6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379636AbiFQCiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 22:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiFQCiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 22:38:01 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3F0186EB
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:37:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n11so3312726iod.4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k1wLpPxyMWL3o7g4obaWOP+HYM5iXHhi755tAhmtcIE=;
        b=gzHSJMP95bIg5Tk2TEpqJhGrRSMqfqyDcxl8JBKEk4t3a2eIybL23yZX/jwCG9iNuB
         53GzohvvQ5wc69u35MCYefyzWSjWTC1iKS7b4O59+PAfu1UtFTqkS0wumBupwplqEuWw
         xeyz7vVw7qvZeMmZWZL+Snk9LtybUuL0Ob+bYhqhZjTvZSzuHWbrdLkbn9uN6uNPo26o
         k/i97sdgcYhWSRI8JXpN2AhCWHIJ/LSXwfCxpwuH9yUMriBxamEVZcmvN0F2MYOe5Rms
         OxvAfwLUurvCXsBjkKyxzIC0tmZMYLmg2/0KigEN74sDtlgMRjIik3GBk+1TxuFfv1jy
         /BzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k1wLpPxyMWL3o7g4obaWOP+HYM5iXHhi755tAhmtcIE=;
        b=13uTWEXjAqB16s/HGbcd35DJfeDmK9US5DDgM7TAnDrLNo9aeprFDZh5sXC7b3LVCt
         G03wN2fkEwcPAMlIm4M0+khhgz1AEJIGDcN+5Wi0QDxw32N8FL8m9HVOeri09MpJtWQ6
         CTuFC+78ti2eQyTloxuy75hUf6OTMx+wyGgSTdM85kzYBwcuiSvDEinz1dyK65ZxE0UX
         d96gXANl1An+UII7EOlJo2gXygtbVkED+Xsc4yjdsTY0LPwz4kCCmMHQlb3hUqWABfNm
         eI7amIcs0gEBPd7NWEBfD6vxiGXkDEGYIsUOVNegFJlfPIsS8w6Lu/gmXvpsy+hjW8OY
         P1hw==
X-Gm-Message-State: AJIora+6m4UrPjVRsDTrbM8phxQmPIUypl2xN8vQkppjjgLu3PV5XYft
        +AYmTk7ic22MSXopPz44DF7wT6u2Vx1G9PDxGttNSg==
X-Google-Smtp-Source: AGRyM1sA9zUVmICJAnLUQ3/jfYHvgvJf1y2s6ohJDOFfS7W+PRfU/c56AisEFAElLJfUERvp/SgvIDjJ2LF0ZHxpAoM=
X-Received: by 2002:a05:6638:264e:b0:333:e9ca:a674 with SMTP id
 n14-20020a056638264e00b00333e9caa674mr4593962jat.85.1655433478795; Thu, 16
 Jun 2022 19:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220617020213.1881452-1-cmllamas@google.com>
In-Reply-To: <20220617020213.1881452-1-cmllamas@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 16 Jun 2022 19:37:47 -0700
Message-ID: <CANP3RGcyqSw4vyk0UaJkrVgGgUo4qCR0Q8foP+iz+4_Oq9mA7A@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: ping: fix bind address validity check
To:     Carlos Llamas <cmllamas@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Riccardo Paolo Bestetti <pbl@bestov.io>,
        kernel-team@android.com,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 7:02 PM Carlos Llamas <cmllamas@google.com> wrote:
>
> Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> introduced a helper function to fold duplicated validity checks of bind
> addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> unintended regression in ping_check_bind_addr(), which previously would
> reject binding to multicast and broadcast addresses, but now these are
> both incorrectly allowed as reported in [1].
>
> This patch restores the original check. A simple reordering is done to
> improve readability and make it evident that multicast and broadcast
> addresses should not be allowed. Also, add an early exit for INADDR_ANY
> which replaces lost behavior added by commit 0ce779a9f501 ("net: Avoid
> unnecessary inet_addr_type() call when addr is INADDR_ANY").
>
> [1] https://lore.kernel.org/netdev/CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbx=
nOs+5zn+cpyKg@mail.gmail.com/
>
> Fixes: 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Riccardo Paolo Bestetti <pbl@bestov.io>
> Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> ---
>  net/ipv4/ping.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index 1a43ca73f94d..3c6101def7d6 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -319,12 +319,16 @@ static int ping_check_bind_addr(struct sock *sk, st=
ruct inet_sock *isk,
>                 pr_debug("ping_check_bind_addr(sk=3D%p,addr=3D%pI4,port=
=3D%d)\n",
>                          sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port=
));
>
> +               if (addr->sin_addr.s_addr =3D=3D htonl(INADDR_ANY))
> +                       return 0;
> +
>                 tb_id =3D l3mdev_fib_table_by_index(net, sk->sk_bound_dev=
_if) ? : tb_id;
>                 chk_addr_ret =3D inet_addr_type_table(net, addr->sin_addr=
.s_addr, tb_id);
>
> -               if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
> -                                                addr->sin_addr.s_addr,
> -                                                chk_addr_ret))
> +               if (chk_addr_ret =3D=3D RTN_MULTICAST ||
> +                   chk_addr_ret =3D=3D RTN_BROADCAST ||
> +                   (chk_addr_ret !=3D RTN_LOCAL &&
> +                    !inet_can_nonlocal_bind(net, isk)))
>                         return -EADDRNOTAVAIL;
>
>  #if IS_ENABLED(CONFIG_IPV6)
> --
> 2.36.1.476.g0c4daa206d-goog

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
