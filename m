Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F34C1E7
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfFST5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 15:57:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37101 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfFST5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 15:57:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so543048qtk.4;
        Wed, 19 Jun 2019 12:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6AYyD7TdXFlYd8xNntFANT3/Llq0uH8/SY9AGv/U5DI=;
        b=YFqWX8E9WKgmfO4L47m4uY2XbYw/sglIBwe/8lNylUdMZhH7BhgKLrKzM4oHvxTJtC
         kdB1M/GQe12gJyqfjF88y2dYRO1ylaoXBDZVxQeumJHaFOKCBj/WenZ9NmQPZbARgwWW
         3//tTs62VaMCEbmCFAVfQ+4AKW/dFQIoiWnhY/vADTMUWtUnlo9KZFVdWEdqN2J0qxj1
         OO4oJt3I2aJ8j6WVc6ew6g9dyuNhNqeZRGd5v1Y5fhVfQxtnJVYA+W6BeNTWUtsalOVt
         9AGG5OWlPh0BvnVpSdPITdSESJ1AHqOnlkKRkw+wOB1hTDZT82ubKHgfBOUmxlSsPwJC
         ag/A==
X-Gm-Message-State: APjAAAWDOvyDlKqe/2k+nMd7uxuAaFOEnvIYrX4v2mtWDO0TzRUwZlNZ
        f+fk8zh5RvW45zsshPFT6VEHGhHHX21TUem9DMA=
X-Google-Smtp-Source: APXvYqy2TeKLUH0rNHdGElJIP0Lh9rOLcGE09nUms4tDMgXncCfPdYt5Go8DgakpocJ7U7fh4NZBy8kK4+Wch5xCufQ=
X-Received: by 2002:a0c:87bd:: with SMTP id 58mr35151296qvj.62.1560974273851;
 Wed, 19 Jun 2019 12:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190619125500.1054426-1-arnd@arndb.de> <20190619174642.hvjvmfaptfdkmbpk@salvia>
In-Reply-To: <20190619174642.hvjvmfaptfdkmbpk@salvia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 19 Jun 2019 21:57:35 +0200
Message-ID: <CAK8P3a3BPgieF_dUFZoNVOp7avdJwJZn2S1O=EA9DZXu_c59WQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: synproxy: fix building syncookie calls
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        wenxu <wenxu@ucloud.cn>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 7:46 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jun 19, 2019 at 02:54:36PM +0200, Arnd Bergmann wrote:
> > When either CONFIG_IPV6 or CONFIG_SYN_COOKIES are disabled, the kernel
> > fails to build:
> >
> > include/linux/netfilter_ipv6.h:180:9: error: implicit declaration of function '__cookie_v6_init_sequence'
> >       [-Werror,-Wimplicit-function-declaration]
> >         return __cookie_v6_init_sequence(iph, th, mssp);
> > include/linux/netfilter_ipv6.h:194:9: error: implicit declaration of function '__cookie_v6_check'
> >       [-Werror,-Wimplicit-function-declaration]
> >         return __cookie_v6_check(iph, th, cookie);
> > net/ipv6/netfilter.c:237:26: error: use of undeclared identifier '__cookie_v6_init_sequence'; did you mean 'cookie_init_sequence'?
> > net/ipv6/netfilter.c:238:21: error: use of undeclared identifier '__cookie_v6_check'; did you mean '__cookie_v4_check'?
> >
> > Fix the IS_ENABLED() checks to match the function declaration
> > and definitions for these.
>
> I made this:
>
> https://patchwork.ozlabs.org/patch/1117735/
>
> Basically it does:
>
> +#endif
> +#if IS_MODULE(CONFIG_IPV6) && defined(CONFIG_SYN_COOKIES)
>         .cookie_init_sequence   = __cookie_v6_init_sequence,
>         .cookie_v6_check        = __cookie_v6_check,
>  #endif
>
> If CONFIG_IPV6=n, then net/ipv6/netfilter.c is never compiled.
>
> Unless I'm missing anything, I'd prefer my patch because it's a bit
> less of ifdefs 8-)

That takes care of the link error, but not the "implicit declaration"
when netfilter_ipv6.h is included without SYN_COOKIES.

My patch addresses both issues together since they are strongly
related.

      Arnd
