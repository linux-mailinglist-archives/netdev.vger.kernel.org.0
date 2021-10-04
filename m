Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C9A4211E3
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhJDOs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234744AbhJDOsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 10:48:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 565D1613A2;
        Mon,  4 Oct 2021 14:46:31 +0000 (UTC)
Date:   Mon, 4 Oct 2021 10:46:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Hou Tao <hotforest@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com
Subject: Re: [PATCH bpf-next v5 0/3] add support for writable bare
 tracepoint
Message-ID: <20211004104629.668cadeb@gandalf.local.home>
In-Reply-To: <20211004094857.30868-1-hotforest@gmail.com>
References: <20211004094857.30868-1-hotforest@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Oct 2021 17:48:54 +0800
Hou Tao <hotforest@gmail.com> wrote:

> The main idea comes from patchset "writable contexts for bpf raw
> tracepoints" [1], but it only supports normal tracepoint with
> associated trace event under tracefs. Now we have one use case
> in which we add bare tracepoint in VFS layer, and update
> file::f_mode for specific files. The reason using bare tracepoint
> is that it doesn't form a ABI and we can change it freely. So
> add support for it in BPF.

Are the VFS maintainers against adding a trace event with just a pointer as
an interface?

That is, it only gives you a pointer to what is passed in, but does not
give you anything else to form any API against it.

This way, not only does BPF have access to this information, so do the
other tracers, through the new eprobe interface:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/Documentation/trace?id=7491e2c442781a1860181adb5ab472a52075f393

(I just realized we are missing updates to the Documentation directory).

event probes allows one to attach to an existing trace event, and then
create a new trace event that can read through pointers. It uses the same
interface that kprobes has.

Just adding trace events to VFS that only have pointers would allow all of
BPF, perf and ftrace access as eprobes could then get the data you are
looking for.

-- Steve
