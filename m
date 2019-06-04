Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1791233C9F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 02:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFDA4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 20:56:23 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33806 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfFDA4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 20:56:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id y198so4553441lfa.1;
        Mon, 03 Jun 2019 17:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2Xqb/zhKYuTNu3NSX5P1KmcSJ/8sKaklBWHuV1TgTo=;
        b=QeUWE/YPDKUBawuFhZPXunbsCorXpNezZpjgJKlHQYPTFrVhjLVJVZBj2iobtbNdzd
         TQ03PHtx8mFhnVsNZT74RoNsAuVwHyIaJZWGiRjnBoHUJlt6tyjDue95PE0OQ4I9uirH
         gWbbayLf2z4ku1F4nKjR5rT9jQRXZhIUb6m/BNiurBm432kccJzs4++KG0KhOXS+gBGp
         ux2NP2jKyEY1gfjI+35NScQvmlHz1gx9eoLV35H0PDSqlgZSKWRS15fqJJ3O+F0R9scx
         ZzpIzM13/sLIUJG5+KoAVed5dD6aYoaNUxj1Ar2iVai4JAvWymDFcyy484f7UhTXWPSz
         SfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2Xqb/zhKYuTNu3NSX5P1KmcSJ/8sKaklBWHuV1TgTo=;
        b=FBy+VeHbfYehF1zP+KyZUIbYh2Ui8suzi6XNizshavsTexztiNoiXhNtxE5E/PB5Rs
         N9MVV6cMU9BrlXof4PIi3gpq+7ACPVwcexccVvZpakPre3Ah1sDMKwDvyWvIY9/99CME
         9yhMSwquf4fItzXTchJygnChiQ/hxT1euPLTWtk6HmytqVqWQ+xOt30RS9LIU2+nJV9e
         M149VNOE8nQsg0JI4jvxkNHXwrmfshp24fl9FY/oAToxswAucxdMZqYqXCCW7YcaVPG+
         txVvXNvyoomdM+tRAIupYnubceOZWcxFKteD9b3Un2Jw0XIYoBCKx96C6cxRzyAeukQV
         RHeA==
X-Gm-Message-State: APjAAAVLU9sSlkbT0V8+mXT6HJLHiUZTAds7O8bpbPav7SArilqzy41q
        ZfQsWaj4BcsGWJUBSuMHecojwqOMWbKBm81yYCQ=
X-Google-Smtp-Source: APXvYqzLKwbRAXpAXUIVksKUoDCoozuXJhz/HVTiZeFCkJygCva8NgNFieyZlOhyd9ruu/zSwFYXWblWxqnKTVi1/sw=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr7424654lfe.6.1559609779982;
 Mon, 03 Jun 2019 17:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190531223735.4998-1-mmullins@fb.com> <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
 <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net> <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
 <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com>
 <70b9a1b2-c960-b810-96f9-1fb5f4a4061b@iogearbox.net> <CAADnVQKfZj5hDhyP6A=2tWAGJ2u7Fyx5d_rOTZ-ZyH1xBXtB3w@mail.gmail.com>
 <71c96268-7779-6e34-3078-5532d9f8fa55@iogearbox.net>
In-Reply-To: <71c96268-7779-6e34-3078-5532d9f8fa55@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Jun 2019 17:56:08 -0700
Message-ID: <CAADnVQLVnOs-94AGpnu_MLZ3J7SgUuSKWJQC-ioy7zOV9iiiZw@mail.gmail.com>
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

On Mon, Jun 3, 2019 at 5:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/04/2019 01:54 AM, Alexei Starovoitov wrote:
> > On Mon, Jun 3, 2019 at 4:48 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 06/04/2019 01:27 AM, Alexei Starovoitov wrote:
> >>> On Mon, Jun 3, 2019 at 3:59 PM Matt Mullins <mmullins@fb.com> wrote:
> >>>>
> >>>> If these are invariably non-nested, I can easily keep bpf_misc_sd when
> >>>> I resubmit.  There was no technical reason other than keeping the two
> >>>> codepaths as similar as possible.
> >>>>
> >>>> What resource gives you worry about doing this for the networking
> >>>> codepath?
> >>>
> >>> my preference would be to keep tracing and networking the same.
> >>> there is already minimal nesting in networking and probably we see
> >>> more when reuseport progs will start running from xdp and clsbpf
> >>>
> >>>>> Aside from that it's also really bad to miss events like this as exporting
> >>>>> through rb is critical. Why can't you have a per-CPU counter that selects a
> >>>>> sample data context based on nesting level in tracing? (I don't see a discussion
> >>>>> of this in your commit message.)
> >>>>
> >>>> This change would only drop messages if the same perf_event is
> >>>> attempted to be used recursively (i.e. the same CPU on the same
> >>>> PERF_EVENT_ARRAY map, as I haven't observed anything use index !=
> >>>> BPF_F_CURRENT_CPU in testing).
> >>>>
> >>>> I'll try to accomplish the same with a percpu nesting level and
> >>>> allocating 2 or 3 perf_sample_data per cpu.  I think that'll solve the
> >>>> same problem -- a local patch keeping track of the nesting level is how
> >>>> I got the above stack trace, too.
> >>>
> >>> I don't think counter approach works. The amount of nesting is unknown.
> >>> imo the approach taken in this patch is good.
> >>> I don't see any issue when event_outputs will be dropped for valid progs.
> >>> Only when user called the helper incorrectly without BPF_F_CURRENT_CPU.
> >>> But that's an error anyway.
> >>
> >> My main worry with this xchg() trick is that we'll miss to export crucial
> >> data with the EBUSY bailing out especially given nesting could increase in
> >> future as you state, so users might have a hard time debugging this kind of
> >> issue if they share the same perf event map among these programs, and no
> >> option to get to this data otherwise. Supporting nesting up to a certain
> >> level would still be better than a lost event which is also not reported
> >> through the usual way aka perf rb.
> >
> > I simply don't see this 'miss to export data' in all but contrived conditions.
> > Say two progs share the same perf event array.
> > One prog calls event_output and while rb logic is working
> > another prog needs to start executing and use the same event array
>
> Correct.
>
> > slot. Today it's only possible for tracing prog combined with networking,
> > but having two progs use the same event output array is pretty much
> > a user bug. Just like not passing BPF_F_CURRENT_CPU.
>
> I don't see the user bug part, why should that be a user bug?

because I suspect that 'struct bpf_event_entry' is not reentrable
(even w/o issues with 'struct perf_sample_data').

Even if we always use 'struct perf_sample_data' on stack, I suspect
the same 'struct bpf_event_entry' cannot be reused in the nested way.

> It's the same
> as if we would say that sharing a BPF hash map between networking programs
> attached to different hooks or networking and tracing would be a user bug
> which it is not. One concrete example would be cilium monitor where we
> currently expose skb trace and drop events a well as debug data through
> the same rb. This should be usable from any type that has perf_event_output
> helper enabled (e.g. XDP and tc/BPF) w/o requiring to walk yet another per
> cpu mmap rb from user space.

sure. those are valid use cases, but in all cases bpf_event_output() on
particular 'struct bpf_event_entry' will end before another one will begin, no?
