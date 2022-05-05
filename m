Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E235251B546
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiEEBe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiEEBeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:34:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BB84BFC3;
        Wed,  4 May 2022 18:30:46 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ktx334ltpzhYnV;
        Thu,  5 May 2022 09:30:23 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 09:30:45 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 09:30:44 +0800
Subject: Re: [PATCH] net: dpaa2-mac: add missing of_node_put() in
 dpaa2_mac_get_node()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ioana.ciornei@nxp.com>, <davem@davemloft.net>,
        <robert-ionut.alexa@nxp.com>
References: <20220428100127.542399-1-yangyingliang@huawei.com>
 <20220429192950.5a1d23cc@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <61393ca9-618c-017b-c463-93d0afe33c12@huawei.com>
Date:   Thu, 5 May 2022 09:30:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220429192950.5a1d23cc@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/4/30 10:29, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 18:01:27 +0800 Yang Yingliang wrote:
>> Add missing of_node_put() in error path in dpaa2_mac_get_node().
>>
>> Fixes: 5b1e38c0792c ("dpaa2-mac: bail if the dpmacs fwnode is not found")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> index c48811d3bcd5..a91446685526 100644
>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> @@ -108,8 +108,11 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
>>   		return ERR_PTR(-EPROBE_DEFER);
>>   	}
>>   
>> -	if (!parent)
>> +	if (!parent) {
>> +		if (dpmacs)
>> +			of_node_put(dpmacs);
> of_node_put() accepts NULL. I know this because unlike you I did
> at least the bare minimum looking at the surrounding code and saw
> other places not checking if it's NULL.
I missed that, I will send a v2 later.

Thanks,
Yang
> .
