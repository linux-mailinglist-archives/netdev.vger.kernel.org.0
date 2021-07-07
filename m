Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EF53BE996
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhGGOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGGOX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:23:29 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2279C061574;
        Wed,  7 Jul 2021 07:20:49 -0700 (PDT)
Date:   Wed, 7 Jul 2021 15:20:43 +0100
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: core: fix SO_TIMESTAMP_* option setting
Message-ID: <20210707152043.46e78f45@zn3>
In-Reply-To: <CANn89iL=uQto2PSNj9Xjt5NFrqKQgVzvYY1T++-Kw_OTfsPwgA@mail.gmail.com>
References: <20210707092731.2499-1-slyfox@gentoo.org>
        <CANn89iL=uQto2PSNj9Xjt5NFrqKQgVzvYY1T++-Kw_OTfsPwgA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Jul 2021 14:32:01 +0200
Eric Dumazet <edumazet@google.com> wrote:

> On Wed, Jul 7, 2021 at 11:27 AM Sergei Trofimovich <slyfox@gentoo.org> wrote:
> >
> > I noticed the problem as a systemd-timesyncd (and ntpsec) sync failures:
> >
> >     systemd-timesyncd[586]: Timed out waiting for reply from ...
> >     systemd-timesyncd[586]: Invalid packet timestamp.
> >
> > Bisected it down to commit 371087aa476
> > ("sock: expose so_timestamp options for mptcp").
> >
> > The commit should be a no-op but it accidentally reordered option type
> > and option value:
> >
> >     +void sock_set_timestamp(struct sock *sk, int optname, bool valbool);
> >     ...
> >     -     __sock_set_timestamps(sk, valbool, true, true);
> >     +     sock_set_timestamp(sk, valbool, optname);
> >
> > Tested the fix on systemd-timesyncd. The sync failures went away.
> >
> > CC: Paolo Abeni <pabeni@redhat.com>
> > CC: Florian Westphal <fw@strlen.de>
> > CC: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > CC: David S. Miller <davem@davemloft.net>
> > CC: Jakub Kicinski <kuba@kernel.org>
> > CC: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > ---  
> 
> I think this has been fixed five days ago in
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=81b4a0cc7565b08cadd0d02bae3434f127d1d72a

Aha, looks good! Thank you!

-- 

  Sergei
