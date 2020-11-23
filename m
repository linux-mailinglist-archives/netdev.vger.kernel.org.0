Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3FA2C1818
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgKWWBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:01:13 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38662 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbgKWWBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:01:12 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606168870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOgyExsMmcgulCtYSfwEoyMOFUiwrusrBNm+SSTsII8=;
        b=G2VzHdD4ucYDyOfYcf2YaTEpSNoyYjuAMLboKB1Mb5h3bbcTX3eEiUBn31rpT38IZ5i5wW
        kpOTaPoA2M1fFW3D1BuE1XdPQG5I8I7qCEU2WOp1/CBoYNskOMKJbbFkFCUmd0GGRcgJ+Q
        thb9GR4u1d89dvbxBmsQBXwMCCx9ixZEwEA363ihhqElKWHrB5UQ/Kibm6ZCWBSmDdbOIc
        FLl5DGp/TATt9sFZboFhPn7YoMTalX0VsvqLV9HxEgIQGJU9lzskJygaqR0ZKzpK506Q03
        1z+SlvrWuaDTM2eUs+lel1dR4EslM10ZfkC4rOPa+oNu4oxXlfcNKTvYMCfhOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606168870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nOgyExsMmcgulCtYSfwEoyMOFUiwrusrBNm+SSTsII8=;
        b=jbjqZF8KCmxT1IFmm88MtvOgo8upRZm4W8+1DkcGTMq1ZlvrJhT6IqlcThSo8L0eKieRW3
        +Z9+Jv/vrzKd2hCw==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
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
Subject: Re: [PATCH v5 3/9] task_isolation: userspace hard isolation from kernel
In-Reply-To: <5d882681867ed43636e22d265d61afbbac1b5a62.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com> <5d882681867ed43636e22d265d61afbbac1b5a62.camel@marvell.com>
Date:   Mon, 23 Nov 2020 23:01:10 +0100
Message-ID: <878sarn36h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex,

On Mon, Nov 23 2020 at 17:56, Alex Belits wrote:
>  .../admin-guide/kernel-parameters.txt         |   6 +
>  drivers/base/cpu.c                            |  23 +
>  include/linux/hrtimer.h                       |   4 +
>  include/linux/isolation.h                     | 326 ++++++++
>  include/linux/sched.h                         |   5 +
>  include/linux/tick.h                          |   3 +
>  include/uapi/linux/prctl.h                    |   6 +
>  init/Kconfig                                  |  27 +
>  kernel/Makefile                               |   2 +
>  kernel/isolation.c                            | 714 ++++++++++++++++++
>  kernel/signal.c                               |   2 +
>  kernel/sys.c                                  |   6 +
>  kernel/time/hrtimer.c                         |  27 +
>  kernel/time/tick-sched.c                      |  18 +

I asked you before to split this up into bits and pieces and argue and
justify each change. Throwing this wholesale over the fence is going
nowhere. It's not revieable at all.

Aside of that ignoring review comments is a sure path to make yourself
ignored:

> +/*
> + * Logging
> + */
> +int task_isolation_message(int cpu, int level, bool supp, const char *fmt, ...);
> +
> +#define pr_task_isol_emerg(cpu, fmt, ...)			\
> +	task_isolation_message(cpu, LOGLEVEL_EMERG, false, fmt, ##__VA_ARGS__)

The comments various people made about that are not going away and none
of this is going near anything I'm responsible for unless you provide
these independent of the rest and with a reasonable justification why
you can't use any other existing mechanism or extend it for your use
case.

Thanks,

        tglx
