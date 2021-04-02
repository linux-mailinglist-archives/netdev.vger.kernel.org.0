Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11093530FD
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 00:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhDBWNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 18:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBWNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 18:13:15 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401D6C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 15:13:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t140so4286293pgb.13
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 15:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qcus6E8nI2Gb3E5Bv+IBE8ZgmMhxjYym0nRLWeXmve8=;
        b=fj3PshRC7ZxWQlpNZFos+svF8kTSEZrWVaZZpTWqR96Ra7B+aLdoLho7EIxrW3gyC3
         /3By5mSoyJt7qdAOrWq6ZCA6HDpUNEy9FWZ8yliKVdefV746cES0ycFxr3bHPRc6UBBV
         zYrYXf4UJdPOVALaDdjhjuDX4hc5ZkVQy40Mu9klz5jH5QsQdCAwt5SdssfPsFEvOwHw
         94XIxeccVQgGGieANtz9gRP3pS/oX0ZP+EZ7hNEqeJ7y3dl3H52DAeP/9d5xamr/gG6q
         Qwktj4XtveYdcbL9k4mASAqSxtv3ELbSUq1Y6Na8W5oiETg3qi0xYzT6t4BG+CJzSrvq
         kXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qcus6E8nI2Gb3E5Bv+IBE8ZgmMhxjYym0nRLWeXmve8=;
        b=GzTxF2NxIEdB1OEcYLj/eDFjizf7FWDD+l+pU1AlXoSdvSmzfQVBnvTzV1M0iCy4jK
         4NsAEpDKdYleLE1zlhSeg63c9Te8Lb3rGJYIvWru2jIMuOVOkyNURbLo+VV2bUrCNsLH
         mOLKB5YbpBXAhNcSkiO3VC7gj7pcB04SQs+MVIojHQmbiX/Q/+gqGcmR2tdNjJbMThmC
         6iNHt+wSzOLST0ziqN4S6LWi1KOb6CM+ueg57gxDKzzfQ/nkPohEf9KgLb+6OrrOpHp+
         pEiLt+uNmTdBe+5sCCRr4/q9ixkAYjx1390SyjDPk/YO0wxiV+O9F78NRvs1rdp/LRql
         c7zg==
X-Gm-Message-State: AOAM533qMHiLiiBx/aavByG1HRS2H1f2slHkHuSIrDOQP4YC4Pvdctc9
        q2dH8cusdNLV8kUIVj23umc7CA5veQExcFiX9ilaMYjcpZ0=
X-Google-Smtp-Source: ABdhPJzdBXfwr8tvwNLdm9hP5WeFBDWGg2QdFHaqutJDuxMTRVbUX/PsthiEriphLPm9LP4h7T2G3fJW/cppLXVjhCA=
X-Received: by 2002:a63:6a41:: with SMTP id f62mr13246996pgc.428.1617401593852;
 Fri, 02 Apr 2021 15:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210331164012.28653-1-vladbu@nvidia.com> <20210331164012.28653-2-vladbu@nvidia.com>
In-Reply-To: <20210331164012.28653-2-vladbu@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 15:13:02 -0700
Message-ID: <CAM_iQpX85rHgUMvwQskEFqa+MRtv5Y_+ZbMnds9xxmaKP=qiOg@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] net: sched: fix action overwrite reference counting
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 9:41 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
> Action init code increments reference counter when it changes an action.
> This is the desired behavior for cls API which needs to obtain action
> reference for every classifier that points to action. However, act API just
> needs to change the action and releases the reference before returning.
> This sequence breaks when the requested action doesn't exist, which causes
> act API init code to create new action with specified index, but action is
> still released before returning and is deleted (unless it was referenced
> concurrently by cls API).

Please also add a summary of how you fix it. From what I understand,
it seems you just skip the refcnt put of successful cases?

One comment below.

>
> Fixes: cae422f379f3 ("net: sched: use reference counting action init")
> Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  include/net/act_api.h |  5 +++--
>  net/sched/act_api.c   | 27 +++++++++++++++++----------
>  net/sched/cls_api.c   |  9 +++++----
>  3 files changed, 25 insertions(+), 16 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 2bf3092ae7ec..312f0f6554a0 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -185,7 +185,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>                     int nr_actions, struct tcf_result *res);
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>                     struct nlattr *est, char *name, int ovr, int bind,
> -                   struct tc_action *actions[], size_t *attr_size,
> +                   struct tc_action *actions[], int init_res[], size_t *attr_size,
>                     bool rtnl_held, struct netlink_ext_ack *extack);
>  struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
>                                          bool rtnl_held,
> @@ -193,7 +193,8 @@ struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
>  struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>                                     struct nlattr *nla, struct nlattr *est,
>                                     char *name, int ovr, int bind,
> -                                   struct tc_action_ops *ops, bool rtnl_held,
> +                                   struct tc_action_ops *a_o, int *init_res,
> +                                   bool rtnl_held,
>                                     struct netlink_ext_ack *extack);
>  int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
>                     int ref, bool terse);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..eb20a75796d5 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -777,8 +777,11 @@ static int tcf_action_put(struct tc_action *p)
>         return __tcf_action_put(p, false);
>  }
>
> -/* Put all actions in this array, skip those NULL's. */
> -static void tcf_action_put_many(struct tc_action *actions[])
> +/* Put all actions in this array, skip those NULL's. If cond array is provided
> + * by caller, then only put actions that match.
> + */
> +static void tcf_action_put_many(struct tc_action *actions[], int *cond,
> +                               int match)
>  {
>         int i;
>
> @@ -786,7 +789,7 @@ static void tcf_action_put_many(struct tc_action *actions[])
>                 struct tc_action *a = actions[i];
>                 const struct tc_action_ops *ops;
>
> -               if (!a)
> +               if (!a || (cond && cond[i] != match))

This looks a bit odd. How about passing an array of action pointers which
only contains those that need to be put?

Thanks.
