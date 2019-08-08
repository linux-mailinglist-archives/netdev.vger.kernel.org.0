Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D62867D8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404278AbfHHRVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:21:20 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46744 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404258AbfHHRVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:21:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id z51so4221397edz.13
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 10:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hoC6tekzvmnBWFpFgVYWi4ETgq/6NaE8lqjt5l31oE=;
        b=UghuymG3LVmw8hvEWxI8szPlFSJo/LEtj0r3o1UQAAk2owWe4vKhsYc0X4dppVAKLK
         /o9MCR1Juki/ZxdAqqW8StWTYqEux79oi3B8HW7M1moXDN/AJZH1A6S/i8hdpCRUgCX8
         0SPIuFDc/P8NP6vbhG2KTRbplA0HSVLUf0cq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hoC6tekzvmnBWFpFgVYWi4ETgq/6NaE8lqjt5l31oE=;
        b=of0lOakePN4F6KOXLw6khafU8PY7IYHKuS7PljNPIGlwjt+xD2ymNHJQ0FSgsG9enY
         n/fDg8R3TlTl4BfTax5KJ+58M/ZJS2lysus5MdWDRNxOTBdRaH4SfxadjSMNl3MkOFVB
         YZj/V5g7EEFiCutE70ch5v+OPpj2/HAMXaG5jZspo8I3JY/QcCxboLNnuhuYKEeNC6/U
         H1rS7GA9IGDbpbLEadpxgsG8mTDCL6TaeQg+8c/SLQfNBL4yGT7VZChyjrX60gQiMiM3
         yKBmMmVsbc7mlTMR76rrsAftR2/tnpxMDWbg/SF1Ro8/RUQGnS9alHoFSkw1s1uIrnja
         Jynw==
X-Gm-Message-State: APjAAAX9EgxDerVup8/eBEhPeY/sYVJBgIBLu+hqLTKTg3wRF6xhcQ4g
        lfq/soXQ1b1eOLKSp0/+E4s59+8HTAVVViNuvGgslw==
X-Google-Smtp-Source: APXvYqyY725AhpQZDFUYOGqSoqtr1qapj+5xHZavJfF3iOC5sl7977OX5m7Hk7sAlbMfz6AGR75KoEzf+TBvRjyxzxo=
X-Received: by 2002:a17:906:1916:: with SMTP id a22mr14116370eje.271.1565284878053;
 Thu, 08 Aug 2019 10:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <20190807150010.1a58a1d2@carbon> <CAC1LvL29KS9CKcXYwR4EHeNo7++i4hYQuXfY5OLtbPFDVUO2mw@mail.gmail.com>
 <20190808112955.5a29c9e1@carbon>
In-Reply-To: <20190808112955.5a29c9e1@carbon>
From:   Zvi Effron <zeffron@riotgames.com>
Date:   Thu, 8 Aug 2019 12:21:06 -0500
Message-ID: <CAC1LvL2Z7VMykO0nK3mxN=RseYGEHgjD8=hKQz0EXWWN3c1QRA@mail.gmail.com>
Subject: Re: [bpf-next PATCH 0/3] bpf: improvements to xdp_fwd sample
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Xdp <xdp-newbies@vger.kernel.org>,
        Anton Protopopov <a.s.protopopov@gmail.com>, dsahern@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 4:30 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> Another improvement from Toke, is that the bpf_redirect_map() helper,
> now also check if the redirect index is valid in the map.  If not, then
> it returns another value than XDP_REDIRECT.  You can choose the
> alternative return value yourself, via "flags" e.g. XDP_PASS.  Thus,
> you don't even need to check/validate devmap in your BPF-code, as it is
> part of the bpf_redirect_map() call now.
>
>  action = bpf_redirect_map(&map, &index, flags_as_xdp_value)
>
> The default flags used in most programs today is 0, which maps to
> XDP_ABORTED.  This is sort of a small UAPI change, but for the better.
> As today, the packet is dropped later, only diagnose/seen via
> tracepoint xdp:xdp_redirect_map_err.
>
That's great to hear, as I'd thought it already worked that way (minus
the flags to specify what the alternate action is).

Thanks for explaining!

--Zvi
