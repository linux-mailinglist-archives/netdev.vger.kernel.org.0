Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E522F2D92
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390891AbhALLJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:09:27 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:30871 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbhALLJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 06:09:25 -0500
Date:   Tue, 12 Jan 2021 11:08:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610449723; bh=9Pj0YAwWv/zYIG9LK/XF1RnE+W2Pai5Bl/8RQ1TEw0g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=YVqimRxGmPdGr1qE4VwCnwpP3KC1lGN44f6RR5Rm2gF5aYeTlgz6C25GwT2Nt6+Gz
         tBvSsfkIdiXvniE6xTsuRJvpcv9t0srAcdVwO3h1gcQmDsG/TjEunpMCUNAVlndxPD
         kaJU+DgcktAQPBNy7ukifvHAxLGrzDPQCSj+KpRab6WG10vfBcxcvEevW4Rkv4wXwG
         DVi2ZlzxJYcEPD5sEokuQFEu2BagdGxkXfW9seZwp9R1z5CqQhW0g+08YbjB5qDwaC
         PIvn4vXoK6UM/w+N1IlZ5k/KOBXjTxu+URBOQcBzN+ArRkLoQLW5o5mrcpl0JMGMV0
         GYLqdaj7AYRCg==
To:     Edward Cree <ecree.xilinx@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
Message-ID: <20210112110802.3914-1-alobakin@pm.me>
In-Reply-To: <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
References: <20210111182655.12159-1-alobakin@pm.me> <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>
Date: Tue, 12 Jan 2021 09:54:04 +0000

> Without wishing to weigh in on whether this caching is a good idea...

Well, we already have a cache to bulk flush "consumed" skbs, although
kmem_cache_free() is generally lighter than kmem_cache_alloc(), and
a page frag cache to allocate skb->head that is also bulking the
operations, since it contains a (compound) page with the size of
min(SZ_32K, PAGE_SIZE).
If they wouldn't give any visible boosts, I think they wouldn't hit
mainline.

> Wouldn't it be simpler, rather than having two separate "alloc" and "flus=
h"
>  caches, to have a single larger cache, such that whenever it becomes ful=
l
>  we bulk flush the top half, and when it's empty we bulk alloc the bottom
>  half?  That should mean fewer branches, fewer instructions etc. than
>  having to decide which cache to act upon every time.

I though about a unified cache, but couldn't decide whether to flush
or to allocate heads and how much to process. Your suggestion answers
these questions and generally seems great. I'll try that one, thanks!

> -ed

Al

