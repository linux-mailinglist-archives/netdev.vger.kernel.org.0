Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF3D48F4CB
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 05:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiAOEjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 23:39:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiAOEjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 23:39:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8EC9B82A3F;
        Sat, 15 Jan 2022 04:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB737C36AE3;
        Sat, 15 Jan 2022 04:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642221553;
        bh=Lmw0vnQYmWnz1sy8w6vxj9DD1VhxFXZBl4P4Jg4yq/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZCQYVVEZGKXxUXg07KpzKKYBf449x8VFMf4m6GuD2mqoi+QiHmDAOu8vU6moy9CK8
         zWTxMxTX5/L5M1Ka2gA2sgmMS+oRyeecauqGf8wD0v+E8EEv9o5GjQ4720OUKadL6Z
         0FrUNOWwuWnUatKXjZtLVwcFZOBmH97XizYRIgt4BXmGVEEnXK1OGANfounfdyJexz
         odmNVhmDZ3OV5IJY+c8b+oCSjd6zWHfDixXtEjFiTGGa8/Y8aYgfxnMt5FQ4IQvIOa
         Gw1wVApnGt2fXnW+QOBPH7KaYzvvDjROUPMFhWLYKfXipl4anZz3Gv0lr3GW06ERkc
         YGpyCsbdkLiWw==
Date:   Sat, 15 Jan 2022 13:39:07 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 3/8] rethook: Add a generic return hook
Message-Id: <20220115133907.2a713806100fc0f7a562a96b@kernel.org>
In-Reply-To: <YeGUNRH9MiF7dgVs@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
        <164199620208.1247129.13021391608719523669.stgit@devnote2>
        <YeAaUN8aUip3MUn8@krava>
        <20220113221532.c48abf7f56d29ba95dcb0dc6@kernel.org>
        <YeGUNRH9MiF7dgVs@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jan 2022 16:18:13 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Jan 13, 2022 at 10:15:32PM +0900, Masami Hiramatsu wrote:
> > On Thu, 13 Jan 2022 13:25:52 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > On Wed, Jan 12, 2022 at 11:03:22PM +0900, Masami Hiramatsu wrote:
> > > > Add a return hook framework which hooks the function
> > > > return. Most of the idea came from the kretprobe, but
> > > > this is independent from kretprobe.
> > > > Note that this is expected to be used with other
> > > > function entry hooking feature, like ftrace, fprobe,
> > > > adn kprobes. Eventually this will replace the
> > > > kretprobe (e.g. kprobe + rethook = kretprobe), but
> > > > at this moment, this is just a additional hook.
> > > 
> > > this looks similar to the code kretprobe is using now
> > 
> > Yes, I've mostly re-typed the code :)
> > 
> > > would it make sense to incrementaly change current code to provide
> > > this rethook interface? instead of big switch of current kretprobe
> > > to kprobe + new rethook interface in future?
> > 
> > Would you mean modifying the kretprobe instance code to provide
> > similar one, and rename it at some point?
> > My original idea is to keep the current kretprobe code and build
> > up the similar one, and switch to it at some point. Actually,
> > I don't want to change the current kretprobe interface itself,
> > but the backend will be changed. For example, current kretprobe
> > has below interface.
> > 
> > struct kretprobe {
> >         struct kprobe kp;
> >         kretprobe_handler_t handler;
> >         kretprobe_handler_t entry_handler;
> >         int maxactive;
> >         int nmissed;
> >         size_t data_size;
> >         struct freelist_head freelist;
> >         struct kretprobe_holder *rph;
> > };
> > 
> > My idea is switching it to below.
> > 
> > struct kretprobe {
> >         struct kprobe kp;
> >         kretprobe_handler_t handler;
> >         kretprobe_handler_t entry_handler;
> >         int maxactive;
> >         int nmissed;
> >         size_t data_size;
> >         struct rethook *rethook;
> > };
> 
> looks good, will this be a lot of changes?

Yes and no, we can easily replace the kretprobe generic trampoline
callback (since it almost same, and have same feature), but it also
needs to update per-arch kretprobe trampoline to rethook trampoline.

> could you include it in the patchset?

Let me try, but since it involves many archs (which support kretprobes)
it may take a time to be merged.

Thank you,

> 
> thanks,
> jirka
> 
> > 
> > Of course 'kretprobe_instance' may need to be changed...
> > 
> > struct kretprobe_instance {
> > 	struct rethook_node;
> > 	char data[];
> > };
> > 
> > But even though, since there is 'get_kretprobe(ri)' wrapper, user
> > will be able to access the 'struct kretprobe' from kretprobe_instance
> > transparently.
> > 
> > Thank you,
> > 
> > 
> > -- 
> > Masami Hiramatsu <mhiramat@kernel.org>
> > 
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
