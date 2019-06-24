Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0D51B82
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfFXTi2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Jun 2019 15:38:28 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43305 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfFXTi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:38:28 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so23337064edr.10
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 12:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=J5Zvm1J+TAome2gTzkUPcjNi7iMvDGaTQp5+BFcjc9M=;
        b=LMrFtgEV8JxuZHWaYsakoy1kUtkn42wfKb6/9m00NcLkF5P9+3ZQO7w3LmATF5HZz+
         MsVNADfX57zwQ8zMoDulRQMVTvQD4Xigzm4VD6yo4ZgQqlae07OBFcHQ03OWSHN8ZSVx
         PGigwMwC5KJxAO0cS0s4JPl7N76RcRCZoaxLTw2sYBVlrIXCyPkxUaYaKh1TEylwkkl6
         A1YCgzQl9zp3ZWbNoVg/GIHE3o2TPdTtD9UDXhEXjVhZ+dCQgyfjeKwgU4E8vs1XiKvL
         SmoNC72yQqQ55OVL7eJMrMw+QrdBH9W2Li451H9ua09No/WBLYTc7bqo5Pt6b7QQDw6m
         Yzsw==
X-Gm-Message-State: APjAAAXA+xfchGvWzzdMQwYz0fW0t6yQLJf3moGaVCzbDPEcOSn4oWrn
        rNcz0g7yD1NUsn2iL8sZrVgGhw==
X-Google-Smtp-Source: APXvYqzLbgrOkwphdGBpYVCxffmmcoqmcEy3Z+V3tC9c5MwO08E9lGkUJAuzhH9spXi3XYQka8wq2A==
X-Received: by 2002:a50:aeee:: with SMTP id f43mr94107359edd.221.1561405106586;
        Mon, 24 Jun 2019 12:38:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l38sm4055404eda.1.2019.06.24.12.38.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 12:38:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3BE19181CA7; Mon, 24 Jun 2019 21:38:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 0/3] xdp: Allow lookup into devmaps before redirect
In-Reply-To: <CAEf4BzYFCAp7yUU80ia=C5ywDBgepeaMmVPJW8VG4gLUT=ht=A@mail.gmail.com>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <CAEf4BzYFCAp7yUU80ia=C5ywDBgepeaMmVPJW8VG4gLUT=ht=A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 Jun 2019 21:38:25 +0200
Message-ID: <87y31qepu6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Jun 22, 2019 at 7:19 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> When using the bpf_redirect_map() helper to redirect packets from XDP, the eBPF
>> program cannot currently know whether the redirect will succeed, which makes it
>> impossible to gracefully handle errors. To properly fix this will probably
>> require deeper changes to the way TX resources are allocated, but one thing that
>> is fairly straight forward to fix is to allow lookups into devmaps, so programs
>> can at least know when a redirect is *guaranteed* to fail because there is no
>> entry in the map. Currently, programs work around this by keeping a shadow map
>> of another type which indicates whether a map index is valid.
>>
>> This series contains two changes that are complementary ways to fix this issue:
>>
>> - Moving the map lookup into the bpf_redirect_map() helper (and caching the
>>   result), so the helper can return an error if no value is found in the map.
>>   This includes a refactoring of the devmap and cpumap code to not care about
>>   the index on enqueue.
>>
>> - Allowing regular lookups into devmaps from eBPF programs, using the read-only
>>   flag to make sure they don't change the values.
>>
>> The performance impact of the series is negligible, in the sense that I cannot
>> measure it because the variance between test runs is higher than the difference
>> pre/post series.
>>
>> Changelog:
>>
>> v5:
>>   - Rebase on latest bpf-next.
>>   - Update documentation for bpf_redirect_map() with the new meaning of flags.
>>
>> v4:
>>   - Fix a few nits from Andrii
>>   - Lose the #defines in bpf.h and just compare the flags argument directly to
>>     XDP_TX in bpf_xdp_redirect_map().
>>
>> v3:
>>   - Adopt Jonathan's idea of using the lower two bits of the flag value as the
>>     return code.
>>   - Always do the lookup, and cache the result for use in xdp_do_redirect(); to
>>     achieve this, refactor the devmap and cpumap code to get rid the bitmap for
>>     selecting which devices to flush.
>>
>> v2:
>>   - For patch 1, make it clear that the change works for any map type.
>>   - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the return
>>     value read-only.
>>
>> ---
>>
>> Toke Høiland-Jørgensen (3):
>>       devmap/cpumap: Use flush list instead of bitmap
>>       bpf_xdp_redirect_map: Perform map lookup in eBPF helper
>>       devmap: Allow map lookups from eBPF
>>
>>
>>  include/linux/filter.h   |    1
>>  include/uapi/linux/bpf.h |    7 ++-
>>  kernel/bpf/cpumap.c      |  106 ++++++++++++++++++++-----------------------
>>  kernel/bpf/devmap.c      |  113 ++++++++++++++++++++++------------------------
>>  kernel/bpf/verifier.c    |    7 +--
>>  net/core/filter.c        |   29 +++++-------
>>  6 files changed, 123 insertions(+), 140 deletions(-)
>>
>
>
> Looks like you forgot to add my Acked-by's for your patches?

Ah yes, did not carry those forward for the individual patches, my
apologies. Could you perhaps be persuaded to send a new one (I believe a
response to the cover letter acking the whole series would suffice)?
I'll make sure to add the carrying forward of acks into my workflow in
the future :)

-Toke
