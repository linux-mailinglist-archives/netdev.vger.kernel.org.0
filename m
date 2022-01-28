Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB98F49F10D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345417AbiA1Cgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:36:35 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17821 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345337AbiA1Cgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:36:35 -0500
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlM4c0fYcz9sc9;
        Fri, 28 Jan 2022 10:35:12 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 10:36:28 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 10:36:27 +0800
Subject: Re: packet stuck in qdisc
To:     Vincent Ray <vray@kalrayinc.com>, <vladimir.oltean@nxp.com>,
        <kuba@kernel.org>, <davem@davemloft.ne>
CC:     Samuel Jones <sjones@kalrayinc.com>, <netdev@vger.kernel.org>
References: <1862202329.1457162.1643113633513.JavaMail.zimbra@kalray.eu>
 <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1c53c5c0-4e77-723b-4260-de83e8f8e40c@huawei.com>
Date:   Fri, 28 Jan 2022 10:36:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <698739062.1462023.1643115337201.JavaMail.zimbra@kalray.eu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/1/25 20:55, Vincent Ray wrote:
> Dear kernel maintainers / developers,
> 
> I work at Kalray where we are developping an NVME-over-TCP target controller board.
> My setup is as such :
> - a development workstation running Linux 5.x.y (the host)
> - sending NVME-TCP traffic to our board, to which it is connected through a Mellanox NIC (Connect-X-5) and a 100G ETH cable
> 
> While doing performance tests, using simple fio scenarios running over the regular kernel nvme-tcp driver on the host, we noticed important performance variations.
> After some digging (using tcpdump on the host), we found that there were big "holes" in the tcp traffic sent by the host.
> The scenario we observed is the following :
> 1) a TCP segment gets lost (not sent by the host) on a particular TCP connection, leading to a gap in the seq numbers received by the board
> 2) the board sends dup-acks and/or sacks (if configured) to signal this loss
> 3) then, sometimes, the host stops emitting on that TCP connection for several seconds (as much as 14s observed)
> 4) finally the host resumes emission, sending the missing packet
> 5) then the TCP connection continues correctly with the appropriate throughput
> 
> Such a scenario can be observed in the attached tcpdump (+ comments).

Hi,
    Thanks for reporting the problem.

> 
> We noticed that this was happening only in recent versions of the kernel, so we dichotomized until we found the culprit commits :
> we believe that the bug was introduced in qdisc updates for 5.14.rc1 by this set of commits, more precisely the middle one :
> 
> [2021-06-22] d3e0f57 Yunsheng Lin net: sched: remove qdisc->empty for lockless qdisc
> [2021-06-22] c4fef01 Yunsheng Lin net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc    *=> KO*
> [2021-06-22] dd25296 Yunsheng Lin net: sched: avoid unnecessary seqcount operation for lockless qdisc   *=> still OK*
> 
> As far as I can tell, the bug is still present in the mainline (at least it was in 5.16-rc4).
> From what I understand / guess, some optimizations in lockless qdiscs have lead to a race making the qdisc unaware that a packet has been enqueued and is waiting for emission.
> I suspect that, when this happens with TCP packets "to be retransmitted", the TCP stack will not timeout and try to retransmitt again because it uses skb_still_in_host_queue() to avoid useless re-retransmissions
> From net/ipv4/ tcp_output.c :
> //* Thanks to skb fast clones, we can detect if a prior transmit of                                                                                                                                                   /
> / * a packet is still in a qdisc or driver queue.                                                                                                                                                                     /
> / * In this case, there is very little point doing a retransmit !                                                                                                                                                     /
> / */  /
> I guess this plays a role in making these holes grow up to 14s, and an other layer than TCP might not experience it (?).
> 
> The interface through which my traffic is going is :
> eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
>     link/ether b8:ce:f6:60:c9:97 brd ff:ff:ff:ff:ff:ff
>     inet 10.20.0.254/24 scope global eth3
> 
> As you can see, it uses a mq qdisc. I did not try with other qdiscs yet.
> 
> Finally, if/when troubleshooting this problem in kernels older than 5.14.7, it's a good idea to first cherry-pick this patch :
> [2021-09-09] ae66447 Keith Busch nvme-tcp: fix io_work priority inversion
> because it fixes a nvme-tcp bug whose performance impact is itself so big that it "hides" the one we've discovered (bringing itself lots of holes at the nvme-tcp layer ...)
> 
> On impacted kernels, the "pkt_stuck_in_qdisc" bug shows up in the order of zero to a few occurences per minute per TCP connection.

It seems the problem can be reproduced easily. Is there some testcase without
hw dependency, so that I can reproduce the problem myself?

> 
> I did not really have time to understand it thoroughly, nor am I a network stack expert, so I don't propose any particular patch for it but I'll be happy to help testing fix attempts if it can help.
> Please feel free to ask any additional information.

Which cpu is used in the testing? It seems the cpu arch's
memory semantic is importance when handling the rare case.


> Best regards,
> 
> 
> *Vincent Ray*
> *Senior Architect • Kalray*
> Phone: +33 6 43 94 87 65
> _vray@kalrayinc.com_ • _www.kalrayinc.com_ <https://www.kalrayinc.com>
> 
> Kalray logo <https://www.kalrayinc.com>
> 	
> Intelligent Data Processing
> From Cloud to Edge
> 
> 
> *Please consider the environment before printing this e-mail.*
> This message contains information that may be privileged or confidential and is the property of Kalray S.A. It is intended only for the person to whom it is addressed. If you are not the intended recipient, you are not authorized to print, retain, copy, disseminate, distribute, or use this message or any part thereof. If you receive this message in error, please notify the sender immediately and delete all copies of this message.
> 
