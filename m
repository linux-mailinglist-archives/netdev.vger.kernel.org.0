Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1456F4A981
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfFRSJd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jun 2019 14:09:33 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35409 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRSJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:09:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so16552012qto.2;
        Tue, 18 Jun 2019 11:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oHj24vcv49o6J15KAKRxHCuXIYgSsjgYc3eEZOnK3fk=;
        b=tQcQ69As5SqfD/1vGLzwiRL0F6PFGXWQQhGNNct46AHQt+KVM4kJkJe9eCC8QKDCSI
         86ODxEiBpgThBMlpUbbX8a8HYRsNSR1QbarY89ZSs32miIK6arxCWhSLtfVK+NUj4Q93
         z9z6BEOECw3ApM4+nO5WJgtZ3Y2g7u3wNQJ4aQdJMz7XxUysPfq5iwr3XgeGW0lmWJhm
         Az5ti351J51onEikochzvgCFq7rnOEMSeGPkyCNl5jCbsUfRn25rGq7k+iUWmxCiE1MW
         Zzrjkjmzn0QZvoJySk2SyyXK1BgLoxuVsA9lkbKJ3LiOe+3FMMjByU12ZIZ9ud9gcH63
         VRsQ==
X-Gm-Message-State: APjAAAWagJJy7Ek3waF9Wx6tlMnxlC9K4DeXk53jLHC/0r2tIBc/Kqpt
        M/TFq0eBSxOvi888M5U6P1nukXOGws8Jl/3NJwg=
X-Google-Smtp-Source: APXvYqzoeNQ+qNXk+Bqr/BBsWwStrS4xCx8wxHWRCYgGKPvM4hp6VttYyVgzD05adAZxSxyf/ZDZB37DLa0Eb9Zc8Eg=
X-Received: by 2002:aed:2bc1:: with SMTP id e59mr81171140qtd.7.1560881371987;
 Tue, 18 Jun 2019 11:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190304204019.2142770-1-arnd@arndb.de> <20190308160441.ler2hs44oaozoq7w@salvia>
 <CAF1oqRAuk7h2Z2iheq3Ze1vTMNWLf5HHn83fZt07hXA4nOPbAg@mail.gmail.com>
In-Reply-To: <CAF1oqRAuk7h2Z2iheq3Ze1vTMNWLf5HHn83fZt07hXA4nOPbAg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 20:09:15 +0200
Message-ID: <CAK8P3a2Go0=9wMfOvdw+GGRNqNZ9c2TJy=jN6dB1VR3K8qz-rg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix IPV6 dependency
To:     =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 8, 2019 at 5:23 PM Alin Năstac <alin.nastac@gmail.com> wrote:

> On Fri, Mar 8, 2019 at 5:04 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 04, 2019 at 09:40:12PM +0100, Arnd Bergmann wrote:
> > > With CONFIG_IPV6=m and CONFIG_NF_CONNTRACK_SIP=y, we now get a link failure:
> > >
> > > net/netfilter/nf_conntrack_sip.o: In function `process_sdp':
> > > nf_conntrack_sip.c:(.text+0x4344): undefined reference to `ip6_route_output_flags'
> >
> > I see. We can probably use nf_route() instead.
> >
> > Or if needed, use struct nf_ipv6_ops for this.
> >
> >         if (v6ops)
> >                 ret = v6ops->route_xyz(...);
> >
> > @Alin: Would you send us a patch to do so to fix a3419ce3356cf1f
> > netfilter: nf_conntrack_sip: add sip_external_media logic".
>
> nf_ip6_route(net, &dst, &fl6, false) seems to be appropriate.
> I'll send the patch Monday.

I see the original bug I reported is still there. Can you send that patch
you had planned to do?

       Arnd
