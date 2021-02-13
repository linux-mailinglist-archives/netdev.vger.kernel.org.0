Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C14B31ADF4
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhBMUbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMUbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:31:10 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A25C061574;
        Sat, 13 Feb 2021 12:30:30 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id u8so2831335ior.13;
        Sat, 13 Feb 2021 12:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JG1Vr3+XZeOCDX4ayu9Kw5Y6nxVv5uh+/era+kVHp+c=;
        b=oDkaEDlaOWmW+rSv6ahySY/RqHECLWmo1OVvDtZUgtkWeigRHCZx7UCVEC+PiTIp89
         cO63xW30qxkzt8FvnWrqUPbjFPcnhxHoUh89LWPT7Cuk/4BW6pWNJsP2OMDuD6bQA7TM
         7GPM6zlybjsrwx2GuyyMmHP7h7BsB5Em01oAHQHBWoFGW58nuxjMcGXZhgQa8x7F+lk7
         HcpNTxZCEP5S81NgEuG2jUQ805uKPZ5y1lKLmn2UnaJymx+j6RC2dQCc0CYf+F9M6af2
         rxhDYVDJfmPNVrFm9om4YJBCjCSqaLP5Ab9RCQZjky32tpyRgFSgKB7+OVSMVFX1PLur
         p/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JG1Vr3+XZeOCDX4ayu9Kw5Y6nxVv5uh+/era+kVHp+c=;
        b=A/ttuVbRiFVyfKq7QKwf22OCE0X+8xNXQjdCoD/NhWMRQTf3Br7dIbHYn8FXUfCg2M
         KU86UvBdXXT/SLleyoLh6rNUlmRUUQeppZawYKDM03CMf3VOXCLB48NyCWyK8VK5Q7e4
         zREqBRIThQgB3ocBdlKeSKi+t43/hTXuM+5ihpnUBeGq1ahnl+DrVGziprobED8p4tsQ
         CZPbu6ZMhA6VvWBZXEl6K5Pv/uo0X8R8PS9aneZMi2GEnkrca9mCPsAaBORcYlrbJHqs
         eH+4SuhtyyQcM5KIepk72wlPsp3IM6XSzluLNUd27OnqMEcEicm+tgKahGu8E/TcNlAa
         /KjA==
X-Gm-Message-State: AOAM530mdfqGlg1WYno3QToSy5kj/wX/fOvJ9AcM1C+mCMrZVB8EuPtu
        RoAmI2eSzBvrfXVFmuF4WtFgkrC7OUv0OGwXni0=
X-Google-Smtp-Source: ABdhPJwrgSMDHKEjHkb7zU0P3YYrxvImMviLp21xLcwyZZXxvQ2sAmK3XIpJhvSoFM4+hGsgCQXq8/PK4sPOHGldYoI=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr7177077iov.5.1613248229578;
 Sat, 13 Feb 2021 12:30:29 -0800 (PST)
MIME-Version: 1.0
References: <20210213141021.87840-1-alobakin@pm.me>
In-Reply-To: <20210213141021.87840-1-alobakin@pm.me>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 13 Feb 2021 12:30:18 -0800
Message-ID: <CAKgT0UfEFBOmQJvry0-+hGnoy7jP3U1ZKbP2nk7NYszVU+O==A@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 00/11] skbuff: introduce skbuff_heads bulking
 and reusing
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 6:10 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Currently, all sorts of skb allocation always do allocate
> skbuff_heads one by one via kmem_cache_alloc().
> On the other hand, we have percpu napi_alloc_cache to store
> skbuff_heads queued up for freeing and flush them by bulks.
>
> We can use this cache not only for bulk-wiping, but also to obtain
> heads for new skbs and avoid unconditional allocations, as well as
> for bulk-allocating (like XDP's cpumap code and veth driver already
> do).
>
> As this might affect latencies, cache pressure and lots of hardware
> and driver-dependent stuff, this new feature is mostly optional and
> can be issued via:
>  - a new napi_build_skb() function (as a replacement for build_skb());
>  - existing {,__}napi_alloc_skb() and napi_get_frags() functions;
>  - __alloc_skb() with passing SKB_ALLOC_NAPI in flags.
>
> iperf3 showed 35-70 Mbps bumps for both TCP and UDP while performing
> VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be bigger
> on more powerful hosts and NICs with tens of Mpps.
>
> Note on skbuff_heads from distant slabs or pfmemalloc'ed slabs:
>  - kmalloc()/kmem_cache_alloc() itself allows by default allocating
>    memory from the remote nodes to defragment their slabs. This is
>    controlled by sysctl, but according to this, skbuff_head from a
>    remote node is an OK case;
>  - The easiest way to check if the slab of skbuff_head is remote or
>    pfmemalloc'ed is:
>
>         if (!dev_page_is_reusable(virt_to_head_page(skb)))
>                 /* drop it */;
>
>    ...*but*, regarding that most slabs are built of compound pages,
>    virt_to_head_page() will hit unlikely-branch every single call.
>    This check costed at least 20 Mbps in test scenarios and seems
>    like it'd be better to _not_ do this.

<snip>

> Alexander Lobakin (11):
>   skbuff: move __alloc_skb() next to the other skb allocation functions
>   skbuff: simplify kmalloc_reserve()
>   skbuff: make __build_skb_around() return void
>   skbuff: simplify __alloc_skb() a bit
>   skbuff: use __build_skb_around() in __alloc_skb()
>   skbuff: remove __kfree_skb_flush()
>   skbuff: move NAPI cache declarations upper in the file
>   skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads
>   skbuff: allow to optionally use NAPI cache from __alloc_skb()
>   skbuff: allow to use NAPI cache from __napi_alloc_skb()
>   skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing
>
>  include/linux/skbuff.h |   4 +-
>  net/core/dev.c         |  16 +-
>  net/core/skbuff.c      | 428 +++++++++++++++++++++++------------------
>  3 files changed, 242 insertions(+), 206 deletions(-)
>

With the last few changes and testing to verify the need to drop the
cache clearing this patch set looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
