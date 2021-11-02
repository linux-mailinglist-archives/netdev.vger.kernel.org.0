Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5B5443687
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 20:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhKBTjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 15:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhKBTjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 15:39:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C21C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 12:37:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d24so259239wra.0
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 12:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VwyJDD0hGZ299DO2h0age4uj0BrWdG8DYwDCoiPgxTI=;
        b=idxafPgkXFCnTsfOF40cUG1nKmYjf0TidkkNDOFeQeduEXf82nI82pVuDyGk0Bp0CQ
         /lxUpKBX0WBtBL9qU6G18xg/PHxoS2XaZ3cnlz4K07Sn3QjALWqvnY3FLtJymC/KKjlR
         /3cqpLLNPKQ01Jsx/NfhDK9bYyBvDwgt54GagTaiXdkgwiPY8c7OeJl5wUiUxAlJwvoX
         PIVaXQpTTIeGQVKXEUBSvEuylxC74K5S2CvDVWzKG2YFElCRiWIjGDuZgGtFu8OsQvY/
         pm6ATDAjKdjrpKlHqLLaOEeJutCXOqO3JHST5sJJ2OgTbklUChz4hGi1YjrnKd5rvZUZ
         G/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VwyJDD0hGZ299DO2h0age4uj0BrWdG8DYwDCoiPgxTI=;
        b=eXb3dr7pnKtXgEdfjCvbHiEqh9j4Vg5+1XdJjeyUK+QeF9oSKE+otXz3Bh7UvKwy/6
         tjRX1/f6i2+xbC+RJZQgMiJKKBHqbqFUaVGzj/dfObkzUM/hdqIUceiK3eFBl/yuD8gb
         HIqXzJ81QjGjOq6YQHbYjGI4mbPkvZ4OU+EKg6m044+Kr++QycogbT2Pu1TPIVoWDnCt
         79Re79S4KPN32OUDKZLhoWTtGcvcQqgxJrD7Ocdk44Wja3cYMhmMuZyeCRsmFjonVKrR
         fhDV/xZJGxpZr01rRxkKhkkY0z6G17fWtvQLov8vtkPpUqrByNcLhvV7hpvUe0b1KZJ3
         oYWw==
X-Gm-Message-State: AOAM533skHkrpzmqNS5xMIbc0vqyLeK5ef6tlE8ec5x4SaNZ9c/BL/+z
        bhL7JMYTM0RG4V0xUjzAUpEmTAxFqyFbesQlV5AfypbCCeA=
X-Google-Smtp-Source: ABdhPJyC1aMpr7I2z/kQd463NPVVWBk4boD28BidPFN4Xg+/gZqQAFybJ/EZwJffKsFfqskI7Z0U9sHjdYrGBgvjEhE=
X-Received: by 2002:a5d:5850:: with SMTP id i16mr24384989wrf.197.1635881823219;
 Tue, 02 Nov 2021 12:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <5C1E4FAF-7A28-40F2-8E67-4B352ED5F45E@yandex-team.ru>
In-Reply-To: <5C1E4FAF-7A28-40F2-8E67-4B352ED5F45E@yandex-team.ru>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 2 Nov 2021 12:36:25 -0700
Message-ID: <CAK6E8=fEmv6kQk8S=bvk6NMFUNx9bqmsiRYgJ9y8nqQU58swZw@mail.gmail.com>
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

On Tue, Nov 2, 2021 at 12:13 PM =D0=90=D1=85=D0=BC=D0=B0=D1=82 =D0=9A=D0=B0=
=D1=80=D0=B0=D0=BA=D0=BE=D1=82=D0=BE=D0=B2 <hmukos@yandex-team.ru> wrote:
>
> > On Nov 2, 2021, at 21:57, Yuchung Cheng <ycheng@google.com> wrote:
> >
> >> static inline struct request_sock *inet_reqsk(const struct sock *sk)
> >> @@ -104,6 +105,7 @@ reqsk_alloc(const struct request_sock_ops *ops, st=
ruct sock *sk_listener,
> >> sk_node_init(&req_to_sk(req)->sk_node);
> >> sk_tx_queue_clear(req_to_sk(req));
> >> req->saved_syn =3D NULL;
> >> + req->timeout =3D 0;
> >
> > why not just set to TCP_TIMEOUT_INIT to avoid setting it again in
> > inet_reqsk_alloc?
> >
>
> I tried, however net/request_sock.h does not include net/tcp.h and
> after trying to include it I got lots of errors. So I thought that
> request_sock is not supposed to know anything about TCP. If I'm
> wrong than what would be the best way to reference this constant?
> Should I just redefine it in net/request_sock.h?

Your explanation makes sense. it'd not be good to put TCP_TIMEOUT_INIT
in req_sk since it's supposed to be less protocol-specific. so
never-mind my comment.
