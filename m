Return-Path: <netdev+bounces-7099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B821719F0C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED31128172E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2979E21CD7;
	Thu,  1 Jun 2023 14:06:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E948C21CC9
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA87C4339B;
	Thu,  1 Jun 2023 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685628406;
	bh=jo+kQRmaMsGk8ilFDIPDe218c8Tetx9OvbItrHEqoYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l7jX3PMgpRa2WwIfC0tf5h8YCO3IO9p9e/4e8d8da94t0pAlDlQzhZbrmZvAS4OVt
	 jKJGsiItamIF78bDAdpNSxVF/uFzsxc23LkOb1Nkzq/7Hgnkuo0LJT7SYxUSE93L0Y
	 vuRpWEFlFBxrRwQcDBb8Mtu5N8FpvHJFbPt5CZZw0YATtIzFB8+X48XLITlt19lFuU
	 PHDnKzvz38VWHDHPYWKtkv4zy4dppE5MgVVnw0Sn0tGaF8rT3wRHluNTEwmaVPQ1tC
	 0YicaiD+JNkUSIm3X5rmcaw5Tnp16fWZw8Tdtiy6KkBbsGW6eoW3jZcVq3kd3Pvvqn
	 xY5yRd6zi5Ylg==
Date: Thu, 1 Jun 2023 15:06:40 +0100
From: Lee Jones <lee@kernel.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>, Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>, xiyou.wangcong@gmail.com,
	jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
Message-ID: <20230601140640.GG449117@google.com>
References: <20230531141556.1637341-1-lee@kernel.org>
 <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
 <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMnUgXsr4UBeZR57vPpc5WRJkbWUFsii90jXJ=stoXCGcg@mail.gmail.com>

On Wed, 31 May 2023, Jamal Hadi Salim wrote:

> On Wed, May 31, 2023 at 11:03 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, May 31, 2023 at 4:16 PM Lee Jones <lee@kernel.org> wrote:
> > >
> > > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > > immediately return without decrementing the recently incremented
> > > reference counter.  If this happens enough times, the counter will
> > > rollover and the reference freed, leading to a double free which can be
> > > used to do 'bad things'.
> > >
> > > Cc: stable@kernel.org # v4.14+
> >
> > Please add a Fixes: tag.

Why?

From memory, I couldn't identify a specific commit to fix, which is why
I used a Cc tag as per the Stable documentation:

Option 1
********

To have the patch automatically included in the stable tree, add the tag

.. code-block:: none

     Cc: stable@vger.kernel.org

in the sign-off area. Once the patch is merged it will be applied to
the stable tree without anything else needing to be done by the author
or subsystem maintainer.

> > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > ---
> > >  net/sched/cls_u32.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > > index 4e2e269f121f8..fad61ca5e90bf 100644
> > > --- a/net/sched/cls_u32.c
> > > +++ b/net/sched/cls_u32.c
> > > @@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
> > >         if (tb[TCA_U32_INDEV]) {
> > >                 int ret;
> > >                 ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
> >
> > This call should probably be done earlier in the function, next to
> > tcf_exts_validate_ex()
> >
> > Otherwise we might ask why the tcf_bind_filter() does not need to be undone.
> >
> > Something like:
> >
> > diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> > index 4e2e269f121f8a301368b9783753e055f5af6a4e..ac957ff2216ae18bcabdd3af3b0e127447ef8f91
> > 100644
> > --- a/net/sched/cls_u32.c
> > +++ b/net/sched/cls_u32.c
> > @@ -718,13 +718,18 @@ static int u32_set_parms(struct net *net, struct
> > tcf_proto *tp,
> >                          struct nlattr *est, u32 flags, u32 fl_flags,
> >                          struct netlink_ext_ack *extack)
> >  {
> > -       int err;
> > +       int err, ifindex = -1;
> >
> >         err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
> >                                    fl_flags, extack);
> >         if (err < 0)
> >                 return err;
> >
> > +       if (tb[TCA_U32_INDEV]) {
> > +               ifindex = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
> > +               if (ifindex < 0)
> > +                       return -EINVAL;
> > +       }

Thanks for the advice.  Leave it with me.

> >         if (tb[TCA_U32_LINK]) {
> >                 u32 handle = nla_get_u32(tb[TCA_U32_LINK]);
> >                 struct tc_u_hnode *ht_down = NULL, *ht_old;
> > @@ -759,13 +764,9 @@ static int u32_set_parms(struct net *net, struct
> > tcf_proto *tp,
> >                 tcf_bind_filter(tp, &n->res, base);
> >         }
> >
> > -       if (tb[TCA_U32_INDEV]) {
> > -               int ret;
> > -               ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
> > -               if (ret < 0)
> > -                       return -EINVAL;
> > -               n->ifindex = ret;
> > -       }
> > +       if (ifindex >= 0)
> > +               n->ifindex = ifindex;
> > +
> 
> I guess we crossed paths ;->

> Please, add a tdc test as well - it doesnt have to be in this patch,
> can be a followup.

I don't know how to do that, or even what a 'tdc' is.  Is it trivial?

Can you point me towards the documentation please?

-- 
Lee Jones [李琼斯]

