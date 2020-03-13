Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3249184028
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 06:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgCMFFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 01:05:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33689 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgCMFFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 01:05:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id d22so6575035qtn.0;
        Thu, 12 Mar 2020 22:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AUaZGhJAuPgsqCt+gzP7za/ND86lb8iuR1Q7yAHj3Do=;
        b=NTGozvAEt9psPcn7tqNfkkwFLbr9xbEU4/wTtR0bCtECsULxQotz6onZcW2TR1/md3
         Yzri91/5qoqr3jtt7tuJSXK9nDggOo+dsKRtyW3Cr3MSJCRex5m8FQormenfRS6wSeRb
         1o+NH70LgyPgADT7WBj9DOaT5UzihzUecGqBCqjB3w0K3B/mjgA9hsnfihr7w6BOBiIn
         w4Mz59SzYOrepAK6VFgWaQVPxfCs+1hDhadrJERhOKvzvRKIWBjigVLtlFyvmq3pK06d
         +V/ptptELAIkmUHo2RbfGBo1js2TbJJ09JYYwTmoIYtDP6vWE8yDO7Kh0u8yMKXoIVsr
         gYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AUaZGhJAuPgsqCt+gzP7za/ND86lb8iuR1Q7yAHj3Do=;
        b=Ie66dM9p8EV0ej6UVLyC7ks2iecGLv9kYd/3ExfNyCI5FW3aPviAkNZ6G/0RXC5jDE
         IrhmU7njGM/IGDwA+ixrwmwKbRowcXqYywnMJLoNEjcsD7SNlivTo57lG1uVBxw3EwSX
         9Vq7wc6QmTUD65m3kiLTq1VSRkb7J9XQQz1myqK3auDkzEbTHJGMs7zsGrmsR3MoTB3H
         vQ7z3+6fRlsrXxyTgGNN05K0TDEH3KKT6chbE6Nr35BqFQyKWtLRHDsTRnm2SHCWc2gh
         Nk/kFexv9Rs42CiuJOwgEVYddkOw2h2E5HBjJw4yffBrSxSJ5beYsrcRELBujMKdHmEp
         MSdw==
X-Gm-Message-State: ANhLgQ2bo5quXRtW2Vudj/xfha7yF39rPNl9kK9OWVC3cr6+Z85/C2Ln
        d7OwBds4aeMWYP8duU/FPWaMp8tayVCJdzhTzG0hyH3NB9I=
X-Google-Smtp-Source: ADFU+vs5xMqV9P5mWjyu2r49mJPOsXwZ7ZPs9waEYa2hTimbvPOyNHE+SjazigDE7WgFraeJYC1i9cTihosN7yk/NM4=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr3226742qtk.171.1584075901583;
 Thu, 12 Mar 2020 22:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200313002128.2028680-1-andriin@fb.com> <20200313015012.nejdagphpe44k27i@ast-mbp>
In-Reply-To: <20200313015012.nejdagphpe44k27i@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 22:04:50 -0700
Message-ID: <CAEf4BzbjqhX5sgoRZX1k-=WjSsvCAXxYs6WN3j4nBzja0ZbTnw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: abstract away entire bpf_link clean up procedure
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 6:50 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 12, 2020 at 05:21:28PM -0700, Andrii Nakryiko wrote:
> > Instead of requiring users to do three steps for cleaning up bpf_link, its
> > anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> > helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> > individual operation anymore.
> >
> > v1->v2:
> > - keep bpf_link_cleanup() static for now (Daniel).
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Applied.
>
> But noticed that the test is now sporadically failing:
> ./test_progs -n 24
> test_link_pinning:PASS:skel_open 0 nsec
> test_link_pinning_subtest:PASS:link_attach 0 nsec
> test_link_pinning_subtest:PASS:res_check1 0 nsec
> test_link_pinning_subtest:PASS:link_pin 0 nsec
> test_link_pinning_subtest:PASS:pin_path1 0 nsec
> test_link_pinning_subtest:PASS:stat_link 0 nsec
> test_link_pinning_subtest:PASS:res_check2 0 nsec
> test_link_pinning_subtest:PASS:res_check3 0 nsec
> test_link_pinning_subtest:PASS:link_open 0 nsec
> test_link_pinning_subtest:PASS:pin_path2 0 nsec
> test_link_pinning_subtest:PASS:link_unpin 0 nsec
> test_link_pinning_subtest:PASS:res_check4 0 nsec
> test_link_pinning_subtest:FAIL:link_attached got to iteration #10000
> #24/1 pin_raw_tp:FAIL
> test_link_pinning_subtest:PASS:link_attach 0 nsec
> test_link_pinning_subtest:PASS:res_check1 0 nsec
> test_link_pinning_subtest:PASS:link_pin 0 nsec
> test_link_pinning_subtest:PASS:pin_path1 0 nsec
> test_link_pinning_subtest:PASS:stat_link 0 nsec
> test_link_pinning_subtest:PASS:res_check2 0 nsec
> test_link_pinning_subtest:PASS:res_check3 0 nsec
> test_link_pinning_subtest:PASS:link_open 0 nsec
> test_link_pinning_subtest:PASS:pin_path2 0 nsec
> test_link_pinning_subtest:PASS:link_unpin 0 nsec
> test_link_pinning_subtest:PASS:res_check4 0 nsec
> test_link_pinning_subtest:FAIL:link_attached got to iteration #10000
> #24/2 pin_tp_btf:FAIL
> #24 link_pinning:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 3 FAILED
>
> it's failing more often than passing, actually.

Can't repro this even with 2 parallel kernel builds and running this
test in VM in a loop. I can bump waiting time a little bit or can drop
that check, because it's inherently non-deterministic...
>
> The #64 tcp_rtt also started to fail sporadically.
> But I wonder whether it's leftover from 24. shrug.

Can you please paste log from #64 failure?
