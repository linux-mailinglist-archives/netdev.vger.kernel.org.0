Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0647241BEDF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbhI2Fyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243585AbhI2Fyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:54:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3358C06161C;
        Tue, 28 Sep 2021 22:53:09 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 66so1168112pgc.9;
        Tue, 28 Sep 2021 22:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PfjTnWUcOgiAtumoZpdwinOUPN5UVGsh3TYhswHTtSk=;
        b=pmuJwLZ5P54YR/f4I0ji7GnrYm1qiziZCmr6mmNLx7e339XVS0VXMcx9W2IEOVVY/J
         XODE1jmE8D1nRwyfOX4jxAPX77b0ps8NDDh0s5tHrgk9rKVbjirgVDeXbrgW0Xogq9Fb
         RRyH770GNwnEOfTSpSuJ0ziGyFJJ/jqn9pCy0HD15fMh8jiikvraH6R4QEb2jxnqzOQL
         YGUWJGkXqU+W+r2jMQxdx9+CCvKhsqrqBjHWN4rPqeL9bZUi5xl6Z/F6c0pjOJ+1KJ2K
         HIfdSTXeC8TkPbF/AcJtYmClEVhzMILFnLnshMSUFOdVkQ6vlfsEP3Reu/TXXoer1S94
         7MTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PfjTnWUcOgiAtumoZpdwinOUPN5UVGsh3TYhswHTtSk=;
        b=LPTQD4CZrNdbMCkx0QaI+KaRn594PttWwPg3mUVVkDUgtBoLsLGqweFx+K1cBloSFX
         D5PoaWAUenmVU5DCGt5Xz19HM1ByC7djQw0uhh4VeM/EINE+xsEpR1TRscHdVnZAd8FW
         HN7KHVo0v/qNHWpX2gaeF1WRH98TNs1y8e06Y5Cq/dOP4VtjlfuNMFgfjk4TtYQzIV5d
         hzbuVgGPNQNv18WQxoApJpaedFmUGaRnAuo+QJ2rm/bUmgzxDtuTmN6tFnhJW2CcdCWY
         ST5jj061OCf3KNzjx7jXUxgDXRdY0UOHcbABHjFwFHnrLK7tBCcSKGSnTjA89QcS6oqU
         KV9w==
X-Gm-Message-State: AOAM531ZpMXLnL7lNgOWglCMv8yKZ/7dI5sHO3F/YqSJR4J6b1LxlIzR
        v5wkFF44dvfsW7E93nvlbd15OoFm4nHH17I31jY=
X-Google-Smtp-Source: ABdhPJw4pXVJN+Q3pNwE5TpcNyPHfgM9xrYH3AKu4MATrkHTwJD1dhSjIR2chL9FVutQXzR67KpZUaBzoGojLO/Z7q0=
X-Received: by 2002:a05:6a00:708:b0:43b:80ba:99c8 with SMTP id
 8-20020a056a00070800b0043b80ba99c8mr9284101pfl.51.1632894789089; Tue, 28 Sep
 2021 22:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
 <20210922075613.12186-7-magnus.karlsson@gmail.com> <YVOiCYXTL63R4Mu9@archlinux-ax161>
In-Reply-To: <YVOiCYXTL63R4Mu9@archlinux-ax161>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 29 Sep 2021 07:52:58 +0200
Message-ID: <CAJ8uoz0RioOT=-bvfcmGKTKvHnEfYg9v0o1cGLQdY7FX628o_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/13] xsk: optimize for aligned case
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 1:15 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Wed, Sep 22, 2021 at 09:56:06AM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Optimize for the aligned case by precomputing the parameter values of
> > the xdp_buff_xsk and xdp_buff structures in the heads array. We can do
> > this as the heads array size is equal to the number of chunks in the
> > umem for the aligned case. Then every entry in this array will reflect
> > a certain chunk/frame and can therefore be prepopulated with the
> > correct values and we can drop the use of the free_heads stack. Note
> > that it is not possible to allocate more buffers than what has been
> > allocated in the aligned case since each chunk can only contain a
> > single buffer.
> >
> > We can unfortunately not do this in the unaligned case as one chunk
> > might contain multiple buffers. In this case, we keep the old scheme
> > of populating a heads entry every time it is used and using
> > the free_heads stack.
> >
> > Also move xp_release() and xp_get_handle() to xsk_buff_pool.h. They
> > were for some reason in xsk.c even though they are buffer pool
> > operations.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> My apologies if this has already been reported (I have not seen a report
> on netdev nor a report from Intel around it) but this patch as
> commit 94033cd8e73b ("xsk: Optimize for aligned case") in -next causes
> the following build failure with clang + x86_64 allmodconfig:
>
> net/xdp/xsk_buff_pool.c:465:15: error: variable 'xskb' is uninitialized when used here [-Werror,-Wuninitialized]
>                         xp_release(xskb);
>                                    ^~~~
> net/xdp/xsk_buff_pool.c:455:27: note: initialize the variable 'xskb' to silence this warning
>         struct xdp_buff_xsk *xskb;
>                                  ^
>                                   = NULL
> 1 error generated.

Thanks for reporting this Nathan. Will fix right away.

/Magnus

> Cheers,
> Nathan
