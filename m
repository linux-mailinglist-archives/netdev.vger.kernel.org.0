Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A996127F9EA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgJAHHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:07:02 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:53385 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725918AbgJAHHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 03:07:02 -0400
Received: from [192.168.0.2] (ip5f5af404.dynamic.kabel-deutschland.de [95.90.244.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 852FF2064623C;
        Thu,  1 Oct 2020 09:06:59 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH] e1000: do not panic on malformed
 rx_desc
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Tong Zhang <ztong0001@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200908162231.4592-1-ztong0001@gmail.com>
 <bd917092-faf6-cfb9-2713-529368e655d8@molgen.mpg.de>
Message-ID: <c23cf934-071b-8f78-a639-8906e5d054df@molgen.mpg.de>
Date:   Thu, 1 Oct 2020 09:06:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <bd917092-faf6-cfb9-2713-529368e655d8@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Tong,


Am 01.10.20 um 09:03 schrieb Paul Menzel:

> Am 08.09.20 um 18:22 schrieb Tong Zhang:
>> length may be corrupted in rx_desc
> 
> How can that be?
> 
>> and lead to panic, so check the sanity before passing it to skb_put
>>
>> [  167.667701] skbuff: skb_over_panic: text:ffffffffb1e32cc1 len:60224 put:60224 head:ffff888055ac5000 data:ffff888055ac5040 tail:0xeb80 end:0x6c0 dev:eth0
>> [  167.668429] ------------[ cut here ]------------
>> [  167.668661] kernel BUG at net/core/skbuff.c:109!
>> [  167.668910] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
>> [  167.669220] CPU: 1 PID: 170 Comm: sd-resolve Tainted: G        W         5.8.0+ #1
>> [  167.670161] RIP: 0010:skb_panic+0xc4/0xc6
>> [  167.670363] Code: 89 f0 48 c7 c7 60 f2 de b2 55 48 8b 74 24 18 4d 89 f9 56 48 8b 54 24 18 4c 89 e6 52 48 8b 44 24 18 4c 89 ea 50 e8 31 c5 2a ff <0f> 0b 4c 8b 64 24 18 e8 f1 b4 48 ff 48 c7 c1 00 fc de b2 44 89 ee
>> [  167.671272] RSP: 0018:ffff88806d109c68 EFLAGS: 00010286
>> [  167.671527] RAX: 000000000000008c RBX: ffff888065e9af40 RCX: 0000000000000000
>> [  167.671878] RDX: 1ffff1100da24c91 RSI: 0000000000000008 RDI: ffffed100da21380
>> [  167.672227] RBP: ffff88806bde4000 R08: 000000000000008c R09: ffffed100da25cfb
>> [  167.672583] R10: ffff88806d12e7d7 R11: ffffed100da25cfa R12: ffffffffb2defc40
>> [  167.672931] R13: ffffffffb1e32cc1 R14: 000000000000eb40 R15: ffff888055ac5000
>> [  167.673286] FS:  00007fc5f5375700(0000) GS:ffff88806d100000(0000) knlGS:0000000000000000
>> [  167.673681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  167.673973] CR2: 0000000000cb3008 CR3: 0000000063d36000 CR4: 00000000000006e0
>> [  167.674330] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  167.674677] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [  167.675035] Call Trace:
>> [  167.675168]  <IRQ>
>> [  167.675315]  ? e1000_clean_rx_irq+0x311/0x630
>> [  167.687459]  skb_put.cold+0x1f/0x1f
>> [  167.687637]  e1000_clean_rx_irq+0x311/0x630
>> [  167.687852]  e1000e_poll+0x19a/0x4d0
>> [  167.688038]  ? e1000_watchdog_task+0x9d0/0x9d0
>> [  167.688262]  ? credit_entropy_bits.constprop.0+0x6f/0x1c0
>> [  167.688527]  net_rx_action+0x26e/0x650
> 
> On what device did you test this?
> 
>> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
>> ---
>>   drivers/net/ethernet/intel/e1000/e1000_main.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c 
>> b/drivers/net/ethernet/intel/e1000/e1000_main.c
>> index 1e6ec081fd9d..29e2ecb0358a 100644
>> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
>> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
>> @@ -4441,8 +4441,13 @@ static bool e1000_clean_rx_irq(struct 
>> e1000_adapter *adapter,
>>                */
>>               length -= 4;
>> -        if (buffer_info->rxbuf.data == NULL)
>> +        if (buffer_info->rxbuf.data == NULL)  {
>> +            /* check length sanity */

I’d remove the comment, and …

>> +            if (skb->tail + length > skb->end) {
> 
> It’d be great, if you could use the same order as in the assignment.
> 
>      length > skb->end - skb->tail
> 
>> +                length = skb->end - skb->tail;
>> +            }
>>               skb_put(skb, length);

print a warning/an error here, as this seems to be a hardware issue.

>> +        }
>>           else /* copybreak skb */
>>               skb_trim(skb, length);
> 
> According to the coding style, the keyword `else` has to be on the same 
> line as the `{`, and, the else branch also needs to be put in {}.


Kind regards,

Paul
