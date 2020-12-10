Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23252D61C3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392315AbgLJQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388706AbgLJQ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:26:51 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495A9C0613D6;
        Thu, 10 Dec 2020 08:26:11 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t3so4650872pgi.11;
        Thu, 10 Dec 2020 08:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i5cob6kgCtDaTq32FhgXmLOVeR9KEkLNJhWX7rL8miU=;
        b=RCzGN1n644wKFf8BkMY82qC8WyR4wVRbnkBZZwnKhE3yH2zLyKrtUitpHVjjB3Mkh2
         hxhocrwOAI00Vy64lMuRATPIj+Co0742dy3vbiH9ksEEmivxkPD8T6BxT8aZL4WX7Z3Y
         8VMCRf+4f3jNhEWZJtfp7WFNjc0C/K6VB6PCjO6DLBeXZvdPAYIjI9zWOilpVt2tyn7w
         AJhj+nMD2w6SK7kOYBxSFSwFOQMOtRhqhdiwTier6TkAnM1oCEEU76nOCSiWwmYsYEEg
         S6t2QMmdkKiDdgMJuBB340HOlYXqZ1H+5GBz+vlL1IZiZRaybt0tUrsJoM6idzKNmeQ1
         fZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i5cob6kgCtDaTq32FhgXmLOVeR9KEkLNJhWX7rL8miU=;
        b=hQE8t5zzqhusvjwGIqeuObOKBNVVt+8N0S7yQtd8YkshmQ8Y7AboBWbSTzIbFnD7JB
         UWqabyZRW+p0gF0wxC+gRSjO1vc3Er8bzQxefqcE2NY0yKMtnE4LnFJ0arBBRc6TYI11
         K4sKfcptIdqlJ1DNQMskag0dOomFdUodm+8zvb0pcmmynqxkQBhc379E3rLhOiEtcglf
         kMhezOeV4tV6N3snNoZg2tIiv19QKbhJwU1wRQbQf3H4IGQAU0Nabv59vzlCD2vASjii
         uxpecKThPudqDqPJnyFt7rmtO/bHa6GZ4y0SvjdZ4IEP3PpGAmbYTQ/UxnTpPQAUQ4RY
         K/jg==
X-Gm-Message-State: AOAM532QCmc+j4s99S7LXElnvXEK74u5lco7UAcI2RidDPA32Bac10H6
        WqcE5hAkbYR2t9kNM7QAx5hsFkeYO5VB2JIydHI=
X-Google-Smtp-Source: ABdhPJxEG/zDQeVb+oFliwwaIVGd9dJycsX4XSRINSav585g6EDYveqmY9mJG+ehQScGDzvk3Bo75WjYon5HplFMxO4=
X-Received: by 2002:a17:90a:fcc:: with SMTP id 70mr8176670pjz.168.1607617570759;
 Thu, 10 Dec 2020 08:26:10 -0800 (PST)
MIME-Version: 1.0
References: <20201210153645.21286-1-magnus.karlsson@gmail.com> <a41f3859-e541-3fba-9b8b-874da86de92d@iogearbox.net>
In-Reply-To: <a41f3859-e541-3fba-9b8b-874da86de92d@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 10 Dec 2020 17:25:59 +0100
Message-ID: <CAJ8uoz2Pj+m5n6vNavY1JCVTY+dTTCuuQ7NurgxvAfHdmoH4KQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: fix possible hang in xdpsock with
 multiple threads
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 5:03 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 12/10/20 4:36 PM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a possible hang in xdpsock that can occur when using multiple
> > threads. In this case, one or more of the threads might get stuck in
> > the while-loop in tx_only after the user has signaled the main thread
> > to stop execution. In this case, no more Tx packets will be sent, so a
> > thread might get stuck in the aforementioned while-loop. Fix this by
> > introducing a test inside the while-loop to check if the benchmark has
> > been terminated. If so, exit the loop.
> >
> > Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch=
 size")
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> With the patch applied, I'm getting a new warning:
>
>    CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.o
> /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.c: In function =E2=
=80=98main=E2=80=99:
> /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.c:1272:6: warning:=
 =E2=80=98idx=E2=80=99 may be used uninitialized in this function [-Wmaybe-=
uninitialized]
>   1272 |  u32 idx;
>        |      ^~~

Sorry, I get it too. It was just masked with the other warnings I get
these days when compiling the bpf samples. Regardless, it is the
compiler trying to tell me I have done something stupid :-(. It should
really be a return instead of a break, sigh. Will send a v2.

> Previously compiling w/o issues:
>
>   [...]
>    CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_ctrl_proc.o
>    CC  /home/darkstar/trees/bpf-next/samples/bpf/xdpsock_user.o
>    CC  /home/darkstar/trees/bpf-next/samples/bpf/xsk_fwd.o
>    LD  /home/darkstar/trees/bpf-next/samples/bpf/fds_example
>   [...]
>
> For testing, I used:
>
>    gcc --version
>    gcc (GCC) 9.0.1 20190312 (Red Hat 9.0.1-0.10)
>
> Ptal, thx!
