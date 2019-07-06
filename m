Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB160F7D
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 10:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGFIlp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 6 Jul 2019 04:41:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38252 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfGFIlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 04:41:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id r12so9808695edo.5
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 01:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1+5yPTDjCxphlEYZ/xRtmGNYP5vPtrUId2OQ7WEZnc8=;
        b=WHBisrhYTpUyEJnTzvIrwSvVt6R+dp36I+cKHkN6BzW5I45M81kTSFHYXGUXJVEmV5
         hT43abHZ8j+5nOyLm7xKGZb2FD9NxdnYs0Njx26uJqOubdWM7AS1lmSkzypepAiYKs8O
         a4jnnU6+Rm8aY9R/RQuDV7r3EbOzJhduRIzMwNJo4jmKcbj/yOohlXKcj5xFSysx86Kq
         7awqAz//LPTObwZji/GtfrLi5MFepjEwO1D2oHfPN6aAO9LLjkP+jTgd4AiqLHaIUfz1
         0ahoVNJX6klTUy3PE19D4F51hOmyXIQyw0fmh+5WDDgLAHQ41cm4AtEYQXdQjJkJfSA6
         sWVA==
X-Gm-Message-State: APjAAAVoCBPMTKq+wOCDHxEPxLbcUpckxA2F0OYlS7brZqTrjIRN20oR
        qz2x7G7Y1s7hLtVSx59YCbWUgg==
X-Google-Smtp-Source: APXvYqz4ZrHp6mvfl/zShozfgJfvuSZKkpmkblyZ5wdF+aWIFriTWI5b6wtuKEyHxottxac+FsDpeA==
X-Received: by 2002:aa7:d68e:: with SMTP id d14mr8934790edr.253.1562402503016;
        Sat, 06 Jul 2019 01:41:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d1sm2171973ejn.11.2019.07.06.01.41.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 01:41:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4D3281800C5; Sat,  6 Jul 2019 10:41:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next 3/3] xdp: Add devmap_hash map type for looking up devices by hashed index
In-Reply-To: <CAH3MdRVHnG+cbHUmwFpkjdtBMVOVasoekxKHKn_upQuDxe5v7Q@mail.gmail.com>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1> <156234940855.2378.3580468359411972045.stgit@alrua-x1> <CAH3MdRVHnG+cbHUmwFpkjdtBMVOVasoekxKHKn_upQuDxe5v7Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 06 Jul 2019 10:41:41 +0200
Message-ID: <87d0in1rne.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Y Song <ys114321@gmail.com> writes:

> On Fri, Jul 5, 2019 at 11:14 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> A common pattern when using xdp_redirect_map() is to create a device map
>> where the lookup key is simply ifindex. Because device maps are arrays,
>> this leaves holes in the map, and the map has to be sized to fit the
>> largest ifindex, regardless of how many devices actually are actually
>> needed in the map.
>>
>> This patch adds a second type of device map where the key is looked up
>> using a hashmap, instead of being used as an array index. This allows maps
>> to be densely packed, so they can be smaller.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  include/linux/bpf.h                     |    7 +
>>  include/linux/bpf_types.h               |    1
>>  include/trace/events/xdp.h              |    3
>>  include/uapi/linux/bpf.h                |    7 +
>>  kernel/bpf/devmap.c                     |  192 +++++++++++++++++++++++++++++++
>>  kernel/bpf/verifier.c                   |    2
>>  net/core/filter.c                       |    9 +
>>  tools/bpf/bpftool/map.c                 |    1
>>  tools/include/uapi/linux/bpf.h          |    7 +
>>  tools/lib/bpf/libbpf_probes.c           |    1
>>  tools/testing/selftests/bpf/test_maps.c |   16 +++
>>  11 files changed, 237 insertions(+), 9 deletions(-)
>
> Could you break this patch into multiple commits for easy backporting
> and easy syncing to libbpf repo?
> For example, you can break it into 4 patches:
>    . kernel patch
>    . sync uapi bpf.h
>    . tools/lib/bpf/libbpf_probes.c
>    . other tools changes.

Sure, I'll send a v2.

-Toke
