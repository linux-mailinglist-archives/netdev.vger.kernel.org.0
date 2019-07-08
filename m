Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46226269D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfGHQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:50:15 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:60727 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfGHQuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:50:14 -0400
Received: (qmail 42582 invoked by uid 89); 8 Jul 2019 16:50:13 -0000
Received: from unknown (HELO ?172.20.95.170?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4z) (POLARISLOCAL)  
  by smtp6.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 8 Jul 2019 16:50:13 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>, netdev@vger.kernel.org,
        "David Miller" <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] xdp: Add devmap_hash map type
Date:   Mon, 08 Jul 2019 09:50:07 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <7CE9D879-7E04-4838-84B3-2F0A58A39BD3@flugsvamp.com>
In-Reply-To: <87bly4zg8n.fsf@toke.dk>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1>
 <53906C87-8AF9-4048-8CA0-AE38C023AEF7@flugsvamp.com> <87bly4zg8n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; markup=markdown
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Jul 2019, at 8:40, Toke Høiland-Jørgensen wrote:

> "Jonathan Lemon" <jlemon@flugsvamp.com> writes:
>
>> On 5 Jul 2019, at 10:56, Toke Høiland-Jørgensen wrote:
>>
>>> This series adds a new map type, devmap_hash, that works like the
>>> existing
>>> devmap type, but using a hash-based indexing scheme. This is useful
>>> for the use
>>> case where a devmap is indexed by ifindex (for instance for use with
>>> the routing
>>> table lookup helper). For this use case, the regular devmap needs to
>>> be sized
>>> after the maximum ifindex number, not the number of devices in it. A
>>> hash-based
>>> indexing scheme makes it possible to size the map after the number of
>>> devices it
>>> should contain instead.
>>
>> This device hash map is sized at NETDEV_HASHENTRIES == 2^8 == 256. Is
>> this actually smaller than an array? What ifindex values are you
>> seeing?
>
> Well, not in all cases, certainly. But machines with lots of virtual
> interfaces (e.g., container hosts) can easily exceed that. Also, for a
> devmap we charge the full size of max_entries * struct bpf_dtab_netdev
> towards the locked memory cost on map creation. And since sizeof(struct
> bpf_dtab_netdev) is 64, the size of the hashmap only corresponds to 32
> entries...
>
> But more importantly, it's a UI issue: Say you want to create a simple
> program that uses the fib_lookup helper (something like the xdp_fwd
> example under samples/bpf/). You know that you only want to route
> between a couple of interfaces, so you naturally create a devmap that
> can hold, say, 8 entries (just to be sure). This works fine on your
> initial test, where the machine only has a couple of physical interfaces
> brought up at boot. But then you try to run the same program on your
> production server, where the interfaces you need to use just happen to
> have ifindexes higher than 8, and now it breaks for no discernible
> reason. Or even worse, if you remove and re-add an interface, you may no
> longer be able to insert it into your map because the ifindex changed...

Thanks for the explanation, that makes sense.
-- 
Jonathan
