Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F378C35F
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfHMVM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:12:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:57198 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMVM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:12:56 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxe66-0004sM-VL; Tue, 13 Aug 2019 23:12:51 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxe66-0004wY-Q2; Tue, 13 Aug 2019 23:12:50 +0200
Subject: Re: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-3-sdf@google.com>
 <db5ec323-1126-d461-bc65-27ccc1414589@iogearbox.net>
 <20190812175249.GF2820@mini-arch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2d24378a-73f4-bfa0-dc99-4a0ed761c797@iogearbox.net>
Date:   Tue, 13 Aug 2019 23:12:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812175249.GF2820@mini-arch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 7:52 PM, Stanislav Fomichev wrote:
> On 08/12, Daniel Borkmann wrote:
>> On 8/9/19 6:10 PM, Stanislav Fomichev wrote:
>>> Add new helper bpf_sk_storage_clone which optionally clones sk storage
>>> and call it from sk_clone_lock.
>>>
>>> Cc: Martin KaFai Lau <kafai@fb.com>
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> [...]
>>> +int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
>>> +{
>>> +	struct bpf_sk_storage *new_sk_storage = NULL;
>>> +	struct bpf_sk_storage *sk_storage;
>>> +	struct bpf_sk_storage_elem *selem;
>>> +	int ret;
>>> +
>>> +	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
>>> +
>>> +	rcu_read_lock();
>>> +	sk_storage = rcu_dereference(sk->sk_bpf_storage);
>>> +
>>> +	if (!sk_storage || hlist_empty(&sk_storage->list))
>>> +		goto out;
>>> +
>>> +	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
>>> +		struct bpf_sk_storage_elem *copy_selem;
>>> +		struct bpf_sk_storage_map *smap;
>>> +		struct bpf_map *map;
>>> +		int refold;
>>> +
>>> +		smap = rcu_dereference(SDATA(selem)->smap);
>>> +		if (!(smap->map.map_flags & BPF_F_CLONE))
>>> +			continue;
>>> +
>>> +		map = bpf_map_inc_not_zero(&smap->map, false);
>>> +		if (IS_ERR(map))
>>> +			continue;
>>> +
>>> +		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
>>> +		if (!copy_selem) {
>>> +			ret = -ENOMEM;
>>> +			bpf_map_put(map);
>>> +			goto err;
>>> +		}
>>> +
>>> +		if (new_sk_storage) {
>>> +			selem_link_map(smap, copy_selem);
>>> +			__selem_link_sk(new_sk_storage, copy_selem);
>>> +		} else {
>>> +			ret = sk_storage_alloc(newsk, smap, copy_selem);
>>> +			if (ret) {
>>> +				kfree(copy_selem);
>>> +				atomic_sub(smap->elem_size,
>>> +					   &newsk->sk_omem_alloc);
>>> +				bpf_map_put(map);
>>> +				goto err;
>>> +			}
>>> +
>>> +			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
>>> +		}
>>> +		bpf_map_put(map);
>>
>> The map get/put combination /under/ RCU read lock seems a bit odd to me, could
>> you exactly describe the race that this would be preventing?
> There is a race between sk storage release and sk storage clone.
> bpf_sk_storage_map_free uses synchronize_rcu to wait for all existing
> users to finish and the new ones are prevented via map's refcnt being
> zero; we need to do something like that for the clone.
> Martin suggested to use bpf_map_inc_not_zero/bpf_map_put.
> If I read everythin correctly, I think without map_inc/map_put we
> get the following race:
> 
> CPU0                                   CPU1
> 
> bpf_map_put
>    bpf_sk_storage_map_free(smap)
>      synchronize_rcu
> 
>      // no more users via bpf or
>      // syscall, but clone
>      // can still happen
> 
>      for each (bucket)
>        selem_unlink
>          selem_unlink_map(smap)
> 
>          // adding anything at
>          // this point to the
>          // bucket will leak
> 
>                                         rcu_read_lock
>                                         tcp_v4_rcv
>                                           tcp_v4_do_rcv
>                                             // sk is lockless TCP_LISTEN
>                                             tcp_v4_cookie_check
>                                               tcp_v4_syn_recv_sock
>                                                 bpf_sk_storage_clone
>                                                   rcu_dereference(sk->sk_bpf_storage)
>                                                   selem_link_map(smap, copy)
>                                                   // adding new element to the
>                                                   // map -> leak
>                                         rcu_read_unlock
> 
>        selem_unlink_sk
>         sk->sk_bpf_storage = NULL
> 
>      synchronize_rcu
> 

Makes sense, thanks for clarifying. Perhaps a small comment on top of
the bpf_map_inc_not_zero() would be great as well, so it's immediately
clear also from this location when reading the code why this is done.

Thanks,
Daniel
