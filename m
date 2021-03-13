Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB351339B5E
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhCMCoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:44:08 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:38487 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhCMCnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 21:43:45 -0500
Received: by mail-pl1-f179.google.com with SMTP id s7so12771094plg.5;
        Fri, 12 Mar 2021 18:43:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ddi16htNtqOVPERhFZV9h+5Vm1yddIZafWsjYwQ4QM4=;
        b=trff/vW/J42lPpUxH9A2YlsRqcJBTfQTBCfcr/cgM4h8PepgiltC/LgrVr8EgPfV1y
         8cN45r8iiJQw+kUIwEdz5ScgMJlHdLbeqZDhKP/iMC82l4A4Ij7XFZLS/UoUC79EK15H
         FsJQKhwx8XN8IYMPwS3VUx3/ghxFYxsSfVBgiObkdeZ9dORj73RHjDSmPV4oZ+juYg5L
         RyDK9w0OU/hu8pRdFjmnuIdw/otV4+fPGVVbVUjr4Vn/feT1EBmG4D6MjPCF+qtEVw+5
         qBQr1vXgKN3MJR5So4yE0GJFO/GR7KVMLKbf4LJOzqyCiWutrawXPTlEY+ozFcwRNJWW
         WV+g==
X-Gm-Message-State: AOAM530WrWsjlVI/OAbgcOAwIcspHCO2BP4NAqJZkmHPPSqldWb4/9AL
        LtfASv3tmr1fUWemPwigT3wv385TCBAo6w==
X-Google-Smtp-Source: ABdhPJy8Us35uKVSedhNlEFC/oMJR3vYGIIIqkl9j4petZyoRqXbRrAjqiLmN1A956gawH0Dxytp3g==
X-Received: by 2002:a17:903:4112:b029:e5:f79d:3eb1 with SMTP id r18-20020a1709034112b02900e5f79d3eb1mr1449476pld.48.1615603424761;
        Fri, 12 Mar 2021 18:43:44 -0800 (PST)
Received: from sultan-box.localdomain (static-198-54-131-119.cust.tzulo.com. [198.54.131.119])
        by smtp.gmail.com with ESMTPSA id r4sm3207207pjl.15.2021.03.12.18.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 18:43:44 -0800 (PST)
Date:   Fri, 12 Mar 2021 18:43:42 -0800
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Use the correct fd when attaching to perf events
Message-ID: <YEwm3ikmNMB3Vlzq@sultan-box.localdomain>
References: <20210312214316.132993-1-sultan@kerneltoast.com>
 <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com>
 <YEwh2S3n8Ufgyovr@sultan-box.localdomain>
 <CAEf4BzaSyg8XjT2SrwW+b+b+r571FuseziV6PniMv+b7pwgW5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSyg8XjT2SrwW+b+b+r571FuseziV6PniMv+b7pwgW5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 06:33:01PM -0800, Andrii Nakryiko wrote:
> On Fri, Mar 12, 2021 at 6:22 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> >
> > On Fri, Mar 12, 2021 at 05:31:14PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Mar 12, 2021 at 1:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> > > >
> > > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > > >
> > > > We should be using the program fd here, not the perf event fd.
> > >
> > > Why? Can you elaborate on what issue you ran into with the current code?
> >
> > bpf_link__pin() would fail with -EINVAL when using tracepoints, kprobes, or
> > uprobes. The failure would happen inside the kernel, in bpf_link_get_from_fd()
> > right here:
> >         if (f.file->f_op != &bpf_link_fops) {
> >                 fdput(f);
> >                 return ERR_PTR(-EINVAL);
> >         }
> 
> kprobe/tracepoint/perf_event attachments behave like bpf_link (so
> libbpf uses user-space high-level bpf_link APIs for it), but they are
> not bpf_link-based in the kernel. So bpf_link__pin() won't work for
> such types of programs until we actually have bpf_link-backed
> attachment support in the kernel itself. I never got to implementing
> this because we already had auto-detachment properties from perf_event
> FD itself. But it would be nice to have that done as a real bpf_link
> in the kernel (with all the observability, program update,
> force-detach support).
> 
> Looking for volunteers to make this happen ;)
> 
> 
> >
> > Since bpf wasn't looking for the perf event fd, I swapped it for the program fd
> > and bpf_link__pin() worked.
> 
> But you were pinning the BPF program, not a BPF link. Which is not
> what should have happen.

This is the code in question:
	link = bpf_program__attach(prog);
	// make sure `link` is valid, blah blah...
	bpf_link__pin(link, some_path);

Are you saying that this usage is incorrect?

Sultan
