Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D8F75214
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388843AbfGYPFH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 11:05:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46202 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388312AbfGYPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:05:07 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so50566012edr.13
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+mu2HirervjgYd6JY58DZ33I6K7Dku+vAMAcY8H7Y7U=;
        b=AH4Feythe6U9RCaQVjgekkxZZQNXT8QOw5or9sRkVxa9ge/B7nSwOjaj+STiK/QF1B
         kogKzUDDEMlwAKtXHfkiTEIh3oZsq1yJ0Wt1tWm+JMrCc/fhpDKY3lLvkWRIDNAFnsxi
         2hEZYkpbq3HgiZhe+KRucbVLHwRP31Oi/SZ3aFfi6+SAsJP+ELKbl50tqZFscTKh6PAQ
         RV678j5ZJRkkSMqYbOv3t43oXz0VQwNhXicmYhEoi/bj3tqYa6AUi2Kp8r+TOrg94AFe
         m9871wRYn8nBj5DAFkAK4STDtlQ5KdiCY7CncLpX9/E1oOOaOStJB3YDQxJ5nCEUTPad
         bIAw==
X-Gm-Message-State: APjAAAUYQWnzfkWcc5GzJX+UIXuFqiMasv2/f4aHdlN2d8DOdA6LYBoj
        sWzLsgqbiBYTD1h6uib0pg/Shw==
X-Google-Smtp-Source: APXvYqwNlPc3Cg/VWxt//7wC5Kzi7b/rHF9HLsDmm0o58+fV5ECH+EWJTV6Rc29AommslAEUGEfHOg==
X-Received: by 2002:a17:906:2544:: with SMTP id j4mr31018548ejb.221.1564067105505;
        Thu, 25 Jul 2019 08:05:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id j11sm9840907ejr.69.2019.07.25.08.05.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 08:05:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C97A21800C5; Thu, 25 Jul 2019 17:05:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v4 3/6] xdp: Add devmap_hash map type for looking up devices by hashed index
In-Reply-To: <20190725133730.3750c66c@carbon>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1> <156379636866.12332.6546616116016146789.stgit@alrua-x1> <20190725100717.0c4e8265@carbon> <87muh2z9os.fsf@toke.dk> <20190725133730.3750c66c@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Jul 2019 17:05:03 +0200
Message-ID: <8736iuyx28.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 25 Jul 2019 12:32:19 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> 
>> > On Mon, 22 Jul 2019 13:52:48 +0200
>> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> >  
>> >> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
>> >> +						    int idx)
>> >> +{
>> >> +	return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
>> >> +}  
>> >
>> > It is good for performance that our "hash" function is simply an AND
>> > operation on the idx.  We want to keep it this way.
>> >
>> > I don't like that you are using NETDEV_HASHENTRIES, because the BPF map
>> > infrastructure already have a way to specify the map size (struct
>> > bpf_map_def .max_entries).  BUT for performance reasons, to keep the
>> > AND operation, we would need to round up the hash-array size to nearest
>> > power of 2 (or reject if user didn't specify a power of 2, if we want
>> > to "expose" this limit to users).  
>> 
>> But do we really want the number of hash buckets to be equal to the max
>> number of entries? The values are not likely to be evenly distributed,
>> so we'll end up with big buckets if the number is small, meaning we'll
>> blow performance on walking long lists in each bucket.
>
> The requested change makes it user-configurable, instead of fixed 256
> entries.  I've seen production use-case with >5000 net_devices, thus
> they need a knob to increase this (to avoid the list walking as you
> mention).

Ah, I see. That makes sense; I thought you wanted to make it smaller
(cf. the previous discussion about it being too big). Still, it seems
counter-intuitive to overload max_entries in this way.

I do see that this is what the existing hash map is also doing, though,
so I guess there is some precedence. I do wonder if we'll end up getting
bad performance from the hash being too simplistic, but I guess we can
always fix that later.

>> Also, if the size is dynamic the size needs to be loaded from memory
>> instead of being a compile-time constant, which will presumably hurt
>> performance (though not sure by how much)?
>
> To counter this, the mask value which need to be loaded from memory,
> needs to be placed next to some other struct member which is already in
> use (at least on same cacheline, Intel have some 16 bytes access micro
> optimizations, which I've never been able to measure, as its in 0.5
> nanosec scale).

In the fast path (i.e., in __xdp_map_lookup_elem) we will have already
loaded map->max_entries since it's on the same cacheline as map_type
which we use to disambiguate which function to call. So it should be
fine to just use that directly.

I'll send a new version with this change :)

-Toke
