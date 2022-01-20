Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF7494740
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358599AbiATGYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:24:49 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31107 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiATGYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:24:49 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JfXSr48pLz1FCqG;
        Thu, 20 Jan 2022 14:21:00 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 14:24:46 +0800
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
To:     Oliver Hartkopp <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
 <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
Message-ID: <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
Date:   Thu, 20 Jan 2022 14:24:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 18.01.22 13:46, Ziyang Xuan (William) wrote:
>>> Hi,
>>>
>>> the referenced syzbot issue has already been fixed in upstream here:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=5f33a09e769a9da0482f20a6770a342842443776
>>>
>>> ("can: isotp: convert struct tpcon::{idx,len} to unsigned int")
>>>
>>> Additionally this fix changes some behaviour that is required by the ISO 16765-2 specification (see below).
>>>
>>> On 17.01.22 13:01, Ziyang Xuan wrote:
>>>> When receive a FF, the current code logic does not consider the real
>>>> so->rx.state but set so->rx.state to ISOTP_IDLE directly. That will
>>>> make so->rx accessed by multiple receiving processes concurrently.
>>>
>>> This is intentionally. "multiple receiving processes" are not allowed resp. specified by ISO 15765-2.
>>
>> Does it can be a network attack?
> 
> Yes. You can see it like this. The ISO 15765-2 protocol is an unreliable UDP-like datagram protocol and the session layer takes care about timeouts and packet lost.
> 
> If you want to disturb that protocol you can also send PDUs with out-of-sync packet counters which will make the receiver drop the communication attempt.
> 
> This is 'CAN-style' ... as usually the bus is very reliable. Security and reliable communication is done on top of these protocols.
> 
>> It receives packets from network, but unexpected packets order make server panic.
> 
> Haha, no :-)
> 
> Unexpected packets should not make the server panic but only drop the communication process.

I have reproduced the syz problem with Marc's commit, the commit can not fix the panic problem.
So I tried to find the root cause for panic and gave my solution.

Marc's commit just fix the condition that packet size bigger than INT_MAX which trigger
tpcon::{idx,len} integer overflow, but the packet size is 4096 in the syz problem.

so->rx.len is 0 after the following logic in isotp_rcv_ff():

/* get the FF_DL */
so->rx.len = (cf->data[ae] & 0x0F) << 8;
so->rx.len += cf->data[ae + 1];

so->rx.len is 4096 after the following logic in isotp_rcv_ff():

/* FF_DL = 0 => get real length from next 4 bytes */
so->rx.len = cf->data[ae + 2] << 24;
so->rx.len += cf->data[ae + 3] << 16;
so->rx.len += cf->data[ae + 4] << 8;
so->rx.len += cf->data[ae + 5];

so->rx.len is 0 before alloc_skb() and is 4096 after alloc_skb() in isotp_rcv_cf(). The following
skb_put() will trigger panic.

The following log is my reproducing log with Marc's commit and my debug modification in isotp_rcv_cf().

[  150.605776][    C6] isotp_rcv_cf: before alloc_skb so->rc.len: 0, after alloc_skb so->rx.len: 4096
[  150.611477][    C6] skbuff: skb_over_panic: text:ffffffff881ff7be len:4096 put:4096 head:ffff88807f93a800 data:ffff88807f93a800 tail:0x1000 end:0xc0 dev:<NULL>
[  150.615837][    C6] ------------[ cut here ]------------
[  150.617238][    C6] kernel BUG at net/core/skbuff.c:113!

> In the case pointed out by syzbot the unsigned 32 bit length information was stored in a signed 32 bit integer which caused a sanity check to fail.
> 
> This is now fixed with the patch from Marc.
> 
> Regards,
> Oliver
> .
