Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B429722B1DA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgGWOxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgGWOxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:53:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0537C0619DC;
        Thu, 23 Jul 2020 07:53:21 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595516000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xReGl6rTwlABQqLHz4nZq26+2OiWDgg160LyB2p5G1Y=;
        b=h+R7c7Oqa+NtfxuxU6ErUL3QgyKMiY86p1+Kw7jgFvrPWdf1Q0qClfz317j9HUmF2fwC/1
        5acMlB6QLMHuQ5C80LW1aEUjGMzQKOLyRA1SAmDUiUIFBgINPfAmbPmW258xRB4SST2MAd
        GsIWTwBzzKWejXNRLcn0/kylOrHmYzxeC+YBi5HEro2PJgagKpxzZ/H2OjSnTCbjwhoJ22
        xkmLAuyyoc25iqroV83OtXKN3Ts+LbJSF0t5tzsVbkxhIuuNqUCPkFbZGSqZEgmsXrkCIr
        pnMbd2XwB2NTi505+WXCf8zIwWxOv0AIhY/IC+XmYNJ03E2iS3sY9MAhMmqOEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595516000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xReGl6rTwlABQqLHz4nZq26+2OiWDgg160LyB2p5G1Y=;
        b=ZWPvwgt7LIfOjZ/LyDvsBRAenC3Lmc63twFT/Q12fb4/k/DMfWqwI6MbrS7HjD3pi6hH84
        QAlVEytmbw2nKuAQ==
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alex Belits <abelits@marvell.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] "Task_isolation" mode
In-Reply-To: <20200723142623.GS5523@worktop.programming.kicks-ass.net>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <87imeextf3.fsf@nanos.tec.linutronix.de> <20200723142623.GS5523@worktop.programming.kicks-ass.net>
Date:   Thu, 23 Jul 2020 16:53:19 +0200
Message-ID: <87y2nawae8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
> On Thu, Jul 23, 2020 at 03:17:04PM +0200, Thomas Gleixner wrote:
>
>>   2) Instruction synchronization
>> 
>>      Trying to do instruction synchronization delayed is a clear recipe
>>      for hard to diagnose failures. Just because it blew not up in your
>>      face does not make it correct in any way. It's broken by design and
>>      violates _all_ rules of safe instruction patching and introduces a
>>      complete trainwreck in x86 NMI processing.
>> 
>>      If you really think that this is correct, then please have at least
>>      the courtesy to come up with a detailed and precise argumentation
>>      why this is a valid approach.
>> 
>>      While writing that up you surely will find out why it is not.
>
> So delaying the sync_core() IPIs for kernel text patching _might_ be
> possible, but it very much wants to be a separate patchset and not
> something hidden inside a 'gem' like this.

I'm not saying it's impossible, but the proposed hack is definitely
beyond broken and you really don't want to be the one who has to mop up
the pieces later.

Thanks,

        tglx
