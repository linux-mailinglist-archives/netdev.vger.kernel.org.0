Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0875A35905
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfFEIwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 04:52:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42314 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726690AbfFEIwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 04:52:49 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1C767CAD2F3FF6741F4C;
        Wed,  5 Jun 2019 16:52:45 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 5 Jun 2019
 16:52:35 +0800
Subject: Re: [PATCH net] tcp: avoid creating multiple req socks with the same
 tuples
To:     Eric Dumazet <edumazet@google.com>, Mao Wenan <maowenan@huawei.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190604145543.61624-1-maowenan@huawei.com>
 <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
Date:   Wed, 5 Jun 2019 16:52:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2019/6/4 23:24, Eric Dumazet 写道:
> On Tue, Jun 4, 2019 at 7:47 AM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> There is one issue about bonding mode BOND_MODE_BROADCAST, and
>> two slaves with diffierent affinity, so packets will be handled
>> by different cpu. These are two pre-conditions in this case.

>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> --
> 
> This issue has been discussed last year.
> 
> I am afraid your patch does not solve all races.
> 
> The lookup you add is lockless, so this is racy.
> 
> Really the only way to solve this is to make sure that _when_ the
> bucket lock is held,
> we do not insert a request socket if the 4-tuple is already in the
> chain (probably in inet_ehash_insert())
> 
> This needs more tricky changes than your patch.
> 

This kind case is rarely used, and the condition of the issue is strict.
If we add the "lookup" before or in inet_ehash_insert func for each reqsk,
overall performance will be affected.

We may solve the small probability issue with a trick in the tcp_v4_rcv.
If the ACK is invalid checked by tcp_check_req func, the req could be dropped,
and then goto the lookup for searching another avaliable reqsk. In this way,
the performance will not be affected in the normal process.

The patch is given as following:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a2896944aa37..9d0491587ed2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1874,8 +1874,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
                        goto discard_and_relse;
                }
                if (nsk == sk) {
-                       reqsk_put(req);
+                       inet_csk_reqsk_queue_drop_and_put(sk, req);
                        tcp_v4_restore_cb(skb);
+                       sock_put(sk);
+                       goto lookup;
                } else if (tcp_child_process(sk, nsk, skb)) {
                        tcp_v4_send_reset(nsk, skb);
                        goto discard_and_relse;






