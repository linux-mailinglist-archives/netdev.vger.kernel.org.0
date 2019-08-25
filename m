Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEC89C4EF
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfHYQvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 12:51:46 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56037 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbfHYQvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 12:51:46 -0400
X-Originating-IP: 209.85.217.53
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (Authenticated sender: pshelar@ovn.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B1AA960007
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 16:51:43 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id y16so9429813vsc.3
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 09:51:43 -0700 (PDT)
X-Gm-Message-State: APjAAAXi4LK/+oVYoG012iFAvh/qE8Pdd9lIHi3eMF/8RVvUsq0X+Q7A
        Ff5iQmQV77TuoO8LxT9SXnMrvAbe5MK182XSdsA=
X-Google-Smtp-Source: APXvYqydFW6fQ4uF5AMCj6dUVXmdzhAImSFFseg6yQ9SK5d4pRK0JPmuC1ie01srVx8wLxug2uCb5LCAACsuq4zEsFM=
X-Received: by 2002:a67:e24d:: with SMTP id w13mr7823521vse.58.1566751902514;
 Sun, 25 Aug 2019 09:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <1566505070-38748-1-git-send-email-yihung.wei@gmail.com>
 <CAOrHB_A6Hn9o=8uzHQTp=cttMQsf=dYpobvq7C7_W398sw8UJA@mail.gmail.com> <CAG1aQhLkrvVADEtAFcdO+GX03SGx7GMW1YyLVTGrPjiCz1HMyQ@mail.gmail.com>
In-Reply-To: <CAG1aQhLkrvVADEtAFcdO+GX03SGx7GMW1YyLVTGrPjiCz1HMyQ@mail.gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sun, 25 Aug 2019 09:53:46 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BUVRYXV4fHbgTavUTWHKbA-xz+TbzSjzCrtVa+NkgrEQ@mail.gmail.com>
Message-ID: <CAOrHB_BUVRYXV4fHbgTavUTWHKbA-xz+TbzSjzCrtVa+NkgrEQ@mail.gmail.com>
Subject: Re: [PATCH net v2] openvswitch: Fix conntrack cache with timeout
To:     Yi-Hung Wei <yihung.wei@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 9:40 AM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
>
> On Thu, Aug 22, 2019 at 11:51 PM Pravin Shelar <pshelar@ovn.org> wrote:
> >
> > On Thu, Aug 22, 2019 at 1:28 PM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
> > >
> > > This patch addresses a conntrack cache issue with timeout policy.
> > > Currently, we do not check if the timeout extension is set properly in the
> > > cached conntrack entry.  Thus, after packet recirculate from conntrack
> > > action, the timeout policy is not applied properly.  This patch fixes the
> > > aforementioned issue.
> > >
> > > Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> > > ---
> > > v1->v2: Fix rcu dereference issue reported by kbuild test robot.
> > > ---
> > >  net/openvswitch/conntrack.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> > > index 848c6eb55064..4d7896135e73 100644
> > > --- a/net/openvswitch/conntrack.c
> > > +++ b/net/openvswitch/conntrack.c
> > > @@ -1657,6 +1666,10 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
> > >                                       ct_info.timeout))
> > >                         pr_info_ratelimited("Failed to associated timeout "
> > >                                             "policy `%s'\n", ct_info.timeout);
> > > +               else
> > > +                       ct_info.nf_ct_timeout = rcu_dereference(
> > > +                               nf_ct_timeout_find(ct_info.ct)->timeout);
> > Is this dereference safe from NULL pointer?
>
> Hi Pravin,
>
> Thanks for your review.  I am not sure if
> nf_ct_timeout_find(ct_info.ct) will return NULL in this case.
>
> We only run into this statement when ct_info.timeout[0] is set, and it
> is only set in parse_ct() when CONFIG_NF_CONNTRACK_TIMEOUT is
> configured.  Also, in this else condition the timeout extension is
> supposed to be set properly by nf_ct_set_timeout().
>

Sounds good.
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
