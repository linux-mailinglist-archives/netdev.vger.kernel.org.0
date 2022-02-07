Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641AD4AC277
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384189AbiBGPFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441933AbiBGOqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:46:32 -0500
X-Greylist: delayed 1205 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 06:46:10 PST
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BD9C0401D9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:46:10 -0800 (PST)
Received: from kwepemi500005.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jsp0N0MWqzccn5;
        Mon,  7 Feb 2022 22:08:52 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi500005.china.huawei.com (7.221.188.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 22:09:51 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 22:09:50 +0800
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Subject: [BUG] net: ipv4: The sent udp broadcast message may be converted to
 an arp request message
Message-ID: <55a04a8f-56f3-f73c-2aea-2195923f09d1@huawei.com>
Date:   Mon, 7 Feb 2022 22:09:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I found a bug, but I don't know how to fix it. Anyone have some good ideas?

This bug will cause udp broadcast messages not to be sent, but instead send
non-expected arp request messages.

Deleting the ip while sending udp broadcast messages and then configuring
the ip again will probably trigger the bug.

The following is the timing diagram of the bug, cpu0 sends a broadcast
message and cpu1 deletes the routing table at the appropriate time.

cpu0                                        cpu1
send()
   udp_sendmsg()
     ip_route_output_flow()
     |  fib_lookup()
     udp_send_skb()
       ip_send_skb()
         ip_finish_output2()

                                             ifconfig eth0:2 down
                                               fib_del_ifaddr
                                                 fib_table_delete // 
delete fib table

           ip_neigh_for_gw()
           |  ip_neigh_gw4()
           |    __ipv4_neigh_lookup_noref()
           |    __neigh_create()
           |      tbl->constructor(n) --> arp_constructor()
           |        neigh->type = inet_addr_type_dev_table(); // no 
route, neigh->type = RTN_UNICAST
           neigh_output() // unicast, send an arp request and create an 
exception arp entry

After the above operation, an abnormal arp entry will be generated. If
the ip is configured again(ifconfig eth0:2 12.0.208.0), the abnormal arp
entry will still exist, and the udp broadcast message will be converted
to an arp request message when it is sent.

Any feedback would be appreciated, thanks.

-- 
Wang Hai

