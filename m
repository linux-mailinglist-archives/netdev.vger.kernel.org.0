Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD0DD0AF
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394417AbfJRUz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:55:59 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:52407 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388245AbfJRUz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:55:59 -0400
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0DB84200004
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 20:55:56 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id l13so2200578uap.8
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:55:56 -0700 (PDT)
X-Gm-Message-State: APjAAAUQCSuqD1XEqImmj8zO74fxWeDPmThBOZgNCjA3xV03foQ8Uah0
        2n/OIGtGrJrgJ+Bo+1ayDxTuOeDb3GpehmdA5mY=
X-Google-Smtp-Source: APXvYqwuV7U8L7yXvN6rvBzOiZ4ydKwky8zI0+wim0KE/FDrmzjP869Y9izMXBJg65+T1desj253aIpXemkzRPx1gE0=
X-Received: by 2002:ab0:60d2:: with SMTP id g18mr6472598uam.64.1571432155545;
 Fri, 18 Oct 2019 13:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
 <CAOrHB_Dfoy3hiVVWu7+4fgm_U+rcB_CPuRV58XqB7kKOBcGb1w@mail.gmail.com> <20191013222231.GA4647@linux.home>
In-Reply-To: <20191013222231.GA4647@linux.home>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Fri, 18 Oct 2019 13:55:46 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DrnQ4NX=SkE_gwBL_LnamRCGqY_YB-_8VZNscPKiELcw@mail.gmail.com>
Message-ID: <CAOrHB_DrnQ4NX=SkE_gwBL_LnamRCGqY_YB-_8VZNscPKiELcw@mail.gmail.com>
Subject: Re: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jesse Gross <jesse@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 3:22 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Sun, Oct 13, 2019 at 12:09:43PM -0700, Pravin Shelar wrote:
> > On Thu, Oct 10, 2019 at 12:07 PM Guillaume Nault <gnault@redhat.com> wrote:
> > >
> > > In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
> > > rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
> > > but there are a few paths calling rtnl_net_notifyid() from atomic
> > > context or from RCU critical section. The later also precludes the use
> > > of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
> > > call is wrong too, as it uses GFP_KERNEL unconditionally.
> > >
> > > Therefore, we need to pass the GFP flags as parameter. The problem then
> > > propagates recursively to the callers until the proper flags can be
> > > determined. The problematic call chains are:
> > >
> > >  * ovs_vport_cmd_fill_info -> peernet2id_alloc -> rtnl_net_notifyid
> > >
> > >  * rtnl_fill_ifinfo -> rtnl_fill_link_netnsid -> peernet2id_alloc
> > >  -> rtnl_net_notifyid
> > >
> > > For openvswitch, ovs_vport_cmd_get() and ovs_vport_cmd_dump() prevent
> > > ovs_vport_cmd_fill_info() from using GFP_KERNEL. It'd be nice to move
> > > the call out of the RCU critical sections, but struct vport doesn't
> > > have a reference counter, so that'd probably require taking the ovs
> > > lock. Also, I don't get why ovs_vport_cmd_build_info() used GFP_ATOMIC
> > > in nlmsg_new(). I've changed it to GFP_KERNEL for consistency, as this
> > > functions seems to be allowed to sleep (as stated in the comment, it's
> > > called from a workqueue, under the protection of a mutex).
> > >
> > It is safe to change GFP flags to GFP_KERNEL in ovs_vport_cmd_build_info().
> > The patch looks good to me.
> >
> Thanks for your feedback.
>
> The point of my RFC is to know if it's possible to avoid all these
> gfp_t flags, by allowing ovs_vport_cmd_fill_info() to sleep (at least
> I'd like to figure out if it's worth spending time investigating this
> path).
>
> To do so, we'd requires moving the ovs_vport_cmd_fill_info() call of
> ovs_vport_cmd_{get,dump}() out of RCU critical section. Since we have
> no reference counter, I believe we'd have to protect these calls with
> ovs_lock() instead of RCU. Is that acceptable? If not, is there any
> other way?

I do not see point of added complexity and serialized OVS flow dumps
just to avoid GFP_ATOMIC allocations in some code path. What is issue
passing the parameter as you have done in this patch?
