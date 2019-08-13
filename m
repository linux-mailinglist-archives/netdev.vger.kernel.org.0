Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840508BC6F
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfHMPGy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Aug 2019 11:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfHMPGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 11:06:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3893830EA1BA;
        Tue, 13 Aug 2019 15:06:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F79580FD6;
        Tue, 13 Aug 2019 15:06:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CACT4Y+YCB3o5Ps9RNq9KpMcmGCwBM4R9DeX67prQ9Q3UppGowQ@mail.gmail.com>
References: <CACT4Y+YCB3o5Ps9RNq9KpMcmGCwBM4R9DeX67prQ9Q3UppGowQ@mail.gmail.com> <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk> <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com> <20330.1564583454@warthog.procyon.org.uk> <CACT4Y+Y4cRgaRPJ_gz_53k85inDKq+X+bWmOTv1gPLo=Yod1=A@mail.gmail.com> <22318.1564586386@warthog.procyon.org.uk> <CACT4Y+bjLBwVK_6fz2H8fXm0baAVX+vRJ4UbVWG_7yNUO-SOUg@mail.gmail.com> <3135.1565706180@warthog.procyon.org.uk>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8012.1565708810.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 13 Aug 2019 16:06:50 +0100
Message-ID: <8013.1565708810@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 13 Aug 2019 15:06:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:

> > I meant that I don't know how to turn a tracepoint on from inside the kernel.
> 
> This /sys/kernel/debug/tracing/events/rxrpc/rxrpc_local/enable in:
>         echo 1 > /sys/kernel/debug/tracing/events/rxrpc/rxrpc_local/enable
> should map to some global variable, right? If so, it should be
> possible to initialize that var to 1 statically. Or that won't work
> for some reason?

As I understand it, it's all hidden inside of tracing macros and ftrace
infrastructure and involves runtime patching the code to enable tracepoints
(they're effectively NOP'ed out when not in use).

So, no, it's not that simple.

I asked Steven and he says:

	trace_set_clr_event("sched", "sched_switch", 1);

is the same as

	echo 1 > events/sched/sched_switch/enable

So it can be done.  Will syzbot actually collect the trace log?

David
