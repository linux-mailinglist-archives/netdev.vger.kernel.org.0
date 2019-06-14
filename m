Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896DE46B54
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfFNU4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:56:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45502 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNU4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 16:56:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id s21so2164273pga.12;
        Fri, 14 Jun 2019 13:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yne9fkU6wE/82N/AFeecOPZEhmtxL6CFlvongVG7mfE=;
        b=DZK18+j/Zl+kVuDlssgW7C9bDCoD1Qr+/Mmke0JecU4VD4daD2/SUDN3/4UOWFDeUI
         CsLNIKid5hnOv8RX8ROzGtFNVPZW7izEXTz+JkZ43/Ia0Xq6A1+W92ObG/VwuM4hB+Ny
         uOh/I6BFWw1ds5ZZws3gfzSBzFYdhDVX/D6JVykAcbve6VObBW2ET0dmx3WxSNn0bL/r
         YDXaPKAPKH150QgCqmFSLdewyGVGOB8KsREwIDh8RGLVGiw343ts1MHXfFYPrUN83rGF
         v/stxJCqMWqUfgWF6JqqZIEG/4YxONKFqeBYEGIH/Exr4UK7BbWM8C77hvMWAqEcSW6T
         n/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yne9fkU6wE/82N/AFeecOPZEhmtxL6CFlvongVG7mfE=;
        b=g2jcfqD3a+TDoN+96ZjXBC8gwWmYluMHKh43A8N7Dh5C/oa9JZIU1UXsVZ1cJ20ytA
         BXhf6wN6ML1k7sBG9H1U2Mkohj+WaeFUN1C67M+6tmlAXvxUW2cNlIcM0bjB11NT9tg8
         ZJlIFeDL5Z+eT5G2EPckHGAp0f3S74aE99/IqfAWIB5CZWDWc/cJgTCisDLVlMBVafCp
         Di6SO1xeio5goVk4xVcd223uOlLY7e1F1GK0JktYt74IcyODXyilUfHZPxGN3i459PK/
         6qoTlnzxeLqiJJ1S8PJO9Yfv+7atMKN/93343zWeYUnfspWWKScqxbRPUpJKur5LrX4t
         PXZQ==
X-Gm-Message-State: APjAAAWGYlTBYGEDHe9SfYKzGH86wtJ/YRQDymQQizU2t96l2lMXoedR
        nddbdVu4tU/OV6nf11USCNc=
X-Google-Smtp-Source: APXvYqz8fF3d09X3S5MDTl9m8/QKwwEvli9hG2LfLqQI22wUh+UIK5jKnhAhsQgDhY1T7Z/EgREJ0A==
X-Received: by 2002:a63:fb4b:: with SMTP id w11mr3077734pgj.415.1560545778214;
        Fri, 14 Jun 2019 13:56:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:6345])
        by smtp.gmail.com with ESMTPSA id y185sm3781367pfy.110.2019.06.14.13.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 13:56:17 -0700 (PDT)
Date:   Fri, 14 Jun 2019 13:56:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86: Always store regs->ip in
 perf_callchain_kernel()
Message-ID: <20190614205614.zr6awljx3qdg2fnb@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <81b0cdc5aa276dac315a0536df384cc82da86243.1560534694.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b0cdc5aa276dac315a0536df384cc82da86243.1560534694.git.jpoimboe@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:56:40PM -0500, Josh Poimboeuf wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> The stacktrace_map_raw_tp BPF selftest is failing because the RIP saved
> by perf_arch_fetch_caller_regs() isn't getting saved by
> perf_callchain_kernel().
> 
> This was broken by the following commit:
> 
>   d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> 
> With that change, when starting with non-HW regs, the unwinder starts
> with the current stack frame and unwinds until it passes up the frame
> which called perf_arch_fetch_caller_regs().  So regs->ip needs to be
> saved deliberately.
> 
> Fixes: d15d356887e7 ("perf/x86: Make perf callchains work without CONFIG_FRAME_POINTER")
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

It's not cool to remove people's SOB.
It's Song's patch. His should be first and your second.

