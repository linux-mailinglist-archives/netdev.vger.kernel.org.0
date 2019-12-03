Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA96E10F643
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 05:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLCEWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 23:22:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45506 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726592AbfLCEWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 23:22:24 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 23CC1F50919857FB931A;
        Tue,  3 Dec 2019 12:22:22 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Dec 2019
 12:22:11 +0800
Subject: Re: [PATCH net 2/3] net: hns3: fix a use after free problem in
 hns3_nic_maybe_stop_tx()
To:     David Miller <davem@davemloft.net>, <tanhuazhong@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
References: <1575342535-2981-1-git-send-email-tanhuazhong@huawei.com>
 <1575342535-2981-3-git-send-email-tanhuazhong@huawei.com>
 <20191202.192840.1366675580449158510.davem@davemloft.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <138d0858-7240-ff75-a38c-55e10eefc28d@huawei.com>
Date:   Tue, 3 Dec 2019 12:22:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191202.192840.1366675580449158510.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/3 11:28, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Tue, 3 Dec 2019 11:08:54 +0800
> 
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> Currently, hns3_nic_maybe_stop_tx() uses skb_copy() to linearize a
>> SKB if the BD num required by the SKB does not meet the hardware
>> limitation, and it linearizes the SKB by allocating a new SKB and
>> freeing the old SKB, if hns3_nic_maybe_stop_tx() returns -EBUSY,
>> the sch_direct_xmit() still hold reference to old SKB and try to
>> retransmit the old SKB when dev_hard_start_xmit() return TX_BUSY,
>> which may cause use after freed problem.
>>
>> This patch fixes it by using __skb_linearize() to linearize the
>> SKB in hns3_nic_maybe_stop_tx().
>>
>> Fixes: 51e8439f3496 ("net: hns3: add 8 BD limit for tx flow")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> That's not what I see.
> 
> You're freeing the SKB in the caller of hns3_nic_maybe_stop_tx()
> in the -ENOMEM case, not the generic qdisc code.
> 
> Standing practice is to always return NETIF_TX_OK in this case
> and just pretend the frame was sent.
> 
> Grep for __skb_linearize use throughout various drivers to see
> what I mean.  i40e is just one of several examples.

1. When skb_copy()/__skb_linearize()  returns failure, the
hns3_nic_maybe_stop_tx() does return -ENOMEM, and hns3_nic_net_xmit()
does free the skb before returning NETIF_TX_OK, which pretens the frame
was sent.

2. When skb_copy() returns success, the hns3_nic_maybe_stop_tx()
returns -EBUSY when there are not no enough space in the ring to
send the skb to hardware, and hns3_nic_net_xmit() will return
NETDEV_TX_BUSY to the upper layer, the upper layer will resend the old
skb later when driver wakes up the queue, but the old skb has been freed
by the hns3_nic_maybe_stop_tx(). Because when using the skb_copy() to
linearize a skb, it will return a new linearized skb, and the old skb is
freed, the upper layer does not have a reference to the new skb and resend
using the old skb, which casues a use after freed problem.

This patch is trying to fixes the case 2.

Maybe I should mention why hns3_nic_maybe_stop_tx() returns -EBUSY to
better describe the problem?


> 
> 
> .
> 

