Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512E11798B
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 14:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfEHMjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 08:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfEHMjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 08:39:15 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825AA20449;
        Wed,  8 May 2019 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557319153;
        bh=xHZf/Oqd/MfTgtCGtWa0Of8XqjVMhgHhLXQ/RCWa0og=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L/ky04awj3OM+92XX8sXAgkelTdwQo/U/SDn3fARJQ6sYWScqhXesM7NDiQBQDLI2
         tfcmuucvGs56FoQoEpl8qWxdJUevBICFgaw+3pqJ++cFqnJK2bAa9HfvmoHUjkpJHN
         iII7ONJSfXINxuYMH6KOD8bm+DsPDeq/RoVtg+fY=
Date:   Wed, 8 May 2019 21:39:04 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        bpf@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 1/4] bpf: Add support for reading user pointers
Message-Id: <20190508213904.44de50870a54167cc924034e@kernel.org>
In-Reply-To: <7e0d07af-79ad-5ff3-74ce-c12b0b9b78cd@iogearbox.net>
References: <20190506183116.33014-1-joel@joelfernandes.org>
        <3c6b312c-5763-0d9c-7c2c-436ee41f9be1@iogearbox.net>
        <20190506195711.GA48323@google.com>
        <7e0d07af-79ad-5ff3-74ce-c12b0b9b78cd@iogearbox.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 May 2019 01:10:45 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 05/06/2019 09:57 PM, Joel Fernandes wrote:
> > On Mon, May 06, 2019 at 09:11:19PM +0200, Daniel Borkmann wrote:
> >> On 05/06/2019 08:31 PM, Joel Fernandes (Google) wrote:
> >>> The eBPF based opensnoop tool fails to read the file path string passed
> >>> to the do_sys_open function. This is because it is a pointer to
> >>> userspace address and causes an -EFAULT when read with
> >>> probe_kernel_read. This is not an issue when running the tool on x86 but
> >>> is an issue on arm64. This patch adds a new bpf function call based
> >>> which calls the recently proposed probe_user_read function [1].
> >>> Using this function call from opensnoop fixes the issue on arm64.
> >>>
> >>> [1] https://lore.kernel.org/patchwork/patch/1051588/
> >>>
> >>> Cc: Michal Gregorczyk <michalgr@live.com>
> >>> Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
> >>> Cc: Mohammad Husain <russoue@gmail.com>
> >>> Cc: Qais Yousef <qais.yousef@arm.com>
> >>> Cc: Srinivas Ramana <sramana@codeaurora.org>
> >>> Cc: duyuchao <yuchao.du@unisoc.com>
> >>> Cc: Manjo Raja Rao <linux@manojrajarao.com>
> >>> Cc: Karim Yaghmour <karim.yaghmour@opersys.com>
> >>> Cc: Tamir Carmeli <carmeli.tamir@gmail.com>
> >>> Cc: Yonghong Song <yhs@fb.com>
> >>> Cc: Alexei Starovoitov <ast@kernel.org>
> >>> Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
> >>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> >>> Cc: Peter Ziljstra <peterz@infradead.org>
> >>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >>> Cc: Steven Rostedt <rostedt@goodmis.org>
> >>> Cc: Kees Cook <keescook@chromium.org>
> >>> Cc: kernel-team@android.com
> >>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> >>> ---
> >>> Masami, could you carry these patches in the series where are you add
> >>> probe_user_read function?
> >>>
> >>> Previous submissions is here:
> >>> https://lore.kernel.org/patchwork/patch/1069552/
> >>> v1->v2: split tools uapi sync into separate commit, added deprecation
> >>> warning for old bpf_probe_read function.
> >>
> >> Please properly submit this series to bpf tree once the base
> >> infrastructure from Masami is upstream.
> > 
> > Could you clarify what do you mean by "properly submit this series to bpf
> > tree" mean? bpf@vger.kernel.org is CC'd.
> 
> Yeah, send the BPF series to bpf@vger.kernel.org once Masami's patches have
> hit mainline, and we'll then route yours as fixes the usual path through
> bpf tree.

OK, then I focus on my series. Keep this series separated.
Thank you!

> 
> >> This series here should
> >> also fix up all current probe read usage under samples/bpf/ and
> >> tools/testing/selftests/bpf/.
> > 
> > Ok. Agreed, will do that.
> 
> Great, thanks!
> Daniel


-- 
Masami Hiramatsu <mhiramat@kernel.org>
