Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B046F7A
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfFOKLJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 15 Jun 2019 06:11:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34154 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfFOKLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:11:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so7473844edb.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 03:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SNdEBshCOsJboiHjLOe41pUIm5ydYkFCGBOmQC+KlkA=;
        b=YqDLnrSPujctUMYS0CoH4d67jMk5dgq2RaD5n4gqM2XzlWgH46ISnzpY1wocWtsf46
         Xw7h4UkFuyF06Xxd/SYuGJHi6seKHuZVCzJ65/8p0Rn1fNZdbzJqWU8UQfaZOUMIDd+3
         2Fgc2FCp1QpoaJbeMC2NoxQX30+7+oZprhrvdKy8gtf+XBaX1MKx07fppnrnryzDC2rf
         tmmdGnFWgGhP8me9wlhv6X3KKUBiXzeEmeaalOrebYYgcS0leOThF7J9FLXNu3sQzWJV
         V7ddV7/IspyWgg418IHipfrBZh5mWTKeetJRFLQ64XtDKKSyh+4/15p0PrVs7zUfzoJw
         WNVw==
X-Gm-Message-State: APjAAAWQVmC8gTCHeI6/d9YOP6mzTuFtHeoy0s+HuEuGhZJuwX6hvuJ7
        CNnfynk8uq7YvvNgmfhTK2YiTg==
X-Google-Smtp-Source: APXvYqxOAnlznkzWWsHQuk0RLhPesllsndn8wg5sK5+YN2fYWaobgWD/F52EUsOtYkseS8Xnwb9/zQ==
X-Received: by 2002:a50:ca89:: with SMTP id x9mr106006961edh.164.1560593466355;
        Sat, 15 Jun 2019 03:11:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id s27sm1703407eda.36.2019.06.15.03.11.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:11:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 389C91804AF; Sat, 15 Jun 2019 12:11:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <CAEf4BzZq4FBoFaaUCDnA8p=gRkUtzrDHOuYGibq1_98sPqaRUQ@mail.gmail.com>
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1> <156042464155.25684.9001494922674130772.stgit@alrua-x1> <CAEf4BzZq4FBoFaaUCDnA8p=gRkUtzrDHOuYGibq1_98sPqaRUQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 15 Jun 2019 12:11:05 +0200
Message-ID: <87o92z9n0m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Jun 13, 2019 at 8:31 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>
>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> indication of whether it can successfully redirect to the map index it was
>> given. Instead, BPF programs have to track this themselves, leading to
>> programs using duplicate maps to track which entries are populated in the
>> devmap.
>>
>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>> helper, which makes it possible to return failure to the eBPF program. The
>> lower bits of the flags argument is used as the return code, which means
>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>
> I see that we have absolutely no documentation for
> bpf_xdp_redirect_map. Can you please add it to
> include/uapi/linux/bpf.h? Don't forget to mention this handling of
> lower bits of flags. Thanks!

Can do.

>> With this, a BPF program can check the return code from the helper call and
>> react by, for instance, substituting a different redirect. This works for
>> any type of map used for redirect.
>>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>  include/linux/filter.h |    1 +
>>  net/core/filter.c      |   27 +++++++++++++--------------
>>  2 files changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 43b45d6db36d..f31ae8b9035a 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -580,6 +580,7 @@ struct bpf_skb_data_end {
>>  struct bpf_redirect_info {
>>         u32 ifindex;
>>         u32 flags;
>> +       void *item;
>
> This is so generic name that some short comment describing what that
> item is would help a lot.

Can also just rename it to something more descriptive? Like 'map_entry?

>
>>         struct bpf_map *map;
>>         struct bpf_map *map_to_flush;
>>         u32 kern_flags;
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 7a996887c500..7d742ea61e2d 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>>                                struct bpf_redirect_info *ri)
>>  {
>>         u32 index = ri->ifindex;
>> -       void *fwd = NULL;
>> +       void *fwd = ri->item;
>>         int err;
>>
>>         ri->ifindex = 0;
>> +       ri->item = NULL;
>>         WRITE_ONCE(ri->map, NULL);
>>
>> -       fwd = __xdp_map_lookup_elem(map, index);
>> -       if (unlikely(!fwd)) {
>> -               err = -EINVAL;
>> -               goto err;
>> -       }
>>         if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
>>                 xdp_do_flush_map();
>>
>> @@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>>  {
>>         struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>         u32 index = ri->ifindex;
>> -       void *fwd = NULL;
>> +       void *fwd = ri->item;
>>         int err = 0;
>>
>>         ri->ifindex = 0;
>> +       ri->item = NULL;
>>         WRITE_ONCE(ri->map, NULL);
>>
>> -       fwd = __xdp_map_lookup_elem(map, index);
>> -       if (unlikely(!fwd)) {
>> -               err = -EINVAL;
>> -               goto err;
>> -       }
>> -
>>         if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>>                 struct bpf_dtab_netdev *dst = fwd;
>>
>> @@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
>>
>>         ri->ifindex = ifindex;
>>         ri->flags = flags;
>> +       ri->item = NULL;
>>         WRITE_ONCE(ri->map, NULL);
>>
>>         return XDP_REDIRECT;
>> @@ -3753,9 +3745,16 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>  {
>>         struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>
>> -       if (unlikely(flags))
>> +       /* Lower bits of the flags are used as return code on lookup failure */
>> +       if (unlikely(flags > XDP_TX))
>>                 return XDP_ABORTED;
>>
>> +       ri->item = __xdp_map_lookup_elem(map, ifindex);
>> +       if (unlikely(!ri->item)) {
>> +               WRITE_ONCE(ri->map, NULL);
>> +               return flags;
>> +       }
>> +
>>         ri->ifindex = ifindex;
>>         ri->flags = flags;
>>         WRITE_ONCE(ri->map, map);
>>
