Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE34F5BD4
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKHXcR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 18:32:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfKHXcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:32:16 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 776487C0B9
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 23:32:15 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id h3so1597273lfp.17
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 15:32:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zaH3uPdvPvPQ2Ntn+DAYM/vhLtCymY6ZD93gXXjWnbs=;
        b=d+8Kk9aSUMlGhuozv/jhq3QB9gFCW+KmVRnc/st0fPVQe/yY9797VCcYl8oRJpGRco
         iRy+Mp0BmkJMI1i2kmINNcYUtwBsONZz2PvzPwJxYEDrWESPITCEnmFkb3LA7aZzeyyb
         xkr5XC6ui3iu6TYMi6gLz6g6L1VMuM9Q6pyhEXYsvJX8LvxY/352GfQFL2WhmONyuSuR
         5Bo5VRob/HsiegydjxmgdR+CoLb25klSy4DAnWYCcete9c7LainsHlCP3N/2/uRP2oPV
         ONMaGRRqKXpm21LdwnJbMXnm/DzJlGQyF8yycZHkAOJhdjoM+1WAxg//w/8tFqkxfUFg
         phzw==
X-Gm-Message-State: APjAAAVVrOj121OacWsYNwVeLVa5UIeggKn/gzO5SvYNhR/hA+4WSaOv
        h6CngCkzYDLfdT2Zwb63rfhkWzlVmGbx9IPmiu55iMldnzfcRouqyAIGTclQVL651q4IcUxfeuV
        XMURr3ZoEw6KxHmsV
X-Received: by 2002:a19:cc47:: with SMTP id c68mr8010636lfg.95.1573255933991;
        Fri, 08 Nov 2019 15:32:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNnXjO/UwqbirlT/zMlVjyzbCBHyKIbmkU2ersXZS4DllykDKV2EsHYH2J5nHPofu9Qmg5Jg==
X-Received: by 2002:a19:cc47:: with SMTP id c68mr8010621lfg.95.1573255933783;
        Fri, 08 Nov 2019 15:32:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id n19sm3200940lfl.85.2019.11.08.15.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 15:32:13 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2EC961800CC; Sat,  9 Nov 2019 00:32:12 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/6] libbpf: Propagate EPERM to caller on program load
In-Reply-To: <20191108231757.7egzqebli6gcplfq@ast-mbp.dhcp.thefacebook.com>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324878850.910124.10106029353677591175.stgit@toke.dk> <CAEf4BzZxcvhZG-FHF+0iqia72q3YA0dCgsgFchibiW7dkFQm2A@mail.gmail.com> <20191108231757.7egzqebli6gcplfq@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 09 Nov 2019 00:32:12 +0100
Message-ID: <87sgmyq70j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Nov 08, 2019 at 02:50:43PM -0800, Andrii Nakryiko wrote:
>> On Fri, Nov 8, 2019 at 1:33 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >
>> > From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >
>> > When loading an eBPF program, libbpf overrides the return code for EPERM
>> > errors instead of returning it to the caller. This makes it hard to figure
>> > out what went wrong on load.
>> >
>> > In particular, EPERM is returned when the system rlimit is too low to lock
>> > the memory required for the BPF program. Previously, this was somewhat
>> > obscured because the rlimit error would be hit on map creation (which does
>> > return it correctly). However, since maps can now be reused, object load
>> > can proceed all the way to loading programs without hitting the error;
>> > propagating it even in this case makes it possible for the caller to react
>> > appropriately (and, e.g., attempt to raise the rlimit before retrying).
>> >
>> > Acked-by: Song Liu <songliubraving@fb.com>
>> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> > ---
>> >  tools/lib/bpf/libbpf.c |    4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > index cea61b2ec9d3..582c0fd16697 100644
>> > --- a/tools/lib/bpf/libbpf.c
>> > +++ b/tools/lib/bpf/libbpf.c
>> > @@ -3721,7 +3721,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>> >                 free(log_buf);
>> >                 goto retry_load;
>> >         }
>> > -       ret = -LIBBPF_ERRNO__LOAD;
>> > +       ret = (errno == EPERM) ? -errno : -LIBBPF_ERRNO__LOAD;
>
> ouch. so libbpf was supressing all errnos for loading and that was a commit
> from 2015. No wonder it's hard to debug. I grepped every where I could and it
> doesn't look like anyone is using this code. There are other codes that can
> come from sys_bpf(prog_load). Not sure why such decision was made back then. I
> guess noone was really paying attention. I think we better propagate all codes.
> I don't see why EPERM should be special.

Fine with me; I just assumed there was a good reason for the current
behaviour :)

Will do a v3 that just passes through the errors from the kernel.

-Toke
