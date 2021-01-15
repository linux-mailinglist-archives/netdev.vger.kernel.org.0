Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682A22F7E5B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbhAOOft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:35:49 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:39771 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732214AbhAOOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:35:48 -0500
Date:   Fri, 15 Jan 2021 14:34:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610721305; bh=TQQJqIAOl8U91/OpE5V91qeQpQLEEGZk67YCSZa+8Lo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=mffgRhhwcN97uCvyqIBv0S412R4INgXfk74WYkNomIF2o/yBP/5oH7pcKMWx0SqWH
         N1Od6MyrojuRDXmUs6E6JUllsHLmTD5dHyLhm46gzWrc6lmJsbx2Ei3BHtrxkosfXc
         tVuu8bzPBeEYVs4gFtaUk3YgteTwCHdFXWx34E7xQk/zILkM3DhRSWy709DpjQ46iy
         kL7dtppXXgi5EcouJYniwZS/ZrOtj84TkyQ1yREPKKpcd4+emWxCygaUjm69cpwozt
         yw/QAT+gJHrJE7MylyF8k+QrBvYVOTNATHCjriekzEPTI33P4G4nrtaUK5cKK3w2om
         BraQVaNjLyKoQ==
To:     Eric Dumazet <edumazet@google.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Marco Elver <elver@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
Message-ID: <20210115143424.83784-1-alobakin@pm.me>
In-Reply-To: <CANn89iKi8jsBsCPqNvfQ9Wx6k6EZy5daL33c8YnAfkXZS+QWHw@mail.gmail.com>
References: <20210114235423.232737-1-alobakin@pm.me> <CANn89iKi8jsBsCPqNvfQ9Wx6k6EZy5daL33c8YnAfkXZS+QWHw@mail.gmail.com>
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

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 15 Jan 2021 15:28:37 +0100

> On Fri, Jan 15, 2021 at 12:55 AM Alexander Lobakin <alobakin@pm.me> wrote=
:
>>
>> Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for
>> tiny skbs") ensured that skbs with data size lower than 1025 bytes
>> will be kmalloc'ed to avoid excessive page cache fragmentation and
>> memory consumption.
>> However, the same issue can still be achieved manually via
>> __netdev_alloc_skb(), where the check for size hasn't been changed.
>> Mirror the condition from __napi_alloc_skb() to prevent from that.
>>
>> Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny=
 skbs")
>
> No, this tag is wrong, if you fix a bug, bug is much older than linux-5.1=
1
>
> My fix was about GRO head and virtio_net heads, both using pre-sized
> small buffers.
>
> You want to fix something else, and this is fine, because some drivers
> are unfortunately
> doing copy break ( at the cost of additional copy, even for packets
> that might be consumed right away)

You're right, it's about copybreak. I thought about wrong "Fixes"
right after sending, but... Sorry.
Will send v2 soon.

Thanks,
Al

