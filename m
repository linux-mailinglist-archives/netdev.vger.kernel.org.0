Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAA225A2D2
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIBBmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 21:42:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgIBBmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 21:42:18 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9808AA0F37ABB56A2A8D;
        Wed,  2 Sep 2020 09:42:16 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Sep 2020 09:42:10 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
Date:   Wed, 2 Sep 2020 09:42:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/2 2:24, Cong Wang wrote:
> On Mon, Aug 31, 2020 at 5:59 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> Currently there is concurrent reset and enqueue operation for the
>> same lockless qdisc when there is no lock to synchronize the
>> q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
>> qdisc_deactivate() called by dev_deactivate_queue(), which may cause
>> out-of-bounds access for priv->ring[] in hns3 driver if user has
>> requested a smaller queue num when __dev_xmit_skb() still enqueue a
>> skb with a larger queue_mapping after the corresponding qdisc is
>> reset, and call hns3_nic_net_xmit() with that skb later.
> 
> Can you be more specific here? Which call path requests a smaller
> tx queue num? If you mean netif_set_real_num_tx_queues(), clearly
> we already have a synchronize_net() there.

When the netdevice is in active state, the synchronize_net() seems to
do the correct work, as below:

CPU 0:                                       CPU1:
__dev_queue_xmit()                       netif_set_real_num_tx_queues()
rcu_read_lock_bh();
netdev_core_pick_tx(dev, skb, sb_dev);
	.
	.				dev->real_num_tx_queues = txq;
	.					.
	.				    	.
        .                               synchronize_net();
	.					.
q->enqueue()					.
	.					.
rcu_read_unlock_bh()				.
					qdisc_reset_all_tx_gt


but dev->real_num_tx_queues is not RCU-protected, maybe that is a problem
too.

The problem we hit is as below:
In hns3_set_channels(), hns3_reset_notify(h, HNAE3_DOWN_CLIENT) is called
to deactive the netdevice when user requested a smaller queue num, and
txq->qdisc is already changed to noop_qdisc when calling
netif_set_real_num_tx_queues(), so the synchronize_net() in the function
netif_set_real_num_tx_queues() does not help here.

> 
>>
>> Avoid the above concurrent op by calling synchronize_rcu_tasks()
>> after assigning new qdisc to dev_queue->qdisc and before calling
>> qdisc_deactivate() to make sure skb with larger queue_mapping
>> enqueued to old qdisc will always be reset when qdisc_deactivate()
>> is called.
> 
> Like Eric said, it is not nice to call such a blocking function when
> we have a large number of TX queues. Possibly we just need to
> add a synchronize_net() as in netif_set_real_num_tx_queues(),
> if it is missing.

As above, the synchronize_net() in netif_set_real_num_tx_queues() seems
to work when netdevice is in active state, but does not work when in
deactive.

And we do not want skb left in the old qdisc when netdevice is deactived,
right?

As reply to Eric, maybe the existing synchronize_net() in dev_deactivate_many()
can be reused to order the qdisc assignment and qdisc reset?

> 
> Thanks.
> .
> 
