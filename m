Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E464925F7
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbiARMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:46:47 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31101 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbiARMqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:46:46 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JdT2V1PdJz1FCpm;
        Tue, 18 Jan 2022 20:42:58 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 18 Jan 2022 20:46:41 +0800
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
To:     Oliver Hartkopp <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
 <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
Date:   Tue, 18 Jan 2022 20:46:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,
> 
> the referenced syzbot issue has already been fixed in upstream here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=5f33a09e769a9da0482f20a6770a342842443776
> 
> ("can: isotp: convert struct tpcon::{idx,len} to unsigned int")
> 
> Additionally this fix changes some behaviour that is required by the ISO 16765-2 specification (see below).
> 
> On 17.01.22 13:01, Ziyang Xuan wrote:
>> When receive a FF, the current code logic does not consider the real
>> so->rx.state but set so->rx.state to ISOTP_IDLE directly. That will
>> make so->rx accessed by multiple receiving processes concurrently.
> 
> This is intentionally. "multiple receiving processes" are not allowed resp. specified by ISO 15765-2.

Does it can be a network attack?

It receives packets from network, but unexpected packets order make server panic.

> 
>> The following syz problem is one of the scenarios. so->rx.len is
>> changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
>> 0 before alloc_skb() and equals 4096 after alloc_skb(). That will
>> trigger skb_over_panic() in skb_put().
>>
>> =======================================================
>> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
>> RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
>> Call Trace:
>>   <TASK>
>>   skb_over_panic net/core/skbuff.c:118 [inline]
>>   skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
>>   isotp_rcv_cf net/can/isotp.c:570 [inline]
>>   isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
>>   deliver net/can/af_can.c:574 [inline]
>>   can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
>>   can_receive+0x31d/0x580 net/can/af_can.c:665
>>   can_rcv+0x120/0x1c0 net/can/af_can.c:696
>>   __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
>>   __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579
>>
>> Check so->rx.state equals ISOTP_IDLE firstly in isotp_rcv_ff().
>> Make sure so->rx idle when receive another new packet. And set
>> so->rx.state to ISOTP_IDLE after whole packet being received.
>>
>> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
>> Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>   net/can/isotp.c | 28 +++++++++++++++++-----------
>>   1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>> index df6968b28bf4..a4b174f860f3 100644
>> --- a/net/can/isotp.c
>> +++ b/net/can/isotp.c
>> @@ -443,8 +443,10 @@ static int isotp_rcv_ff(struct sock *sk, struct canfd_frame *cf, int ae)
>>       int off;
>>       int ff_pci_sz;
>>   +    if (so->rx.state != ISOTP_IDLE)
>> +        return 0;
>> +
>>       hrtimer_cancel(&so->rxtimer);
>> -    so->rx.state = ISOTP_IDLE;
> 
> No matter in which receiving state we receive a first frame (FF) we are required to start a fresh reception process and/or terminate the current attempt.
> 
> Best regards,
> Oliver
> 
>>         /* get the used sender LL_DL from the (first) CAN frame data length */
>>       so->rx.ll_dl = padlen(cf->len);
>> @@ -518,8 +520,6 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
>>           so->lastrxcf_tstamp = skb->tstamp;
>>       }
>>   -    hrtimer_cancel(&so->rxtimer);
>> -
>>       /* CFs are never longer than the FF */
>>       if (cf->len > so->rx.ll_dl)
>>           return 1;
>> @@ -531,15 +531,15 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
>>               return 1;
>>       }
>>   +    hrtimer_cancel(&so->rxtimer);
>> +
>>       if ((cf->data[ae] & 0x0F) != so->rx.sn) {
>>           /* wrong sn detected - report 'illegal byte sequence' */
>>           sk->sk_err = EILSEQ;
>>           if (!sock_flag(sk, SOCK_DEAD))
>>               sk_error_report(sk);
>>   -        /* reset rx state */
>> -        so->rx.state = ISOTP_IDLE;
>> -        return 1;
>> +        goto err_out;
>>       }
>>       so->rx.sn++;
>>       so->rx.sn %= 16;
>> @@ -551,21 +551,18 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
>>       }
>>         if (so->rx.idx >= so->rx.len) {
>> -        /* we are done */
>> -        so->rx.state = ISOTP_IDLE;
>> -
>>           if ((so->opt.flags & ISOTP_CHECK_PADDING) &&
>>               check_pad(so, cf, i + 1, so->opt.rxpad_content)) {
>>               /* malformed PDU - report 'not a data message' */
>>               sk->sk_err = EBADMSG;
>>               if (!sock_flag(sk, SOCK_DEAD))
>>                   sk_error_report(sk);
>> -            return 1;
>> +            goto err_out;
>>           }
>>             nskb = alloc_skb(so->rx.len, gfp_any());
>>           if (!nskb)
>> -            return 1;
>> +            goto err_out;
>>             memcpy(skb_put(nskb, so->rx.len), so->rx.buf,
>>                  so->rx.len);
>> @@ -573,6 +570,10 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
>>           nskb->tstamp = skb->tstamp;
>>           nskb->dev = skb->dev;
>>           isotp_rcv_skb(nskb, sk);
>> +
>> +        /* we are done */
>> +        so->rx.state = ISOTP_IDLE;
>> +
>>           return 0;
>>       }
>>   @@ -591,6 +592,11 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
>>       /* we reached the specified blocksize so->rxfc.bs */
>>       isotp_send_fc(sk, ae, ISOTP_FC_CTS);
>>       return 0;
>> +
>> +err_out:
>> +    /* reset rx state */
>> +    so->rx.state = ISOTP_IDLE;
>> +    return 1;
>>   }
>>     static void isotp_rcv(struct sk_buff *skb, void *data)
> .
