Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65813122306
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfLQEPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:15:24 -0500
Received: from mail-vs1-f51.google.com ([209.85.217.51]:42318 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfLQEPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:15:24 -0500
Received: by mail-vs1-f51.google.com with SMTP id b79so5622617vsd.9
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 20:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ED6A3UH3Pvs1NptP3CjVSIWkLopjyA3mVzCJ3WehvKI=;
        b=F01K8VZ8OEEl8QFHiq89GIWMhNn0c792hOyRZNNAYD4jkX6PwR4EXD85pxHJLFBeev
         +duPyJKaoRF2P3o8ksrL4uaq7urQF0D2oL9Jj7YAl156wCgxaU9Q+YG1KkV1y2UIPH0d
         RrY6vRMpvzKw8yTztrTDTeu4EOdaxuIq88tV8RPeqenPPaA4wNro7iryFdFl6973jDkC
         TUJIc3aKrMpZGITEH7h+/ql0KksG8pcKElNdWeuEJZ3Ov2pFkjFQpRGZ50PBXEVLUC+f
         NxRiaeOQ529z7Q4aK6MguH1RCumSVnV3t4f6wXbiEtbIiEOMhgVRoj38K+O0I+3bFcv4
         uCGQ==
X-Gm-Message-State: APjAAAXS2jTonCUHh6vaK47WPat3ScDIAaU3tjHLfYjmbabJKKM/yHNu
        Fkx0TM65Y8lKxu1q7Yfpj9tUMlyToz/V8vFJefo=
X-Google-Smtp-Source: APXvYqzHhHvG4jH9KLrGm2NZG6uNRbdF/sVnqkS92VotxRked7JiRzpGCpQBM0N0Q/UNyAaks3Kjx/8h6mzkqtkS9BQ=
X-Received: by 2002:a67:67c1:: with SMTP id b184mr1603297vsc.239.1576556123215;
 Mon, 16 Dec 2019 20:15:23 -0800 (PST)
MIME-Version: 1.0
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net> <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon> <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon> <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon>
In-Reply-To: <20191216150728.38c50822@carbon>
From:   Luigi Rizzo <rizzo@iet.unipi.it>
Date:   Mon, 16 Dec 2019 20:15:12 -0800
Message-ID: <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
Subject: Re: XDP multi-buffer design discussion
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 6:07 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
>
> See answers inlined below (please get an email client that support
> inline replies... to interact with this community)
>
> On Sun, 15 Dec 2019 13:57:12 +0000
> "Jubran, Samih" <sameehj@amazon.com> wrote:
...
> > * Why should we provide the fragments to the bpf program if the
> > program doesn't access them? If validating the length is what
> > matters, we can provide only the full length info to the user with no
> > issues.
>
> My Proposal#1 (in [base-doc]) is that XDP only get access to the
> first-buffer.  People are welcome to challenge this choice.
>
> There are a several sub-questions and challenges hidden inside this
> choice.
>
> As you hint, the total length... spawns some questions we should answer:
>
>  (1) is it relevant to the BPF program to know this, explain the use-case.
>
>  (2) if so, how does BPF prog access info (without slowdown baseline)

For some use cases, the bpf program could deduct the total length
looking at the L3 header. It won't work for XDP_TX response though.

cheers
luigi
