Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D153D01DA
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGTSCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhGTSCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:02:31 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A834DC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 11:43:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b14-20020a1c1b0e0000b02901fc3a62af78so2058381wmb.3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 11:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0JG7RUcBoSxlQgScK4tXTDK4hQK4CAab6KB4pPNlfE=;
        b=eISU/vW2BdVHQNC3zl/KZ2Q17ivOvcD445b7Z4xQBhPdICxxgvw6viBtTlS/5ztzm4
         98RlGQriOQbfdb8qwHyW6TkClztan43ZYN5XwBDxvhz8cEqONTbixuNbvb1bKkgCLAEC
         ZrIXhEoAXkeCV5HZgEJvSENi3+QYql6ebowAIVvIL2wvEl/EHbk8tSGwJEovPQckYYSX
         rT7h42RxIXTcXDWDyuQr7MqjXrqmBmvmFyuzNZUvJ2PXuWXSrfBW6og3Vvm4v6J0//W3
         59lPMN62lQrGavMZBXcpku+vDpCMqgJY1MPjCWB2R7hukoNtYOYvo7clYSfSVDUw1QIC
         1pIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0JG7RUcBoSxlQgScK4tXTDK4hQK4CAab6KB4pPNlfE=;
        b=iryB0A9S0C51uGtckf4GbV5hMhnL/Gg6/7EVdQhmJIQvOns/1y/hJLHnmOlD+q+MS4
         rm61+ObGEUY6KZjpY3GCjLWDAsm60TXHM2sfcj7IWBA1H+aLipoK+S/hHrgJHTtpurcj
         YzrXdmTfHOqZaYlH/7BnL+IZLqaQIsqA6+nsElJgQ1Y9gFv1MUl1Tw4hhApXs4bMjDGk
         YFZSaZDD6IfB7nd5Ph0IRhAyuy90t9e+Yz5JnmZ32FOldwA1T8QU2UGFMZSaNSJs3BUY
         YYmsBRJiECoYyymZpzXBNhMP4KXx+oGXvnr+lliZFN1HyV3hS38OxyR/dhLfllGPo9dO
         k0oA==
X-Gm-Message-State: AOAM5301f5e1nHnjAqBTSOG6c4TiwtSb7in/ok2Bzar/T5ka8F8em7X5
        Q/lGyPLAw0991/dEgeyK2scIuaNPlp0I1JDKB7092w==
X-Google-Smtp-Source: ABdhPJxHAg5kwm++HDia0tzF4oJAiNObsuLxBJyiYT+4+osWFuZA0OtPJx9zsrUqy4L/1dpTfpRYZV/uC4/8B5Dre48=
X-Received: by 2002:a7b:ce82:: with SMTP id q2mr38485181wmj.60.1626806583773;
 Tue, 20 Jul 2021 11:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210701200535.1033513-1-kafai@fb.com> <CAADnVQ+Y4YFoctqKjFMgx1OXknAttup10npCEc1d1kjrQVp40w@mail.gmail.com>
 <CAADnVQ+RYgHYO=aJwoh7C_=CeX+nwYopb+pk=Pp709Z-WwQnPw@mail.gmail.com>
In-Reply-To: <CAADnVQ+RYgHYO=aJwoh7C_=CeX+nwYopb+pk=Pp709Z-WwQnPw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Jul 2021 20:42:50 +0200
Message-ID: <CANn89iKjP6xaax7c2mr5NE-AWCkHehH3NQXWyGbt=TP95zq7yg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there.

I was indeed on vacation, but I am back, and done with my netdev presentation :)

I will take a look, thanks !

On Tue, Jul 20, 2021 at 8:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 14, 2021 at 6:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 1, 2021 at 1:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> > >
> > > With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> > > restarting the applications to pick up the new tcp-cc, this set
> > > allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> > > It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> > > bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> > > into all the fields of a tcp_sock, so there is a lot of flexibility
> > > to select the desired sk to do setsockopt(), e.g. it can test for
> > > TCP_LISTEN only and leave the established connections untouched,
> > > or check the addr/port, or check the current tcp-cc name, ...etc.
> > >
> > > Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> > >
> > > Patch 5 is to have the tcp seq_file iterate on the
> > > port+addr lhash2 instead of the port only listening_hash.
> > ...
> > >  include/linux/bpf.h                           |   8 +
> > >  include/net/inet_hashtables.h                 |   6 +
> > >  include/net/tcp.h                             |   1 -
> > >  kernel/bpf/bpf_iter.c                         |  22 +
> > >  kernel/trace/bpf_trace.c                      |   7 +-
> > >  net/core/filter.c                             |  34 ++
> > >  net/ipv4/tcp_ipv4.c                           | 410 ++++++++++++++----
> >
> > Eric,
> >
> > Could you please review this set where it touches inet bits?
> > I've looked a few times and it all looks fine to me, but I'm no expert
> > in those parts.
>
> Eric,
>
> ping!
> If you're on vacation or something I'm inclined to land the patches
> and let Martin address your review feedback in follow up patches.
>
> Thanks
