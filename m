Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3593E30087C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbhAVQUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:20:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729599AbhAVQPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611332035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTzvcxscKtq/tV27tCHh9sa+whh6ERFxBikE1EVctD4=;
        b=Nh5lIg2sJlTC3gK4aS39V6jrIZmn0RR7B39qeCnXyT/hYmKvxPtQIomr1tEuu6bK79uLJn
        r5d6S4Q57+owoAHiGAS0MGqFZxvuMCcxy+LM6xa7VVOFxe+9sSJ+DV3nKPJsgKKABTTh53
        bN/9Nf+kFmxEUaNblxlsyzDVMzzWI4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-psFA18dgOHywEF7_WcmkKg-1; Fri, 22 Jan 2021 11:13:52 -0500
X-MC-Unique: psFA18dgOHywEF7_WcmkKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6956190A7AD;
        Fri, 22 Jan 2021 16:13:49 +0000 (UTC)
Received: from ovpn-113-245.ams2.redhat.com (ovpn-113-245.ams2.redhat.com [10.36.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC47519813;
        Fri, 22 Jan 2021 16:13:45 +0000 (UTC)
Message-ID: <4c9229e0e2d7ffabba1a8372d5335ddb28486b6e.camel@redhat.com>
Subject: Re: [PATCH v4 11/13] task_isolation: net: don't flush backlog on
 CPUs running isolated tasks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>
Cc:     Alex Belits <abelits@marvell.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 22 Jan 2021 17:13:44 +0100
In-Reply-To: <20210122141320.GA66969@fuller.cnet>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <01470cf1f1a2e79e46a87bb5a8a4780a1c3cc740.camel@marvell.com>
         <20201001144731.GC6595@lothringen> <20210122141320.GA66969@fuller.cnet>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-22 at 11:13 -0300, Marcelo Tosatti wrote:
> On Thu, Oct 01, 2020 at 04:47:31PM +0200, Frederic Weisbecker wrote:
> > On Wed, Jul 22, 2020 at 02:58:24PM +0000, Alex Belits wrote:
> > > From: Yuri Norov <ynorov@marvell.com>
> > > 
> > > so we don't need to flush it.
> > 
> > What guarantees that we have no backlog on it?
> 
> From Paolo's work to use lockless reading of 
> per-CPU skb lists
> 
> https://www.spinics.net/lists/netdev/msg682693.html
> 
> It also exposed skb queue length to userspace
> 
> https://www.spinics.net/lists/netdev/msg684939.html
> 
> But if i remember correctly waiting for a RCU grace
> period was also necessary to ensure no backlog !?! 
> 
> Paolo would you please remind us what was the sequence of steps?
> (and then also, for the userspace isolation interface, where 
> the application informs the kernel that its entering isolated
> mode, is just confirming the queues have zero length is
> sufficient?).

After commit 2de79ee27fdb52626ac4ac48ec6d8d52ba6f9047, for CONFIG_RPS
enabled build, with no RFS in place to ensure backlog will be empty on
CPU X, the user must:
- configure the RPS map on each device before the device goes up to
explicitly exclude CPU X.

If CPU X is isolated after some network device already went up, to
ensure that the backlog will be empty on CPU X the user must:
- configure RPS on all the network device to exclude CPU X (as in the
previous scenario)
- wait a RCU grace period
- wait untill the backlog len on CPU X reported by procfs is 0

Cheers,

Paolo

