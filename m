Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9558E483486
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiACQEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:04:38 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51426 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiACQEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 11:04:33 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DC1841F381;
        Mon,  3 Jan 2022 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641225871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JI+ClfcBMEbVg7coPIrkba4vZBLWnxY727vXuk1pUjY=;
        b=cAXVKimh/25e7k0h4Fjf9E377qfeC6mgx7qKcakGt6KYb8hqr1YNKzxyX468cF8JHd2hEz
        1L/OIGta7OC8iDrISx0l38a1QC4d8vZogiwM9oCiQdIemq3VfonU3xVAjq2vpVdkeCWmUi
        4DQFPk9PV6BHxAlVpS3d/r5bfGNDUcw=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B0EF3A3B8B;
        Mon,  3 Jan 2022 16:04:31 +0000 (UTC)
Date:   Mon, 3 Jan 2022 17:04:31 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, linux-modules@vger.kernel.org,
        mcgrof@kernel.org, jeyu@kernel.org, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <YdMej8L0bqe+XetW@alley>
References: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2021-12-29 20:16:50, David Vernet wrote:
> Adding modules + BPF list and maintainers to this thread.
> 
> David Vernet <void@manifault.com> wrote on Wed [2021-Dec-29 13:56:47 -0800]:
> > When initializing a 'struct klp_object' in klp_init_object_loaded(), and
> > performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
> > is invoked to look up the address of a symbol in an already-loaded module
> > (or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
> > module_kallsyms_on_each_symbol() to find the address of the symbol that is
> > being patched.
> > 
> > It turns out that symbol lookups often take up the most CPU time when
> > enabling and disabling a patch, and may hog the CPU and cause other tasks
> > on that CPU's runqueue to starve -- even in paths where interrupts are
> > enabled.  For example, under certain workloads, enabling a KLP patch with
> > many objects or functions may cause ksoftirqd to be starved, and thus for
    ^^^^^^^^^^^^^^^^^^^^^^^^^
This suggests that a single kallsyms_on_each_symbol() is not a big
problem. cond_resched() might be called non-necessarily often there.
I wonder if it would be enough to add cond_resched() into the two
loops calling klp_find_object_symbol().

That said, kallsyms_on_each_symbol() is a slow path and there might
be many symbols. So, it might be the right place.

I am just thinking loudly. I do not have strong opinion. I am fine
with any cond_resched() location that solves the problem. Feel free
to use:

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr


> > interrupts to be backlogged and delayed. This may end up causing TCP
> > retransmits on the host where the KLP patch is being applied, and in
> > general, may cause any interrupts serviced by softirqd to be delayed while
> > the patch is being applied.
> > 
> > So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
> > CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
> > and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
> > lookup in vmlinux and a module respectively.  Without this patch, if a
> > live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
> > ~10x spike is observed in TCP retransmits while the patch is being applied.
> > Additionally, collecting sched events with perf indicates that ksoftirqd is
> > awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
> > increase in TCP retransmit events is observed, and ksoftirqd is scheduled
> > shortly after it's awakened.
> > 
> > Signed-off-by: David Vernet <void@manifault.com>
> > ---
> >  kernel/kallsyms.c | 1 +
> >  kernel/module.c   | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 0ba87982d017..2a9afe484aec 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -223,6 +223,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> >  		ret = fn(data, namebuf, NULL, kallsyms_sym_address(i));
> >  		if (ret != 0)
> >  			return ret;
> > +		cond_resched();
> >  	}
> >  	return 0;
> >  }
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 40ec9a030eec..c96160f7f3f5 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -4462,6 +4462,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
> >  				 mod, kallsyms_symbol_value(sym));
> >  			if (ret != 0)
> >  				goto out;
> > +
> > +			cond_resched();
> >  		}
> >  	}
> >  out:
> > -- 
> > 2.30.2
> > 
