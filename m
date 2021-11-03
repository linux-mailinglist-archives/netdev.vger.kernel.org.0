Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEB3443A69
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhKCAfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhKCAfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 20:35:51 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B90C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 17:33:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z11-20020a1c7e0b000000b0030db7b70b6bso3300201wmc.1
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 17:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m51rRqT1+VhrQMA9TVqNpib5TevmTUAGwTrG6rw1YNw=;
        b=JgqOcl1YGCiBZEc+5qh3YjcZj2vHGtJcnIEaYC8uv2JeZIRDu1pO5/cA6CoSzYtZXH
         9KrFsg8vJM8oI22Fkuho6fFRx8xu2xcEWKWj4VCkaZunbxYNyt8hAvvVni+dhO9GjgvP
         RphUe3pGzMX2ejlqvcWCxRQspGgjPI6rmAASDdULef8aaoXzGWIpNencISIks/EO/umu
         KBzxHe9NpIS811yIRxbu7H8PKihDif4Tm5ixTr8Z/Mlmah9aaBIiZDk42R/lHK/7driJ
         hFNnLJMiU7RGtBaBXhg28q3jAyOdERraZWJ5KJnzt0+hgEiqciJtYxPgZsPWCmyFWfsd
         MYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m51rRqT1+VhrQMA9TVqNpib5TevmTUAGwTrG6rw1YNw=;
        b=f3QH1unU+Gt/xvVrdBO8V7amovBDCSty6ry4JLYHodK9svru/0PUVo+OKZO8sgMRP3
         0SnNbBwN2L53cZWHW96kBiubarHuH+kEe6yKWZOErog7vQYkE861Pjj9nT8i6oBshaxl
         GfQ9qnH6dmUABJphdffA1n5DMlr41cF+boN1pDg7R598THrgZSIuA6ttqrd+t2NzAUjX
         UuX3xPE7adGy9CmFDCMJiyyUl1GphquMlP7oNi1swmxWYsAKv9+5YnKDmJtbyYn8zEe4
         2if1/W6r5wTRrckx1icuQwQOqSoUThF912BVHE4+0jsbUqDyVo/6sCOIEINh53jlwPdh
         dGGg==
X-Gm-Message-State: AOAM532ayIH76U2UHyzfrWgVlKljU7Y+A5NvQf1vlwVJ52nxYS0cn8or
        8ppLfGp0F0dHpnlZl8h8adcBf/+8gNxhaS0QiIIUIA==
X-Google-Smtp-Source: ABdhPJzOVmprMT5a9oj+J5wSOHhHdbCJwI8dtBLW33o8WKns3//961JOCl0eNGKltXDAO6MqJbR4mco+2YJzBNTaHO8=
X-Received: by 2002:a1c:4c19:: with SMTP id z25mr11261580wmf.177.1635899594520;
 Tue, 02 Nov 2021 17:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <5C1E4FAF-7A28-40F2-8E67-4B352ED5F45E@yandex-team.ru> <CAK6E8=fEmv6kQk8S=bvk6NMFUNx9bqmsiRYgJ9y8nqQU58swZw@mail.gmail.com>
In-Reply-To: <CAK6E8=fEmv6kQk8S=bvk6NMFUNx9bqmsiRYgJ9y8nqQU58swZw@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 2 Nov 2021 17:32:37 -0700
Message-ID: <CAK6E8=cZe4i0aejTc2Y57aNp=jT66p6qM-jGH32AZWRfVVCEYg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Use BPF timeout setting for SYN ACK RTO
To:     =?UTF-8?B?0JDRhdC80LDRgiDQmtCw0YDQsNC60L7RgtC+0LI=?= 
        <hmukos@yandex-team.ru>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 12:36 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Tue, Nov 2, 2021 at 12:13 PM =D0=90=D1=85=D0=BC=D0=B0=D1=82 =D0=9A=D0=
=B0=D1=80=D0=B0=D0=BA=D0=BE=D1=82=D0=BE=D0=B2 <hmukos@yandex-team.ru> wrote=
:
> >
> > > On Nov 2, 2021, at 21:57, Yuchung Cheng <ycheng@google.com> wrote:
> > >
> > >> static inline struct request_sock *inet_reqsk(const struct sock *sk)
> > >> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, =
struct sock *sk_listener,
> > >> sk_node_init(&req_to_sk(req)->sk_node);
> > >> sk_tx_queue_clear(req_to_sk(req));
> > >> req->saved_syn =3D NULL;
> > >> + req->timeout =3D 0;
> > >
> > > why not just set to TCP_TIMEOUT_INIT to avoid setting it again in
> > > inet_reqsk_alloc?
> > >
> >
> > I tried, however net/request_sock.h does not include net/tcp.h and
> > after trying to include it I got lots of errors. So I thought that
> > request_sock is not supposed to know anything about TCP. If I'm
> > wrong than what would be the best way to reference this constant?
> > Should I just redefine it in net/request_sock.h?
>
> Your explanation makes sense. it'd not be good to put TCP_TIMEOUT_INIT
> in req_sk since it's supposed to be less protocol-specific. so
> never-mind my comment.
Forget to

Acked-by: Yuchung Cheng <ycheng@google.com>
