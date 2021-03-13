Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C535339B69
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 03:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhCMCuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 21:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhCMCua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 21:50:30 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9DCC061574;
        Fri, 12 Mar 2021 18:50:28 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id m9so27409938ybk.8;
        Fri, 12 Mar 2021 18:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rhyPMcnHQIQmhjUZbuPpathGLF1C0v/EujW0DiDZzMY=;
        b=l6j6Yc4RE6ZuIFQpPUxzSj/6wAmMPZhY9i1m2KkEN3J14pduSSylfBRZ5hNb7sH2Q9
         BpRn2KU8KnN+IX/nPS6sJbrRLmn6lgCDVlAZO+TxsYqKnV+jZx4JPSjRuVng8WF4SAAq
         2tXsGLkPdQ3/76rWCRIQEaC5V9xz905IOdEv7keShMivQ4Hv8hypfqUl7zGqf0F1rIwC
         Kr4mUpwdJL1zwZ2AI2RzpYleCDmpwXzZtmryy7BOJfmPQ/9hHzbt4EHyY//uBy4dZcxd
         bli6h6POmsjX9tE4G5blDxTKxWsh2X39J3WCGIfJGmx3bOX9jcI/+SGhfNev9h4Xuj0s
         JKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rhyPMcnHQIQmhjUZbuPpathGLF1C0v/EujW0DiDZzMY=;
        b=boESUJYaT1vJ9Cp1Kewpt8sifyGIlJEx+hmXQcMFsoNpRTRzZc2C7jNkuOlyjv5xay
         9ghi2AedaTv3fI/1AXI8X2IZNfEbYnvE9qP+vfRL30EJ8dib2uLZcchlYLQpbsEoI8E9
         fhIrZUFR55ffc95UnIF3MGGXFOI6kgvc+REFU10CYLD3gE8BtiHv2xsoJarHvLW8AIOA
         7f+HfZmQJj1iTrCx1FcbxZh8Xx88wa+6hoIUo73998C7tE0IiCs/yNaV5OiEa3Ky2JUm
         m66SS/3m4wUnC9Xa+y89SU7wGzrHKzi0rgqwbTeXJhkJfkB5F2JuLfudBU6r60fLsUog
         gUcg==
X-Gm-Message-State: AOAM5304epAOGM0OShB55i6v9q+6EH1HAhlFm+MUWNp83hU8LpCHUY94
        EIZMXS9rJALF0gZg3ZJnf9I/UvYH8gbRMG9EnGxFm6tCV8g=
X-Google-Smtp-Source: ABdhPJy5983T76dF04EQX438ihV7W/6Ebm8MtFH5oyxF7sQDuFmUdLTOqyrrjxohw5uqKwNfHphZODm1ifbUwT2o3s0=
X-Received: by 2002:a25:d94:: with SMTP id 142mr21883722ybn.230.1615603827962;
 Fri, 12 Mar 2021 18:50:27 -0800 (PST)
MIME-Version: 1.0
References: <20210312214316.132993-1-sultan@kerneltoast.com>
 <CAEf4BzYBj254AtZxjMKdJ_yoP9Exvjuyotc8XZ7AUCLFG9iHLQ@mail.gmail.com>
 <YEwh2S3n8Ufgyovr@sultan-box.localdomain> <CAEf4BzaSyg8XjT2SrwW+b+b+r571FuseziV6PniMv+b7pwgW5A@mail.gmail.com>
 <YEwm3ikmNMB3Vlzq@sultan-box.localdomain>
In-Reply-To: <YEwm3ikmNMB3Vlzq@sultan-box.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Mar 2021 18:50:17 -0800
Message-ID: <CAEf4BzZkuW94jSNfEdp0VR7Z=6tfEH_wo05wyunuO+D9VXmmtA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Use the correct fd when attaching to perf events
To:     Sultan Alsawaf <sultan@kerneltoast.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 6:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
>
> On Fri, Mar 12, 2021 at 06:33:01PM -0800, Andrii Nakryiko wrote:
> > On Fri, Mar 12, 2021 at 6:22 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> > >
> > > On Fri, Mar 12, 2021 at 05:31:14PM -0800, Andrii Nakryiko wrote:
> > > > On Fri, Mar 12, 2021 at 1:43 PM Sultan Alsawaf <sultan@kerneltoast.com> wrote:
> > > > >
> > > > > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > > > >
> > > > > We should be using the program fd here, not the perf event fd.
> > > >
> > > > Why? Can you elaborate on what issue you ran into with the current code?
> > >
> > > bpf_link__pin() would fail with -EINVAL when using tracepoints, kprobes, or
> > > uprobes. The failure would happen inside the kernel, in bpf_link_get_from_fd()
> > > right here:
> > >         if (f.file->f_op != &bpf_link_fops) {
> > >                 fdput(f);
> > >                 return ERR_PTR(-EINVAL);
> > >         }
> >
> > kprobe/tracepoint/perf_event attachments behave like bpf_link (so
> > libbpf uses user-space high-level bpf_link APIs for it), but they are
> > not bpf_link-based in the kernel. So bpf_link__pin() won't work for
> > such types of programs until we actually have bpf_link-backed
> > attachment support in the kernel itself. I never got to implementing
> > this because we already had auto-detachment properties from perf_event
> > FD itself. But it would be nice to have that done as a real bpf_link
> > in the kernel (with all the observability, program update,
> > force-detach support).
> >
> > Looking for volunteers to make this happen ;)
> >
> >
> > >
> > > Since bpf wasn't looking for the perf event fd, I swapped it for the program fd
> > > and bpf_link__pin() worked.
> >
> > But you were pinning the BPF program, not a BPF link. Which is not
> > what should have happen.
>
> This is the code in question:
>         link = bpf_program__attach(prog);
>         // make sure `link` is valid, blah blah...
>         bpf_link__pin(link, some_path);
>
> Are you saying that this usage is incorrect?

Right, for kprobe/tracepoint/perf_event attachments it's not
supported. cgroup, xdp, raw_tracepoint and
fentry/fexit/fmod_ret/freplace (and a few more) attachments are
bpf_links in the kernel, so it works for them.

>
> Sultan
