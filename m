Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF542F29EC
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404695AbhALIVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbhALIVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:21:31 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809B3C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:20:51 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r9so2262332ioo.7
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXtA70cbeE8Sr5F2LDfs+ZsAfbVNXbbgaW18k1+9xN0=;
        b=WTPOeDdNxXmvx5nAT5V4iW5OoTZjcbBtBjLX0zQXdVWSh6JWXDpAn3ZFIQ/Um97HUu
         3Qcni2KbkepY2XXmfsxOocfoRmEve86qdgT6+6wFvvqLHn9i3kY1DUGGYp9ZZ0NEPwsG
         vHH5dUf15AvAdBBybf4WM9EXdX1eIEweztNfCZ4CBs14yWwlyk9NezxPlT8DuOLoBwfC
         zx0fpK+4bW0Rqaali9wO2p/zHkqYn79cJ3zGfR6t7exzb7adYYPfxFgk5N2f2oHXO52u
         JmQWaHLp6zdXXyO0USneiT5saXxxy8DTDodmZshag8h4H1Z0ZbMkxALBh2EQW+nWBpx8
         A0MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXtA70cbeE8Sr5F2LDfs+ZsAfbVNXbbgaW18k1+9xN0=;
        b=cUMOBiGJruia0Y0a8H7VWXNuz+9M7/0Lj4LJt48CbnmhoEu9OvOspD4m2eU4g3Rpfb
         MhtrZKuaHX5B3T/X7JBsxIUTe87JVF0WVFitCbEBqKMCmbUB5eEniXXWfJC329vWxf0T
         AWKP95v3SKb4/pEmPFCuVDj3kL30CcvsrFyTDDKxi0VaXO2LQtwWbv0X6f3HbizKqcMx
         1u59B+sTitLfpse23RBE27HlQTVgclBGnaxjtk8LpWWb3A27aXe3oFrpYrv+T/El3hrF
         ZZcvZ6DhJjeFiwXJNVwBa4oS0p3rag1YSLFBdW/VcBu6QMBlI/KpS6a53x8JgIyeP8VQ
         duFA==
X-Gm-Message-State: AOAM531z+1G1gOpY5xb6HyAS0J8T6bm7pMGjgHIgsdWnO+D7CpZoO1Pz
        dTninQaGqKdv0OkPWgnVe3pg2ChR4tM+kKpKRQDK2w==
X-Google-Smtp-Source: ABdhPJxS9lPXfuX3soDEhIeaxvPtBYQ34WqO7VVDRsTM5pNHys9n7c38EhmcN5hHeaUOzuVg+yWe+rr1E8pds1PhqQU=
X-Received: by 2002:a92:da82:: with SMTP id u2mr2894870iln.137.1610439650674;
 Tue, 12 Jan 2021 00:20:50 -0800 (PST)
MIME-Version: 1.0
References: <20210111182655.12159-1-alobakin@pm.me>
In-Reply-To: <20210111182655.12159-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 09:20:39 +0100
Message-ID: <CANn89iKceTG_Mm4RrF+WVg-EEoFBD48gwpWX=GQiNdNnj2R8+A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 7:27 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Inspired by cpu_map_kthread_run() and _kfree_skb_defer() logics.
>
> Currently, all sorts of skb allocation always do allocate
> skbuff_heads one by one via kmem_cache_alloc().
> On the other hand, we have percpu napi_alloc_cache to store
> skbuff_heads queued up for freeing and flush them by bulks.
>
> We can use this struct to cache and bulk not only freeing, but also
> allocation of new skbuff_heads, as well as to reuse cached-to-free
> heads instead of allocating the new ones.
> As accessing napi_alloc_cache implies NAPI softirq context, do this
> only for __napi_alloc_skb() and its derivatives (napi_alloc_skb()
> and napi_get_frags()). The rough amount of their call sites are 69,
> which is quite a number.
>
> iperf3 showed a nice bump from 910 to 935 Mbits while performing
> UDP VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be
> way bigger on more powerful hosts and NICs with tens of Mpps.

What is the latency cost of these bulk allocations, and for TCP traffic
on which GRO is the norm ?

Adding caches is increasing cache foot print when the cache is populated.

I wonder if your iperf3 numbers are simply wrong because of lack of
GRO in this UDP VLAN NAT case.

We are adding a log of additional code, thus icache pressure, that
iperf3 tests can not really measure.

Most linus devices simply handle one packet at a time (one packet per interrupt)
