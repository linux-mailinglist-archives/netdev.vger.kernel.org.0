Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68FD2F7E30
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbhAOO3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbhAOO33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:29:29 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C48C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:28:49 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id n2so1277893iom.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4t2xImQTSoylap6FV9VzZoFi72SaBY2B00ks1m41fxg=;
        b=idUMpCyXLWpO0p8HDuV7CX0Fhq6jcqAFRLDOvLwVY1i0IGlB4vyV71YT9g4DERSqsy
         zoKh5hQZCZw+r/j9onHTt3dXbJoYlUI+65YZeO2wPHuXZxQcOox/abJcTVPvH7mfZ8Nh
         4wDryXOSbtj72k7ZFwluMyaRspH91MatZ3vZO8gVhYfDnjjYwKIKE1CGp0vyouHQlLOB
         FmpvI6oetzpu4uOj15nInUBlIUYT/wsAOGzeDjB8zsCGzLX4FyuapwCbD2ty7PjxvaA+
         7aC+8s54FUzOVp+Q4B5gNmfuv7ZNvkfYIZckoU74tC6m/nWZVf4DQK+qkPhVE1fal/UN
         fyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4t2xImQTSoylap6FV9VzZoFi72SaBY2B00ks1m41fxg=;
        b=GxCHBAxQziakHmroJmL6C1yZyiHjvjomRDdujKeSLcKrqwrqpFxTwOXDIANc9lVT5j
         B3eTt5+iZYa6/juZ7sfV70VCBEmCffshkLYhxOHHC/KiHAdt17Hkl9qke/DffA7qbf7p
         EnBqC24UsIYv1dbG0KZsDs037cKcl5LsOInxo4R/ysw79JkKgdPMW1GNyTsU4CZScFFq
         2Jv512k6gwdjYnjtxDHb8nTprjjEzzyIUZbALxtx9/oW+ua+3sk32sYuXKwm58R5JXHc
         DwEMuoRbd+a9i2MUiArElQmcxYcT1dLBmRfLoab8h2tCwLRUsIooq8HbDl9kAzP2JS+P
         hJ9Q==
X-Gm-Message-State: AOAM533qO30cgzY+foSsQLGKP+6GArHOK0ljgFON9K+JSFHVm7uFxHGe
        E9sYIvEPycKRNPtirdOCuurfcnOCcezxGu+MJ5uVeA==
X-Google-Smtp-Source: ABdhPJw3idb1i1wKMdzvj93NRD5qYGLjSGZpz5H/XnJJqURG1pAYZzT+ByUtZYFIKGzJwCn6TUpL9mOBVMkpdmaspUg=
X-Received: by 2002:a02:68a:: with SMTP id 132mr10703746jav.53.1610720928490;
 Fri, 15 Jan 2021 06:28:48 -0800 (PST)
MIME-Version: 1.0
References: <20210114235423.232737-1-alobakin@pm.me>
In-Reply-To: <20210114235423.232737-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Jan 2021 15:28:37 +0100
Message-ID: <CANn89iKi8jsBsCPqNvfQ9Wx6k6EZy5daL33c8YnAfkXZS+QWHw@mail.gmail.com>
Subject: Re: [PATCH net] skbuff: back tiny skbs with kmalloc() in
 __netdev_alloc_skb() too
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 12:55 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for
> tiny skbs") ensured that skbs with data size lower than 1025 bytes
> will be kmalloc'ed to avoid excessive page cache fragmentation and
> memory consumption.
> However, the same issue can still be achieved manually via
> __netdev_alloc_skb(), where the check for size hasn't been changed.
> Mirror the condition from __napi_alloc_skb() to prevent from that.
>
> Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")

No, this tag is wrong, if you fix a bug, bug is much older than linux-5.11

My fix was about GRO head and virtio_net heads, both using pre-sized
small buffers.

You want to fix something else, and this is fine, because some drivers
are unfortunately
doing copy break ( at the cost of additional copy, even for packets
that might be consumed right away)
