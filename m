Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2505D286E65
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 08:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgJHGEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 02:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgJHGEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 02:04:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAC2C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 23:04:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q7so4611057ile.8
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 23:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1/JrwZbWD8gxzMYYn0C09QwjCEs5M+FCAqsslvVKM9U=;
        b=ukCz1suJtlvB2kOlernkr8M64mz0J825j0PLVaqJzqwcFXvpcjyTv9g4mHlD2BtsVF
         B4zsXsLJ3WfH7MT9aN/sYPl7i4h4ANJyCx8KMWrtlhtoOwGjjqAY6PsTeuGg7W7V+iic
         Vj+/F0QAjJrzSC+HVo3w8UN6JhmONPpCelJrad8xtyM8EwV/2lPrcgozYpA72UpImpU2
         JkPl0El5bmdkSNV0SF7mSTHtRguZDj1xOGC6cv8QSo0kKzqnX1RPsq5ZhAbnXZx9s+dC
         Pzrd2ID/Y4n0FNTB6ln2lHzxKfl1Pi0jl+sWnQasl/1eVmvHe3QXh8Gaub5USHmtXbOF
         rNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1/JrwZbWD8gxzMYYn0C09QwjCEs5M+FCAqsslvVKM9U=;
        b=fIMdoTw42302yGs7RT6yR+vfBPkYJ3G6rrlDB4ikIr9YLcCPs/SYCxikLycCfKkSw4
         KxQi6atR0ggBP5zhmkEftrP0Csui1Fi4cF4q+JWviYwDvodIy4Z35Y2h0Ipo/Amd2U9z
         lY0+N7iPtKAkFW/MMJi7m2QoxSkBbdfGSzvx5I/1296fW9VAFJSxkiu5VH4YXor6kQ8c
         bn8GJkAoVI9lKKJQlVpLvP6U4B3BLY5xeb5+Wenv2SdOwZC9+jMISpC5BZWkz8wHacZS
         2gkWeMMudIhHD3q/ukWDVvG/H+1nRbGc2ZdUp84ei7lpn5DybnRDMNkbCdmMA48wUpPg
         6/qQ==
X-Gm-Message-State: AOAM533tdzsKtCc+fuW/Y8CYJgllsuHPLYAMQ5W7RzUMA07I58G/GukC
        i3gEolwouKP0MAOOcSwL0pNSsqTmhILq80MHqGWTGg==
X-Google-Smtp-Source: ABdhPJxDwFYqajhmkNSV1r1r+UPxMLiiyIRChk5ZQm4NBllcIZ6+6RRU453DpoYdouz9q3rsnQS9xS0enzlKEPlj66k=
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr5865126ils.0.1602137090443;
 Wed, 07 Oct 2020 23:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201008033102.623894-1-zenczykowski@gmail.com>
In-Reply-To: <20201008033102.623894-1-zenczykowski@gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Thu, 8 Oct 2020 15:04:39 +0900
Message-ID: <CAKD1Yr3idc3zz1AT5kmqBE4A9QaOYVF-XvU9zh29gW66tjHQ3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/ipv6: always honour route mtu during forwarding
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:31 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 2a5277758379..598415743f46 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -311,19 +311,13 @@ static inline bool rt6_duplicate_nexthop(struct fib=
6_info *a, struct fib6_info *
>  static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *d=
st)
>  {
>         struct inet6_dev *idev;
> -       unsigned int mtu;
> +       unsigned int mtu =3D dst_metric_raw(dst, RTAX_MTU);
> +       if (mtu)
> +               return mtu;

What should happen here if mtu is less than idev->cnf.mtu6? Should the
code pick the minimum? If not: will picking the higher value work, or
will the packet be dropped? I suppose we already have this problem
today if the administrator configures a route with a locked MTU.
