Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432954AD49E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353746AbiBHJSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbiBHJSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:18:44 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2051C03FEC0;
        Tue,  8 Feb 2022 01:18:42 -0800 (PST)
Received: from kwepemi500017.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JtHQD3v4Fz1FD3D;
        Tue,  8 Feb 2022 17:14:28 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500017.china.huawei.com (7.221.188.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 17:18:39 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 17:18:38 +0800
Subject: Re: [BUG] net: ipv4: The sent udp broadcast message may be converted
 to an arp request message
To:     Ido Schimmel <idosch@idosch.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
 <YgIhGhh75mR5uLaS@shredder>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <f4a0f41c-d315-22a8-ee1f-b12bbf56187a@huawei.com>
Date:   Tue, 8 Feb 2022 17:18:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YgIhGhh75mR5uLaS@shredder>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/2/8 15:51, Ido Schimmel 写道:
> On Mon, Feb 07, 2022 at 10:09:49PM +0800, wanghai (M) wrote:
>> Hello,
>>
>> I found a bug, but I don't know how to fix it. Anyone have some good ideas?
>>
>> This bug will cause udp broadcast messages not to be sent, but instead send
>> non-expected arp request messages.
>>
>> Deleting the ip while sending udp broadcast messages and then configuring
>> the ip again will probably trigger the bug.
>>
>> The following is the timing diagram of the bug, cpu0 sends a broadcast
>> message and cpu1 deletes the routing table at the appropriate time.
>>
>> cpu0                                        cpu1
>> send()
>>    udp_sendmsg()
>>      ip_route_output_flow()
>>      |  fib_lookup()
>>      udp_send_skb()
>>        ip_send_skb()
>>          ip_finish_output2()
>>
>>                                              ifconfig eth0:2 down
>>                                                fib_del_ifaddr
>>                                                  fib_table_delete // delete
>> fib table
>>
>>            ip_neigh_for_gw()
>>            |  ip_neigh_gw4()
>>            |    __ipv4_neigh_lookup_noref()
>>            |    __neigh_create()
>>            |      tbl->constructor(n) --> arp_constructor()
>>            |        neigh->type = inet_addr_type_dev_table(); // no route,
>> neigh->type = RTN_UNICAST
>>            neigh_output() // unicast, send an arp request and create an
>> exception arp entry
>>
>> After the above operation, an abnormal arp entry will be generated. If
>> the ip is configured again(ifconfig eth0:2 12.0.208.0), the abnormal arp
>> entry will still exist, and the udp broadcast message will be converted
>> to an arp request message when it is sent.
> Can you try the below? Not really happy with it, but don't have a better
> idea at the moment. It seemed better to handle it from the control path
> than augmenting the data path with more checks
>
> diff --git a/include/net/arp.h b/include/net/arp.h
> index 031374ac2f22..9e6a1961b64c 100644
> --- a/include/net/arp.h
> +++ b/include/net/arp.h
> @@ -64,6 +64,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
>   	      const unsigned char *dest_hw,
>   	      const unsigned char *src_hw, const unsigned char *th);
>   int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
> +int arp_invalidate(struct net_device *dev, __be32 ip);
>   void arp_ifdown(struct net_device *dev);
>   
>   struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 4db0325f6e1a..b81665ce2b57 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -1116,7 +1116,7 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
>   	return err;
>   }
>   
> -static int arp_invalidate(struct net_device *dev, __be32 ip)
> +int arp_invalidate(struct net_device *dev, __be32 ip)
>   {
>   	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
>   	int err = -ENXIO;
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 4d61ddd8a0ec..2d7085232cb5 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -1112,9 +1112,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
>   		return;
>   
>   	/* Add broadcast address, if it is explicitly assigned. */
> -	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
> +	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
>   		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
>   			  prim, 0);
> +		arp_invalidate(dev, ifa->ifa_broadcast);
> +	}
>   
>   	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
>   	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
> @@ -1128,6 +1130,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
>   		if (ifa->ifa_prefixlen < 31) {
>   			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
>   				  32, prim, 0);
> +			arp_invalidate(dev, prefix | ~mask);
>   		}
>   	}
>   }

Thank you for your help. I tested it and it solved my problem.

Tested-by: Wang Hai <wanghai38@huawei.com>

> .
>
-- 
Wang Hai

