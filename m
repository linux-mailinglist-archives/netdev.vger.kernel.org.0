Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D4216484A
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgBSPRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:17:31 -0500
Received: from mail.efficios.com ([167.114.26.124]:55552 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgBSPRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:17:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D7BC02490A3;
        Wed, 19 Feb 2020 10:17:29 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 2MXQCndbR0nH; Wed, 19 Feb 2020 10:17:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 946A7248E45;
        Wed, 19 Feb 2020 10:17:29 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 946A7248E45
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1582125449;
        bh=E+T2zau6Nrzd/5UrHxBwjFO/z6zZmEyWpKIt0k5o2nw=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=cBhnjQYooRNjkzLDy0EtHNIr0MyHS+be39Ze0qlXO3sCvsU1Yj2PiVygBNOpGqcSp
         sZ0FgDegopcSsZYkbQtm24enMnm41JSZs7ecwoOJUs7oZANxMC6bpoU1TA/e2utw3v
         Dvo0sbsYkU/i2V4JINq7iDku3UFIUow25QevcGzOtZRTdeVBYybp+l5pnKyzCfMS/O
         +zK5ZuBF3QUgpI4f6wSwfkBG5P/b27iiVmnxdngYxcyPvDVMdwbvi20lFCS5kylVCH
         euvJRAHMDK8ElCyDRlfzPucBAAXCaBMYBpRETN++FOGjkKBAm8F6RAoneYa4TtAlCR
         qLMwim9QBTteA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id i_e6Jf-_d-MZ; Wed, 19 Feb 2020 10:17:29 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 7F9E2248E3F;
        Wed, 19 Feb 2020 10:17:29 -0500 (EST)
Date:   Wed, 19 Feb 2020 10:17:28 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Message-ID: <1127123648.641.1582125448879.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200218233641.i7fyf36zxocgucap@ast-mbp>
References: <20200214133917.304937432@linutronix.de> <20200214161504.325142160@linutronix.de> <20200214191126.lbiusetaxecdl3of@localhost> <87imk9t02r.fsf@nanos.tec.linutronix.de> <20200218233641.i7fyf36zxocgucap@ast-mbp>
Subject: Re: [RFC patch 14/19] bpf: Use migrate_disable() in hashtab code
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3901 (ZimbraWebClient - FF72 (Linux)/8.8.15_GA_3895)
Thread-Topic: Use migrate_disable() in hashtab code
Thread-Index: FMpBzgOmPiKRGoH6zx7fdw8jq3/Jnw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Feb 18, 2020, at 6:36 PM, Alexei Starovoitov alexei.starovoitov@gmail.com wrote:

[...]

> If I can use migrate_disable() without RT it will help my work on sleepable
> BPF programs. I would only have to worry about rcu_read_lock() since
> preempt_disable() is nicely addressed.

Hi Alexei,

You may want to consider using SRCU rather than RCU if you need to sleep while
holding a RCU read-side lock.

This is the synchronization approach I consider for adding the ability to take page
faults when doing syscall tracing.

Then you'll be able to replace preempt_disable() by combining SRCU and
migrate_disable():

AFAIU eBPF currently uses preempt_disable() for two reasons:

- Ensure the thread is not migrated,
  -> can be replaced by migrate_disable() in RT
- Provide RCU existence guarantee through sched-RCU
  -> can be replaced by SRCU, which allows sleeping and taking page faults.

I wonder if it would be acceptable to take a page fault while migration is
disabled though ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
