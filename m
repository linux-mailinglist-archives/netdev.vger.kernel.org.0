Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C81823D6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgCKV1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:27:30 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:25270 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgCKV1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:27:30 -0400
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 02BLRBlU030179;
        Thu, 12 Mar 2020 06:27:12 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 02BLRBlU030179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1583962032;
        bh=kbWqPD/5BVvh1Qw3PprVads8y98YV6jmA2+olTbwLms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=18Say0DVwJzy3gpsxMTKW5SkOv+13lGEM7tgb+0qmFhEIyEkRf84WpHoZuotGExam
         l28CjbWiBsjOYYXTXVorUHVhMrd7MzH9Q32umpYDelnuV0sU4A8VADqP1ALhjFP4G0
         mRsBJ5/NDhplezTHmOFa9ArTTcj/4Lg7ADJoKM4fs4JVIMP+8M2AzRfdnusdbRg4hW
         Uy3sDgiK0Zzi9/OYCXPEN273qR3jrQDjsuOQh307z9hswIZ26qEdFPEfVQTPiEGT3R
         5DrFo5wwbv+b6l/JJfDmNeDWI5Rk5H3kl1HLU7aBLvf/0JkU66+W6clD8/mhlFKXD7
         GVevVj14Bht7A==
X-Nifty-SrcIP: [209.85.222.43]
Received: by mail-ua1-f43.google.com with SMTP id v16so228158ual.9;
        Wed, 11 Mar 2020 14:27:12 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3yK2KfmUhOoNwwSbvDgEtB/IG0gXSlwyl6pE9+rO5fgdBTm2xW
        qvvXoRSvmkeh0tB3pNYPcBZMNMJ5gf05C9EIpQo=
X-Google-Smtp-Source: ADFU+vthn3wrUbYgxaw18lalX3Fw7yiaP0FsvMtzVrj2ofhcX57g6NmsivMdiollhWbVip3FO3S0/MuqENwOOl0kuY8=
X-Received: by 2002:ab0:28d8:: with SMTP id g24mr1754195uaq.121.1583962030875;
 Wed, 11 Mar 2020 14:27:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200311062925.5163-1-masahiroy@kernel.org> <20200311093143.GB279080@splinter>
 <20200311104756.GA1972672@hmswarspite.think-freely.org> <20200311112833.GA284417@splinter>
 <20200311173053.GB1972672@hmswarspite.think-freely.org>
In-Reply-To: <20200311173053.GB1972672@hmswarspite.think-freely.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 12 Mar 2020 06:26:34 +0900
X-Gmail-Original-Message-ID: <CAK7LNARSbP-DY5wdXtB0cxHfwgmFYE0QvxYACk8GuMQhTvj_WQ@mail.gmail.com>
Message-ID: <CAK7LNARSbP-DY5wdXtB0cxHfwgmFYE0QvxYACk8GuMQhTvj_WQ@mail.gmail.com>
Subject: Re: [PATCH] net: drop_monitor: use IS_REACHABLE() to guard net_dm_hw_report()
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 2:31 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Wed, Mar 11, 2020 at 01:28:33PM +0200, Ido Schimmel wrote:
> > On Wed, Mar 11, 2020 at 06:47:56AM -0400, Neil Horman wrote:
> > > On Wed, Mar 11, 2020 at 11:31:43AM +0200, Ido Schimmel wrote:
> > > > On Wed, Mar 11, 2020 at 03:29:25PM +0900, Masahiro Yamada wrote:
> > > > > In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.
> > > > >
> > > > > The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
> > > > > from being 'm' when NET_DEVLINK=y.
> > > > >
> > > > > With the planned Kconfig change that relaxes the 'imply', the
> > > > > combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.
> > > > >
> > > > > Use IS_REACHABLE() to avoid the vmlinux link error for this case.
> > > > >
> > > > > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > >
> > > > Thanks, Masahiro.
> > > >
> > > > Neil, Jiri, another option (long term) is to add a raw tracepoint (not
> > > > part of ABI) in devlink and have drop monitor register its probe on it
> > > > when monitoring.
> > > >
> > > > Two advantages:
> > > > 1. Consistent with what drop monitor is already doing with kfree_skb()
> > > > tracepoint
> > > > 2. We can remove 'imply NET_DROP_MONITOR' altogether
> > > >
> > > > What do you think?
> > > >
> > > Agreed, I think I like this implementation better.
> >
> > OK, but I don't want to block Masahiro. I think we can go with his patch
> > and then I'll add the raw tracepoint in the next release.
> >
> Yeah, ok, I can agree with that
> Acked-by: Neil Horman <nhorman@tuxdriver.com>


Thanks, I will insert this patch before the kconfig change
with your Ack.


-- 
Best Regards
Masahiro Yamada
