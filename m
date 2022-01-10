Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6271C489B6E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 15:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiAJOjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 09:39:02 -0500
Received: from mail-qv1-f43.google.com ([209.85.219.43]:45844 "EHLO
        mail-qv1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiAJOjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 09:39:01 -0500
Received: by mail-qv1-f43.google.com with SMTP id a9so14599906qvd.12;
        Mon, 10 Jan 2022 06:39:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pO7pYeF0q/KOlSDXskK/am/odc2RYkvEzSsdTjA4sWM=;
        b=gRTbjgJmxjdCUi7JMQk7WGmiyclPZeWwmgoeu2VyXeCHGgJ9Vz7o/Dk5ijtymrXntb
         g3M65jKF9TnEdtGpgstLScFbD4OBJfzVwHaHynhg6OUOW2zpVqM+fKYFocDJyUuHeoDz
         HPsQlsqJihg/rjA2LxB7MUL03k/IavUEby7njHPZa/Ve/31HezB6CLE2qMPxgZ7Z2SwP
         2tSJtiFZ4XzqzojNTd78hDXNo6bCETKkNsOlyT9wcKu1Zh4EUITJrZjnJhkzUQaLtFTm
         9JILxMwCgKBv4A89KFQtI1cE1QRvWGn6reomc2kuoOhD6l0QzYx/HFeZcy463gNcMCbF
         g1Fw==
X-Gm-Message-State: AOAM533vUXmtCoff9+QHKY+wIY/A0NkDKQMHKO7qVIqr9G7UD4S426mP
        SwOybfGK2YepZxnpwxHmPsTtROvv6fmNxg==
X-Google-Smtp-Source: ABdhPJym7QBoq8Zjc+aKSJ0iSTaFS10mpRbgvEa+KZAl3mkEJk7GZpOWuY2DnxGzvLYA1H/MIZou1A==
X-Received: by 2002:a05:6214:2a88:: with SMTP id jr8mr69282684qvb.18.1641825540470;
        Mon, 10 Jan 2022 06:39:00 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-006.fbsv.net. [2a03:2880:20ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id k8sm4931234qtx.35.2022.01.10.06.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 06:39:00 -0800 (PST)
Date:   Mon, 10 Jan 2022 06:38:58 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, linux-modules@vger.kernel.org,
        mcgrof@kernel.org, jeyu@kernel.org, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, clm@fb.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <YdxFAshozmxfiLd/@dev0025.ash9.facebook.com>
References: <Yc0yskk0m2bePLu6@dev0025.ash9.facebook.com>
 <YdMej8L0bqe+XetW@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdMej8L0bqe+XetW@alley>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies all for the delayed response -- I was still on holiday last week.

Petr Mladek <pmladek@suse.com> wrote on Mon [2022-Jan-03 17:04:31 +0100]:
> > > It turns out that symbol lookups often take up the most CPU time when
> > > enabling and disabling a patch, and may hog the CPU and cause other tasks
> > > on that CPU's runqueue to starve -- even in paths where interrupts are
> > > enabled.  For example, under certain workloads, enabling a KLP patch with
> > > many objects or functions may cause ksoftirqd to be starved, and thus for
>     ^^^^^^^^^^^^^^^^^^^^^^^^^
> This suggests that a single kallsyms_on_each_symbol() is not a big
> problem. cond_resched() might be called non-necessarily often there.
> I wonder if it would be enough to add cond_resched() into the two
> loops calling klp_find_object_symbol().

In the initial version of the patch I was intending to send out, I actually
had the cond_resched() in klp_find_object_symbol(). Having it there did
appear to fix the ksoftirqd starvation issue, but I elected to put it in
klp_find_object_symbol() after Chris (cc'd) suggested it because
cond_resched() is so lightweight, and it didn't affect the runtime for
livepatching in my experiments.

> That said, kallsyms_on_each_symbol() is a slow path and there might
> be many symbols. So, it might be the right place.

Yes, my thinking was that because it didn't seem to affect throughput, and
because it would could potentially cause the same ssue to occur if it were
ever called elsewhere, that this was the correct place for it.
