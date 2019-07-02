Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760905CDFD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 12:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGBKyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 06:54:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46252 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfGBKyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 06:54:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so26784430edr.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 03:54:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+7NprwUDgD3Jl+TFJyEff474B+vHazYLuaUeu+s02Y=;
        b=MeHl4nr8QSa+VxmoFQwuuD9IpE0/2cqEnyjzUqPFCXRDB4NzF9rz8GNusFeUc3Mg6s
         xJeJTlLk3uu0lNhI4ge7RAULz1o4Nk3+QAmol8ZfXCwuZ21zQwrqXKNI6ekaRfKL7/cY
         tnN/8I/GaTsT48g5Fka9mavOoaABLJdrPE/B7uak8BHzXgB9ESsEq32ITpdA8/Xo+xP0
         FLf0zB190qsU58svS5sINfo4zW5EyhFF3Jlx4u9KVSJRJUwWKo0j1mU3wGq0FXGlzQJj
         g8gXPtAMicjLUvSmX9gZGS+8VVyFVXU+a6NbDn7l78+yreG2Tft1mXh+/zREnmHy4Uml
         Ef7Q==
X-Gm-Message-State: APjAAAUt/JI+oQJimPgoPr8DYG9kxY8tlA1F0jg3dIZBY0m94vsSNHf0
        2CEW2xtkx9t2h624OSMdTk7XhaBX8zhshtNk9sWSWw==
X-Google-Smtp-Source: APXvYqztmBOhu52zqIB/Ndg/hD0Tt/DP4YYhG0lcquW3xsdl3e8168KtXn7ftSG186UMeKjmF0uCc5Qf8dWXqyftzqo=
X-Received: by 2002:a17:906:948c:: with SMTP id t12mr7770674ejx.222.1562064889826;
 Tue, 02 Jul 2019 03:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAGWhr0AOApbf4-4RJHibUaKa8MmOfGS+uH6Rx4x1PQGZXRbCOQ@mail.gmail.com>
 <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com>
In-Reply-To: <CAGWhr0Bg3mnaddCg=RexXgUGeP5EyqiU63n_c9NAgyfx-wpJ2Q@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 2 Jul 2019 12:55:38 +0200
Message-ID: <CAPpH65x3_adKR5DfBznwg-6k=ZrTE3EZwGcKziiZx6hqcHkgbA@mail.gmail.com>
Subject: Re: [iproute2] Can't create ip6 tunnel device
To:     Ji Jianwen <jijianwen@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        maheshb@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 12:27 PM Ji Jianwen <jijianwen@gmail.com> wrote:
>
> It seems this issue was introduced by commit below, I am able to run
> the command successfully mentioned at previous mail without it.
>
> commit ba126dcad20e6d0e472586541d78bdd1ac4f1123 (HEAD)
> Author: Mahesh Bandewar <maheshb@google.com>
> Date:   Thu Jun 6 16:44:26 2019 -0700
>
>     ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds
>

From what I can see, before this commit we have in p->name the tunnel
iface name (in Jianwen example, ip6tnl1), while after this p->name
contains the iface name specified after "dev".
Probably the strlcpy() should be limited to the {show|change} cases?

Regards,
Andrea

> On Tue, Jul 2, 2019 at 2:53 PM Ji Jianwen <jijianwen@gmail.com> wrote:
> >
> > Hello  there,
> >
> > I got error when creating ip6 tunnel device on a rhel-8.0.0 system.
> >
> > Here are the steps to reproduce the issue.
> > # # uname -r
> > 4.18.0-80.el8.x86_64
> > # dnf install -y libcap-devel bison flex git gcc
> > # git clone git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> > # cd iproute2  &&  git log --pretty=oneline --abbrev-commit
> > d0272f54 (HEAD -> master, origin/master, origin/HEAD) devlink: fix
> > libc and kernel headers collision
> > ee09370a devlink: fix format string warning for 32bit targets
> > 68c46872 ip address: do not set mngtmpaddr option for IPv4 addresses
> > e4448b6c ip address: do not set home option for IPv4 addresses
> > ....
> >
> > # ./configure && make && make install
> > # ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2
> > local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev eno1   --->
> > please replace eno1 with the network card name of your system
> > add tunnel "ip6tnl0" failed: File exists
> >
> > Please help take a look. Thanks!
> >
> > Br,
> > Jianwen
