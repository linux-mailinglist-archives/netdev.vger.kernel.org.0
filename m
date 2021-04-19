Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1836461B
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239788AbhDSOaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhDSOaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 10:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF33611CE;
        Mon, 19 Apr 2021 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618842580;
        bh=KT3dRbNBIAI9N6Pz0JoZwsxDuyyqzklTvg3+j8AbVyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCK/t8HHzd0wpq/+cEiQoKB3oQ95/1mHnycSgoyp5cLeAbF4itBXB5M7XKTGhFTn1
         u08B7GZ9BijuDPT0zVOpeiRQRCG/gfSNMmBELP8TfIQOZ76l9vaG5bAKRI0v5UT6d/
         4m7O44FzVSnRBsUCmEDaCu9F1n6v+CZjY9Aj4W9Z3FeVmG9OAlQSGM8uyf15v2SuLk
         GkdRp3Em8Kb9nsFV5Ex6Cl8TqDtA3bD1EPDBcuuu5sawgIKcUEDM5hQuUx+7sa3z1K
         QTgYQLthPVKEPi/tUuZgb7dCNew6OamIYfweL4Gr/yZtA731cteRtWX+sIJRlB+H6r
         6PbXwNXzYRbxg==
Date:   Mon, 19 Apr 2021 23:29:34 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-Id: <20210419232934.4bce1d424b7cd133d20c8be4@kernel.org>
In-Reply-To: <20210416124834.05862233@gandalf.local.home>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
        <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
        <20210416124834.05862233@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 12:48:34 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 17 Apr 2021 00:03:04 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > > return (who cares about the registers on return, except for the return
> > > value?)  
> > 
> > I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> > used for something like debugger. In that case, accessing full regs stack
> > will be more preferrable. (BTW, what the not "full regs" means? Does that
> > save partial registers?)
> 
> When the REGS flag is not set in the ftrace_ops (where kprobes uses the
> REGS flags), the regs parameter is not a full set of regs, but holds just
> enough to get access to the parameters. This just happened to be what was
> saved in the mcount/fentry trampoline, anyway, because tracing the start of
> the program, you had to save the arguments before calling the trace code,
> otherwise you would corrupt the parameters of the function being traced.

Yes, if we trace the function as a blackbox, it is correct. It should trace
the parameter at the entry and trace result at the exit.

> I just tweaked it so that by default, the ftrace callbacks now have access
> to the saved regs (call ftrace_regs, to not let a callback get confused and
> think it has full regs when it does not).

Ah, I got it. kretprobe allows user to set a custom region in its instance
so that the user handler can store the parameter at entry point. Sometimes
such "saved regs" is not enough because if the parameter passed via
pointer, actual data can be changed.
Anyway, for the kprobe event, that can be integrated seemlessly. But for the
low-level kretprobe, I think if we integrate it, we should better to update
kretprobe handler interface.

> Now for the exit of a function, what does having the full pt_regs give you?

It may allow user to debug kernel function if the user thinks any suspicious
behavior does/doesn't come from the compiler issue. (I would like to recommend
them to use kprobe for that purpose, but there is kretprobe already ...)

> Besides the information to get the return value, the rest of the regs are
> pretty much meaningless. Is there any example that someone wants access to
> the regs at the end of a function besides getting the return value?

Yes, as far as we can confident that the code is not corrupted. But, for example,
if user would like to make sure the collee saved register (or some flags)
is correctly saved and restored, ensuring raw register access will be helpful.

(Yeah, but I know it is very rare case.)

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
