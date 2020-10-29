Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FFC29F883
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgJ2Wkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2Wkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:40:32 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6871AC0613CF;
        Thu, 29 Oct 2020 15:40:32 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id f140so3538166ybg.3;
        Thu, 29 Oct 2020 15:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RT08zdMB6U/tTBtGYcjh42pKK9rfOLiH58A8WAYZMCs=;
        b=Rj5ivE5C7Dvhdy1f7AWTrSdVsfZQHl2KkbK3JaLuG7VVAiaIWFvlWI9tECrE62oAh8
         UIkIJV/lsq2hqQeTeRPAedC2tO+a9zLmnc2iDFEHSu9E/dXyZL0WFjD95Z4fJPhAn8w7
         eGHYZX4ufuMxsr5miFPeBNT0vi/UXP6Ur8UdxRZlZjhqdpcUlDhgjZsaXGzadNroDNsJ
         mTdE7jlueGrI8laLtWNBQFh4ZQlWeNmB+4VHR4UCmi0Gx2anz3sos5bjC+9noHstp8ch
         z35D1O0p5XkNJb5XnJKdJuch9x/DqHZOg46kYDbS+sUyKD5KvkZfPp0hvo6aweZKmR7o
         p+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RT08zdMB6U/tTBtGYcjh42pKK9rfOLiH58A8WAYZMCs=;
        b=LZjtuWwwv7rmFzNuWcSgzuVjpa2nKo7ntP9S5TqSKVU2hw5gtAfXtlXsjDPW4dq7lw
         GPh5auUiLse6m/Mel35JML/N/wGM/02QsyFCe+O+l5h1zWzzUhMZH8HgpSCYTb7FkCWY
         1uDFE6MdSAyL0RKfusoxK+rNppx29QyNRW8KioS3LGP6PPhK8x2Tp9iLMfkohrMqvA4T
         jB9w3Y64SoCQj4I5KIU4w55qBTmfu7tZgxQaqhIur7OlKRuqhzkYZty4z3xYndlnd8BK
         zLPky2vCr761loHrhU7E3UF3cqIp+t6d8Pla819mM54ZwO8KC3gSUz9TTljtNwR2BMs3
         tgrA==
X-Gm-Message-State: AOAM533gVm0NRQQQNWhMu4A6ccLQIjkd4w2bknWc4ax871HKBFl/tY0d
        MI4km1XmwTVKVfOAsLWLbaBwM+B/ENIeLHJdTC0=
X-Google-Smtp-Source: ABdhPJyoLxPHCPa/4XJgfYaRpULeT+Xotb5qqzDGY0W7t/+hM+bAFASIiNxLE3XJSOGrinuC7gq7bvr/RWp4d5/qC5E=
X-Received: by 2002:a25:25c2:: with SMTP id l185mr8467921ybl.230.1604011231723;
 Thu, 29 Oct 2020 15:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201023123754.30304-1-david.verbeiren@tessares.net>
 <20201027221324.27894-1-david.verbeiren@tessares.net> <CAEf4Bzb84+Uv1dZa6WE5Eow3tovFqL+FpP8QfGP0C-QQj1JDTw@mail.gmail.com>
 <CAHzPrnEfDLZ6McM+OMBMPiJ1AT9JZta1eognnnowbtT9_pHGMw@mail.gmail.com>
In-Reply-To: <CAHzPrnEfDLZ6McM+OMBMPiJ1AT9JZta1eognnnowbtT9_pHGMw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 15:40:20 -0700
Message-ID: <CAEf4BzZBn9HWhTeyaOLXYwJtdandx44a8oJLjBunFUgjoN5Udw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: zero-fill re-used per-cpu map element
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 7:44 AM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> On Tue, Oct 27, 2020 at 11:55 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > Looks good, but would be good to have a unit test (see below). Maybe
> > in a follow up.
>
> Here is the associated new selftest, implementing the sequence you
> proposed (thanks for that!), and also one for LRU case:
> https://lore.kernel.org/bpf/20201029111730.6881-1-david.verbeiren@tessares.net/
>
> I hope I did it in the "right" framework of the day.

You did it in a very laborious and hard way, which will be harder to
maintain, unfortunately. But it should be trivial to simplify it with
skeleton. It's probably better to combine the selftest patch with the
kernel fix in this patch and send it as v2?
