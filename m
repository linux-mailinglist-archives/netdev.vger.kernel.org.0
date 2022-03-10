Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C854D3EF6
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 02:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiCJBwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 20:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbiCJBwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 20:52:23 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A437127D79;
        Wed,  9 Mar 2022 17:51:22 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KDX3W1HZlz1GCK0;
        Thu, 10 Mar 2022 09:46:31 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 09:51:20 +0800
Subject: Re: IPv4 saddr do not match with selected output device in double
 default gateways scene
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
To:     David Miller <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <ja@ssi.bg>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
Message-ID: <0de63268-a33b-d514-9457-1332c8aec58e@huawei.com>
Date:   Thu, 10 Mar 2022 09:51:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <58c15089-f1c7-675e-db4b-b6dfdad4b497@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Create VLAN devices and add default gateways with following commands:
> 
> # ip link add link eth2 dev eth2.71 type vlan id 71
> # ip link add link eth2 dev eth2.72 type vlan id 72
> # ip addr add 192.168.71.41/24 dev eth2.71
> # ip addr add 192.168.72.41/24 dev eth2.72
> # ip link set eth2.71 up
> # ip link set eth2.72 up
> # route add -net default gw 192.168.71.1 dev eth2.71
> # route add -net default gw 192.168.72.1 dev eth2.72
> 
> Add a nameserver configuration in the following file:
> # cat /etc/resolv.conf
> nameserver 8.8.8.8
> 
> Use the following command trigger DNS packet:
> # ping www.baidu.com
> 
> Assume the above test machine is client.
> 
> Of course, we should also create VLAN devices in peer server as following:
> 
> # ip link add link eth2 dev eth2.71 type vlan id 71
> # ip link add link eth2 dev eth2.72 type vlan id 72
> # ip addr add 192.168.71.1/24 dev eth2.71
> # ip addr add 192.168.72.1/24 dev eth2.72
> # ip link set eth2.71 up
> # ip link set eth2.72 up
> 
> We capture packets with tcpdump in client machine when ping:
> # tcpdump -i eth2 -vne
> ...
> 20:30:22.996044 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25407, offset 0, flags [DF], proto UDP (17), length 59)
>     192.168.72.41.42666 > 8.8.8.8.domain: 58562+ A? www.baidu.com. (31)
> 20:30:22.996125 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25408, offset 0, flags [DF], proto UDP (17), length 59)
>     192.168.72.41.42666 > 8.8.8.8.domain: 25803+ AAAA? www.baidu.com. (31)
> ...
> 
> We can find that IPv4 saddr "192.168.72.41" do not match with selected VLAN device "eth2.71".

Is there anyone familiar with route/fib realization? And thank you for your warm-hearted help!

> 
> I tracked the related processes, and found that user space program uses connect() firstly, then sends UDP packet.
> 
> The problem happens in the connect() process. Analysis as following with codes:
> 
> static inline struct rtable *ip_route_connect(struct flowi4 *fl4,
> 					      __be32 dst, __be32 src, u32 tos,
> 					      int oif, u8 protocol,
> 					      __be16 sport, __be16 dport,
> 					      struct sock *sk)
> {
> 	struct net *net = sock_net(sk);
> 	struct rtable *rt;
> 
> 	ip_route_connect_init(fl4, dst, src, tos, oif, protocol,
> 			      sport, dport, sk);
> 
> 	if (!dst || !src) {
> 
> 		/* rtable and fl4 are matched after the first __ip_route_output_key().
> 		 * rtable->dst.dev->name == "eth2.72" && rtable->rt_gw4 == 0x148a8c0
> 		 * fl4->saddr == 0x2948a8c0
> 		 */
> 		rt = __ip_route_output_key(net, fl4);
> 		if (IS_ERR(rt))
> 			return rt;
> 		ip_rt_put(rt);
> 		flowi4_update_output(fl4, oif, tos, fl4->daddr, fl4->saddr);
> 	}
> 	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
> 
> 	/* rtable and fl4 do not match after the second __ip_route_output_key().
> 	 * rtable->dst.dev->name == "eth2.71" && rtable->rt_gw4 == 0x147a8c0
> 	 * fl4->saddr == 0x2948a8c0
> 	 */
> 	return ip_route_output_flow(net, fl4, sk);
> }
> 
> Deep tracking, it because fa->fa_default has changed in fib_select_default() after first __ip_route_output_key() process,
> and a new fib_nh is selected in fib_select_default() within the second __ip_route_output_key() process but not update flowi4.
> So the phenomenon described at the beginning happens.
> 
> Does it a kernel bug or a user problem? If it is a kernel bug, is there any good solution?
> 

