Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9642438F4D9
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhEXV2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXV17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:27:59 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63394C061574;
        Mon, 24 May 2021 14:26:31 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id w1so28708992ybt.1;
        Mon, 24 May 2021 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Id8BDQ9jKW9LgXnerfsIA+zlJZCrEDDoLCqREQeUKIE=;
        b=j/aFLTjC3yvEWJV93d6nxYVGnHq1vpgzvvKWiZj7uy4lP2EFoOhR/GBhk1k/dqChVJ
         e2ws9+bshF+D2ulsQa4HnunSmG6WRArQ4CqdT8Zg8uTSw2MTdS28aYx6AfyIukVi+TKs
         ncprYN4zGVyVZ6nq5FZjlzwvF9dyidCWkNXt3upRz/s4lrBw9fnJHAH9YAswrdG6OPXR
         hDbPGm+RvEEbQ90eqqoBmzhT85xHabaG3xRpIPq3A+zw248fSy5C8dNbuHaTx9yh7loe
         MefD5hz8DbtWIXzDtm60/lE2QIV0ZxvgDfBcRPk5QT+WYgzJ57QPUUISFM+AlygE+9Mk
         yACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Id8BDQ9jKW9LgXnerfsIA+zlJZCrEDDoLCqREQeUKIE=;
        b=ai5MQasHx2jQ/vhrFPXEOmoSVy3KWLEKDimt1AMW1gXQ/SZgfAU2U0volVCxJEqxw/
         OqezovF/50D1OGxlD1XNS0EiatgCtQVVeUo52vw8X/Sjp9IQ8mnBXJJfGObsJYM25606
         Ll0LNUopThInvoUriy32LDr5U7JoSqYjHAGvQxQISy+uoP/MMgbp57MQZliQo9ynN7x+
         kmOZ7MKbLfrHgPOX1HqS2dtk0rpVBNngNbNdSbJ+v7eejQT7RG8RAnh4fBuv/Zk+bs3H
         46L594eEVJAKPzYeY28sNFt8sA67kJE5wQesW7qqQQyoXhnibkAzTWS/EEhG5QQHbrQ+
         NzxQ==
X-Gm-Message-State: AOAM533vHQzvGbDi7CwM3/Yw2cqNMHvQuCt+eyGwkozBjbXvFM3t7Ngs
        tc7SkktOOke3Ih3uVXLhb+ncaTzHFNO5qJ38BcfW2vVx
X-Google-Smtp-Source: ABdhPJwhbGgnNVKbwwGEZNBhMn5uLCeeYM1mWWrkqFoBAj/S/yZhnxjJzU62zuDp//h4gFVQU3LlpR4MXpOsANcoO+8=
X-Received: by 2002:a5b:286:: with SMTP id x6mr39687988ybl.347.1621891590611;
 Mon, 24 May 2021 14:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210521234203.1283033-1-andrii@kernel.org> <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com> <87a6ojzwdi.fsf@toke.dk>
In-Reply-To: <87a6ojzwdi.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 14:26:19 -0700
Message-ID: <CAEf4BzadPCOboLov7dbVAQAcQtNj+x4CP7pKutXxo90q7oUuLQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 1:53 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> >>
> >> Andrii Nakryiko wrote:
> >> > Implement error reporting changes discussed in "Libbpf: the road to =
v1.0"
> >> > ([0]) document.
> >> >
> >> > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set =
of flags
> >> > that turn on a set of libbpf 1.0 changes, that might be potentially =
breaking.
> >> > It's possible to opt-in into all current and future 1.0 features by =
specifying
> >> > LIBBPF_STRICT_ALL flag.
> >> >
> >> > When some of the 1.0 "features" are requested, libbpf APIs might beh=
ave
> >> > differently. In this patch set a first set of changes are implemente=
d, all
> >> > related to the way libbpf returns errors. See individual patches for=
 details.
> >> >
> >> > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to enab=
le
> >> > updating selftests.
> >> >
> >> > Patch #2 gets rid of all the bad code patterns that will break in li=
bbpf 1.0
> >> > (exact -1 comparison for low-level APIs, direct IS_ERR() macro usage=
 to check
> >> > pointer-returning APIs for error, etc). These changes make selftest =
work in
> >> > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% li=
bbpf 1.0
> >> > mode to automatically gain all the subsequent changes, which will co=
me in
> >> > follow up patches.
> >> >
> >> > Patch #3 streamlines error reporting for low-level APIs wrapping bpf=
() syscall.
> >> >
> >> > Patch #4 streamlines errors for all the rest APIs.
> >> >
> >> > Patch #5 ensures that BPF skeletons propagate errors properly as wel=
l, as
> >> > currently on error some APIs will return NULL with no way of checkin=
g exact
> >> > error code.
> >> >
> >> >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_ia=
Ruec6U-ZESZ54nNTY
> >> >
> >> > Andrii Nakryiko (5):
> >> >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
> >> >     behaviors
> >> >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
> >> >   libbpf: streamline error reporting for low-level APIs
> >> >   libbpf: streamline error reporting for high-level APIs
> >> >   bpftool: set errno on skeleton failures and propagate errors
> >> >
> >>
> >> LGTM for the series,
> >>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >
> > Thanks, John!
> >
> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
> > commenting on the doc itself), do you mind also taking a brief look
> > and letting me know if this works for your use cases? Thanks!
>
> Changes LGTM:
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> As a side note, the series seems to have been chopped up into individual
> emails with no threading; was a bit weird that I had to go hunting for
> the individual patches in my mailbox...
>

That's my bad, I messed up and sent them individually and probably
that's why they weren't threaded properly.
