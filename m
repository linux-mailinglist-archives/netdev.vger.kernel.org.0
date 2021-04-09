Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C4359394
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 06:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhDIEIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 00:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhDIEI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 00:08:28 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11ADC061760;
        Thu,  8 Apr 2021 21:08:16 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l76so2910242pga.6;
        Thu, 08 Apr 2021 21:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwkJQMPwiOfDOGttdSfGe5hwvJwsvckYfhrgLcypAHk=;
        b=cMsfegVZH+3NipbLHANwo/P/BbWZO42Kbx3YDYj6O1jDB7bVh2wxrEhNg4mO3v3cMh
         4bJ/nO9BQoR2QrlYyVKImKpIJx5kUcJju+nt1IjkmkBw0lOUNTQozIgRDbVphoAzbuJj
         RJiAItoSokF8I/prV+vG7IwVsyJXk7dDZwYtPKFqBHX+6tSPrLeYsmFkhbf0I6R/4wU0
         h669knn3PRoiuMz3d/wyAOUtFaE6wYPKzw8wDYV2Pj8yayzlFsnTkBiWH9SaMQ4g2ukV
         YCKOwxBALinguDGtI8kxnerpqxMoLW9TH5ZdA4Uz1hRU4ZCoKpsznX04hIEC8BV1Fzvp
         zgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwkJQMPwiOfDOGttdSfGe5hwvJwsvckYfhrgLcypAHk=;
        b=TY0RSCfOoRsOGiV+4JJnQ20b/myb3KQsPQD7bRv4EAYjfO8RNfLwhBZT9xITz4Nh0F
         YfuWj0rGXNFc359saxWd/k/8fZnuvtHdjHizEkp/G9oWF5m9fY5XwJ1Dur/Qg5MWqyle
         7qBt9M+qaIqJU0khx9zbnwDws9YQzQI5kvzR0P+z7oHu7pwNog9lx0x+G3z1p2WOl6di
         y/4delgW4uiE0hUtukLLqRzcGa8wNxeX3atCYiBSlv66lxOT+yqXZPnKWfzU0vxm+usg
         h/s6C+WN5lw/WyohbyuAfyjNq4MJ4kcx+P/8DAqNwB1mohK+txE5W8b6QPQWnBR0R3Bn
         ROfA==
X-Gm-Message-State: AOAM532iiGS4X/kogW9jpGtYm/LWVc0t+KcxHI1+T+GOpPHg5toIMpbM
        P6R174X+kbFFbszxm8ArsFYLwnwA33hBA89b/q4=
X-Google-Smtp-Source: ABdhPJwewqPOUQ+1EvjSpcIxAS0fOf8DEeSrkTxFrkc3qmkIKX4/wJKoH6dbkKhjeLHaIsLL69SOFOfe7+j2H4T8woo=
X-Received: by 2002:aa7:90d3:0:b029:241:21a1:6ffb with SMTP id
 k19-20020aa790d30000b029024121a16ffbmr10335444pfk.43.1617941296208; Thu, 08
 Apr 2021 21:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210408030556.45134-1-xiyou.wangcong@gmail.com> <606f9f2b26b1a_c8b9208a4@john-XPS-13-9370.notmuch>
In-Reply-To: <606f9f2b26b1a_c8b9208a4@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Apr 2021 21:08:05 -0700
Message-ID: <CAM_iQpXqfAXPoesdXskH7BaE206zc5QDEsfjFnfSRck2FH+wLg@mail.gmail.com>
Subject: Re: [Patch bpf-next] sock_map: fix a potential use-after-free in sock_map_close()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > The last refcnt of the psock can be gone right after
> > sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
> > The reason why I placed sk_psock_stop() there is to avoid RCU read
> > critical section, and more importantly, some callee of
> > sock_map_remove_links() is supposed to be called with RCU read lock,
> > we can not simply get rid of RCU read lock here. Therefore, the only
> > choice we have is to grab an additional refcnt with sk_psock_get()
> > and put it back after sk_psock_stop().
> >
> > Reported-by: syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com
> > Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/core/sock_map.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index f473c51cbc4b..6f1b82b8ad49 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -1521,7 +1521,7 @@ void sock_map_close(struct sock *sk, long timeout)
> >
> >       lock_sock(sk);
> >       rcu_read_lock();
>
> It looks like we can drop the rcu_read_lock()/unlock() section then if we
> take a reference on the psock? Before it was there to ensure we didn't
> lose the psock from some other context, but with a reference held this
> can not happen.

Some callees under sock_map_remove_links() still assert RCU read
lock, so we can not simply drop the RCU read lock here. Some
additional efforts are needed to take care of those assertions, which
can be a separate patch.

Thanks.
