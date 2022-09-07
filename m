Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952535AF941
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIGA51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIGA50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:57:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA0295E61;
        Tue,  6 Sep 2022 17:57:24 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MMkLJ3vn6znWMk;
        Wed,  7 Sep 2022 08:54:48 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 08:57:22 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 7 Sep
 2022 08:57:21 +0800
Subject: Re: [PATCH net-next 2/5] net: hns3: support ndo_select_queue()
To:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
 <20220905081539.62131-3-huangguangbin2@huawei.com>
 <8b2589bd6303133fd27cab1af27b096a5f848074.camel@redhat.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <855274c8-fa07-8405-61d6-390b7cd9853e@huawei.com>
Date:   Wed, 7 Sep 2022 08:57:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8b2589bd6303133fd27cab1af27b096a5f848074.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/6 21:15, Paolo Abeni wrote:
> On Mon, 2022-09-05 at 16:15 +0800, Guangbin Huang wrote:
>> To support tx packets to select queue according to its dscp field after
>> setting dscp and tc map relationship, this patch implements
>> ndo_select_queue() to set skb->priority according to the user's setting
>> dscp and priority map relationship.
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 46 +++++++++++++++++++
>>   1 file changed, 46 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index 481a300819ad..82f83e3f8162 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -2963,6 +2963,51 @@ static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
>>   	return h->ae_algo->ops->set_vf_mac(h, vf_id, mac);
>>   }
>>   
>> +#define HNS3_INVALID_DSCP		0xff
>> +#define HNS3_DSCP_SHIFT			2
>> +
>> +static u8 hns3_get_skb_dscp(struct sk_buff *skb)
>> +{
>> +	__be16 protocol = skb->protocol;
>> +	u8 dscp = HNS3_INVALID_DSCP;
>> +
>> +	if (protocol == htons(ETH_P_8021Q))
>> +		protocol = vlan_get_protocol(skb);
>> +
>> +	if (protocol == htons(ETH_P_IP))
>> +		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> HNS3_DSCP_SHIFT;
>> +	else if (protocol == htons(ETH_P_IPV6))
>> +		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> HNS3_DSCP_SHIFT;
>> +
>> +	return dscp;
>> +}
>> +
>> +static u16 hns3_nic_select_queue(struct net_device *netdev,
>> +				 struct sk_buff *skb,
>> +				 struct net_device *sb_dev)
>> +{
>> +	struct hnae3_handle *h = hns3_get_handle(netdev);
>> +	u8 dscp, priority;
>> +	int ret;
>> +
>> +	if (h->kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP ||
>> +	    !h->ae_algo->ops->get_dscp_prio)
>> +		goto out;
>> +
>> +	dscp = hns3_get_skb_dscp(skb);
>> +	if (unlikely(dscp == HNS3_INVALID_DSCP))
>> +		goto out;
>> +
>> +	ret = h->ae_algo->ops->get_dscp_prio(h, dscp, NULL, &priority);
> 
> This introduces an additional, unneeded indirect call in the fast path,
> you could consider replacing the above with a direct call to
> hclge_get_dscp_prio() - again taking care of the CONFIG_HNS3_DCB
> dependency.
> 
> Cheers,
> 
> Paolo
> 
> .
> 
Ok.
