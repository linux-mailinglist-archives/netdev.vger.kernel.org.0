Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43589C2D5C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 08:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbfJAGST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 02:18:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48030 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729457AbfJAGST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 02:18:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 649CF200AC;
        Tue,  1 Oct 2019 08:18:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5Z0-dVSthMg6; Tue,  1 Oct 2019 08:18:16 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E7A9520536;
        Tue,  1 Oct 2019 08:18:16 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 1 Oct 2019
 08:18:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 97643318002D;
 Tue,  1 Oct 2019 08:18:16 +0200 (CEST)
Date:   Tue, 1 Oct 2019 08:18:16 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
Message-ID: <20191001061816.GP2879@gauss3.secunet.de>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com>
 <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
 <20190930062427.GF2879@gauss3.secunet.de>
 <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:26:55AM -0400, Willem de Bruijn wrote:
> On Mon, Sep 30, 2019 at 2:24 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Mon, Sep 23, 2019 at 08:38:56AM -0400, Willem de Bruijn wrote:
> > >
> > > The UDP GRO benchmarks were largely positive, but not a strict win if
> > > I read Paolo's previous results correctly. Even if enabling to by
> > > default, it probably should come with a sysctl to disable for specific
> > > workloads.
> >
> > Maybe we can just keep the default for the local input path
> > as is and enable GRO as this:
> >
> > For standard UDP GRO on local input, do GRO only if a GRO enabled
> > socket is found.
> >
> > If there is no local socket found and forwarding is enabled,
> > assume forwarding and do standard GRO.
> >
> > If fraglist GRO is enabled, do it as default on local input and
> > forwarding because it is explicitly configured.
> >
> > Would such a policy make semse?
> 
> Making the choice between fraglist or non-fraglist GRO explicitly
> configurable sounds great. Per device through ethtool over global
> sysctl, too.
> 
> My main concern is not this patch, but 1/5 that enables UDP GRO by
> default. There should be a way to disable it, at least.
> 
> I guess your suggestion is to only enable it with forwarding, which is
> unlikely to see a cycle regression. And if there is a latency
> regression, disable all GRO to disable UDP GRO.

Yes, do GRO only for forwarding or if there is a GRO capable socket.

In this case it can be disabled only by disable all GRO.
It might be a disadvantage, but that's how it is with other
protocols too.

> 
> Instead, how about adding a UDP GRO ethtool feature independent of
> forwarding, analogous to fraglist GRO? Then both are explicitly under
> admin control. And can be enabled by default (either now, or after
> getting more data).

We could add a protocol specific feature, but what would it mean
if UDP GRO is enabled?

Would it be enabled for forwarding, and for local input only if there
is a GRO capable socket? Or would it be enabled even if there
is no GRO capable socket? Same question when UDP GRO is disabled.

Also, what means enabling GRO then? Enable GRO for all protocols
but UDP? Either UDP becomes something special then, or we need
to create protocol specific features for the other protocols
too. Same would apply for fraglist GRO.

