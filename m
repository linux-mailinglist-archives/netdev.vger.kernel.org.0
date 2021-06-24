Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925583B2C22
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhFXKKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 06:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhFXKKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 06:10:37 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D477C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:08:18 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id bj15so12928110qkb.11
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 03:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ry7DAjWFfQAEGfTreG5TSrapaTI48ABkN7Dp1HDYK24=;
        b=rXZ20ClFYDeDwH77UhvlPIJxE/ELJqF3RrxZwr4s9QvEhYoaedkEIsnoitfNMc0Ymc
         C+JxoDuVXbxLFheyjBirOYA0EJG7L8NRcEna6i7bPICMVVqVFsEWCTg0FGUp6rSDjThX
         XRlc0rgu1zlTgJh/Bb3uPB+ll6eDFj+Y1YiaCymLILlCLlI5i7iAGXQeSjvZhDThjASY
         ELZ3EPI6doCEtdluKWfWEdWVbRcDV2qSE1DcET+dDL/W/lfijJqzip1Bjlw0kDGTGaRJ
         2qs+hbAoMDZS7Jzp5aPDz1zL8OAh/hhBpgapqszO1TwsISLUBQ8HrU/KJiuGMynUBUAb
         Uznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ry7DAjWFfQAEGfTreG5TSrapaTI48ABkN7Dp1HDYK24=;
        b=RgzaqzJEDTNfDHjE+rCKRxBjN+7+NcbxgJUeYmKK9loP7ozxuS+yVxIC8y1JdHrhFM
         fXti+pXgBrundD2RoI6BPRP/vpcPOjpxdSNHSgHULF4lFpf7fPQ4VTxkV2xKkhZz90Xj
         WX5cZ7bBpADU+aP7qouX9KZqb12BlEY+kfs8GhCzl0CcmCD/K5e/yDJ+Mh50PUJORvKC
         ZZ/XgZamyUKr5ew0SmJyliMyiKC9rMaIKqXgVaeqt1IKPKjfpeD+sAmfEiTd45pqY6uJ
         fzReJYuv3thkQz2qcDhR8NjRmtNtO/ppIM/VX64YiiNnMtF35ZFuZYN+A57CeJUDLnf9
         YYdw==
X-Gm-Message-State: AOAM530G5R72k5mYS318ONqA/6YZ7mkjviTKOoxVoXk3VJdAlndZSHzc
        EsGGwP+18mc2nSoeNg7gK2FLYxYSoa5FediB43LzLQ==
X-Google-Smtp-Source: ABdhPJzSMaF34vJ0p9CNhaBtE8ZJ6ktH29s6p9E8oslaFYSvNhmf498bMS43L8Xr0qhhdJJtkC/gZlEPptcxFkyibcY=
X-Received: by 2002:a05:6902:544:: with SMTP id z4mr3873677ybs.452.1624529296793;
 Thu, 24 Jun 2021 03:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210623194353.2021745-1-eric.dumazet@gmail.com> <e0e59d780e1c979c2666e8bc77ce00249ac3e6e1.camel@redhat.com>
In-Reply-To: <e0e59d780e1c979c2666e8bc77ce00249ac3e6e1.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 24 Jun 2021 12:08:05 +0200
Message-ID: <CANn89i+c5QhVt4NDtvx6ap8HdPyJKVtrpXyhdAMqRWBLZBzApw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix out-of-bound access in ip6_parse_tlv()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:49 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2021-06-23 at 12:43 -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > First problem is that optlen is fetched without checking
> > there is more than one byte to parse.
> >
> > Fix this by taking care of IPV6_TLV_PAD1 before
> > fetching optlen (under appropriate sanity checks against len)
> >
> > Second problem is that IPV6_TLV_PADN checks of zero
> > padding are performed before the check of remaining length.
> >
> > Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
>
> Perhaps even:
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> for the first issue?
>

> +             if (nh[off] == IPV6_TLV_PAD1) {
> >                       optlen = 1;
>
> It looks like the above assignment is not needed anymore.
>
> Other than that LGTM,
>

Thanks for the review, I am sending the v2.
