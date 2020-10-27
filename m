Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3304B29CC3D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1795041AbgJ0Wzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:36 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33646 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1793812AbgJ0Wzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:33 -0400
Received: by mail-yb1-f196.google.com with SMTP id c3so2669393ybl.0;
        Tue, 27 Oct 2020 15:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uOT2cv6lRdiliWs62LyNQj+t0f3tiV/jTixSklraP9c=;
        b=iE0szS7X8ftg+fPcpGU1JjGuVYrWKwrGJNuggsnGAXMNeYSFqQfJ1FAOmSXEoOEJeY
         pBNC2zHM/6vn+2LtrXk+6FjbGDDmZMZzUHUvy9KVV7UVyc1DxmwmhR4GmbKza1e1dxF/
         G32YKC5GaW+rQTtW/NFdkJBIcUZpD4vDCWzR78GWE/zhFDmBqWqj3LETTYhPt8N0Amt0
         85VZMntRjrLHDRCoAPazopnAs0wHL3WsQPGDLfQYy/ZCiJwDYvltN6sXtcooRi8HrJxN
         g3qpMmA5b7xe+Of20TnMuBlgEh1t8VzaOly5uoWJK3DcOukViFYo5Yb9Tm/HF35/AwHv
         VHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uOT2cv6lRdiliWs62LyNQj+t0f3tiV/jTixSklraP9c=;
        b=bzsrGCOs5i+hqQtrwvtNAjI5TNCj/GrE2jPgDbDiPdvSNwZvFG77Gctzps+e1Cdy6z
         aGUqKb+fFiRRqQPoWZWpZ5egB5xQCTUU343mvzyH0JoH9QRlwU2rb9SWIH+7gro++ndZ
         RBhOmwct/KjfTbg1/tBA2MSGaXwlCJP5VKVucrqtNBmR1Ax7tH1it6qelPFhVqZ849wK
         x9+gWIxAHT2Sl6pRpPJXNO3D9JKmAxXS1sKbGjGMmvRuEvWCk4bgCXAxG6toRBlx5YdT
         p1yabRbeUG6+NofhRAVTbzsgXHK/Q57qNPJ5Ld0b/RiaQJ4O8FuxEOkuUUyB+1St+Kq2
         02nA==
X-Gm-Message-State: AOAM5322fv02pPMG+7mBnA212D+BmbcEziuf5hhYJ4k1tL7ZvSbzY0iO
        AE0bpZilcOXjYDlhgZywC6SvHzoy4f91T5OydaOEkiWIDQ81wg==
X-Google-Smtp-Source: ABdhPJztLytSckmlYoU4KdGXXYYCMGKjNBKM5UYyixxiLfc93NcsH/Daia1vtqqO551fxsYAEcLsZZSjmq5Uycd2Ot8=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr6742246ybg.459.1603839331953;
 Tue, 27 Oct 2020 15:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20201023123754.30304-1-david.verbeiren@tessares.net> <20201027221324.27894-1-david.verbeiren@tessares.net>
In-Reply-To: <20201027221324.27894-1-david.verbeiren@tessares.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Oct 2020 15:55:21 -0700
Message-ID: <CAEf4Bzb84+Uv1dZa6WE5Eow3tovFqL+FpP8QfGP0C-QQj1JDTw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: zero-fill re-used per-cpu map element
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 3:15 PM David Verbeiren
<david.verbeiren@tessares.net> wrote:
>
> Zero-fill element values for all other cpus than current, just as
> when not using prealloc. This is the only way the bpf program can
> ensure known initial values for all cpus ('onallcpus' cannot be
> set when coming from the bpf program).
>
> The scenario is: bpf program inserts some elements in a per-cpu
> map, then deletes some (or userspace does). When later adding
> new elements using bpf_map_update_elem(), the bpf program can
> only set the value of the new elements for the current cpu.
> When prealloc is enabled, previously deleted elements are re-used.
> Without the fix, values for other cpus remain whatever they were
> when the re-used entry was previously freed.
>
> Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
> ---
>

Looks good, but would be good to have a unit test (see below). Maybe
in a follow up.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> Notes:
>     v2:
>       - Moved memset() to separate pcpu_init_value() function,
>         which replaces pcpu_copy_value() but delegates to it
>         for the cases where no memset() is needed (Andrii).
>       - This function now also avoids doing the memset() for
>         the current cpu for which the value must be set
>         anyhow (Andrii).
>       - Same pcpu_init_value() used for per-cpu LRU map
>         (Andrii).
>
>       Note that I could not test the per-cpu LRU other than
>       by running the bpf selftests. lru_map and maps tests
>       passed but for the rest of the test suite, I don't
>       think I know how to spot problems...

It would be good to write a new selftest specifically for this. You
can create a single-element pre-allocated per-CPU hashmap. From
user-space, initialize it to non-zeros on all CPUs. Then delete that
key (it will get put on the free list). Then trigger BPF program, do
an update (that should take an element from the freelist), doesn't
matter which value you set (could be zero). Then from user-space get
all per-CPU values for than new key. It should all be zeroes with your
fix and non-zero without it.

It sounds more complicated than it would look like in practice :)

>
>       Question: Is it ok to use raw_smp_processor_id() in
>       these contexts? bpf prog context should be fine, I think.
>       Is it also ok in the syscall context?

From the BPF program side it's definitely ok, because we disable CPU
migration even for sleepable programs. For syscall context, it always
uses onallcpus=true, so we'll never run this logic from syscall
context. So I think it's fine.

>
>  kernel/bpf/hashtab.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)

[...]
