Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C0442308A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhJETI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhJETI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:08:28 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3739C061749;
        Tue,  5 Oct 2021 12:06:37 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 21E7D5877C256; Tue,  5 Oct 2021 21:06:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 1DD7B60C1CB34;
        Tue,  5 Oct 2021 21:06:36 +0200 (CEST)
Date:   Tue, 5 Oct 2021 21:06:36 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
In-Reply-To: <20211005144002.34008ea0@gandalf.local.home>
Message-ID: <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr>
References: <20211005094728.203ecef2@gandalf.local.home>        <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>        <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>        <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr>
 <20211005144002.34008ea0@gandalf.local.home>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tuesday 2021-10-05 20:40, Steven Rostedt wrote:
>> 
>> >>>> typeof(*p) *________p1 = (typeof(*p) *__force)READ_ONCE(p);  
>> 
>> #define static_cast(type, expr) ((struct { type x; }){(expr)}.x)
>> typeof(p) p1 = (typeof(p) __force)static_cast(void *, READ_ONCE(p));
>> 
>> Let the name not fool you; it's absolutely _not_ the same as C++'s 
>> static_cast, but still: it does emit a warning when you do pass an 
>> integer, which is better than no warning at all in that case.
>> 
>>  *flies away*
>
>Are you suggesting I should continue this exercise ;-)

“After all, why not?”

typeof(p) p1 = (typeof(p) __force)READ_ONCE(p) +
               BUILD_BUG_ON_EXPR(__builtin_classify_type(p) != 5);
