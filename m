Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292732B2FDB
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKNSuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:50:54 -0500
Received: from mx.der-flo.net ([193.160.39.236]:51822 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKNSuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 13:50:54 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 884C8439A7; Sat, 14 Nov 2020 19:50:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id B7D00413E7;
        Sat, 14 Nov 2020 19:49:36 +0100 (CET)
Date:   Sat, 14 Nov 2020 19:49:31 +0100
From:   Florian Lehner <dev@der-flo.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     acme@kernel.org, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH bpf,perf]] bpf,perf: return EOPNOTSUPP for attaching bpf
 handler on PERF_COUNT_SW_DUMMY
Message-ID: <20201114184931.GA2747@der-flo.net>
References: <20201114135126.29462-1-dev@der-flo.net>
 <CAADnVQL4zBmS5Yo3skoA32YjFXz5qu0q9LuJ5Z-61EGwZzgD6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQL4zBmS5Yo3skoA32YjFXz5qu0q9LuJ5Z-61EGwZzgD6Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 08:07:29AM -0800, Alexei Starovoitov wrote:
> On Sat, Nov 14, 2020 at 5:53 AM Florian Lehner <dev@der-flo.net> wrote:
> >
> > At the moment it is not possible to attach a bpf handler to a perf event
> > of type PERF_TYPE_SOFTWARE with a configuration of PERF_COUNT_SW_DUMMY.
> 
> It is possible or it is not possible?
> 
> Such "commit log as an abstract statement" patches are a mystery to a reader.
> Please explain what problem you're trying to solve and how it's being addressed.

Perf events of type software/dummy are just placeholder events and don't
require a counting event. So attaching the bpf handler to the
overflow_handler of this event does not trigger the execution of the bpf
handler.
So the idea of this fix was to indicate to the user that attaching a bpf
handler to such a perf event is not (yet) supported.

> > Signed-off-by: Florian Lehner <dev@der-flo.net>
> > ---
> >  kernel/events/core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index da467e1dd49a..4e8846b7ceda 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -9668,6 +9668,10 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
> >         if (event->prog)
> >                 return -EEXIST;
> >
> > +       if (event->attr.type == PERF_TYPE_SOFTWARE &&
> > +           event->attr.config == PERF_COUNT_SW_DUMMY)
> > +               return -EOPNOTSUPP;
> 
> Is it a fix or a feature?
> If it is a fix please add 'Fixes:' tag.

I was not sure how to address it and so I have chosen PATCH. As bpf
handlers are still not executed on such events, I also would not call it
a feature.
