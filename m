Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF76A8F513
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733211AbfHOTqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43585 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733205AbfHOTqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:46:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id v12so1825599pfn.10
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q9R0vNoUpwKLeu2pnfmt46PqrXtqSmivMtowXnYTOZo=;
        b=H0/RvPSUgkXdfxxI3i5LVxFFjGoQjDU4tEClLQbXRTozuKmyG66rsuwuaQhm6opn8L
         YfqvyrmFeGimX21lZuHDTTWFEXr8ocu9gR3Jv1WZm6e9nsPzXLaQIup05uukgtM8RKDj
         XddoB41uZ7kY/ujqgXTjaa5ORKT5c/3HP1uYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q9R0vNoUpwKLeu2pnfmt46PqrXtqSmivMtowXnYTOZo=;
        b=MYGKAGFoqHrCi5vViQJZxqmeO+IrfSBsep43rARxi2cATyVBx7qj0/lpx7SN86Koj1
         JMXUiDOQ9vRJMDgfRXDiMlw6n3CfvaolnKe4TFmzUxHu5sevrTmqa6YaQWQW/QYDjuG/
         Mn27RwP5CUA2YPE+64uku/Mxn7pFE1J6AQOpSx4o5QJK6KK2bTM0Ltqr5POh8JG6eldO
         RIKP0DV8ipTHkPdAXXIpcMBWuZIiRkuNkWjgY44sGjSq+7T/X67ed1rXla32nfmRsb7D
         faMz0QOBI1FUxYn1f73+etuRjjqHMTeieGTlnz0jvxoozqNbVR8AtjVV5ZyAi4K8gDqH
         +eAg==
X-Gm-Message-State: APjAAAV/zLvhFdHDWkpc121dQOYNlNfrpUTmb1cypmBAmzQLJgZZTJ1Z
        o0Ttf6YLeqxurySynWF92ASAYw==
X-Google-Smtp-Source: APXvYqwkdKiJuv/6WIKEpcaHaZ22PyLLwMhSfjqdJkm4PMqDnc+jsZVtxZmMArS1ytN4WQAQBH5eLg==
X-Received: by 2002:a63:a302:: with SMTP id s2mr4777940pge.125.1565898403670;
        Thu, 15 Aug 2019 12:46:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm4327185pfr.140.2019.08.15.12.46.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 12:46:42 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:46:41 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <201908151203.FE87970@keescook>
References: <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813215823.3sfbakzzjjykyng2@ast-mbp>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 02:58:25PM -0700, Alexei Starovoitov wrote:
> agree that containers (namespaces) reduce amount of trust necessary
> for apps to run, but the end goal is not security though.

Unsurprisingly, I totally disagree: this is the very definition of
improved "security": reduced attack surface, confined trust, etc.

> Linux has become a single user system.

I hope this is just hyperbole, because it's not true in reality. I agree
that the vast majority of Linux devices are single-user-at-a-time
systems now (rather than the "shell servers" of yore), but the system
still has to be expected to confine users from each other, root, and the
hardware. Switching users on Chrome OS or a distro laptop, etc is still
very much expected to _mean_ something.

> If user can ssh into the host they can become root.
> If arbitrary code can run on the host it will be break out of any sandbox.
> Containers are not providing the level of security that is enough
> to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.

I'm not sure why you draw the line for VMs -- they're just as buggy
as anything else. Regardless, I reject this line of thinking: yes,
all software is buggy, but that isn't a reason to give up. In fact,
we should be trying very hard to create safe code (*insert arguments
for sane languages and toolchains here*).

If you look at software safety as a binary, you will always be
disappointed. If you look at it as it manifests in the real world,
then there is some perspective to be had. Reachability of flaws becomes
a major factor; exploit chain length becomes a factor. There are very
real impacts to be had from security hardening, sandboxing, etc. Of
course nothing is perfect, but the current state of the world isn't
as you describe. (And I say this with the knowledge of how long
the lifetime of bugs are in the kernel.)

> Containers are used to make production systems safer.

Yes.

> Some people call it more 'secure', but it's clearly not secure for
> arbitrary code

Perhaps it's just a language issue. "More secure" and "safer" mean
mostly the same thing to me. I tend to think "safer" is actually
a superset that includes things that wreck the user experience but
aren't actually in the privilege manipulation realm. In the traditional
"security" triad of confidentiality, integrity, and availability, I tend
to weigh availability less highly, but a bug that stops someone from
doing their work but doesn't wreck data, let them switch users, etc,
is still considered a "security" issue by many folks. The fewer bugs
someone is exposed to improves their security, safety, whatever. The
easiest way to do that is confinement and its associated attack surface
reduction. tl;dr: security and safety are very use-case-specific
continuum, not a binary state.

> When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> It's been a constant source of pain. The constant blinding, randomization,
> verifier speculative analysis, all spectre v1, v2, v4 mitigations
> are simply not worth it. It's a lot of complex kernel code without users.
> There is not a single use case to allow arbitrary malicious bpf
> program to be loaded and executed.

The world isn't binary (safe code/malicious code), and we need to build
systems that can be used safely even when things go wrong. Yes, probably
no one has a system that _intentionally_ feeds eBPF into the kernel from
a web form. But there is probably someone who does it unintentionally,
or has a user login exposed on a system where unpriv BPF is enabled. The
point is to create primitives as safely as possible so when things DO
go wrong, they fail safe instead of making things worse.

I'm all for a "less privileged than root" API for eBPF, but I get worried
when I see "security" being treated as a binary state. Especially when
it is considered an always-failed state. :)

-- 
Kees Cook
