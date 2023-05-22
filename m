Return-Path: <netdev+bounces-4131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C258B70B2D5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 03:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 684B0280E22
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 01:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C632A40;
	Mon, 22 May 2023 01:37:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F57A31;
	Mon, 22 May 2023 01:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF9C433D2;
	Mon, 22 May 2023 01:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684719421;
	bh=rQqm+d2EFHE384n3OSuP7ZiGPEVYIDUl4XCUxQmHiHw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fODKzsVEdpuUNT4XkenMR4SXPk3B7CrscOcXbn7e90X7TRp+hpkWjfCI69nsRnPMe
	 QddI+4EluM2i7qZrEtYkhWZ5Zl9ZY1hs+ibe/vgajauD7cI4rLUZROLpXK0Fk5itXg
	 zd6YYGwZ9RJHnsBdUQZIFoGVAagT4KON1juorPMzHZmOHSPMavAJdmsxrl0l3TtPPo
	 CCJ+oUJc3cJLKhHADaVm2H45tX7X41evI5TTeNIM8aXsi9lVzRq3YjpwPZwTx6Ygpm
	 Q1dgynMmMhEKyVvnmZJAMS/W/AuHfWFPGljHQqg/YRBzAzZcX41dN9wHlV3IhooRAi
	 BOuzepKu4OVHg==
Date: Mon, 22 May 2023 10:36:52 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: Ze Gao <zegao2021@gmail.com>, Yonghong Song <yhs@meta.com>, Alexei
 Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, John
 Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@google.com>, Steven
 Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kafai@fb.com, kpsingh@chromium.org,
 netdev@vger.kernel.org, paulmck@kernel.org, songliubraving@fb.com, Ze Gao
 <zegao@tencent.com>
Subject: Re:
Message-Id: <20230522103652.4c1680bb945cba22ccba6a79@kernel.org>
In-Reply-To: <ZGp+fW855gmWuh9W@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
	<20230520094722.5393-1-zegao@tencent.com>
	<b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
	<CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
	<ZGp+fW855gmWuh9W@krava>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 21 May 2023 22:26:37 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Sun, May 21, 2023 at 11:10:16PM +0800, Ze Gao wrote:
> > > kprobe_multi/fprobe share the same set of attachments with fentry.
> > > Currently, fentry does not filter with !rcu_is_watching, maybe
> > > because this is an extreme corner case. Not sure whether it is
> > > worthwhile or not.
> > 
> > Agreed, it's rare, especially after Peter's patches which push narrow
> > down rcu eqs regions
> > in the idle path and reduce the chance of any traceable functions
> > happening in between.
> > 
> > However, from RCU's perspective, we ought to check if rcu_is_watching
> > theoretically
> > when there's a chance our code will run in the idle path and also we
> > need rcu to be alive,
> > And also we cannot simply make assumptions for any future changes in
> > the idle path.
> > You know, just like what was hit in the thread.
> > 
> > > Maybe if you can give a concrete example (e.g., attachment point)
> > > with current code base to show what the issue you encountered and
> > > it will make it easier to judge whether adding !rcu_is_watching()
> > > is necessary or not.
> > 
> > I can reproduce likely warnings on v6.1.18 where arch_cpu_idle is
> > traceable but not on the latest version
> > so far. But as I state above, in theory we need it. So here is a
> > gentle ping :) .
> 
> hum, this change [1] added rcu_is_watching check to ftrace_test_recursion_trylock,
> which we use in fprobe_handler and is coming to fprobe_exit_handler in [2]
> 
> I might be missing something, but it seems like we don't need another
> rcu_is_watching call on kprobe_multi level

Good point! OK, then it seems we don't need it. The rethook continues to
use the rcu_is_watching() because it is also used from kprobes, but the
kprobe_multi doesn't need it.

Thank you,

> 
> jirka
> 
> 
> [1] d099dbfd3306 cpuidle: tracing: Warn about !rcu_is_watching()
> [2] https://lore.kernel.org/bpf/20230517034510.15639-4-zegao@tencent.com/


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

