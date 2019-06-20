Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819AF4CB7D
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbfFTKCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:02:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18644 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfFTKCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 06:02:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 201F6524BC4FF94BC2CB;
        Thu, 20 Jun 2019 18:02:39 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Jun 2019
 18:02:35 +0800
Subject: Re: [PATCH] flow_dissector: Fix vlan header offset in
 __skb_flow_dissect
To:     Stanislav Fomichev <sdf@fomichev.me>
References: <20190619160132.38416-1-yuehaibing@huawei.com>
 <20190619183938.GA19111@mini-arch>
CC:     <davem@davemloft.net>, <sdf@google.com>, <jianbol@mellanox.com>,
        <jiri@mellanox.com>, <mirq-linux@rere.qmqm.pl>,
        <willemb@google.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <00a5d09f-a23e-661f-60c0-75fba6227451@huawei.com>
Date:   Thu, 20 Jun 2019 18:02:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190619183938.GA19111@mini-arch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/6/20 2:39, Stanislav Fomichev wrote:
> On 06/20, YueHaibing wrote:
>> We build vlan on top of bonding interface, which vlan offload
>> is off, bond mode is 802.3ad (LACP) and xmit_hash_policy is
>> BOND_XMIT_POLICY_ENCAP34.
>>
>> __skb_flow_dissect() fails to get information from protocol headers
>> encapsulated within vlan, because 'nhoff' is points to IP header,
>> so bond hashing is based on layer 2 info, which fails to distribute
>> packets across slaves.
>>
>> Fixes: d5709f7ab776 ("flow_dissector: For stripped vlan, get vlan info from skb->vlan_tci")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/core/flow_dissector.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
>> index 415b95f..2a52abb 100644
>> --- a/net/core/flow_dissector.c
>> +++ b/net/core/flow_dissector.c
>> @@ -785,6 +785,9 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
>>  		    skb && skb_vlan_tag_present(skb)) {
>>  			proto = skb->protocol;
>>  		} else {
>> +			if (dissector_vlan == FLOW_DISSECTOR_KEY_MAX)
>> +				nhoff -=  sizeof(*vlan);
>> +
> Should we instead fix the place where the skb is allocated to properly
> pull vlan (skb_vlan_untag)? I'm not sure this particular place is
> supposed to work with an skb. Having an skb with nhoff pointing to
> IP header but missing skb_vlan_tag_present() when with
> proto==ETH_P_8021xx seems weird.

The skb is a forwarded vxlan packet, it send through vlan interface like this:

   vlan_dev_hard_start_xmit
    --> __vlan_hwaccel_put_tag //vlan_tci and VLAN_TAG_PRESENT is set
    --> dev_queue_xmit
        --> validate_xmit_skb
          --> validate_xmit_vlan // vlan_hw_offload_capable is false
             --> __vlan_hwaccel_push_inside //here skb_push vlan_hlen, then clear skb->tci

    --> bond_start_xmit
       --> bond_xmit_hash
         --> __skb_flow_dissect // nhoff point to IP header
            -->  case htons(ETH_P_8021Q)
            // skb_vlan_tag_present is false, so
              vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan), //vlan point to ip header wrongly

> 
>>  			vlan = __skb_header_pointer(skb, nhoff, sizeof(_vlan),
>>  						    data, hlen, &_vlan);
>>  			if (!vlan) {
>> -- 
>> 2.7.0
>>
>>
> 
> .
> 

