Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A267861CAD
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfGHKCo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 06:02:44 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37391 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfGHKCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:02:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so14006976eds.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YxPCAS5xHdU7kgcXFsEO2tRjh2GlEkpffR9+LkAmjzU=;
        b=Gex1zIXLco2KtsN/XQiCCCprqH/q5KEL+nXMIT+ZoFz66PAa7widROgctleMJoLeDN
         KQklbpHK3J/7Myc4G+JfDuO3S3cdXr6yXbUXh3aP15IypGIUXQkjs0filesmmYH0Mmiq
         9E7vFsZtbGB0ITtyzxdU/GV1ML9c9FEdpDottPVnG/LoRL5I8/2y13tYn2bFJiodA0rq
         Tqq0hVHcNI0S1hMtoBVaL/vfVJAOAoi87Zwt/NmhfAckeyziNLM25t1gEPZQeTxtm6X9
         HA5Z4f9+pMzwd3kihle+iW+zbC+rqF7ll8DOjJVRZ9Bt9zbA01FeNV0CJt4fAVtVA/+i
         Cjkg==
X-Gm-Message-State: APjAAAVUIxIlzOZ2G4MGl4MJI/SyqBT8MGaXDI7DNhXDLJPuBC4ITanb
        ENFFajtWu5iabLMzyfIcT19xzQ==
X-Google-Smtp-Source: APXvYqyCVYpc0Zby1IGt8qiLoY8uM3dYEBpdqJmk/HSWe8969JnqCf/d0Wz/85VGJxUVnf9UOUO9Ew==
X-Received: by 2002:a50:ba78:: with SMTP id 53mr17088170eds.6.1562580162026;
        Mon, 08 Jul 2019 03:02:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id m39sm5606412edm.96.2019.07.08.03.02.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:02:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D641D181CE6; Mon,  8 Jul 2019 12:02:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v2 0/6] xdp: Add devmap_hash map type
In-Reply-To: <CAH3MdRVB5Wq7_SPShk=xQaoGBdcdzRfb-t02JWOETRxY9QrKGA@mail.gmail.com>
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1> <CAH3MdRVB5Wq7_SPShk=xQaoGBdcdzRfb-t02JWOETRxY9QrKGA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 12:02:40 +0200
Message-ID: <87sgrgzvwf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Y Song <ys114321@gmail.com> writes:

> On Sat, Jul 6, 2019 at 1:47 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> This series adds a new map type, devmap_hash, that works like the existing
>> devmap type, but using a hash-based indexing scheme. This is useful for the use
>> case where a devmap is indexed by ifindex (for instance for use with the routing
>> table lookup helper). For this use case, the regular devmap needs to be sized
>> after the maximum ifindex number, not the number of devices in it. A hash-based
>> indexing scheme makes it possible to size the map after the number of devices it
>> should contain instead.
>>
>> This was previously part of my patch series that also turned the regular
>> bpf_redirect() helper into a map-based one; for this series I just pulled out
>> the patches that introduced the new map type.
>>
>> Changelog:
>>
>> v2:
>>
>> - Split commit adding the new map type so uapi and tools changes are separate.
>>
>> Changes to these patches since the previous series:
>>
>> - Rebase on top of the other devmap changes (makes this one simpler!)
>> - Don't enforce key==val, but allow arbitrary indexes.
>> - Rename the type to devmap_hash to reflect the fact that it's just a hashmap now.
>>
>> ---
>>
>> Toke Høiland-Jørgensen (6):
>>       include/bpf.h: Remove map_insert_ctx() stubs
>>       xdp: Refactor devmap allocation code for reuse
>>       uapi/bpf: Add new devmap_hash type
>>       xdp: Add devmap_hash map type for looking up devices by hashed index
>>       tools/libbpf_probes: Add new devmap_hash type
>>       tools: Add definitions for devmap_hash map type
>
> Thanks for re-organize the patch. I guess this can be tweaked a little more
> to better suit for syncing between kernel and libbpf repo.
>
> Let me provide a little bit background here. The below is
> a sync done by Andrii from kernel/tools to libbpf repo.
>
> =============
> commit 39de6711795f6d1583ae96ed8d13892bc4475ac1
> Author: Andrii Nakryiko <andriin@fb.com>
> Date:   Tue Jun 11 09:56:11 2019 -0700
>
>     sync: latest libbpf changes from kernel
>
>     Syncing latest libbpf commits from kernel repository.
>     Baseline commit:   e672db03ab0e43e41ab6f8b2156a10d6e40f243d
>     Checkpoint commit: 5e2ac390fbd08b2a462db66cef2663e4db0d5191
>
>     Andrii Nakryiko (9):
>       libbpf: fix detection of corrupted BPF instructions section
>       libbpf: preserve errno before calling into user callback
>       libbpf: simplify endianness check
>       libbpf: check map name retrieved from ELF
>       libbpf: fix error code returned on corrupted ELF
>       libbpf: use negative fd to specify missing BTF
>       libbpf: simplify two pieces of logic
>       libbpf: typo and formatting fixes
>       libbpf: reduce unnecessary line wrapping
>
>     Hechao Li (1):
>       bpf: add a new API libbpf_num_possible_cpus()
>
>     Jonathan Lemon (2):
>       bpf/tools: sync bpf.h
>       libbpf: remove qidconf and better support external bpf programs.
>
>     Quentin Monnet (1):
>       libbpf: prevent overwriting of log_level in bpf_object__load_progs()
>
>      include/uapi/linux/bpf.h |   4 +
>      src/libbpf.c             | 207 ++++++++++++++++++++++-----------------
>      src/libbpf.h             |  16 +++
>      src/libbpf.map           |   1 +
>      src/xsk.c                | 103 ++++++-------------
>      5 files changed, 167 insertions(+), 164 deletions(-)
> ==========
>
> You can see the commits at tools/lib/bpf and
> commits at tools/include/uapi/{linux/[bpf.h, btf.h], ...}
> are sync'ed to libbpf repo.
>
> So we would like kernel commits to be aligned that way for better
> automatic syncing.
>
> Therefore, your current patch set could be changed from
>    >       include/bpf.h: Remove map_insert_ctx() stubs
>    >       xdp: Refactor devmap allocation code for reuse
>    >       uapi/bpf: Add new devmap_hash type
>    >       xdp: Add devmap_hash map type for looking up devices by hashed index
>    >       tools/libbpf_probes: Add new devmap_hash type
>    >       tools: Add definitions for devmap_hash map type
> to
>       1. include/bpf.h: Remove map_insert_ctx() stubs
>       2. xdp: Refactor devmap allocation code for reuse
>       3. kernel non-tools changes (the above patch #3 and #4)
>       4. tools/include/uapi change (part of the above patch #6)
>       5. tools/libbpf_probes change
>       6. other tools/ change (the above patch #6 - new patch #4).
>
> Thanks!

Ah, right, got the two uapi updates mixed up I guess. Will fix and
respin :)

-Toke
