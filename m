Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BF83171F9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhBJVIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbhBJVIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:08:19 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30592C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:07:39 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id i71so3448040ybg.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8znaZRtocbvV+3M9rM9KGrHZiohGeWVUeqKokJsXK0=;
        b=jK9tC3ita5KRNzbe24jzqS+8WDFMsNg5IxR/KmaPGH2MPH8Evf2AkU96TuB7whhBNF
         Z0mAxSpJBsVP91MvIXnt+sxUF73XeLbxoizYIUkb9iXJI3M8orY7jOL9fdJ0gVeWBiFB
         yL+Xb3uTmpS8QqWcg3i8XZLk1oEXVRoRTI6vbmGH0c8tzpr2nv17/SzX17vB+4boaN2m
         FPmkRyK9q1cJjRL3IuxfeFRUXOkSZJZvre2FVIIJI1LMdCgOu5wHs3qyIdZYKnI+WHC8
         w6aRfxKBt91yfOSMtIvtXvRv0BD8q9KMh+PNiJ5eLITbSd5Cg7ezFekN0lZwKN3PxhId
         DV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8znaZRtocbvV+3M9rM9KGrHZiohGeWVUeqKokJsXK0=;
        b=UZzdtUbjbfWamI+l5qIFw00Yar56ZKBt5qO4NnLMUQhEOlroPmUjK+2RrutAvig+Kx
         VKrerCauWcGFp2Un3nQgNuXY9GsDXgTtXyEf5AzxpAJTnGJO/Zau9Y503NOGCTJXqVFn
         jp4c3D3bonYgjX0KSUgx4Q5WSSS7b9KaZaathj1mcolnFH5THLIQGe0fOor3UltmCMKo
         iW4ihEeRbUeY9LH0mMHp5/bXpSFkWIho1K0rL7i6ix9mYrS2+mrwHMkK1b0K8R0lqAKi
         sGtfwK8gX8pYicr9CvjdjUamxJzR5zlkVxF36Kr7eW//xyQ0TWTtKYCqqfqNYJf8elwL
         /vtQ==
X-Gm-Message-State: AOAM533nf+rf4VVrc9OwX/h7qRIGKEoq2dUW1tR6DwSYerwo4OUgc1PZ
        xSmQctNAb22/yZv6luMkXBCsNxLrGWB0K8wS0pw9ow==
X-Google-Smtp-Source: ABdhPJy18ySepsmFSRe/afFpMaXsfRiXj0nvicnKrH8KQ046pyXmhqvTPEiBtSiuG21KRPJdvImbYpJ3s31sFDUxC50=
X-Received: by 2002:a25:1fc5:: with SMTP id f188mr7031979ybf.389.1612991258300;
 Wed, 10 Feb 2021 13:07:38 -0800 (PST)
MIME-Version: 1.0
References: <20210208193410.3859094-1-weiwan@google.com> <c02040902f51f0cf3aa3fc701005cea970ce0ff8.camel@redhat.com>
In-Reply-To: <c02040902f51f0cf3aa3fc701005cea970ce0ff8.camel@redhat.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 10 Feb 2021 13:07:27 -0800
Message-ID: <CAEA6p_C7Kz13ocAMJNvys_VcLdCHUG7usT4AgOk8ODbxrWQ=8w@mail.gmail.com>
Subject: Re: [PATCH net-next v11 0/3] implement kthread based napi poll
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 2:34 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2021-02-08 at 11:34 -0800, Wei Wang wrote:
> > The idea of moving the napi poll process out of softirq context to a
> > kernel thread based context is not new.
> > Paolo Abeni and Hannes Frederic Sowa have proposed patches to move napi
> > poll to kthread back in 2016. And Felix Fietkau has also proposed
> > patches of similar ideas to use workqueue to process napi poll just a
> > few weeks ago.
>
> I'd like to explicitly thank Wei and the reviewers for all the effort
> done to get this merged!
>
> Nice and huge work, kudos on you!

Thank you Paolo! And thanks to all the reviewers!

>
> Thanks!
>
> Paolo
>
