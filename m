Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD527B7E09
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391219AbfISPVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:21:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38003 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391210AbfISPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 11:21:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id h195so2546668pfe.5;
        Thu, 19 Sep 2019 08:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elSAIrRu3dQxgG0RMhk4CUbUdZ4ObQpOvu0urPmvfjk=;
        b=YsfLhAWmn1qmXdoymgAnQy6+5RuBBX/FoT2FzmCut7LkV7WVoCb3wGg9gj6+zlzayM
         9MCJf1GzozawNoHz8Er5jMIz53ePwS/eFrfrUgpomI4r+2Izt0GkzvJhTPLQ4mBs+qg6
         MjuvQZf3Livp5U8YMaBAxe1a48LlfpX067U/cBMLakXGDnQOWcfDBCfnUB+xj+/hPCH0
         WJVNbmXHnMKaDXGNJ/RbyLDEVLD9/ZDgn0AFi4rygyp39n6uDg4yOXAWWH2gB688rh2D
         BzVq8nDjfeCeoT5noC3nrEYdNVRE44VfIy5Vm6MsqDpo/n/dwORRqU1xf0uzW3oOK96x
         2XAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elSAIrRu3dQxgG0RMhk4CUbUdZ4ObQpOvu0urPmvfjk=;
        b=avMwOoEGjaMxRakzveQ43iOIysFJYtbV4bg/uT+UyAgtgmE52cRlHiopk7hZQvTz9r
         q0EFziqprndylGD79qetHwSlXvMHNjAUCm+spM0Gy1jJ8CQJg1tcRSKpbKMjNOb7nOlh
         pFeHVe1ecKluK/GsH5tGNKVMQJV9zB75Q9+ysRa0j/OkYgA5x7uvc35H2NjiGI3lF8a6
         1Vq5qUNZYi59dSiCbImb1DqSSfKTOxWOpXVBMW/bvYmHpLJFBnqg7UzbCQu9KeCVifJc
         j2SYCtdvg07kHP+yj0gRu7K/Jc5ELxbbzs4/I/XeonmIBcxaMD2+unYeY60bHAfsqEWE
         w/6g==
X-Gm-Message-State: APjAAAX/4fOLMXjbR1r/jkTXCJGQBZ5amAg2gwF0paa4WYleZ6MzJjJa
        R0DpEbRS7c+2x79+YYfMYixC335KJmTVT4cfPLE=
X-Google-Smtp-Source: APXvYqx/0SJGC3GSoPDCtTJYkYGHu9GaMKjzuHLo54ri/0jtmcZzWFrnVZDNSHYNIWjVjwz/mB27JzfWy9gNM5A8vxw=
X-Received: by 2002:a63:db50:: with SMTP id x16mr9296011pgi.87.1568906514155;
 Thu, 19 Sep 2019 08:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190913200819.32686-1-cpaasch@apple.com>
In-Reply-To: <20190913200819.32686-1-cpaasch@apple.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Thu, 19 Sep 2019 08:21:43 -0700
Message-ID: <CALMXkpbL+P8ZM+Z8NHg644X7++opx2He5256D7ZLncntQp+8vw@mail.gmail.com>
Subject: Re: [PATCH v4.14-stable 0/2] Fixes to commit fdfc5c8594c2 (tcp:
 remove empty skb from write queue in error cases)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg & Sasha,

On Sat, Sep 14, 2019 at 12:20 AM Christoph Paasch <cpaasch@apple.com> wrote:
>
>
> The above referenced commit has problems on older non-rbTree kernels.
>
> AFAICS, the commit has only been backported to 4.14 up to now, but the
> commit that fdfc5c8594c2 is fixing (namely ce5ec440994b ("tcp: ensure epoll
> edge trigger wakeup when write queue is empty"), is in v4.2.
>
> Christoph Paasch (2):
>   tcp: Reset send_head when removing skb from write-queue
>   tcp: Don't dequeue SYN/FIN-segments from write-queue

I'm checking in on these two patches for the 4.14 stable-queue.
Especially the panic fixed by patch 2 is pretty easy to trigger :-/

Thanks,
Christoph
