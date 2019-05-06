Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBBA148A4
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFK6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:58:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:9295 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfEFK6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 06:58:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 May 2019 03:58:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,437,1549958400"; 
   d="scan'208";a="155485080"
Received: from btopel-mobl.isw.intel.com (HELO btopel-mobl.ger.intel.com) ([10.103.209.137])
  by FMSMGA003.fm.intel.com with ESMTP; 06 May 2019 03:58:50 -0700
Subject: Re: [PATCH bpf-next 1/2] xsk: remove AF_XDP socket from map when the
 socket is released
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, Bruce Richardson <bruce.richardson@intel.com>
References: <20190504160603.10173-1-bjorn.topel@gmail.com>
 <20190504160603.10173-2-bjorn.topel@gmail.com>
 <89542aec-4fb5-5322-624f-99731a834b8b@iogearbox.net>
 <033c455c-0f76-178e-3df0-97c0dc540f30@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a45b0353-8878-f86f-7d85-2e38c8b8f99e@intel.com>
Date:   Mon, 6 May 2019 12:58:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <033c455c-0f76-178e-3df0-97c0dc540f30@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-06 12:07, Daniel Borkmann wrote:
> On 05/06/2019 12:04 PM, Daniel Borkmann wrote:
>> On 05/04/2019 06:06 PM, Björn Töpel wrote:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> When an AF_XDP socket is released/closed the XSKMAP still holds a
>>> reference to the socket in a "released" state. The socket will still
>>> use the netdev queue resource, and block newly created sockets from
>>> attaching to that queue, but no user application can access the
>>> fill/complete/rx/tx rings. This results in that all applications need
>>> to explicitly clear the map entry from the old "zombie state"
>>> socket. This should be done automatically.
>>>
>>> After this patch, when a socket is released, it will remove itself
>>> from all the XSKMAPs it resides in, allowing the socket application to
>>> remove the code that cleans the XSKMAP entry.
>>>
>>> This behavior is also closer to that of SOCKMAP, making the two socket
>>> maps more consistent.
>>>
>>> Reported-by: Bruce Richardson <bruce.richardson@intel.com>
>>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> [...]
>>
>>
>>> +static void __xsk_map_delete_elem(struct xsk_map *map,
>>> +				  struct xdp_sock **map_entry)
>>> +{
>>> +	struct xdp_sock *old_xs;
>>> +
>>> +	spin_lock_bh(&map->lock);
>>> +	old_xs = xchg(map_entry, NULL);
>>> +	if (old_xs)
>>> +		xsk_map_del_node(old_xs, map_entry);
>>> +	spin_unlock_bh(&map->lock);
>>> +
>>> +}
>>> +
>>>   static void xsk_map_free(struct bpf_map *map)
>>>   {
>>>   	struct xsk_map *m = container_of(map, struct xsk_map, map);
>>> @@ -78,15 +142,16 @@ static void xsk_map_free(struct bpf_map *map)
>>>   	bpf_clear_redirect_map(map);
>>>   	synchronize_net();
>>>   
>>> +	spin_lock_bh(&m->lock);
>>>   	for (i = 0; i < map->max_entries; i++) {
>>> +		struct xdp_sock **entry = &m->xsk_map[i];
>>>   		struct xdp_sock *xs;
>>>   
>>> -		xs = m->xsk_map[i];
>>> -		if (!xs)
>>> -			continue;
>>> -
>>> -		sock_put((struct sock *)xs);
>>> +		xs = xchg(entry, NULL);
>>> +		if (xs)
>>> +			__xsk_map_delete_elem(m, entry);
>>>   	}
>>> +	spin_unlock_bh(&m->lock);
>>>   
>>
>> Was this tested? Doesn't the above straight run into a deadlock?
>>
>>  From xsk_map_free() you iterate over the map with m->lock held. Once you
>> xchg'ed the entry and call into __xsk_map_delete_elem(), you attempt to
>> call map->lock on the same map once again. What am I missing?
> 
> (It also does the xchg() twice so we'd leak the xs since it's NULL in the
>   second one.)
> 

No, you're not missing anything. Just plain old sloppiness from my side.
Apologies for the wasted time.


Björn

>> Thanks,
>> Daniel
