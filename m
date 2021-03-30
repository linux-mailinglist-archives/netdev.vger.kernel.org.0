Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5C134ED39
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhC3QJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhC3QIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:08:50 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA43C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:08:50 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x189so17977242ybg.5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tjx4AF4XIRdJDEKC/Pu6EiKHWkc5ovyi25lGX+MyGY0=;
        b=VNSfiGmsumEEc1J1JOWhDEcwSX9GoNM52dP3GeGCexvQQsqPCuqk9cFc/6CqJ30jxU
         ph8yLhhR/4U47Y9U5/kFiyLpCltj6hbgTRdllGAdI4YLjgDMNGH/QdlBF0slMpbWhV+V
         RLhnA4hQHyhHm0bzf1PD2IjN5J+Zyz0vpeHecoTh+YSGmiSwvVXfCBiJU8FH/1IJQSQv
         3DdWf/wetcSkEjkEvale1E/221KZKgiRfz4ZfVv44PBdTyi5dqZRLupT8+CpQl4UyYcM
         t4+IeJySMWqeQAZhde3CCtX0qeSbpr9u64tEtiFvTMhZc/CQVgrqp4B+X+HgAzULkifS
         2mNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tjx4AF4XIRdJDEKC/Pu6EiKHWkc5ovyi25lGX+MyGY0=;
        b=lSwHSJY9YyizCgc1nDtPHJedk9bi8V1uKRgc8qHruYPEPP1mJVbIWwDPj6ndp6Pmfq
         Ngf9sIAzD4Pgzyg31wpZJWnkpdg9YWKJE3iAqSVg6vIUUCY5jB3F+NUsIxvZzszB/mre
         eezb6z9Q1c6tJuM9wN1Pm1+fR4L5+WZ+AnbkBWmkraw+Qbj3NOalSTO2R3f12NIbXs2O
         x8ps20qAI/62uKrX9JDwWel8Jgrfu7SorTeraw2o2aOv4Djbj1mMo/CKZRka6raVKO46
         /u1DdBKz1va4mctV4UzNXIYtkcf9a+DSUJWDGISG0wvQ7aSBcyI9U+7bE25BR+H4fAHS
         SQvA==
X-Gm-Message-State: AOAM532zn319kCPRkaRkHR9ifGrPuPB3vP8XEacXhyvNuINw+2l6Uv0n
        3lfhahavBd3kyWdzseREBaIB9yxmTy4TRklZx0MPJA==
X-Google-Smtp-Source: ABdhPJxk+5wILZhhgj5D6ktCxaE3rfIT8ef/CILPeReg0jrA7SraXbuG/8DE3on5XDhL1q+Gg/4PdPci7jIew30tggY=
X-Received: by 2002:a25:3614:: with SMTP id d20mr29710685yba.452.1617120527667;
 Tue, 30 Mar 2021 09:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210330153106.31614-1-ap420073@gmail.com> <CANn89iJ1G8vU-Jw6gaTsZHamQv1ncLmoJ1FOop25OzrYmjh4kA@mail.gmail.com>
 <634ed5a7-eccc-3749-e386-841141a30038@gmail.com>
In-Reply-To: <634ed5a7-eccc-3749-e386-841141a30038@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 18:08:36 +0200
Message-ID: <CANn89iKeeWLkzrrW8Yre+iHkbfL6kLR33vDae8y01Hfn-nz5_A@mail.gmail.com>
Subject: Re: [PATCH net-next] mld: add missing rtnl_lock() in do_ipv6_getsockopt()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 6:02 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On 3/31/21 12:40 AM, Eric Dumazet wrote:
>  > This seems a serious regression compared to old code (in net tree)
>  >
>  > Have you added RTNL requirement in all this code ?
>  >
>  > We would like to use RTNL only if strictly needed.
>
> Yes, I agree with you.
> This patchset actually relies on existed RTNL, which is
> setsockopt_needs_rtnl().
> And remained RTNL was replaced by mc_lock.
> So, this patchset actually doesn't add new RTNL except in this case.
>
> Fortunately, I think It can be replaced by RCU because,
> 1. ip6_mc_msfget() doesn't need the sleepable functions.
> 2. It is not the write critical section.
> So, RCU can be used instead of RTNL for ip6_mc_msfget().
> How do you think about it?

Yes please, do not add RTNL here if we can avoid it.

Otherwise some applications will slow down the whole stack, even with
different containers/netns.

(There is a single RTNL for the whole machine)
