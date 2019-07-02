Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A309D5D103
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfGBNvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:51:53 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43682 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGBNvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 09:51:53 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so27336658edr.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 06:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLudlrpcOalpyQuTk+9YokZY4fhFDagQiNLDDBhIjB4=;
        b=N9VBusUGMUlz7UwvsBeT1PYomaix7TJ5AtlgSxIXJ09KBiaw62aG7C7sZbFDyrZwrv
         27+4lu5JayudfHKrfAZ3+4HU+bvbxGsfqG0ldoVyvTMKFepgPEzefRaKCVdLSo+ib4Nk
         rBlgkAr71T8PwR6+kgp21X8sAwJHlku2uKrVkgwv1uBjukmMwA0ZuLE/SQhh1uFVDo97
         JLZJwqecqWnstBxYLgIGxQb5vEaVs7BFhfgR+B7iMbNbZyBNH/vg6BszWyqv5z6bvGsK
         Zq3pQCQcLkp85kgVykxlDLZAOeiaWnV1Y9gMrE3Zj00Am8bZoqMFGotZjs8pqOqQ0ZH1
         VTBg==
X-Gm-Message-State: APjAAAV2VDH+m/H4n1nANCradaTjYcWw8m20N02LJ7+EsTrUZg2pJ/LQ
        fWBOEVk7TXf+S8hTZmACf32v1gE4z9AL1EEcKmLPQg==
X-Google-Smtp-Source: APXvYqy5kLbOKo7/8uE26N8Kgd73dpzTFRZhVT8mXGc0UauFeUhM1sQ9ccXwG4mZ9V4C1vagEDoV0OJ+4py4HQXcpp0=
X-Received: by 2002:a17:906:2101:: with SMTP id 1mr28122559ejt.182.1562075511820;
 Tue, 02 Jul 2019 06:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
 <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com>
 <CAPpH65x3_adKR5DfBznwg-6k=ZrTE3EZwGcKziiZx6hqcHkgbA@mail.gmail.com>
 <CAPpH65z28sN67-4mVvcAt_eX7Q=qtK07OpeABi4-BsTxAGs0ag@mail.gmail.com> <CAGWhr0CmF1Cz0cFE82k=vXCv7-=5Rxd97JcEn173ufU-UbQtxg@mail.gmail.com>
In-Reply-To: <CAGWhr0CmF1Cz0cFE82k=vXCv7-=5Rxd97JcEn173ufU-UbQtxg@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 2 Jul 2019 15:52:40 +0200
Message-ID: <CAPpH65w1xxTheE5_suumNePPfU8+qKVnDR8h7q2F6-L+zEeBgg@mail.gmail.com>
Subject: Re: [iproute2] Can't create ip6 tunnel device
To:     Ji Jianwen <jijianwen@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 3:11 PM Ji Jianwen <jijianwen@gmail.com> wrote:
>
> It works for 'add', but not for 'del'.
> ip -6 tunnel del my_ip6ip6 mode ip6ip6 remote 2001:db8:ffff:100::2
> local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1
> delete tunnel "eno1" failed: Operation not supported
>

Thanks Jianwen, this is kinda expected, since I left out the
SIOCDELTUNNEL case in my code.

While this can be easily fixed, the intent of the offending patch is
not entirely clear to me.

From the ip tunnel man page, I can read that with "dev NAME" we
instruct ip to bind the tunnel to the device NAME; so dev should not
be used to indicate the tunnel, as the offending commit does.
Moreover, man page states that "ip tunnel show" has no arguments. So,
either we update the man page fixing this obsolete statement, or the
"show dev NAME" case is not supported at all.
However, even if "show" command supports filter (as it seems to do),
in my opinion "dev NAME" should be used to filter tunnels based on the
device to which they are binded.

Mahesh, can you please clarify?

Regards,
Andrea

> On Tue, Jul 2, 2019 at 7:18 PM Andrea Claudi <aclaudi@redhat.com> wrote:
> >
> > On Tue, Jul 2, 2019 at 12:55 PM Andrea Claudi <aclaudi@redhat.com> wrote:
> > >
> > > On Tue, Jul 2, 2019 at 12:27 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> > > >
> > > > It seems this issue was introduced by commit below, I am able to run
> > > > the command successfully mentioned at previous mail without it.
> > > >
> > > > commit ba126dcad20e6d0e472586541d78bdd1ac4f1123 (HEAD)
> > > > Author: Mahesh Bandewar <maheshb@google.com>
> > > > Date:   Thu Jun 6 16:44:26 2019 -0700
> > > >
> > > >     ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds
> > > >
> > >
> > > From what I can see, before this commit we have in p->name the tunnel
> > > iface name (in Jianwen example, ip6tnl1), while after this p->name
> > > contains the iface name specified after "dev".
> > > Probably the strlcpy() should be limited to the {show|change} cases?
> > >
> > > Regards,
> > > Andrea
> > >
> > > > On Tue, Jul 2, 2019 at 2:53 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> > > > >
> > > > > Hello  there,
> > > > >
> > > > > I got error when creating ip6 tunnel device on a rhel-8.0.0 system.
> > > > >
> > > > > Here are the steps to reproduce the issue.
> > > > > # # uname -r
> > > > > 4.18.0-80.el8.x86_64
> > > > > # dnf install -y libcap-devel bison flex git gcc
> > > > > # git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> > > > > # cd iproute2  &&  git log --pretty=oneline --abbrev-commit
> > > > > d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
> > > > > libc and kernel headers collision
> > > > > ee09370a devlink: fix format string warning for 32bit targets
> > > > > 68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
> > > > > e4448b6c ip address: do not set home option for IPv4 addresses
> > > > > ....
> > > > >
> > > > > # ./configure && make && make install
> > > > > # ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
> > > > > local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
> > > > > please replace eno1 with the network card name of your system
> > > > > add tunnel "ip6tnl0" failed: File exists
> > > > >
> > > > > Please help take a look. Thanks!
> > > > >
> > > > > Br,
> > > > > Jianwen
> >
> > Jianwen, can you please check if this patch solves your issue?
> >
> > --- a/ip/ip6tunnel.c
> > +++ b/ip/ip6tunnel.c
> > @@ -298,7 +298,7 @@ static int parse_args(int argc, char **argv, int
> > cmd, struct ip6_tnl_parm2 *p)
> >                 p->link = ll_name_to_index(medium);
> >                 if (!p->link)
> >                         return nodev(medium);
> > -               else
> > +               else if (cmd != SIOCADDTUNNEL)
> >                         strlcpy(p->name, medium, sizeof(p->name));
> >         }
> >         return 0;
> >
> > Thanks in advance!
