Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEBC1FADA1
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgFPKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:13:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20672 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726052AbgFPKNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592302385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sl3LD/rN1iOztK/aRWc8fZxwrKmlZvGDsvlVzKYcl9k=;
        b=jFeSPHiYImKk1vpLvwlp9gzh/36nzSN8luKqGhamH99HsPesOQi4HWIVQQMNoZSrm87BMU
        OYJrTBlcDwLFJJLByn5K8KEvlsjjkM/4e1ze7qbkmeM5a1yCN8DrZIDDzCtRCbrgttVMza
        yeXQD+R2922RhiCBjEN25XULe+xRcJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-QcA-qDcvNKy7Hlc5mfO7zg-1; Tue, 16 Jun 2020 06:13:03 -0400
X-MC-Unique: QcA-qDcvNKy7Hlc5mfO7zg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41641100CCC8;
        Tue, 16 Jun 2020 10:13:02 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC02160C80;
        Tue, 16 Jun 2020 10:13:00 +0000 (UTC)
Message-ID: <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of
 the periodic timer
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
References: <cover.1592247564.git.dcaratti@redhat.com>
         <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
         <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 16 Jun 2020 12:12:59 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Vladimir,

thanks a lot for reviewing this.

On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:

[...]

> > diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> > index 6775ccf355b0..3c529a4bcca5 100644
> > --- a/net/sched/act_gate.c
> > +++ b/net/sched/act_gate.c
> > @@ -272,6 +272,27 @@ static int parse_gate_list(struct nlattr *list_attr,
> >         return err;
> >  }
> > 
> > +static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> > +                            enum tk_offsets tko, s32 clockid,
> > +                            bool do_init)
> > +{
> > +       if (!do_init) {
> > +               if (basetime == gact->param.tcfg_basetime &&
> > +                   tko == gact->tk_offset &&
> > +                   clockid == gact->param.tcfg_clockid)
> > +                       return;
> > +
> > +               spin_unlock_bh(&gact->tcf_lock);
> > +               hrtimer_cancel(&gact->hitimer);
> > +               spin_lock_bh(&gact->tcf_lock);
> 
> I think it's horrible to do this just to get out of atomic context.
> What if you split the "replace" functionality of gate_setup_timer into
> a separate gate_cancel_timer function, which you could call earlier
> (before taking the spin lock)? 

I think it would introduce the following 2 problems:

problem #1) a race condition, see below:

> That change would look like this:
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 3c529a4bcca5..47c625a0e70c 100644
> --- a/net/sched/act_gate.c
> +++ b/net/sched/act_gate.c
> @@ -273,19 +273,8 @@ static int parse_gate_list(struct nlattr *list_attr,
>  }
> 
>  static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> -                 enum tk_offsets tko, s32 clockid,
> -                 bool do_init)
> +                 enum tk_offsets tko, s32 clockid)
>  {
> -    if (!do_init) {
> -        if (basetime == gact->param.tcfg_basetime &&
> -            tko == gact->tk_offset &&
> -            clockid == gact->param.tcfg_clockid)
> -            return;
> -
> -        spin_unlock_bh(&gact->tcf_lock);
> -        hrtimer_cancel(&gact->hitimer);
> -        spin_lock_bh(&gact->tcf_lock);
> -    }
>      gact->param.tcfg_basetime = basetime;
>      gact->param.tcfg_clockid = clockid;
>      gact->tk_offset = tko;
> @@ -293,6 +282,17 @@ static void gate_setup_timer(struct tcf_gate
> *gact, u64 basetime,
>      gact->hitimer.function = gate_timer_func;
>  }
> 
> +static void gate_cancel_timer(struct tcf_gate *gact, u64 basetime,
> +                  enum tk_offsets tko, s32 clockid)
> +{
> +    if (basetime == gact->param.tcfg_basetime &&
> +        tko == gact->tk_offset &&
> +        clockid == gact->param.tcfg_clockid)
> +        return;
> +
> +    hrtimer_cancel(&gact->hitimer);
> +}
> +

the above function either cancels a timer, or does nothing: it depends on
the value of the 3-ple {tcfg_basetime, tk_offset, tcfg_clockid}. If we run
this function without holding tcf_lock, nobody will guarantee that
{tcfg_basetime, tk_offset, tcfg_clockid} is not being concurrently
rewritten by some other command like:

# tc action replace action gate <parameters> index <x>

>  static int tcf_gate_init(struct net *net, struct nlattr *nla,
>               struct nlattr *est, struct tc_action **a,
>               int ovr, int bind, bool rtnl_held,
> @@ -381,6 +381,8 @@ static int tcf_gate_init(struct net *net, struct
> nlattr *nla,
>      gact = to_gate(*a);
>      if (ret == ACT_P_CREATED)
>          INIT_LIST_HEAD(&gact->param.entries);
> +    else
> +        gate_cancel_timer(gact, basetime, tk_offset, clockid);
> 

IOW, the above line is racy unless we do spin_lock()/spin_unlock() around
the

if (<expression depending on gact-> members>)
	return; 

statement before hrtimer_cancel(), which does not seem much different
than what I did in gate_setup_timer().

[...]

> @@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
> >         if (goto_ch)
> >                 tcf_chain_put_by_act(goto_ch);
> >  release_idr:
> > +       /* action is not in: hitimer can be inited without taking tcf_lock */
> > +       if (ret == ACT_P_CREATED)
> > +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> > +                                gact->tk_offset, gact->param.tcfg_clockid,
> > +                                true);

please note, here I felt the need to add a comment, because when ret ==
ACT_P_CREATED the action is not inserted in any list, so there is no
concurrent writer of gact-> members for that action.

> >         tcf_idr_release(*a, bind);
> >         return err;
> >  }

problem #2) a functional issue that originates in how 'cycle_time' and
'entries' are validated (*). See below:

On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:

> static int tcf_gate_init(struct net *net, struct nlattr *nla,
>               struct nlattr *est, struct tc_action **a,
>               int ovr, int bind, bool rtnl_held,
> @@ -381,6 +381,8 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>      gact = to_gate(*a);
>      if (ret == ACT_P_CREATED)
>          INIT_LIST_HEAD(&gact->param.entries);
> +    else
> +        gate_cancel_timer(gact, basetime, tk_offset, clockid);

here you propose to cancel the timer, but few lines after we have this:

385         err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
386         if (err < 0)
387                 goto release_idr;
388 

so, when users try the following commands:

# tc action add action gate <good parameters> index 2
# tc action replace action gate <other good parameters> goto chain 42 index 2

and chain 42 does not exist, the second command will fail. But the timer
is erroneously stopped, and never started again. So, the first rule is
correctly inserted but it becomes no more functional after users try to
replace it with another one having invalid control action.

Moving the call to gate_cancel_timer() after the validation of the control
action will not fix this problem, because 'cycle_time' and 'entries' are
validated together, and with the spinlock taken. Because of this, we need
to cancel that timer only when we know that we will not do
tcf_idr_release() and return some error to the user.

please let me know if you think my doubts are not well-founded.

-- 
davide

(*) now that I see parse_gate_list() again, I noticed another potential
issue with replace (that I need to verify first): apparently the list is
not replaced, it's just "updated" with new entries appended at the end. I
will try to write a fix for that (separate from this series).


