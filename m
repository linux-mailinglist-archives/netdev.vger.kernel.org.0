Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4457346FF75
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbhLJLLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbhLJLLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 06:11:07 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BBEC0617A2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:07:32 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id j2so20391932ybg.9
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 03:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YLr1OfhaFphwYKu/t1VDUlZQ82qDFmSjNCE43bOQYos=;
        b=ouvOOruaDVL/nKcxGTn19tzdk8O1+ZsdFYykoGTUq6gDmknAN5N/eK+Ao/p2IKOeJS
         AlO93dePMNNgzzIHZQ1OK+jZIH7PFbxVrkqbXsZ3wa3NgTKd9IrxDod9f6p74ITlHWn5
         WpBuPzGuL2quCVRZQITfgJiTZGlWT17/C0xsrHYvqDqgjByevYZzxMSmcKpSQZzGO5Xj
         YCtG0n9Kax1yYveeNq+6XGGXStPyi+W3rGxnR29hZxqUB9EzxBF/MI8W8UiajAAGTP6e
         UHQMQ/aPJOUCwiBp1sVDF29h3lmE08s2ksIw3HKdX/fY3lW+NTXj8GQlc95mDiwRokED
         9HiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YLr1OfhaFphwYKu/t1VDUlZQ82qDFmSjNCE43bOQYos=;
        b=dwUJFd65NuAwOvVUPy74OZ4qynrx+XBxuUQFAVL4rbhM/+QoSv0NOrVBFQGwXx/03F
         163yUasfj0P6TNW8mPChcEf6JxKtT/NdXk5JQci0bJvZuZGdkZmdUDHAdHdO0V4FoEzk
         eQMeR7IkBE2AJzMpAre+0c0D7hi+tPy0MKDc5F+N3z2Zg2AJHr8il0Ak0BQTLy0SJYRZ
         sv3UFGvr9utAjdK1yiI/fdBzMMmSfi6UXgA0YYCe5vTEiJRpTzKQznAeqaDA+T+rdN27
         R91P4lbDEgAvOiJUir4+cjYoKU26Ex7C/m99sA0tu9NTGQ0tmoYmlkE6MHmPHAAAN5fv
         EQNg==
X-Gm-Message-State: AOAM532GDJXVCbzawZ64RPci+p/ezdis/U+2FVCnmQfjMf9wxoOQFDhJ
        LcMtyM87iIb8spCUeESaUMMOlDUAAZ8G/sLW1Bz8Fw==
X-Google-Smtp-Source: ABdhPJwpMFf1c9+HLsTENcy+8NGlpdb5bbmb4VJsELWoJHyCUVxTqRokLRKfewuOct8BSCSWyzE8pMnlgXAMxF+FJkU=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr14051025ybg.753.1639134451177;
 Fri, 10 Dec 2021 03:07:31 -0800 (PST)
MIME-Version: 1.0
References: <20211210081536.451881-1-eric.dumazet@gmail.com> <87ilvwwwmm.fsf@toke.dk>
In-Reply-To: <87ilvwwwmm.fsf@toke.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Dec 2021 03:07:19 -0800
Message-ID: <CANn89iJRu_uHi__pYr-y5p3Gw_FzmvCEgnYoBa4EGiXRNzxuPw@mail.gmail.com>
Subject: Re: [PATCH net] sch_cake: do not call cake_destroy() from cake_init()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 3:02 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=
.dk> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> > From: Eric Dumazet <edumazet@google.com>
> >
> > qdiscs are not supposed to call their own destroy() method
> > from init(), because core stack already does that.
> >
> > syzbot was able to trigger use after free:

> >
> > Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cak=
e) qdisc")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> Oops, thanks for the fix! I'm a little puzzled with the patch has my
> S-o-b, though? It should probably be replaced by:
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

Right, user error from my side, I copied it from your commit changelog
and forgot to s/Signed-off-by/Cc/

Thanks.
