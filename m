Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B47A3BF37
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390060AbfFJWJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:09:33 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36146 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389429AbfFJWJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:09:32 -0400
Received: by mail-yb1-f194.google.com with SMTP id b22so2840957yba.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OzyhibLThvxKQJLgRAaKJ1S/xooWZ72EuVRzSoCgonU=;
        b=tWynVEFVMiv3Ii/ikiHBE3Ah7BVzTA6nriq4mtuteMmI+GbbhgBnCksqrTJd24zP1P
         FMM5SomHK/Ys2bt09C9N3lA4WL99teXL2ANm84zpdRaA2Iu2lvac1Ec/5oYGxkedz5nK
         st3UVPxx9NPzrGOHvvj6hvgMWp8mY7XBN4MNQ8+gbxK7rOYbgQjMt5krziuZOqnA93oM
         4sU5gVKtBGuLTMBzdgMEcP6CPlVYV9GAnHQnmkPRWdU9W61PJrvM/iOpS4Edv/LoGl8E
         xV1C06WVOXwiN25RL1Jbo660XH6J7r84dSH8nCmEl6EJknNvJJsIaU3A+3qSwXoiZ1PA
         Vp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OzyhibLThvxKQJLgRAaKJ1S/xooWZ72EuVRzSoCgonU=;
        b=Qv6QO83q81PzRJjEinvOME3XjndJtqFqcnuXWxzSbHVBcYURCj30OkGPQ2yxqlfwjM
         3INB1zX7bXcIGweiQThxSMxwjbQ2FTQ9EB6lu0wu9hcS4/c7sLTlT+4xySzKv0vJ3wXZ
         YObZli14T2p79y54NhH8avnQSB1dYDRTIUoxYEE26dItSp0JPYg/ZwjREt2tFQQ6i+PB
         OMdCl1N2R0lZP5wwqhg6I/GHWO02bPnmFcEnBBUZAA0R7mGAUy4trvPdewRj6+MFWExJ
         MrAf34CiIPSf/OG6+8FBmzM+3VX7phBxgRdR1x/wdpScL084MB/jm3CvCPSFkvSWt/sl
         F9oQ==
X-Gm-Message-State: APjAAAWIVet7y1cgphnI6NS0l2Tqn4jV3tou1O9wNTI3hABRHLSn2sON
        sW/dbDaZjcEMIF0nU6u18tg2ISyF2qLsWJ+HC07muQ==
X-Google-Smtp-Source: APXvYqyqkUXe1wmXuhNi405lwnGacnx4Uf7NB+ovEfX7J6oVMyeNV2T/NVtLp/DYsgR+q6s07sQInqs/S1CTyJHqiB4=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr34740885ybq.518.1560204571336;
 Mon, 10 Jun 2019 15:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190610214543.92576-1-edumazet@google.com> <20190610.150450.1486548651691855934.davem@davemloft.net>
In-Reply-To: <20190610.150450.1486548651691855934.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 10 Jun 2019 15:09:20 -0700
Message-ID: <CANn89i+4Xr-0m7X_NoEnO-uBD3XR7PV8UsMVKk=xunoLH=Cf8A@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jmaxwell37@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 3:04 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 10 Jun 2019 14:45:43 -0700
>
> > Using sk_to_full_sk() should get back to the listener socket.
>
> net/ipv6/tcp_ipv6.c: In function =E2=80=98tcp_v6_send_response=E2=80=99:
> net/ipv6/tcp_ipv6.c:887:22: warning: passing argument 1 of =E2=80=98sk_to=
_full_sk=E2=80=99 discards =E2=80=98const=E2=80=99 qualifier from pointer t=
arget type [-Wdiscarded-qualifiers]

I was about to ask you to drop this patch.

Apparently the only case we can have SYN_RECV sockets here are for
fastopen, and in this case sk->sk_mark defined.

This only leaves the chance to get better sock_net_uid() reach,
and my upcoming patch adding per-tcp-socket arbitrary tx delay.
