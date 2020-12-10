Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C271A2D5BE6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389398AbgLJNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389202AbgLJNfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:35:17 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18570C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 05:34:37 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i18so5538794ioa.1
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 05:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qPuTAGucGvzqgTNxrF9n0FwDltwm7MyZmFGY3E7gY0c=;
        b=Fy2fTjlapPQntE22uOCG4RkJdS2M0O+HLQrPnV5OA+VTyjnZ1BKHr499fnc6izXei3
         3lamsmClYUTCcAmHUJ6m5HJzoye5tuC6BbWKl9KDguLjQMJxrWzwO8HbJ/alrv54XhSJ
         0nzxEq+L3cb78MEmgkpELf9LOXvtXyZBWcNXF/AyziecC1eQk02VTm66maoCBq86xSLC
         kpHtLkTpdiRigmF/T47aMatmTUa8nfrpt0WhFMI9C6nr+XU2DXuPdQEKM10/1qwVeeyZ
         gLdOeMcVY41n45DCL6ltzd9HXh+t2m9tH6G6G76va9G+9XbUk1OGrJYrwncaZJ1rwWT5
         9X+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qPuTAGucGvzqgTNxrF9n0FwDltwm7MyZmFGY3E7gY0c=;
        b=ILw49kKf9biSZ5C5t2k+7FS7q5cc0Bbbhjs6CqjOznBueRLmfklIESgyUsSxFLpF2n
         ivBvY+2/yPNqeA5TeyPUJNO9wW38RgMwGcLPsrGOaopqdFZuil6VN3DQiTuUZArtSD9v
         1bL9Ms7u9Pdu9xOz/TIeJjyDvqPWsBWWfgfgRLURarvoWhhQD02o1zOv7kVXJp5bm1Kc
         gNp2JfXrNa1wMqWMyd+Ae/OsPtavgKdyWHCaSloKv0dwEvr92m9mWONhmHJOCYfmKg/P
         VthoVNG8YS1XO57TfOCVyq9tIQ1V/RNPcDS90mYJsEkGM+y4Gh26w1e4gmqYT5ytPs/e
         vz3A==
X-Gm-Message-State: AOAM531RG2dxvcFTeCa+bbTozcKPebfWigb8u5AG+szHdqr5Ry6EApyb
        QctMzU4AKVdGFoHfd1ZbBWyBg5zFXUDuHeQJCL26Ow==
X-Google-Smtp-Source: ABdhPJxz6pdUHkkmaYdXhsoY3XmJLTCmoO0CuKMORf3YDkLG822+IhHiT9WlxlybIsF/ZmZzQtRGRP0HulpfcGsoT3o=
X-Received: by 2002:a02:c981:: with SMTP id b1mr8885225jap.6.1607607276223;
 Thu, 10 Dec 2020 05:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20201208162131.313635-1-eric.dumazet@gmail.com>
 <20201208.162852.2205708169665484487.davem@davemloft.net> <A65467F2-CC10-4FAF-A728-0969FD17E780@amazon.com>
In-Reply-To: <A65467F2-CC10-4FAF-A728-0969FD17E780@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Dec 2020 14:34:23 +0100
Message-ID: <CANn89iL1pCZY3PdrQbjMHvyCFj3CpKPK=G0W0AauKWG4Y_FW1w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: select sane initial rcvq_space.space for big MSS
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "soheil@google.com" <soheil@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "ycheng@google.com" <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 1:49 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
> Hi Eric,
>
> I don't see the patch in the stable queue. Can we add it  to stable so we=
 can cherry pick it  in Amazon Linux kernel?
>

No need for stable tags , as documented in
https://elixir.bootlin.com/linux/v5.9/source/Documentation/networking/netde=
v-FAQ.rst#L147


> Thank you.
>
> Hazem
>
> =EF=BB=BFOn 09/12/2020, 00:29, "David Miller" <davem@davemloft.net> wrote=
:
>
>     CAUTION: This email originated from outside of the organization. Do n=
ot click links or open attachments unless you can confirm the sender and kn=
ow the content is safe.
>
>
>
>     From: Eric Dumazet <eric.dumazet@gmail.com>
>     Date: Tue,  8 Dec 2020 08:21:31 -0800
>
>     > From: Eric Dumazet <edumazet@google.com>
>     >
>     > Before commit a337531b942b ("tcp: up initial rmem to 128KB and SYN =
rwin to around 64KB")
>     > small tcp_rmem[1] values were overridden by tcp_fixup_rcvbuf() to a=
ccommodate various MSS.
>     >
>     > This is no longer the case, and Hazem Mohamed Abuelfotoh reported
>     > that DRS would not work for MTU 9000 endpoints receiving regular (1=
500 bytes) frames.
>     >
>     > Root cause is that tcp_init_buffer_space() uses tp->rcv_wnd for upp=
er limit
>     > of rcvq_space.space computation, while it can select later a smalle=
r
>     > value for tp->rcv_ssthresh and tp->window_clamp.
>     >
>     > ss -temoi on receiver would show :
>     >
>     > skmem:(r0,rb131072,t0,tb46080,f0,w0,o0,bl0,d0) rcv_space:62496 rcv_=
ssthresh:56596
>     >
>     > This means that TCP can not increase its window in tcp_grow_window(=
),
>     > and that DRS can never kick.
>     >
>     > Fix this by making sure that rcvq_space.space is not bigger than nu=
mber of bytes
>     > that can be held in TCP receive queue.
>     >
>     > People unable/unwilling to change their kernel can work around this=
 issue by
>     > selecting a bigger tcp_rmem[1] value as in :
>     >
>     > echo "4096 196608 6291456" >/proc/sys/net/ipv4/tcp_rmem
>     >
>     > Based on an initial report and patch from Hazem Mohamed Abuelfotoh
>     >  https://lore.kernel.org/netdev/20201204180622.14285-1-abuehaze@ama=
zon.com/
>     >
>     > Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to=
 around 64KB")
>     > Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner"=
)
>     > Reported-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
>     > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
>     Applied, thanks Eric.
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembou=
rg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlin=
gton Road, Dublin 4, Ireland, branch registration number 908705
>
>
