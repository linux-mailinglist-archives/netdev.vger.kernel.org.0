Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EC76B1E9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbfGPWbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728986AbfGPWbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 18:31:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0DCF206C2;
        Tue, 16 Jul 2019 22:31:19 +0000 (UTC)
Date:   Tue, 16 Jul 2019 18:31:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190716183117.77b3ed49@gandalf.local.home>
In-Reply-To: <20190716213050.GA161922@google.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
        <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
        <20190716213050.GA161922@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 17:30:50 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> I don't see why a new bpf node for a trace event is a bad idea, really.
> tracefs is how we deal with trace events on Android. We do it in production
> systems. This is a natural extension to that and fits with the security model
> well.

What I would like to see is a way to have BPF inject data into the
ftrace ring buffer directly. There's a bpf_trace_printk() that I find a
bit of a hack (especially since it hooks into trace_printk() which is
only for debugging purposes). Have a dedicated bpf ftrace ring
buffer event that can be triggered is what I am looking for. Then comes
the issue of what ring buffer to place it in, as ftrace can have
multiple ring buffer instances. But these instances are defined by the
tracefs instances directory. Having a way to associate a bpf program to
a specific event in a specific tracefs directory could allow for ways to
trigger writing into the correct ftrace buffer.

But looking over the patches, I see what Alexei means that there's no
overlap with ftrace and these patches except for the tracefs directory
itself (which is part of the ftrace infrastructure). And the trace
events are technically part of the ftrace infrastructure too. I see the
tracefs interface being used, but I don't see how the bpf programs
being added affect the ftrace ring buffer or other parts of ftrace. And
I'm guessing that's what is confusing Alexei.

-- Steve
