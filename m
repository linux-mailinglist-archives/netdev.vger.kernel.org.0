Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB3A8E12C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 01:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbfHNXRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 19:17:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:60330 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfHNXRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 19:17:30 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hy2WE-0002TG-BV; Thu, 15 Aug 2019 01:17:26 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hy2WE-000CWU-3l; Thu, 15 Aug 2019 01:17:26 +0200
Subject: Re: [PATCH bpf-next v4 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
 <20190802081154.30962-2-bjorn.topel@gmail.com>
 <5ad56a5e-a189-3f56-c85c-24b6c300efd9@iogearbox.net>
 <CAJ+HfNhO+xSs25aPat9WjC75W6_Kgfq=GU+YCEcoZw-GCjZdEg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ce25e5b-a07a-31d8-4141-c6bd250bba0e@iogearbox.net>
Date:   Thu, 15 Aug 2019 01:17:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNhO+xSs25aPat9WjC75W6_Kgfq=GU+YCEcoZw-GCjZdEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25541/Wed Aug 14 10:26:08 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 7:25 PM, Björn Töpel wrote:
> On Mon, 12 Aug 2019 at 14:28, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
> [...]
>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>> index 59b57d708697..c3447bad608a 100644
>>> --- a/net/xdp/xsk.c
>>> +++ b/net/xdp/xsk.c
>>> @@ -362,6 +362,50 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
>>>        dev_put(dev);
>>>    }
>>>
>>> +static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
>>> +                                           struct xdp_sock ***map_entry)
>>> +{
>>> +     struct xsk_map *map = NULL;
>>> +     struct xsk_map_node *node;
>>> +
>>> +     *map_entry = NULL;
>>> +
>>> +     spin_lock_bh(&xs->map_list_lock);
>>> +     node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>>> +                                     node);
>>> +     if (node) {
>>> +             WARN_ON(xsk_map_inc(node->map));
>>
>> Can you elaborate on the refcount usage here and against what scenario it is protecting?
> 
> Thanks for having a look!
> 
> First we access the map_list (under the lock) and pull out the map
> which we intend to clean. In order to clear the map entry, we need to
> a reference to the map. However, when the map_list_lock is released,
> there's a window where the map entry can be cleared and the map can be
> destroyed, and making the "map", which is used in
> xsk_delete_from_maps, stale. To guarantee existence the additional
> refinc is required. Makes sense?

Seems reasonable to me, and inc as opposed to inc_not_zero is also fine
here since at this point in time we're still holding one reference to
the map. But I think there's a catch with the current code that still
needs fixing:

Imagine you do a xsk_map_update_elem() where we have a situation where
xs == old_xs. There, we first do the xsk_map_sock_add() to add the new
xsk map node at the tail of the socket's xs->map_list. We do the xchg()
and then xsk_map_sock_delete() for old_xs which then walks xs->map_list
again and purges all entries including the just newly created one. This
means we'll end up with an xs socket at the given map slot, but the xs
socket has empty xs->map_list. This means we could release the xs sock
and the xsk_delete_from_maps() won't need to clean up anything anymore
but yet the xs is still in the map slot, so if you redirect to that
socket, it would be use-after-free, no?

>> Do we pretend it never fails on the bpf_map_inc() wrt the WARN_ON(),
>> why that (what makes it different from the xsk_map_node_alloc() inc
>> above where we do error out)?
> 
> Hmm, given that we're in a cleanup (socket release), we can't really
> return any error. What would be a more robust way? Retrying? AFAIK the
> release ops return an int, but it's not checked/used.
> 
>>> +             map = node->map;
>>> +             *map_entry = node->map_entry;
>>> +     }
>>> +     spin_unlock_bh(&xs->map_list_lock);
>>> +     return map;
>>> +}
>>> +
>>> +static void xsk_delete_from_maps(struct xdp_sock *xs)
>>> +{
>>> +     /* This function removes the current XDP socket from all the
>>> +      * maps it resides in. We need to take extra care here, due to
>>> +      * the two locks involved. Each map has a lock synchronizing
>>> +      * updates to the entries, and each socket has a lock that
>>> +      * synchronizes access to the list of maps (map_list). For
>>> +      * deadlock avoidance the locks need to be taken in the order
>>> +      * "map lock"->"socket map list lock". We start off by
>>> +      * accessing the socket map list, and take a reference to the
>>> +      * map to guarantee existence. Then we ask the map to remove
>>> +      * the socket, which tries to remove the socket from the
>>> +      * map. Note that there might be updates to the map between
>>> +      * xsk_get_map_list_entry() and xsk_map_try_sock_delete().
>>> +      */
> 
> I tried to clarify here, but I obviously need to do a better job. :-)
> 
> 
> Björn
> 

