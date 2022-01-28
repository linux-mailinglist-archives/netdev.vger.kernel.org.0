Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CB449F4CB
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347015AbiA1IBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:01:42 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:35363 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242948AbiA1IBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:01:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643356894;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SXWQbdv7n9eGH3R2pXxo3em0xAzOLFXJc61MSR7OjVY=;
    b=lVOHvror/SLqs9qAyjew2OfSq1y++69MoFvZlXj/bGq4XqSkZo9xZigwgdNIV2sE65
    jHJVdbmmzgTu26I2w0MqTw6GUoLLEONv4OGr+5p3ND2Tg/P6th+RzNJnbhTHdf1u0kAL
    8NYeKKYGpnCFVbyD9IvllegDgx2mVCOR19iSMrLSEmg2ipb+wGeI3bsL7CBnZF+7l+xG
    4Fj7J7jhJ+S9uTYd2VHLoPrqwhF9hRjfjb4Bo2quRmesOg83AOPo1ohvMIyuvVa2sXsl
    VjUkLO4JuIN4WOdIZICpmiBze9KtiwQTC9T17p6VgnUSm2iqeT5ZtW9RY8KJ8aMgSD1D
    sucw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0S81YPx6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 09:01:34 +0100 (CET)
Message-ID: <476fedec-295c-cf14-2bfe-1d7369dcb0ef@hartkopp.net>
Date:   Fri, 28 Jan 2022 09:01:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC][PATCH v2] can: isotp: fix CAN frame reception race in
 isotp_rcv()
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        william.xuanziyang@huawei.com,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
References: <20220128074327.52229-1-socketcan@hartkopp.net>
 <20220128075632.ixy33y3cmbcmgh6f@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220128075632.ixy33y3cmbcmgh6f@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.01.22 08:56, Marc Kleine-Budde wrote:
> On 28.01.2022 08:43:27, Oliver Hartkopp wrote:
>> When receiving a CAN frame the current code logic does not consider
>> concurrently receiving processes which do not show up in real world
>> usage.
>>
>> Ziyang Xuan writes:
>>
>> The following syz problem is one of the scenarios. so->rx.len is
>> changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
>> 0 before alloc_skb() and equals 4096 after alloc_skb(). That will
>> trigger skb_over_panic() in skb_put().
>>
>> =======================================================
>> CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
>> RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
>> Call Trace:
>>   <TASK>
>>   skb_over_panic net/core/skbuff.c:118 [inline]
>>   skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
>>   isotp_rcv_cf net/can/isotp.c:570 [inline]
>>   isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
>>   deliver net/can/af_can.c:574 [inline]
>>   can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
>>   can_receive+0x31d/0x580 net/can/af_can.c:665
>>   can_rcv+0x120/0x1c0 net/can/af_can.c:696
>>   __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
>>   __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579
>>
>> Therefore we make sure the state changes and data structures stay
>> consistent at CAN frame reception time by adding a spin_lock in
>> isotp_rcv(). This fixes the issue reported by syzkaller but does not
>> affect real world operation.
>>
>> Link: https://lore.kernel.org/linux-can/d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com/T/
>> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
>> Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
>> Reported-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> ---
>>   net/can/isotp.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/net/can/isotp.c b/net/can/isotp.c
>> index 02cbcb2ecf0d..b5ba1a9a9e3b 100644
>> --- a/net/can/isotp.c
>> +++ b/net/can/isotp.c
>> @@ -54,10 +54,11 @@
>>    */
>>   
>>   #include <linux/module.h>
>>   #include <linux/init.h>
>>   #include <linux/interrupt.h>
>> +#include <linux/spinlock.h>
>>   #include <linux/hrtimer.h>
>>   #include <linux/wait.h>
>>   #include <linux/uio.h>
>>   #include <linux/net.h>
>>   #include <linux/netdevice.h>
>> @@ -143,10 +144,11 @@ struct isotp_sock {
>>   	u32 force_tx_stmin;
>>   	u32 force_rx_stmin;
>>   	struct tpcon rx, tx;
>>   	struct list_head notifier;
>>   	wait_queue_head_t wait;
>> +	spinlock_t rx_lock;
> 
> I think checkpatch wants to have a comment describing the lock.

Ok.
> 
>>   };
>>   
>>   static LIST_HEAD(isotp_notifier_list);
>>   static DEFINE_SPINLOCK(isotp_notifier_lock);
>>   static struct isotp_sock *isotp_busy_notifier;
>> @@ -613,10 +615,19 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
>>   	if (ae && cf->data[0] != so->opt.rx_ext_address)
>>   		return;
>>   
>>   	n_pci_type = cf->data[ae] & 0xF0;
>>   
>> +	/* Make sure the state changes and data structures stay consistent at
>> +	 * CAN frame reception time. This locking is not needed in real world
>> +	 * use cases but the inconsistency can be triggered with syzkaller.
>> +	 *
>> +	 * To not lock up the softirq just drop the frame in syzcaller case.
>> +	 */
>> +	if (!spin_trylock(&so->rx_lock))
>> +		return;
>> +
>>   	if (so->opt.flags & CAN_ISOTP_HALF_DUPLEX) {
>>   		/* check rx/tx path half duplex expectations */
>>   		if ((so->tx.state != ISOTP_IDLE && n_pci_type != N_PCI_FC) ||
>>   		    (so->rx.state != ISOTP_IDLE && n_pci_type == N_PCI_FC))
>>   			return;
>                          ^^^^^^
>                          goto out_unlock;
> 
> Maybe there are more returns, which are not shown in the context of this
> patch.
> 

Oh, yes! Thanks!

Will send a V3 soon.

>> @@ -666,10 +677,12 @@ static void isotp_rcv(struct sk_buff *skb, void *data)
>>   	case N_PCI_CF:
>>   		/* rx path: consecutive frame */
>>   		isotp_rcv_cf(sk, cf, ae, skb);
>>   		break;
>>   	}
>> +
> out_unlock:
>> +	spin_unlock(&so->rx_lock);
>>   }
>>   
>>   static void isotp_fill_dataframe(struct canfd_frame *cf, struct isotp_sock *so,
>>   				 int ae, int off)
>>   {
>> @@ -1442,10 +1455,11 @@ static int isotp_init(struct sock *sk)
>>   	so->rxtimer.function = isotp_rx_timer_handler;
>>   	hrtimer_init(&so->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
>>   	so->txtimer.function = isotp_tx_timer_handler;
>>   
>>   	init_waitqueue_head(&so->wait);
>> +	spin_lock_init(&so->rx_lock);
>>   
>>   	spin_lock(&isotp_notifier_lock);
>>   	list_add_tail(&so->notifier, &isotp_notifier_list);
>>   	spin_unlock(&isotp_notifier_lock);
> 
> regards,
> Marc
> 
