Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D2F425375
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbhJGMxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:53:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:46785 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhJGMxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:53:46 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M3DBd-1mVQTK2aEf-003dgE; Thu, 07 Oct 2021 14:51:51 +0200
Received: by mail-wr1-f52.google.com with SMTP id v25so18730657wra.2;
        Thu, 07 Oct 2021 05:51:51 -0700 (PDT)
X-Gm-Message-State: AOAM531sDq++uOQUXoXGc8bWyn+Zbwp+Jvi+iUbk2curmoLadenEuEAZ
        xOYwvTldW3FdUZykS9oUifknApofcXGu92SbyeQ=
X-Google-Smtp-Source: ABdhPJwv+l/CSOosTq8f+t6BW8AyR/xkVWW8CL/ivITsueRIFGBny/+Bu+Rd/xm6OVcd3RpGweAFgtMqaVkf5mzVlu8=
X-Received: by 2002:adf:a3da:: with SMTP id m26mr5045788wrb.336.1633611111268;
 Thu, 07 Oct 2021 05:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211007123147.5780-1-rpalethorpe@suse.com>
In-Reply-To: <20211007123147.5780-1-rpalethorpe@suse.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 7 Oct 2021 14:51:34 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3ctLB=0-E18xqBQAF8LiiE345rnwG0ZKBTt1W9qKC0bg@mail.gmail.com>
Message-ID: <CAK8P3a3ctLB=0-E18xqBQAF8LiiE345rnwG0ZKBTt1W9qKC0bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] vsock: Refactor vsock_*_getsockopt to resemble sock_getsockopt
To:     Richard Palethorpe <rpalethorpe@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:D2S/l2x1wMKaseE4m/80bf4ZZ4PkKOQfgPZjO3SOvtCE2rVhB7n
 0Q2r+XZKdUXQ4z2uGFtNE6CT5lySaL+omivmJuhD+iurnZzAKvt6h5jJ5CbHRQz6RELX6EM
 iZT9yCWdDR+tQH8D5at4N+ewlQ6HOiO5swCbmlAnk4l8M+a+MVaL59DzWCo+mU0JpbAYtxp
 fRyhJ2GpDaPfJPlbyxZbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VQubckiNZmg=:nXAB3n5VDNHcOGbUjqyVIK
 xqWVfPHxB/HPq6GgWhFlSV1/ZuURL93eS10GCANrDTIab+GdCKlzOuuqo5OHDeE1RdCxCkW+H
 jbLeaWuL+jxtKsHrgD4e85HkMkmkcZadzlIOBLEJxxg3D9wV3RA8PsCfmfR//HfGITTxR1/QI
 FAjFr+vdOWAhmyBfZfqhYB9A0K4j3BYTo2Bt5zZZpDzdVi7Rz1IBqFmJwlczT4H8Icr/pE7GP
 rwcARj+ZVRm3IiYvHqdoqzmz5gpRXU+nM/H+fNIowISd3EEl3oAsCD66iGvYYszfFKrN5zBCa
 xYngTmbQljVxJfiph6draSAjrbjrvV+9678qJIFGXnwzdAUyOYEhX2Ed4FAnFetO0972weO1W
 nEz5ijSi4i6Wl6ryIjV+eyyeM269cc4gPaqZOErqvH4xImpaGZrSqGt+Tg4PnxNs/e2eP1jM1
 59hr5gi1qq0DjIBkfIm+WiSRB/1ombN8aoz2GSBTHpzuZJfhhCD+0ygLiCeSRil29fXVFHVnO
 D8lespEaZzbUSu+BRBhz6GjLJlBVFktpK02hV268PJRi7qUnW/bLI0Ex7bBm2X5rRUcDqXsj0
 G4zAnxZliOOCB3XqPBP3CVJyefaUscl6ml3uZZ4lZ68V+zq/WWBESLF1QhHb72KlVkYlp3NS8
 AYPz0sZTn1EcTn2ZzSh8XADCE9awteVxGdjfItW66kJzzXeBWI94EF9QlP+zHFHZFVAFFPsbr
 RKAp9OFFs2eFSGLVC56SPIMFdL/Id5kMa++WsA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 2:33 PM Richard Palethorpe <rpalethorpe@suse.com> wrote:
>
> In preparation for sharing the implementation of sock_get_timeout.
>
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Richard Palethorpe <rpalethorpe@richiejp.com>

Looks good to me, both as a standalone cleanup and as a preparation for patch 2.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
