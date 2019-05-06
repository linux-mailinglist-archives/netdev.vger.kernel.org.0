Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E641482A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfEFKHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 06:07:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:47302 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfEFKHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 06:07:31 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNaWu-0002o0-Ue; Mon, 06 May 2019 12:07:29 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNaWu-0002Rm-Jl; Mon, 06 May 2019 12:07:28 +0200
Subject: Re: [PATCH bpf-next 1/2] xsk: remove AF_XDP socket from map when the
 socket is released
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bruce.richarson@intel.com, bpf@vger.kernel.org,
        Bruce Richardson <bruce.richardson@intel.com>
References: <20190504160603.10173-1-bjorn.topel@gmail.com>
 <20190504160603.10173-2-bjorn.topel@gmail.com>
 <89542aec-4fb5-5322-624f-99731a834b8b@iogearbox.net>
Message-ID: <033c455c-0f76-178e-3df0-97c0dc540f30@iogearbox.net>
Date:   Mon, 6 May 2019 12:07:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <89542aec-4fb5-5322-624f-99731a834b8b@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/2019 12:04 PM, Daniel Borkmann wrote:
> On 05/04/2019 06:06 PM, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> When an AF_XDP socket is released/closed the XSKMAP still holds a
>> reference to the socket in a "released" state. The socket will still
>> use the netdev queue resource, and block newly created sockets from
>> attaching to that queue, but no user application can access the
>> fill/complete/rx/tx rings. This results in that all applications need
>> to explicitly clear the map entry from the old "zombie state"
>> socket. This should be done automatically.
>>
>> After this patch, when a socket is released, it will remove itself
>> from all the XSKMAPs it resides in, allowing the socket application to
>> remove the code that cleans the XSKMAP entry.
>>
>> This behavior is also closer to that of SOCKMAP, making the two socket
>> maps more consistent.
>>
>> Reported-by: Bruce Richardson <bruce.richardson@intel.com>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> [...]
> 
> 
>> +static void __xsk_map_delete_elem(struct xsk_map *map,
>> +				  struct xdp_sock **map_entry)
>> +{
>> +	struct xdp_sock *old_xs;
>> +
>> +	spin_lock_bh(&map->lock);
>> +	old_xs = xchg(map_entry, NULL);
>> +	if (old_xs)
>> +		xsk_map_del_node(old_xs, map_entry);
>> +	spin_unlock_bh(&map->lock);
>> +
>> +}
>> +
>>  static void xsk_map_free(struct bpf_map *map)
>>  {
>>  	struct xsk_map *m = container_of(map, struct xsk_map, map);
>> @@ -78,15 +142,16 @@ static void xsk_map_free(struct bpf_map *map)
>>  	bpf_clear_redirect_map(map);
>>  	synchronize_net();
>>  
>> +	spin_lock_bh(&m->lock);
>>  	for (i = 0; i < map->max_entries; i++) {
>> +		struct xdp_sock **entry = &m->xsk_map[i];
>>  		struct xdp_sock *xs;
>>  
>> -		xs = m->xsk_map[i];
>> -		if (!xs)
>> -			continue;
>> -
>> -		sock_put((struct sock *)xs);
>> +		xs = xchg(entry, NULL);
>> +		if (xs)
>> +			__xsk_map_delete_elem(m, entry);
>>  	}
>> +	spin_unlock_bh(&m->lock);
>>  
> 
> Was this tested? Doesn't the above straight run into a deadlock?
> 
> From xsk_map_free() you iterate over the map with m->lock held. Once you
> xchg'ed the entry and call into __xsk_map_delete_elem(), you attempt to
> call map->lock on the same map once again. What am I missing?

(It also does the xchg() twice so we'd leak the xs since it's NULL in the
 second one.)

> Thanks,
> Daniel
