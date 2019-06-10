Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B383B6AA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390658AbfFJOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:02:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390384AbfFJOCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 10:02:48 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C55D96CA51B27A67399;
        Mon, 10 Jun 2019 22:02:43 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 10 Jun 2019
 22:02:42 +0800
Subject: Re: [PATCH -next] packet: remove unused variable 'status' in
 __packet_lookup_frame_in_block
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20190610115831.175710-1-maowenan@huawei.com>
 <CAF=yD-JOCZHt6q3ArCqY5PMW1vP5ZmNkYMKUB14TrgU-X30cSQ@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <caf8d25f-60e2-a0c0-dc21-956ea32ee59a@huawei.com>
Date:   Mon, 10 Jun 2019 22:02:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JOCZHt6q3ArCqY5PMW1vP5ZmNkYMKUB14TrgU-X30cSQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/10 21:05, Willem de Bruijn wrote:
> On Mon, Jun 10, 2019 at 8:17 AM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> The variable 'status' in  __packet_lookup_frame_in_block() is never used since
>> introduction in commit f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer
>> implementation."), we can remove it.
>> And when __packet_lookup_frame_in_block() calls prb_retire_current_block(),
>> it can pass macro TP_STATUS_KERNEL instead of 0.
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  net/packet/af_packet.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index a29d66d..fb1a79c 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -1003,7 +1003,6 @@ static void prb_fill_curr_block(char *curr,
>>  /* Assumes caller has the sk->rx_queue.lock */
>>  static void *__packet_lookup_frame_in_block(struct packet_sock *po,
>>                                             struct sk_buff *skb,
>> -                                               int status,
>>                                             unsigned int len
>>                                             )
>>  {
>> @@ -1046,7 +1045,7 @@ static void *__packet_lookup_frame_in_block(struct packet_sock *po,
>>         }
>>
>>         /* Ok, close the current block */
>> -       prb_retire_current_block(pkc, po, 0);
>> +       prb_retire_current_block(pkc, po, TP_STATUS_KERNEL);
> 
> I don't think that 0 is intended to mean TP_STATUS_KERNEL here.
> 
> prb_retire_current_block calls prb_close_block which sets status to
> 
>   TP_STATUS_USER | stat
> 
> where stat is 0 or TP_STATUS_BLK_TMO.


#define TP_STATUS_KERNEL		      0
#define TP_STATUS_BLK_TMO		(1 << 5)

Actually, packet_current_rx_frame calls __packet_lookup_frame_in_block with status=TP_STATUS_KERNEL
in original code.

__packet_lookup_frame_in_block in this function, first is to check whether the currently active block
has enough space for the packet, which means status of block should be TP_STATUS_KERNEL, then it calls
prb_retire_current_block to retire this block.

Since there needs some discussion about means of status, I can send v2 only removing the parameter status of
__packet_lookup_frame_in_block?

> 
> 

