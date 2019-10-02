Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25BC4974
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfJBI1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:27:37 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39340 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfJBI1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 04:27:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A44DC20571;
        Wed,  2 Oct 2019 10:27:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IgdF7cTA5Xsj; Wed,  2 Oct 2019 10:27:34 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 26C502026E;
        Wed,  2 Oct 2019 10:27:34 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 2 Oct 2019
 10:27:33 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4DD1A3180089;
 Wed,  2 Oct 2019 10:27:33 +0200 (CEST)
Date:   Wed, 2 Oct 2019 10:27:33 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
Message-ID: <20191002082733.GR2879@gauss3.secunet.de>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com>
 <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
 <20190930062427.GF2879@gauss3.secunet.de>
 <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
 <20191001061816.GP2879@gauss3.secunet.de>
 <CA+FuTSdTDAG95XCc8qcb7pJJn_6HuxCrCJnta+sJZa7Bi9x6tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSdTDAG95XCc8qcb7pJJn_6HuxCrCJnta+sJZa7Bi9x6tw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 08:43:05AM -0400, Willem de Bruijn wrote:
> On Tue, Oct 1, 2019 at 2:18 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Mon, Sep 30, 2019 at 11:26:55AM -0400, Willem de Bruijn wrote:
> > >
> > > Instead, how about adding a UDP GRO ethtool feature independent of
> > > forwarding, analogous to fraglist GRO? Then both are explicitly under
> > > admin control. And can be enabled by default (either now, or after
> > > getting more data).
> >
> > We could add a protocol specific feature, but what would it mean
> > if UDP GRO is enabled?
> >
> > Would it be enabled for forwarding, and for local input only if there
> > is a GRO capable socket? Or would it be enabled even if there
> > is no GRO capable socket? Same question when UDP GRO is disabled.
> 
> Enable UDP GRO for all traffic if GRO and UDP GRO are set, and only
> then. 

But this means that we would need to enable UDP GRO by default then.
Currently, if an application uses a UDP GRO capable socket, it
can expect that it gets GROed packets without doing any additional
configuration. This would change if we disable it by default.
Unfortunately, enabling UDP GRO by default has the biggest
risk because most applications don't use UDP GRO capable sockets.

The most condervative way would be to leave standard GRO as it is.
But on some workloads standard GRO might be preferable, in
particular on forwarding to a NIC that can do UDP segmentation
in hardware.

> That seems like the easiest to understand behavior to me, and
> gives administrators an opt-out for workloads where UDP GRO causes a
> regression. We cannot realistically turn off all GRO on a mixed
> TCP/UDP workload (like, say, hosting TCP and QUIC).
> 
> > Also, what means enabling GRO then? Enable GRO for all protocols
> > but UDP? Either UDP becomes something special then,
> 
> Yes and true. But it is something special. We don't know whether UDP
> GRO is safe to deploy everywhere.
> 
> Only enabling it for the forwarding case is more conservative, but
> gives no path to enabling it systemwide, is arguably confusing and
> still lacks the admin control to turn off in case of unexpected
> regressions. I do think that for a time this needs to be configurable
> unless you're confident that the forwarding path is such a win that
> no plan B is needed. But especially without fraglist, I'm not sure.

On my tests it was a win on forwarding, but there might be
usecases where it is not. I guess the only way to find this out
is to enable is and wait what happens.

I'm a bit hesitating on adding a feature flag that might be only
temporary usefull. In particular on the background of the talk
that Jesse Brandeburg gave on the LPC last year. Maybe you
remember the slide where he showed the output of
ethtool --show-offloads, it filled the whole page.

> 
> > or we need
> > to create protocol specific features for the other protocols
> > too. Same would apply for fraglist GRO.
> 
> We don't need it for other protocols after the fact, but it's a good
> question: I don't know how it was enabled for them. Perhaps confidence
> was gained based on testing. Or it was enabled for -rc1, no one
> complained and stayed turned on. In which case you could do the same.

Maybe we should go that way to enable it and wait whether somebody
complains. A patch to add the feature flag could be prepared
beforehand for that case.

It is easy to make a suboptimal design decision here, so
some more opinions would be helpfull.

