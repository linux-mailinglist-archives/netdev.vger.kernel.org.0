Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F10E2FD254
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390053AbhATOGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:06:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:28887 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389747AbhATN2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:28:49 -0500
IronPort-SDR: AQ9R1KDJBDBRGNt29msXMURvD1lpft/pQkQZODcZwo3R4qMLfpaBeiaGKWW8LXj4xafR7HxlKt
 30Azub2RQCxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="243173267"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="243173267"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:28:05 -0800
IronPort-SDR: EQJKsnWu5S8VyOtGQnfXye3iZuwRWDWOA69LQJOBOUY7FdvIsNdnTMi1DmJwZllNDfNY2Jnu7I
 h/VpvIlfqP0g==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384834944"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:28:00 -0800
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <9fd68fd5-6a9f-3c36-1b83-4ba587387f5d@intel.com>
Date:   Wed, 20 Jan 2021 14:27:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 14:15, Maxim Mikityanskiy wrote:
> On 2021-01-19 17:50, Björn Töpel wrote:
>> This series extends bind() for XDP sockets, so that the bound socket
>> is added to the netdev_rx_queue _rx array in the netdevice. We call
>> this to register the socket. To redirect packets to the registered
>> socket, a new BPF helper is used: bpf_redirect_xsk().
>>
>> For shared XDP sockets, only the first bound socket is
>> registered. Users that need more complex setup has to use XSKMAP and
>> bpf_redirect_map().
>>
>> Now, why would one use bpf_redirect_xsk() over the regular
>> bpf_redirect_map() helper?
>>
>> * Better performance!
>> * Convenience; Most user use one socket per queue. This scenario is
>>    what registered sockets support. There is no need to create an
>>    XSKMAP. This can also reduce complexity from containerized setups,
>>    where users might what to use XDP sockets without CAP_SYS_ADMIN
>>    capabilities.
>>
>> The first patch restructures xdp_do_redirect() a bit, to make it
>> easier to add the new helper. This restructure also give us a slight
>> performance benefit. The following three patches extends bind() and
>> adds the new helper. After that, two libbpf patches that selects XDP
>> program based on what kernel is running. Finally, selftests for the new
>> functionality is added.
>>
>> Note that the libbpf "auto-selection" is based on kernel version, so
>> it is hard coded to the "-next" version (5.12). If you would like to
>> try this is out, you will need to change the libbpf patch locally!
>>
>> Thanks to Maciej and Magnus for the internal review/comments!
>>
>> Performance (rxdrop, zero-copy)
>>
>> Baseline
>> Two cores:                   21.3 Mpps
>> One core:                    24.5 Mpps
> 
> Two cores is slower? It used to be faster all the time, didn't it?
>

Up until busy-polling. Note that I'm using a busy-poll napi budget of 512.


>> Patched
>> Two cores, bpf_redirect_map: 21.7 Mpps + 2%
>> One core, bpf_redirect_map:  24.9 Mpps + 2%
>>
>> Two cores, bpf_redirect_xsk: 24.0 Mpps +13%
> 
> Nice, impressive improvement!
>

Thanks! Getting rid of the queue/netdev checks really payed off!


Björn
