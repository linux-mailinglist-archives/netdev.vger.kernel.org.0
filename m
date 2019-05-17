Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0364D21A79
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfEQPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:23:02 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:43935 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfEQPXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 11:23:01 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7f8079fd
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8t8JW19XTOO5GYISDvuSiehwnUA=; b=pLFnA6
        ZD+qqKBCwHtnrpOzlM5VKIyyKOkiKIfCIDGc8R5WASbp7cXjVSj52CbMq6vrxA+T
        R4Ny+vZI+418/ZDIidyRkgp0SR3m0f3bIEtOgMzI2/dLPM6+rhs58OkU6yawtbcs
        05N+O13RpTJBlEtjsH3aphiWqy5UAWXk6CLXjiZrrkg+y4BUW550vidVmDAlv2LC
        9KtGLpRz8A/EvSwCdQ8zDn1SHBR4ksQvxRIyjC8GLT4kBcz3VRNgYATotdw6c8MX
        QvTSVvnr41DydNBUBj/IVTKmU2G+OFiP67ZjLAZmhJ/LqCURevKIHS1PSZp3/33V
        5YoTsnzr5liqWccg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3cacca3f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 14:54:03 +0000 (UTC)
Received: by mail-ot1-f43.google.com with SMTP id n14so7096746otk.2
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 08:22:59 -0700 (PDT)
X-Gm-Message-State: APjAAAUNyfozgcZzplJGdgRyl7zx+YgLf/aYCEGGtYUB4QnV0VWGkbvN
        Ybf3rgeWv8rG2bwigw3hpcxy6DPMXELxJwWHU3k=
X-Google-Smtp-Source: APXvYqzale5Ci/OcT0HY35fSe9jAzes8uOhcDFKyNEm0caIGLdfFgsceP8E+YI12ZJOryvMJhdMkjQ8ZmbFZO1Mkp24=
X-Received: by 2002:a9d:4e08:: with SMTP id p8mr34137738otf.243.1558106578876;
 Fri, 17 May 2019 08:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <LaeckvP--3-1@tutanota.com> <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
 <20190517141709.GA25473@unicorn.suse.cz> <cb462836-a8d3-b8d8-fe3f-42186ade769e@gmail.com>
In-Reply-To: <cb462836-a8d3-b8d8-fe3f-42186ade769e@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 17 May 2019 17:22:47 +0200
X-Gmail-Original-Message-ID: <CAHmME9q+wmMQV_g6NvG6dM8XCm5xvshZrJiwLAHeS0FTywsLOA@mail.gmail.com>
Message-ID: <CAHmME9q+wmMQV_g6NvG6dM8XCm5xvshZrJiwLAHeS0FTywsLOA@mail.gmail.com>
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     David Ahern <dsahern@gmail.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>,
        emersonbernier@tutanota.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 5:21 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/17/19 8:17 AM, Michal Kubecek wrote:
> > AFAIK the purpose of 'ip route get' always was to let the user check
> > the result of a route lookup, i.e. "what route would be used if I sent
> > a packet to an address". To be honest I would have to check how exactly
> > was "ip route get <addr>/<prefixlen>" implemented before.
> >
>
> The prefixlen was always silently ignored. We are trying to clean up
> this 'silent ignoring' just hitting a few speed bumps.

Indeed what we were after has always been, `ip route show dev <dev>
match <addr>/<prefixlen>`, and the old positive return value from `ip
route get` wasn't always correct for what we were using it for. So
mostly the breakage exposed another bug here.
