Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F977BBD9E
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 23:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502668AbfIWVKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 17:10:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32881 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388866AbfIWVKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 17:10:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so9937730pfl.0
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 14:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NkgH7US4bX0rlHhcB4W65YFLpV3dVVt3h8lBPJrKqEA=;
        b=h6HAdNso0DEPgZD5dNEKUuXqjCMvwzboAkeqSnX7lUOStFkXPIVP80QtcHm2rxRB47
         DafDZGMFwXKYL1xMrzRjPJ3jpk6GBYEhT5AJOPpbD5793EvNvUheH3Q6MU2XPUbgXBVY
         jNNQDLpXAhzzlxUVspIavW59VfNr9UcGZZKAjaGQ5JfIDqE3K6Dmt2GbkuBmQJOkYMMI
         Esbfv8w73iMYMZfQLoA/hkBm5AaglZKOmLn2orZknVFbtHjFxHlooThvO/fHl5DnKAfO
         fZkesVwlonlKxRJOp3lZsJ0j5EKhy6dwgK6ZpC4MAsgJBvFqDQhTNCoww2ururLS4VSp
         GPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NkgH7US4bX0rlHhcB4W65YFLpV3dVVt3h8lBPJrKqEA=;
        b=WM1rciD/ip6OhQoklzniBEQuyDjlCofGOOxe0SySitc4Pum6vTbO4nucvzsmVa/csN
         zhj71dBDs6XZne7aqlxVnBc86o7GsJtM8qsHZwY9glx6XieSnNfRq71+npRnOH6CCuTj
         GPGAEIiYmbSpH1azz5ZhEsQbPnk+7ckzVs1uSvrTGciYLlSNTqrsT9XLTzDYBomfPwU9
         GT8ZzIAAhHZM+quiHDibCDt4IeL+I4+o9gNmvPgEsE8XmImeWjaxYg2kWMHIJl5GcQNu
         FxuypyHArVxc72+ttpmYjSrk7pdlpsChJZ12TvsCabeVrzwM0YeRE9RpyOPnQ6f5s1FP
         cs2Q==
X-Gm-Message-State: APjAAAXVw0F6bWam8m6a/FheRiQk+nEU1IVNadqPIasK1wcWw/7+FLTb
        xI/ihM5MKpdTJ0wHKw/4Fn/3x6tZmyNnxWlva58=
X-Google-Smtp-Source: APXvYqyREQOTwrUzx5xH7n60+d1zx8Zqai9kTWw6tkv9yuLagcmIfxjpLJCV6ajJ5YTUVZLTKGURKSxnabztpxw5a60=
X-Received: by 2002:a17:90a:ad8f:: with SMTP id s15mr1577781pjq.50.1569273047848;
 Mon, 23 Sep 2019 14:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190918195704.218413-1-edumazet@google.com> <CAM_iQpVyJDeScQDL6vHNAN9gu5a3c0forQ2Ko7eQihawRO_Sdw@mail.gmail.com>
 <20190921190800.3f19fe23@cakuba.netronome.com> <4e2ff069-e1f5-492f-14eb-5348e2cab907@gmail.com>
In-Reply-To: <4e2ff069-e1f5-492f-14eb-5348e2cab907@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Sep 2019 14:10:36 -0700
Message-ID: <CAM_iQpXJzqy2uQ2gq4AmPRyPjtWE6f+6duHo_0yRyoB-4imnEg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix possible crash in tcf_action_destroy()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 8:44 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 9/21/19 7:08 PM, Jakub Kicinski wrote:
> > On Wed, 18 Sep 2019 14:37:21 -0700, Cong Wang wrote:
> >> On Wed, Sep 18, 2019 at 12:57 PM 'Eric Dumazet' via syzkaller
> >> <syzkaller@googlegroups.com> wrote:
> >>>
> >>> If the allocation done in tcf_exts_init() failed,
> >>> we end up with a NULL pointer in exts->actions.
> >> ...
> >>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> >>> index efd3cfb80a2ad775dc8ab3c4900bd73d52c7aaad..9aef93300f1c11791acbb9262dfe77996872eafe 100644
> >>> --- a/net/sched/cls_api.c
> >>> +++ b/net/sched/cls_api.c
> >>> @@ -3027,8 +3027,10 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
> >>>  void tcf_exts_destroy(struct tcf_exts *exts)
> >>>  {
> >>>  #ifdef CONFIG_NET_CLS_ACT
> >>> -       tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
> >>> -       kfree(exts->actions);
> >>> +       if (exts->actions) {
> >>
> >> I think it is _slightly_ better to check exts->nr_actions!=0 here,
> >> as it would help exts->actions!=NULL&& exts->nr_actions==0
> >> cases too.
> >>
> >> What do you think?
> >
> > Alternatively, since tcf_exts_destroy() now takes NULL, and so
> > obviously does kfree() - perhaps tcf_action_destroy() should
> > return early if actions are NULL?
> >
>
> I do not have any preference really, this is slow path and was trying to
> fix a crash.
>
> tcf_action_destroy() makes me nervous, since it seems to be able to break its loop
> in case __tcf_idr_release() returns an error. This means that some actions will
> never be release.

Good point. Seems we can just continue the loop even when
-EPERM is returned, there is in fact no harm to leave those still
bound to filters there until the filers release them. Not sure if we
should still propagate -EPERM to users in this partially failure
case.
