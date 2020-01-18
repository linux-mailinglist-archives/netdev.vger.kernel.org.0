Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA9B141537
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 01:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgARAeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 19:34:09 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:48710 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729748AbgARAeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 19:34:09 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id ACA492F7539;
        Fri, 17 Jan 2020 16:34:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com ACA492F7539
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1579307648;
        bh=N+LmasajIWUxa2zsWRULtQh4rOUVMycfI+GUHI/baCU=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=QlvnAQrnG7HGX12rsEIVJtdFYGj5MssodxI76ldb5u0UnpE/U95U9gCL2hVlcrwZt
         XqpzTFy1vKKbfh4dLfMFCBiGqCiPiPb3asXrnxLeDiuTvGHkwEAV1KqW/tvZde8WSq
         T9PFprEM3VRQNWvN/RLP2sdJim8gTGoNmPctWBZw=
Subject: Re: vrf and ipsec xfrm routing problem
From:   Ben Greear <greearb@candelatech.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>
References: <1425d02c-de99-b708-e543-b7fe3f0ef07e@candelatech.com>
 <9893ae01-18a5-2afd-b485-459423b8adc0@candelatech.com>
Organization: Candela Technologies
Message-ID: <e677fd11-8373-818e-9b50-35e4f9fdcb62@candelatech.com>
Date:   Fri, 17 Jan 2020 16:34:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9893ae01-18a5-2afd-b485-459423b8adc0@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/20 1:52 PM, Ben Greear wrote:
> On 1/17/20 9:49 AM, Ben Greear wrote:
>> Hello,
>>
>> I'm back to mucking with xfrm and vrfs.  I am currently able to get the
>> xfrm interface to connect to the ipsec peer and get an IP address.
>>
>> But, when I bind a UDP socket to the x_eth4 xfrm device, the packets
>> go out of eth4 instead.
>>
>> Based on the problems I was having with multicast, I am thinking this might just be some routing problem.
>>
>> # ip route show vrf _vrf4
>> default via 192.168.5.1 dev eth4
>> 192.168.5.0/24 dev eth4 scope link src 192.168.5.4
>>
>> # ip addr show dev eth4
>> 7: eth4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master _vrf4 state UP group default qlen 1000
>>      link/ether 00:30:18:01:63:eb brd ff:ff:ff:ff:ff:ff
>>      inet 192.168.5.4/24 brd 192.168.5.255 scope global eth4
>>         valid_lft forever preferred_lft forever
>>
>> # ip addr show dev x_eth4
>> 30: x_eth4@eth4: <NOARP,UP,LOWER_UP> mtu 1440 qdisc noqueue master _vrf4 state UNKNOWN group default qlen 1000
>>      link/none 00:30:18:01:63:eb brd ff:ff:ff:ff:ff:ff
>>      inet 192.168.10.101/32 scope global x_eth4
>>         valid_lft forever preferred_lft forever
>>      inet6 fe80::f6ec:3e67:9b7b:60c9/64 scope link stable-privacy
>>         valid_lft forever preferred_lft forever
>>
>>
>> I tried adding a route to specify the x_frm as source, but that does not appear to work:
>>
>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via 192.168.5.1 dev x_eth4 table 4
>> [root@lf0313-63e7 lanforge]# ip route show vrf _vrf4
>> default via 192.168.5.1 dev eth4
>> 192.168.5.0/24 dev eth4 scope link src 192.168.5.4
>> 192.168.10.0/24 via 192.168.5.1 dev eth4
>>
>> I also tried this, but no luck:
>>
>> [root@lf0313-63e7 lanforge]# ip route add 192.168.10.0/24 via 192.168.10.1 dev x_eth4 table 4
>> Error: Nexthop has invalid gateway.

So, looks like all I need to do is to pull the xfrm device out of the vrf, and now
traffic is working.  Possibly I need to put the xfrm in its own vrf, I'll need to
test a more complex case to determine that.

I will clean up my test bed and scripts and make sure this is reproducible.

Thanks,
Ben

> 
> I went looking for why this was failing.  The reason is that this code is hitting the error case
> in the code snippet below (from 5.2.21+ kernel).
> 
> The oif is that of _vrf4, not the x_eth4 device.
> 
> David:  Is this expected behaviour?  Do you know how to tell vrf to use the x_eth4
> xfrm device as oif when routing output to certain destinations?
> 
>      rcu_read_lock();
>      {
>          struct fib_table *tbl = NULL;
>          struct flowi4 fl4 = {
>              .daddr = nh->fib_nh_gw4,
>              .flowi4_scope = scope + 1,
>              .flowi4_oif = nh->fib_nh_oif,
>              .flowi4_iif = LOOPBACK_IFINDEX,
>          };
> 
>          /* It is not necessary, but requires a bit of thinking */
>          if (fl4.flowi4_scope < RT_SCOPE_LINK)
>              fl4.flowi4_scope = RT_SCOPE_LINK;
> 
>          if (table)
>              tbl = fib_get_table(net, table);
> 
>          if (tbl)
>              err = fib_table_lookup(tbl, &fl4, &res,
>                             FIB_LOOKUP_IGNORE_LINKSTATE |
>                             FIB_LOOKUP_NOREF);
> 
>          /* on error or if no table given do full lookup. This
>           * is needed for example when nexthops are in the local
>           * table rather than the given table
>           */
>          if (!tbl || err) {
>              err = fib_lookup(net, &fl4, &res,
>                       FIB_LOOKUP_IGNORE_LINKSTATE);
>          }
> 
>          if (err) {
>              pr_err("daddr: 0x%x scope: %d  oif: %d iif: %d table: %d tbl: %p\n",
>                     fl4.daddr, fl4.flowi4_scope, fl4.flowi4_oif, fl4.flowi4_iif, table, tbl);
>              NL_SET_ERR_MSG(extack, "Nexthop has invalid gateway, table lookup");
>              goto out;
>          }
>      }
> 
> Thanks,
> Ben
> 

