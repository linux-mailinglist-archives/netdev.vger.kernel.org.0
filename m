Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55F32CFFC2
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgLEX0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:26:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55620 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgLEX03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 18:26:29 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607210746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OF/yxcOl24sCZMNn4pFXh470oPoxUajiPWkLNQAbERU=;
        b=qM/BWflaQxEXLQ8tIgzhYUuf1xoW7bdG4CvFJrmU0VDLsTE391cb0fqh1cULmil6JPkN5H
        CjM9f71zxVI6Sk6dpZdpMv1/Dmw/Ki6KPTrX209JefSyxBKR9gikRtVtEd2SDYLG5WPI34
        6CcwxqoVWHvlbSCVv7N6hjn1WunbYGvZ0LdHs9tCkU7kmNqqKPy+2SusNfTxHqzjDH8xHD
        Y1qThnsAJvud0e+1SToR7En8O3qIzL05tGCeqq6uPq9qkX5Rgy3UCVdCx6Yovo0QV/UY4c
        vLzoVpeqNJv/og+qJE/8OA0XGq+IVUZNcsbicbnWcoQYUKcC8m2Dk6fgKORH0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607210746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OF/yxcOl24sCZMNn4pFXh470oPoxUajiPWkLNQAbERU=;
        b=F0Wpl6o+XvAhNAela/BGvtsgKXboiTn2PGy6xEd0AhejBgQ9J5NvG+DtqLBW5WYakJVmng
        7IXzd1Pi4pU5X8CQ==
To:     Pavel Machek <pavel@ucw.cz>, Alex Belits <abelits@marvell.com>
Cc:     "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "trix\@redhat.com" <trix@redhat.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx\@redhat.com" <peterx@redhat.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "will\@kernel.org" <will@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "leon\@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld\@redhat.com" <pauld@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/9] "Task_isolation" mode
In-Reply-To: <20201205204049.GA8578@amd>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com> <20201205204049.GA8578@amd>
Date:   Sun, 06 Dec 2020 00:25:45 +0100
Message-ID: <87h7oz96o6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel,

On Sat, Dec 05 2020 at 21:40, Pavel Machek wrote:
> So... what kind of guarantees does this aim to provide / what tasks it
> is useful for?
>
> For real time response, we have other approaches.

Depends on your requirements. Some problems are actually better solved
with busy polling. See below.

> If you want to guarantee performnace of the "isolated" task... I don't
> see how that works. Other tasks on the system still compete for DRAM
> bandwidth, caches, etc...

Applications which want to run as undisturbed as possible. There is
quite a range of those:

  - Hardware in the loop simulation is today often done with that crude
    approach of "offlining" a CPU and then instead of playing dead
    jumping to a preloaded bare metal executable. That's a horrible hack
    and impossible to debug, but gives them the results they need to
    achieve. These applications are well optimized vs. cache and memory
    foot print, so they don't worry about these things too much and they
    surely don't run on SMI and BIOS value add inflicted machines.

    Don't even think about waiting for an interrupt to achieve what
    these folks are doing. So no, there are problems which a general
    purpose realtime OS cannot solve ever.

  - HPC computations on large data sets. While the memory foot print is
    large the access patterns are cache optimized. 

    The problem there is that any unnecessary IPI, tick interrupt or
    whatever nuisance is disturbing the carefully optimized cache usage
    and alone getting rid of the timer interrupt gained them measurable
    performance. Even very low single digit percentage of runtime saving
    is valuable for these folks because the compute time on such beasts
    is expensive.

  - Realtime guests in KVM. With posted interrupts and a fully populated
    host side page table there is no point in running host side
    interrupts or IPIs for random accounting or whatever purposes as
    they affect the latency in the guest. With all the side effects
    mitigated and a properly set up guest and host it is possible to get
    to a zero exit situation after the bootup phase which means pretty
    much matching bare metal behaviour.

    Yes, you can do that with e.g. Jailhouse as well, but you lose lots
    of the fancy things KVM provides. And people care about these not
    just because they are fancy. They care because their application
    scenario needs them.

There are more reasons why people want to be able to get as much
isolation from the OS as possible but at the same time have a sane
execution environment, debugging, performance monitoring and the OS
provided protection mechanisms instead of horrible hacks.

Isolation makes sense for a range of applications and there is no reason
why Linux should not support them. 

Thanks,

        tglx
