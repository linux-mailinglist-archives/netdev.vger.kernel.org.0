Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2600B15F622
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbgBNSub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:50:31 -0500
Received: from mail.efficios.com ([167.114.26.124]:58502 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388268AbgBNSub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:50:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 256EF23BC1F;
        Fri, 14 Feb 2020 13:50:30 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id YYpVRuuR_C_6; Fri, 14 Feb 2020 13:50:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id CFC9F23B8E1;
        Fri, 14 Feb 2020 13:50:29 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com CFC9F23B8E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1581706229;
        bh=VzUR9Bfe3F/JSoaq6QEVx8D9A43LNgpVZoQQa6Y285o=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=tF77J3ZG5K6RKC7QA+KvDTzXXSjI6ATvHNWQHVRnG5ZrNIXUwMsSkZdoTThDk9J4D
         njRQaJPlXHoj6T9YwJwEbF0Vm2y/uJ5vXwKB4UtRESpcV5QqTj4vvVBMrckN+TDt1l
         JFYJvUiaM0qOb0wJeHJ1toSz+xYZzJUOSizPOv44TZ+2feTghgbD3tEMzuyWCbrbgR
         ZtHPNn3lwcrupb2P/Xsl4CaSCrOWAwNQXaYdUEndNGwoe+h69yQQ2wMEphKyaLVDys
         k1ZYER6Sqk1f2Zd1ZjDnh+R5/uqhVo87ymto+ZyjQLebIZWERQfeDjp3MRl68leKRe
         HjO+X71YSt7Bw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CtnvbEbnMtXo; Fri, 14 Feb 2020 13:50:29 -0500 (EST)
Received: from localhost (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 909E923B77F;
        Fri, 14 Feb 2020 13:50:28 -0500 (EST)
Date:   Fri, 14 Feb 2020 13:50:27 -0500
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 07/19] bpf: Provide BPF_PROG_RUN_PIN_ON_CPU() macro
Message-ID: <20200214185027.nx6enxvmghucai2d@localhost>
References: <20200214133917.304937432@linutronix.de>
 <20200214161503.595780887@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214161503.595780887@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14-Feb-2020 02:39:24 PM, Thomas Gleixner wrote:
[...]
> +#define BPF_PROG_RUN_PIN_ON_CPU(prog, ctx) ({				\
> +	u32 ret;							\
> +	migrate_disable();						\
> +	ret = __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nopfunc);	\
> +	migrate_enable();						\
> +	ret; })

Does it really have to be a statement expression with a local variable ?

If so, we should consider renaming "ret" to "__ret" to minimize the
chances of a caller issuing BPF_PROG_RUN_PIN_ON_CPU with "ret" as
prog or ctx argument, which would lead to unexpected results.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
