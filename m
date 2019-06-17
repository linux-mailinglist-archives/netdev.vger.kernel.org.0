Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38514495B1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfFQXJY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Jun 2019 19:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQXJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:09:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA392089E;
        Mon, 17 Jun 2019 23:09:22 +0000 (UTC)
Date:   Mon, 17 Jun 2019 19:09:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Matt Mullins <mmullins@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: hide do_bpf_send_signal when unused
Message-ID: <20190617190920.71c21a6c@gandalf.local.home>
In-Reply-To: <CAADnVQ+LzuNHFyLae0vUAudZpOFQ4cA02OC0zu3ypis+gqnjew@mail.gmail.com>
References: <20190617125724.1616165-1-arnd@arndb.de>
        <CAADnVQ+LzuNHFyLae0vUAudZpOFQ4cA02OC0zu3ypis+gqnjew@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 08:26:29 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Jun 17, 2019 at 5:59 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > When CONFIG_MODULES is disabled, this function is never called:
> >
> > kernel/trace/bpf_trace.c:581:13: error: 'do_bpf_send_signal' defined but not used [-Werror=unused-function]  
> 
> hmm. it should work just fine without modules.
> the bug is somewhere else.

From what I see, the only use of do_bpf_send_signal is within a
#ifdef CONFIG_MODULES, which means that you will get a warning about a
static unused when CONFIG_MODULES is not defined.

In kernel/trace/bpf_trace.c we have:

static void do_bpf_send_signal(struct irq_work *entry)

[..]

#ifdef CONFIG_MODULES

[..]

        for_each_possible_cpu(cpu) {
                work = per_cpu_ptr(&send_signal_work, cpu);
                init_irq_work(&work->irq_work, do_bpf_send_signal);  <-- on use of do_bpf_send_signal
        }
[..]
#endif /* CONFIG_MODULES */

The bug (really just a warning) reported is exactly here.

-- Steve
