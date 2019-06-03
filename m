Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125E233C25
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfFCXyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:54:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33130 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFCXyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:54:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id v29so6625373ljv.0;
        Mon, 03 Jun 2019 16:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g9m612Ua5ZtJoE5e9+kvoqKKvahu9EaWnw+91ctupQU=;
        b=O8pewUE47xHrXtZ+DxPtT2115bZe28AI3dMiXT3Pve3hdsJz7hB9nUECfyjeOMmA+j
         rFwxiV4/ku6k6mKKqh609VH7YWqv07p5LKzxLm/wUwgHYa26/Qv3b3jk6hNyYppSdut6
         rO37eJcRNEgZWAtuRH/ivBUAx/2T3hXvzRSaYUQZLiWG+Ucs7VkwfYFuf5AayRGNIhaV
         iS+KpUR2dtBTTl3PZbU65JGpdVdRln0iXDofEaQKlqlrujttVmlTNOTP7xKcylzmFvOQ
         6b6mC4bFx0fd8Wii0X0JPLNXNNnx5AwfiaqiwnDTKdCfUDIpgc0zLpw2SmrFKVlMQ6nS
         U/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9m612Ua5ZtJoE5e9+kvoqKKvahu9EaWnw+91ctupQU=;
        b=Vt0FObVlBnIEEIPkD3ZXuD9hfHMMh5wYKX2pVHhx/GCFSVI5O93d298eOV/2nIxF0E
         df+Wdo77xDA7+82ONNtzqJGPAgGCggJFJ+CeO0EMvGhXmVfxaNTAHgSy01/ejlU5mPGI
         /iDMCJfpA3TiVIrJylNcMShHb0ndx52poflUp4US5FxxdFrbeDUJNg8+qHmvevPS2vdh
         GK8qmSKsF9dCSYmlNsczfRcK9eNmNbQI/irjWJ3GoLxS2GJ/eFBOs+1XOwh/FkH3N9q7
         sPTgAy0BakFkBuj4n8wzeGXGhYBpR18rqZTB4PKmuKlwggNWnPX6B7Jvqzw2OGhzGRu1
         YyNA==
X-Gm-Message-State: APjAAAUkblcm58lKsg08X6//c97rJTHdrQvok0glSKAIz37bual3q5LW
        LQ+g/1yXRg1sUchPSf4dUYhQFUMc969rKjiTttC+Yfks
X-Google-Smtp-Source: APXvYqyQ4eA4OAV4dR5jtvi0RzR5D1hH48qipdM5L3YSoNldq7ZCkQbnFrgwOdWEQBZgdGbhF9DZR9rR3/kY493wlhA=
X-Received: by 2002:a2e:5b5b:: with SMTP id p88mr5669244ljb.192.1559606051674;
 Mon, 03 Jun 2019 16:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190531223735.4998-1-mmullins@fb.com> <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
 <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net> <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
 <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com> <70b9a1b2-c960-b810-96f9-1fb5f4a4061b@iogearbox.net>
In-Reply-To: <70b9a1b2-c960-b810-96f9-1fb5f4a4061b@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Jun 2019 16:54:00 -0700
Message-ID: <CAADnVQKfZj5hDhyP6A=2tWAGJ2u7Fyx5d_rOTZ-ZyH1xBXtB3w@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Matt Mullins <mmullins@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Hall <hall@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 4:48 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/04/2019 01:27 AM, Alexei Starovoitov wrote:
> > On Mon, Jun 3, 2019 at 3:59 PM Matt Mullins <mmullins@fb.com> wrote:
> >>
> >> If these are invariably non-nested, I can easily keep bpf_misc_sd when
> >> I resubmit.  There was no technical reason other than keeping the two
> >> codepaths as similar as possible.
> >>
> >> What resource gives you worry about doing this for the networking
> >> codepath?
> >
> > my preference would be to keep tracing and networking the same.
> > there is already minimal nesting in networking and probably we see
> > more when reuseport progs will start running from xdp and clsbpf
> >
> >>> Aside from that it's also really bad to miss events like this as exporting
> >>> through rb is critical. Why can't you have a per-CPU counter that selects a
> >>> sample data context based on nesting level in tracing? (I don't see a discussion
> >>> of this in your commit message.)
> >>
> >> This change would only drop messages if the same perf_event is
> >> attempted to be used recursively (i.e. the same CPU on the same
> >> PERF_EVENT_ARRAY map, as I haven't observed anything use index !=
> >> BPF_F_CURRENT_CPU in testing).
> >>
> >> I'll try to accomplish the same with a percpu nesting level and
> >> allocating 2 or 3 perf_sample_data per cpu.  I think that'll solve the
> >> same problem -- a local patch keeping track of the nesting level is how
> >> I got the above stack trace, too.
> >
> > I don't think counter approach works. The amount of nesting is unknown.
> > imo the approach taken in this patch is good.
> > I don't see any issue when event_outputs will be dropped for valid progs.
> > Only when user called the helper incorrectly without BPF_F_CURRENT_CPU.
> > But that's an error anyway.
>
> My main worry with this xchg() trick is that we'll miss to export crucial
> data with the EBUSY bailing out especially given nesting could increase in
> future as you state, so users might have a hard time debugging this kind of
> issue if they share the same perf event map among these programs, and no
> option to get to this data otherwise. Supporting nesting up to a certain
> level would still be better than a lost event which is also not reported
> through the usual way aka perf rb.

I simply don't see this 'miss to export data' in all but contrived conditions.
Say two progs share the same perf event array.
One prog calls event_output and while rb logic is working
another prog needs to start executing and use the same event array
slot. Today it's only possible for tracing prog combined with networking,
but having two progs use the same event output array is pretty much
a user bug. Just like not passing BPF_F_CURRENT_CPU.
Same kind of a bug.
