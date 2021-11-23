Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D52745AF73
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhKWWzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhKWWzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:55:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC9C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:52:41 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so450102wme.4
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RseFuatNLsYAngYBWgoaYXSq9+zE3N9xCO/4DZMgQdk=;
        b=BrzRalCv84u0cpdtXrzrEb2xR6FaGW8fsljQtyy4Jc4wAr9oMmvlXUffbbUsZSYAi4
         289YEonHoO1UbTNvRhO1friix8KUZOOztIINkg0SVUC6VJhSxJdcNeT7NO8HDsBVcD+f
         gldiNDfGiRdFi37Gf1exDd1VgNTYmE/56TXpEGyl/tLzWkb1SDbN2+SAXlhNL5AItQlk
         2Z2jRnhM2oIqz3axirwdTbOeFeU3qBNAPK+gqrYR4Zgxkz+1RSERh+u4fhmkLgpa21Ya
         xRdoXxYlffbEc1DJBWxwDKGQfN3lmjhgVBhPxmDpKhZbIKHXU+pF4BOVjNrZeIosoKnA
         5UKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RseFuatNLsYAngYBWgoaYXSq9+zE3N9xCO/4DZMgQdk=;
        b=2+ck4jCU26s0o/jCaCtlLL0hOookNMXCJyO2A9q7X+Srti7ShP71sOu2LaMZtWSInO
         dP/+QE8c16apr99e58AwyxxYy0TZyCAMfIup8Vbb8jxMnw+7WZYlV3ipfw0+LAucCfBC
         u2ySoRAtFkD+J/damzkxiroiNiX19MPBtz4N6EhLCvlOXYd5OgTaGqbri3LTOX3D3N05
         yh3OByGePjmMhbKi6y0VL+3NSW/wzUXD8H8skrILhp4n7sxfYwuN6zKaVyA+lD8Zdtbb
         5q/wTztObJmpBI9593Wmeq5zCkZYuYYDm6pvpQqH96Oc7V9Olw+wbA56lgZ0KNeAVh2H
         Zf5Q==
X-Gm-Message-State: AOAM532BbRTqduKsM3uYmWEm+3eICHe5K55dFicrYl2aiGG1INqEuVIz
        aqVBH5mQeUn6lI4q+qiqMICMcRJldGhAg6ND+NZskQ==
X-Google-Smtp-Source: ABdhPJwKHu1H9PWb0UkJBuD/FJygI1e8P+gMzWomtVW9j18nzxRUcj7cYmJ/Pqsbjennfq0zW62+WxHC5IBKNsrMfWU=
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr8308959wmk.92.1637707960064;
 Tue, 23 Nov 2021 14:52:40 -0800 (PST)
MIME-Version: 1.0
References: <20211123223154.1117794-1-zenczykowski@gmail.com>
In-Reply-To: <20211123223154.1117794-1-zenczykowski@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 23 Nov 2021 14:52:27 -0800
Message-ID: <CANn89iLc3pE49M+m5mk77kmdgGxSAjy_s-Lc8mqSt+ZdCmPJ0Q@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: do not allow IPV6_TCLASS to muck with tcp's ECN
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 2:32 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This is to match ipv4 behaviour, see __ip_sock_set_tos()
> implementation at ipv4/ip_sockglue.c:579
>
> void __ip_sock_set_tos(struct sock *sk, int val)
> {
>   if (sk->sk_type =3D=3D SOCK_STREAM) {
>     val &=3D ~INET_ECN_MASK;
>     val |=3D inet_sk(sk)->tos & INET_ECN_MASK;
>   }
>   if (inet_sk(sk)->tos !=3D val) {
>     inet_sk(sk)->tos =3D val;
>     sk->sk_priority =3D rt_tos2priority(val);
>     sk_dst_reset(sk);
>   }
> }
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
>

This makes sense, thanks, even if INET_ECN_dontxmit() would eventually
catch up for non dctcp.

Reviewed-by: Eric Dumazet <edumazet@google.com>
