Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4DAC8D1
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392053AbfIGSlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 14:41:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41751 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733279AbfIGSlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 14:41:39 -0400
Received: by mail-qk1-f195.google.com with SMTP id o11so8942960qkg.8;
        Sat, 07 Sep 2019 11:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYhp8TlOraPZEcvgQxX+zDL0OShnjbjHQGWCEKi0vzw=;
        b=KBrNxQwfwomEYJqnvAP6KXvslf+92+qxbt1mG7Bml5dXt5SdJUVmhQi3/tJo5O8KsJ
         FCWzcEgMW43jg3taA5dtAYbcI+xWrcwTlKJ6kkOaGOy6JXDTAeEMtHPQUaRK/fcE3Sbq
         4MxH+PLGPyxLFWqkepJkGsILaPWtd3J8tvu3cyxs033vR8F1tAz3OglFUY5uUNgJu3kQ
         yqru0o95ZjVi/5b6ALV3BjOgp4GtEkWqrv8jvv/UsOsif3inqgVzaEGJqkh38UpaFHx/
         v4Np+ReyM7qWx5JE7VD3+oHLUu6y9CNXqOdjtDYYO2BWrcoM/cBExOAdu6HOszvdCAvf
         ceyQ==
X-Gm-Message-State: APjAAAWMbnfQrhoxxjWPwQG117rUUOeyFEsYnqimB4jgyFY2BtDqOHf/
        4aSDLJ7KF607NbdM5hirlkbGLDF919rcn+hZhEI=
X-Google-Smtp-Source: APXvYqz1HJ3qg6cvnS/niXBkM+JJ51geexQhRQF+xEmY+lhPRKf31bLpTncI3MbHMMGrv5NyGilu/DV60ZV32P0cPUo=
X-Received: by 2002:ae9:ef8c:: with SMTP id d134mr15352039qkg.286.1567881698140;
 Sat, 07 Sep 2019 11:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190906151242.1115282-1-arnd@arndb.de> <20190907180754.dz7gstqfj7djlbrs@salvia>
In-Reply-To: <20190907180754.dz7gstqfj7djlbrs@salvia>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 7 Sep 2019 20:41:22 +0200
Message-ID: <CAK8P3a04ic_VP6L_=N5P7vfQG1VDV25g3KvUpuCVdX483hx_cA@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: nf_tables: avoid excessive stack usage
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wenxu <wenxu@ucloud.cn>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 7, 2019 at 8:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Arnd,
>
> On Fri, Sep 06, 2019 at 05:12:30PM +0200, Arnd Bergmann wrote:
> > The nft_offload_ctx structure is much too large to put on the
> > stack:
> >
> > net/netfilter/nf_tables_offload.c:31:23: error: stack frame size of 1200 bytes in function 'nft_flow_rule_create' [-Werror,-Wframe-larger-than=]
> >
> > Use dynamic allocation here, as we do elsewhere in the same
> > function.
> >
> > Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > Since we only really care about two members of the structure, an
> > alternative would be a larger rewrite, but that is probably too
> > late for v5.4.
>
> Thanks for this patch.
>
> I'm attaching a patch to reduce this structure size a bit. Do you
> think this alternative patch is ok until this alternative rewrite
> happens?

I haven't tried it yet, but it looks like that would save 8 of the
48 bytes in each for each of the 24 registers (12 bytes on m68k
or i386, which only use 4 byte alignment for nft_data), so
this wouldn't make too much difference.

> Anyway I agree we should to get this structure away from the
> stack, even after this is still large, so your patch (or a variant of
> it) will be useful sooner than later I think.

What I was thinking for a possible smaller fix would be to not
pass the ctx into the expr->ops->offload callback but
only pass the 'dep' member. Since I've never seen this code
before, I have no idea if that would be an improvement
in the end.

       Arnd
