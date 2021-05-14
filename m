Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8938136B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhENVzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhENVzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:55:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D63C06174A;
        Fri, 14 May 2021 14:53:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621029236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YMDSuhwDDAIBz65ztaPmnouscCan/8FmST0Xl3cL+3o=;
        b=jiN3KFXCr2sxwoVmItCe+621oLau+r8o6ATT5UrfWPjZ+BCjeAEdMydDsG0LjGUfI+4Lcu
        YFc+yGssUeWlmFa6SY/kb3dlHS7iomFIJgcI6FOjE7QHExHZkMJlcaa7Gc3a/difbbXETY
        ppXPgWWzulrWg/Vk6p1qHypxbAd1nJi8xFhegAhyS5rF8pPltslF/iuyIpQIJtHtSMPftI
        gDl30hZOM5QvfLjGfULqdpgcJKHbdnLuXlWGTy3QUE0LKP8wuDocHx5gWLENiYgTDSEmO/
        rXDefewkUJOxOoXFhitTJAKeoztmWM9yNzBfFWfmmeVhHm92oKdquyT7B8Na+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621029236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YMDSuhwDDAIBz65ztaPmnouscCan/8FmST0Xl3cL+3o=;
        b=PxoAkGINkifPynLBMaZAZB3REJRuHaHqAa7rAIPjXpll7B7jY7w5IBWEsZ9tWgE2qlt0rz
        6Za0D/MJPDbe49CQ==
To:     Alison Chaiken <achaiken@aurora.tech>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>, stable-rt@vger.kernel.org
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
In-Reply-To: <CAFzL-7vTcr75ho0kKs+0PxD3UFRE9=KtNQKJGTx7u-LzGK_oxA@mail.gmail.com>
References: <YJofplWBz8dT7xiw@localhost.localdomain> <20210512214324.hiaiw3e2tzmsygcz@linutronix.de> <87k0o360zx.ffs@nanos.tec.linutronix.de> <20210514115649.6c84fdc3@kicinski-fedora-PC1C0HJN> <CAFzL-7vTcr75ho0kKs+0PxD3UFRE9=KtNQKJGTx7u-LzGK_oxA@mail.gmail.com>
Date:   Fri, 14 May 2021 23:53:56 +0200
Message-ID: <877dk12d8r.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 12:44, Alison Chaiken wrote:
> On Fri, May 14, 2021 at 11:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> Another thing while I have your attention - ____napi_schedule() does
>> __raise_softirq_irqoff() which AFAIU does not wake the ksoftirq thread.
>> On non-RT we get occasional NOHZ warnings when drivers schedule napi
>> from process context, but on RT this is even more of a problem, right?
>> ksoftirqd won't run until something else actually wakes it up?
>
> By "NOHZ warnings," do you mean "NOHZ: local_softirq_pending"?    We see
> that message about once a week with 4.19.   Presumably any failure of
> ____napi_schedule() to wake ksoftirqd could only cause problems for the
> NET_RX softirq, so if the pending softirq is different, the cause lies
> elsewhere.

If you read the above carefully you might notice that this _IS_ about
____napi_schedule() being invoked from task context which raises NET_RX
and then results in pending 08! which is NET_RX.

Thanks,

        tglx


