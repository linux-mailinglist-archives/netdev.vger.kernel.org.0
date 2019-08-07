Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB799841C7
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfHGBqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:46:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727653AbfHGBqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 21:46:11 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EF9C02DD744F68D04751;
        Wed,  7 Aug 2019 09:46:09 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Wed, 7 Aug 2019
 09:46:08 +0800
Subject: Re: [PATCH] bonding: Add vlan tx offload to hw_enc_features
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20190805134953.63596-1-yuehaibing@huawei.com>
 <4281.1565098884@nyx>
CC:     <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <402f6b7a-779d-06f3-e248-386c06a3d97c@huawei.com>
Date:   Wed, 7 Aug 2019 09:46:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <4281.1565098884@nyx>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/6 21:41, Jay Vosburgh wrote:
> YueHaibing <yuehaibing@huawei.com> wrote:
> 
>> As commit 30d8177e8ac7 ("bonding: Always enable vlan tx offload")
>> said, we should always enable bonding's vlan tx offload, pass the
>> vlan packets to the slave devices with vlan tci, let them to handle
>> vlan implementation.
>>
>> Now if encapsulation protocols like VXLAN is used, skb->encapsulation
>> may be set, then the packet is passed to vlan devicec which based on
> 
> 	Typo: "devicec"

oh, yes, thanks!

> 
>> bonding device. However in netif_skb_features(), the check of
>> hw_enc_features:
>>
>> 	 if (skb->encapsulation)
>>                 features &= dev->hw_enc_features;
>>
>> clears NETIF_F_HW_VLAN_CTAG_TX/NETIF_F_HW_VLAN_STAG_TX. This results
>> in same issue in commit 30d8177e8ac7 like this:
>>
>> vlan_dev_hard_start_xmit
>>  -->dev_queue_xmit
>>    -->validate_xmit_skb
>>      -->netif_skb_features //NETIF_F_HW_VLAN_CTAG_TX is cleared
>>      -->validate_xmit_vlan
>>        -->__vlan_hwaccel_push_inside //skb->tci is cleared
>> ...
>> --> bond_start_xmit
>>   --> bond_xmit_hash //BOND_XMIT_POLICY_ENCAP34
>>     --> __skb_flow_dissect // nhoff point to IP header
>>        -->  case htons(ETH_P_8021Q)
>>             // skb_vlan_tag_present is false, so
>>             vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
>>             //vlan point to ip header wrongly
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> 	Looks good to me; should this be tagged with
> 
> Fixes: 278339a42a1b ("bonding: propogate vlan_features to bonding master")
> 
> 	as 30d8177e8ac7 was?  If not, is there an appropriate commit id?

It seems the commit was:

Fixes: b2a103e6d0af ("bonding: convert to ndo_fix_features")

> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


Thanks, will send v2.

> 
> 	-J
> 
>> ---
>> drivers/net/bonding/bond_main.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 02fd782..931d9d9 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1126,6 +1126,8 @@ static void bond_compute_features(struct bonding *bond)
>> done:
>> 	bond_dev->vlan_features = vlan_features;
>> 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
>> +				    NETIF_F_HW_VLAN_CTAG_TX |
>> +				    NETIF_F_HW_VLAN_STAG_TX |
>> 				    NETIF_F_GSO_UDP_L4;
>> 	bond_dev->mpls_features = mpls_features;
>> 	bond_dev->gso_max_segs = gso_max_segs;
>> -- 
>> 2.7.4
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 
> .
> 

