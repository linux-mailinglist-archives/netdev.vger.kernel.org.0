Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8484429143C
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 22:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439675AbgJQUDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 16:03:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51326 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439665AbgJQUDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 16:03:55 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602965033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fD8To0G31Wnjv4CSMouQW042TTW/VTVEOWWDfMh5qQE=;
        b=MMY/7PwSl8pTU+QjRZoRdBJnqBHwz3WNOQs0ZqfB9wtPAyxcZphka1I8Ox3P5w0HQEfHwc
        SB1bT3KSbn97AzStxmqRWvD7Jd1jINNp6UzvOCJeJVGYRRL3eexJl/Vemp+B9FDCZ0+3Fq
        ss12hKC4M9SCODCom0ozeSDBsVLSh1PAsl1aXNQdx7EndPJwIV1/mfzl+oW7mFRzHpBKYf
        ZzNn7oai9typ1Hao6RIxtPLiPSbCytsNDkTgasYyf+PB/qvtmFUugyLPS669321TQUPE/x
        jnKNK2t5jeFrlr50fDhlJipvwCarc80vKcxm/4D6B5Vi8z6egogWTImuKBe0yg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602965033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fD8To0G31Wnjv4CSMouQW042TTW/VTVEOWWDfMh5qQE=;
        b=PSyszyaXkHnx+TsPjL80dPcUU/8lGfYRE5vJu8CKE5x06QLwbhdfM79YhpSyaQN11p4USa
        FOppEQaJ2xqSucCA==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     "mingo\@kernel.org" <mingo@kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "will\@kernel.org" <will@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard isolation from kernel
In-Reply-To: <e9c5513d0d8dcd8b2db07a932e9f45640be6b0ea.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com> <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com> <20201001135640.GA1748@lothringen> <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com> <20201004231404.GA66364@lothringen> <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com> <91b8301b0888bf9e5ff7711c3b49d21beddf569a.camel@marvell.com> <87r1pwj0nh.fsf@nanos.tec.linutronix.de> <e9c5513d0d8dcd8b2db07a932e9f45640be6b0ea.camel@marvell.com>
Date:   Sat, 17 Oct 2020 22:03:52 +0200
Message-ID: <87mu0kipqv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17 2020 at 16:15, Alex Belits wrote:
> On Sat, 2020-10-17 at 18:08 +0200, Thomas Gleixner wrote:
>> On Sat, Oct 17 2020 at 01:08, Alex Belits wrote:
>> > I think that the goal of "finding source of disturbance" interface
>> > is
>> > different from what can be accomplished by tracing in two ways:
>> > 
>> > 1. "Source of disturbance" should provide some useful information
>> > about
>> > category of event and it cause as opposed to determining all
>> > precise
>> > details about things being called that resulted or could result in
>> > disturbance. It should not depend on the user's knowledge about
>> > details
>> 
>> Tracepoints already give you selectively useful information.
>
> Carefully placed tracepoints also can give the user information about
> failures of open(), write(), execve() or mmap(). However syscalls still
> provide an error code instead of returning generic failure and letting
> user debug the cause.

I have absolutely no idea what you are trying to tell me.

Thanks,

        tglx
