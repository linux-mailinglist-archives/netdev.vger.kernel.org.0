Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D2648D898
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiAMNPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiAMNPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:15:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1D9C06173F;
        Thu, 13 Jan 2022 05:15:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D17AE616C9;
        Thu, 13 Jan 2022 13:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14CEC36AE3;
        Thu, 13 Jan 2022 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642079738;
        bh=xQVTKDZzsFtlhCL8BzwYKaH2UmaQPcZ7CBG/VUdwYIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b2gQ9meTpLGrX0Ciip0/ORIKxjmNs3QOgS38E4v6w/yxxEM9WXNY39gU6TQEAXfc6
         bQoCz3wOuGK88hxIpumnx6F+8/+1uD2N8mpvqKgyhibLwjuq1ShXG3v1getRHfd++b
         zxSoxdlf2IA07lxAHlNQ2pneVvJU3XpheL5GAssD3EJbxQ1oPaxHYMCF2Eddbn6u34
         PgDVORFkcAJQKcLwgFJrknnKNKLyikJtzICJKH9nDYx66DWYOwa/9x9sa5ZOX3wQAE
         pnGk/VPsSBdNpVIffCZIELB0EqrlPFni7FEIp8v6xOdzf4iMB6vP5lmg0oeRx5kKkd
         vPGKZiPwUuTOQ==
Date:   Thu, 13 Jan 2022 22:15:32 +0900
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
Message-Id: <20220113221532.c48abf7f56d29ba95dcb0dc6@kernel.org>
In-Reply-To: <YeAaUN8aUip3MUn8@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
        <164199620208.1247129.13021391608719523669.stgit@devnote2>
        <YeAaUN8aUip3MUn8@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 13:25:52 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Jan 12, 2022 at 11:03:22PM +0900, Masami Hiramatsu wrote:
> > Add a return hook framework which hooks the function
> > return. Most of the idea came from the kretprobe, but
> > this is independent from kretprobe.
> > Note that this is expected to be used with other
> > function entry hooking feature, like ftrace, fprobe,
> > adn kprobes. Eventually this will replace the
> > kretprobe (e.g. kprobe + rethook = kretprobe), but
> > at this moment, this is just a additional hook.
> 
> this looks similar to the code kretprobe is using now

Yes, I've mostly re-typed the code :)

> would it make sense to incrementaly change current code to provide
> this rethook interface? instead of big switch of current kretprobe
> to kprobe + new rethook interface in future?

Would you mean modifying the kretprobe instance code to provide
similar one, and rename it at some point?
My original idea is to keep the current kretprobe code and build
up the similar one, and switch to it at some point. Actually,
I don't want to change the current kretprobe interface itself,
but the backend will be changed. For example, current kretprobe
has below interface.

struct kretprobe {
        struct kprobe kp;
        kretprobe_handler_t handler;
        kretprobe_handler_t entry_handler;
        int maxactive;
        int nmissed;
        size_t data_size;
        struct freelist_head freelist;
        struct kretprobe_holder *rph;
};

My idea is switching it to below.

struct kretprobe {
        struct kprobe kp;
        kretprobe_handler_t handler;
        kretprobe_handler_t entry_handler;
        int maxactive;
        int nmissed;
        size_t data_size;
        struct rethook *rethook;
};

Of course 'kretprobe_instance' may need to be changed...

struct kretprobe_instance {
	struct rethook_node;
	char data[];
};

But even though, since there is 'get_kretprobe(ri)' wrapper, user
will be able to access the 'struct kretprobe' from kretprobe_instance
transparently.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
