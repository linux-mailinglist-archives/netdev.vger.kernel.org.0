Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243D41FB102
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgFPMnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 08:43:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54955 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbgFPMnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 08:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592311393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3fYpvcRSbYmZ+sBV/eWTEF4S/6w7cKyAopBZy7FMBM=;
        b=Ht9nEWi6sZSfp44N7Jd8UHq5Am5pxtJAvEQL34n5yrla4spEyxkaWgXx76O0IB3PAqCPRO
        l2yEaOKz9xewkYC/itHHkOt7HoneGwtekagJmOIuFTHc7mFTfDQLQfNJ+t94HUgxJtEBmz
        78wm5bTkv7sT9hy5rz88o9zphPzQdEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-TXfB-LL3OnqgdBG8dq8e2Q-1; Tue, 16 Jun 2020 08:43:02 -0400
X-MC-Unique: TXfB-LL3OnqgdBG8dq8e2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DD11835BAA;
        Tue, 16 Jun 2020 12:43:01 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92C0A7CABA;
        Tue, 16 Jun 2020 12:42:59 +0000 (UTC)
Message-ID: <429bc64106ac69c8291f4466ddbaa2b48b8e16c4.camel@redhat.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of
 the periodic timer
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com>
References: <cover.1592247564.git.dcaratti@redhat.com>
         <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
         <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
         <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
         <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 16 Jun 2020 14:42:58 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-06-16 at 13:38 +0300, Vladimir Oltean wrote:
> Hi Davide,
> 
> On Tue, 16 Jun 2020 at 13:13, Davide Caratti <dcaratti@redhat.com> wrote:
> > hello Vladimir,
> > 
> > thanks a lot for reviewing this.
> > 
> > On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:

[...]

> > > What if you split the "replace" functionality of gate_setup_timer into
> > > a separate gate_cancel_timer function, which you could call earlier
> > > (before taking the spin lock)?
> > 
> > I think it would introduce the following 2 problems:
> >
> > problem #1) a race condition, see below:

[...]

> > > @@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
> > > >         if (goto_ch)
> > > >                 tcf_chain_put_by_act(goto_ch);
> > > >  release_idr:
> > > > +       /* action is not in: hitimer can be inited without taking tcf_lock */
> > > > +       if (ret == ACT_P_CREATED)
> > > > +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> > > > +                                gact->tk_offset, gact->param.tcfg_clockid,
> > > > +                                true);
> > 
> > please note, here I felt the need to add a comment, because when ret ==
> > ACT_P_CREATED the action is not inserted in any list, so there is no
> > concurrent writer of gact-> members for that action.
> > 
> 
> Then please rephrase the comment. I had read it and it still wasn't
> clear at all for me what you were talking about.

something like:

/* action is not yet inserted in any list: it's safe to init hitimer 
 * without taking tcf_lock.
 */

would be ok?

[...]

> I wonder, could you call tcf_gate_cleanup instead of just canceling the
> hrtimer?

not with the current tcf_gate_cleanup() [1] and parse_gate_list() [2],
because it would introduce another bug: 'p->entries' gets cleared on
action overwrite after being successfully created here:

395         if (tb[TCA_GATE_ENTRY_LIST]) {
396                 err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
397                 if (err < 0)
398                         goto chain_put;
399         }


like mentioned earlier, 'hitimer' can not be canceled/re-initialized easily when
tcf_gate_init() still has a possible error path. And in my understanding
'p->entries' must be consistent when the timer is initialized.

IMO, the correct way to handle 'entries' is to:

- populate the list on a local variable, before taking the spinlock and
allocating the IDR

- assign to p->entries after validation is successful (with the spinlock
taken). Same as what was done with 'cycletime' in patch 1/2, but with the
variable initialized (btw, thanks for catching this), and free the old
list in case of action replace

- release the newly allocated list in the error path of tcf_gate_init()

(but again, this would be a fix for 'entries' - not for 'hitimer', so I
plan to work on it as a separate patch, that fits better 'net-next' rather
than 'net').

-- 
davide

[1] https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_gate.c#L450
[2] https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_gate.c#L235

