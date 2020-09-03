Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBB25C2AB
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgICOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:32:11 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:33768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729042AbgICO1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 10:27:46 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 4E10611E9B46AAA048E3;
        Thu,  3 Sep 2020 22:27:12 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 3 Sep 2020 22:27:11 +0800
Subject: Re: [PATCH net 3/3] hinic: fix bug of send pkts while setting
 channels
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200902094145.12216-1-luobin9@huawei.com>
 <20200902094145.12216-4-luobin9@huawei.com>
 <20200902.125257.1961904187228004830.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <4846879f-92ac-3726-58c8-beb719eee22e@huawei.com>
Date:   Thu, 3 Sep 2020 22:27:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200902.125257.1961904187228004830.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/3 3:52, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Wed, 2 Sep 2020 17:41:45 +0800
> 
>> @@ -531,6 +531,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>>  	struct hinic_txq *txq;
>>  	struct hinic_qp *qp;
>>  
>> +	if (unlikely(!netif_carrier_ok(netdev))) {
>> +		dev_kfree_skb_any(skb);
>> +		return NETDEV_TX_OK;
>> +	}
> 
> As Eric said, these kinds of tests should not be placed in the fast path
> of the driver.
> 
> If you invoke close and the core networking still sends packets to the
> driver, that's a bug that needs to be fixed in the core networking.
> .
> 
Okay, I'm trying to figure out why the core networking can still call ndo_start_xmit
after netif_tx_disable and solve the problem fundamentally. And I'll undo this patch
temporarily.
