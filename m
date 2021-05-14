Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38213811C8
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhENU1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:27:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39162 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhENU1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 16:27:03 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621023950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMXkr7Iq4MF3U+pohoKkjIdV0/xsXMNWRAnt0xXZpwk=;
        b=ccA1E3zfVOYRwDBQ/oUUl5hJUAgyZVvV44HcqG5WyhpNXzgzol3bRFQZkuJe1E5BiOe/BP
        exTpYoQC5psEyjUORIHtgUkX35C3e8Dh84yLnPP4s8DMrwBCin1r6LAnBi5Gd2cdlc6HSj
        GLIwgLlp3/GL0R+7vLfia482J6fdQWV1RrRnePrG6219d7e61oCqsfNkOWbldKbNQadHCk
        NpXCgME9k+EW4/0KrmbHT6PSEphVlHXFp9FoQ/v2avHFo3oOskgUrGQk+Cbwga9IDdLnYx
        UyeBdx+ZwAL1o5RtZsK/s+eUoe2g5IPN4oRw/l95mhERCCPDqIrTUGnjlpKnvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621023950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMXkr7Iq4MF3U+pohoKkjIdV0/xsXMNWRAnt0xXZpwk=;
        b=/KL/Z5Q+7KfNEa/0wJeI4FV9TavPjgmRx6+O71g1QcRhTgXdsmMAHGGhdnUWE9M6uCtXua
        SVCOw41Cb+MkCJAA==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
In-Reply-To: <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
References: <877dk162mo.ffs@nanos.tec.linutronix.de> <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN>
Date:   Fri, 14 May 2021 22:25:50 +0200
Message-ID: <87sg2p2hbl.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 12:38, Jakub Kicinski wrote:

> On Fri, 14 May 2021 12:17:19 +0200 Thomas Gleixner wrote:
>> The driver invokes napi_schedule() in several places from task
>> context. napi_schedule() raises the NET_RX softirq bit and relies on the
>> calling context to ensure that the softirq is handled. That's usually on
>> return from interrupt or on the outermost local_bh_enable().
>> 
>> But that's not the case here which causes the soft interrupt handling to be
>> delayed to the next interrupt or local_bh_enable(). If the task in which
>> context this is invoked is the last runnable task on a CPU and the CPU goes
>> idle before an interrupt arrives or a local_bh_disable/enable() pair
>> handles the pending soft interrupt then the NOHZ idle code emits the
>> following warning.
>> 
>>   NOHZ tick-stop error: Non-RCU local softirq work is pending, handler #08!!!
>> 
>> Prevent this by wrapping the napi_schedule() invocation from task context
>> into a local_bh_disable/enable() pair.
>
> I should have read through my inbox before replying :)
>
> I'd go for switching to raise_softirq_irqoff() in ____napi_schedule()...
> why not?

Except that some instruction cycle beancounters might complain about
the extra conditional for the sane cases.

But yes, I'm fine with that as well. That's why this patch is marked RFC :)

Thanks,

        tglx

