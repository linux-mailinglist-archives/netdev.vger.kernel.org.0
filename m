Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649E328FDE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 06:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfEXERf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 00:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfEXERf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 00:17:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 495873079B9F;
        Fri, 24 May 2019 04:17:34 +0000 (UTC)
Received: from [10.72.12.217] (ovpn-12-217.pek2.redhat.com [10.72.12.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E02619724;
        Fri, 24 May 2019 04:17:30 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked devices.
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "jesper.brouer@gmail.com" <jesper.brouer@gmail.com>
Cc:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
 <20190523175429.13302-3-sthemmin@microsoft.com>
 <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ebf12468-504c-fae7-b62d-2b6db47391f9@redhat.com>
Date:   Fri, 24 May 2019 12:17:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 24 May 2019 04:17:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/24 上午3:19, Saeed Mahameed wrote:
> On Thu, 2019-05-23 at 10:54 -0700, Stephen Hemminger wrote:
>> When a device is stacked like (team, bonding, failsafe or netvsc) the
>> XDP generic program for the parent device was not called.
>>
>> Move the call to XDP generic inside __netif_receive_skb_core where
>> it can be done multiple times for stacked case.
>>
>> Suggested-by: Jiri Pirko <jiri@resnulli.us>
>> Fixes: d445516966dc ("net: xdp: support xdp generic on virtual
>> devices")
>> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>> ---
>> v1 - call xdp_generic in netvsc handler
>> v2 - do xdp_generic in generic rx handler processing
>> v3 - move xdp_generic call inside the another pass loop
>>
>>   net/core/dev.c | 56 ++++++++++------------------------------------
>> ----
>>   1 file changed, 11 insertions(+), 45 deletions(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index b6b8505cfb3e..696776e14d00 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff
>> *skb)
>>   
>>   	trace_netif_rx(skb);
>>   
>> -	if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> -		int ret;
>> -
>> -		preempt_disable();
>> -		rcu_read_lock();
>> -		ret = do_xdp_generic(rcu_dereference(skb->dev-
>>> xdp_prog), skb);
>> -		rcu_read_unlock();
>> -		preempt_enable();
>> -
>> -		/* Consider XDP consuming the packet a success from
>> -		 * the netdev point of view we do not want to count
>> -		 * this as an error.
>> -		 */
>> -		if (ret != XDP_PASS)
>> -			return NET_RX_SUCCESS;
>> -	}
>> -
> Adding Jesper,
>
> There is a small behavioral change due to this patch,


At least not for current code. We don't support skb in cpumap (though 
the fix should not be hard), in dp_do_generic_redirect_map() we had:

         } else {
                 /* TODO: Handle BPF_MAP_TYPE_CPUMAP */
                 err = -EBADRQC;
                 goto err;
         }


> the XDP program after this patch will run on the RPS CPU, if
> configured, which could cause some behavioral changes in
> xdp_redirect_cpu: bpf_redirect_map(cpu_map).
>
> Maybe this is acceptable, but it should be documented, as the current
> assumption dictates: XDP program runs on the core where the XDP
> frame/SKB was first seen.


At lest for TUN, this is not true. XDP frames were built by vhost_net 
and passed to TUN. There's no guarantee that vhost_net kthread won't 
move to another core.

Thanks



