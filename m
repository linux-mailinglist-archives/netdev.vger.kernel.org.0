Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B872B26EA67
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 03:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIRBVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 21:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIRBVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 21:21:04 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89AFF2087D;
        Fri, 18 Sep 2020 01:21:03 +0000 (UTC)
Date:   Thu, 17 Sep 2020 21:21:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marco Elver <elver@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
Message-ID: <20200917212101.53287f29@rorschach.local.home>
In-Reply-To: <20200821153532.GA3205540@elver.google.com>
References: <20200821063043.1949509-1-elver@google.com>
        <20200821085907.GJ1362448@hirez.programming.kicks-ass.net>
        <CANn89i+1MQRCSRVg-af758en5e9nwQBes3aBSjQ6BY1pV5+HdQ@mail.gmail.com>
        <20200821153532.GA3205540@elver.google.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Late reply, due to Plumbers followed by a much needed vacation and
  then drowning in 3 weeks of unread email! ]

On Fri, 21 Aug 2020 17:35:32 +0200
Marco Elver <elver@google.com> wrote:

> So, if the _rcuidle() variant here doesn't break your usecase, there
> should be no harm in using the _rcuidle() variant. This also lifts the
> restriction on where prandom_u32() is usable to what it was before,
> which should be any context.
> 
> Steven, Peter: What's the downside to of _rcuidle()?

_rcuidle() only has a slightly more overhead in the tracing path (it's
no different when not tracing). There's not a issue with _rcuidle()
itself. The issue is that we need to have it. We'd like it to be that
rcu *is* watching always except for a very minimal locations when
switching context (kernel to and from user and running to and from
idle), and then we just don't let tracing or anything that needs rcu in
those locations.

But for your patch:

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
