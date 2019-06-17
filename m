Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E038449519
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbfFQWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:21:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42123 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfFQWVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:21:33 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so7712811lfh.9
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5mPSV3kyTwtgpybI0HKNu1XZ3D8EPuA9Erkanqd/n+w=;
        b=PyFscf0MFwlk8MlDKNJDWQugATysW1Jo6BK6RPvqoIE9YtfquXietVQ0IwYmM0YKqm
         a6vsNkF8mIB/AZtAVqMcZBKIZxJ5uvReZaF02SvHvG9mp+vhcAHsPT+tbrRlfbzf+6tn
         xc6Sf11wjV08ofaiKv+3kcHZf41IZk1RTNg/BvlVE1y6q/fZjwceTcfY0a6MS+UZheS5
         dSaDVBKen2gdM5yqGljDpN9Sm+bmKjp1G2VIWv27k3Si/jOsAalPIDi7quPh4e7QB2VA
         Z/QCzyNvxtijy/rwC3lbIiOqM+hj8pwq3gcXoRCtVRa5FqP8Khx/DQom072kusWfytiJ
         RnAw==
X-Gm-Message-State: APjAAAXqmsi6dXt0krRdnmqVZ87htBEyO/IzFi9Zm41swZ8qQ0d08Jej
        Q0SBsu/y09dPhC/iTrqYt0Uv/C+FIv9JJ+I9M7HU6Q==
X-Google-Smtp-Source: APXvYqx7k6av5je0eXM8aUbVEDtTtEG0WI/+B1DvmWdRzJBCLyx/v25vhKS7D0JFo+pvx2lwhyGCHYrBrb9tnbp4moI=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr12842794lft.132.1560810091186;
 Mon, 17 Jun 2019 15:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190611161031.12898-1-mcroce@redhat.com> <11cdc79f-a8c9-e41f-ac4d-4906b358e845@gmail.com>
 <CAGnkfhwH-4+Ov+QRBZaQaHnnbTczpavuV8_yJBg=GOHSLD0pQw@mail.gmail.com>
In-Reply-To: <CAGnkfhwH-4+Ov+QRBZaQaHnnbTczpavuV8_yJBg=GOHSLD0pQw@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 18 Jun 2019 00:20:55 +0200
Message-ID: <CAGnkfhz940SbWpKau0j13rzqH7Zw7BKTStuCcSeg9EQBLeaEOg@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 4:06 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 4:36 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 6/11/19 10:10 AM, Matteo Croce wrote:
> > > Refactor the netns and ipvrf code so less steps are needed to exec commands
> > > in a netns or a VRF context.
> > > Also remove some code which became dead. bloat-o-meter output:
> > >
> >
> > This breaks the vrf reset after namespace switch
> >
> >
> > # ip vrf ls
> > Name              Table
> > -----------------------
> > red               1001
> >
> > Set shell into vrf red context:
> > # ip vrf exec red bash
> >
> > Add new namespace and do netns exec:
> > # ip netns  add foo
> > # ./ip netns exec foo bash
> >
> > Check the vrf id:
> > # ip vrf id
> > red
> >
> > With the current command:
> > # ip netns exec foo bash
> > # ip vrf id
> > <nothing - no vrf bind>
>
> Hi David,
>
> if the vrf needs to be reset after a netns change, why don't we do in
> netns_switch()?
> This way all code paths will be covered.
>
> Cheers,
> --
> Matteo Croce
> per aspera ad upstream

Hi David,

I looked for every occourrence of netns_switch():

bridge/bridge.c:                        if (netns_switch(argv[1]))
include/namespace.h:int netns_switch(char *netns);
ip/ip.c:                        if (netns_switch(argv[1]))
ip/ipnetns.c:   if (netns_switch(argv[0]))
lib/namespace.c:int netns_switch(char *name)
lib/utils.c:    if (netns_switch(nsname))
misc/ss.c:                      if (netns_switch(optarg))
tc/tc.c:                        if (netns_switch(argv[1]))

the ones in {ss,tc,bridge,ip}.c are obviously handling the '-n netns'
command line option.
my question here is: should the VRF association be reset in all these cases?
If we need to reset, we should really call vrf_reset() from netns_switch().
If don't, I can add the missing vrf_reset() in ipnetns.c but I'm
curious to know what can happen to change netns and keep VRF
associations belonging to another netns.

Regards,
-- 
Matteo Croce
per aspera ad upstream
