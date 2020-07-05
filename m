Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CB214F3C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgGEUTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgGEUTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:19:30 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72FC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:19:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d194so14054459pga.13
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+eZV+j8eeFdPL7ONsmuokgRfsTEj+RVF3Zfsba4wHfM=;
        b=U0xvOvuXhudjDoBG+0i7o4XZqsk9kQ1pmOzKAJi8NTpaqdwkOAJCFbBTmvNmLU1mx2
         cov3g0kKS/RbI1mPqNukvoRPoGAQgMe265ZEkjknljF5Y4PwvMEsDYhQ8wDcwKjievyJ
         f5sL5Eyl+6oZIKIqIV/1y30e3zOLE7wWjd9TQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+eZV+j8eeFdPL7ONsmuokgRfsTEj+RVF3Zfsba4wHfM=;
        b=tu9Bi+UTECrR7FZ0gaG6tOpVQcWBTvcX9WUTipgi9/++tELrmxmvCVDJ3o1i3mX2E/
         AjbvzkBFMt9ihg7FLjirHllXjm0Avos/Eb03hg6VPpifF7eqbobh4GVsHo857Iqfocgj
         PnAMpmMzpyG/sdov14Sf0maiARtd3ZiK6wuNeFIEVP45NnDQC5bUsWJjVYQaWo/tlhWM
         Mf9KW+5UIOo0tkrjU9uiiKuvmq9YI1JvrajiVRF/DUci921iGsskmZjcWh+2T9GRbQm0
         P818Q+FpriolKU8rf8W+XkV507uBxTJcCu6dHsbvFSARCmMplTaFeglQDpoX1qKmdn6m
         jxFA==
X-Gm-Message-State: AOAM530f4dah6YH9ifipDUkmXYVrr/21amkHjG3lPdV1YBZthUa+Ikrp
        CrEfRcp5dnLlY2oawxVCRN2f2Q==
X-Google-Smtp-Source: ABdhPJwUhUfKUYtmlsWvQMFnUPyfezn5Vv/jyidaFG9Inycnc/k4yYuK1QdR1r4fgYhzZSuXNwkQyw==
X-Received: by 2002:a63:525a:: with SMTP id s26mr36603596pgl.155.1593980369927;
        Sun, 05 Jul 2020 13:19:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n62sm6691891pjb.28.2020.07.05.13.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 13:19:28 -0700 (PDT)
Date:   Sun, 5 Jul 2020 13:19:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable <stable@vger.kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] kprobes: Do not expose probe addresses to
 non-CAP_SYSLOG
Message-ID: <202007051318.CA51091A@keescook>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-5-keescook@chromium.org>
 <CAHk-=wiZi-v8Xgu_B3wV0B4RQYngKyPeONdiXNgrHJFU5jbe1w@mail.gmail.com>
 <202007030848.265EA58@keescook>
 <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgEkTsNRvEM9W_JiVN6t70SnPuP=-1=LyhLS_BJ25Q4sQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 01:10:54PM -0700, Linus Torvalds wrote:
> On Fri, Jul 3, 2020 at 8:50 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > With 67 kthreads on a booted system, this patch does not immediately
> > blow up...
> 
> Did you try making read/write inc/dec that thing too? Or does that
> just blow up with tons of warnings?

I hadn't gotten to that yet. I need to catch up on other stuff first,
and I thought I'd give people time to scream if they tested this
themselves. :)

-- 
Kees Cook
