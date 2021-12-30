Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DCB481944
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 05:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbhL3EQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 23:16:55 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]:33626 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbhL3EQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 23:16:54 -0500
Received: by mail-qk1-f175.google.com with SMTP id de30so21717087qkb.0;
        Wed, 29 Dec 2021 20:16:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DMt/az0eWUgDPeK+xQBQ/1ORAuUzfUrR/WRqazjMwVI=;
        b=m6udy6hxqgGMpRHcRQUpWbokEsNqlOtSJSB1HIgGmpb8AmHVJDHwR5wjA88oCHVE22
         l1MVNLNDZ90ZGM+HcIKlnvd1HJ3FuR8z7NaCptx/TdDgMLUXyJaJ3hNufhVIHscsy/nb
         lpVmdlNuS/AsyaOsUT034HPR1xaCSAESzVEbM/sr5xjiUgaZQGPlqU7A9quPwEU355pH
         tl4hU2Pjg0e+VmiRpeObh4EGBt4VsE+hKeNhD3lM6b+083YvXbfeeebziej5Q+GewR7A
         FALJCWlK+C5HLjPmdqkZK9Ksq+t0YbsAFqhObdWxz6thOywo7dSBaSEQwIOQQhxgETAB
         9aKA==
X-Gm-Message-State: AOAM5306iveK+P9XMTHtE6j8BhkDsF9ZnZUi/YbvZQ2gmu7f3T1JKl81
        0LfN/CoQK89h5cKDcrGXOhLQi/HnnD2VHQ==
X-Google-Smtp-Source: ABdhPJziRq8H61UMeCPVVziRrMIUUKj0hBHpYBoJW3a00mf2YuFxxDjYQX8Bhux60UvKPk9CvQwVZA==
X-Received: by 2002:a37:6941:: with SMTP id e62mr20755790qkc.735.1640837813124;
        Wed, 29 Dec 2021 20:16:53 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-016.fbsv.net. [2a03:2880:20ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id u19sm13736320qke.1.2021.12.29.20.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 20:16:52 -0800 (PST)
Date:   Wed, 29 Dec 2021 20:16:50 -0800
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com
Cc:     linux-modules@vger.kernel.org, mcgrof@kernel.org, jeyu@kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding modules + BPF list and maintainers to this thread.

David Vernet <void@manifault.com> wrote on Wed [2021-Dec-29 13:56:47 -0800]:
> When initializing a 'struct klp_object' in klp_init_object_loaded(), and
> performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
> is invoked to look up the address of a symbol in an already-loaded module
> (or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
> module_kallsyms_on_each_symbol() to find the address of the symbol that is
> being patched.
> 
> It turns out that symbol lookups often take up the most CPU time when
> enabling and disabling a patch, and may hog the CPU and cause other tasks
> on that CPU's runqueue to starve -- even in paths where interrupts are
> enabled.  For example, under certain workloads, enabling a KLP patch with
> many objects or functions may cause ksoftirqd to be starved, and thus for
> interrupts to be backlogged and delayed. This may end up causing TCP
> retransmits on the host where the KLP patch is being applied, and in
> general, may cause any interrupts serviced by softirqd to be delayed while
> the patch is being applied.
> 
> So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
> CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
> and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
> lookup in vmlinux and a module respectively.  Without this patch, if a
> live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
> ~10x spike is observed in TCP retransmits while the patch is being applied.
> Additionally, collecting sched events with perf indicates that ksoftirqd is
> awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
> increase in TCP retransmit events is observed, and ksoftirqd is scheduled
> shortly after it's awakened.
> 
> Signed-off-by: David Vernet <void@manifault.com>
> ---
>  kernel/kallsyms.c | 1 +
>  kernel/module.c   | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 0ba87982d017..2a9afe484aec 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -223,6 +223,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  		ret = fn(data, namebuf, NULL, kallsyms_sym_address(i));
>  		if (ret != 0)
>  			return ret;
> +		cond_resched();
>  	}
>  	return 0;
>  }
> diff --git a/kernel/module.c b/kernel/module.c
> index 40ec9a030eec..c96160f7f3f5 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -4462,6 +4462,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>  				 mod, kallsyms_symbol_value(sym));
>  			if (ret != 0)
>  				goto out;
> +
> +			cond_resched();
>  		}
>  	}
>  out:
> -- 
> 2.30.2
> 
